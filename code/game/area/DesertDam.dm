//Base Instance
/area/desert_dam
	name = "沙漠大坝"
	icon_state = "cliff_blocked"
	can_build_special = TRUE
	powernet_name = "ground"
	ambience_exterior = AMBIENCE_TRIJENT
	minimap_color = MINIMAP_AREA_COLONY

//INTERIOR
// areas under rock
/area/desert_dam/interior
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
//NorthEastern Lab Section
/area/desert_dam/interior/lab_northeast
	name = "东北实验室"
	icon_state = "purple"
	minimap_color = MINIMAP_AREA_RESEARCH
/area/desert_dam/interior/lab_northeast/east_lab_lobby
	name = "东部实验室大厅"
	icon_state = "green"
/area/desert_dam/interior/lab_northeast/east_lab_west_hallway
	name = "东部实验室西走廊"
	icon_state = "blue"
/area/desert_dam/interior/lab_northeast/east_lab_central_hallway
	name = "东部实验室中央走廊"
	icon_state = "green"
/area/desert_dam/interior/lab_northeast/east_lab_east_hallway
	name = "东部实验室东走廊"
	icon_state = "yellow"
/area/desert_dam/interior/lab_northeast/east_lab_workshop
	name = "东部实验室工坊"
	icon_state = "ass_line"
/area/desert_dam/interior/lab_northeast/east_lab_storage
	name = "东部实验室储藏室"
	icon_state = "storage"
/area/desert_dam/interior/lab_northeast/east_lab_RD_office
	name = "东部实验室研究主管办公室"
	icon_state = "yellow"
/area/desert_dam/interior/lab_northeast/east_lab_maintenence
	name = "东部实验室维护区"
	icon_state = "maintcentral"
/area/desert_dam/interior/lab_northeast/east_lab_containment
	name = "东部实验室收容区"
	icon_state = "purple"
/area/desert_dam/interior/lab_northeast/east_lab_RND
	name = "东部实验室研发区"
	icon_state = "purple"
/area/desert_dam/interior/lab_northeast/east_lab_biology
	name = "东部实验室生物学区"
	icon_state = "purple"
/area/desert_dam/interior/lab_northeast/east_lab_surgery
	name = "东部实验室手术室"
	icon_state = "red"
/area/desert_dam/interior/lab_northeast/east_lab_excavation
	name = "东部实验室挖掘准备区"
	icon_state = "blue"
/area/desert_dam/interior/lab_northeast/east_lab_west_entrance
	name = "东部实验室西入口"
	icon_state = "purple"
/area/desert_dam/interior/lab_northeast/east_lab_east_entrance
	name = "东部实验室入口"
	icon_state = "purple"
/area/desert_dam/interior/lab_northeast/east_lab_security_checkpoint
	name = "东部实验室安保检查站"
	icon_state = "purple"
/area/desert_dam/interior/lab_northeast/east_lab_security_office
	name = "东部实验室安保办公室"
	icon_state = "security"
/area/desert_dam/interior/lab_northeast/east_lab_security_armory
	name = "东部实验室军械库"
	icon_state = "armory"
/area/desert_dam/interior/lab_northeast/east_lab_xenobiology
	name = "东部实验室异星生物学区"
	icon_state = "red"

//Dam Interior
/area/desert_dam/interior/dam_interior
	minimap_color = MINIMAP_AREA_ENGI

/area/desert_dam/interior/dam_interior/engine_room
	name = "工程部发电机室"
	icon_state = "yellow"
/area/desert_dam/interior/dam_interior/control_room
	name = "工程部控制室"
	icon_state = "red"
/area/desert_dam/interior/dam_interior/smes_main
	name = "工程部主变电站"
	icon_state = "purple"
/area/desert_dam/interior/dam_interior/smes_backup
	name = "工程部次级备用变电站"
	icon_state = "green"
/area/desert_dam/interior/dam_interior/engine_east_wing
	name = "工程部东侧引擎区"
	icon_state = "blue-red"
/area/desert_dam/interior/dam_interior/engine_west_wing
	name = "工程部西侧引擎区"
	icon_state = "yellow"
/area/desert_dam/interior/dam_interior/lobby
	name = "工程部大厅"
	icon_state = "purple"
/area/desert_dam/interior/dam_interior/atmos_storage
	name = "工程部气体储存区"
	icon_state = "purple"
/area/desert_dam/interior/dam_interior/northwestern_tunnel
	name = "工程部西北隧道"
	icon_state = "green"
/area/desert_dam/interior/dam_interior/north_tunnel
	name = "工程部北部隧道"
	icon_state = "blue-red"
/area/desert_dam/interior/dam_interior/west_tunnel
	name = "工程部西部隧道"
	icon_state = "yellow"
/area/desert_dam/interior/dam_interior/central_tunnel
	name = "工程部中央隧道"
	icon_state = "red"
/area/desert_dam/interior/dam_interior/south_tunnel
	name = "工程部南部隧道"
	icon_state = "purple"
/area/desert_dam/interior/dam_interior/northeastern_tunnel
	name = "工程部东北隧道"
	icon_state = "green"
/area/desert_dam/interior/dam_interior/CE_office
	name = "工程部总工程师办公室"
	icon_state = "yellow"
/area/desert_dam/interior/dam_interior/workshop
	name = "工程部工坊"
	icon_state = "purple"
/area/desert_dam/interior/dam_interior/hanger
	name = "工程部机库"
	icon_state = "hangar"
/area/desert_dam/interior/dam_interior/hangar_storage
	name = "工程部机库储藏室"
	icon_state = "storage"
/area/desert_dam/interior/dam_interior/auxilary_tool_storage
	name = "工程部辅助工具储藏室"
	icon_state = "red"
/area/desert_dam/interior/dam_interior/primary_tool_storage
	name = "工程部主要工具储藏室"
	icon_state = "blue"
/area/desert_dam/interior/dam_interior/tech_storage
	name = "工程部安全技术器材储藏室"
	icon_state = "dark"
/area/desert_dam/interior/dam_interior/break_room
	name = "工程部休息室"
	icon_state = "yellow"
/area/desert_dam/interior/dam_interior/disposals
	name = "工程部废物处理区"
	icon_state = "disposal"
/area/desert_dam/interior/dam_interior/western_dam_cave
	name = "工程部西入口"
	icon_state = "red"
/area/desert_dam/interior/dam_interior/office
	name = "工程部办公室"
	icon_state = "red"
/area/desert_dam/interior/dam_interior
	name = "工程部"
	icon_state = ""

/area/desert_dam/interior/dam_interior/north_tunnel_entrance
	name = "工程部北部隧道入口"
	icon_state = "yellow"
/area/desert_dam/interior/dam_interior/east_tunnel_entrance
	name = "工程部东部隧道入口"
	icon_state = "yellow"
/area/desert_dam/interior/dam_interior/south_tunnel_entrance
	name = "工程部南部隧道入口"
	icon_state = "red"
/area/desert_dam/interior/dam_interior/garage
	name = "车库"
	icon_state = "green"
/area/desert_dam/interior/caves
	name = "洞穴"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "red"
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	minimap_color = MINIMAP_AREA_CAVES
/area/desert_dam/interior/caves/northern_caves
	name = "北部洞穴"
	icon_state = "red"
/area/desert_dam/interior/caves/east_caves
	name = "东部洞穴"
	icon_state = "red"

/area/desert_dam/interior/caves/central_caves
	name = "中央洞穴"
	icon_state = "yellow"
/area/desert_dam/interior/caves/central_caves/entrances/east_tunnel_entrance
	name = "中央隧道东入口"
	icon_state = "red"
/area/desert_dam/interior/caves/central_caves/entrances/south_tunnel_entrance
	name = "中央隧道南入口"
	icon_state = "red"
/area/desert_dam/interior/caves/central_caves/entrances/west_tunnel_entrance
	name = "中央隧道西入口"
	icon_state = "red"

/area/desert_dam/interior/caves/temple
	name = "沙之神庙"
	icon_state = "green"

//BUILDING
//areas not under rock
// ceiling = CEILING_METAL
/area/desert_dam/building
	ceiling = CEILING_METAL
//Substations
/area/desert_dam/building/substation
	name = "变电站"
	icon = 'icons/turf/dam_areas.dmi'
	minimap_color = MINIMAP_AREA_ENGI

/area/desert_dam/building/substation/northwest
	name = "指挥区变电站"
	icon_state = "northewestern_ss"
	is_landing_zone = TRUE
/area/desert_dam/building/substation/northeast
	name = "指挥区变电站"
	icon_state = "northeastern_ss"
/area/desert_dam/building/substation/east
	name = "指挥区变电站"
	icon_state = "eastern_ss"
/area/desert_dam/building/substation/southeast
	name = "指挥区变电站"
	icon_state = "southeastern_ss"
/area/desert_dam/building/substation/central
	name = "指挥区变电站"
	icon_state = "central_ss"
/area/desert_dam/building/substation/southwest
	name = "指挥区变电站"
	icon_state = "southwestern_ss"
/area/desert_dam/building/substation/west
	name = "指挥区变电站"
	icon_state = "western_ss"
	is_resin_allowed = FALSE

//Administration
/area/desert_dam/building/administration
	minimap_color = MINIMAP_AREA_COMMAND

/area/desert_dam/building/administration/control_room
	name = "行政部着陆控制室"
	icon_state = "yellow"
	is_resin_allowed = FALSE
/area/desert_dam/building/administration/lobby
	name = "行政部大厅"
	icon_state = "green"
	is_resin_allowed = FALSE
/area/desert_dam/building/administration/hallway
	name = "行政部走廊"
	icon_state = "purple"
	is_resin_allowed = FALSE
/area/desert_dam/building/administration/office
	name = "行政办公室"
	icon_state = "blue-red"
	is_resin_allowed = FALSE
/area/desert_dam/building/administration/overseer_office
	name = "行政部监管员办公室"
	icon_state = "red"
	is_resin_allowed = FALSE
/area/desert_dam/building/administration/meetingrooom
	name = "行政部会议室"
	icon_state = "yellow"
	is_resin_allowed = FALSE
/area/desert_dam/building/administration/archives
	name = "行政部档案室"
	icon_state = "green"
	is_resin_allowed = FALSE


//Bar
/area/desert_dam/building/bar/bar
	name = "酒吧"
	icon_state = "yellow"
/area/desert_dam/building/bar/backroom
	name = "酒吧后屋"
	icon_state = "green"
/area/desert_dam/building/bar/bar_restroom
	name = "酒吧卫生间"
	icon_state = "purple"


//Cafe
/area/desert_dam/building/cafeteria/cafeteria
	name = "餐厅"
	icon_state = "yellow"
/area/desert_dam/building/cafeteria/backroom
	name = "餐厅后屋"
	icon_state = "green"
/area/desert_dam/building/cafeteria/restroom
	name = "餐厅卫生间"
	icon_state = "purple"
/area/desert_dam/building/cafeteria/loading
	name = "餐厅装卸间"
	icon_state = "blue-red"
/area/desert_dam/building/cafeteria/cold_room
	name = "餐厅冷库"
	icon_state = "red"


//Dorms
/area/desert_dam/building/dorms/hallway_northwing
	name = "宿舍北翼"
	icon_state = "yellow"
/area/desert_dam/building/dorms/hallway_westwing
	name = "宿舍西翼"
	icon_state = "green"
/area/desert_dam/building/dorms/hallway_eastwing
	name = "宿舍东翼"
	icon_state = "purple"
/area/desert_dam/building/dorms/restroom
	name = "宿舍淋浴间"
	icon_state = "blue-red"
/area/desert_dam/building/dorms/pool
	name = "宿舍泳池室"
	icon_state = "red"


//Medical
/area/desert_dam/building/medical
	minimap_color = MINIMAP_AREA_MEDBAY

/area/desert_dam/building/medical/garage
	name = "医疗部车库"
	icon_state = "garage"
/area/desert_dam/building/medical/emergency_room
	name = "医疗部急诊室"
	icon_state = "medbay"
/area/desert_dam/building/medical/treatment_room
	name = "医疗部治疗室"
	icon_state = "medbay2"
/area/desert_dam/building/medical/lobby
	name = "医疗部大厅"
	icon_state = "medbay3"
/area/desert_dam/building/medical/chemistry
	name = "医疗部药房"
	icon_state = "medbay"
/area/desert_dam/building/medical/west_wing_hallway
	name = "医疗部西翼"
	icon_state = "medbay2"
/area/desert_dam/building/medical/north_wing_hallway
	name = "医疗部北翼"
	icon_state = "medbay3"
/area/desert_dam/building/medical/east_wing_hallway
	name = "医疗部东翼"
	icon_state = "medbay"
/area/desert_dam/building/medical/primary_storage
	name = "医疗部主储藏室"
	icon_state = "red"
/area/desert_dam/building/medical/surgery_room_one
	name = "医疗部1号手术室"
	icon_state = "yellow"
/area/desert_dam/building/medical/surgery_room_two
	name = "医疗部2号手术室"
	icon_state = "purple"
/area/desert_dam/building/medical/surgury_observation
	name = "医疗部手术观察室"
	icon_state = "medbay2"
/area/desert_dam/building/medical/morgue
	name = "医疗部停尸房"
	icon_state = "blue"
/area/desert_dam/building/medical/break_room
	name = "医疗部休息室"
	icon_state = "medbay"
/area/desert_dam/building/medical/CMO
	name = "医疗部首席医疗官办公室"
	icon_state = "CMO"
/area/desert_dam/building/medical/office1
	name = "医疗部1号办公室"
	icon_state = "red"
/area/desert_dam/building/medical/office2
	name = "医疗部2号办公室"
	icon_state = "blue"
/area/desert_dam/building/medical/patient_wing
	name = "医疗部病房区"
	icon_state = "medbay2"
/area/desert_dam/building/medical/virology_wing
	name = "医疗部病毒学区"
	icon_state = "medbay3"
/area/desert_dam/building/medical/virology_isolation
	name = "医疗部病毒隔离区"
	icon_state = "medbay"
/area/desert_dam/building/medical
	name = "医疗部"
	icon_state = "medbay2"


//Warehouse
/area/desert_dam/building/warehouse/warehouse
	name = "仓库"
	icon_state = "yellow"
	is_resin_allowed = FALSE
/area/desert_dam/building/warehouse/loading
	name = "仓库装卸间"
	icon_state = "red"
	is_resin_allowed = FALSE
/area/desert_dam/building/warehouse/breakroom
	name = "仓库休息室"
	icon_state = "green"
	is_resin_allowed = FALSE


//Hydroponics
/area/desert_dam/building/hydroponics
	minimap_color = MINIMAP_AREA_RESEARCH

/area/desert_dam/building/hydroponics/hydroponics
	name = "水培区"
	icon_state = "hydro"
/area/desert_dam/building/hydroponics/hydroponics_storage
	name = "水培储藏室"
	icon_state = "green"
/area/desert_dam/building/hydroponics/hydroponics_loading
	name = "水培装卸间"
	icon_state = "garage"
/area/desert_dam/building/hydroponics/hydroponics_breakroom
	name = "水培休息室"
	icon_state = "red"


//Telecoms
/area/desert_dam/building/telecommunication
	name = "电信室"
	icon_state = "yellow"
	is_resin_allowed = FALSE

//Water Treatment Plant 1
/area/desert_dam/building/water_treatment_one
	minimap_color = MINIMAP_AREA_ENGI

/area/desert_dam/building/water_treatment_one
	name = "1号水处理厂"
	icon_state = "yellow"
//Water Treatment Plant 1
/area/desert_dam/building/water_treatment_one/lobby
	name = "1号水处理厂大厅"
	icon_state = "red"
/area/desert_dam/building/water_treatment_one/breakroom
	name = "1号水处理厂休息室"
	icon_state = "green"
/area/desert_dam/building/water_treatment_one/garage
	name = "1号水处理厂车库"
	icon_state = "garage"
/area/desert_dam/building/water_treatment_one/sedimentation
	name = "1号水处理厂沉淀区"
	icon_state = "blue"
/area/desert_dam/building/water_treatment_one/equipment
	name = "1号水处理厂设备间"
	icon_state = "red"
/area/desert_dam/building/water_treatment_one/hallway
	name = "1号水处理厂走廊"
	icon_state = "purple"
/area/desert_dam/building/water_treatment_one/control_room
	name = "1号水处理厂控制室"
	icon_state = "yellow"
/area/desert_dam/building/water_treatment_one/purification
	name = "1号水处理厂净化区"
	icon_state = "green"
/area/desert_dam/building/water_treatment_one/floodgate_control
	name = "1号水处理厂水闸控制室"
	icon_state = "green"

/area/desert_dam/building/water_treatment_one/floodgate_control/central
	name = "中央水闸控制室"
	icon_state = "green"

/area/desert_dam/building/water_treatment_one/floodgate_control/central2
	name = "中央水闸控制室储藏间"
	icon_state = "green"

//Water Treatment Plant 2
/area/desert_dam/building/water_treatment_two
	minimap_color = MINIMAP_AREA_ENGI

/area/desert_dam/building/water_treatment_two
	name = "2号水处理厂"
	icon_state = "yellow"
/area/desert_dam/building/water_treatment_two/lobby
	name = "2号水处理厂大厅"
	icon_state = "red"
/area/desert_dam/building/water_treatment_two/breakroom
	name = "2号水处理厂休息室"
	icon_state = "green"
/area/desert_dam/building/water_treatment_two/garage
	name = "2号水处理厂车库"
	icon_state = "garage"
/area/desert_dam/building/water_treatment_two/sedimentation
	name = "2号水处理厂沉淀区"
	icon_state = "blue"
/area/desert_dam/building/water_treatment_two/equipment
	name = "2号水处理厂设备间"
	icon_state = "red"
/area/desert_dam/building/water_treatment_two/hallway
	name = "2号水处理厂走廊"
	icon_state = "purple"
/area/desert_dam/building/water_treatment_two/control_room
	name = "2号水处理厂控制室"
	icon_state = "yellow"
/area/desert_dam/building/water_treatment_two/purification
	name = "2号水处理厂净化区"
	icon_state = "green"
/area/desert_dam/building/water_treatment_two/floodgate_control
	name = "2号水处理厂水闸控制室"
	icon_state = "green"


//Library UNUSED
/*
/area/desert_dam/building/library/library
	name = "Library"
	icon_state = "library"
/area/desert_dam/building/library/restroom
	name = "Library Restroom"
	icon_state = "green"
/area/desert_dam/building/library/studyroom
	name = "Library Study Room"
	icon_state = "purple"
*/

//Security
/area/desert_dam/building/security
	minimap_color = MINIMAP_AREA_SEC

/area/desert_dam/building/security/prison
	name = "安保部监狱"
	icon_state = "sec_prison"
/area/desert_dam/building/security/marshals_office
	name = "安保部法警办公室"
	icon_state = "sec_hos"
/area/desert_dam/building/security/armory
	name = "安保部军械库"
	icon_state = "armory"
/area/desert_dam/building/security/warden
	name = "安保部监狱长办公室"
	icon_state = "Warden"
/area/desert_dam/building/security/interrogation
	name = "安保部审讯室"
	icon_state = "interrogation"
/area/desert_dam/building/security/backroom
	name = "安保部审讯室"
	icon_state = "sec_backroom"
/area/desert_dam/building/security/observation
	name = "安保部观察室"
	icon_state = "observatory"
/area/desert_dam/building/security/detective
	name = "安保部侦探办公室"
	icon_state = "detective"
/area/desert_dam/building/security/office
	name = "安保办公室"
	icon_state = "yellow"
/area/desert_dam/building/security/lobby
	name = "安保部大厅"
	icon_state = "green"
/area/desert_dam/building/security/northern_hallway
	name = "安保部北走廊"
	icon_state = "purple"
/area/desert_dam/building/security/courtroom
	name = "安保部法庭"
	icon_state = "courtroom"
/area/desert_dam/building/security/evidence
	name = "安保部证物室"
	icon_state = "red"
/area/desert_dam/building/security/holding
	name = "安保部拘留室"
	icon_state = "yellow"
/area/desert_dam/building/security/southern_hallway
	name = "安保部南走廊"
	icon_state = "green"
/area/desert_dam/building/security/deathrow
	name = "安保部死囚区"
	icon_state = "cells_max_n"
/area/desert_dam/building/security/execution_chamber
	name = "安保部行刑室"
	icon_state = "red"
/area/desert_dam/building/security/staffroom
	name = "安保部员工休息室"
	icon_state = "security"

//Church
/area/desert_dam/building/church
	name = "教堂"
	icon_state = "courtroom"
	is_resin_allowed = FALSE

//Mining area
/area/desert_dam/building/mining/workshop
	name = "采矿工坊"
	icon_state = "yellow"
/area/desert_dam/building/mining/workshop_foyer
	name = "采矿工坊门厅"
	icon_state = "purple"
//Legacy Areas for mining
	/*
/area/desert_dam/building/mining/garage
	name = "Mining Garage"
	icon_state = "garage"
/area/desert_dam/building/mining/boxing_room
	name = "Mining Boxing Room"
	icon_state = "red"
/area/desert_dam/building/mining/loading_room
	name = "Mining Loading Bay"
	icon_state = "yellow"
/area/desert_dam/building/mining/break_room
	name = "Mining Breakroom"
	icon_state = "purple"
/area/desert_dam/building/mining/locker_room
	name = "Mining Locker Room"
	icon_state = "green"
/area/desert_dam/building/mining/lobby
	name = "Mining Lobby"
	icon_state = "red"
/area/desert_dam/building/mining/front_desk
	name = "Mining Front Desk"
	icon_state = "green"
/area/desert_dam/building/mining/foremans_office
	name = "Mining Foreman's Office"
	icon_state = "yellow"
/area/desert_dam/building/mining/maintenance_north
	name = "Mining Maintenance North"
	icon_state = "dark160"
/area/desert_dam/building/mining/maintenance_east
	name = "Mining Maintenance East"
	icon_state = "dark128"
/area/desert_dam/building/mining/bunkhouse
	name = "Mining Bunkhouse"
	icon_state = "red"
/area/desert_dam/building/mining/construction_site
	name = "Construction Site"
	icon_state = "yellow"
*/


//NorthWest Lab Buildings
/area/desert_dam/building/lab_northwest
	minimap_color = MINIMAP_AREA_RESEARCH

/area/desert_dam/building/lab_northwest/west_lab_robotics
	name = "西部实验室机器人技术区"
	icon_state = "ass_line"
/area/desert_dam/building/lab_northwest/west_lab_robotics_mechbay
	name = "西部实验室机甲库"
	icon_state = "purple"
/area/desert_dam/building/lab_northwest/west_lab_east_hallway
	name = "西部实验室走廊"
	icon_state = "red"
/area/desert_dam/building/lab_northwest/west_lab_west_hallway
	name = "西部实验室走廊"
	icon_state = "red"
/area/desert_dam/building/lab_northwest/west_lab_maintenance
	name = "西部实验室维护区"
	icon_state = "purple"
/area/desert_dam/building/lab_northwest/west_lab_chemistry
	name = "西部实验室化学区"
	icon_state = "yellow"
/area/desert_dam/building/lab_northwest/west_lab_cafeteria
	name = "西部实验室餐厅"
	icon_state = "blue"
/area/desert_dam/building/lab_northwest/west_lab_kitchen
	name = "西部实验室厨房"
	icon_state = "kitchen"
/area/desert_dam/building/lab_northwest/west_lab_dormitory
	name = "西部实验室宿舍"
	icon_state = "red"
/area/desert_dam/building/lab_northwest/west_lab_meeting_room
	name = "西部实验室会议室"
	icon_state = "purple"
/area/desert_dam/building/lab_northwest/west_lab_xenoflora
	name = "西部实验室异星植物区"
	icon_state = "purple"
/area/desert_dam/building/lab_northeast/checkpoint
	name = "东部实验室检查站"
	icon_state = "red"
/area/desert_dam/building/lab_northeast/garage
	name = "东部实验室车库"
	icon_state = "garage"


//EXTERIOR
//under open sky
/area/desert_dam/exterior
	requires_power = 1
	always_unpowered = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE

	//ambience = list('sound/ambience/ambiatm1.ogg')

/area/desert_dam/exterior/rock
	name = "岩石区"
	icon_state = "cave"

//Landing Pad for the Alamo. THIS IS NOT THE SHUTTLE AREA
/area/desert_dam/exterior/landing_pad_one
	name = "简易跑道着陆坪"
	icon_state = "landing_pad"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/desert_dam/exterior/landing_pad_one_external
	name = "简易跑道着陆谷地"
	icon_state = "landing_pad_ext"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ


//Landing Pad for the Normandy. THIS IS NOT THE SHUTTLE AREA
/area/desert_dam/exterior/landing_pad_two
	name = "机场着陆坪"
	icon_state = "landing_pad"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/desert_dam/exterior/landing_pad_two_external
	name = "机场着陆谷地"
	icon_state = "landing_pad_ext"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

//Valleys
//Near LZ
//TODO: incorporate valleys and substrations for floodlight coverage

/area/desert_dam/exterior/valley
/area/desert_dam/exterior/valley/valley_northwest
	name = "西北谷地"
	icon_state = "valley_north_west"
	is_resin_allowed = FALSE
/area/desert_dam/exterior/valley/valley_cargo
	name = "货运谷地"
	icon_state = "valley_south_west"
	is_resin_allowed = FALSE
/area/desert_dam/exterior/valley/valley_telecoms
	name = "电信站谷地"
	icon_state = "valley_west"
	is_resin_allowed = FALSE

// Generic bridge used in nightmare inserts... Can in fact be different places (sigh)
/area/desert_dam/exterior/valley/valley_bridge
	name = "谷地大桥"
	icon_state = "valley"


//telecomms areas
/area/desert_dam/exterior/telecomm
	name = "\improper 特里金特大坝通信中继站"
	icon_state = "ass_line"
	is_resin_allowed = FALSE
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_LOW
	always_unpowered = 0

/area/desert_dam/exterior/telecomm/lz2_containers
	name = "\improper 集装箱区通信中继站"

/area/desert_dam/exterior/telecomm/lz2_tcomms
	name = "\improper 电信站通信中继站"

/area/desert_dam/exterior/telecomm/lz2_storage
	name = "\improper 2号着陆区东部通信中继站"

/area/desert_dam/exterior/telecomm/lz1_south
	name = "\improper 1号着陆区南部通信中继站"

/area/desert_dam/exterior/telecomm/lz1_valley
	name = "\improper 1号着陆区谷地通信中继站"

/area/desert_dam/exterior/telecomm/lz1_xenoflora
	name = "\improper 异星植物区通信中继站"

//Away from LZ

/area/desert_dam/exterior/valley/valley_labs
	name = "实验室谷地"
	icon_state = "valley_north"
/area/desert_dam/exterior/valley/valley_mining
	name = "采矿谷地"
	icon_state = "valley_east"
/area/desert_dam/exterior/valley/valley_civilian
	name = "平民区谷地"
	icon_state = "valley_south_excv"
/area/desert_dam/exterior/valley/valley_medical
	name = "医疗区谷地"
	icon_state = "valley"
/area/desert_dam/exterior/valley/valley_hydro
	name = "水培区谷地"
	icon_state = "valley"
/area/desert_dam/exterior/valley/valley_crashsite
	name = "坠毁现场谷地"
	icon_state = "yellow"
/area/desert_dam/exterior/valley/north_valley_dam
	name = "大坝北部谷地"
	icon_state = "valley"
/area/desert_dam/exterior/valley/south_valley_dam
	name = "大坝南部谷地"
	icon_state = "valley"
/area/desert_dam/exterior/valley/bar_valley_dam
	name = "酒吧谷地"
	icon_state = "yellow"
/area/desert_dam/exterior/valley/valley_wilderness
	name = "荒野谷地"
	icon_state = "central"


//Rivers
/area/desert_dam/exterior/river
	name = "河流"
	icon_state = "bluenew"
	var/filtered = 0
	var/list/Next_areas = list()//The next river to update - that is, unless...
	var/obj/structure/machinery/console/toggle/Floodgate = null //If there's a floodgate at the end of us, this is it's ID

/area/desert_dam/exterior/river/proc/check_filtered()
	var/turf/open/gm/river/desert/R
	if(filtered)
		for(R in src)
			R.toxic = 0
	else
		for(R in src)
			R.toxic = 1
	R.update_icon()
	if(Next_areas && !(src in Next_areas)) //Shouldn't ever happen but just to be safe
		for(var/area/desert_dam/exterior/river/A in Next_areas)
			A.check_filtered()



//End of the river areas, no Next
/area/desert_dam/exterior/river/riverside_northwest
	name = "西北河床"
	icon_state = "bluenew"
/area/desert_dam/exterior/river/riverside_central_north
	name = "中北部河床"
	icon_state = "purple"
/area/desert_dam/exterior/river/riverside_central_south
	name = "中南部河床"
	icon_state = "purple"
/area/desert_dam/exterior/river/riverside_south
	name = "南部河床"
	icon_state = "bluenew"
/area/desert_dam/exterior/river/riverside_east
	name = "东部河床"
	icon_state = "bluenew"
/area/desert_dam/exterior/river/riverside_northeast
	name = "东北河床"
	icon_state = "bluenew"
//The filtration plants - This area isn't for the WHOLE plant, but the areas that have water in them, so the water changes color as well.

/area/desert_dam/exterior/river/filtration_a
	name = "A号过滤厂"

/area/desert_dam/exterior/river/filtration_b
	name = "B号过滤厂"

//Areas that are rivers, but will not change because they're before the floodgates
/area/desert_dam/exterior/river_mouth/southern
	name = "南部河口"
	icon_state = "purple"

/area/desert_dam/exterior/river_mouth/eastern
	name = "东部河口"
	icon_state = "purple"

/area/desert_dam/landing/console
	name = "1号着陆区“行政部”"
	icon_state = "tcomsatcham"
	requires_power = 0

/area/desert_dam/landing/console2
	name = "2号着陆区“补给”"
	icon_state = "tcomsatcham"
	requires_power = 0


//Transit Shuttle
/area/shuttle/tri_trans1/alpha
	icon_state = "shuttle"
/area/shuttle/tri_trans1/away
	icon_state = "away1"
/area/shuttle/tri_trans1/omega
	icon_state = "shuttle2"

/area/shuttle/tri_trans2/alpha
	icon_state = "shuttlered"
/area/shuttle/tri_trans2/away
	icon_state = "away2"
/area/shuttle/tri_trans2/omega
	icon_state = "shuttle2"
