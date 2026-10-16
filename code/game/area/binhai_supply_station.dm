//====================================================================================================
//BASE
/area/binhai
	name = "滨海补给站"
	icon_state = "lv-626"
	can_build_special = TRUE
	minimap_color = MINIMAP_AREA_COLONY
	powernet_name = "station"
//======================================================================================PARENT
/area/binhai/basemil
	name = "MSS与UPP基地"
	ceiling = CEILING_REINFORCED_METAL
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	soundscape_playlist = AMBIENCE_SHIP
	powernet_name = "base"
/area/binhai/caves
	name = "滨海洞穴"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	base_muffle = MUFFLE_HIGH
/area/binhai/hab
	name = "滨海居住区"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	soundscape_playlist = AMBIENCE_SHIP
/area/binhai/main
	name = "滨海主区"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	soundscape_playlist = AMBIENCE_SHIP
/area/binhai/oob
	name = "OOB"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	requires_power = FALSE
/area/binhai/other
	name = "滨海其他区域"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
//=============================================================================SHUTTLES
/area/binhai/shuttles/drop1
	name = "机库区 - 补给停机坪"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/binhai/shuttles/drop2
	name = "军事区 - 停机坪"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
	soundscape_playlist = SCAPE_PL_HANGAR
	powernet_name = "base"
//==============================================================================BASEMIL
/area/binhai/basemil/lower
	name = "MSS区 - 作战区"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_SEC_CAVE
/area/binhai/basemil/lowerss
	name = "MSS区 - 变电室"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	soundscape_playlist = SCAPE_PL_ENG
/area/binhai/basemil/office
	name = "MSS区 - 办公室"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_SEC_CAVE
/area/binhai/basemil/lowertoilet
	name = "MSS区 - 卫生间"
	icon_state = "toilet"
/area/binhai/basemil/lowerbunks
	name = "MSS区 - 铺位区"
	icon_state = "red"
/area/binhai/basemil/lowerarmory
	name = "MSS区 - 军械库"
	icon_state = "armory"
	minimap_color = MINIMAP_AREA_SEC
/area/binhai/basemil/command
	name = "军事区 - 指挥室"
	icon_state = "bridge"
	minimap_color = MINIMAP_AREA_COMMAND
	soundscape_playlist = SCAPE_PL_CIC
/area/binhai/basemil/airoom
	name = "军事区 - 人机交互终端"
	icon_state = "blue"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE
	soundscape_playlist = SCAPE_PL_AICORE
/area/binhai/basemil/lobby
	name = "军事区 - 大厅"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_SEC_CAVE
/area/binhai/basemil/hallway
	name = "军事区 - 走廊"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_SEC_CAVE
/area/binhai/basemil/upperss
	name = "军事区 - 变电室"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	soundscape_playlist = SCAPE_PL_ENG
/area/binhai/basemil/maint
	name = "军事区 - 维护区"
	icon_state = "yellow"
/area/binhai/basemil/uppertoilet
	name = "军事区 - 卫生间"
	icon_state = "toilet"
/area/binhai/basemil/upperbunks
	name = "军事区 - 住舱"
	icon_state = "green"
/area/binhai/basemil/upperarmory
	name = "军事区 - 军械库"
	icon_state = "armory"
	minimap_color = MINIMAP_AREA_SEC
//===============================================================================CAVES
/area/binhai/caves/main
	name = "滨海洞穴"
	icon_state = "cave"
	temperature = T0C
/area/binhai/caves/upper
	name = "滨海上层洞穴"
	icon_state = "cave"
	temperature = T0C
	powernet_name = "base"
/area/binhai/caves/depths
	name = "滨海深处"
	icon_state = "cave"
	temperature = ICE_COLONY_TEMPERATURE
//======================================================================MAIN BLOCK & HANGAR
/area/binhai/main/hangar
	name = "机库区 - 入站与储物区"
	icon_state = "away1"
	soundscape_playlist = SCAPE_PL_HANGAR
/area/binhai/main/shed
	name = "滨海 - 储物棚"
	icon_state = "storage"
/area/binhai/main/commissary
	name = "机库区 - 军人商店"
	icon_state = "quart"
/area/binhai/main/lobby
	name = "主区 - 入站大厅"
	icon_state = "blue-red"
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
/area/binhai/main/hallway
	name = "主区 - 走廊"
	icon_state = "blue-red"
/area/binhai/main/pap
	name = "主区 - PAP区"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC_CAVE
/area/binhai/main/paparmory
	name = "主区 - PAP军械库"
	icon_state = "armory"
	minimap_color = MINIMAP_AREA_SEC
/area/binhai/main/operations
	name = "主区 - 殖民地运营区"
	icon_state = "purple"
	minimap_color = MINIMAP_AREA_COMMAND
/area/binhai/main/server
	name = "主区 - 服务器室"
	icon_state = "purple"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE
/area/binhai/main/diner
	name = "主区 - 餐馆"
	icon_state = "cafeteria"
/area/binhai/main/bar
	name = "主区 - 酒吧"
	icon_state = "cafeteria"
/area/binhai/main/kitchen
	name = "主区 - 厨房"
	icon_state = "kitchen"
/area/binhai/main/toilet
	name = "主区 - 卫生间"
	icon_state = "toilet"
/area/binhai/main/hall
	name = "主区 - 集合大厅"
	icon_state = "blue-red2"
/area/binhai/main/janitor
	name = "主区 - 清洁储物间"
	icon_state = "janitor"
/area/binhai/main/supply
	name = "主区 - 补给储物间"
	icon_state = "storage"
/area/binhai/main/synth
	name = "主区 - 合成人存放区"
	icon_state = "yellow"
/area/binhai/main/atmos
	name = "主区 - 大气系统区"
	icon_state = "atmos"
/area/binhai/main/engineering
	name = "主区 - 工程区"
	icon_state = "engine"
	minimap_color = MINIMAP_AREA_ENGI
	soundscape_playlist = SCAPE_PL_ENG
/area/binhai/main/treatment
	name = "主区 - 治疗区"
	icon_state = "medbay"
	minimap_color = MINIMAP_AREA_MEDBAY
//=============================================================================HABITATION
/area/binhai/hab/hallway
	name = "居住区 - 走廊"
	icon_state = "blue"
/area/binhai/hab/north
	name = "居住区 - 北侧公寓"
	icon_state = "blue"
/area/binhai/hab/east
	name = "居住区 - 东侧公寓"
	icon_state = "blue"
/area/binhai/hab/west
	name = "居住区 - 西侧公寓"
	icon_state = "blue"
/area/binhai/hab/south
	name = "居住区 - 南侧公寓"
	icon_state = "blue"
/area/binhai/hab/study
	name = "居住区 - 学习区"
	icon_state = "blue"
/area/binhai/hab/washing
	name = "居住区 - 洗漱区"
	icon_state = "blue"
/area/binhai/hab/canteen
	name = "居住区 - 食堂"
	icon_state = "cafeteria"
/area/binhai/hab/bunks
	name = "居住区 - 铺位区"
	icon_state = "blue"
/area/binhai/hab/toilet
	name = "居住区 - 铺位区卫生间"
	icon_state = "toilet"
/area/binhai/hab/substation
	name = "居住区 - 变电室"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	soundscape_playlist = SCAPE_PL_ENG
//===============================================================================Other
/area/binhai/other/ship1
	name = "货运穿梭机 - 奥伯龙级赫歇尔号"
	icon_state = "blue-red2"
	requires_power = FALSE
/area/binhai/other/checkpoint
	name = "滨海 - 检查站"
	icon_state = "red"
/area/binhai/other/hablower
	name = "居住区 - 下层通道"
	icon_state = "yellow"
/area/binhai/other/mainlower
	name = "主区 - 下层通道"
	icon_state = "yellow"
/area/binhai/other/Engineeringlower
	name = "主区 - 工程区下层通道"
	icon_state = "engine_storage"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
/area/binhai/other/powerstation
	name = "滨海 - 发电站"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI
	soundscape_playlist = SCAPE_PL_ENG
/area/binhai/other/watertreat
	name = "滨海 - 水处理控制室"
	icon_state = "yellow"
/area/binhai/other/research
	name = "滨海 - 科研区"
	icon_state = "research"
	minimap_color = MINIMAP_AREA_RESEARCH
/area/binhai/other/morgue
	name = "滨海 - 停尸间"
	icon_state = "medbay2"
	minimap_color = MINIMAP_AREA_MEDBAY_CAVE
/area/binhai/other/mineprep
	name = "采矿区 - 整备区"
	icon_state = "purple"
/area/binhai/other/mineoffice
	name = "采矿区 - 办公室"
	icon_state = "purple"
/area/binhai/other/minelower
	name = "采矿区 - 下层挖掘区"
	icon_state = "purple"
/area/binhai/other/hyrdo
	name = "滨海 - 水培区"
	icon_state = "hydro"
/area/binhai/other/umbilical
	name = "滨海 - 对接通道入站区"
	icon_state = "yellow"
//===============================================================================OOB
/area/binhai/oob/buttons
	name = "Out of Bounds"
	icon_state = "mech"
	requires_power = FALSE
