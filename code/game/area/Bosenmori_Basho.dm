//==================================================================BOSENMORI BASHO
//BASE
/area/bosenmori
	name = "博森莫里地区"
	icon_state = "lv626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
//============================================================PARENTS
/area/bosenmori/outside
	name = "博森莫里荒野"
	ceiling = CEILING_NONE
/area/bosenmori/interior_glass
	name = "博森莫里玻璃顶区域"
	ceiling = CEILING_GLASS
/area/bosenmori/interior_regular
	name = "博森莫里屋顶区域"
	ceiling = CEILING_METAL
/area/bosenmori/interior_heavy
	name = "博森莫里加固屋顶区域"
	ceiling = CEILING_REINFORCED_METAL
/area/bosenmori/mountain
	name = "博森莫里山地"
	ceiling = CEILING_DEEP_UNDERGROUND
/area/bosenmori/oob
	name = "oob"
	ceiling = CEILING_METAL
//============================================================SHUTTLES
/area/bosenmori/shuttles/drop1
	name = "博森莫里地区 - 货运降落区"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/bosenmori/shuttles/drop2
	name = "博森莫里地区 - 公司降落区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/bosenmori/shuttles/drop3
	name = "博森莫里地区 - 山地降落区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
//============================================================NEXUS
/area/bosenmori/interior_glass/nexus
	name = "枢纽主大厅"
	icon_state = "hallC1"
/area/bosenmori/interior_regular/security
	name = "安保部"
	icon_state = "security"
/area/bosenmori/interior_regular/security_armory
	name = "军械库"
	icon_state = "armory"
/area/bosenmori/interior_regular/kitchen
	name = "厨房区"
	icon_state = "kitchen"
/area/bosenmori/interior_regular/store
	name = "商店区"
	icon_state = "store"
/area/bosenmori/interior_regular/operations
	name = "殖民地运营中心"
	icon_state = "command"
/area/bosenmori/interior_glass/cargo
	name = "货运部"
	icon_state = "cargo"
/area/bosenmori/interior_glass/shipment
	name = "运输部"
	icon_state = "cargo2"
/area/bosenmori/interior_glass/tree
	name = "生态园"
	icon_state = "green"
//============================================================SOUTH DOMES
/area/bosenmori/interior_regular/engineering
	name = "工程部"
	icon_state = "engineering"
/area/bosenmori/interior_regular/telecommunication
	name = "通讯部"
	icon_state = "yellow"
/area/bosenmori/interior_heavy/secured_armory
	name = "安全军械库"
	icon_state = "storage"
/area/bosenmori/interior_glass/corporate
	name = "维兰德-汤谷公司穹顶"
	icon_state = "blueold"
//============================================================NORTH DOMES above tree
/area/bosenmori/interior_glass/offices
	name = "人力资源部"
	icon_state = "blueold"
/area/bosenmori/interior_glass/fitness
	name = "博森莫里极限体能康复部"
	icon_state = "fitness"
/area/bosenmori/interior_regular/research
	name = "科研部"
	icon_state = "research"
/area/bosenmori/interior_glass/living
	name = "生活区"
	icon_state = "dormitory"
/area/bosenmori/interior_glass/hospital
	name = "医疗部"
	icon_state = "medbay"
/area/bosenmori/interior_glass/food_processing
	name = "食品加工部"
	icon_state = "hydroponics"
/area/bosenmori/interior_glass/filtration
	name = "过滤部"
	icon_state = "filtration"
//============================================================COLONY PROPER EXTERIOR
/area/bosenmori/outside/cargo
	name = "建筑工地"
	icon_state = "cargo"
/area/bosenmori/outside/east_area
	name = "东南区"
	icon_state = "southeast"
/area/bosenmori/outside/south_area
	name = "西南区"
	icon_state = "southwest"
/area/bosenmori/outside/west_area
	name = "西区"
	icon_state = "west"
/area/bosenmori/outside/north_area
	name = "北区"
	icon_state = "north"
/area/bosenmori/outside/west_barrens
	name = "西侧荒地"
	icon_state = "west"
/area/bosenmori/outside/north_barrens
	name = "北侧荒地"
	icon_state = "red"
/area/bosenmori/outside/east_barrens
	name = "东侧荒地"
	icon_state = "east"
/area/bosenmori/outside/filtration
	name = "过滤区"
	icon_state = "bluered"
/area/bosenmori/outside/river
	name = "博森莫里河"
	icon_state = "blue"
//============================================================CAVES
/area/bosenmori/mountain/mining
	name = "采矿区"
	icon_state = "mining"
/area/bosenmori/mountain/abandoned
	name = "废弃区"
	icon_state = "cave"
/area/bosenmori/mountain/pilgrim
	name = "朝圣小径"
	icon_state = "away1"
/area/bosenmori/mountain/river
	name = "洞穴河流"
	icon_state = "blue"
/area/bosenmori/mountain/field_post
	name = "野外科研场地"
	icon_state = "away2"
/area/bosenmori/mountain/temple_proper
	name = "神殿主体"
	icon_state = "away3"
/area/bosenmori/mountain/temple_ruins
	name = "遗迹外围"
	icon_state = "away"
/area/bosenmori/mountain/clearing
	name = "山间空地"
	icon_state = "away1"
//============================================================UNDERGROUND COLONY
/area/bosenmori/interior_heavy/Mai_hall
	name = "维护段"
	icon_state = "away1"
/area/bosenmori/interior_heavy/Mai_tree
	name = "生态园下层"
	icon_state = "away2"
/area/bosenmori/interior_heavy/Mai_sewer
	name = "博森莫里污水系统"
	icon_state = "yellow"
/area/bosenmori/interior_heavy/Mai_research
	name = "科研区下层"
	icon_state = "research"
/area/bosenmori/interior_heavy/Mai_food
	name = "食品加工区下层"
	icon_state = "away3"
/area/bosenmori/interior_heavy/Mai_engineering
	name = "工程区下层"
	icon_state = "smes_engine"
/area/bosenmori/interior_heavy/Mai_armory
	name = "军械库下层"
	icon_state = "security"
/area/bosenmori/interior_heavy/Mai_secure_arm
	name = "安全军械库下层"
	icon_state = "secure"
/area/bosenmori/interior_heavy/Mai_cargo
	name = "货运区下层"
	icon_state = "storage"
/area/bosenmori/interior_heavy/Mai_corpo
	name = "公司区下层"
	icon_state = "wy"
/area/bosenmori/interior_heavy/Mai_caves
	name = "地下局部洞穴网络"
	icon_state = "cave"
/area/bosenmori/interior_heavy/Mai_nexus
	name = "枢纽下层"
	icon_state = "nexus"
/area/bosenmori/interior_heavy/Mai_shipment
	name = "运输区下层"
	icon_state = "cargo"
/area/bosenmori/interior_heavy/Mai_ops
	name = "应急作战区下层"
	icon_state = "command"
/area/bosenmori/interior_glass/Mai_tree_under
	name = "生态园"
	icon_state = "green"
/area/bosenmori/outside/Mai_cargo_under
	name = "建筑工地"
	icon_state = "cargo"
//============================================================UNDERGROUND CAVERNS
/area/bosenmori/mountain/temple_under
	name = "遗迹内部"
	icon_state = "away"
/area/bosenmori/mountain/first_level_caves
	name = "地下洞穴网络"
	icon_state = "away2"
/area/bosenmori/mountain/unknown_level_caves
	name = "Unknown"
	icon_state = "cave"
/area/bosenmori/mountain/unknown_level_temple
	name = "Unknown"
	icon_state = "away3"
/area/bosenmori/mountain/abandoned_dome_under
	name = "废弃穹顶"
	icon_state = "hallc1"
