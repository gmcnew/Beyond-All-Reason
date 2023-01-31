-- Translations are currently being migrated to the i18n modules
-- If the translations you are looking for are not in this file,
-- check the other files inside the /language/ directory
return {
	info = {
		selectedunits = 'Selected units',
		unitsselected = 'units selected',
		m = 'M',
		e = 'E',
		costm = 'Cost M',
		coste = 'Cost E',
		health = 'Health',
		of = 'of',		-- 3 of 7
		xp = 'XP',
		maxhealth = 'max health',
		reload = 'reload',
		dps = 'DPS',
		weaponrange = 'weapon range',
		coverrange = 'cover range',
		reloadtime = 'reload time',
		energyshot = 'energy/shot',
		metalshot = 'metal/shot',
		stealthy = 'stealthy',
		cloakcost = 'cloak cost',
		cloakcostmoving = 'cloak cost moving',
		transportmaxmass = 'transport max mass',
		transportmaxsize = 'transport max size',
		transportcapacity = 'transport capacity',
		speed = 'speed',
		reversespeed = 'reverse speed',
		buildpower = 'buildpower',
		buildoptions = 'buildoptions',
		unparalyzable = 'unparalyzable',
		paralyzemult = 'paralyzeMult',
		transportable = 'transportable',
		los = 'LoS',
		airlos = 'AirLoS',
		radar = 'radar',
		sonar = 'sonar',
		jamrange = 'jam range',
		sonarjamrange = 'sonar jam range',
		seismic = 'seismic',
		eneededforconversion = 'E needed for conversion',
		convertedm = 'converted M',
		estorage = 'E storage',
		mstorage = 'M storage',
	},
	unitstats = {
		prog = 'Prog',
		metal = 'Metal',
		energy = 'Energy',
		cost = 'Cost',
		move = 'Move',
		speedaccelturn = 'Speed / Accel / Turn',
		build = 'Build',
		los = 'Los',
		airlos = 'AirLos',
		radar = 'Radar',
		sonar = 'Sonar',
		jammer = 'Jam',
		sonarjam = 'Sonar Jam',
		seis = 'Seis',
		other = 'Other',
		stealth = 'Stealth',
		armor = 'Armor',
		class = 'class',
		exp = 'Exp',
		open = 'Open',
		closed = 'Closed',
		maxhp = 'max HP',
		health = 'health',
		assist = 'Assist',
		repair = 'Repair',
		reclaim = 'Reclaim',
		resurrect = 'Resurrect',
		capture = 'Capture',
		cloak = 'Cloak',
		waterweapon = 'Waterweapon',
		manuelfire = 'Manual Fire',
		stockpile = 'Stockpile',
		paralyzer = 'Paralyzer',
		kamikaze = 'Kamikaze',
		abilities = 'Abilities',
		deathexplosion = 'Death Explosion',
		selfdestruct = 'Self Destruct',
		weap = 'Weap',
		accuracy = 'accuracy',
		aim = 'aim',
		firerate = 'firerate',
		range = 'range',
		aoe = 'aoe',
		edge = 'edge',
		s = 's', -- seconds abbr
		reload = 'reload',
		paralyze = 'paralyze',
		impulse = 'impulse',
		crater = 'crater',
		info = 'Info',
		dmg = 'Dmg',
		infinite = 'infinite',
		burst = 'Burst',
		modifiers = 'Modifiers',
		each = 'each',
		dps = 'DPS',
		persecond = 'per second',
		totaldmg = 'Total Dmg',
	},
	options = {
		basic = 'Basic',
		advanced = 'Advanced',
		madechanges = "made changes that require restart",
		group = {
			graphics = 'Graphics',
			interface = 'Interface',
			game = 'Game',
			control = 'Control',
			audio = 'Audio',
			notifications = 'Notifications',
			accessibility = 'Accessibility',
			dev = 'Dev',
		},
		option = {
			preset_lowest = 'Lowest',
			preset_low = 'Low',
			preset_medium = 'Medium',
			preset_high = 'High',
			preset_ultra = 'Ultra',
			preset_custom = 'Custom',
			label_screen = 'Screen',
			label_interface = 'Interface',
			label_lighting = 'Lighting',
			label_effects = 'Effects',
			label_visuals = 'Visuals',
			label_ranges = 'Ranges',
			label_environment = 'Environment',
			label_behavior = 'Behavior',
			label_automation = 'Automation',
			label_game = 'Game',
			label_info = 'Info',
			label_soundtrack = 'Soundtrack',
			label_playlist = 'Playlist',
			label_messages = 'Messages',
			label_hotkeys = 'Hotkeys',
			label_camera = 'Camera',
			label_cloak = 'Cloak Units',
			label_water = 'Water',
			label_map = 'Map',
			label_unit = 'Unit',
			label_debug = 'Debug',
			label_other = 'Other',
			label_teamcolors = 'Teamcolors',
			preset = 'Graphics Quality',
			display = 'Display',
			resolution = 'Resolution',
			resolution_descr = 'WARNING: sometimes freezes game engine in windowed mode',
			vsync = 'VSync',
			vsync_descr = 'Prevent vertical screen tearing. Note this can introduce slight lag. Try adaptive for less screen draw delay.',
			limitidlefps = 'Limit FPS when idle/offscreen',
			limitidlefps_descr = 'Reduces fps when idle (by setting vsync to a high number)\n(for borderless window and fullscreen need engine not have focus)\nMakes your pc more responsive/cooler when you do stuff outside the game\nCamera movement will break idle mode',
			msaa = 'Anti Aliasing',
			msaa_descr = 'Enables multisample anti-aliasing. NOTE: Can be expensive!\n\nChanges will be applied next game',
			cas_sharpness = 'Sharpness',
			cas_sharpness_descr = 'How much sharpening should be applied to 3d world space',
			sepiatone = 'Color filters',
			sepiatone_descr = '',
			sepiatone_gamma = 'gamma',
			sepiatone_gamma_descr = '',
			sepiatone_saturation = 'saturation',
			sepiatone_saturation_descr = '',
			sepiatone_contrast = 'contrast',
			sepiatone_contrast_descr = '',
			sepiatone_sepia = 'sepia',
			sepiatone_sepia_descr = '',
			sepiatone_shadeui = 'affect the UI',
			sepiatone_shadeui_descr = '',
			cus = 'Advanced Model Shading',
			cus_descr = 'Enables: depth texture, looking damaged, lights that blink, environment lighting, moving tank tracks.',
			darkenmap = 'Darken map',
			darkenmap_descr = 'Darkens the whole map (not the units)',
			darkenmap_darkenfeatures = 'darken features',
			darkenmap_darkenfeatures_descr = 'Darkens features (trees, wrecks, ect..) along with darken map slider above\n\nNOTE: Can be CPU intensive: it cycles through all visible features\nand renders them another time.',
			advmapshading = 'Advanced Map Shading',
			advmapshading_descr = 'Enables: depth texture, detail textures, improved lighting, shadows.',
			shadowslider = 'Shadows',
			shadowslider_descr = 'Set shadow detail',
			shadows_opacity = 'opacity',
			sun = 'Sun',
			sun_y = 'height',
			sun_x = 'pos X',
			sun_z = 'pos Z',
			sun_reset = 'reset map default',
			fog = 'Fog',
			fogmult = 'amount',
			fogmult_descr = 'fog multiplier',
			fog_start = 'start',
			fog_end = 'end',
			fog_reset = 'reset map default',
			ssao = 'Ambient Occlusion',
			ssao_descr = 'WARNING: might introduce a bit of lag',
			ssao_strength = 'strength',
			ssao_quality = 'quality',
			ssao_quality_descr = 'Lower qualities have lower SSAO resolution which can result in SSAO flicker for moving units/camera',
			bloomdeferred = 'Bloom',
			bloomdeferred_descr = 'Unit highlights and lights will glow.',
			bloomdeferredbrightness = 'brightness',
			bloomdeferred_quality = 'quality',
			bloomdeferred_quality_descr = 'Lower qualities have lower bloom resolution which can result in bloom flicker for moving units/camera',
			mapedgeextension = 'Map edge extension',
			mapedgeextension_descr = 'Mirrors the map at screen edges and darkens and decolorizes them.',
			mapedgeextension_brightness = 'brightness',
			mapedgeextension_curvature = 'curvature',
			mapedgeextension_curvature_descr = 'Curve the mirrored edges away into the floor/seabed',
			lineofsight = 'Line of Sight',
			losopacity = 'opacity',
			water = 'Water quality',
			decals = 'Unit tracks',
			decals_descr = '0 = Off\n\nNOTE: Changes might require a restart (if you turn it On/Off)',
			decalsgl4 = 'Ground scarring',
			decalsgl4_descr = '',
			decalsgl4_lifetime = 'lifetime',
			decalsgl4_lifetime_descr = '...changes only apply to newly created scars',
			grounddetail = 'Ground detail',
			grounddetail_descr = 'Set how detailed the map mesh/model is',
			uniticonscaleui = 'Icon scale',
			uniticonscaleui_descr = 'Unit model disappears when the icon covers it completely',
			uniticondistance = 'distance',
			uniticondistance_descr = 'sets the distance when icons appear',
			uniticonfadeamount = 'fade-in amount',
			uniticonfadeamount_descr = 'sets the distance when icons appear',
			uniticonhidewithui = 'hide when UI is hidden',
			uniticonhidewithui_descr = 'dont show icons when disabling UI (via F5)',
			featuredrawdist = 'Feature draw distance',
			featuredrawdist_descr = 'Features (trees, stones, wreckage) stop being displayed at this distance',
			particles = 'Particle limit',
			particles_descr = 'Particle limit used for explosions, smoke, fire, missiletrails and nano particles\n\nBeware: too low value can result in missing effects.',
			lighteffects = 'Lights',
			lighteffects_descr = 'Adds lights to projectiles, lasers and explosions.',
			lighteffects_life = 'lifetime',
			lighteffects_life_descr = 'lifetime of explosion lights',
			lighteffects_brightness = 'brightness',
			lighteffects_brightness_descr = 'Set the brightness of the lights',
			lighteffects_radius = 'radius',
			lighteffects_radius_descr = 'Set the radius of the lights\n\nWARNING: the bigger the radius the heavier on the GPU',
			lighteffects_headlights = 'headlights',
			lighteffects_headlights_descr = 'Adds headlights to units',
			lighteffects_buildlights = 'construction lights',
			lighteffects_buildlights_descr = 'Adds rotating construction builder lights to units',
			dof = 'Depth of Field',
			dof_descr = 'Applies out of focus blur',
			dof_autofocus = 'autofocus',
			dof_autofocus_descr = 'Disable to have mouse position focus',
			dof_fstop = 'f-stop',
			dof_fstop_descr = 'Set amount of blur\n\nOnly works if autofocus is off',
			grass = 'Grass',
			grass_desc = 'Show patches of grass on certain maps',
			grassdistance = 'fadeout distance',
			grassdistance_desc = 'The distance that grass remains visible',
			treewind = 'Tree Wind',
			treewind_descr = 'Makes trees wave in the wind.\n\n(will not apply too every tree type)',
			heatdistortion = 'Heat distortion fx',
			heatdistortion_descr = 'Adds a distortion effect to explosions and flames',
			clouds = 'Clouds',
			clouds_opacity = 'opacity',
			snow = 'Snow',
			snow_descr = 'Snow widget (By default.. maps with wintery names have snow applied)',
			snowmap = 'enabled on this map',
			snowmap_descr = 'It will remember what you toggled for every map\n\n(by default: maps with wintery names have this toggled)',
			snowautoreduce = 'auto reduce',
			snowautoreduce_descr = 'Automaticly reduce snow when average FPS gets lower\n\n(re-enabling this needs time to readjust  to average fps again',
			snowamount = 'amount',
			snowamount_descr = 'disable "auto reduce" option to see the max snow amount you have set',
			resurrectionhalos = 'Resurrected unit halos',
			resurrectionhalos_descr = 'Gives units have have been resurrected a little halo above it.',
			xmas = 'X-mas balls',
			xmas_descr = 'disabling will make the xmas ball invisible (other decorations stay)',
			tombstones = 'Tombstones',
			tombstones_descr = 'Displays tombstones where commanders died',
			snddevice = 'Sound device',
			snddevice_descr = 'Select a sound device\ndefault means your default OS playback device\n\nNOTE: Changes require a restart',
			soundtrack = 'Soundtrack',
			soundtracknew = 'Orchestral theme',
			soundtracknew_descr = 'Add the orchestral themed music to the soundtrack',
			soundtrackold = 'Modern theme',
			soundtrackold_descr = 'Add the modern themed music to the soundtrack',
			soundtrackcustom = 'Custom theme',
			soundtrackcustom_descr = 'Add your own .ogg music files to the soundtrack\nPlace these .ogg music files in data/music/custom/ subfolders: peace/warlow/warhigh/bossfight/gameover\nYou need to create all these folders yourself.',
			soundtracksilence = 'Silence periods',
			soundtracksilence_descr = 'Adds no-music breaks between tracks\nto give you some time to enjoy pure sound effects\nand to make the music less repetitive.',
			soundtrackinterruption = 'Interruption',
			soundtrackinterruption_descr = 'Allows the music to cut off mid-track\nto switch to diffrent intensity level\nwhen action pace changes quickly.',
			volume = 'Volume',
			sndvolmaster = 'master',
			sndvolgeneral = 'general',
			sndvolbattle = 'battle',
			sndvolui = 'interface',
			sndvolunitreply = 'unit reply',
			sndunitsound = "Unit Response Sounds",
			sndunitsound_desc = "Unit Response Sounds",
			sndairabsorption = 'Air absorption',
			sndairabsorption_descr = 'Air absorption is basically a low-pass filter relative to distance between\nsound source and listener, so when in your base or zoomed out, front battles\nwill be heard as only low frequencies',
			muteoffscreen = 'Mute when offscreen',
			muteoffscreen_descr = 'Game will mute itself when mouse is offscreen until you return',
			sndvolmusic = 'music',
			loadscreen_music = 'starts at loadscreen',
			loadscreen_music_descr = 'Music when displaying the startup load screen',
			scav_messages = 'Scavenger written notifications',
			scav_voicenotifs = 'Scavenger voice notifications',
			scav_voicenotifs_descr = 'Toggle the scavenger announcer voice',
			notifications_tutorial = 'Tutorial mode',
			notifications_tutorial_descr = 'Additional messages that guide you how to play\n\nIt remembers what has been played already\n(Re)enabling this will reset this',
			notifications_messages = 'Written notifications',
			notifications_messages_descr = 'Displays notifications on screen',
			notifications_spoken = 'Voice notifications',
			notifications_spoken_descr = 'Plays voice notifications',
			notifications_volume = 'volume',
			notifications_volume_descr = 'NOTE: it also uses interface volume channel (Sound tab)',
			notifications_playtrackedplayernotifs = 'tracked cam/player notifs',
			notifications_playtrackedplayernotifs_descr = 'Displays notifications from the perspective of the currently camera tracked player',
			hwcursor = 'Hardware cursor',
			hwcursor_descr = 'When disabled: mouse cursor refresh rate will equal to your ingame fps',
			setcamera_bugfix = "Per-frame camera smooth",
			setcamera_bugfix_descr = "Enable SetCamera every frame",
			cursorsize = 'Cursor size',
			cursorsize_descr = 'Note that cursor already auto scales according to screen resolution\n\nFurther adjust size and snap to a smaller/larger size',
			doubleclicktime = 'Double-click time',
			crossalpha = 'Cursor \'cross\' alpha',
			crossalpha_descr = 'Opacity of mouse icon in center of screen when you are in camera pan mode\n\n(The\'icon\' has a dot in center with 4 arrows pointing in all directions)',
			middleclicktoggle = 'Middleclick toggles camera move',
			middleclicktoggle_descr = 'Enable camera pan toggle via single middlemouse click',
			containmouse = 'Contain mouse',
			containmouse_descr = 'When in windowed mode, this prevents your mouse from moving out of it',
			screenedgemove = 'Screen edge moves camera',
			screenedgemove_descr = 'If mouse is close to screen edge this will move camera\n\nChanges will be applied next game',
			screenedgemovewidth = 'edge width',
			screenedgemovewidth_descr = 'In percentage of screen border',
			screenedgemovedynamic = 'variable speed',
			screenedgemovedynamic_descr = 'Enable if scrolling speed should fade with edge distance.',
			camera = 'Camera',
			camerashake = 'shake',
			camerashake_descr = 'Set the amount of camerashake on explosions',
			camerasmoothing = 'smoothing',
			camerasmoothness = 'smoothness',
			camerasmoothness_descr = 'How smooth should the transitions between camera movement be?',
			camerapanspeed = 'middleclick grab speed',
			camerapanspeed_descr = 'Smoothness of camera panning mode',
			cameramovespeed = 'move speed',
			cameramovespeed_descr = 'Smoothness of camera moving mode',
			mincamheight = 'Limit camera zoom',
			mincamheight_descr = 'Limit the max amount the camera can zoom in\n\nHigher = camera can zoom in less',
			scrollspeed = 'scroll zoom speed',
			scrollinverse = 'reverse scrolling',
			minimumcameraheight = 'minimum camera height',
			lockcamera = 'Tracking cam',
			lockcamera_transitiontime = 'smoothing',
			lockcamera_transitiontime_descr = 'When viewing a players camera...\nhow smooth should the transitions between camera movement be?',
			interface = 'Interface',
			uiscale = 'scale',
			guiopacity = 'opacity',
			guitilescale = 'background tile scale',
			guitileopacity = 'opacity',
			guishader = 'blur',
			guishader_descr = 'Blurs the world under every user interface element',
			guishaderintensity = '   intensity',
			font = 'font',
			font_descr = 'Regular read friendly font used for text',
			font2 = 'font 2',
			font2_descr = 'Stylistic font mainly used for names/buttons/titles',
			teamcolors = 'Player colors: auto generated ingame',
			teamcolors_descr = 'Replaces lobby colors with a auto generated color palette based one\n\nNOTE: reloads all widgets because these need to update their colors',
			sameteamcolors = 'team colorisation',
			sameteamcolors_descr = 'Use the same teamcolor for all the players in a team\n\nNOTE: reloads all widgets because these need to update their teamcolors',
			playercolors = 'Simple Team Colors',
			simpleteamcolors = 'simple',
			simpleteamcolors_reset = "Reset (Restart to reset sliders)",
			simpleteamcolors_player_r = 'Player Red',
			simpleteamcolors_player_g = 'Player Green',
			simpleteamcolors_player_b = 'Player Blue',
			simpleteamcolors_ally_r = 'Ally Red',
			simpleteamcolors_ally_g = 'Ally Green',
			simpleteamcolors_ally_b = 'Ally Blue',
			simpleteamcolors_enemy_r = 'Enemy Red',
			simpleteamcolors_enemy_g = 'Enemy Green',
			simpleteamcolors_enemy_b = 'Enemy Blue',
			simpleteamcolors_descr = 'Make all enemies have the same color',
			dualmode = 'Dual Screen Mode',
			dualmode_enabled = 'enabled',
			dualmode_enabled_descr = 'Fill a separate screen with minimap. On a single monitor divides screen in half',
			dualmode_left = 'use left screen',
			dualmode_left_descr = 'Uses the left screen for dual mode if enabled, otherwise the right one',
			dualmode_minimap_aspectratio = 'keep aspect ratio',
			dualmode_minimap_aspectratio_descr = 'Keeps dual screen content aspect ratio if enabled, otherwise stretch to fill',
			minimap = 'Minimap',
			minimap_enlarged = 'enlarged',
			minimap_enlarged_descr = 'Relocates the order-menu to make room for the minimap',
			minimap_maxheight = 'height',
			minimap_maxheight_descr = 'Allocate a max height for the minimap (remember: width is limited as well)',
			minimapiconsize = 'icon scale',
			minimapleftclick = 'left click moves camera',
			minimapleftclick_descr = 'Left mouse button will move the camera (it is middle mouse by default)\nwhen disabled: left click(drag) will be selecting units.',
			gridmenu = 'grid',
			gridmenu_descr = 'Alternative comprehensive build menu',
			keylayout = 'Keyboard Layout',
			keylayout_descr = 'Set the keyboard layout',
			keybindings = 'Keybindings',
			keybindings_descr = 'Set the keybindings layout',
			buildmenu = 'Build menu',
			buildmenu_bottom = 'bottom position',
			buildmenu_bottom_descr = 'Relocate the buildmenu to the bottom of the screen',
			buildmenu_maxposy = 'max height pos',
			buildmenu_maxposy_descr = 'Set a maximum height position the buildmenu will stick to\n(menu will be directly under minimap unless it gets higher than this amount of the screen)',
			buildmenu_alwaysshow = 'always show',
			buildmenu_alwaysshow_descr = 'Not hiding when no builders are selected',
			buildmenu_prices = 'prices',
			buildmenu_prices_descr = 'Unit prices in the buildmenu\n\n(when disabled: still show when hovering icon)',
			buildmenu_groupicon = 'group icon',
			buildmenu_groupicon_descr = 'Group icons in the buildmenu',
			buildmenu_radaricon = 'radar icon',
			buildmenu_radaricon_descr = 'Radar icons in the buildmenu',
			ordermenu = 'Ordermenu',
			ordermenu_colorize = 'colorize',
			ordermenu_bottompos = 'bottom position',
			ordermenu_bottompos_descr = 'Relocate the ordermenu to the bottom of the screen',
			ordermenu_alwaysshow = 'always show',
			ordermenu_alwaysshow_descr = 'Not hiding when no buttons are available',
			ordermenu_hideset = 'hide common commands',
			ordermenu_hideset_descr = 'Hide the ordermenu commands that have shortcuts:\n\nMove, Stop, Attack, Patrol, Fight, Wait, Guard, Reclaim, Repair, D-Gun',
			unitgroups = 'Unit groups',
			unitgroups_descr = 'Show unit groups interface\nlocated at the bottom of the screen (unless you have the buildmenu there)',
			info = 'Info panel',
			info_buildlist = 'buildoption icons',
			info_buildlist_descr = 'Regarding factories/builders: display an icon list of all buildable units instead of other info.',
			advplayerlist = 'Playerlist',
			advplayerlist_scale = 'scale',
			advplayerlist_scale_descr = 'Resize the playerlist (and its addons)',
			advplayerlist_showid = 'show Team ID',
			advplayerlist_showid_descr = 'show team ID',
			advplayerlist_country = 'country flag',
			advplayerlist_country_descr = 'show country flag',
			advplayerlist_rank = 'rank icon',
			advplayerlist_rank_descr = 'show rank icon',
			advplayerlist_side = 'faction icon',
			advplayerlist_side_descr = 'show side/faction icon',
			advplayerlist_skill = 'OpenSkill value',
			advplayerlist_skill_descr = 'show the player openskill number (used for balancing algorithm)',
			advplayerlist_income = 'income values',
			advplayerlist_income_descr = 'displays the energy/metal income values',
			advplayerlist_cpuping = 'cpuping number',
			advplayerlist_cpuping_descr = 'show cpu/ping usage/value',
			advplayerlist_share = 'share buttons',
			advplayerlist_share_descr = 'show (quick) share buttons\n\nNOTE: auto hides when having no team members',
			advplayerlist_absresbars = 'resbar absolutes',
			advplayerlist_absresbars_descr = 'resbar values and max storages are displayed on the scale of teamplayer that has max storage',
			advplayerlist_hidespecs = 'hide spectators',
			advplayerlist_hidespecs_descr = 'hide/collapse spectator list by default',
			systemprivacy = 'hide your system info',
			systemprivacy_descr = 'disallow other players to view your system specifications (in player list tooltip)\napplies to next game',
			mascot = 'mascot',
			mascot_descr = 'Shows a mascot on top of the playerslist',
			unittotals = 'unit totals',
			unittotals_descr = 'Show your unit totals on top of the playerlist',
			musicplayer = 'music/audio controls',
			musicplayer_descr = 'Show music and general volume sliders and displays track progress and name on hover',
			musicplayer = 'music player',
			musicplayer_descr = 'Show music player on top of playerlist',
			console = 'Console',
			console_maxlines = 'max chat lines',
			console_maxconsolelines = 'max console lines',
			console_capitalize = 'capitalize chat text',
			console_fontsize = 'font size',
			console_hide = 'hide chat and console',
			console_hide_descr = 'Hides chat and console. (scrollable ui interface still available)',
			console_hidespecchat = 'hide spectator chat',
			console_hidespecchat_descr = 'Not showing any spectator chat',
			console_showbackground = 'show background',
			console_showbackground_descr = 'Always show background (faintly)',
			console_backgroundopacity = 'background opacity',
			console_backgroundopacity_descr = 'Show a transparent background',
			console_chatvolume = 'chat message',
			console_chatvolume_descr = 'Customize the volume of incoming chat messages',
			console_mapmarkvolume = 'mapmark point',
			console_mapmarkvolume_descr = 'Customize the volume of mapmark points/messages',
			console_handleinput = 'handle chat input',
			console_handleinput_descr = 'Integrates chat text input instead of using in-engine method',
			console_inputbutton = 'input mode toggle button',
			console_inputbutton_descr = 'Enable text input mode toggle button',
			continuouslyclearmapmarks = 'Hide all map drawings/marks',
			continuouslyclearmapmarks_descr = 'Continuously clear all map marks: drawings and points',
			idlebuilders = 'Idle builders',
			idlebuilders_descr = 'Displays a row of idle builder units at the bottom of the screen',
			buildbar = 'Factory dock',
			buildbar_descr = 'Displays a column of factories at the right side of the screen\nhover and click units to quickly add to the factory queue',
			converterusage = 'Energy Converter usage',
			converterusage_descr = 'Displays the current energy->metal converter usage at the top of the screen',
			dgunrulereminder = 'Dgun rule reminder',
			dgunrulereminder_descr = 'Displays a tooltip at enemy commander to remind you not to dgun it\n...when last your commander is near it and dgun targeting is active',
			teamplatter = 'Unit team platters',
			teamplatter_descr = 'Shows a team color platter above all visible units',
			teamplatter_opacity = 'opacity',
			teamplatter_opacity_descr = 'Set the opacity of the team spotters',
			teamplatter_skipownteam = 'skip own units',
			teamplatter_skipownteam_descr = 'Doesnt draw platters for yourself',
			enemyspotter = 'Enemy spotters',
			enemyspotter_descr = 'Draws smoothed circles under enemy units\n\nDisables when enemy is single colored or alone',
			enemyspotter_opacity = 'opacity',
			enemyspotter_opacity_descr = 'Set the opacity of the enemy-spotter rings',
			selectedunits = 'Selection',
			selectedunits_descr = 'Draws a platter under selected units\n\nNOTE: this widget can be heavy when having lots of units selected',
			selectedunits_opacity = 'base opacity',
			selectedunits_opacity_descr = 'Set the opacity of the highlight on selected units',
			selectedunits_teamcoloropacity = 'teamcolor amount',
			selectedunits_teamcoloropacity_descr = 'Set the amount of teamcolor used for the base platter',
			highlightselunits = 'Selection Unit Highlight',
			highlightselunits_descr = 'Highlights unit models when selected',
			highlightselunits_opacity = 'opacity',
			highlightselunits_opacity_descr = 'Set the opacity of the highlight on selected units',
			highlightselunits_teamcolor = 'use teamcolor',
			highlightselunits_teamcolor_descr = 'Use teamcolor instead of unit health coloring',
			metalspots = 'Metalspots',
			metalspots_descr = 'Shows a circle around (unoccupied) metal spots with the amount of metal in it',
			metalspots_opacity = 'opacity',
			metalspots_values = 'show values',
			metalspots_values_descr = 'Display metal values (during game)\nPre-gamestart or when in metalmap view (f4) this will always be shown\n\nNote that it\'s significantly enough more costly to draw the text values',
			metalspots_metalviewonly = 'limit to F4 (metalmap) view',
			metalspots_metalviewonly_descr = 'Limit display to only during pre-gamestart or when in metalmap view (f4)',
			geospots = 'Geothermals',
			geospots_descr = 'Shows a circle around (unoccupied) geothermal spots',
			geospots_opacity = 'opacity',
			healthbars = 'Health bars',
			healthbarsscale = 'scale',
			healthbarsdistance = 'draw distance',
			healthbarsvariable = 'variable sizes',
			healthbarsvariable_descr = 'Increases healthbar sizes for bigger units',
			healthbarswhenguihidden = 'display when GUI hidden',
			healthbarswhenguihidden_descr = 'even display bars when GUI is hidden (F5 mode)',
			healthbarshide = 'show health only when selected',
			healthbarshide_descr = 'Hide the healthbar and rely on damaged unit looks',
			healthbarsmaxdistance = "Healthbars max distance",
			rankicons = 'Rank icons',
			rankicons_descr = 'Shows a rank icon depending on experience next to units',
			rankicons_distance = 'draw distance',
			rankicons_scale = 'scale',
			allycursors = 'Ally cursors',
			allycursors_descr = 'Shows the position of ally cursors',
			allycursors_playername = 'player name',
			allycursors_playername_descr = 'Shows the player name next to the cursor',
			allycursors_spectatorname = 'spectator name',
			allycursors_spectatorname_descr = 'Shows the spectator name next to the cursor',
			allycursors_showdot = 'player cursor dot',
			allycursors_showdot_descr = 'Shows a dot at the center of ally cursor position',
			allycursors_lights = 'lights (non-specs)',
			allycursors_lights_descr = 'Adds a colored light to every ally cursor',
			allycursors_lightradius = '   radius',
			allycursors_lightstrength = '   strength',
			cursorlight = 'Cursor light',
			cursorlight_descr = 'Adds a light at/above your cursor position\n\nNeeds "Lights" (graphics option) to be enabled',
			cursorlight_lightradius = 'radius',
			cursorlight_lightstrength = 'strength',
			showbuilderqueue = 'Show builder queue',
			showbuilderqueue_descr = 'Shows ghosted buildings about to be built on the map',
			unitenergyicons = 'Unit insufficient energy icons',
			unitenergyicons_descr = 'Shows a red power bolt above units that cant fire their most e consuming weapon\nwhen you haven\'t enough energy available.',
			nametags_rank = 'Commander name tag rank icon',
			nametags_rank_descr = 'Display the player rank icon left of the commander player name.\n(only shown in multiplayer)',
			nametags_icon = 'Commander name on icon',
			nametags_icon_descr = 'Show commander name when its displayed as icon',
			commandsfx = 'Command FX',
			commandsfx_descr = 'Shows unit target lines when you give orders\n\nThe commands from your teammates are shown as well',
			commandsfxfilterai = 'filter AI teams',
			commandsfxfilterai_descr = 'Hide commands for AI teams',
			commandsfxopacity = 'opacity',
			commandsfxduration = 'lifetime',
			commandsfxuseteamcolors = 'use teamcolors',
			commandsfxuseteamcolors_descr = 'Make all the lines be teamcolors instead of command colors',
			commandsfxuseteamcolorswhenspec = 'use teamcolors when spectator',
			commandsfxuseteamcolorswhenspec_descr = 'Make all the lines be teamcolors instead of command colors',
			displaydps = 'Display DPS',
			displaydps_descr = 'Display the \'Damage Per Second\' done where target are hit',
			flankingicons = 'Flanking direction',
			flankingicons_descr = 'Display the flanking icons to show direction of armor strong/weak point\nEncircle unit to achieve a larger damage bonus!',
			givenunits = 'Given unit icons',
			givenunits_descr = 'Tags given units with \'new\' icon',
			radarrange = 'Radar range',
			radarrange_descr = 'Displays the range of radar coverage with a green circle',
			radarrangeopacity = 'opacity',
			sonarrange = 'Sonar range',
			sonarrange_descr = 'Displays the range of sonar coverage with a blue circle',
			sonarrangeopacity = 'opacity',
			jammerrange = 'Jammer range',
			jammerrange_descr = 'Displays the range of radar jammer coverage with an orange circle',
			jammerrangeopacity = 'opacity',
			losrange = 'Line of Sight range',
			losrange_descr = 'Displays the sight range with a (white or team colored) line',
			losrangeopacity = 'opacity',
			losrangeteamcolors = 'team colored',
			defrange = 'Defense ranges',
			defrange_descr = 'Displays range of defenses (enemy and ally)',
			defrange_allyair = 'Ally Air',
			defrange_allyair_descr = 'Show Range For Ally Air',
			defrange_allyground = 'Ally Ground',
			defrange_allyground_descr = 'Show Range For Ally Ground',
			defrange_allynuke = 'Ally Nuke',
			defrange_allynuke_descr = 'Show Range For Ally Nuke',
			defrange_enemyair = 'Enemy Air',
			defrange_enemyair_descr = 'Show Range For Enemy Air',
			defrange_enemyground = 'Enemy Ground',
			defrange_enemyground_descr = 'Show Range For Enemy Ground',
			defrange_enemynuke = 'Enemy Nuke',
			defrange_enemynuke_descr = 'Show Range For Enemy Nuke',
			antiranges = 'Anti-nuke ranges',
			antiranges_descr = 'Displays the range of anti-nuke coverage',
			allyselunits_select = 'select units',
			allyselunits_select_descr = 'When viewing a players camera, this selects what the player has selected',
			lockcamera_hideenemies = 'only show tracked player viewpoint',
			lockcamera_hideenemies_descr = 'When viewing a players camera, this will display what the tracked player sees',
			lockcamera_los = 'show tracked player LoS',
			lockcamera_los_descr = 'When viewing a players camera and los, shows shaded los ranges too',
			playertv_countdown = 'Player TV countdown',
			playertv_countdown_descr = 'Countdown time before it switches player',
			displayselectedname = 'Display selected playername',
			displayselectedname_descr = 'Display the selected playername above the playerlist area',
			loadscreen_tips = 'Loadscreen tips',
			loadscreen_tips_descr = 'Show tips at the startup load screen',
			networksmoothing = 'Network smoothing',
			networksmoothing_descr = 'Adds additional delay to assure smooth gameplay and stability\nDisable for increased responsiveness: if you have a quality network connection\n\nChanges will be applied next game',
			autoquit = 'Auto quit',
			autoquit_descr = 'Automatically quits after the game ends.\n...unless the mouse has been moved within a few seconds.',
			smartselect_includebuildings = 'Include structures in area-selection',
			smartselect_includebuildings_descr = 'When rectangle-drag-selecting an area, include building units too?\n\nDisabled: non-mobile units will be excluded (hold Shift to override)\nNote: Nano Turrets will always be selected',
			smartselect_includebuilders = 'include builders (if above is off)',
			smartselect_includebuilders_descr = 'When rectangle-drag-selecting an area, exclude builder units (hold Shift to override)',
			onlyfighterspatrol = 'Only fighters patrol',
			onlyfighterspatrol_descr = 'Only fighters obey a factory\'s patrol route after leaving airlab.',
			fightersfly = 'Set fighters on Fly mode',
			fightersfly_descr = 'Setting fighters on Fly mode when created',
			builderpriority = 'Builder Priority Restriction',
			builderpriority_descr = 'Sets builders (nanos, labs and cons) on low priority mode\n\nLow priority mode means that builders will only spend energy when its available.\nUsage: Set the most important builders on high and leave the rest on low priority',
			builderpriority_nanos = 'nanos',
			builderpriority_nanos_descr = 'Toggle to set low priority',
			builderpriority_cons = 'cons',
			builderpriority_cons_descr = 'Toggle to set low priority',
			builderpriority_labs = 'labs',
			builderpriority_labs_descr = 'Toggle to set low priority',
			autocloak = 'Auto Cloak Units',
			autocloak_descr = '',
			unitreclaimer = 'Unit Reclaimer',
			unitreclaimer_descr = 'Reclaim units within an area.\nHover over a unit and hold CTRL and drag area-reclaim circle to reclaim all units within, use ALT for just the type you hover over.',
			autogroup_immediate = 'Autogroup immediate mode',
			autogroup_immediate_descr = 'Units built/resurrected/received are added to autogroups immediately,\ninstead when they get to be idle.\n\n(add units to autogroup with ALT+number)',
			autogroup_persist = 'Autogroup persist mode',
			autogroup_persist_descr = 'Autogroups persist in new games.\nIf this is enabled units which were added to an autogroup in previous games\n will be added to the same group in this game.',
			factory = 'Factory',
			factoryguard = 'guard (builders)',
			factoryguard_descr = 'Newly created builders will assist their source factory',
			factoryholdpos = 'hold position',
			factoryholdpos_descr = 'Sets factories and units they produce, to hold position automatically (not aircraft)',
			factoryrepeat = 'auto-repeat',
			factoryrepeat_descr = 'Sets new factories on Repeat mode',
			transportai = 'Transport AI',
			transportai_descr = 'Transport units automatically pick up new units going to factory waypoint.',
			settargetdefault = 'Set-target as default',
			settargetdefault_descr = 'Replace default attack command to a set-target command\n(when rightclicked on enemy unit)',
			dgunnogroundenemies = 'Dont snap DGun to ground units',
			dgunnogroundenemies_descr = 'Prevents dgun aim to snap onto enemy ground units.\nholding SHIFT will still target units\n\nWill still snap to air, ships and hovers (when on water)',
			dgunstallassist = 'Conserve energy when DGunning',
			dgunstallassist_descr = 'When pressing D with a Com selected, units that drain energy are put on wait for a while.',
			singleplayerpause = 'Pause when in settings/quit/lobby',
			singleplayerpause_descr = 'Exclusively in singleplayer mode...\n\nPauses the game when showing the settings/quit window or lobby',
			widgetselector = 'Widget selector interface',
			widgetselector_descr = 'Allow the toggling of the widget selector interface (via F11)',
			devmode = 'Developer UI',
			devmode_descr = 'Toggle between how a developer or player see the UI',
			customwidgets = 'Allow custom widgets',
			customwidgets_descr = 'enable loading of custom widgets (placed inside spring/luaui/widgets)',
			profiler = 'Widget profiler',
			framegrapher = 'Frame grapher',
			autocheat = 'Auto enable cheats for $VERSION',
			autocheat_descr = 'does: /cheat, /globallos, /godmode',
			restart = 'Restart',
			restart_descr = 'Restarts the game',
			echocamerastate = 'Echo CameraState',
			echocamerastate_descr = 'Echoes contents of Spring.GetCameraState()',
			startboxeditor = 'Startbox editor',
			startboxeditor_descr = 'LMB to draw (either clicks or drag), RMB to accept a polygon, D to remove last polygon\nS to add a team startbox to startboxes_mapname.txt\n(S overwites the export file for the first team)',
			tonemap = 'Unit tonemapping',
			envAmbient = 'ambient %',
			unitSunMult = 'sun mult',
			unitExposureMult = 'exposure mult',
			modelGamma = 'gamma value',
			tonemapDefaults = 'restore defaults',
			debugcolvol = 'Draw Collision Volumes',
			fog_color_reset = 'reset map default',
			map_voidwater = 'Map VoidWater',
			map_voidground = 'Map VoidGround',
			map_splatdetailnormaldiffusealpha = 'Map splatDetailNormalDiffuseAlpha',
			map_splattexmults = 'Map Splat Tex Mult',
			map_splattexacales = 'Map Splat Tex Scales',
			GroundShadowDensity = 'GroundShadowDensity',
			UnitShadowDensity = 'UnitShadowDensity',
			color_groundambient = 'Ground ambient',
			color_grounddiffuse = 'Ground diffuse',
			color_groundspecular = 'Ground specular',
			color_unitambient = 'Unit ambient',
			color_unitdiffuse = 'Unit diffuse',
			color_unitspecular = 'Unit specular',
			suncolor = 'Sun',
			skycolor = 'Sky',
			sunlighting_reset = 'Reset ground/unit coloring',
			sunlighting_reset_descr = 'resets ground/unit ambient/diffuse/specular colors',
			red = 'red',
			green = 'green',
			blue = 'blue',
			language = 'Language',
		},
	},
}
