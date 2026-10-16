//==================================================================SEKHMET SWAMP
//BASE
/area/sekhmet
	name = "塞赫迈特沼泽"
	icon_state = "lv626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
//============================================================PARENTS
/area/sekhmet/outside
	name = "塞赫迈特室外区"
	ceiling = CEILING_NONE
/area/sekhmet/int_glass
	name = "塞赫迈特玻璃顶区域"
	ceiling = CEILING_GLASS
/area/sekhmet/int_reg
	name = "塞赫迈特金属顶区域"
	ceiling = CEILING_METAL
/area/sekhmet/int_heavy
	name = "塞赫迈特加固顶区域"
	ceiling = CEILING_REINFORCED_METAL
/area/sekhmet/caves
	name = "塞赫迈特洞穴"
	ceiling = CEILING_DEEP_UNDERGROUND
//============================================================SHUTTLES
/area/sekhmet/shuttles/drop1
	name = "塞赫迈特 - 军事停机坪"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/sekhmet/shuttles/drop2
	name = "塞赫迈特 - 开阔地"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/sekhmet/shuttles/drop3
	name = "塞赫迈特 - 科研停机坪"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
//============================================================NORTHWEST PORTION (military base, swamps, communication lower, air filtration, caves)
/area/sekhmet/int_reg/military_hangar
	name = "UPP军事降落区"
	icon_state = "away1"
/area/sekhmet/int_reg/catwalk
	name = "沼泽栈道"
	icon_state = "away2"
/area/sekhmet/outside/swamp
	name = "塞赫迈特沼泽"
	icon_state = "northwest"
/area/sekhmet/int_reg/comms_lower
	name = "塞赫迈特下层通讯厅"
	icon_state = "away3"
/area/sekhmet/int_reg/air_filters
	name = "塞赫迈特空气过滤区"
	icon_state = "away3"
/area/sekhmet/caves/west_cave
	name = "塞赫迈特西侧洞穴"
	icon_state = "cave"
//============================================================SOUTHWEST PORTION (airfield, medbay, warehouse)
/area/sekhmet/outside/airfield
	name = "塞赫迈特空地"
	icon_state = "southwest"
/area/sekhmet/int_glass/hosptial
	name = "塞赫迈特治疗中心"
	icon_state = "medbay"
/area/sekhmet/int_reg/southwest_complex
	name = "塞赫迈特西南综合区"
	icon_state = "away1"
/area/sekhmet/int_reg/warehouse
	name = "塞赫迈特仓库"
	icon_state = "cargo"
/area/sekhmet/outside/southroad
	name = "塞赫迈特南侧小径"
	icon_state = "south"
/area/sekhmet/caves/south_cave
	name = "塞赫迈特南侧洞穴"
	icon_state = "cave"
//============================================================CENTRAL PORTION (central complex, yard, roadways, comms)
/area/sekhmet/outside/central_road
	name = "塞赫迈特中央小径"
	icon_state = "away2"
/area/sekhmet/int_glass/complex_generic
	name = "塞赫迈特中央综合区"
	icon_state = "away1"
/area/sekhmet/int_reg/complex_intel
	name = "塞赫迈特情报部"
	icon_state = "blue-red2"
/area/sekhmet/int_reg/complex_operation
	name = "塞赫迈特作战部"
	icon_state = "blue"
/area/sekhmet/int_reg/complex_comms
	name = "塞赫迈特通讯阵列"
	icon_state = "away3"
/area/sekhmet/int_glass/south_complex
	name = "塞赫迈特南侧综合区"
	icon_state = "green"
/area/sekhmet/int_reg/water_filters
	name = "塞赫迈特净水区"
	icon_state = "red"
/area/sekhmet/int_glass/offices
	name = "塞赫迈特行政办公室"
	icon_state = "yellow"
/area/sekhmet/int_reg/engineering
	name = "塞赫迈特工程区"
	icon_state = "SMES"
/area/sekhmet/int_heavy/entry_zone
	name = "塞赫迈特入口区"
	icon_state = "red"
/area/sekhmet/int_reg/yard
	name = "塞赫迈特拆解场"
	icon_state = "blue-red2"
//============================================================EAST PORTION (research, jungle, temple)
/area/sekhmet/outside/east_jungle
	name = "塞赫迈特东侧丛林"
	icon_state = "east"
/area/sekhmet/caves/temple
	name = "塞赫迈特遗迹"
	icon_state = "cave"
/area/sekhmet/outside/temple_outer
	name = "塞赫迈特遗迹外围"
	icon_state = "northwest"
/area/sekhmet/outside/southeast_road
	name = "塞赫迈特东南小径"
	icon_state = "southeast"
/area/sekhmet/int_heavy/research
	name = "塞赫迈特科研主层"
	icon_state = "research"
/area/sekhmet/int_reg/garage
	name = "塞赫迈特车库"
	icon_state = "yellow"
//============================================================UNDERGROUND PORTION (Very Lazy Two Sectors)
/area/sekhmet/int_heavy/low_level_gen
	name = "塞赫迈特下层综合区"
	icon_state = "red"
/area/sekhmet/int_heavy/low_level_rsr
	name = "塞赫迈特下层科研区"
	icon_state = "green"
//============================================================EXTRA PORTION
/area/sekhmet/int_reg/ship1
	name = "创世纪级货船米哈伊尔号"
	icon_state = "blue-red2"
/area/sekhmet/int_reg/ship2
	name = "塞阔德级运输船阿特柔斯号"
	icon_state = "blue-red2"
