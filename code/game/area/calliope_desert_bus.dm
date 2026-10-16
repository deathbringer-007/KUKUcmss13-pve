//================================================CALLIOPE DESERT BUS
//BASE
/area/calliope_route
	name = "卡利俄佩公路"
	icon_state = "lv626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
//==============================================PARENTS
/area/calliope_route/highway
	name = "卡利俄佩通道"
	ceiling = CEILING_NONE
/area/calliope_route/exterior_buildings
	name = "建筑内部"
	ceiling = CEILING_METAL
/area/calliope_route/tunnel
	name = "隧道"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL
/area/calliope_route/oob
	name = "oob"
	ceiling = CEILING_DEEP_UNDERGROUND
/area/calliope_route/oob_o
	name = "open oob"
	ceiling = CEILING_NONE
//===============================================SHUTTLES
/area/calliope_route/shuttles/drop1
	name = "新阿肯色 - 外围大门"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/calliope_route/shuttles/drop2
	name = "卡利俄佩公路 - 隧道入口"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/calliope_route/shuttles/drop3
	name = "卡利俄佩公路 - 最南端出口"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/calliope_route/shuttles/drop4
	name = "卡利俄佩公路 - 最南端出口 - 备用"
	icon_state = "shuttle3"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
//===============================================SOUTH
/area/calliope_route/highway/far_south
	name = "公路最南段"
	icon_state = "south"
/area/calliope_route/highway/exchange
	name = "公路立交桥"
	icon_state = "away1"
/area/calliope_route/highway/close_south
	name = "公路南段"
	icon_state = "south"
/area/calliope_route/tunnel/tunnel_s
	name = "隧道南段"
	icon_state = "hall1"
//===============================================NORTH
/area/calliope_route/tunnel/maintenance_hall
	name = "隧道维护段"
	icon_state = "hall2"
/area/calliope_route/tunnel/generator_maints
	name = "隧道维护供电段"
	icon_state = "engine_smes"
/area/calliope_route/tunnel/tunnel_n
	name = "隧道北段"
	icon_state = "hall3"
/area/calliope_route/highway/north
	name = "公路北段"
	icon_state = "north"
/area/calliope_route/tunnel/caves
	name = "公路洞穴系统"
	icon_state = "cave"
//===============================================BUIDLINGS
/area/calliope_route/exterior_buildings/buildings
	name = "公路建筑"
	icon_state = "red"
/area/calliope_route/exterior_buildings/gateways
	name = "公路出入口"
	icon_state = "red"
