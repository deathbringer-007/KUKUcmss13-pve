//Areas for Biodomes Map

/area/corsat
	icon = 'icons/turf/area_corsat.dmi'
	ceiling = CEILING_GLASS
	powernet_name = "ground"
	can_build_special = TRUE

/area/corsat/landing/console
	name = "\improper 1号着陆区“伽马”"
	icon_state = "corsat_telecomms"
	requires_power = 0

/area/corsat/landing/console2
	name = "\improper 2号着陆区“西格玛”"
	icon_state = "corsat_telecomms"
	requires_power = 0

/area/corsat/emergency_access
	name = "\improper 未知区域"
	icon_state = "corsat_hull"
	ceiling = CEILING_REINFORCED_METAL

//SIGMA SECTOR

/area/corsat/sigma
	name = "\improper 西格玛区"
	icon_state = "corsat_hull"

/area/corsat/sigma/north
	name = "\improper 西格玛区北走廊"
	icon_state = "sigma_hallway_north"
	is_resin_allowed = FALSE

/area/corsat/sigma/hangar
	name = "\improper 西格玛着陆机库"
	icon_state = "sigma_hangar"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/corsat/sigma/hangar/monorail
	name = "\improper 西格玛单轨车站"
	icon_state = "monorail"

/area/corsat/sigma/hangar/monorail/control
	name = "\improper 西格玛单轨控制室"
	icon_state = "monorail"

/area/corsat/sigma/hangar/monorail/railcart
	name = "\improper CORSAT 单轨列车"
	icon_state = "railcart"
	ceiling = CEILING_REINFORCED_METAL

/area/corsat/sigma/hangar/monorail/railcart_transit
	name = "\improper CORSAT 单轨列车行驶区"
	icon_state = "railcart"
	ceiling = CEILING_REINFORCED_METAL
	flags_area = AREA_NOTUNNEL

/area/corsat/sigma/hangar/cargo
	name = "\improper 西格玛机库货运检查站"
	icon_state = "sigma_hangar"

/area/corsat/sigma/hangar/checkpoint
	name = "\improper 西格玛机库检查站"
	icon_state = "sigma_hangar"

/area/corsat/sigma/hangar/id
	name = "\improper 西格玛机库身份检查站"
	icon_state = "corsat_id"

/area/corsat/sigma/hangar/arrivals
	name = "\improper 西格玛到达区"
	icon_state = "sigma_arrivals"

/area/corsat/sigma/hangar/office
	name = "\improper 西格玛机库办公室"
	icon_state = "sigma_hangar_office"

/area/corsat/sigma/hangar/security
	name = "\improper 西格玛机库安保区"
	icon_state = "sigma_hangar_security"

/area/corsat/sigma/airlock/east
	name = "\improper 西格玛穹顶东气闸"
	icon_state = "sigma_airlock_east"

/area/corsat/sigma/airlock/east/id
	name = "\improper 西格玛东部身份检查站"
	icon_state = "corsat_id"

/area/corsat/sigma/airlock/south
	name = "\improper 西格玛穹顶南气闸"
	icon_state = "sigma_airlock_south"

/area/corsat/sigma/airlock/south/id
	name = "\improper 西格玛南部身份检查站"
	icon_state = "corsat_id"

/area/corsat/sigma/airlock/control
	name = "\improper 西格玛穹顶控制舱室"
	icon_state = "sigma_control"

/area/corsat/sigma/cargo
	name = "\improper 西格玛货运区"
	icon_state = "sigma_cargo"
	is_resin_allowed = FALSE

/area/corsat/sigma/laundry
	name = "\improper 西格玛洗衣房"
	icon_state = "sigma_laundry"
	is_resin_allowed = FALSE

/area/corsat/sigma/lavatory
	name = "\improper 西格玛卫生间"
	icon_state = "sigma_lavatory"
	is_resin_allowed = FALSE

/area/corsat/sigma/cafe
	name = "\improper 西格玛咖啡馆"
	icon_state = "sigma_cafe"
	is_resin_allowed = FALSE

/area/corsat/sigma/dorms
	name = "\improper 西格玛居住舱室"
	icon_state = "sigma_residential"

/area/corsat/sigma/checkpoint
	name = "\improper 西格玛安保检查站"
	icon_state = "sigma_security_checkpoint"

/area/corsat/sigma/southeast
	name = "\improper 西格玛区东南走廊"
	icon_state = "sigma_hallway_southeast"

/area/corsat/sigma/southeast/generator
	name = "\improper CORSAT 辅助发电机区"
	icon_state = "secondary_core"
	ceiling = CEILING_METAL

/area/corsat/sigma/southeast/telecomm
	name = "\improper CORSAT 电信室"
	icon_state = "corsat_telecomms"
	ceiling = CEILING_METAL

/area/corsat/sigma/southeast/datalab
	name = "\improper 西格玛数据实验室"
	icon_state = "sigma_data_lab"
	ceiling = CEILING_METAL

/area/corsat/sigma/southeast/dataoffice
	name = "\improper 西格玛数据办公室"
	icon_state = "sigma_data_offices"

/area/corsat/sigma/southeast/datamaint
	name = "\improper 西格玛数据维护区"
	icon_state = "sigma_data_lab"

/area/corsat/sigma/south
	name = "\improper 西格玛区南走廊"
	icon_state = "sigma_hallway_south"

/area/corsat/sigma/south/complex
	name = "\improper 西格玛科研园区"
	icon_state = "sigma_complex"

/area/corsat/sigma/south/complex/teleporter
	name = "\improper 西格玛传送器"
	icon = 'icons/turf/areas.dmi'
	icon_state = "shuttle"
	ceiling = CEILING_METAL

/area/corsat/sigma/south/robotics
	name = "\improper 西格玛机器人实验室"
	icon_state = "robotics"

/area/corsat/sigma/south/engineering
	name = "\improper 西格玛工程区"
	icon_state = "sigma_engineering"

/area/corsat/sigma/south/security
	name = "\improper 西格玛安保枢纽"
	icon_state = "sigma_security"

/area/corsat/sigma/south/offices
	name = "\improper 西格玛办公室"
	icon_state = "sigma_offices"

/area/corsat/sigma/biodome
	name = "\improper 西格玛生态穹顶"
	icon_state = "sigma_biodome"
	always_unpowered = 1

// Ice Nightmare insert variation. COLD!
/area/corsat/sigma/biodome/ice
	temperature = SOROKYNE_TEMPERATURE

/area/corsat/sigma/biodome/testgrounds
	name = "\improper 西格玛生态穹顶试验场"
	icon_state = "sigma_testgrounds"

/area/corsat/sigma/biodome/gunrange
	name = "\improper 西格玛生态穹顶靶场"
	icon_state = "sigma_gunrange"

/area/corsat/sigma/biodome/scrapyard
	name = "\improper 西格玛生态穹顶废料场"
	icon_state = "sigma_scrapyard"

//GAMMA SECTOR

/area/corsat/gamma
	name = "\improper 伽马区"
	icon_state = "corsat_hull"

/area/corsat/gamma/hangar
	name = "\improper 伽马着陆机库"
	icon_state = "gamma_hangar"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/corsat/gamma/hangar/monorail
	name = "\improper 伽马单轨车站"
	icon_state = "monorail"

/area/corsat/gamma/hangar/monorail/control
	name = "\improper 伽马单轨控制室"
	icon_state = "monorail"

/area/corsat/gamma/hangar/monorail/railcart
	name = "\improper CORSAT 轨道车"
	icon_state = "railcart"
	requires_power = 0
	ceiling = CEILING_REINFORCED_METAL

/area/corsat/gamma/hangar/cargo
	name = "\improper 伽马机库货运检查站"
	icon_state = "gamma_hangar"

/area/corsat/gamma/hangar/checkpoint
	name = "\improper 伽马机库检查站"
	icon_state = "gamma_hangar"

/area/corsat/gamma/hangar/office
	name = "\improper 伽马机库办公室"
	icon_state = "gamma_hangar_office"

/area/corsat/gamma/hangar/flightcontrol
	name = "\improper CORSAT 飞行控制中心"
	icon_state = "flight_center"

/area/corsat/gamma/hangar/security
	name = "\improper 伽马机库安保区"
	icon_state = "gamma_hangar_security"

/area/corsat/gamma/hangar/arrivals
	name = "\improper 伽马到达区"
	icon_state = "gamma_arrivals"

/area/corsat/gamma/foyer
	name = "\improper 伽马门厅"
	icon_state = "gamma_foyer"
	is_resin_allowed = FALSE

/area/corsat/gamma/hallwaymain
	name = "\improper 伽马区西走廊"
	icon_state = "gamma_hallway_main"

/area/corsat/gamma/hallwaysouth
	name = "\improper 伽马区南走廊"
	icon_state = "gamma_hallway_south"

/area/corsat/gamma/residential
	name = "\improper 伽马居住区走廊"
	icon_state = "gamma_hallway_main"

/area/corsat/gamma/residential/west
	name = "\improper CORSAT 学院"
	icon_state = "gamma_residential_west"

/area/corsat/gamma/residential/east
	name = "\improper 伽马北部居住区"
	icon_state = "gamma_residential_east"

/area/corsat/gamma/residential/maint
	name = "\improper 伽马居住区维护区"
	icon_state = "gamma_residential_maint"

/area/corsat/gamma/residential/researcher
	name = "\improper 研究员宿舍"
	icon_state = "researcher_quarters"

/area/corsat/gamma/residential/lounge
	name = "\improper 研究员休息室"
	icon_state = "researcher_lounge"

/area/corsat/gamma/residential/lavatory
	name = "\improper 伽马卫生间"
	icon_state = "gamma_lavatory"

/area/corsat/gamma/residential/showers
	name = "\improper 伽马淋浴间"
	icon_state = "gamma_showers"

/area/corsat/gamma/residential/laundry
	name = "\improper 伽马洗衣房"
	icon_state = "gamma_laundry"

/area/corsat/gamma/cargo
	name = "\improper 伽马货运区"
	icon_state = "gamma_cargo"
	is_resin_allowed = FALSE

/area/corsat/gamma/cargo/lobby
	name = "\improper 伽马货运大厅"
	icon_state = "gamma_cargo_lobby"

/area/corsat/gamma/cargo/disposal
	name = "\improper 伽马废物处理区"
	icon_state = "gamma_disposals"

/area/corsat/gamma/medbay
	name = "\improper CORSAT 医务室"
	icon_state = "corsat_medbay"

/area/corsat/gamma/medbay/morgue
	name = "\improper CORSAT 停尸房"
	icon_state = "corsat_morgue"

/area/corsat/gamma/medbay/chemistry
	name = "\improper CORSAT 化学区"
	icon_state = "corsat_chemistry"

/area/corsat/gamma/medbay/surgery
	name = "\improper CORSAT 手术室"
	icon_state = "corsat_surgery"

/area/corsat/gamma/medbay/lobby
	name = "\improper CORSAT 医务室大厅"
	icon_state = "medbay_lobby"

/area/corsat/gamma/hydroponics
	name = "\improper CORSAT 水培区"
	icon_state = "corsat_hydroponics"

/area/corsat/gamma/canteen
	name = "\improper CORSAT 食堂"
	icon_state = "corsat_canteen"

/area/corsat/gamma/kitchen
	name = "\improper CORSAT 厨房"
	icon_state = "corsat_kitchen"

/area/corsat/gamma/freezer
	name = "\improper CORSAT 食物储藏室"
	icon_state = "food_storage"

/area/corsat/gamma/administration
	name = "\improper CORSAT 行政中心"
	icon_state = "corsat_administration"

/area/corsat/gamma/security
	name = "\improper CORSAT 安保枢纽"
	icon_state = "gamma_security"

/area/corsat/gamma/security/cells
	name = "\improper CORSAT 安保牢房"
	icon_state = "security_cell"

/area/corsat/gamma/security/armory
	name = "\improper CORSAT 军械库"
	icon_state = "corsat_armory"

/area/corsat/gamma/rnr
	name = "\improper CORSAT 休闲区"
	icon_state = "corsat_rnr"

/area/corsat/gamma/rnr/bar
	name = "\improper CORSAT 酒吧"
	icon_state = "corsat_bar"
	is_resin_allowed = FALSE

/area/corsat/gamma/rnr/arcade
	name = "\improper CORSAT 电子游戏厅"
	icon_state = "corsat_arcade"
	is_resin_allowed = FALSE

/area/corsat/gamma/rnr/library
	name = "\improper CORSAT 图书馆"
	icon_state = "corsat_library"

/area/corsat/gamma/engineering
	name = "\improper 伽马工程区"
	icon_state = "gamma_engineering"

/area/corsat/gamma/engineering/lobby
	name = "\improper 伽马工程区大厅"
	icon_state = "gamma_engineering"

/area/corsat/gamma/engineering/atmos
	name = "\improper CORSAT 大气控制室"
	icon_state = "gamma_atmos"

/area/corsat/gamma/engineering/core
	name = "\improper CORSAT 发电机核心"
	icon_state = "corsat_core"

/area/corsat/gamma/sigmaremote
	name = "\improper 西格玛远端园区"
	icon_state = "sigma_complex_remote"

/area/corsat/gamma/sigmaremote/teleporter
	name = "\improper 西格玛远端传送器"
	icon = 'icons/turf/areas.dmi'
	icon_state = "shuttle"
	ceiling = CEILING_METAL

/area/corsat/gamma/airlock/north
	name = "\improper 伽马穹顶北气闸"
	icon_state = "gamma_airlock_north"
	ceiling = CEILING_GLASS

/area/corsat/gamma/airlock/north/id
	name = "\improper 伽马北部身份检查站"
	icon_state = "corsat_id"

/area/corsat/gamma/airlock/south
	name = "\improper 伽马穹顶南气闸"
	icon_state = "gamma_airlock_south"

/area/corsat/gamma/airlock/south/id
	name = "\improper 伽马南部身份检查站"
	icon_state = "corsat_id"

/area/corsat/gamma/airlock/control
	name = "\improper 伽马穹顶控制舱室"
	icon_state = "gamma_control"
	ceiling = CEILING_GLASS

/area/corsat/gamma/biodome
	name = "\improper 伽马生态穹顶"
	icon_state = "gamma_biodome"
	temperature = ICE_COLONY_TEMPERATURE
	always_unpowered = 1
	ceiling = CEILING_GLASS

/area/corsat/gamma/biodome/complex
	name = "\improper 伽马科研园区"
	icon_state = "gamma_complex"
	temperature = T20C
	always_unpowered = 0

/area/corsat/gamma/biodome/virology
	name = "\improper 伽马病毒学区"
	icon_state = "gamma_virology"
	temperature = T20C
	always_unpowered = 0

/area/corsat/gamma/biodome/toxins
	name = "\improper 伽马毒理学区"
	icon_state = "gamma_toxin"
	temperature = T20C
	always_unpowered = 0

//THETA SECTOR

/area/corsat/theta
	name = "\improper 西塔区"
	icon_state = "corsat_hull"
	ceiling = CEILING_GLASS

/area/corsat/theta/biodome
	name = "\improper 西塔生态穹顶"
	icon_state = "theta_biodome"
	always_unpowered = 1

/area/corsat/theta/biodome/complex
	name = "\improper 西塔科研园区"
	icon_state = "theta_complex"
	always_unpowered = 0

/area/corsat/theta/biodome/hydroeast
	name = "\improper 西塔东部水培区"
	icon_state = "theta_hydro_east"
	always_unpowered = 0

/area/corsat/theta/biodome/hydrowest
	name = "\improper 西塔西部水培区"
	icon_state = "theta_hydro_west"
	always_unpowered = 0

/area/corsat/theta/airlock/west
	name = "\improper 西塔穹顶西气闸"
	icon_state = "theta_airlock_west"

/area/corsat/theta/airlock/west/id
	name = "\improper 西塔西部身份检查站"
	icon_state = "corsat_id"

/area/corsat/theta/airlock/east
	name = "\improper 西塔穹顶东气闸"
	icon_state = "theta_airlock_east"

/area/corsat/theta/airlock/east/id
	name = "\improper 西塔东部身份检查站"
	icon_state = "corsat_id"

/area/corsat/theta/airlock/control
	name = "\improper 西塔穹顶控制舱室"
	icon_state = "theta_control"

//OMEGA SECTOR

/area/corsat/omega
	name = "\improper 欧米伽区"
	icon_state = "corsat_hull"
	ceiling = CEILING_REINFORCED_METAL

/area/corsat/omega/biodome
	name = "\improper 欧米伽生态穹顶"
	icon_state = "omega_biodome"

/area/corsat/omega/hangar
	name = "\improper 欧米伽着陆机库"
	icon_state = "omega_hangar"

/area/corsat/omega/hangar/office
	name = "\improper 欧米伽机库办公室"
	icon_state = "omega_hangar_office"

/area/corsat/omega/hangar/security
	name = "\improper 欧米伽机库安保区"
	icon_state = "omega_hangar_security"

/area/corsat/omega/hallways
	name = "\improper 欧米伽区走廊"
	icon_state = "omega_hallway"

/area/corsat/omega/complex
	name = "\improper 欧米伽科研园区"
	icon_state = "omega_complex"

/area/corsat/omega/containment
	name = "\improper 欧米伽研究收容区"
	icon_state = "omega_containment"

/area/corsat/omega/security
	name = "\improper 欧米伽安保枢纽"
	icon_state = "omega_security"

/area/corsat/omega/checkpoint
	name = "\improper 欧米伽出入检查站"
	icon_state = "omega_checkpoint"

/area/corsat/omega/offices
	name = "\improper 欧米伽办公室"
	icon_state = "omega_offices"

/area/corsat/omega/cargo
	name = "\improper 欧米伽货运区"
	icon_state = "omega_cargo"

/area/corsat/omega/maint
	name = "\improper 欧米伽维护区"
	icon_state = "omega_maintenance"

/area/corsat/omega/airlocknorth
	name = "\improper 欧米伽穹顶北气闸"
	icon_state = "omega_airlock"

/area/corsat/omega/airlocknorth/id
	name = "\improper 欧米伽北部身份检查站"
	icon_state = "corsat_id"

/area/corsat/omega/control
	name = "\improper 欧米伽穹顶控制舱室"
	icon_state = "omega_control"

//INACCESSIBLE

/area/corsat/inaccessible
	name = "\improper 未知位置"
	icon_state = "corsat_hull"
	ceiling = CEILING_REINFORCED_METAL
	flags_area = AREA_NOTUNNEL
