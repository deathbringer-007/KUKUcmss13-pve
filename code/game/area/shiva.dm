//Areas for Shiva's Snowball, aka Ice LZ1, above ground revamp.

/area/shiva
	name = "湿婆雪球"
	icon = 'icons/turf/area_shiva.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "shiva"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	temperature = ICE_COLONY_TEMPERATURE
	minimap_color = MINIMAP_AREA_COLONY

/area/shuttle/drop1/shiva
	name = "湿婆雪球 - 阿拉莫号运输机降落区"
	icon_state = "shuttle"
	icon = 'icons/turf/area_shiva.dmi'
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

/area/shuttle/drop2/shiva
	name = "湿婆雪球 - 诺曼底号运输机降落区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_shiva.dmi'
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/lz1_console
	name = "湿婆雪球 - 阿拉莫号运输机控制台"
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/lz1_console/two
	name = "湿婆雪球 - 诺曼底号运输机控制台"
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior
	name = "湿婆雪球 - 外部"
	ceiling = CEILING_NONE


/area/shiva/interior
	name = "湿婆雪球 - 内部"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	requires_power = TRUE

/area/shiva/interior/oob
	name = "Shiva's Snowball - Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

/area/shiva/interior/oob/dev_room
	name = "湿婆雪球 - 秘密房间"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	icon_state = "shiva"

//telecomms areas - exterior
/area/shiva/exterior/telecomm
	name = "湿婆雪球 - 通讯中继站"
	icon_state = "ass_line"
	is_resin_allowed = FALSE

/area/shiva/exterior/telecomm/lz1_north
	name = "湿婆雪球 - 一号降落区北侧通讯中继站"
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/telecomm/lz2_southeast
	name = "湿婆雪球 - 二号降落区东南通讯中继站"
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/telecomm/lz2_northeast
	name = "湿婆雪球 - 二号降落区东北通讯中继站"
	minimap_color = MINIMAP_AREA_LZ


//telecomms areas - interior
/area/shiva/interior/telecomm
	name = "湿婆雪球 - 通讯中继站"
	icon_state = "ass_line"
	is_resin_allowed = FALSE

/area/shiva/interior/telecomm/lz1_biceps
	name = "湿婆雪球 - 肱二头肌堡通讯中继站"
	icon_state = "hangars0"
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/interior/telecomm/lz1_flight
	name = "湿婆雪球 - 一号降落区机场通讯中继站"
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/interior/telecomm/lz2_research
	name = "湿婆雪球 - 阿根廷通讯中继站"
	minimap_color = MINIMAP_AREA_LZ

//telecomms areas - caves
/area/shiva/caves/telecomm
	name = "湿婆雪球 - 通讯中继站"
	icon_state = "ass_line"
	is_resin_allowed = FALSE

/area/shiva/caves/telecomm/lz2_south
	name = "湿婆雪球 - 备用通讯中继站"
	minimap_color = MINIMAP_AREA_LZ

//exterior areas

/area/shiva/exterior/lz1_valley
	name = "湿婆雪球 - 降落山谷"
	icon_state = "landing_valley"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/lz2_fortress
	name = "湿婆雪球 - 降落区壁垒"
	icon_state = "lz2_fortress"
	is_resin_allowed = FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/exterior/valley
	name = "湿婆雪球 - 山谷储物地堡"
	icon_state = "junkyard1"

/area/shiva/exterior/cp_colony_grounds
	name = "湿婆雪球 - 殖民地场区"
	icon_state = "junkyard2"

/area/shiva/exterior/junkyard
	name = "湿婆雪球 - 废料场"
	icon_state = "junkyard0"

/area/shiva/exterior/junkyard/fortbiceps
	name = "湿婆雪球 - 肱二头肌堡"
	icon_state = "junkyard1"

/area/shiva/exterior/junkyard/cp_bar
	name = "湿婆雪球 - 酒吧场区"
	icon_state = "bar0"

/area/shiva/exterior/cp_s_research
	name = "湿婆雪球 - 科研居住舱外部"
	icon_state = "junkyard1"

/area/shiva/exterior/cp_lz2
	name = "湿婆雪球 - 殖民地北侧场区"
	icon_state = "junkyard3"

/area/shiva/exterior/research_alley
	name = "湿婆雪球 - 科研区南侧小巷"
	icon_state = "junkyard2"
	minimap_color = MINIMAP_AREA_RESEARCH



//interior areas

/area/shiva/interior/caves
	name = "湿婆雪球 - 洞穴"
	icon_state = "caves0"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS

/area/shiva/interior/caves/right_spiders
	name = "湿婆雪球 - 遗忘通道"
	icon_state = "caves1"

/area/shiva/interior/caves/left_spiders
	name = "湿婆雪球 - 裂隙通道"
	icon_state = "caves2"

/area/shiva/interior/caves/s_lz2
	name = "湿婆雪球 - 二号降落区南侧洞穴"
	icon_state = "caves3"
	minimap_color = MINIMAP_AREA_LZ

/area/shiva/interior/caves/cp_camp
	name = "湿婆雪球 - 洞穴营地"
	icon_state = "bar3"

/area/shiva/interior/caves/research_caves
	name = "湿婆雪球 - 南侧科研居住舱洞穴"
	icon_state = "caves2"
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE

/area/shiva/interior/caves/medseceng_caves
	name = "湿婆雪球 - 南侧医疗安保工程综合区洞穴"
	icon_state = "caves3"

/area/shiva/interior/colony
	name = "湿婆雪球 - 殖民地巨构(TM)"
	icon_state = "res0"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/shiva/interior/colony/botany
	name = "湿婆雪球 - 巨构(TM)植物区宿舍"
	icon_state = "res1"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/shiva/interior/colony/s_admin
	name = "湿婆雪球 - 巨构(TM)危机中心"
	icon_state = "res2"

/area/shiva/interior/colony/n_admin
	name = "湿婆雪球 - 巨构(TM)行政区"
	icon_state = "res3"
	minimap_color = MINIMAP_AREA_COMMAND

/area/shiva/interior/colony/central
	name = "湿婆雪球 - 巨构(TM)住宅区"
	icon_state = "res4"

/area/shiva/interior/colony/research_hab
	name = "湿婆雪球 - 科研居住舱内部"
	icon_state = "res2"

/area/shiva/interior/colony/medseceng
	name = "湿婆雪球 - 殖民地巨构(TM)医疗安保工程段"
	icon_state = "res0"

/area/shiva/interior/colony/deck
	name = "湿婆雪球 - 殖民地巨构(TM)露天甲板"
	icon_state = "res1"
	ceiling = CEILING_GLASS

/area/shiva/interior/aerodrome
	name = "湿婆雪球 - 机场"
	icon_state = "hangars0"

/area/shiva/interior/bar
	name = "湿婆雪球 - 防冻酒吧"
	icon_state = "hangars0"

/area/shiva/interior/fort_biceps
	name = "湿婆雪球 - 肱二头肌堡内部"
	icon_state = "hangars0"

/area/shiva/interior/warehouse
	name = "湿婆雪球 - 蓝色仓库"
	icon_state = "hangars1"

/area/shiva/interior/warehouse/caves
	name = "湿婆雪球 - 蓝色仓库冰洞"
	icon_state = "caves1"

/area/shiva/interior/valley_huts
	name = "湿婆雪球 - 山谷一号地堡"
	icon_state = "hangars1"

/area/shiva/interior/valley_huts/no2
	name = "湿婆雪球 - 山谷二号地堡"
	icon_state = "hangars2"

/area/shiva/interior/valley_huts/disposals
	name = "湿婆雪球 - 山谷垃圾处理区"
	icon_state = "hangars3"

/area/shiva/interior/garage
	name = "湿婆雪球 - 货运牵引车维修站"
	icon_state = "hangars2"

/area/shiva/interior/lz2_habs
	name = "湿婆雪球 - 阿根廷科研总部"
	icon_state = "bar1"
	is_landing_zone = TRUE

/area/shiva/interior/aux_power
	name = "湿婆雪球 - 辅助发电站"
	icon_state = "hangars0"
