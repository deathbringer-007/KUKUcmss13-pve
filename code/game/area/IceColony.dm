/*
 * Areas for the Ice Colony map (nickname is "Shiva's Snowball")
 * Area inheritance logic :
 * Exterior Areas all use the same code, under /exterior branch. Those are NOT homogenous but used to give rough locations to area scanners. THIS INCLUDES UNDERGROUND UNBUILT AREAS
 * Exterior is divided into /surface and /underground for ease of navigation. BOTH PATHS MUST INHERIT EXTERIOR
 * Otherwise, all areas on the surface excluding external areas use /surface, no exceptions. All areas underground use /underground, no exceptions
 * Areas are grouped by building if possible, this excludes some repeating buildings like storage units
 * ELEVATORS AND SHUTTLES ARE SEGREGATED AT THE END OF THE FILE IF APPLICABLE
 */

//Base Instance
/area/ice_colony
	name = "\improper 冰原殖民地"
	icon_state = "ice_colony"
	icon_state = "cliff_blocked"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

/*
 *  ----------------
 * | Exterior Areas |
 *  ----------------
 */

/area/ice_colony/exterior
	name = "\improper 冰原殖民地"
	icon_state = "cliff_blocked"
	requires_power = 1
	always_unpowered = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	temperature = ICE_COLONY_TEMPERATURE

/*
 * Exterior - Surface
 */

//Rough color code for the surface exteriors
//Mountains : Deep Blue/Purple
//Valleys : Light Blue/Cyan
//Open Ground : Gray
//Buildings : Native Color. Command stays Blue, Clinic is Red

/area/ice_colony/exterior/surface
	name = "\improper 冰原殖民地地表外围"
	soundscape_playlist = SCAPE_PL_WIND

//Equivalent of space. None of this area should be accessible. If these are valleys, make separate areas
/area/ice_colony/exterior/surface/cliff
	name = "\improper 冰崖"
	icon_state = "cliff_blocked"

//Landing Pad for the Rasp. THIS IS NOT THE SHUTTLE AREA
/area/ice_colony/exterior/surface/landing_pad
	name = "\improper 机场着陆坪"
	icon_state = "landing_pad"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

//Landing Pad for the Vindi. THIS IS NOT THE SHUTTLE AREA
/area/ice_colony/exterior/surface/landing_pad2
	name = "\improper 应急着陆坪"
	icon_state = "landing_pad"
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE


//Everything around the physical landing pad
/area/ice_colony/exterior/surface/landing_pad_external
	name = "\improper 机场着陆谷地"
	icon_state = "landing_pad_ext"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

//Aerodrome Container Yard
/area/ice_colony/exterior/surface/container_yard
	name = "\improper 机场集装箱堆场"
	icon_state = "container_yard"
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

//
// Valleys
// This is for all the areas mostly surrounded by mountains
// As of current, notably includes Excavation, Research, Requesition Storage, the North and Telecommunications
//

/area/ice_colony/exterior/surface/valley
	name = "\improper 冰崖谷地"
	icon_state = "valley"

/area/ice_colony/exterior/surface/valley/north
	name = "\improper 北部谷地"
	icon_state = "valley_north"

/area/ice_colony/exterior/surface/valley/northeast
	name = "\improper 东北谷地"
	icon_state = "valley_north_east"

/area/ice_colony/exterior/surface/valley/northwest
	name = "\improper 西北谷地"
	icon_state = "valley_north_west"

/area/ice_colony/exterior/surface/valley/west
	name = "\improper 西部谷地"
	icon_state = "valley_west"

/area/ice_colony/exterior/surface/valley/south
	name = "\improper 南部谷地"
	icon_state = "valley_south"

/area/ice_colony/exterior/surface/valley/south/excavation
	name = "\improper 南部谷地挖掘场"
	icon_state = "valley_south_excv"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/ice_colony/exterior/surface/valley/southeast
	name = "\improper 东部谷地"
	icon_state = "valley_east"

/area/ice_colony/exterior/surface/valley/southwest
	name = "\improper 西南谷地"
	icon_state = "valley_south_west"

/area/ice_colony/exterior/surface/valley/northeast/apc_support
	always_unpowered = FALSE

/area/ice_colony/exterior/surface/valley/southeast/apc_support
	always_unpowered = FALSE

//
// Clearing
// The Colony Center, so to speak
//

/area/ice_colony/exterior/surface/clearing
	name = "\improper 冰原殖民地空地"
	icon_state = "clear"

/area/ice_colony/exterior/surface/clearing/pass
	name = "\improper 殖民地中央谷地"
	icon_state = "clear_pass"

/area/ice_colony/exterior/surface/clearing/south
	name = "\improper 殖民地南部空地"
	icon_state = "clear_south"

/area/ice_colony/exterior/surface/clearing/north
	name = "\improper 殖民地北部空地"
	icon_state = "clear_north"

/*
 * Exterior - Underground
 */

/area/ice_colony/exterior/underground
	name = "\improper 冰原殖民地地下外围"
	icon_state = "cave"
	ceiling = CEILING_DEEP_UNDERGROUND
	ambience_exterior = null
//
// Caves
// Extremely simple, anything that is not built is a cave
// For style, we have two subtypes. Open, and dig site
// These do NOT have particular names
//

/area/ice_colony/exterior/underground/caves
	name = "\improper 地下洞穴"
	icon_state = "cave"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	ambience_exterior = AMBIENCE_CAVE
	minimap_color = MINIMAP_AREA_CAVES

/area/ice_colony/exterior/underground/caves/open
	icon_state = "explored"

/area/ice_colony/exterior/underground/caves/dig
	icon_state = "mining_living"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL


/*
 *  ---------------------
 * | Built Surface Areas |
 *  ---------------------
 */

/area/ice_colony/surface
	name = "\improper 冰原殖民地地表建筑区"
	icon_state = "clear"
	ceiling = CEILING_METAL

/*
 * Surface - Bar
 */


/area/ice_colony/surface/bar
	name = "\improper 防冻区"
	icon_state = "bar"

/area/ice_colony/surface/bar/bar
	name = "\improper 防冻酒吧"

/area/ice_colony/surface/bar/canteen
	name = "\improper 防冻食堂"
	icon_state = "kitchen"

/*
 * Surface - Clinic
 */

/area/ice_colony/surface/clinic
	name = "\improper 极光医疗诊所"
	icon_state = "medbay"
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 60
	minimap_color = MINIMAP_AREA_MEDBAY

/area/ice_colony/surface/clinic/lobby
	name = "\improper 极光医疗诊所大厅"

/area/ice_colony/surface/clinic/treatment
	name = "\improper 极光医疗诊所治疗室"
	icon_state = "medbay2"

/area/ice_colony/surface/clinic/storage
	name = "\improper 极光医疗诊所储藏室"
	icon_state = "medbay3"

/*
 * Surface - Colony Administration
 */

/area/ice_colony/surface/command
	name = "\improper 殖民地行政部"
	icon_state = "bridge"
	minimap_color = MINIMAP_AREA_COMMAND

/area/ice_colony/surface/command/checkpoint
	name = "\improper 殖民地行政部安保检查站"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC

/area/ice_colony/surface/command/control
	name = "\improper 殖民地控制中心"
	icon_state = "maintcentral"

/area/ice_colony/surface/command/control/office
	name = "\improper 殖民地控制中心办公室"
	icon_state = "bridge"

/area/ice_colony/surface/command/control/pv1
	name = "\improper 殖民地控制中心私人办公室"
	icon_state = "yellow"

/area/ice_colony/surface/command/control/pv2
	name = "\improper 殖民地控制中心私人办公室"
	icon_state = "green"

/area/ice_colony/surface/command/crisis
	name = "\improper 殖民地危机处理室"
	icon_state = "head_quarters"

/*
 * Surface - Disposals
 */

/area/ice_colony/surface/disposals
	name = "\improper 地表废物处理区"
	icon_state = "disposal"

/*
 * Surface - Dormitories
 */

/area/ice_colony/surface/dorms
	name = "\improper 宿舍"
	icon_state = "Sleep"

/area/ice_colony/surface/dorms/canteen
	name = "\improper 宿舍食堂"
	icon_state = "kitchen"

/area/ice_colony/surface/dorms/lavatory
	name = "\improper 宿舍卫生间"
	icon_state = "janitor"

/area/ice_colony/surface/dorms/restroom_w
	name = "\improper 宿舍西卫生间"
	icon_state = "toilet"

/area/ice_colony/surface/dorms/restroom_e
	name = "\improper 宿舍东卫生间"
	icon_state = "toilet"

/*
 * Surface - Engineering
 */

/area/ice_colony/surface/engineering
	name = "\improper 工程部"
	icon_state = "engine_hallway"
	minimap_color = MINIMAP_AREA_ENGI

/area/ice_colony/surface/engineering/generator
	name = "\improper 工程部发电机室"
	icon_state = "engine"

/area/ice_colony/surface/engineering/electric
	name = "\improper 工程部电气器材储藏室"
	icon_state = "engine_storage"

/area/ice_colony/surface/engineering/tool
	name = "\improper 工程部工具储藏室"
	icon_state = "storage"

/*
 * Surface - Excavation Preparation
 */

/area/ice_colony/surface/excavation
	name = "\improper 挖掘哨站"
	icon_state = "mining_outpost"
	minimap_color = MINIMAP_AREA_ENGI

/area/ice_colony/surface/excavation/storage
	name = "\improper 挖掘哨站外部储藏室"
	icon_state = "mining_storage"

/*
 * Surface - Garage
 */

/area/ice_colony/surface/garage
	name = "\improper 车库"
	icon_state = "garage"

/area/ice_colony/surface/garage/one
	name = "\improper 车库西区"
	icon_state = "garage_one"

/area/ice_colony/surface/garage/two
	name = "\improper 车库东区"
	icon_state = "garage_two"

/area/ice_colony/surface/garage/repair
	name = "\improper 车库维修站"
	icon_state = "engine"

/*
 * Surface - Hangar
 */

/area/ice_colony/surface/hangar
	name = "\improper 机场机库"
	icon_state = "hangar"

/area/ice_colony/surface/hangar/hallway
	name = "\improper 机场机库走廊"
	is_resin_allowed = FALSE

/area/ice_colony/surface/hangar/alpha
	name = "\improper 机场阿尔法机库"
	icon_state = "hangar_alpha"

/area/ice_colony/surface/hangar/beta
	name = "\improper 机场贝塔机库"
	icon_state = "hangar_beta"
	is_resin_allowed = FALSE

/area/ice_colony/surface/hangar/checkpoint
	name = "\improper 机场机库安保检查站"
	icon_state = "security"

/*
 * Surface - Hydroponics
 */

/area/ice_colony/surface/hydroponics
	name = "\improper 冰原殖民地水培区"
	icon_state = "hydro"
	ceiling = CEILING_GLASS
	minimap_color = MINIMAP_AREA_RESEARCH

/area/ice_colony/surface/hydroponics/lobby
	name = "\improper 水培休闲舱室"
	icon_state = "garden"

/area/ice_colony/surface/hydroponics/north
	name = "\improper 水培区北翼"
	icon_state = "hydro_north"

/area/ice_colony/surface/hydroponics/south
	name = "\improper 水培区南翼"
	icon_state = "hydro_south"

/*
 * Surface - Mining
 */

/area/ice_colony/surface/mining
	name = "\improper 采矿哨站"
	icon_state = "mining_production"
	minimap_color = MINIMAP_AREA_ENGI

/*
 * Surface - Power
 */

/area/ice_colony/surface/substation
	name = "\improper 地表变电站"
	icon_state = "dk_yellow"
	minimap_color = MINIMAP_AREA_ENGI

/area/ice_colony/surface/substation/smes
	name = "\improper 地表变电站超导磁储能装置"
	icon_state = "substation"

/*
 * Surface - Requesitions
 */

/area/ice_colony/surface/requesitions
	name = "\improper 地表军需仓库"
	icon_state = "quartstorage"

/*
 * Surface - Research
 */

/area/ice_colony/surface/research
	name = "\improper 奥密克戎穹顶"
	icon_state = "toxlab"
	minimap_color = MINIMAP_AREA_ENGI

/area/ice_colony/surface/research/tech_storage
	name = "\improper 奥密克戎穹顶技术器材储藏室"
	icon_state = "primarystorage"

/area/ice_colony/surface/research/field_gear
	name = "\improper 奥密克戎穹顶野外装备储藏室"
	icon_state = "eva"

/area/ice_colony/surface/research/temporary
	name = "\improper 奥密克戎穹顶临时储藏室"
	icon_state = "storage"

/*
 * Surface - Storage Units
 */

/area/ice_colony/surface/storage_unit
	name = "\improper 储藏单元"
	icon_state = "storage"

/area/ice_colony/surface/storage_unit/research
	name = "\improper 科研储藏单元"
	icon_state = "storage"

/area/ice_colony/surface/storage_unit/telecomms
	name = "\improper 电信储藏单元"
	icon_state = "storage"

/area/ice_colony/surface/storage_unit/power
	name = "\improper 电力储藏单元"
	icon_state = "storage"

/*
 * Surface - Telecommunications
 */

/area/ice_colony/surface/tcomms
	name = "\improper 殖民地电信室"
	icon_state = "tcomsatcham"

/*
 *  -------------------------
 * | Built Underground Areas |
 *  -------------------------
 */

/area/ice_colony/underground
	name = "\improper 冰原殖民地地下建筑区"
	icon_state = "explored"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE
	sound_environment = SOUND_ENVIRONMENT_ROOM
	minimap_color = MINIMAP_AREA_CAVES

/*
 * Underground - Crew Areas
 */

/area/ice_colony/underground/crew
	name = "\improper 地下人员生活区"
	icon_state = "crew_quarters"

/area/ice_colony/underground/crew/dorm_l
	name = "\improper 西部宿舍"
	icon_state = "Sleep"

/area/ice_colony/underground/crew/dorm_r
	name = "\improper 东部宿舍"
	icon_state = "Sleep"

/area/ice_colony/underground/crew/canteen
	name = "\improper 地下食堂"
	icon_state = "kitchen"

/area/ice_colony/underground/crew/disposals
	name = "\improper 地下废物处理区"
	icon_state = "disposal"

/area/ice_colony/underground/crew/lavatory
	name = "\improper 地下卫生间"
	icon_state = "janitor"

/area/ice_colony/underground/crew/leisure
	name = "\improper 地下休闲区"

/area/ice_colony/underground/crew/bball
	name = "\improper 地下体育中心"

/area/ice_colony/underground/crew/chapel
	name = "\improper 地下礼拜堂"

/area/ice_colony/underground/crew/library
	name = "\improper 地下图书馆"
	icon_state = "library"

/area/ice_colony/underground/crew/morgue
	name = "\improper 地下停尸房"
	icon_state = "morgue"

/*
 * Underground - Colony Administration
 */

/area/ice_colony/underground/command
	name = "\improper 地下殖民地行政部"
	icon_state = "bridge"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/ice_colony/underground/command/checkpoint
	name = "\improper 地下殖民地行政部大厅"
	icon_state = "security"

/area/ice_colony/underground/command/center
	name = "\improper 地下殖民地行政部指挥中心"
	icon_state = "head_quarters"

/area/ice_colony/underground/command/pv1
	name = "\improper 地下殖民地行政部私人办公室"
	icon_state = "yellow"

/area/ice_colony/underground/command/pv2
	name = "\improper 地下殖民地行政部私人办公室"
	icon_state = "green"

/*
 * Underground - Engineering
 */

/area/ice_colony/underground/engineering
	name = "\improper 地下工程部"
	icon_state = "engine_hallway"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/ice_colony/underground/engineering/locker
	name = "\improper 地下工程部更衣室"
	icon_state = "storage"


/area/ice_colony/underground/engineering/substation
	name = "\improper 地下变电站"
	icon_state = "substation"

/*
 * Underground - Hallways
 */

/area/ice_colony/underground/hallway
	name = "\improper 地下走廊"
	icon_state = "hallC1"

/area/ice_colony/underground/hallway/north_west
	name = "\improper 地下西北走廊"

/area/ice_colony/underground/hallway/south_east
	name = "\improper 地下东南走廊"
	icon_state = "hallF"

/*
 * Underground - Maintenance
 */

/area/ice_colony/underground/maintenance
	name = "\improper 地下维护区"
	icon_state = "maintcentral"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	base_muffle = MUFFLE_MEDIUM

/area/ice_colony/underground/maintenance/central
	name = "\improper 地下中央维护区"

/area/ice_colony/underground/maintenance/central/construction
	name = "\improper 地下中央维护工程区"
	icon_state = "construction"

/area/ice_colony/underground/maintenance/security
	name = "\improper 地下安保维护区"
	icon_state = "maint_security_port"

/area/ice_colony/underground/maintenance/engineering
	name = "\improper 地下工程维护区"
	icon_state = "maint_engineering"

/area/ice_colony/underground/maintenance/research
	name = "\improper 地下科研维护区"
	icon_state = "maint_research_port"

/area/ice_colony/underground/maintenance/east
	name = "\improper 地下东部维护区"
	icon_state = "fmaint"

/area/ice_colony/underground/maintenance/south
	name = "\improper 地下南部维护区"
	icon_state = "asmaint"

/area/ice_colony/underground/maintenance/north
	name = "\improper 地下北部维护区"
	icon_state = "asmaint"
	is_resin_allowed = FALSE

/*
 * Underground - Medbay
 */

/area/ice_colony/underground/medical
	name = "\improper 地下医疗实验室"
	icon_state = "medbay"
	minimap_color = MINIMAP_AREA_MEDBAY_CAVE

/area/ice_colony/underground/medical/lobby
	name = "\improper 地下医疗实验室大厅"

/area/ice_colony/underground/medical/hallway
	name = "\improper 地下医疗实验室走廊"
	icon_state = "medbay2"

/area/ice_colony/underground/medical/storage
	name = "\improper 地下医疗实验室储藏室"
	icon_state = "storage"

/area/ice_colony/underground/medical/treatment
	name = "\improper 地下医疗实验室治疗室"
	icon_state = "medbay3"

/area/ice_colony/underground/medical/or
	name = "\improper 地下医疗实验室手术室"
	icon_state = "surgery"

/*
 * Underground - Reception
 */

/area/ice_colony/underground/reception
	name = "\improper 地下接待区"
	icon_state = "showroom"

/area/ice_colony/underground/reception/checkpoint_north
	name = "\improper 地下接待区北部安保检查站"
	icon_state = "security"

/area/ice_colony/underground/reception/checkpoint_south
	name = "\improper 地下接待区南部安保检查站"
	icon_state = "security"

/area/ice_colony/underground/reception/toilet_men
	name = "\improper 地下接待区男卫生间"
	icon_state = "toilet"

/area/ice_colony/underground/reception/toilet_women
	name = "\improper 地下接待区女卫生间"
	icon_state = "toilet"

/*
 * Underground - Requesition
 */

/area/ice_colony/underground/requesition
	name = "\improper 地下军需部"
	icon_state = "quart"
	is_resin_allowed = FALSE

/area/ice_colony/underground/requesition/lobby
	name = "\improper 地下军需部大厅"
	icon_state = "quartoffice"

/area/ice_colony/underground/requesition/storage
	name = "\improper 地下军需部储藏室"
	icon_state = "quartstorage"

/area/ice_colony/underground/requesition/sec_storage
	name = "\improper 地下军需部安全储藏室"
	icon_state = "storage"
	is_resin_allowed = TRUE

/*
 * Underground - Research
 */

/area/ice_colony/underground/research
	name = "\improper 西塔-V研究实验室"
	icon_state = "anolab"
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE

/area/ice_colony/underground/research/work
	name = "\improper 西塔-V研究实验室工作站"
	icon_state = "toxmix"

/area/ice_colony/underground/research/storage
	name = "\improper 西塔-V研究实验室储藏室"
	icon_state = "storage"

/area/ice_colony/underground/research/sample
	name = "\improper 西塔-V研究实验室样本隔离区"
	icon_state = "anosample"

/*
 * Underground - Security
 */

/area/ice_colony/underground/security
	name = "\improper 地下安保中心"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC_CAVE

/area/ice_colony/underground/security/marshal
	name = "\improper 法警办公室"
	icon_state = "sec_hos"

/area/ice_colony/underground/security/detective
	name = "\improper 侦探办公室"
	icon_state = "detective"

/area/ice_colony/underground/security/interrogation
	name = "\improper 审讯室"
	icon_state = "interrogation"

/area/ice_colony/underground/security/backroom
	name = "\improper 地下安保中心清洁用品柜"
	icon_state = "sec_backroom"

/area/ice_colony/underground/security/hallway
	name = "\improper 地下安保中心走廊"
	icon_state = "checkpoint1"

/area/ice_colony/underground/security/armory
	name = "\improper 地下安保中心军械库"
	icon_state = "armory"

/area/ice_colony/underground/security/brig
	name = "\improper 地下安保中心禁闭室"
	icon_state = "brig"

/*
 * Underground - Hangar
 */

/area/ice_colony/underground/hangar
	name = "\improper 地下机库"
	icon_state = "hangar"
	ceiling = CEILING_NONE
	is_resin_allowed = FALSE

/*
 * Underground - Storage
 */

/area/ice_colony/underground/storage
	name = "\improper 地下技术器材储藏室"
	icon_state = "storage"

/area/ice_colony/underground/storage/highsec
	name = "\improper 地下高安保技术器材储藏室"
	icon_state = "armory"

//Elevator-------
/area/shuttle/elevator1/ground
	name = "\improper I号电梯"
	icon_state = "shuttlered"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator1/underground
	name = "\improper I号电梯"
	icon_state = "shuttle"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator1/transit
	name = "\improper I号电梯"
	icon_state = "shuttle2"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator2/ground
	name = "\improper II号电梯"
	icon_state = "shuttle"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator2/underground
	name = "\improper II号电梯"
	icon_state = "shuttle2"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator2/transit
	name = "\improper II号电梯"
	icon_state = "shuttlered"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator3/ground
	name = "\improper III号电梯"
	icon_state = "shuttle"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator3/underground
	name = "\improper III号电梯"
	icon_state = "shuttle2"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator3/transit
	name = "\improper III号电梯"
	icon_state = "shuttlered"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator4/ground
	name = "\improper IV号电梯"
	icon_state = "shuttlered"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator4/underground
	name = "\improper IV号电梯"
	icon_state = "shuttle"
	requires_power = TRUE
	unlimited_power = FALSE

/area/shuttle/elevator4/transit
	name = "\improper IV号电梯"
	icon_state = "shuttle2"
	requires_power = TRUE
	unlimited_power = FALSE

/area/ice_colony/landing/console
	name = "\improper 1号着陆区“拉撒路”"
	icon_state = "tcomsatcham"
	requires_power = FALSE

/area/ice_colony/landing/console2
	name = "\improper 2号着陆区“地下”"
	icon_state = "tcomsatcham"
	requires_power = FALSE
