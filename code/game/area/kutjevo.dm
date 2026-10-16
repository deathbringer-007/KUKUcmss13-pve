
//Areas for the Kutjevo Refinery

/area/kutjevo
	name = "库特耶沃精炼厂"
	icon = 'icons/turf/area_kutjevo.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "kutjevo"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	temperature = 308.7 //kelvin, 35c, 95f
	minimap_color = MINIMAP_AREA_ENGI

/area/shuttle/drop1/kutjevo
	name = "库特耶沃 - 阿拉莫号运输机降落区"
	icon_state = "shuttle"
	icon = 'icons/turf/area_kutjevo.dmi'

/area/shuttle/drop2/kutjevo
	name = "库特耶沃 - 诺曼底号运输机降落区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_kutjevo.dmi'

/area/kutjevo/exterior
	name = "库特耶沃 - 外部"
	ceiling = CEILING_NONE
	icon_state = "ext"


/area/kutjevo/interior
	name = "库特耶沃 - 内部"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "int"
	requires_power = 1

/area/kutjevo/interior/oob
	name = "Kutjevo -  Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

/area/kutjevo/interior/oob/dev_room
	name = "库特耶沃 - 制作人员室"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	icon_state = "kutjevo"

//exterior map areas

/area/kutjevo/exterior/lz_pad
	name = "库特耶沃辅助降落区"
	icon_state = "lz_pad"
	weather_enabled = FALSE
	unlimited_power = 1//ds computer
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/kutjevo/exterior/lz_dunes
	name = "库特耶沃 - 降落区沙丘"
	icon_state = "lz_dunes"
	is_resin_allowed = FALSE
	weather_enabled =  FALSE
	unlimited_power = 1//DS Computer
	is_landing_zone = TRUE

/area/kutjevo/exterior/lz_river
	name = "库特耶沃 - 电站河流"
	icon_state = "lz_river"

/area/kutjevo/exterior/spring
	name = "库特耶沃 - 南侧泉水"
	icon_state = "lz_river"

/area/kutjevo/exterior/scrubland
	name = "库特耶沃 - 灌木地"
	icon_state = "scrubland"

/area/kutjevo/exterior/stonyfields
	name = "库特耶沃 - 乱石地"
	icon_state = "stone_fields"

/area/kutjevo/exterior/Northwest_Colony
	name = "库特耶沃 - 殖民地西北场区"
	icon_state = "rf_dunes"
	is_resin_allowed = FALSE

/area/kutjevo/exterior/runoff_dunes
	name = "库特耶沃 - 排水沙丘"
	icon_state = "rf_dunes"

/area/kutjevo/exterior/runoff_river
	name = "库特耶沃 - 排水河"
	icon_state = "rf_river"

/area/kutjevo/exterior/runoff_bridge
	name = "库特耶沃 - 排水河桥"
	icon_state = "rf_bridge"

/area/kutjevo/exterior/overlook
	name = "库特耶沃 - 排水河眺望台"
	icon_state = "rf_overlook"

/area/kutjevo/exterior/botany_bay_ext
	name = "库特耶沃 - 太空大麻农场外部"
	icon_state = "weed_ext"

/area/kutjevo/exterior/construction
	name = "库特耶沃 - 废弃工地"
	icon_state = "construction"

/area/kutjevo/exterior/complex_border
	name = "库特耶沃综合区 - 外部"
	icon_state = "kutjevo"

/area/kutjevo/exterior/complex_border/botany_medical_cave
	name = "库特耶沃综合区 - 植物区 - 医疗区洞穴"
	icon_state = "med_ext"

/area/kutjevo/exterior/complex_border/med_park
	name = "库特耶沃综合区 - 医疗区公园"
	icon_state = "med_ext"

/area/kutjevo/exterior/complex_border/med_rec
	name = "库特耶沃综合区 - 水箱洞穴"
	icon_state = "construction2"

//telecomms areas
/area/kutjevo/exterior/telecomm
	name = "库特耶沃 - 通讯中继站"
	icon_state = "ass_line"
	is_resin_allowed = FALSE
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_LOW

/area/kutjevo/exterior/telecomm/lz1_north
	name = "库特耶沃 - 一号降落区北侧通讯中继站"

/area/kutjevo/exterior/telecomm/lz1_south
	name = "库特耶沃 - 一号降落区南侧通讯中继站"

/area/kutjevo/exterior/telecomm/lz2_north
	name = "库特耶沃 - 二号降落区北侧通讯中继站"

/area/kutjevo/exterior/telecomm/lz2_south
	name = "库特耶沃 - 二号降落区南侧通讯中继站"

//interior areas + caves

//Primary Colony Buildings
/area/kutjevo/interior/complex
	name = "库特耶沃综合区"
	ceiling = CEILING_METAL
	icon_state = "kutjevo"

/area/kutjevo/interior/complex/botany
	name = "库特耶沃综合区 - 植物栽培区"
	icon_state = "botany0"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/kutjevo/interior/complex/botany/east
	name = "库特耶沃综合区 - 植物区东厅"
	icon_state = "botany1"

/area/kutjevo/interior/complex/botany/east_tech
	name = "库特耶沃综合区 - 发电厂通道"
	icon_state = "botany1"

/area/kutjevo/interior/complex/botany/locks
	name = "库特耶沃综合区 - 植物区防风气闸"
	icon_state = "botany0"

/area/kutjevo/interior/complex/med
	name = "库特耶沃综合区 - 医疗区门厅"
	icon_state = "med0"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/kutjevo/interior/complex/med/auto_doc
	name = "库特耶沃综合区 - 自动医疗机走廊"
	icon_state = "med2"

/area/kutjevo/interior/complex/med/operating
	name = "库特耶沃综合区 - 医疗区手术走廊"
	icon_state = "med3"

/area/kutjevo/interior/complex/med/triage
	name = "库特耶沃综合区 - 医疗区分诊走廊"
	icon_state = "med4"

/area/kutjevo/interior/complex/med/cells
	name = "库特耶沃综合区 - 医疗区冷冻休眠舱"
	icon_state = "med5"

/area/kutjevo/interior/complex/med/pano
	name = "库特耶沃综合区 - 医疗区全景监视室"
	icon_state = "med3"

/area/kutjevo/interior/complex/med/locks
	name = "库特耶沃综合区 - 医疗区防风气闸"
	icon_state = "med1"

/area/kutjevo/interior/complex/Northwest_Dorms
	name = "库特耶沃综合区 - 殖民地西北宿舍"
	icon_state = "Colony_int"
	ceiling = CEILING_METAL
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/kutjevo/interior/complex/Northwest_Flight_Control
	name =  "库特耶沃综合区 - 西北飞行控制室"
	icon_state = "Colony_int"
	ceiling = CEILING_METAL
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/kutjevo/interior/complex/Northwest_Security_Checkpoint
	name = "库特耶沃综合区 - 西北安保检查站"
	icon_state = "Colony_int"
	ceiling = CEILING_METAL
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_SEC
	is_landing_zone = TRUE

//Out buildings + foremans
/area/kutjevo/interior/power
	name = "库特耶沃 - 水电大坝变电站"
	ceiling = CEILING_METAL
	icon_state = "power"
	minimap_color = MINIMAP_AREA_ENGI

/area/kutjevo/interior/power/comms
	name = "库特耶沃 - 水电大坝通讯中继站"
	ceiling = CEILING_METAL
	icon_state = "power"

/area/kutjevo/interior/construction
	name = "库特耶沃 - 废弃工地内部"
	ceiling = CEILING_METAL
	icon_state = "construction_int"

/area/kutjevo/interior/foremans_office
	name = "库特耶沃 - 工头办公室"
	ceiling = CEILING_METAL
	icon_state = "foremans"

/area/kutjevo/interior/botany_bay_int
	name = "库特耶沃 - 太空大麻农场内部"
	ceiling = CEILING_METAL
	icon_state = "weed_int"

/area/kutjevo/interior/power_pt2_electric_boogaloo
	name = "库特耶沃 - 发电厂"
	ceiling = CEILING_METAL
	icon_state = "power_2"

/area/kutjevo/interior/colony
	name = "库特耶沃 - 殖民地建筑内部"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	icon_state = "colony_int"

/area/kutjevo/interior/colony_central
	name = "库特耶沃 - 殖民地中央洞穴"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_0"
	minimap_color = MINIMAP_AREA_CAVES

/area/kutjevo/interior/colony_central/mine_elevator
	name = "库特耶沃 - 殖民地中央电梯"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_0"

/area/kutjevo/interior/colony_north
	name = "库特耶沃 - 殖民地北侧洞穴"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_1"

/area/kutjevo/interior/colony_S_East
	name = "库特耶沃 - 殖民地东北洞穴"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_2"

/area/kutjevo/interior/colony_N_East
	name = "库特耶沃 - 殖民地东南洞穴"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_2"

/area/kutjevo/interior/colony_South
	name = "库特耶沃 - 殖民地南侧洞穴"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_3"

/area/kutjevo/interior/colony_South/power2
	name = "库特耶沃 - 殖民地南侧处理厂"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_3"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
