//ALMAYER AREAS--------------------------------------//
// Fore = West  | Aft = East //
// Port = South | Starboard = North //
// Bow = Western|Stern = Eastern //(those are the front and back small sections)
// Naming convention is to start by port or starboard then put eitheir (bow,fore,midship,aft,stern)
/area/almayer
	icon = 'icons/turf/area_almayer.dmi'
	// ambience = list('sound/ambience/shipambience.ogg')
	icon_state = "almayer"
	ceiling = CEILING_METAL
	powernet_name = "almayer"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_interval = 30
	// soundscape_playlist = list('sound/effects/xylophone1.ogg', 'sound/effects/xylophone2.ogg', 'sound/effects/xylophone3.ogg')
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE

	///Whether this area is used for hijack evacuation progress
	var/hijack_evacuation_area = FALSE

	///The weight this area gives towards hijack evacuation progress
	var/hijack_evacuation_weight = 0

	///Whether this area is additive or multiplicative towards evacuation progress
	var/hijack_evacuation_type = EVACUATION_TYPE_NONE

/area/almayer/Initialize(mapload, ...)
	. = ..()

	if(hijack_evacuation_area)
		SShijack.progress_areas[src] = power_equip

/obj/structure/machinery/computer/shuttle_control/almayer/hangar
	name = "电梯控制台"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "supply"
	unslashable = TRUE
	unacidable = TRUE
	exproof = 1
	density = TRUE
	req_access = null
	shuttle_tag = "Hangar"

/obj/structure/machinery/computer/shuttle_control/almayer/maintenance
	name = "电梯控制台"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	unslashable = TRUE
	unacidable = TRUE
	exproof = 1
	density = TRUE
	req_access = null
	shuttle_tag = "Maintenance"

/area/almayer/command
	minimap_color = MINIMAP_AREA_COMMAND

/area/almayer/command/cic
	name = "\improper 作战情报中心"
	icon_state = "cic"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_CIC
	soundscape_interval = 50

/area/almayer/command/cichallway
	name = "\improper 指挥区安全走廊"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/airoom
	name = "\improper AI 核心"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ARES
	soundscape_interval = 120

/area/almayer/command/securestorage
	name = "\improper 上层甲板安全储藏室"
	icon_state = "corporatespace"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/computerlab
	name = "\improper 上层甲板计算机实验室"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/telecomms
	name = "\improper 上层甲板电信室"
	icon_state = "tcomms"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/self_destruct
	name = "\improper 上层甲板自毁系统核心室"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/corporateliaison
	name = "\improper 公司联络员办公室"
	icon_state = "corporatespace"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/combat_correspondent
	name = "\improper 上层甲板战地记者办公室"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck

// engineering

/area/almayer/engineering
	minimap_color = MINIMAP_AREA_ENGI

// lower deck

/area/almayer/engineering/lower
	name = "\improper 下层甲板工程部"
	icon_state = "lowerengineering"
	fake_zlevel = 2 // lowerdeck

/area/almayer/engineering/lower/engine_monitoring//this is not used  so could be remove?
	name = "\improper 下层甲板反应堆监控室"
	icon_state = "lowermonitoring"

/area/almayer/engineering/lower/workshop
	name = "\improper 下层甲板工程工坊"
	icon_state = "workshop"

/area/almayer/engineering/lower/workshop/hangar
	name = "\improper 军械工坊"

/area/almayer/engineering/lower/engine_core
	name = "\improper 反应堆核心室"
	icon_state = "coreroom"
	soundscape_playlist = SCAPE_PL_ENG
	soundscape_interval = 15
	hijack_evacuation_area = TRUE
	hijack_evacuation_weight = 0.2
	hijack_evacuation_type = EVACUATION_TYPE_ADDITIVE

// upper deck

/area/almayer/engineering/upper_engineering
	name = "\improper 上层甲板工程部"
	icon_state = "upperengineering"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/upper_engineering/starboard
	name = "\improper 上层甲板右舷工程区"

/area/almayer/engineering/upper_engineering/port
	name = "\improper 上层甲板左舷工程区"

/area/almayer/engineering/upper_engineering/notunnel
	flags_area = AREA_NOTUNNEL

/area/almayer/engineering/ce_room
	name = "\improper 上层甲板总工程师办公室"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/starboard_atmos
	name = "\improper 上层甲板右舷大气控制室"
	icon_state = "starboardatmos"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/port_atmos
	name = "\improper 上层甲板左舷大气控制室"
	icon_state = "portatmos"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/laundry
	name = "\improper 上层甲板洗衣房"
	icon_state = "laundry"
	fake_zlevel = 1 // upperdeck

/area/almayer/shipboard
	minimap_color = MINIMAP_AREA_SEC

/area/almayer/shipboard/navigation
	name = "\improper 星际导航甲板"
	icon_state = "astronavigation"
	fake_zlevel = 2 // lowerdeck
	hijack_evacuation_area = TRUE
	hijack_evacuation_weight = 1.1
	hijack_evacuation_type = EVACUATION_TYPE_MULTIPLICATIVE

/area/almayer/shipboard/panic
	name = "\improper 机库避难室"
	icon_state = "brig"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/starboard_missiles
	name = "\improper 上层甲板右舷导弹发射管"
	icon_state = "starboardmissile"
	fake_zlevel = 1 // upperdeck

/area/almayer/shipboard/port_missiles
	name = "\improper 上层甲板左舷导弹发射管"
	icon_state = "portmissile"
	fake_zlevel = 1 // upperdeck

/area/almayer/shipboard/weapon_room
	name = "\improper 下层甲板武器控制室"
	icon_state = "weaponroom"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/weapon_room/notunnel
	flags_area = AREA_NOTUNNEL

/area/almayer/shipboard/starboard_point_defense
	name = "\improper 下层甲板右舷近防炮区"
	icon_state = "starboardpd"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/port_point_defense
	name = "\improper 下层甲板左舷近防炮区"
	icon_state = "portpd"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/stern_point_defense
	name = "\improper 下层甲板舰艉近防炮区"
	icon_state = "portpd"
	fake_zlevel = 2 // lowerdeck

// brig

/area/almayer/shipboard/brig
	name = "\improper 禁闭室"
	icon_state = "brig"
	fake_zlevel = 1 //upperdeck

/area/almayer/shipboard/brig/lobby
	name = "\improper 禁闭室大厅"

/area/almayer/shipboard/brig/armory
	name = "\improper 禁闭室军械库"

/area/almayer/shipboard/brig/mp_bunks
	name = "\improper 禁闭室宪兵宿舍"

/area/almayer/shipboard/brig/starboard_hallway
	name = "\improper 禁闭室右舷走廊"

/area/almayer/shipboard/brig/perma
	name = "\improper 禁闭室永久监禁牢房"

/area/almayer/shipboard/brig/cryo
	name = "\improper 禁闭室冷冻休眠舱"

/area/almayer/shipboard/brig/medical
	name = "\improper 禁闭室医务室"

/area/almayer/shipboard/brig/interrogation
	name = "\improper 禁闭室审讯室"

/area/almayer/shipboard/brig/general_equipment
	name = "\improper 禁闭室通用装备间"

/area/almayer/shipboard/brig/evidence_storage
	name = "\improper 禁闭室证物储藏室"

/area/almayer/shipboard/brig/execution
	name = "\improper 禁闭室行刑室"

/area/almayer/shipboard/brig/execution_storage
	name = "\improper 禁闭室行刑器材储藏室"

/area/almayer/shipboard/brig/cic_hallway
	name = "\improper 禁闭室至作战情报中心走廊"

/area/almayer/shipboard/brig/dress
	name = "\improper 作战情报中心军礼服室"

/area/almayer/shipboard/brig/processing
	name = "\improper 禁闭室收押与拘留区"

/area/almayer/shipboard/brig/cells
	name = "\improper 禁闭室牢房"
	icon_state = "brigcells"

/area/almayer/shipboard/brig/chief_mp_office
	name = "\improper 禁闭室宪兵长办公室"
	icon_state = "chiefmpoffice"

/area/almayer/shipboard/brig/warden_office
	name = "\improper 禁闭室军事监狱长办公室"
	icon_state = "chiefmpoffice"

/area/almayer/shipboard/sea_office
	name = "\improper 下层甲板资深士官顾问办公室"
	icon_state = "chiefmpoffice"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/firing_range_north
	name = "\improper 右舷靶场"
	icon_state = "firingrange"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/firing_range_south
	name = "\improper 左舷靶场"
	icon_state = "firingrange"
	fake_zlevel = 2 // lowerdeck

/area/almayer/hallways/hangar
	name = "\improper 机库"
	icon_state = "hangar"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 50

/area/almayer/hallways/lower
	fake_zlevel = 2 // lowerdeck

/area/almayer/hallways/lower/vehiclehangar
	name = "\improper 下层甲板载具存放区"
	icon_state = "exoarmor"

/area/almayer/hallways/lower/repair_bay
	name = "\improper 下层甲板出击准备工坊"
	icon_state = "dropshiprepair"

/area/almayer/hallways/lower/starboard_umbilical
	name = "\improper 下层甲板右舷连接通道"
	icon_state = "starboardumbilical"

/area/almayer/hallways/lower/port_umbilical
	name = "\improper 下层甲板左舷连接通道"
	icon_state = "portumbilical"

//port
/area/almayer/hallways/lower/port_fore_hallway
	name = "\improper 下层甲板左舷前部走廊"
	icon_state = "port"

/area/almayer/hallways/lower/port_midship_hallway
	name = "\improper 下层甲板左舷中部走廊"
	icon_state = "port"

/area/almayer/hallways/lower/port_aft_hallway
	name = "\improper 下层甲板左舷后部走廊"
	icon_state = "port"

//starboard
/area/almayer/hallways/lower/starboard_fore_hallway
	name = "\improper 下层甲板右舷前部走廊"
	icon_state = "starboard"

/area/almayer/hallways/lower/starboard_midship_hallway
	name = "\improper 下层甲板右舷中部走廊"
	icon_state = "starboard"

/area/almayer/hallways/lower/starboard_aft_hallway
	name = "\improper 下层甲板右舷后部走廊"
	icon_state = "starboard"

/area/almayer/hallways/upper
	fake_zlevel = 1 // upperdeck

/area/almayer/hallways/upper/aft_hallway
	name = "\improper 上层甲板后部走廊"
	icon_state = "aft"

/area/almayer/hallways/upper/fore_hallway
	name = "\improper 上层甲板前部走廊"
	icon_state = "stern"

/area/almayer/hallways/upper/midship_hallway
	name = "\improper 上层甲板舰中走廊"
	icon_state = "stern"

/area/almayer/hallways/upper/port
	name = "\improper 上层甲板左舷走廊"
	icon_state = "port"

/area/almayer/hallways/upper/starboard
	name = "\improper 上层甲板右舷走廊"
	icon_state = "starboard"

//area that are used for transition between decks.
/area/almayer/stair_clone
	name = "\improper 下层甲板楼梯"
	icon_state = "stairs_lowerdeck"
	fake_zlevel = 2 // lowerdeck
	resin_construction_allowed = FALSE

/area/almayer/stair_clone/upper
	name = "\improper 上层甲板楼梯"
	icon_state = "stairs_upperdeck"
	fake_zlevel = 1 // upperdeck

// maintenance areas

/area/almayer/maint

//lower maintenance areas

/area/almayer/maint/lower
	name = "\improper 下层甲板维护区"
	icon_state = "lowerhull"
	fake_zlevel = 2 // lowerdeck

/area/almayer/maint/lower/constr
	name = "\improper 下层甲板施工区"

/area/almayer/maint/lower/s_bow
	name = "\improper 下层甲板右舷舰艏维护区"

/area/almayer/maint/lower/cryo_cells
	name = "\improper 下层甲板冷冻休眠舱维护区"

// Upper maintainance areas
/area/almayer/maint/upper
	name = "\improper 上层甲板维护区"
	icon_state = "upperhull"
	fake_zlevel = 1 // upperdeck

/area/almayer/maint/upper/mess
	name = "\improper 上层甲板餐厅维护区"

/area/almayer/maint/upper/u_m_p
	name = "\improper 上层甲板左舷中部维护区"

/area/almayer/maint/upper/u_m_s
	name = "\improper 上层甲板右舷中部维护区"

/area/almayer/maint/upper/u_f_p
	name = "\improper 上层甲板左舷前部维护区"

/area/almayer/maint/upper/u_f_s
	name = "\improper 上层甲板右舷前部维护区"

/area/almayer/maint/upper/u_a_p
	name = "\improper 上层甲板左舷后部维护区"

/area/almayer/maint/upper/u_a_s
	name = "\improper 上层甲板右舷后部维护区"

// hull areas
/area/almayer/maint/hull

// lower deck hull areas
/area/almayer/maint/hull/lower
	name = "\improper 下层甲板船壳区"
	icon_state = "lowerhull"
	fake_zlevel = 2 // lowerdeck
// stairs.

/area/almayer/maint/hull/lower/stairs
	name = "\improper 下层甲板楼梯船壳区"

/area/almayer/maint/hull/lower/stern
	name = "\improper 下层甲板舰艉船壳区"

/area/almayer/maint/hull/lower/p_bow
	name = "\improper 下层甲板左舷舰艏船壳区"

/area/almayer/maint/hull/lower/s_bow
	name = "\improper 下层甲板右舷舰艏船壳区"

/area/almayer/maint/hull/lower/l_f_s
	name = "\improper 下层甲板右舷前部船壳区"

/area/almayer/maint/hull/lower/l_m_s
	name = "\improper 下层甲板右舷中部船壳区"

/area/almayer/maint/hull/lower/l_a_s
	name = "\improper 下层甲板右舷后部船壳区"

/area/almayer/maint/hull/lower/l_f_p
	name = "\improper 下层甲板左舷前部船壳区"

/area/almayer/maint/hull/lower/l_m_p
	name = "\improper 下层甲板左舷中部船壳区"

/area/almayer/maint/hull/lower/l_a_p
	name = "\improper 下层甲板左舷后部船壳区"

// upper deck hull areas

/area/almayer/maint/hull/upper
	name = "\improper 上层甲板船壳区"
	icon_state = "upperhull"
	fake_zlevel = 1 // upperdeck

// Stairs.
/area/almayer/maint/hull/upper/stairs
	name = "\improper 上层甲板楼梯船壳区"

/area/almayer/maint/hull/upper/p_bow
	name = "\improper 上层甲板左舷舰艏船壳区"

/area/almayer/maint/hull/upper/s_bow
	name = "\improper 上层甲板右舷舰艏船壳区"

/area/almayer/maint/hull/upper/p_stern
	name = "\improper 上层甲板左舷舰艉船壳区"

/area/almayer/maint/hull/upper/s_stern
	name = "\improper 上层甲板右舷舰艉船壳区"

/area/almayer/maint/hull/upper/u_f_s
	name = "\improper 上层甲板右舷前部船壳区"

/area/almayer/maint/hull/upper/u_m_s
	name = "\improper 上层甲板右舷中部船壳区"

/area/almayer/maint/hull/upper/u_a_s
	name = "\improper 上层甲板右舷后部船壳区"

/area/almayer/maint/hull/upper/u_f_p
	name = "\improper 上层甲板左舷前部船壳区"

/area/almayer/maint/hull/upper/u_m_p
	name = "\improper 上层甲板左舷中部船壳区"

/area/almayer/maint/hull/upper/u_a_p
	name = "\improper 上层甲板左舷后部船壳区"

/area/almayer/living
	minimap_color = MINIMAP_AREA_COLONY

/area/almayer/living/tankerbunks
	name = "\improper 下层甲板载具组宿舍"
	icon_state = "livingspace"
	fake_zlevel = 2

/area/almayer/living/auxiliary_officer_office
	name = "\improper 下层甲板辅助支援军官办公室"
	icon_state = "livingspace"
	fake_zlevel = 2

/area/almayer/living/cryo_cells
	name = "\improper 下层甲板冷冻休眠舱"
	icon_state = "cryo"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/briefing
	name = "\improper 简报区"
	icon_state = "briefing"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/port_emb
	name = "\improper 下层甲板左舷长期任务宿舍"
	icon_state = "portemb"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/starboard_emb
	name = "\improper 下层甲板右舷长期任务宿舍"
	icon_state = "starboardemb"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/port_garden
	name = "\improper 左舷花园"
	icon_state = "portemb"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/starboard_garden
	name = "\improper 右舷花园"
	icon_state = "starboardemb"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/basketball
	name = "\improper 篮球场"
	icon_state = "basketball"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/grunt_rnr
	name = "\improper 休息室"
	icon_state = "gruntrnr"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/officer_rnr
	name = "\improper 上层甲板军官休息室"
	icon_state = "officerrnr"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/officer_study
	name = "\improper 上层甲板军官书房"
	icon_state = "officerstudy"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/cafeteria_port
	name = "\improper 左舷餐厅"
	icon_state = "food"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/cafeteria_starboard
	name = "\improper 右舷餐厅"
	icon_state = "food"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/gym
	name = "\improper 下层甲板健身房"
	icon_state = "officerrnr"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/cafeteria_officer
	name = "\improper 上层甲板军官餐厅"
	icon_state = "food"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/offices
	name = "\improper 下层甲板会议室"
	icon_state = "briefing"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/offices/flight
	name = "\improper 飞行办公室"

/area/almayer/living/captain_mess
	name = "\improper 舰长餐厅"
	icon_state = "briefing"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/pilotbunks
	name = "\improper 飞行员宿舍"
	icon_state = "livingspace"
	fake_zlevel = 1

/area/almayer/living/bridgebunks
	name = "\improper 参谋军官宿舍"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/commandbunks
	name = "\improper 指挥官卧室"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/synthcloset
	name = "\improper 上层甲板合成人储藏间"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/numbertwobunks
	name = "\improper 副指挥官卧室"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/chapel
	name = "\improper 阿尔迈耶号礼拜堂"
	icon_state = "officerrnr"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical
	minimap_color = MINIMAP_AREA_MEDBAY

/area/almayer/medical/lower_medical_lobby
	name = "\improper 医疗部下层大厅"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/upper_medical
	name = "\improper 医疗部上层"
	icon_state = "medical"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/morgue
	name = "\improper 停尸房"
	icon_state = "operating"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/operating_room_one
	name = "\improper 医疗部1号手术室"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/operating_room_two
	name = "\improper 医疗部2号手术室"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/operating_room_three
	name = "\improper 医疗部3号手术室"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/operating_room_four
	name = "\improper 医疗部4号手术室"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/medical_science
	name = "\improper 医疗研究实验室"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/hydroponics
	name = "\improper 医疗研究水培室"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/containment
	name = "\improper 医疗研究收容区"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/containment/cell
	name = "\improper 医疗研究收容室"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL|AREA_CONTAINMENT

/area/almayer/medical/containment/cell/cl
	name = "\improper 收容区"

/area/almayer/medical/chemistry
	name = "\improper 医疗部化学实验室"
	icon_state = "chemistry"
	fake_zlevel = 2 // lowerdeck

/area/almayer/medical/lockerroom
	name = "\improper 医疗部更衣室"
	icon_state = "science"
	fake_zlevel = 2 // lowerdeck

/area/almayer/medical/cryo_tubes
	name = "\improper 医疗部低温治疗舱"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/lower_medical_medbay
	name = "\improper 医疗部下层医务室"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/squads/alpha
	name = "\improper 阿尔法小队备战区"
	icon_state = "alpha"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/bravo
	name = "\improper 布拉沃小队备战区"
	icon_state = "bravo"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/charlie
	name = "\improper 查理小队备战区"
	icon_state = "charlie"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/delta
	name = "\improper 德尔塔小队备战区"
	icon_state = "delta"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/alpha_bravo_shared
	name = "\improper 阿尔法与布拉沃小队装备准备区"
	icon_state = "ab_shared"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/charlie_delta_shared
	name = "\improper 查理与德尔塔小队装备准备区"
	icon_state = "cd_shared"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/req
	name = "\improper 军需部"
	icon_state = "req"
	fake_zlevel = 2 // lowerdeck

/area/almayer/powered //for objects not intended to lose power
	name = "\improper 供电区"
	icon_state = "selfdestruct"
	requires_power = 0

/area/almayer/powered/agent
	name = "\improper 未知区域"
	icon_state = "selfdestruct"
	fake_zlevel = 2 // lowerdeck
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL

/area/almayer/engineering/airmix
	icon_state = "selfdestruct"
	requires_power = 0
	flags_area = AREA_NOTUNNEL

/area/almayer/lifeboat_pumps
	name = "救生艇燃料泵"
	icon_state = "lifeboat_pump"
	requires_power = 1
	fake_zlevel = 1
	hijack_evacuation_area = TRUE
	hijack_evacuation_weight = 0.1
	hijack_evacuation_type = EVACUATION_TYPE_ADDITIVE

/area/almayer/lifeboat_pumps/north1
	name = "右舷前部救生艇燃料泵"

/area/almayer/lifeboat_pumps/north2
	name = "右舷后部救生艇燃料泵"

/area/almayer/lifeboat_pumps/south1
	name = "左舷前部救生艇燃料泵"

/area/almayer/lifeboat_pumps/south2
	name = "左舷后部救生艇燃料泵"

/area/almayer/command/lifeboat
	name = "\improper 救生艇对接口"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck

/area/space/almayer/lifeboat_dock
	name = "\improper 左舷救生艇停靠区"
	icon_state = "lifeboat"
	fake_zlevel = 1 // upperdeck

/area/almayer/evacuation
	icon = 'icons/turf/areas.dmi'
	icon_state = "shuttle2"
	requires_power = 0

//Placeholder.
/area/almayer/evacuation/pod1
/area/almayer/evacuation/pod2
/area/almayer/evacuation/pod3
/area/almayer/evacuation/pod4
/area/almayer/evacuation/pod5
/area/almayer/evacuation/pod6
/area/almayer/evacuation/pod7
/area/almayer/evacuation/pod8
/area/almayer/evacuation/pod9
/area/almayer/evacuation/pod10
/area/almayer/evacuation/pod11
/area/almayer/evacuation/pod12
/area/almayer/evacuation/pod13
/area/almayer/evacuation/pod14
/area/almayer/evacuation/pod15
/area/almayer/evacuation/pod16
/area/almayer/evacuation/pod17
/area/almayer/evacuation/pod18

/area/almayer/evacuation/stranded

//Placeholder.
/area/almayer/evacuation/stranded/pod1
/area/almayer/evacuation/stranded/pod2
/area/almayer/evacuation/stranded/pod3
/area/almayer/evacuation/stranded/pod4
/area/almayer/evacuation/stranded/pod5
/area/almayer/evacuation/stranded/pod6
/area/almayer/evacuation/stranded/pod7
/area/almayer/evacuation/stranded/pod8
/area/almayer/evacuation/stranded/pod9
/area/almayer/evacuation/stranded/pod10
/area/almayer/evacuation/stranded/pod11
/area/almayer/evacuation/stranded/pod12
/area/almayer/evacuation/stranded/pod13
/area/almayer/evacuation/stranded/pod14
/area/almayer/evacuation/stranded/pod15
/area/almayer/evacuation/stranded/pod16
/area/almayer/evacuation/stranded/pod17
/area/almayer/evacuation/stranded/pod18
