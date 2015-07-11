
function gadget:GetInfo()
    return {
        name      = 'Mobile Unit Paralyze Damage Handler',
        desc      = 'Limit mobile units max paralysis time',
        author    = 'Bluestone',
        version   = '',
        date      = 'Monkeya',
        license   = 'GNU GPL, v2 or later',
        layer     = 100,
        enabled   = true
    }
end

----------------------------------------------------------------
-- Synced only
----------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
    return false
end

----------------------------------------------------------------
-- Var
----------------------------------------------------------------

local maxTime = 15 -- in seconds

----------------------------------------------------------------
-- Callins
----------------------------------------------------------------

function gadget:UnitPreDamaged(uID, uDefID, uTeam, damage, paralyzer, weaponID, projID, aID, aDefID, aTeam)
    if paralyzer then
        -- restrict the max paralysis time of mobile units to 15 sec
        if aDefID and uDefID and weaponID and not UnitDefs[uDefID].isBuilding then
            local max_para_time = WeaponDefs[weaponID].damages and WeaponDefs[weaponID].damages.paralyzeDamageTime or maxParalysisTime
            local h,mh,ph = Spring.GetUnitHealth(uID)
            local max_para_damage = mh + ((max_para_time<maxTime) and mh or mh*maxTime/max_para_time)
            damage = math.min(damage, math.max(0,max_para_damage-ph) )            
            --Spring.Echo(h,mh, ph, max_para_damage, max_para_time, damage)
        end
        
        return damage, 1
    end
    return damage, 1
end
