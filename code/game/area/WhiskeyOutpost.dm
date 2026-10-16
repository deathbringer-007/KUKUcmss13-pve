/area/whiskey_outpost
	name = "\improper 威士忌哨站"
	icon = 'icons/turf/area_whiskey.dmi'
	icon_state = "outside"
	ceiling = CEILING_METAL
	powernet_name = "ground"

/*
|***INSIDE AREAS***|
*/

/area/whiskey_outpost/inside
	name = "威士忌哨站内部"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	minimap_color = MINIMAP_AREA_CAVES

/area/whiskey_outpost/inside/hospital
	name = "\improper 医院"
	icon_state = "medical"
	minimap_color = MINIMAP_AREA_MEDBAY_CAVE

/area/whiskey_outpost/inside/hospital/triage
	name = "\improper 分诊中心"

/area/whiskey_outpost/inside/cic
	name = "\improper 作战情报中心"
	icon_state = "CIC"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/whiskey_outpost/inside/bunker
	name = "\improper 地堡"
	icon_state = "bunker"

/area/whiskey_outpost/inside/bunker/pillbox
	ceiling = CEILING_METAL

/area/whiskey_outpost/inside/bunker/pillbox/one
	name = "波本碉堡"
	icon_state = "p1"

/area/whiskey_outpost/inside/bunker/pillbox/two
	name = "葡萄酒碉堡"
	icon_state = "p2"

/area/whiskey_outpost/inside/bunker/pillbox/three
	name = "伏特加碉堡"
	icon_state = "p3"

/area/whiskey_outpost/inside/bunker/pillbox/four
	name = "龙舌兰碉堡"
	icon_state = "p4"

/area/whiskey_outpost/inside/bunker/bunker/front
	name = "啤酒碉堡"
	icon_state = "p5"


/area/whiskey_outpost/inside/engineering
	name = "\improper 工程区"
	icon_state = "engineering"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/whiskey_outpost/inside/living
	name = "\improper 生活区"
	icon_state = "livingspace"

/area/whiskey_outpost/inside/supply
	name = "\improper 补给仓库"
	icon_state = "req"

/*
|***OUTSIDE AREAS***|
*/

/area/whiskey_outpost/outside
	name = "\improper Unused"
	icon_state = "outside"
	ceiling = CEILING_NONE
	//ambience = list('sound/ambience/jungle_amb1.ogg')
	requires_power = 1
	always_unpowered = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	minimap_color = MINIMAP_AREA_COLONY

/area/whiskey_outpost/outside/north
	name = "\improper 北侧海滩"
	icon_state = "north"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/whiskey_outpost/outside/north/northwest
	name = "\improper 西北海滩"
	icon_state = "northwest"

/area/whiskey_outpost/outside/north/northeast
	name = "\improper 东北海滩"
	icon_state = "northeast"

/area/whiskey_outpost/outside/north/beach
	name = "\improper 地堡海滩"
	icon_state = "farnorth"

/area/whiskey_outpost/outside/north/platform
	name = "\improper 地堡平台"
	icon_state = "platform"

/area/whiskey_outpost/outside/lane

/area/whiskey_outpost/outside/lane/one_north
	name = "\improper 西侧丛林北段"
	icon_state = "lane1n"

/area/whiskey_outpost/outside/lane/one_south
	name = "\improper 西侧丛林南段"
	icon_state = "lane1s"

/area/whiskey_outpost/outside/lane/two_north
	name = "\improper 西侧小径北段"
	icon_state = "lane2n"

/area/whiskey_outpost/outside/lane/two_south
	name = "\improper 西侧小径南段"
	icon_state = "lane2s"

/area/whiskey_outpost/outside/lane/three_north
	name = "\improper 东侧小径北段"
	icon_state = "lane3n"

/area/whiskey_outpost/outside/lane/three_south
	name = "\improper 东侧小径南段"
	icon_state = "lane3s"

/area/whiskey_outpost/outside/lane/four_north
	name = "\improper 东侧坠毁点北段"
	icon_state = "lane4n"

/area/whiskey_outpost/outside/lane/four_south
	name = "\improper 东侧坠毁点南段"
	icon_state = "lane4s"

//lane4south
/area/whiskey_outpost/outside/south
	name = "\improper 外围入口"
	icon_state = "south"

/area/whiskey_outpost/outside/south/far
	name = "南侧丛林"
	icon_state = "farsouth"

/area/whiskey_outpost/outside/south/very_far
	name = "\improper 最南侧丛林"
	icon_state = "veryfarsouth"

/area/whiskey_outpost/outside/mortar_pit
	name = "\improper 迫击炮阵地"
	icon_state = "mortarpit"

/area/whiskey_outpost/outside/river
	name = "\improper 里科河中段"
	icon_state = "river"

/area/whiskey_outpost/outside/river/east
	name = "\improper 里科河东段"
	icon_state = "rivere"

/area/whiskey_outpost/outside/river/west
	name = "\improper 里科河西段"
	icon_state = "riverw"

/*
|***CAVE AREAS***|
*/

/area/whiskey_outpost/inside/caves
	name = "\improper 岩石区"
	icon_state = "rock"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambisin4.ogg')
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	requires_power = 1
	always_unpowered = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE

/area/whiskey_outpost/inside/caves/tunnel
	name = "\improper 隧道"
	icon_state = "tunnel"
	flags_area = AREA_NOTUNNEL

/area/whiskey_outpost/inside/caves/caverns
	name = "\improper 北侧洞窟"
	icon_state = "caves"
/area/whiskey_outpost/inside/caves/caverns/west
	name = "\improper 西侧洞窟"
	icon_state = "caveswest"

/area/whiskey_outpost/inside/caves/caverns/east
	name = "\improper 东侧洞窟"
	icon_state = "caveseast"
