//==================================================================KLESCHERS RESEARCH SITE
//BASE
/area/kleschers
	name = "克莱舍科研区"
	icon_state = "lv626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
//============================================================PARENTS
/area/kleschers/outside
	name = "克莱舍室外区"
	ceiling = CEILING_NONE
/area/kleschers/int_glass
	name = "克莱舍玻璃顶区域"
	ceiling = CEILING_GLASS
/area/kleschers/int_reg
	name = "克莱舍金属顶区域"
	ceiling = CEILING_METAL
/area/kleschers/int_heavy
	name = "克莱舍加固顶区域"
	ceiling = CEILING_REINFORCED_METAL
/area/kleschers/caves
	name = "克莱舍洞穴"
	ceiling = CEILING_DEEP_UNDERGROUND
//============================================================SHUTTLES
/area/kleschers/shuttles/drop1
	name = "克莱舍 - 太空港"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/kleschers/shuttles/drop2
	name = "克莱舍 - 货运区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
//============================================================Northwest Portion (viro,marshal,clinic)
/area/kleschers/outside/spaceport
	name = "克莱舍太空港"
	icon_state = "away1"
/area/kleschers/int_reg/roofed_spaceport
	name = "克莱舍太空港"
	icon_state = "blueold"
/area/kleschers/int_reg/clinic
	name = "圣米凯尔诊所"
	icon_state = "medbay"
/area/kleschers/int_reg/marshals
	name = "殖民地执法局综合楼"
	icon_state = "security"
/area/kleschers/int_heavy/marshals_armory
	name = "军械库"
	icon_state = "secure_armory"
/area/kleschers/int_reg/virology
	name = "病毒学区"
	icon_state = "virology"
/area/kleschers/outside/northwest
	name = "克莱舍西北区"
	icon_state = "northwest"
/area/kleschers/int_reg/telecomms
	name = "太空港通讯中心"
	icon_state = "yellow"
/area/kleschers/outside/telecomms_yard
	name = "太空港通讯场区"
	icon_state = "blue-red"
/area/kleschers/int_reg/garage
	name = "太空港车库"
	icon_state = "storage"
/area/kleschers/caves/north_river
	name = "北侧洞穴"
	icon_state = "cave"
//============================================================Western Portion (Cargo, Fitness, Engineering)
/area/kleschers/int_glass/fitness
	name = "健身与康复中心"
	icon_state = "fitness"
/area/kleschers/int_reg/cargo
	name = "货舱"
	icon_state = "cargo"
/area/kleschers/int_reg/engineering
	name = "工程综合区"
	icon_state = "SMES"
/area/kleschers/caves/western_cave
	name = "西侧洞穴"
	icon_state = "caves"
/area/kleschers/outside/western
	name = "克莱舍西区"
	icon_state = "west"
//============================================================Central Portion (Admin, Bar, Dorms)
/area/kleschers/int_reg/admin
	name = "克莱舍行政综合区"
	icon_state = "command"
/area/kleschers/int_glass/admin_open
	name = "克莱舍行政综合区"
	icon_state = "command"
/area/kleschers/int_reg/dorms
	name = "宿舍综合区"
	icon_state = "yellow"
/area/kleschers/int_heavy/sec_armory
	name = "安全仓库"
	icon_state = "secure_armory"
/area/kleschers/int_glass/bar
	name = "酒吧综合区"
	icon_state = "away1"
/area/kleschers/outside/central_road
	name = "克莱舍中央区"
	icon_state = "away2"
/area/kleschers/int_reg/connector
	name = "工程区与过滤区连接走廊"
	icon_state = "yellow"
//============================================================Northeastern Portion (Diner, Library, Control, Hydro)
/area/kleschers/int_reg/control_cover
	name = "克莱舍东北区"
	icon_state = "cave"
/area/kleschers/int_reg/diner
	name = "餐馆综合区"
	icon_state = "red"
/area/kleschers/int_glass/library
	name = "图书馆综合区"
	icon_state = "yellow"
/area/kleschers/int_reg/library
	name = "图书馆综合区"
	icon_state = "away1"
/area/kleschers/outside/northeast
	name = "克莱舍东北区"
	icon_state = "northeast"
/area/kleschers/int_reg/control_tower
	name = "控制塔综合区"
	icon_state = "command"
/area/kleschers/int_reg/hydroponics
	name = "水培综合区"
	icon_state = "green"
/area/kleschers/int_glass/hydroponics
	name = "水培综合区"
	icon_state = "green"
//============================================================Eastern Portion (filtration, offices)
/area/kleschers/int_reg/filtration
	name = "过滤综合区"
	icon_state = "robotics"
/area/kleschers/int_reg/offices
	name = "综合办公区"
	icon_state = "hallE1"
/area/kleschers/int_heavy/filtration_locks
	name = "过滤区大门"
	icon_state = "red"
/area/kleschers/outside/east
	name = "克莱舍东区"
	icon_state = "east"
/area/kleschers/outside/construction
	name = "建筑工地"
	icon_state = "yellow"
/area/kleschers/caves/east
	name = "东侧洞穴"
	icon_state = "away3"
//============================================================ETA LABS
/area/kleschers/outside/eta_courtyard
	name = "伊塔庭院"
	icon_state = "south"
/area/kleschers/int_heavy/eta
	name = "伊塔实验室"
	icon_state = "research"
/area/kleschers/caves/southern_caves
	name = "南侧洞穴"
	icon_state = "cave"
/area/kleschers/int_heavy/reactor_excess
	name = "克莱舍反应堆冷却管道"
	icon_state = "engine_smes"
//============================================================LAMBDA LABS
/area/kleschers/int_reg/checkpoint
	name = "兰姆达入口检查站"
	icon_state = "security"
/area/kleschers/outside/lambda_entry
	name = "兰姆达入口区"
	icon_state = "away1"
/area/kleschers/int_heavy/lambda_north_wing
	name = "兰姆达北翼"
	icon_state = "north"
/area/kleschers/int_heavy/lambda_south_wing
	name = "兰姆达南翼"
	icon_state = "south"
/area/kleschers/int_heavy/lambda_virology
	name = "兰姆达病毒学区"
	icon_state = "research"
/area/kleschers/int_heavy/lambda_center
	name = "兰姆达中央区"
	icon_state = "yellow"
/area/kleschers/int_heavy/lambda_saferoom
	name = "应急避难室"
	icon_state = "blue-red2"
/area/kleschers/caves/northeast_caves
	name = "东北洞穴"
	icon_state = "cave"
//============================================================SOUTHWEST PORTION
/area/kleschers/int_reg/shuttle
	name = "轻型货船十字军号"
	icon_state = "shuttle"
/area/kleschers/outside/rebel_landing
	name = "室外降落点"
	icon_state = "away3"
/area/kleschers/caves/southwest_caves
	name = "西南洞穴"
	icon_state = "southwest"
/area/kleschers/int_reg/buildings
	name = "降落点建筑"
	icon_state = "away2"
/area/kleschers/outside/southern_path
	name = "南侧小径"
	icon_state = "away1"
