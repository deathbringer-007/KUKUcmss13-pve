
//Areas for the Sorokyne Strata (aka Carp Lake.dm)

/* AG in a path stands for ABOVE GROUND, while UG stands for underground.
After that, all areas are sorted by EXTERIOR or INTERIOR. With INTERIOR being any area that isn't nippy and cold. (All buildings & jungle caves)
EXTERIOR is FUCKING FREEZING, and refers to areas out in the open and or exposed to the elements.
*/

/area/strata
	name = "索罗基内地层"
	icon = 'icons/turf/area_strata.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "strata"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	temperature = SOROKYNE_TEMPERATURE //If not in a building, it'll be cold. All interior areas are set to T20C
	minimap_color = MINIMAP_AREA_COLONY

/area/shuttle/drop1/strata //Not in Sulaco.DM because holy shit we need to sort things.
	name = "阿拉莫运输艇着陆区"
	icon_state = "shuttle"
	base_lighting_alpha = 255
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/shuttle/drop2/strata
	name = "诺曼底运输艇着陆区"
	icon_state = "shuttle2"
	base_lighting_alpha = 255
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/strata/ag
	name = "地上区域"
	icon_state = "ag"

/area/strata/ag/exterior
	name = "地上室外区域"
	icon_state = "ag_e"
	//always_unpowered = 1 So exterior lights work, this will be commented out unless it causes unforseen issues.
	is_resin_allowed = FALSE

/area/strata/ag/exterior/paths
	is_resin_allowed = TRUE

/area/strata/ag/exterior/restricted
	flags_area = AREA_NOTUNNEL

/area/strata/ag/interior
	name = "地上室内区域"
	icon_state = "ag_i"
	requires_power = 1
	temperature = T20C //Nice and room temp
	ceiling = CEILING_METAL

/area/strata/ag/interior/mountain
	name = "山体外侧"
	icon_state = "ag_e"

/area/strata/ag/interior/restricted
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

/area/strata/ag/interior/restricted/devroom
	name = "超级秘密制作人员名单室"

/area/strata/ug
	name = "地下区域"
	icon_state = "ug"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/strata/ug/interior
	name = "地下室内区域"
	icon_state = "ug_i"
	requires_power = 1
	temperature = T20C

/area/strata/ug/exterior
	name = "地下室外区域"
	icon_state = "ug_i"
	requires_power = 1
	temperature = T20C
	ceiling = CEILING_NONE

//END PARENT ENTITIES

//Begin actual area definitions. There's probably a better way to do this.

//Landing Zones, places near LZs (Open Air, Above Ground)

/area/strata/ag/interior/landingzone_1
	name = "1号着陆平台——采矿航空港"
	icon_state = "landingzone_1"
	weather_enabled = FALSE
	unlimited_power = 1 //So the DS computer always works for the Queen
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/strata/ag/exterior/landingzone_2
	name = "2号着陆平台——冰原"
	icon_state = "landingzone_2"
	weather_enabled = FALSE
	unlimited_power = 1 //So the DS computer always works for the Queen
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/strata/ag/interior/nearlz1
	name = "1号着陆区——采矿航空港"
	icon_state = "nearlz1"
	weather_enabled = FALSE
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

/area/strata/ag/exterior/nearlz2
	name = "2号着陆区——冰原"
	icon_state = "nearlz2"
	weather_enabled = TRUE //This LZ is outside, but consider disabling if it destroys the meta.
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/strata/ag/exterior/landingzone_valley
	name = "着陆区山谷"
	icon_state = "lzvalley"

/area/strata/ag/exterior/landingzone_lake
	name = "着陆区湖面冰层"
	icon_state = "lzfrozenlake"

/area/strata/ag/exterior/landingzone_water
	name = "着陆区湖泊水域"
	icon_state = "lzfrozenwater"
	temperature = TCMB //Cold enough to kill through protective clothing.

/////Research Station//////

/area/strata/ag/exterior/research_decks
	name = "哨站平台"
	icon_state = "rdecks"
	is_resin_allowed = TRUE
	minimap_color = MINIMAP_AREA_RESEARCH

/area/strata/ag/exterior/research_decks/center //The decks on the deck.
	name = "哨站次级平台"

/area/strata/ag/exterior/research_decks/pipes //pipemaze thingy
	name = "哨站平台管道区"
	icon_state = "security_station"

/area/strata/ag/interior/research_decks/security //For all security stuff outside the outpost.
	name = "哨站平台安检站"
	icon_state = "rdecks_sec"

/area/strata/ag/exterior/paths/north_outpost //The area north of the outpost
	name = "哨站北通道"
	icon_state = "outpost_gen_2"

////////close to research/////////

/area/strata/ag/exterior/paths/southresearch
	minimap_color = MINIMAP_AREA_RESEARCH
	name = "哨站南侧"

/area/strata/ag/exterior/shed_five_caves
	name = "5号终端上方洞穴"
	icon_state = "lzcaves"
	is_resin_allowed = TRUE

////////Telecomms//////////////////

/area/strata/ag/interior/tcomms/ //T-Comms is inside until you leave the sheltered area..
	name = "中继站"
	icon_state = "tcomms1"

/area/strata/ag/interior/tcomms/tcomms_engi
	name = "中继站维护区"
	icon_state = "tcomms2"

/area/strata/ag/exterior/tcomms/tcomms_cave
	name = "中继站洞穴"
	icon_state = "tcomms3"

/area/strata/ag/exterior/tcomms/tcomms_deck
	name = "中继站储藏平台"
	icon_state = "tcomms4"

//JUNGLE CAVES, ALL UNDERGROUND, ALL INTERIOR//

/area/strata/ug/interior/jungle
	name = "深层I区"

//Maintenance/Generator Sheds (Above & Below Ground)
//Terminals are below ground, Sheds are above ground.

/area/strata/ag/interior/engi_shed //Above ground parent
	name = "engi_shed AG parent"
	icon_state = "shed_x_ag"

/area/strata/ug/interior/engi_shed //Below ground parent
	name = "engi_shed UG parent"
	icon_state = "shed_x_ug"

///Engineering Terminals / Sheds, whatever. Map Power///
/area/strata/ag/interior/engi_shed
	minimap_color = MINIMAP_AREA_ENGI

/area/strata/ag/interior/engi_shed/one
	name = "1号发电机棚"
	icon_state = "shed_1_ag"
	ceiling = CEILING_METAL

/area/strata/ug/interior/engi_shed/one
	name = "1号发电终端"
	icon_state = "shed_1_ug"

/area/strata/ag/interior/engi_shed/two
	name = "2号发电机棚"
	icon_state = "shed_2_ag"

/area/strata/ug/interior/engi_shed/two
	name = "2号发电终端"
	icon_state = "shed_2_ug"

/area/strata/ag/interior/engi_shed/three
	name = "3号发电机棚"
	icon_state = "shed_3_ag"

/area/strata/ug/interior/engi_shed/three
	name = "3号发电终端"
	icon_state = "shed_3_ug"

/area/strata/ag/interior/engi_shed/four
	name = "4号发电机棚"
	icon_state = "shed_4_ag"

/area/strata/ug/interior/engi_shed/four
	name = "4号发电终端"
	icon_state = "shed_4_ug"

/area/strata/ag/interior/engi_shed/five
	name = "5号发电机棚"
	icon_state = "shed_5_ag"

/area/strata/ug/interior/engi_shed/five
	name = "5号发电终端"
	icon_state = "shed_5_ug"

/area/strata/ag/interior/engi_shed/six
	name = "6号发电机棚"
	icon_state = "shed_6_ag"

/area/strata/ug/interior/engi_shed/six
	name = "6号发电终端"
	icon_state = "shed_6_ug"

/area/strata/ag/interior/engi_shed/seven
	name = "7号发电机棚"
	icon_state = "shed_7_ag"

/area/strata/ug/interior/engi_shed/seven
	name = "7号发电终端"
	icon_state = "shed_7_ug"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/strata/ag/interior/engi_shed/eight
	name = "8号发电机棚"
	icon_state = "shed_8_ag"

/area/strata/ug/interior/engi_shed/eight
	name = "8号发电终端"
	icon_state = "shed_8_ug"


//Topside Structures //Clean these up into a sub tree

/area/strata/ag/interior/landingzone_checkpoint
	name = "着陆区安检站"
	icon_state = "security_station"
	minimap_color = MINIMAP_AREA_SEC

/area/strata/ag/exterior/landingzone_checkpoint_deck
	name = "着陆区安检平台"
	icon_state = "security_station"
	minimap_color = MINIMAP_AREA_SEC

/area/strata/ag/exterior/disposals
	name = "废物处理庭院"
	icon_state = "disposal"

/area/strata/ag/interior/disposals
	name = "废物处理区外伸棚"
	icon_state = "disposal"

/area/strata/ag/interior/vanjam //a jam, just for vans
	name = "飞控车库外伸棚"
	icon_state = "garage"

/area/strata/ag/exterior/vanyard
	name = "飞控车辆场"
	icon_state = "garage"

/area/strata/ag/interior/administration
	name = "飞控办公室"
	icon_state = "offices"
	minimap_color = MINIMAP_AREA_COMMAND

/area/strata/ag/interior/admin_tcomms/ //T-Comms is inside until you leave the sheltered area..
	name = "通信室"
	icon_state = "tcomms1"
	minimap_color = MINIMAP_AREA_COMMAND

/area/strata/ag/exterior/administration_decks
	name = "飞控办公室平台"
	icon_state = "offices"
	minimap_color = MINIMAP_AREA_COMMAND

/area/strata/ag/interior/administrative_wash_closet
	name = "飞控洗手间"
	icon_state = "offices"
	minimap_color = MINIMAP_AREA_COMMAND

/area/strata/ag/interior/dorms
	name = "外围采矿区"
	icon_state = "dorms_0"
	is_resin_allowed = FALSE

/area/strata/ag/interior/dorms/north
	name = "外围采矿区北宿舍"
	icon_state = "dorms_1"

/area/strata/ag/interior/dorms/west
	name = "外围采矿区西宿舍"
	icon_state = "dorms_2"

/area/strata/ag/interior/dorms/south
	name = "外围采矿区南宿舍"
	icon_state = "dorms_3"

/area/strata/ag/exterior/dorms_deck
	name = "外围采矿宿舍平台"
	icon_state = "dorms_2"

/area/strata/ag/interior/dorms/maintenance
	name = "外围采矿宿舍维护区"
	icon_state = "outpost_maint"
	is_resin_allowed = TRUE

/area/strata/ag/interior/dorms/hive
	name = "外围采矿宿舍温控储藏室"
	icon_state = "dorms_beno"
	is_resin_allowed = TRUE

/area/strata/ag/interior/dorms/canteen
	name = "外围采矿宿舍食堂"
	icon_state = "dorms_canteen"

/area/strata/ag/interior/dorms/flight_control
	name = "外围采矿区飞控室"
	icon_state = "dorms_lobby"

/area/strata/ag/interior/dorms/lobby
	name = "外围采矿区大厅"
	icon_state = "dorms_2"

/area/strata/ag/interior/dorms/bar
	name = "外围采矿区酒吧"
	icon_state = "dorms_1"


//More topside areas, somehow these got duplicated?? Includes some parent defs.

//Also marshes

/area/strata/ag/exterior/marsh
	name = "冰热区沼泽"
	icon_state = "marsh"

/area/strata/ag/exterior/marsh/center
	name = "冰热区泉水"
	icon_state = "marshcenter"

/area/strata/ag/exterior/marsh/river
	name = "冰热区河流"
	icon_state = "marshriver"

/area/strata/ag/exterior/marsh/crash
	name = "冰热区坠毁救生艇"
	icon_state = "marshship"

/area/strata/ag/exterior/marsh/water
	name = "冰热区水域"
	icon_state = "marshwater"
	temperature = TCMB //space cold

/area/strata/ag/exterior/north_lz_caves
	name = "外围采矿航空港洞穴"
	icon_state = "lzcaves"

/area/strata/ag/exterior/paths //parent entity, just for sorting within the object tree, if anything, very generic, use as a placeholder.
	name = "冰道"
	icon_state = "path"

/area/strata/ag/exterior/paths/adminext
	name = "飞控室外区"

/area/strata/ag/exterior/paths/dorms_quad //The area between the deck.
	name = "采矿宿舍院落"
	icon_state = "path"
	is_resin_allowed = FALSE

/area/strata/ag/exterior/paths/cabin_area
	name = "哨站远北区域"
	icon_state = "cabin"

/area/strata/ag/exterior/paths/cabin_area/lake
	name = "木屋医院——湖泊"

/area/strata/ag/exterior/paths/cabin_area/shed
	name = "木屋医院——外部棚屋"

/area/strata/ag/exterior/paths/cabin_area/central
	name = "木屋医院——前院"

/area/strata/ag/interior/paths/cabin_area/central
	name = "木屋医院——医院主楼"
	icon_state = "cabin3"

/area/strata/ag/interior/paths/cabin_area/cave
	name = "木屋医院——遗忘通道"
	icon_state = "hive_1"

/area/strata/ag/exterior/paths/cabin_area/minehead
	name = "木屋医院——矿井口"

/area/strata/ug/interior/jungle/deep/minehead
	icon_state = "cabin2"
	name = "密林深处——矿井口"


///OUTPOST INTERIOR///

/area/strata/ag/interior/outpost
	name = "索罗基内哨站"
	icon_state = "research_station"

/area/strata/ag/interior/outpost/gen
	name = "哨站内部"
	icon_state = "outpost_gen_0"

/area/strata/ag/interior/outpost/gen/foyer
	name = "哨站主门厅"
	icon_state = "outpost_gen_1"

/area/strata/ag/interior/outpost/gen/bball //come on and SLAM.
	name = "哨站篮球场"
	icon_state = "outpost_gen_4"

/area/strata/ag/interior/outpost/gen/bball/nest //come on and BURST AND DIE.
	name = "哨站篮球场洞穴"
	icon_state = "hive_1"


///ALL MAINTENANCE AREAS///


/area/strata/ag/interior/outpost/maint
	name = "哨站维护区"
	icon_state = "outpost_maint"

/area/strata/ag/interior/outpost/maint/foyer1
	name = "哨站主门厅北维护区"

/area/strata/ag/interior/outpost/maint/foyer2
	name = "哨站主门厅南维护区"

/area/strata/ag/interior/outpost/maint/med1
	name = "哨站医疗部——行政大厅维护区"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/strata/ag/interior/outpost/maint/med2
	name = "哨站医疗部——主管办公室维护区"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/strata/ag/interior/outpost/maint/med3
	name = "哨站医疗部——行政休息室维护区"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/strata/ag/interior/outpost/maint/sec_west
	name = "哨站安保部——西维护区"

/area/strata/ag/interior/outpost/maint/aerodrome_to_admin
	name = "哨站航空港——西维护区"

/area/strata/ag/interior/outpost/maint/aerodrome_to_jungle
	name = "哨站航空港——南维护区"

/area/strata/ag/interior/outpost/maint/canteen_e_1
	name = "哨站食堂——东维护区"

/area/strata/ag/interior/outpost/maint/canteen_e_2
	name = "哨站食堂——应急口粮储藏室"

/area/strata/ag/interior/outpost/maint/canteen_e_3
	name = "哨站食堂——应急手册储藏室"

/area/strata/ag/interior/outpost/maint/bar
	name = "哨站酒吧——维护区"

///OUTPOST MEDICAL///

/area/strata/ag/interior/outpost/med
	name = "哨站医疗部"
	icon_state = "outpost_med"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/strata/ag/interior/outpost/med/hall
	name = "哨站医疗部主走廊"
	icon_state = "outpost_med_hall"

/area/strata/ag/interior/outpost/med/reception
	name = "哨站医疗部接待处"
	icon_state = "outpost_med_recp"

/area/strata/ag/interior/outpost/med/or1
	name = "哨站医疗部1号手术室"
	icon_state = "outpost_med_or"

/area/strata/ag/interior/outpost/med/chemstorage
	name = "哨站医疗部化学品储藏室"
	icon_state = "outpost_med_chem"

/area/strata/ag/interior/outpost/med/recovery
	name = "哨站医疗部康复室"
	icon_state = "outpost_med_recovery"

/area/strata/ag/interior/outpost/med/paperroom
	name = "哨站医疗部文书室"
	icon_state = "outpost_med_stock"

/area/strata/ag/interior/outpost/med/spareuniform
	name = "哨站医疗部备用制服间"
	icon_state = "outpost_med_closet"

/area/strata/ag/interior/outpost/med/lounge
	name = "哨站医疗部休息室"

/area/strata/ag/interior/outpost/med/utility
	name = "哨站医疗部杂物间"

/area/strata/ag/interior/outpost/med/lounge
	name = "哨站医疗部休息室"

/area/strata/ag/interior/outpost/med/stockroom
	name = "哨站医疗部储物间"
	icon_state = "outpost_med_stock"

/area/strata/ag/interior/outpost/med/morgue
	name = "哨站停尸房"

/area/strata/ag/interior/outpost/med/autopsy
	name = "哨站验尸室"

/area/strata/ag/interior/outpost/med/records
	name = "哨站医疗部——工程档案室"

/area/strata/ag/interior/outpost/med/jung_hall
	name = "哨站医疗部南走廊"

/area/strata/ag/interior/outpost/med/jungle_lock
	name = "哨站医疗部洞穴闸口"

///OUTPOST ENGINEERING///

/area/strata/ag/interior/outpost/engi
	name = "哨站工程部"
	icon_state = "outpost_engi_0"
	minimap_color = MINIMAP_AREA_ENGI

/area/strata/ag/interior/outpost/engi/foyer
	name = "哨站工程部门厅"
	icon_state = "outpost_engi_1"

/area/strata/ag/interior/outpost/engi/foyerdecks
	name = "哨站工程部门厅平台"

/area/strata/ag/interior/outpost/engi/garage
	name = "哨站工程部车库"

/area/strata/ag/interior/outpost/engi/tool_storage
	name = "哨站工程部工具间"
	icon_state = "outpost_engi_2"

/area/strata/ag/interior/outpost/engi/power_monitoring
	name = "哨站工程部电力监控室"
	icon_state = "outpost_engi_3"

/area/strata/ag/interior/outpost/engi/hall
	name = "哨站工程部主走廊"

/area/strata/ag/interior/outpost/engi/emergency_storage
	name = "哨站工程部应急物资库"
	icon_state = "outpost_engi_4"

/area/strata/ag/interior/outpost/engi/drome
	name = "哨站航空港"
	icon_state = "outpost_engi_4"

/area/strata/ag/interior/outpost/engi/drome/shuttle
	name = "已拆解的VDVK“鹰”Mk4"
	icon_state = "outpost_engi_3"

/area/strata/ag/interior/outpost/engi/drome/security
	name = "哨站航空港安保站"
	icon_state = "outpost_engi_2"

/area/strata/ag/interior/outpost/engi/drome/northlock
	name = "哨站航空港排爆器材间"
	icon_state = "outpost_engi_2"

/area/strata/ag/interior/outpost/engi/drome/foreman
	name = "哨站工头办公室"
	icon_state = "outpost_engi_1"

/area/strata/ag/interior/outpost/engi/drome/northhall
	name = "哨站航空港北走廊"

/area/strata/ag/interior/outpost/engi/drome/jung_hall
	name = "哨站航空港东走廊"

/area/strata/ag/interior/outpost/engi/drome/jungle_lock
	name = "哨站航空港洞穴闸口"
	icon_state = "outpost_engi_4"

///OUTPOST SECURITY

/area/strata/ag/interior/outpost/security
	name = "哨站安保部"
	icon_state = "outpost_sec_0"
	minimap_color = MINIMAP_AREA_SEC

/area/strata/ag/interior/outpost/security/hall
	name = "哨站安保部主走廊"
	icon_state = "outpost_sec_1"

/area/strata/ag/interior/outpost/security/armory
	name = "哨站军械库"
	icon_state = "outpost_sec_4"

/area/strata/ag/interior/outpost/security/access_line
	name = "哨站安保部证件办理室"
	icon_state = "outpost_sec_3"

/area/strata/ag/interior/outpost/security/breakroom
	name = "哨站安保部休息室"
	icon_state = "outpost_sec_2"

/area/strata/ag/interior/outpost/security/holding
	name = "哨站安保部拘留室"
	icon_state = "outpost_sec_4"

/area/strata/ag/interior/outpost/security/briefing
	name = "哨站安保部简报室"

/area/strata/ag/interior/outpost/security/lockers
	name = "哨站安保部更衣室"

/area/strata/ag/interior/outpost/security/wardens
	name = "哨站监狱长办公室"
	icon_state = "outpost_sec_3"

/area/strata/ag/interior/outpost/security/helpdesk
	name = "哨站咨询台"

/area/strata/ag/interior/outpost/security/dispatch
	name = "哨站安保调度与监控室"
	icon_state = "outpost_sec_3"

///OUTPOST ADMINISTRATION

/area/strata/ag/interior/outpost/admin
	name = "哨站行政部"
	icon_state = "outpost_admin_0"
	minimap_color = MINIMAP_AREA_COMMAND

/area/strata/ag/interior/outpost/admin/dir_office
	name = "哨站主管办公室"
	icon_state = "outpost_admin_1"

/area/strata/ag/interior/outpost/admin/dir_waiting
	name = "哨站行政部等候室"

/area/strata/ag/interior/outpost/admin/office_0
	name = "哨站行政部地面层办公室"

/area/strata/ag/interior/outpost/admin/office_1
	name = "哨站行政部1层办公室"
	icon_state = "outpost_admin_1"

/area/strata/ag/interior/outpost/admin/office_2
	name = "哨站行政部2层办公室"
	icon_state = "outpost_admin_2"

/area/strata/ag/interior/outpost/admin/lounge
	name = "哨站行政部休息室"
	icon_state = "outpost_admin_4"

/area/strata/ag/interior/outpost/admin/records
	name = "哨站行政部档案室"
	icon_state = "outpost_admin_4"

/area/strata/ag/interior/outpost/admin/wc
	name = "哨站行政部洗手间"
	icon_state = "outpost_admin_2"

/area/strata/ag/interior/outpost/admin/backhall
	name = "哨站行政部东走廊"

///CANTEEN / GENERAL QUARTERS///

/area/strata/ag/interior/outpost/canteen
	name = "哨站食堂"
	icon_state = "outpost_canteen_0"

/area/strata/ag/interior/outpost/canteen/kitchen
	name = "哨站厨房"
	icon_state = "outpost_canteen_1"

/area/strata/ag/interior/outpost/canteen/bar
	name = "哨站酒吧"
	icon_state = "outpost_canteen_2"

/area/strata/ag/interior/outpost/canteen/northlock
	name = "哨站食堂北气闸"
	icon_state = "outpost_canteen_2"

/area/strata/ag/interior/outpost/canteen/freezer
	name = "哨站厨房与酒吧冷冻库"
	icon_state = "outpost_canteen_3"

/area/strata/ag/interior/outpost/canteen/janitors
	name = "哨站清洁工具间"
	icon_state = "outpost_canteen_4"

/area/strata/ag/interior/outpost/canteen/upper_cafeteria
	name = "哨站餐厅高台座位区"
	icon_state = "outpost_canteen_4"

/area/strata/ag/interior/outpost/canteen/lower_cafeteria
	name = "哨站餐厅"
	icon_state = "outpost_canteen_0"

/area/strata/ag/interior/outpost/canteen/hall
	name = "哨站食堂东走廊"
	icon_state = "outpost_canteen_3"

/area/strata/ag/interior/outpost/canteen/personal_storage
	name = "哨站个人物品储藏室"

/area/strata/ag/interior/outpost/canteen/spare_uniforms
	name = "哨站备用制服间"

/area/strata/ag/interior/outpost/canteen/showers
	name = "哨站公共淋浴间"

/area/strata/ag/interior/outpost/canteen/bar_2
	name = "哨站赌场"

/area/strata/ag/interior/outpost/canteen/jungle_lock
	name = "哨站公共洞穴闸口"


///JUNGLE STRUCTURES - UNDERGROUND///

/area/strata/ug/interior/outpost/jung
	name = "地下丛林建筑群"
	icon_state = "ug_jung_dorm"
	minimap_color = MINIMAP_AREA_CAVES

/area/strata/ug/interior/outpost/jung/dorms
	name = "地下宿舍区"

/area/strata/ug/interior/outpost/jung/dorms/sec1
	name = "地下安保宿舍1号"

/area/strata/ug/interior/outpost/jung/dorms/sec2
	name = "地下安保宿舍2号"

/area/strata/ug/interior/outpost/jung/dorms/admin1
	name = "地下普通员工宿舍1号"

/area/strata/ug/interior/outpost/jung/dorms/admin2
	name = "地下普通员工宿舍2号"

/area/strata/ug/interior/outpost/jung/dorms/admin3
	name = "地下普通员工宿舍3号"

/area/strata/ug/interior/outpost/jung/dorms/admin4
	name = "地下殖民地行政人员宿舍1号"

/area/strata/ug/interior/outpost/jung/dorms/engi1
	name = "地下工程人员宿舍1号"

/area/strata/ug/interior/outpost/jung/dorms/engi2
	name = "地下工程人员宿舍2号"

/area/strata/ug/interior/outpost/jung/dorms/engi3
	name = "地下工程人员宿舍3号"

/area/strata/ug/interior/outpost/jung/dorms/engi4
	name = "地下工程人员宿舍4号"

/area/strata/ug/interior/outpost/jung/dorms/med1
	name = "地下医护人员宿舍1号"

/area/strata/ug/interior/outpost/jung/dorms/med2
	name = "地下医护人员宿舍2号"


////END OUTPOST DEFINES////

///DEEP JUNGLE///

/area/strata/ug/interior/jungle
	name = "地下丛林"
	icon_state = "ug_jung_0"
	minimap_color = MINIMAP_AREA_JUNGLE


/area/strata/ug/interior/jungle/platform
	name = "地下平台"
	icon_state = "ug_jung_2"

/area/strata/ug/interior/jungle/platform/south
	name = "地下平台南侧"

/area/strata/ug/interior/jungle/platform/south/scrub
	name = "地下平台南侧灌木地"
	icon_state = "ug_jung_1"

/area/strata/ug/interior/jungle/platform/east
	name = "地下平台东侧"

/area/strata/ug/interior/jungle/platform/east/scrub
	name = "地下平台东侧灌木地"
	icon_state = "ug_jung_1"

/area/strata/ug/interior/jungle/deep
	name = "密林深处"
	ceiling = CEILING_DEEP_UNDERGROUND

/area/strata/ug/interior/jungle/deep/carplake
	name = "密林深处——鲤鱼湖岸"
	icon_state = "ug_jung_2"

/area/strata/ug/exterior
	ceiling = CEILING_NONE

/area/strata/ug/exterior/jungle/deep/carplake_water
	name = "密林深处——鲤鱼湖水域"
	icon_state = "ug_jung_5"

/area/strata/ug/exterior/jungle/deep/carplake_center
	name = "密林深处——鲤鱼湖中央岛屿"
	icon_state = "ug_jung_1"


/area/strata/ug/interior/jungle/deep/north_carp
	name = "密林深处——鲤鱼湖以北"
	icon_state = "ug_jung_6"

/area/strata/ug/interior/jungle/deep/south_carp
	name = "密林深处——鲤鱼湖以南"
	icon_state = "ug_jung_3"

/area/strata/ug/interior/jungle/deep/east_carp
	name = "密林深处——鲤鱼湖以东"
	icon_state = "ug_jung_5"

/area/strata/ug/interior/jungle/deep/tearlake
	name = "密林深处——泪池"
	icon_state = "ug_jung_3"

/area/strata/ug/interior/jungle/deep/tearlake_south
	name = "密林深处——泪池以南"
	icon_state = "ug_jung_8"

/area/strata/ug/interior/jungle/deep/tearlake_north
	name = "密林深处——泪池以北"
	icon_state = "ug_jung_3"

/area/strata/ug/interior/jungle/deep/tearlake_east
	name = "密林深处——泪池以东"
	icon_state = "ug_jung_6"

/area/strata/ug/interior/jungle/deep/tearlake_west
	name = "密林深处——泪池以西"
	icon_state = "ug_jung_5"

/area/strata/ug/interior/jungle/deep/south_dorms
	name = "密林深处——南部宿舍"
	icon_state = "ug_jung_4"

/area/strata/ug/interior/jungle/deep/east_dorms
	name = "密林深处——东部宿舍"
	icon_state = "ug_jung_0"

/area/strata/ug/interior/jungle/deep/structures
	name = "密林深处——未知建筑"
	icon_state = "ug_jung_1"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/strata/ug/interior/jungle/deep/structures/res
	icon_state = "ug_jung_2"
	name = "密林深处——机密研究站"

/area/strata/ug/interior/jungle/deep/south_res
	icon_state = "ug_jung_3"
	name = "密林深处——机密研究站以南"

/area/strata/ug/interior/jungle/deep/hotsprings
	icon_state = "ug_jung_4"
	name = "密林深处——温泉"

/area/strata/ug/interior/jungle/deep/structures/engi
	icon_state = "ug_jung_5"
	name = "密林深处——行星地核监测站"

/area/strata/ug/interior/jungle/deep/south_engi
	icon_state = "ug_jung_7"
	name = "密林深处——地核监测站以南"

/area/strata/ug/interior/jungle/deep/east_engi
	icon_state = "ug_jung_6"
	name = "密林深处——地核监测站以东"

/area/strata/ug/interior/jungle/deep/west_engi
	icon_state = "ug_jung_8"
	name = "密林深处——地核监测站以西"

/area/strata/ug/interior/jungle/deep/minehead
	icon_state = "ug_jung_mine_1"
	name = "密林深处——旧隧道"

/area/strata/ug/interior/jungle/deep/minehead/north
	icon_state = "ug_jung_mine_2"
	name = "密林深处——北部旧隧道"

/area/strata/ug/interior/jungle/deep/minehead/south
	icon_state = "ug_jung_mine_3"
	name = "密林深处——南部旧隧道"

/area/strata/ug/interior/jungle/deep/minehead/east
	icon_state = "ug_jung_mine_4"
	name = "密林深处——东部旧隧道"

/area/strata/ug/interior/jungle/deep/minehead/west
	icon_state = "ug_jung_mine_5"
	name = "密林深处——西部旧隧道"

/area/strata/ug/interior/jungle/deep/minehead/ruins
	icon_state = "ug_jung_mine_4"
	name = "密林深处——古旧宿舍"





