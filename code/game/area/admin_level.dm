// Bunker01
// Areas

/area/adminlevel
	ceiling = CEILING_METAL
	base_lighting_alpha = 255

/area/adminlevel/bunker01
	icon_state = "thunder"
	requires_power = FALSE
	statistic_exempt = TRUE
	flags_area = AREA_NOTUNNEL

/area/adminlevel/bunker01/mainroom
	name = "地堡主厅"
	icon_state = "bunker01_main"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/medbay
	name = "地堡医务室"
	icon_state = "bunker01_medbay"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/security
	name = "地堡安保区"
	icon_state = "bunker01_security"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/engineering
	name = "地堡工程区"
	icon_state = "bunker01_engineering"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/storage
	name = "地堡储藏室"
	icon_state = "bunker01_storage"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/bedroom
	name = "地堡卧室"
	icon_state = "bunker01_bedroom"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/command
	name = "地堡指挥室"
	icon_state = "bunker01_command"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/bathroom
	name = "地堡浴室"
	icon_state = "bunker01_bathroom"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/kitchen
	name = "地堡厨房"
	icon_state = "bunker01_kitchen"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/hydroponics
	name = "地堡水培室"
	icon_state = "bunker01_hydroponics"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/breakroom
	name = "地堡休息室"
	icon_state = "bunker01_break"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/gear
	name = "地堡装备室"
	icon_state = "bunker01_gear"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/adminlevel/bunker01/caves
	name = "地堡洞穴"
	icon_state = "bunker01_caves"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	always_unpowered = TRUE
	requires_power = TRUE
	base_lighting_alpha = 0

/area/adminlevel/bunker01/caves/outpost
	name = "地堡哨站"
	icon_state = "bunker01_caves_outpost"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	requires_power = TRUE
	always_unpowered = FALSE

/area/adminlevel/bunker01/caves/xeno
	name = "地堡异形虫巢"
	icon_state = "bunker01_caves_outpost"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	flags_area = AREA_NOTUNNEL|AREA_ALLOW_XENO_JOIN

	var/hivenumber = XENO_HIVE_ALPHA

/area/adminlevel/bunker01/caves/xeno/Entered(A, atom/OldLoc)
	. = ..()
	if(isxeno(A))
		var/mob/living/carbon/xenomorph/X = A

		X.away_timer = XENO_LEAVE_TIMER
		X.set_hive_and_update(hivenumber)

// ERT Station
/area/adminlevel/ert_station
	name = "应急响应队驻地"
	icon_state = "green"
	requires_power = FALSE
	flags_area = AREA_NOTUNNEL

/area/adminlevel/ert_station/upp_station
	name = "进步人民联盟驻地"
	icon_state = "green"

/area/adminlevel/ert_station/pizza_station
	name = "银河披萨"
	icon_state = "red"

/area/adminlevel/ert_station/clf_station
	name = "殖民地解放阵线驻地"
	icon_state = "white"

/area/adminlevel/ert_station/weyland_station
	name = "维兰德-汤谷驻地"
	icon_state = "red"

/area/adminlevel/ert_station/uscm_station
	name = "美国殖民地海军陆战队驻地"
	icon_state = "green"

/area/adminlevel/ert_station/freelancer_station
	name = "自由佣兵驻地"
	icon_state = "yellow"

/area/adminlevel/ert_station/royal_marines_station
	name = "HMS 帕特纳号机库"
	icon_state = "yellow"

/area/adminlevel/ert_station/shuttle_dispatch
	name = "穿梭机调度站"
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	icon_state = "yellow"

//Simulation area
/area/adminlevel/simulation
	name = "模拟现实"
	icon_state = "green"
	requires_power = 0
	flags_area = AREA_NOTUNNEL

/area/misc
	weather_enabled = FALSE

/area/misc/testroom
	requires_power = FALSE
	name = "Test Room"

/area/misc/tutorial
	name = "教程区域"
	icon_state = "tutorial"
	requires_power = FALSE
	flags_area = AREA_NOTUNNEL|AREA_AVOID_BIOSCAN
	statistic_exempt = TRUE
	ceiling = CEILING_METAL
	block_game_interaction = TRUE
	unique = TRUE

	base_lighting_alpha = 255

/area/misc/tutorial/Initialize(mapload, ...)
	. = ..()
	update_base_lighting()

/area/misc/tutorial/no_baselight
	base_lighting_alpha = 0
