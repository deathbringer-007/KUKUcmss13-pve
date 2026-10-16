//================================================CALLIOPE HIGHWAY
//BASE
/area/calliope
	name = "卡利俄佩公路"
	icon_state = "lv626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
//==============================================PARENTS
/area/calliope/highway
	name = "卡利俄佩通道"
	ceiling = CEILING_NONE
/area/calliope/exterior_buildings
	name = "建筑内部"
	ceiling = CEILING_METAL
/area/calliope/bunker
	name = "斯特林地堡"
	ceiling = CEILING_REINFORCED_METAL
/area/calliope/bunker_exterior_buildings
	name = "斯特林外围"
	ceiling = CEILING_METAL
/area/calliope/oob
	name = "oob"
	ceiling = CEILING_DEEP_UNDERGROUND
/area/calliope/oob_o
	name = "open oob"
	ceiling = CEILING_NONE
//===============================================SHUTTLES
/area/calliope/shuttles/drop1
	name = "斯特林哨站 - 检查站降落区"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/calliope/shuttles/drop2
	name = "卡利俄佩公路 - 北侧进场区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/calliope/shuttles/drop3
	name = "卡利俄佩公路 - 南侧进场区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
//===============================================HIGHWAY
/area/calliope/highway/northbound
	name = "卡利俄佩公路北向车道"
	icon_state = "north"
/area/calliope/highway/southbound
	name = "卡利俄佩公路南向车道"
	icon_state = "south"
/area/calliope/highway/checkpoint
	name = "卡利俄佩公路检查站"
	icon_state = "central"
/area/calliope/exterior_buildings/north_buildings
	name = "卡利俄佩公路建筑"
	icon_state = "storage"
/area/calliope/exterior_buildings/ghost_town
	name = "废弃小镇"
	icon_state = "cave"
//===============================================STERLING BUNKER EXT
/area/calliope/bunker_exterior_buildings/west_checkpoint
	name = "南向检查站"
	icon_state = "red"
/area/calliope/bunker_exterior_buildings/east_checkpoint
	name = "北向检查站"
	icon_state = "red"
/area/calliope/bunker_exterior_buildings/complex
	name = "综合设施"
	icon_state = "red"
//================================================STERLING BUNKER PROPER
/area/calliope/bunker/fuel_depot
	name = "燃料库"
	icon_state = "blue-red"
/area/calliope/bunker/entry_checkpoint
	name = "斯特林入口检查站"
	icon_state = "red"
/area/calliope/bunker/sterlingtransfer
	name = "斯特林转运区"
	icon_state = "away1"
/area/calliope/bunker/pillbox
	name = "碉堡"
	icon_state = "away2"
/area/calliope/bunker/cargo_area
	name = "货运区"
	icon_state = "away3"
/area/calliope/bunker/closet
	name = "补给储物间"
	icon_state = "storage"
/area/calliope/bunker/hospital
	name = "医院"
	icon_state = "medbay"
/area/calliope/bunker/abandoned_section
	name = "研究实验室"
	icon_state = "research"
/area/calliope/bunker/armory
	name = "军械库"
	icon_state = "red"
/area/calliope/bunker/hallway
	name = "斯特林主大厅"
	icon_state = "central"
/area/calliope/bunker/cafeteria
	name = "斯特林咖啡馆"
	icon_state = "cafeteria"
/area/calliope/bunker/barracks
	name = "营房"
	icon_state = "green"
/area/calliope/bunker/command
	name = "作战中心"
	icon_state = "bluenew"
/area/calliope/bunker/engineering
	name = "工程区"
	icon_state = "engine_smes"
/area/calliope/bunker/holding
	name = "拘留室"
	icon_state = "security"
//================================================================================OOB
/area/calliope/oob/mountain
	name = "oob"
	icon_state = "cave2"
/area/calliope/oob/gate
	name = "公路入口"
	icon_state = "bluered"
/area/calliope/oob_o/playground
	name = "Out of Bounds Fun"
	icon_state = "yellow"
//=================================================================================UNDERGROUND BUNKERS
/area/calliope/bunker/engineering_under
	name = "发电站"
	icon_state = "engineering"
/area/calliope/bunker/north_section
	name = "维护走廊"
	icon_state = "lower hull"
/area/calliope/bunker/cargo_under
	name = "斯特林货物仓库"
	icon_state = "storage"
/area/calliope/bunker/south_section
	name = "维护走廊"
	icon_state = "lower hull"
/area/calliope/bunker/escape
	name = "紧急逃生舱口"
	icon_state = "evac"
