-- OUTLINE:
-- Low priority cons build either at their full speed or not at all.
-- The amount of res expense for high prio cons is calculated (as total expense - low prio cons expense) and the remainder is available to the low prio cons, if any.
-- We cycle through the low prio cons and allocate this expense until it runs out. All other low prio cons have their buildspeed set to 0.

-- ACTUALLY:
-- We only do the check every x frames (controlled by interval) and only allow low prio con(s) to act if doing so allows them to sustain their expense
--   until the next check, based on current expense allocations.
-- We allow the interval to be different for each team, because normally it would be wasteful to reconfigure every frame, but if a team has a high income and low
--   storage then not doing the check every frame would result in excessing resources that low prio builders could have used
-- We also pick one low prio con, per build target, and allow it a tiny build speed for 1 frame per interval, to prevent nanoframes that only have low prio cons
--   building them from decaying if a prolonged stall occurs.
-- We cache the buildspeeds of all low prio cons to prevent constant use of get/set callouts.

-- REASON:
-- AllowUnitBuildStep is damn expensive and is a serious perf hit if it is used for all this.

-- Done: Unify the usage of ruleName, to make it so that high prio = nil or false, low prio = assigned buildspeed

-- TODO: rewrite the whole goddamn thing as a multilevel queue!

--[[

Note to self, there are four outstanding issues with this approach:

    solars and makers cant be built by low-prio cons, would need a medium priority queue
    During round-robin iteration, units that were previously given resources do not free them.
    Still creates a non-zero amount of garbage by iterating over every stupid constructor
    Needs a proper multilevel queue implementation for this to make sense, with proper pop-back instructions, because there are factually 4 priority levels currently:

    High prio cons
    Low prio Cons building solars or makers
    low prio cons who are sole builders of a target
    low prio everyone else.

    Sets UnitUniformBuffers set for nanospray gl4


]]--




function gadget:GetInfo()
	return {
		name	  = 'Builder Priority', 	-- this once was named: Passive Builders v3
		desc	  = 'Builders marked as low priority only use resources after others builder have taken their share',
		author	= 'Beherith, Floris',
		date	  = '2023.12.28',
		license   = 'GNU GPL, v2 or later',
		layer	 = 0,
		enabled   = true
	}
end

local DEBUG = true -- will draw the buildSpeeds above builders. Perf heavy but its debugging only.
local VERBOSE = true -- will spam debug into infolog
local FORWARDUNIFORMS = false -- Needed for future nanospray GL4
-- Available Info to Widgets:
--Number is build speed number, and means low priority, otherwise nil means high
--Spring.GetUnitRulesParam(unitID, "builderPriorityLow")
local ruleName = "builderPriorityLow" -- So that non-nil means low prio, and the actual build speed number, nil means high

--TeamRulesParams
local totalBuildPowerRule = "totalBuildPower" -- total build power of a team
local highPrioBuildPowerRule = "highPrioBuildPower" -- The total buildpower of constructors set to high priority
local lowPrioBuildPowerRule = "lowPrioBuildPower"	-- The total buildpower of constructors set to low  priority 
local highPrioBuildPowerWantedRule = "highPrioBuildPowerWanted" -- The total buildpower of constructors set to high priority that are building things
local lowPrioBuildPowerWantedRule = "lowPrioBuildPowerWanted"  -- The total buildpower of constructors set to low priority that are building things
local highPrioBuildPowerUsedRule = "highPrioBuildPowerUsed" -- The total buildpower of constructors set to high priority that is actually spent on building stuff
local lowPrioBuildPowerUsedRule = "lowPrioBuildPowerUsed" -- The total buildpower of constructors set to low priority that is actually spent on building stuff



if not gadgetHandler:IsSyncedCode() then
	if DEBUG then 
		
		local canPassive = {} -- canPassive[unitDefID] = nil / true
		for unitDefID, unitDef in pairs(UnitDefs) do
			canPassive[unitDefID] = ((unitDef.canAssist and unitDef.buildSpeed > 0) or #unitDef.buildOptions > 0)
		end
		
		function gadget:DrawWorld()
			for i, unitID in pairs(Spring.GetAllUnits()) do 
				if Spring.IsUnitInView(unitID) and canPassive[Spring.GetUnitDefID(unitID)] then  
					local lowPriority = Spring.GetUnitRulesParam(unitID, ruleName)
				
					local x,y,z = Spring.GetUnitPosition(unitID)
					gl.PushMatrix()
					gl.Translate(x,y+64, z)
					
					gl.Text(((lowPriority and "L:"..tostring(lowPriority)) or "High"),0,0,16,'n')
					gl.PopMatrix()

				end
			end
			
		end
	end
	if FORWARDUNIFORMS then 
		local uniformCache = {0}
		local function BuildSpeedsChanged(cmdname, countx2, ...)
			local vararg = {...}
			for i= 1, countx2, 2 do 
				uniformCache[1] = vararg[i+1]
				gl.SetUnitBufferUniforms(vararg[i], uniformCache, 1)
				--Spring.Echo(vararg[i], vararg[i+1])
			end
			
		end
		
		function gadget:Initialize()
			gadgetHandler:AddSyncAction("BuildSpeedsChanged", BuildSpeedsChanged)
		end

		function gadget:Shutdown()
			gadgetHandler:RemoveSyncAction("BuildSpeedsChanged")
		end
	end

else

local CMD_PRIORITY = 34571

local stallMarginInc = 0.2 -- 
local stallMarginSto = 0.01

local buildPowerMinimum = 0.001 -- A small amount of buildpower we allocate to each build target owner to ensure that nanoframes dont vanish 

local passiveCons = {} -- passiveCons[teamID][builderID] = true for passive cons
local lastRoundTeamBuilders = {} -- {teamID = {builderID = 123}} -- last gameframe that we assigned resources, so we can take away the resources of previous recipients
local canBuild = {} --builders[teamID][builderID], contains all builders

local buildTargets = {} --{builtUnitID = builderUnitID} the unitIDs of build targets of passive builders, a -1 here indicates that this build target has Active builders too.

local maxBuildSpeed = {} -- {builderUnitID = buildSpeed} build speed of builderID, as in UnitDefs (contains all builders)
local currentBuildSpeed = {} -- {builderid = currentBuildSpeed} build speed of builderID for current interval, not accounting for buildTargets special speed (contains only passive builders)
local unitDefRelativeMetalBurden = {} -- relative metal burden (0..1) on economy when building the unit; 0 means its cost is basically all-energy (metal maker), 1 means all-metal (solar panel)

-- NOTE: Explanation: Instead of using an individual table to store {unitID = {metal, energy, buildtime}}
-- We are using using a single table, where: {
--      unitID = metal,
--      (unitID + energyOffset) = energy,
--      (unitID + buildTimeOffset) = buildtime,
--      (unitID + unitDefIDOffset) = unitDefID}
local costIDOverride = {}
local energyOffset = Game.maxUnits + 1
local buildTimeOffset = (Game.maxUnits + 1) * 2 
local unitDefIDOffset = (Game.maxUnits + 1) * 3
local nextK = 1

local resTable = {"metal","energy"} -- 1 = metal, 2 = energy

local cmdPassiveDesc = {
	  id	  = CMD_PRIORITY,
	  name	= 'priority',
	  action  = 'priority',
	  type	= CMDTYPE.ICON_MODE,
	  tooltip = 'Builder Mode: Low Priority restricts build when stalling on resources',
	  params  = {1, 'Low Prio', 'High Prio'}, -- cmdParams[1], where 0 == Low Prio, 1 == High prio
}

local spInsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
local spGetUnitCmdDescs = Spring.GetUnitCmdDescs
local spEditUnitCmdDesc = Spring.EditUnitCmdDesc
local spGetTeamResources = Spring.GetTeamResources
local spGetTeamList = Spring.GetTeamList
local spSetUnitRulesParam = Spring.SetUnitRulesParam
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spSetUnitBuildSpeed = Spring.SetUnitBuildSpeed
local spGetUnitIsBuilding = Spring.GetUnitIsBuilding
local spValidUnitID = Spring.ValidUnitID
local spGetTeamInfo = Spring.GetTeamInfo
local simSpeed = Game.gameSpeed
local LOS_ACCESS = {inlos = true}

local max = math.max
local floor = math.floor

local updateFrame = {}

local teamList
local deadTeamList = {}
local canPassive = {} -- canPassive[unitDefID] = nil / true

-- Uses a flattened table as per costIDOverride
local cost = {} -- cost = {unitDefID = metal, (unitDefID + energyOffset) = energy, (unitDefID+buildTimeOffset) = buildtime}, this is now keyed on integers for better cache
-- Is there any point in the approximate 100Kb of RAM savings? Probably no 

local unitBuildSpeed = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	if unitDef.buildSpeed > 0 then
		unitBuildSpeed[unitDefID] = unitDef.buildSpeed
	end
	-- build the list of which unitdef can have low prio mode
	canPassive[unitDefID] = ((unitDef.canAssist and unitDef.buildSpeed > 0) or #unitDef.buildOptions > 0)
	cost[unitDefID				  ] = unitDef.metalCost
	cost[unitDefID +	energyOffset] = unitDef.energyCost
	cost[unitDefID + buildTimeOffset] = unitDef.buildTime
end

local function updateTeamList()
	teamList = spGetTeamList()
	for _, teamID in ipairs(teamList) do
		passiveCons[teamID] = {} -- passiveCons[teamID][builderID] = true for passive cons
		lastRoundTeamBuilders[teamID] = {} -- {teamID = {builderID = true}} -- this is for taking away the resources of previous recipients
		canBuild[teamID] = {} --builders[teamID][builderID], contains all builders
		Spring.SetTeamRulesParam(teamID, totalBuildPowerRule, 0)
		Spring.SetTeamRulesParam(teamID, highPrioBuildPowerRule, 0)
		Spring.SetTeamRulesParam(teamID, lowPrioBuildPowerRule, 0)
		Spring.SetTeamRulesParam(teamID, highPrioBuildPowerUsedRule, 0)
		Spring.SetTeamRulesParam(teamID, lowPrioBuildPowerUsedRule, 0)

	end
end

-- For a given unitdef, calculate the relative metal burden of building it, taking into account any resources the unit
-- will produce or consume for a time after being built.

-- The returned value will be between 0 and 1.
-- 0 means the economic burden of building it is basically energy-only (e.g. a metal extractor or metal maker),
-- 1 means the economic burden of building it is basically metal-only (e.g. a basic solar collector),
-- with most units falling somewhere in between (around 0.1)

-- For example, a Cortex construction bot costs 120 metal, 1750 energy, and produces 7 E/s.
-- Assuming it stays alive for just 30 seconds, that's a net energy cost of 1750 - (7 * 30) = 1540.
-- The relative metal burden is 120 / (120 + 1540) = 0.072.
local function CalculateRelativeMetalBurden(unitDef)

	-- Some units produce (or require) resources. How many seconds of production/use should we factor into the burden of this unit?
	local productionTime = 30 -- seconds
	local metalCost = unitDef.metalCost
	local energyCost = unitDef.energyCost
	local metalMake = 0
	local energyMake = unitDef.energyMake - unitDef.energyUpkeep

	local avgTide = Spring.GetTidal()
	local avgMexStrength = 2 -- assume 2.0 metal spots
	local avgWindSpeed = math.max((Game.windMin or 0), (Game.windMax or 0) * .75) --fallback approximation from gui_top_bar.lua

	if unitDef.windGenerator > 0 then
		energyMake = math.min(avgWindSpeed, unitDef.windGenerator)
	elseif unitDef.tidalGenerator > 0 then
		energyMake = avgTide * unitDef.tidalGenerator
	elseif unitDef.customParams then
		if unitDef.customParams.metal_extractor then
			local mex = tonumber(unitDef.customParams.metal_extractor)
			if mex > 0 then
				metalMake = mex * avgMexStrength
			end
		elseif unitDef.customParams.energyconv_capacity then
			energyMake = -tonumber(unitDef.customParams.energyconv_capacity)
			metalMake = -energyMake * tonumber(unitDef.customParams.energyconv_efficiency)
		end
	end

	local metalBurden = math.max(0, metalCost - metalMake * productionTime) -- 0 or greater
	local energyBurden = math.max(0, energyCost - energyMake * productionTime) -- 0 or greater
	local relativeMetalBurden = metalBurden / math.max(1, metalBurden + energyBurden) -- 0..1
	--[[
	Spring.Echo("unit " .. tostring(unitDef.name) .. " has M/E cost " .. tostring(metalCost) .. ", " .. tostring(energyCost)
		.. ", M/E production " .. tostring(metalMake) .. ", " .. tostring(energyMake)
		.." M/E burden " .. tostring(metalBurden) .. ", " .. tostring(energyBurden)
		.. " relative M burden " .. tostring(relativeMetalBurden))
	]]
	return relativeMetalBurden
end

function gadget:Initialize()
	updateTeamList()
	for _,unitID in pairs(Spring.GetAllUnits()) do
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID), Spring.GetUnitTeam(unitID))
	end
	for unitDefID, unitDef in pairs(UnitDefs) do
		unitDefRelativeMetalBurden[unitDefID] = CalculateRelativeMetalBurden(unitDef)
	end
end

local nCBS = 0
local changedBuildSpeeds = {}

local function MaybeSetWantedBuildSpeed(builderID, wantedSpeed, force)
	if (currentBuildSpeed[builderID] ~= wantedSpeed) or force then
		spSetUnitBuildSpeed(builderID, wantedSpeed) -- 100 ns per call
		spSetUnitRulesParam(builderID, ruleName, wantedSpeed)  -- 300 ns per call
		currentBuildSpeed[builderID] = wantedSpeed
		if FORWARDUNIFORMS then 
			changedBuildSpeeds[nCBS + 1] = builderID
			changedBuildSpeeds[nCBS + 2] = wantedSpeed
			nCBS = nCBS + 2
		end
	end
end

local function SetBuilderPriority(builderID, lowPriority)
	if lowPriority then  -- low prio immediately sets it to 0 buildspeed
		MaybeSetWantedBuildSpeed(builderID, 0, true)
	else -- set to high
		-- clear all our passive status
		spSetUnitBuildSpeed(builderID, maxBuildSpeed[builderID]) 
		spSetUnitRulesParam(builderID, ruleName, nil) 
		currentBuildSpeed[builderID] = maxBuildSpeed[builderID]
		
		if FORWARDUNIFORMS then 
			changedBuildSpeeds[nCBS + 1] = builderID
			changedBuildSpeeds[nCBS + 2] = maxBuildSpeed[builderID]
			nCBS = nCBS + 2
		end
	end
end

local function BuildSpeedsChanged()
	if nCBS > 0 then 
		-- Note: we are pretty much pushing an entire unpacked table onto sendtounsynced
		-- the max amound of stuff we can send here is like <8000 elements. 
		-- todo: actually check that we dont send more, and if we do, then split it into multiple calls.
		SendToUnsynced("BuildSpeedsChanged", nCBS, unpack(changedBuildSpeeds))
		changedBuildSpeeds = {}
		nCBS = 0
	end
end


local function UDN(unitID)
	return UnitDefs[Spring.GetUnitDefID(unitID)].name
end


function gadget:UnitCreated(unitID, unitDefID, teamID)
	if unitBuildSpeed[unitDefID] then
		canBuild[teamID][unitID] = true
		maxBuildSpeed[unitID] = unitBuildSpeed[unitDefID]
	end
	if canPassive[unitDefID] then
		spInsertUnitCmdDesc(unitID, cmdPassiveDesc)
		local lowPriority = spGetUnitRulesParam(unitID, ruleName) or nil -- non-nil rule means passive
		passiveCons[teamID][unitID] = lowPriority
		SetBuilderPriority(unitID, lowPriority)

		if VERBOSE then 
			Spring.Echo(string.format("UnitID %i of def %s has been set to %s = %s",
					unitID, UnitDefs[unitDefID].name, ruleName, tostring(passiveCons[teamID][unitID])))
		end
	end

	costIDOverride[unitID +			   0] = cost[unitDefID]
	costIDOverride[unitID +	energyOffset] = cost[unitDefID + energyOffset]
	costIDOverride[unitID + buildTimeOffset] = cost[unitDefID + buildTimeOffset]
	costIDOverride[unitID + unitDefIDOffset] = unitDefID
end

function gadget:UnitGiven(unitID, unitDefID, newTeamID, oldTeamID)
	gadget:UnitDestroyed(unitID, unitDefID, oldTeamID)
	gadget:UnitCreated(unitID, unitDefID, newTeamID)
end

function gadget:UnitTaken(unitID, unitDefID, oldTeamID, newTeamID)
	gadget:UnitGiven(unitID, unitDefID, newTeamID, oldTeamID)
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	-- Clear Team stuff
	canBuild[teamID][unitID] = nil
	lastRoundTeamBuilders[teamID][unitID] = nil
	passiveCons[teamID][unitID] = nil
	
	-- clear unit data
	maxBuildSpeed[unitID] = nil
	currentBuildSpeed[unitID] = nil

	costIDOverride[unitID +			   0] = nil
	costIDOverride[unitID +	energyOffset] = nil
	costIDOverride[unitID + buildTimeOffset] = nil
	costIDOverride[unitID + unitDefIDOffset] = nil
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
	-- as its no longer being built, clear cache of its costs
	costIDOverride[unitID +			   0] = nil
	costIDOverride[unitID +	energyOffset] = nil
	costIDOverride[unitID + buildTimeOffset] = nil
	costIDOverride[unitID + unitDefIDOffset] = nil
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions, cmdTag, playerID, fromSynced, fromLua)
	-- track which cons are set to passive
	if cmdID == CMD_PRIORITY and canPassive[unitDefID] then
		local cmdIdx = spFindUnitCmdDesc(unitID, CMD_PRIORITY)
		if cmdIdx then
			local cmdDesc = spGetUnitCmdDescs(unitID, cmdIdx, cmdIdx)[1]
			cmdDesc.params[1] = cmdParams[1] -- cmdParams[1] where 0 == Low Prio, 1 == High prio
			spEditUnitCmdDesc(unitID, cmdIdx, cmdDesc)
			local lowPriority = (cmdParams[1] == 0)
			
			SetBuilderPriority(unitID, lowPriority)
			passiveCons[teamID][unitID] = lowPriority or nil
			lastRoundTeamBuilders[teamID][unitID] = nil -- this is to ensure that mid-update changes carry over

			if VERBOSE then 
				Spring.Echo(string.format("UnitID %i of def %s has been set to %s = %s (%s)",
						unitID, UnitDefs[unitDefID].name, ruleName, tostring(passiveCons[teamID][unitID]), tostring(cmdParams[1])))
			end
		end
		return false -- Allowing command causes command queue to be lost if command is unshifted
	end
	return true
end

local function sortMetalBurdensAndGetInitialPointers(lowPrioBuilderMetalBurdens, resourcesLeftMetalBurden)
	-- Sort the lowPrioBuilderMetalBurdens table.
	local function compareBuilderMetalBurdens(a, b)
		-- a[1] is metal burden, a[2] is builder unit ID
		if a[1] == b[1] then
			return a[2] < b[2]
		end
		return a[1] < b[1]
	end
	table.sort(lowPrioBuilderMetalBurdens, compareBuilderMetalBurdens)

	-- TODO: We already have the initial burden, so we get to choose the secondary sort.
	-- Consider whether a secondary sort based on total buildpower of the builder might require fewer total buildpower changes.

	-- Now that passive builders have been sorted by their builds' metal burdens, find the two builders (adjacent
	-- in the array) whose metal burden most closely matches the metal burden we can support.
	-- Call these b0 and b1.
	-- 		1. See which of lowPrioBuilderMetalBurdens[b0] and [b1] has a metal burden _closer_ to resourcesLeftMetalBurden.
	-- 		   (If tied, choose arbitrarily.)
	-- 		2. Give the chosen builder as many resources as we can.
	-- 		3. If we chose b0, decrement b0. If we chose b1, increment b1.
	-- 		4. If we have resources left, recalculate resourcesLeftMetalBurden and repeat from step 1
	-- 		   (excluding either of b0 or b1 that's fallen off the end of the array).
	-- This should produce relatively stable buildspeeds while avoiding two problems:
	-- 		a. energy being wasted due to a metal stall, or vice-versa
	-- 		b. large amounts of structures being half-built when we'd be better off with some fully-built and some still near 0%

	-- Binary search to find the b0 and b1 whose build metal burdens are closest to resourcesLeftMetalBurden
	local n = #lowPrioBuilderMetalBurdens
	local b0 = 1
	local b1 = math.max(b0 + 1, n) -- if n<=1, make b1 out-of-bounds
	while b0 + 1 < b1 do -- run until b0 and b1 are adjacent
		local bt = math.floor((b0 + b1) / 2)
		if lowPrioBuilderMetalBurdens[bt][1] < resourcesLeftMetalBurden then
			b0 = bt -- move b0 to the right
		else
			b1 = bt -- move b1 to the left
		end
	end
	if DEBUG and n > 0 then
		for i, v in ipairs(lowPrioBuilderMetalBurdens) do
			Spring.Echo("lowPrioBuilderMetalBurdens[" .. tostring(i) .. "] = " .. v[1] .. ", " .. v[2])
		end
	end

	return b0, b1, n
end

local function getNextBestBuilderByMetalBurden(lowPrioBuilderMetalBurdens, resourcesLeftMetalBurden, b0, b1, n)
	local bClosest = -1 -- invalid by default
	--if DEBUG then Spring.Echo("resourcesLeftMetalBurden b0=" .. tostring(b0) .. ", b1=" .. tostring(b1) .. ", n=" .. tostring(n)) end

	if n >= 1 and (b0 >= 1 or b1 <= n) then
		-- at least one of b0 and b1 are in-bounds
		if b1 > n or (b0 >= 1 and math.abs(lowPrioBuilderMetalBurdens[b0][1] - resourcesLeftMetalBurden) < math.abs(lowPrioBuilderMetalBurdens[b1][1] - resourcesLeftMetalBurden)) then
			-- if b1 is out-of-bounds, or if b0 is in-bounds and closer to b1, then choose b0
			bClosest = b0
			b0 = b0 - 1
		else
			bClosest = b1
			b1 = b1 + 1
		end
	end

	--if DEBUG then Spring.Echo("remaining burden " .. tostring(resourcesLeftMetalBurden) .. ", closest is " .. bClosest) end
	return b0, b1, bClosest
end

local function UpdatePassiveBuilders(teamID, interval, gameFrame)

	-- calculate how much expense each passive con would require, and how much total expense the non-passive cons require
	local nonPassiveConsTotalExpenseEnergy = 0
	local nonPassiveConsTotalExpenseMetal = 0

	local passiveConsTotalExpenseEnergy = 0
	local passiveConsTotalExpenseMetal = 0

	local passiveConsTeam = passiveCons[teamID]
	if tracy then tracy.ZoneBeginN("UpdateStart") end 
	local numPassiveCons = 0

	local passiveExpense = {} -- once again, similar to the costIDOverride we are using a single table with offsets to store two values per unitID
	local totalBuildPower = 0
	local highPrioBuildPower = 0
	local lowPrioBuildPower = 0
	local highPrioBuildPowerWanted = 0
	local lowPrioBuildPowerWanted = 0
	local highPrioBuildPowerUsed = 0
	local lowPrioBuildPowerUsed = 0

	
	local lowPrioBuilderMetalBurdens = {} -- builderID to metal burden (0..1) of their build target
	local passiveBuilderIDs = {}
	-- this is about 800 us
	if canBuild[teamID] then
		local canBuildTeam = canBuild[teamID]
		for builderID in pairs(canBuildTeam) do
			local builtUnit = spGetUnitIsBuilding(builderID)
			local expenseMetal = builtUnit and costIDOverride[builtUnit] or nil
			local maxbuildspeed = maxBuildSpeed[builderID]
			totalBuildPower = totalBuildPower + maxbuildspeed
			local isPassive = passiveConsTeam[builderID]
			if isPassive then 
				lowPrioBuildPower = lowPrioBuildPower + maxbuildspeed
			else
				highPrioBuildPower = highPrioBuildPower + maxbuildspeed
			end
			
			if builtUnit and expenseMetal and maxbuildspeed then	-- added check for maxBuildSpeed[builderID] else line below could error (unsure why), probably units that were newly created?

				local expenseEnergy = costIDOverride[builtUnit + energyOffset]
				local rate = maxbuildspeed / costIDOverride[builtUnit + buildTimeOffset]

				-- At full buildpower, how much would this builder spend per second?
				expenseMetal = expenseMetal * rate
				expenseEnergy = expenseEnergy * rate

				if isPassive then 
					table.insert(passiveBuilderIDs, builderID)
					passiveExpense[builderID] = expenseMetal
					passiveExpense[builderID + energyOffset] = expenseEnergy
					numPassiveCons = numPassiveCons + 1
					passiveConsTotalExpenseEnergy = passiveConsTotalExpenseEnergy + expenseEnergy
					passiveConsTotalExpenseMetal  = passiveConsTotalExpenseMetal  + expenseMetal

					-- take ownership of this build if it has no builder attached _or_ if our builder ID is lower
					local buildOwner = buildTargets[builtUnit]
					if (not buildOwner) or builderID < buildOwner then
						buildTargets[builtUnit] = builderID
					end

					local builtUnitDefID = costIDOverride[builtUnit + unitDefIDOffset]
					table.insert(lowPrioBuilderMetalBurdens, { unitDefRelativeMetalBurden[builtUnitDefID], builderID, builtUnit })

					lowPrioBuildPowerWanted = lowPrioBuildPowerWanted + maxbuildspeed
					
				else
					buildTargets[builtUnit] = -1 -- mark this unit as having a high-priority builder working on it
					highPrioBuildPowerWanted = highPrioBuildPowerWanted + maxbuildspeed
					nonPassiveConsTotalExpenseEnergy = nonPassiveConsTotalExpenseEnergy + expenseEnergy
					nonPassiveConsTotalExpenseMetal  = nonPassiveConsTotalExpenseMetal  + expenseMetal
				end
				
			end
			
			
		end
	end

	local intervalpersimspeed = interval/simSpeed
	if tracy then tracy.ZoneEnd() end 
	
	-- calculate how much expense passive cons will be allowed, this can be negative
	local passiveEnergyLeft, passiveMetalLeft

	for _,resName in pairs(resTable) do
		local currentLevel, storage, pull, income, expense, share, sent, received = spGetTeamResources(teamID, resName)
		storage = storage * share -- consider capacity only up to the share slider
		local reservedExpense = (resName == 'energy' and nonPassiveConsTotalExpenseEnergy or nonPassiveConsTotalExpenseMetal) -- we don't want to touch this part of expense
		if resName == 'energy' then
			Spring.Echo(string.format("energy %.2f - max(%.2f * %.2f, %.2f * %.2f) - 1 + (%.2f - %.2f + %.2f - %.2f) * %.2f",
				currentLevel, income, stallMarginInc, storage, stallMarginSto,
				income, reservedExpense, received, sent, intervalpersimspeed))
			passiveEnergyLeft = currentLevel - max(income * stallMarginInc, storage * stallMarginSto) - 1 + (income - reservedExpense + received - sent) * intervalpersimspeed --amount of res available to assign to passive builders (in next interval); leave a tiny bit left over to avoid engines own "stall mode"
		else
			passiveMetalLeft =  currentLevel - max(income * stallMarginInc, storage * stallMarginSto) - 1 + (income - reservedExpense + received - sent) * intervalpersimspeed --amount of res available to assign to passive builders (in next interval); leave a tiny bit left over to avoid engines own "stall mode"
		end
	end
	
	local passiveMetalStart = passiveMetalLeft
	local passiveEnergyStart = passiveEnergyLeft
	
	local havePassiveResourcesLeft = (passiveEnergyLeft > 0) and (passiveMetalLeft > 0 )

	--[[
		Determine how many passive resources we will use over the next interval _if_ passive builders are left alone.
			(1) figure out each builder's metal and energy needs _per frame_ if they were allowed max BP
			    (see passiveExpense[builderID] for metal and passiveExpense[builderID + energyOffset] for energy)
			(2) figure out an INDIVIDUAL weight (0 or greater) for each builder (default: 1, or use econ-support, or use inverse of BP)
					local builderWeights[i] -- ensure no negative values]]--

	Spring.Echo("")
	Spring.Echo("calculating builder weights")
	local builderWeights = {}
	for i, builderID in ipairs(passiveBuilderIDs) do
		builderWeights[builderID] = 1 -- TODO
		--Spring.Echo(string.format("  builder %d weight: %.2f", builderID, builderWeights[builderID]))
	end

	-- (3) normalize INDIVIDUAL weights (0..1)
	local maxWeight = 0
	for k, v in pairs(builderWeights) do
		maxWeight = math.max(maxWeight, v)
	end

	if maxWeight > 1 then
		for k, v in pairs(builderWeights) do
			builderWeights[k] = math.max(0, v / maxWeight)
			Spring.Echo(string.format("  builder %d weight normalized to %.2f", k, builderWeights[k]))
		end
	end

	--(4) figure out a GLOBAL weight that can be multiplied by INDIVIDUAL rates such that all builders would, together, precisely consume available passive resources,
	--    keeping in mind that individualWeight * globalWeight for each builder will be capped at 1.
	local globalWeight = 1
	local totalWeightedMetalWanted = 0
	local totalWeightedEnergyWanted = 0
	local builderIDs = {}
	Spring.Echo("creating builderIDs table")
	for builderID, builderWeight in pairs(builderWeights) do
		totalWeightedMetalWanted = totalWeightedMetalWanted + passiveExpense[builderID] * builderWeight * intervalpersimspeed
		totalWeightedEnergyWanted = totalWeightedEnergyWanted + passiveExpense[builderID + energyOffset] * builderWeight * intervalpersimspeed
		Spring.Echo(string.format("  adding %d", builderID))
		table.insert(builderIDs, builderID)
	end

	Spring.Echo(string.format("checking %.2f < %.2f or %.2f < %.2f", passiveMetalLeft, totalWeightedMetalWanted, passiveEnergyLeft, totalWeightedEnergyWanted))
	if passiveMetalLeft - 1 < totalWeightedMetalWanted * globalWeight or passiveEnergyLeft - 1 < totalWeightedEnergyWanted * globalWeight then
		-- REDUCE global weight if we don't have enough resources
		globalWeight = math.max(0, math.min((passiveMetalLeft - 1) / totalWeightedMetalWanted, (passiveEnergyLeft - 1) / totalWeightedEnergyWanted))
		Spring.Echo(string.format("reducing global weight to %.2f", globalWeight))
	else
		Spring.Echo("we'll have leftover resources, but we aren't increasing global weight")
		-- INCREASE global weight if we have leftover resources, keeping in mind that individualWeight * globalWeight for each builder will be capped at 1.
		--[[ TODO: not needed until builder weights can exceed 1
		local sortedBuilders -- builders sorted by local weight
		local pretendMetalLeft = passiveMetalLeft
		local pretendEnergyLeft = passiveEnergyLeft
		for i in 1..n do
			if builderWeights[i] > 0 then
				local pretendMetalWanted = builderWeightedWantedMetalForThisAndSubsequentBuilders[i] * globalWeight
				local pretendEnergyWanted = builderWeightedWantedEnergyForThisAndSubsequentBuilders[i] * globalWeight
				globalWeight = globalWeight * min(passiveMetalLeft / pretendMetalWanted, passiveEnergyLeft / pretendEnergyWanted, 1 / builderWeights[i])
				pretendMetalLeft = pretendMetalLeft - builderMetalWanted[i] * builderWeights[i] * globalWeight
				pretendEnergyLeft = pretendEnergyLeft - builderEnergyWanted[i] * builderWeights[i] * globalWeight
			end
		end
		]]--
	end

	-- (5) set the next K builders' buildpower

	local n = #builderIDs
	local toUpdate = math.min(2, n)
	Spring.Echo(string.format("will update BP for %d builders", toUpdate))
	for j = 1, toUpdate do
		local i = (j + nextK) % n -- 0..n-1
		local builderID = builderIDs[i + 1]
		Spring.Echo(string.format("  updating BP for j=%d, nextK=%d, n=%d, i=%d, builderID=%d", j, nextK, n, i, builderID))
		local newSpeed = math.floor(maxBuildSpeed[builderID] * math.min(1, builderWeights[builderID] * globalWeight))
		MaybeSetWantedBuildSpeed(builderID, newSpeed) -- product of weights can't exceed 1
		Spring.Echo(string.format("  ... to %.2f of %.2f", newSpeed, maxBuildSpeed[builderID]))

		-- If our build target has a low-priority owner that isn't us, take ownership of it here,
		-- so that we can skip the buildPowerMinimum workaround to any other builder on the same job.
		if newSpeed > 0 and buildTargets[builtUnitID] and (buildTargets[builtUnitID] > 0) then -- has a passive builder attached
			buildTargets[builtUnitID] = builderID
		end
	end
	nextK = nextK + toUpdate

	-- (6) Figure out if we're going to use too many resources over the next interval -- this handles sharp drops in resources.
	--     Sharp increases in resources don't need special-casing, as we should get all builders up to full buildpower soon enough.
	local projectedMetalUsed = 0
	local projectedEnergyUsed = 0
	for i, builderID in ipairs(builderIDs) do
		projectedMetalUsed = projectedMetalUsed + passiveExpense[builderID] * (currentBuildSpeed[builderID] / maxBuildSpeed[builderID]) * intervalpersimspeed
		projectedEnergyUsed = projectedEnergyUsed + passiveExpense[builderID + energyOffset] * (currentBuildSpeed[builderID] / maxBuildSpeed[builderID]) * intervalpersimspeed
	end

	-- (7) if we're going to use too many resources, remove some from builders, starting with the builder with the least-recent
	--     BP update (whose BP is due to be updated soon anyway), until our resource use is expected to be within limits again:
	local i = 0
	while i < n and (projectedMetalUsed > passiveMetalLeft or projectedEnergyUsed > passiveEnergyLeft) do
		Spring.Echo(string.format("looking for builder ID using nextK=%d, i=%d, n=%d, result=%d", nextK, i, n, ((nextK + i) % n)))
		local builderID = builderIDs[((nextK + i) % n) + 1]
		Spring.Echo(string.format("would use too many resources (%.2f of %.2f metal, %.2f of %.2f energy), removing resources from %d", projectedMetalUsed, passiveMetalLeft, projectedEnergyUsed, passiveEnergyLeft, builderID))
		projectedMetalUsed = projectedMetalUsed - passiveExpense[builderID] * (currentBuildSpeed[builderID] / maxBuildSpeed[builderID]) * intervalpersimspeed
		projectedEnergyUsed = projectedEnergyUsed - passiveExpense[builderID + energyOffset] * (currentBuildSpeed[builderID] / maxBuildSpeed[builderID]) * intervalpersimspeed
		MaybeSetWantedBuildSpeed(builderID, 0)
		i = i + 1
	end
	
	if havePassiveResourcesLeft then
		highPrioBuildPowerUsed = highPrioBuildPowerWanted
	else
		-- make a very wild guess:
		-- a fraction of 1 is used if passiveMetalLeft == 0
		-- if passiveMetalLeft = -1 * nonPassiveConsTotalExpenseMetal then its 0.5
		nonPassiveConsTotalExpenseMetal = math.max(nonPassiveConsTotalExpenseMetal, 1)
		nonPassiveConsTotalExpenseEnergy = math.max(nonPassiveConsTotalExpenseEnergy, 1)
		local highPrioMetalSpend = (nonPassiveConsTotalExpenseMetal - math.min(0,passiveMetalLeft)) /nonPassiveConsTotalExpenseMetal
		local highPrioEnergySpend = (nonPassiveConsTotalExpenseEnergy - math.min(0,passiveEnergyLeft)) /nonPassiveConsTotalExpenseMetal
		
		highPrioBuildPowerUsed = highPrioBuildPowerWanted * math.min(highPrioMetalSpend, highPrioEnergySpend)
	end
	
	havePassiveResourcesLeft = (passiveEnergyLeft > 0) and (passiveMetalLeft > 0 )

	-- override buildTarget builders build speeds for a single frame; let them build at a tiny rate to prevent nanoframes from possibly decaying (yes this is confirmed to happen)
	-- dont remove the resources given to a builder just because they are build target owners
	-- and take them off the buildTargets queue!
	for buildTargetID, builderUnitID in pairs(buildTargets) do 
		-- builderUnitID < 0 means there's an active builder working on this unit, no need to do anything
		if builderUnitID > 0 then
			-- if owner is passive, then give it a bit of BP
			-- This ensures that we at least build each unit a tiny bit.
			if currentBuildSpeed[builderUnitID] < buildPowerMinimum then
				-- This builderUnitID has been assigned as passive with no resources, so give it a little bit
				MaybeSetWantedBuildSpeed(builderUnitID, buildPowerMinimum)
			else
				-- this builderUnitID has been assigned greater than 0 resources, so remove it from the next frame's clear pass
				buildTargets[buildTargetID] = nil
			end
		end
	end 
	
	
	Spring.SetTeamRulesParam(teamID, totalBuildPowerRule, totalBuildPower)
	Spring.SetTeamRulesParam(teamID, highPrioBuildPowerRule, highPrioBuildPower)
	Spring.SetTeamRulesParam(teamID, lowPrioBuildPowerRule, lowPrioBuildPower)
	Spring.SetTeamRulesParam(teamID, highPrioBuildPowerWantedRule, highPrioBuildPowerWanted)
	Spring.SetTeamRulesParam(teamID, lowPrioBuildPowerWantedRule, lowPrioBuildPowerWanted)
	Spring.SetTeamRulesParam(teamID, highPrioBuildPowerUsedRule, highPrioBuildPowerUsed)
	Spring.SetTeamRulesParam(teamID, lowPrioBuildPowerUsedRule, lowPrioBuildPowerUsed)
	
	if VERBOSE then 
		Spring.Echo(string.format("%d Pstart = %.1f/%.0f Pleft = %.1f/%.0f #passive=%d Stalled=%d",
			Spring.GetGameFrame(),
			passiveMetalStart, passiveEnergyStart,
			passiveMetalLeft, passiveEnergyLeft,
			numPassiveCons,
			havePassiveResourcesLeft and 0 or 1
			)
		)
	end
end

local function GetUpdateInterval(teamID)
	local maxInterval = 6
	for _,resName in pairs(resTable) do
		local _, stor, _, inc = spGetTeamResources(teamID, resName)
		local resMaxInterval
		if inc > 0 then
			local resMaxInterval = floor(stor*simSpeed/inc)+1 -- (1 or greater) how many frames would it take to fill our current storage based on current income?

			-- Update more frequently if we're in danger of overflowing this resource
			if resMaxInterval < maxInterval then
				maxInterval = resMaxInterval
			end
		end
	end
	--Spring.Echo("interval: "..maxInterval)
	return maxInterval
end

function gadget:TeamDied(teamID)
	deadTeamList[teamID] = true
end

function gadget:TeamChanged(teamID)
	updateTeamList()
end

function gadget:GameFrame(n)
	-- During the previous UpdatePassiveBuilders, we set build target owners to buildPowerMinimum so that the nanoframes dont die
	-- Now we can set their buildpower to what we wanted instead of buildPowerMinimum we had for 1 frame.
	for builtUnit, builderID in pairs(buildTargets) do
		if spValidUnitID(builderID) and spGetUnitIsBuilding(builderID) == builtUnit then
			MaybeSetWantedBuildSpeed(builderID, 0)
		end
	end
	
	buildTargets = (next(buildTargets) and {}) or buildTargets -- check if table is empty and if not reallocate it!
	
	for i=1, #teamList do
		local teamID = teamList[i]
		if not deadTeamList[teamID] then -- isnt dead
			if n == updateFrame[teamID] then
				local interval = GetUpdateInterval(teamID)
				UpdatePassiveBuilders(teamID, interval, n)
				updateFrame[teamID] = n + interval
			elseif not updateFrame[teamID] or updateFrame[teamID] < n then
				updateFrame[teamID] = n + GetUpdateInterval(teamID)
			end
		end
	end
	if FORWARDUNIFORMS then 
		BuildSpeedsChanged()
	end
end

end