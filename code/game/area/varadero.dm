
//areas for New  Varadero (waterworld), aka Ice Underground revamped.

/area/varadero
	name = "新巴拉德罗"
	icon = 'icons/turf/area_varadero.dmi'
	ambience_exterior = AMBIENCE_NV
	icon_state = "varadero"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	temperature = TROPICAL_TEMP
	minimap_color = MINIMAP_AREA_COLONY

//shuttle stuff

/area/shuttle/drop1/varadero
	name = "新巴拉德罗 - 阿拉莫号运输机降落区"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ


/area/shuttle/drop2/varadero
	name = "新巴拉德罗 - 诺曼底号运输机降落区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

//Parent areas

/area/varadero/exterior
	name = "新巴拉德罗 - 外部"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_NV
	//soundscape_playlist

/area/varadero/interior
	name = "新巴拉德罗 - 内部"
	ceiling = CEILING_GLASS
	ambience_exterior = AMBIENCE_PRISON
	//soundscape_playlist
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/varadero/interior_protected
	name = "新巴拉德罗 - 内部"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	icon_state = "NV_no_CAS"

/area/varadero/interior/comms1
	name = "新巴拉德罗 - 货运区发电机"
	is_resin_allowed = FALSE
	icon_state = "comms1"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/varadero/interior/comms2
	name = "新巴拉德罗 - 通讯工程场地"
	icon_state = "comms2"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/varadero/interior/comms3
	name = "新巴拉德罗 - 工程通讯区"
	icon_state = "comms3"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/varadero/exterior/comms4
	name = "新巴拉德罗 - 延伸步道"
	is_resin_allowed = FALSE
	icon_state = "comms4"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/varadero/interior/oob
	name = "New Varadero - Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

//landing zone computers

/area/varadero/exterior/lz1_console
	name = "新巴拉德罗 - 浮筒码头"
	requires_power = FALSE
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ
	is_landing_zone = TRUE

/area/varadero/exterior/lz1_console/two
	name = "新巴拉德罗 - 棕榈机场"
	requires_power = FALSE
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

//exterior areas

/area/varadero/exterior/lz1_near
	name = "新巴拉德罗 - 浮筒机场"
	icon_state = "lz1"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ
	is_landing_zone = TRUE

/area/varadero/exterior/lz2_near
	name = "新巴拉德罗 - 棕榈机场"
	icon_state = "lz2"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ
	is_landing_zone = TRUE

/area/varadero/exterior/pontoon_beach
	name = "新巴拉德罗 - 山地摇滚海滩"
	icon_state = "varadero0"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_JUNGLE

/area/varadero/exterior/pontoon_beach/lz
	is_landing_zone = TRUE

/area/varadero/exterior/eastbeach
	name = "新巴拉德罗 - 东侧海滩"
	is_resin_allowed = FALSE
	icon_state = "varadero1"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/varadero/exterior/monsoon
	name = "新巴拉德罗 - 季风区"
	icon_state = "varadero1"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/varadero/exterior/pool
	name = "新巴拉德罗 - 室内泳池"
	icon_state = "varadero1"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/exterior/eastocean
	name = "新巴拉德罗 - 东侧海洋"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	icon_state = "varadero2"
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE

/area/varadero/exterior/farocean
	name = "新巴拉德罗 - 远洋"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	icon_state = "varadero3"
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE

//interior areas


/area/varadero/interior/beach_bar
	name = "新巴拉德罗 - 海滩酒吧"
	icon_state = "varadero4"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_JUNGLE
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/varadero/interior/dock_control
	name = "新巴拉德罗 - 码头控制室"
	icon_state = "varadero3"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_JUNGLE
	sound_environment = SOUND_ENVIRONMENT_ROOM
	is_landing_zone = TRUE

/area/varadero/interior/cargo
	name = "新巴拉德罗 - 货运区"
	icon_state = "req0"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_ENGI

/area/varadero/interior/hall_NW
	name = "新巴拉德罗 - 西北走廊"
	icon_state = "hall0"

/area/varadero/interior/hall_N
	name = "新巴拉德罗 - 北侧走廊"
	icon_state = "hall2"
	is_resin_allowed = FALSE

/area/varadero/interior/hall_SE
	name = "新巴拉德罗 - 东南走廊"
	icon_state = "hall1"

/area/varadero/interior/chapel
	name = "新巴拉德罗 - 礼拜堂"
	icon_state = "offices1"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/interior/morgue
	name = "新巴拉德罗 - 停尸间"
	icon_state = "offices0"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_MEDBAY_CAVE

/area/varadero/interior/medical
	name = "新巴拉德罗 - 医疗区"
	icon_state = "offices2"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/varadero/interior/maintenance
	name = "新巴拉德罗 - 中央维护区"
	icon_state = "tunnels0"

/area/varadero/interior/maintenance/north
	name = "新巴拉德罗 - 北侧维护区"
	icon_state = "tunnels1"
	is_resin_allowed = FALSE

/area/varadero/interior/maintenance/research
	name = "新巴拉德罗 - 科研维护区"
	icon_state = "tunnels1"
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE

/area/varadero/interior/maintenance/security
	name = "新巴拉德罗 - 安保维护区"
	icon_state = "tunnels2"
	minimap_color = MINIMAP_AREA_SEC_CAVE

/area/varadero/interior/research
	name = "新巴拉德罗 - 科研办公室"
	icon_state = "offices4"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/varadero/interior/electrical
	name = "新巴拉德罗 - 电气附属区"
	icon_state = "req4"
	minimap_color = MINIMAP_AREA_ENGI

/area/varadero/interior/toilets
	name = "新巴拉德罗 - 卫生间"
	icon_state = "req0"

/area/varadero/interior/technical_storage
	name = "新巴拉德罗 - 技术储物间"
	icon_state = "req3"
	minimap_color = MINIMAP_AREA_ENGI

/area/varadero/interior/laundry
	name = "新巴拉德罗 - 洗衣房"
	icon_state = "req2"

/area/varadero/interior/disposals
	name = "新巴拉德罗 - 垃圾处理区"
	icon_state = "offices4"
	minimap_color = MINIMAP_AREA_ENGI

/area/varadero/interior/administration
	name = "新巴拉德罗 - 行政办公室"
	icon_state = "offices2"
	minimap_color = MINIMAP_AREA_COMMAND

/area/varadero/interior/library
	name = "新巴拉德罗 - 图书馆"
	icon_state = "offices0"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/interior/court
	name = "新巴拉德罗 - 篮球场"
	icon_state = "req4"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/interior/mess
	name = "新巴拉德罗 - 食堂"
	icon_state = "req2"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/interior/bunks
	name = "新巴拉德罗 - 一层住舱"
	icon_state = "req3"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/varadero/interior/security
	name = "新巴拉德罗 - 安保办公室"
	icon_state = "offices0"
	minimap_color = MINIMAP_AREA_SEC

/area/varadero/interior/records
	name = "新巴拉德罗 - 档案室"
	icon_state = "offices2"

/area/varadero/interior/rear_elevator
	name = "新巴拉德罗 - 主升降机"
	icon_state = "req3"

/area/varadero/interior/caves
	name = "New Varadero - PARENT TYPE CAVES"
	icon_state = "tunnels0"
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	minimap_color = MINIMAP_AREA_CAVES

/area/varadero/interior/caves/north_research
	name = "新巴拉德罗 - 科研区北侧洞穴"
	icon_state = "tunnels4"

/area/varadero/interior/caves/east
	name = "新巴拉德罗 - 海滩洞穴"
	icon_state = "tunnels2"

/area/varadero/interior_protected/caves
	name = "新巴拉德罗 - 科研区南侧洞穴"
	icon_state = "deepcaves0"
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE


/area/varadero/interior_protected/caves/central
	name = "新巴拉德罗 - 草地洞穴"
	icon_state = "deepcaves2"
	minimap_color = MINIMAP_AREA_CAVES

/area/varadero/interior_protected/caves/digsite
	name = "新巴拉德罗 - 挖掘场"
	icon_state = "deepcaves3"

/area/varadero/interior_protected/caves/swcaves
	name = "新巴拉德罗 - 西南洞穴"
	icon_state = "deepcaves3"

/area/varadero/interior_protected/maintenance/south
	name = "新巴拉德罗 - 南侧维护区"
	icon_state = "deepcaves4"
	minimap_color = MINIMAP_AREA_CAVES

/area/varadero/interior_protected/vessel
	name = "新巴拉德罗 - 未知舰船"
	icon_state = "predship"
	minimap_color = MINIMAP_AREA_SHIP


