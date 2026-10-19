//LV624 AREAS--------------------------------------//
/area/lv624
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	ambience_exterior = AMBIENCE_JUNGLE
	minimap_color = MINIMAP_AREA_COLONY

/area/lv624/ground
	name = "地表"
	icon_state = "green"
	always_unpowered = 1 //Will this mess things up? God only knows

//Jungle
/area/lv624/ground/jungle
	minimap_color = MINIMAP_AREA_JUNGLE

/area/lv624/ground/jungle/south_east_jungle
	name ="\improper 东南丛林"
	icon_state = "southeast"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/south_central_jungle
	name ="\improper 中南丛林"
	icon_state = "south"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/south_west_jungle
	name ="\improper 西南丛林"
	icon_state = "southwest"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/south_west_jungle/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/jungle/west_jungle
	name ="\improper 西部丛林"
	icon_state = "west"
	//ambience = list('sound/ambience/jungle_amb1.ogg')
	is_resin_allowed = FALSE

/area/lv624/ground/jungle/west_jungle/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/jungle/east_jungle
	name ="\improper 东部丛林"
	icon_state = "east"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/north_west_jungle
	name ="\improper 西北丛林"
	icon_state = "northwest"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/north_jungle
	name ="\improper 北部丛林"
	icon_state = "north"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/north_east_jungle
	name ="\improper 东北丛林"
	icon_state = "northeast"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/central_jungle
	name ="\improper 中央丛林"
	icon_state = "central"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/west_central_jungle
	name ="\improper 中西部丛林"
	icon_state = "west"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/jungle/east_central_jungle
	name ="\improper 中东部丛林"
	icon_state = "east"
	//ambience = list('sound/ambience/jungle_amb1.ogg')


//The Barrens
/area/lv624/ground/barrens
	name = "\improper 荒地"
	icon_state = "yellow"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/west_barrens
	name = "\improper 西部荒地"
	icon_state = "west"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/west_barrens/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/barrens/east_barrens
	name = "\improper 东部荒地"
	icon_state = "east"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/east_barrens/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/barrens/containers
	name = "\improper 集装箱区"
	icon_state = "blue-red"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/north_east_barrens
	name = "\improper 东北荒地"
	icon_state = "northeast"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/north_east_barrens/ceiling
	ceiling = CEILING_GLASS

/area/lv624/ground/barrens/south_west_barrens
	name = "\improper 西南荒地"
	icon_state = "southwest"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/central_barrens
	name = "\improper 中央荒地"
	icon_state = "away1"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/south_eastern_barrens
	name = "\improper 东南荒地"
	icon_state = "southeast"
// ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/barrens/south_eastern_jungle_barrens
	name = "\improper 东南丛林荒地"
	icon_state = "southeast"
// ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambisin4.ogg')

/area/lv624/ground/river
	name = "\improper 河流"
	icon_state = "blueold"
// ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/river/west_river
	name = "\improper 西部河流"
	icon_state = "blueold"
// ambience = list('sound/ambience/jungle_amb1.ogg')
/area/lv624/ground/river/central_river
	name = "\improper 中央河流"
	icon_state = "purple"
// ambience = list('sound/ambience/jungle_amb1.ogg')

/area/lv624/ground/river/east_river
	name = "\improper 东部河流"
	icon_state = "bluenew"
// ambience = list('sound/ambience/jungle_amb1.ogg')


//Colony Areas
/area/lv624/ground/colony
	name = "\improper 维兰德-汤谷园区"
	icon_state = "green"

/area/lv624/ground/colony/north_nexus_road
	name = "\improper 枢纽北路"
	icon_state = "north"

/area/lv624/ground/colony/south_medbay_road
	name = "\improper 医务室南路"
	icon_state = "south"

/area/lv624/ground/colony/south_nexus_road
	name = "\improper 枢纽南路"
	icon_state = "south"

/area/lv624/ground/colony/west_nexus_road
	name = "\improper 枢纽西路"
	icon_state = "west"

/area/lv624/ground/colony/north_tcomms_road
	name = "\improper 电信站北路"
	icon_state = "north"

/area/lv624/ground/colony/west_tcomms_road
	name = "\improper 电信站西路"
	icon_state = "west"

/area/lv624/ground/colony/telecomm
	name = "\improper 1号着陆区通信中继站"
	icon_state = "ass_line"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	is_resin_allowed = FALSE
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_LOW
	always_unpowered = FALSE

/area/lv624/ground/colony/telecomm/cargo
	name = "\improper 最北端储藏穹顶通信中继站"


/area/lv624/ground/colony/telecomm/sw_lz1
	name = "\improper 1号着陆区西南通信中继站"
	ceiling = CEILING_NONE

/area/lv624/ground/colony/telecomm/tcommdome
	name = "\improper 电信穹顶通信中继站"

/area/lv624/ground/colony/telecomm/tcommdome/south
	name = "\improper 电信穹顶南部通信中继站"
	ceiling = CEILING_NONE

/area/lv624/ground/colony/telecomm/sw_lz2
	name = "\improper 2号着陆区西南通信中继站"
	ceiling = CEILING_NONE

// ambience = list('sound/ambience/jungle_amb1.ogg')


//The Caves
/area/lv624/ground/caves //Does not actually exist
	name ="\improper 洞穴"
	icon_state = "cave"
	//ambience = list('sound/ambience/ambimine.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambisin4.ogg')
	ambience_exterior = AMBIENCE_CAVE
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	minimap_color = MINIMAP_AREA_CAVES

/area/lv624/ground/caves/west_caves
	name ="\improper 西部洞穴"
	icon_state = "away1"

/area/lv624/ground/caves/south_west_caves
	name ="\improper 西南洞穴"
	icon_state = "red"

/area/lv624/ground/caves/east_caves
	name ="\improper 东部洞穴"
	icon_state = "away"

/area/lv624/ground/caves/central_caves
	name ="\improper 中央洞穴"
	icon_state = "away4" //meh

/area/lv624/ground/caves/north_west_caves
	name ="\improper 西北洞穴"
	icon_state = "cave"

/area/lv624/ground/caves/north_east_caves
	name ="\improper 东北洞穴"
	icon_state = "cave"

/area/lv624/ground/caves/north_central_caves
	name ="\improper 中北部洞穴"
	icon_state = "away3" //meh

/area/lv624/ground/caves/south_central_caves
	name ="\improper 中南部洞穴"
	icon_state = "away2" //meh

/area/lv624/ground/caves/south_east_caves
	name ="\improper 东南洞穴"
	icon_state = "away2" //meh

/area/lv624/ground/caves/sand_temple
	name = "\improper 沙之神庙"
	icon_state = "bluenew"

/area/lv624/ground/caves/sand_temple/powered
	name = "\improper 沙之神庙供电区"
	icon_state = "green"
	requires_power = FALSE

//Lazarus landing
/area/lv624/lazarus
	name = "\improper 拉撒路"
	icon_state = "green"
	ceiling = CEILING_METAL

/area/lv624/lazarus/landing_zones
	ceiling = CEILING_NONE
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/lv624/lazarus/landing_zones/lz1
	name = "\improper 阿拉莫号着陆区"

/area/lv624/lazarus/landing_zones/lz2
	name = "\improper 诺曼底号着陆区"

/area/lv624/lazarus
	name = "\improper 拉撒路"
	icon_state = "green"
	ceiling = CEILING_METAL

/area/lv624/lazarus/corporate_dome
	name = "\improper 公司穹顶"
	icon_state = "green"

/area/lv624/lazarus/yggdrasil
	name = "\improper 世界树"
	icon_state = "atmos"
	ceiling = CEILING_GLASS

/area/lv624/lazarus/medbay
	name = "\improper 医务室"
	icon_state = "medbay"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/lv624/lazarus/armory
	name = "\improper 军械库"
	icon_state = "armory"
	minimap_color = MINIMAP_AREA_SEC

/area/lv624/lazarus/security
	name = "\improper 安保部"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC

/area/lv624/lazarus/captain
	name = "\improper 司令官宿舍"
	icon_state = "captain"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv624/lazarus/hop
	name = "\improper 人事主管办公室"
	icon_state = "head_quarters"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv624/lazarus/kitchen
	name = "\improper 厨房"
	icon_state = "kitchen"
	is_resin_allowed = FALSE

/area/lv624/lazarus/canteen
	name = "\improper 食堂"
	icon_state = "cafeteria"
	is_resin_allowed = FALSE

/area/lv624/lazarus/main_hall
	name = "\improper 主走廊"
	icon_state = "hallC1"
	is_resin_allowed = FALSE

/area/lv624/lazarus/toilet
	name = "\improper 宿舍卫生间"
	icon_state = "toilet"

/area/lv624/lazarus/chapel
	name = "\improper 礼拜堂"
	icon_state = "chapel"
	//ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg')

/area/lv624/lazarus/toilet
	name = "\improper 宿舍卫生间"
	icon_state = "toilet"

/area/lv624/lazarus/sleep_male
	name = "\improper 男性宿舍"
	icon_state = "Sleep"

/area/lv624/lazarus/sleep_female
	name = "\improper 女性宿舍"
	icon_state = "Sleep"
	is_resin_allowed = FALSE

/area/lv624/lazarus/quart
	name = "\improper 军需官办公室"
	icon_state = "quart"
	is_resin_allowed = FALSE

/area/lv624/lazarus/quartstorage
	name = "\improper 货舱"
	icon_state = "quartstorage"
	is_resin_allowed = FALSE

/area/lv624/lazarus/quartstorage/outdoors
	name = "\improper 货舱区"
	icon_state = "purple"
	ceiling = CEILING_NONE
	is_resin_allowed = FALSE
	always_unpowered = TRUE

/area/lv624/lazarus/engineering
	name = "\improper 工程部"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv624/lazarus/comms
	name = "\improper 通信中继站"
	icon_state = "tcomsatcham"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv624/lazarus/secure_storage
	name = "\improper 安全储藏室"
	icon_state = "storage"
	flags_area = AREA_NOTUNNEL

/area/lv624/lazarus/robotics
	name = "\improper 机器人技术部"
	icon_state = "ass_line"
	is_resin_allowed = FALSE

/area/lv624/lazarus/research
	name = "\improper 研究实验室"
	icon_state = "toxlab"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/lv624/lazarus/fitness
	name = "\improper 健身房"
	icon_state = "fitness"

/area/lv624/lazarus/hydroponics
	name = "\improper 水培区"
	icon_state = "hydro"
	ceiling = CEILING_GLASS

/area/lv624/landing/console
	name = "\improper 1号着陆区“枢纽”"
	icon_state = "tcomsatcham"
	requires_power = FALSE

/area/lv624/landing/console2
	name = "\improper 2号着陆区“机器人技术部”"
	icon_state = "tcomsatcham"
	requires_power = FALSE

/area/lv624/lazarus/crashed_ship
	name = "\improper 坠毁飞船"
	icon_state = "syndie-ship"

/area/lv624/lazarus/crashed_ship_containers
	name = "\improper 坠毁飞船集装箱区"
	icon_state = "syndie-ship"
