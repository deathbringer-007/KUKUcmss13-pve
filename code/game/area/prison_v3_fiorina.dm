
//areas for new prison (I want to leave the legacy ones intact yo)

/area/fiorina
	name = "菲奥里纳轨道监狱 - 科研附属区"
	icon = 'icons/turf/area_prison_v3_fiorina.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "fiorina"
	can_build_special = TRUE //T-Comms structure
	temperature = T20C
	ceiling = CEILING_GLASS
	minimap_color = MINIMAP_AREA_COLONY

/area/fiorina/oob
	name = "Fiorina - Out Of Bounds"
	icon_state = "oob"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

/area/fiorina/maintenance
	name = "菲奥里纳 - 维护区"
	ceiling = CEILING_METAL
	icon_state = "maints"

//tumor / hive areas aka the place that is CAS immune
/area/fiorina/tumor
	name = "菲奥里纳 - 树脂瘤"
	icon_state = "tumor0"
	temperature = 309.15 //its uh, gettin' kinda warm in here SL...
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
/area/fiorina/tumor/deep
	icon_state = "tumor0-deep"

/area/fiorina/tumor/fiberbush
	name = "菲奥里纳 - 纤维灌木蔓生区"
	icon_state = "tumor-fiberbush"

/area/fiorina/tumor/ship
	name = "菲奥里纳 - 拾荒船NSV雷诺号"
	icon_state = "tumor1"
	requires_power = 0
	minimap_color = MINIMAP_AREA_SHIP

/area/fiorina/tumor/civres
	name = "菲奥里纳 - 绿色监区住宅"
	icon_state = "tumor0"

/area/fiorina/tumor/aux_engi
	name = "菲奥里纳 - 工程区"
	icon_state = "tumor2"
	minimap_color = MINIMAP_AREA_ENGI

/area/fiorina/tumor/servers
	name = "菲奥里纳 - 科研服务器区"
	icon_state = "tumor2"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/fiorina/tumor/ice_lab
	name = "菲奥里纳 - 低温研究实验室"
	icon_state = "tumor3"
	minimap_color = MINIMAP_AREA_RESEARCH



//LZ CODE
/area/fiorina/lz
	icon_state = "lz"
	ceiling = CEILING_GLASS
	name = "菲奥里纳 - 降落区"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/fiorina/lz/near_lzI
	name = "菲奥里纳 - 一号降落区辅助港"

/area/fiorina/lz/near_lzII
	name = "菲奥里纳 - 二号降落区监狱港"

/area/fiorina/lz/console_I
	name = "菲奥里纳 - 一号降落区控制台"
	icon_state = "lz1"
	requires_power = 0

/area/fiorina/lz/console_II
	name = "菲奥里纳 - 二号降落区控制台"
	icon_state = "lz2"
	requires_power = 0

/area/shuttle/drop1/prison_v3
	name = "菲奥里纳 - 阿拉莫号运输机降落区"
	icon_state = "shuttle"
	is_resin_allowed = FALSE

/area/shuttle/drop2/prison_v3
	name = "菲奥里纳 - 诺曼底号降落区"
	icon_state = "shuttle2"
	is_resin_allowed = FALSE

//STATION AREAS AAAA
/area/fiorina/station
	name = "菲奥里纳 - 空间站内部"
	icon_state = "station0"
	ceiling = CEILING_GLASS

/area/fiorina/station/lowsec
	name = "菲奥里纳 - 低警戒监区"
	icon_state = "station1"

/area/fiorina/station/power_ring
	name = "菲奥里纳 - 工程环区"
	icon_state = "power0"
	minimap_color = MINIMAP_AREA_ENGI

/area/fiorina/station/disco
	name = "菲奥里纳 - 迪斯科储物间"
	icon_state = "disco"

/area/fiorina/station/flight_deck
	name = "菲奥里纳 - 飞行甲板"
	icon_state = "police_line"

/area/fiorina/station/security
	name = "菲奥里纳 - 安保中心"
	icon_state = "security_hub"
	minimap_color = MINIMAP_AREA_SEC

/area/fiorina/station/security/wardens
	name = "菲奥里纳 - 典狱长办公室"
	icon_state = "wardens"
	minimap_color = MINIMAP_AREA_SEC

/area/fiorina/station/botany
	name = "菲奥里纳 - 植物栽培盘区"
	icon_state = "botany"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/fiorina/station/park
	name = "菲奥里纳 - 公园"
	icon_state = "station0"

/area/fiorina/station/transit_hub
	name = "菲奥里纳 - 交通枢纽"
	icon_state = "station1"

/area/fiorina/station/central_ring
	name = "菲奥里纳 - 中央环区"
	icon_state = "station2"

/area/fiorina/station/chapel
	name = "菲奥里纳 - 礼拜堂"
	icon_state = "station3"

/area/fiorina/station/civres_blue
	name = "菲奥里纳 - 蓝色监区住宅"
	icon_state = "station1"

/area/fiorina/station/medbay
	name = "菲奥里纳 - 医务室"
	icon_state = "station4"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/fiorina/station/research_cells
	name = "菲奥里纳 - 科研监区"
	icon_state = "station0"
	minimap_color = MINIMAP_AREA_RESEARCH


//telecomms areas
/area/fiorina/station/telecomm
	name = "菲奥里纳 - 通讯中继站"
	icon_state = "ass_line"
	is_resin_allowed = FALSE
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_LOW

/area/fiorina/station/telecomm/lz1_cargo
	name = "菲奥里纳 - 一号降落区货运通讯中继站"

/area/fiorina/station/telecomm/lz1_containers
	name = "菲奥里纳 - 一号降落区集装箱通讯中继站"

/area/fiorina/station/telecomm/lz1_tram
	name = "菲奥里纳 - 一号降落区辅助港通讯中继站"
	is_landing_zone = TRUE

/area/fiorina/station/telecomm/lz1_engineering
	name = "菲奥里纳 - 工程区主通讯中继站"

/area/fiorina/station/telecomm/lz2_engineering
	name = "菲奥里纳 - 工程区副通讯中继站"

/area/fiorina/station/telecomm/lz2_north
	name = "菲奥里纳 - 二号降落区北侧通讯中继站"

/area/fiorina/station/telecomm/lz2_maint
	name = "菲奥里纳 - 备用通讯中继站"
