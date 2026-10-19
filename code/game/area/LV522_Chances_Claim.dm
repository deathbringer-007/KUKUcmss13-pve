//lv522 AREAS--------------------------------------//

/area/lv522
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

//parent types

/area/lv522/indoors
	name = "机遇矿区户外"
	icon_state = "cliff_blocked" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV522_INDOORS


/area/lv522/outdoors
	name = "机遇矿区户外"
	icon_state = "cliff_blocked" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

/area/lv522/oob
	name = "LV522 - Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

/area/lv522/oob/w_y_vault
	name = "LV522维兰德安全金库"
	icon_state = "blue"

//Landing Zone 1

/area/lv522/landing_zone_1
	name = "机遇矿区1号着陆区"
	icon_state = "explored"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/lv522/landing_zone_1/ceiling
	ceiling = CEILING_METAL

/area/lv522/landing_zone_1/tunnel
	name = "机遇矿区1号着陆区隧道"
	ceiling = CEILING_METAL

/area/lv522/landing_zone_1/tunnel/far
	name = "机遇矿区1号着陆区隧道"
	ceiling = CEILING_METAL
	is_landing_zone = FALSE

/area/shuttle/drop1/lv522
	name = "机遇矿区阿拉莫号运输艇着陆区"
	icon_state = "shuttle"
	icon = 'icons/turf/area_shiva.dmi'

/area/lv522/landing_zone_1/lz1_console
	name = "机遇矿区阿拉莫号运输艇控制台"
	icon_state = "tcomsatcham"
	requires_power = FALSE

//Landing Zone 2

/area/lv522/landing_zone_2
	name = "机遇矿区2号着陆区"
	icon_state = "explored"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/lv522/landing_zone_2/ceiling
	ceiling = CEILING_METAL

/area/shuttle/drop2/lv522
	name = "机遇矿区诺曼底号运输艇着陆区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_shiva.dmi'

/area/lv522/landing_zone_2/lz2_console
	name = "机遇矿区诺曼底号运输艇控制台"
	icon_state = "tcomsatcham"
	requires_power = FALSE

//Landing Zone 3 & 4

/area/lv522/landing_zone_forecon
	name = "机遇矿区武装侦察部队穿梭机"
	icon_state = "shuttle"
	ceiling =  CEILING_METAL
	requires_power = FALSE

/area/lv522/landing_zone_forecon/landing_zone_3
	name = "机遇矿区3号着陆区"
	icon_state = "blue"
	ceiling = CEILING_NONE

/area/lv522/landing_zone_forecon/landing_zone_4
	name = "机遇矿区4号着陆区"
	icon_state = "blue"
	ceiling = CEILING_NONE

/area/lv522/landing_zone_forecon/UD6_Typhoon
	name = "机遇矿区UD6台风号"

/area/lv522/landing_zone_forecon/UD6_Tornado
	name = "机遇矿区UD6龙卷风号"

//Outdoors areas
/area/lv522/outdoors/colony_streets //WHY IS THIS A SUBTYPE OF BUILDINGS AAAARGGHGHHHH YOU DIDN'T EVEN USE OBJECT INHERITANCE FOR THE CIELINGS I HATE YOU BOBBY
	name = "殖民地街道"
	icon_state = "green"
	ceiling = CEILING_NONE

/area/lv522/outdoors/colony_streets/windbreaker
	name = "殖民地防风屏障"
	icon_state = "tcomsatcham"
	requires_power = FALSE
	ceiling = CEILING_NONE

/area/lv522/outdoors/colony_streets/windbreaker/observation
	name = "殖民地防风屏障观察区"
	icon_state = "purple"
	requires_power = FALSE
	ceiling = CEILING_GLASS
	soundscape_playlist = SCAPE_PL_LV522_INDOORS

/area/lv522/outdoors/colony_streets/central_streets
	name = "中央街道西段"
	icon_state = "west"

/area/lv522/outdoors/colony_streets/east_central_street
	name = "中央街道东段"
	icon_state = "east"

/area/lv522/outdoors/colony_streets/south_street
	name = "殖民地南部街道"
	icon_state = "south"

/area/lv522/outdoors/colony_streets/south_east_street
	name = "殖民地东南街道"
	icon_state = "southeast"

/area/lv522/outdoors/colony_streets/south_west_street
	name = "殖民地西南街道"
	icon_state = "southwest"

/area/lv522/outdoors/colony_streets/north_west_street
	name = "殖民地西北街道"
	icon_state = "northwest"

/area/lv522/outdoors/colony_streets/north_east_street
	name = "殖民地东北街道"
	icon_state = "northeast"

/area/lv522/outdoors/colony_streets/north_street
	name = "殖民地北部街道"
	icon_state = "north"

/area/lv522/outdoors/colony_streets/winde
	name = "殖民地西北街道"
	icon_state = "northwest"

//misc indoors areas

/area/lv522/indoors/lone_buildings
	name = "LV522独立建筑区"
	icon_state = "green"

/area/lv522/indoors/toilet
	name = "LV522户外卫生间"
	icon_state = "green"

/area/lv522/indoors/lone_buildings/engineering
	name = "应急工程区"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv522/indoors/lone_buildings/spaceport
	name = "1号着陆区北部太空港"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/lv522/indoors/lone_buildings/outdoor_bot
	name = "1号着陆区东部户外电信站"
	icon_state = "yellow"
	ceiling = CEILING_GLASS

/area/lv522/indoors/lone_buildings/storage_blocks
	name = "户外储藏区"
	icon_state = "blue"

/area/lv522/indoors/lone_buildings/chunk
	name = "大块快餐店"
	icon_state = "blue"

//A Block
/area/lv522/indoors/a_block
	name = "A区"
	icon_state = "blue"
	ceiling = CEILING_METAL

/area/lv522/indoors/a_block/admin
	name = "A区殖民地运营中心"
	icon_state = "mechbay"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv522/indoors/a_block/dorms
	name = "A区西部宿舍与办公室"
	icon_state = "fitness"

/area/lv522/indoors/a_block/dorms/glass
	ceiling = CEILING_GLASS

/area/lv522/indoors/a_block/fitness
	name = "A区健身中心"
	icon_state = "fitness"

/area/lv522/indoors/a_block/fitness/glass
	ceiling = CEILING_GLASS

/area/lv522/indoors/a_block/hallway
	name = "A区运营中心南走廊"
	icon_state = "green"

/area/lv522/indoors/a_block/hallway/damage
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

/area/lv522/indoors/a_block/medical
	name = "A区医疗部"
	icon_state = "medbay"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/lv522/indoors/a_block/medical/glass
	ceiling = CEILING_GLASS

/area/lv522/indoors/a_block/security
	name = "A区安保部"
	icon_state = "head_quarters"
	minimap_color = MINIMAP_AREA_SEC

/area/lv522/indoors/a_block/security/glass
	ceiling = CEILING_GLASS

/area/lv522/indoors/a_block/kitchen
	name = "A区厨房与餐厅"
	icon_state = "kitchen"

/area/lv522/indoors/a_block/kitchen/glass
	ceiling = CEILING_GLASS

/area/lv522/indoors/a_block/kitchen/damage
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

/area/lv522/indoors/a_block/executive
	name = "A区高管套间"
	icon_state = "captain"

/area/lv522/indoors/a_block/executive/glass
	ceiling = CEILING_GLASS

/area/lv522/indoors/a_block/dorm_north
	name = "A区北部合住宿舍"
	icon_state = "fitness"

/area/lv522/indoors/a_block/bridges
	name = "A区西部宿舍至安保部连桥"
	icon_state = "hallC1"
	ceiling = CEILING_GLASS

/area/lv522/indoors/a_block/bridges/dorms_fitness
	name = "A区公司办公室至健身中心连桥"
	icon_state = "hallC1"
	ceiling = CEILING_GLASS

/area/lv522/indoors/a_block/bridges/corpo_fitness
	name = "A区西部宿舍至健身中心通道"
	icon_state = "hallC1"
	ceiling = CEILING_GLASS


/area/lv522/indoors/a_block/bridges/corpo
	name = "A区安保部至公司办公室连桥"
	icon_state = "hallC1"

/area/lv522/indoors/a_block/bridges/op_centre
	name = "A区安保部至运营中心连桥"
	icon_state = "hallC1"

/area/lv522/indoors/a_block/bridges/garden_bridge
	name = "A区花园连桥"
	icon_state = "hallC2"
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC

/area/lv522/indoors/a_block/corpo
	name = "A区公司办公室"
	icon_state = "toxlab"

/area/lv522/indoors/a_block/corpo/glass
	ceiling =  CEILING_GLASS

/area/lv522/indoors/a_block/garden
	name = "A区运营中心西部花园"
	icon_state = "green"
	ceiling = CEILING_GLASS
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC

//B Block

/area/lv522/indoors/b_block
	name = "B区"
	icon_state = "red"
	ceiling =  CEILING_METAL

/area/lv522/indoors/b_block/hydro
	name = "B区水培区"
	icon_state = "hydro"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/lv522/indoors/b_block/hydro/glass
	ceiling = CEILING_GLASS

/area/lv522/indoors/b_block/bar
	name = "B区酒吧"
	icon_state = "cafeteria"

/area/lv522/indoors/b_block/bridge
	name = "B区水培区连桥网络"
	icon_state = "hallC1"
	ceiling = CEILING_GLASS

//C Block

/area/lv522/indoors/c_block
	name = "C区"
	icon_state = "green"

/area/lv522/indoors/c_block/cargo
	name = "C区货运部"
	icon_state = "primarystorage"

/area/lv522/indoors/c_block/mining
	name = "C区采矿区"
	icon_state = "yellow"

/area/lv522/indoors/c_block/garage
	name = "C区车库"
	icon_state = "storage"

/area/lv522/indoors/c_block/casino
	name = "C区赌场"
	icon_state = "purple"

/area/lv522/indoors/c_block/bridge
	name = "C区货运部至车库连桥"
	icon_state = "hallC1"
	ceiling = CEILING_GLASS

/area/lv522/indoors/c_block/t_comm
	name = "C区车库西部电信站"
	icon_state = "hallC1"

//Rockies

/area/lv522/outdoors/n_rockies
	name = "殖民地北部岩石区"
	icon_state = "away"

/area/lv522/outdoors/nw_rockies
	name = "殖民地西北岩石区"
	icon_state = "away1"

/area/lv522/outdoors/w_rockies
	name = "殖民地西部岩石区"
	icon_state = "away2"

/area/lv522/outdoors/p_n_rockies
	name = "处理站北部岩石区"
	icon_state = "away"

/area/lv522/outdoors/p_nw_rockies
	name = "处理站西北岩石区"
	icon_state = "away1"

/area/lv522/outdoors/p_w_rockies
	name = "处理站西部岩石区"
	icon_state = "away2"

/area/lv522/outdoors/p_e_rockies
	name = "处理站东部岩石区"
	icon_state = "away3"

//ATMOS
/area/lv522/atmos
	name = "大气处理站"
	icon_state = "engineering"
	ceiling = CEILING_REINFORCED_METAL
	ambience_exterior = AMBIENCE_SHIP
	minimap_color = MINIMAP_AREA_ENGI

/area/lv522/atmos/outdoor
	name = "大气处理站户外"
	icon_state = "quart"
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

/area/lv522/atmos/east_reactor
	name = "大气处理站东反应堆"
	icon_state = "blue"

/area/lv522/atmos/east_reactor/north
	name = "大气处理站东反应堆外围北部"
	icon_state = "yellow"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/east_reactor/south
	name = "大气处理站东反应堆外围南部"
	icon_state = "red"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/east_reactor/south/cas
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/east_reactor/east
	name = "大气处理站东反应堆外围东部"
	icon_state = "green"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/east_reactor/west
	name = "大气处理站东反应堆外围西部"
	icon_state = "purple"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/west_reactor
	name = "大气处理站西反应堆"
	icon_state = "blue"

/area/lv522/atmos/cargo_intake
	name = "大气处理站货运接收区"
	icon_state = "yellow"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/command_centre
	name = "大气处理站中央指挥区"
	icon_state = "red"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/north_command_centre
	name = "大气处理站北部指挥中心检查站"
	icon_state = "green"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/filt
	name = "大气处理站过滤系统"
	icon_state = "mechbay"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/way_in_command_centre
	name = "大气处理站北部公司反应堆入口"
	icon_state = "blue"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/sewer
	name = "大气处理站下水道"
	icon_state = "red"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/lv522/atmos/reactor_garage
	name = "大气处理站车库"
	icon_state = "green"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
