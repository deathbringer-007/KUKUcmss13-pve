//====================================================================================================BMG290 AREAS
//BASE
/area/bmg290
	name = "御伽撤离点"
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
//=============================================================================================PARENT, this is the stuff to define ceilings i bet
/area/bmg290/wilderness
	name = "荒野"
	ceiling = CEILING_NONE
/area/bmg290/wilderness_roof
	name = "遮蔽区"
	ceiling = CEILING_METAL
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
/area/bmg290/caverns
	name = "紫区"
	ceiling = CEILING_DEEP_UNDERGROUND
/area/bmg290/colony
	name = "御伽区"
	ceiling = CEILING_METAL
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
/area/bmg290/keppitz
	name = "凯皮茨区"
	ceiling = CEILING_METAL
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
/area/bmg290/relay
	name = "中继站区"
	ceiling = CEILING_REINFORCED_METAL
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
/area/bmg290/site
	name = "场地区"
	ceiling = CEILING_DEEP_UNDERGROUND
/area/bmg290/oob
	name = "OOB"
	ceiling = CEILING_NO_PROTECTION
//===============================================================================SHUTTLES
/area/bmg290/shuttles/drop1
	name = "御伽 - 殖民地后勤中心"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/bmg290/shuttles/drop2
	name = "御伽 - 郊区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/bmg290/shuttles/drop3
	name = "凯皮茨 - 私人机库"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/bmg290/shuttles/drop4
	name = "场地降落区"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
//===============================================================================OUTSKIRTS
/area/bmg290/wilderness/road
	name = "御伽路边"
	icon_state = "blue-red2"
/area/bmg290/wilderness/outskirts
	name = "御伽郊区"
	icon_state = "hallf"
/area/bmg290/wilderness/beach
	name = "御伽海滩"
	icon_state = "varadero2"
/area/bmg290/wilderness/site
	name = "场地外围"
	icon_state = "varadero2"
/area/bmg290/wilderness/farmland
	name = "农田"
	icon_state = "varadero2"
/area/bmg290/wilderness/archaeology
	name = "考古遗址"
	icon_state = "varadero0"
/area/bmg290/wilderness/colony_exterior
	name = "御伽内区"
	icon_state = "hallf"
/area/bmg290/wilderness/relay_exterior
	name = "中继站内区"
	icon_state = "hallf"
//===============================================OUTSKIRTS roofing
/area/bmg290/wilderness_roof/beach_house
	name = "海滩住宅区"
	icon_state = "varadero0"
/area/bmg290/wilderness_roof/telecomms_station
	name = "中继站变电室"
	icon_state = "varadero0"
/area/bmg290/wilderness_roof/checkpoint
	name = "检查站"
	icon_state = "varadero0"
/area/bmg290/wilderness_roof/farm_house
	name = "农舍"
	icon_state = "red"
/area/bmg290/wilderness_roof/storage_house
	name = "仓房"
	icon_state = "storage"
/area/bmg290/wilderness_roof/archaeology_check
	name = "考古前哨"
	icon_state = "storage"
//===============================================================================COLONY
/area/bmg290/colony/logistics
	name = "御伽后勤服务区"
	icon_state = "storage"
/area/bmg290/colony/logistics_hub
	name = "御伽后勤仓库"
	icon_state = "storage"
/area/bmg290/colony/hospital
	name = "御伽医院"
	icon_state = "medbay"
/area/bmg290/colony/security
	name = "御伽安保区"
	icon_state = "security"
/area/bmg290/colony/diner
	name = "御伽餐馆"
	icon_state = "green"
/area/bmg290/colony/bar
	name = "御伽酒吧"
	icon_state = "red"
/area/bmg290/colony/shed
	name = "御伽棚屋"
	icon_state = "yellow"
/area/bmg290/colony/engineering
	name = "御伽工程区"
	icon_state = "SMES"
/area/bmg290/colony/admin
	name = "御伽运营与公共服务区"
	icon_state = "command"
/area/bmg290/colony/complex
	name = "御伽综合枢纽"
	icon_state = "hallE"
/area/bmg290/colony/flightdeck
	name = "御伽飞行控制区"
	icon_state = "command"
/area/bmg290/colony/motorpool
	name = "御伽车辆停放区"
	icon_state = "engineering"
/area/bmg290/colony/hangar
	name = "御伽后勤机库"
	icon_state = "lz1"
//===============================================================================RELAY
/area/bmg290/relay/cargo
	name = "中继站货运区"
	icon_state = "storage"
/area/bmg290/relay/engineering
	name = "中继站发电机室"
	icon_state = "smes"
/area/bmg290/relay/synthetic
	name = "中继站合成人存放舱"
	icon_state = "robotics"
/area/bmg290/relay/dataserver
	name = "中继站数据室"
/area/bmg290/relay/hallway
	name = "中继站入口区"
	icon_state = "hallE"
/area/bmg290/relay/telecommunication
	name = "中继站通讯中心"
	icon_state = "telecomms"
/area/bmg290/relay/exterior_storage
	name = "中继站货物存放区"
	icon_state = "storage"
/area/bmg290/relay/underground_shelter
	name = "中继站大规模疏散避难所"
	icon_state = "secure armory"
//===============================================================================KEPPITZ
/area/bmg290/keppitz/command
	name = "凯皮茨公共服务中心"
	icon_state = "command"
/area/bmg290/keppitz/archives
	name = "凯皮茨公共档案馆"
	icon_state = "blue-red2"
/area/bmg290/keppitz/research
	name = "凯皮茨私人实验室"
	icon_state = "research"
/area/bmg290/keppitz/acquisitions
	name = "凯皮茨私人采购区"
	icon_state = "mech"
/area/bmg290/keppitz/security
	name = "凯皮茨私人安保区"
	icon_state = "security"
/area/bmg290/keppitz/test
	name = "凯皮茨私人测试室"
	icon_state = "mech"
/area/bmg290/keppitz/entry
	name = "凯皮茨入口区"
	icon_state = "blue-red2"
/area/bmg290/keppitz/entry_pub
	name = "凯皮茨公共入口区"
	icon_state = "blue-red2"
/area/bmg290/keppitz/interlude
	name = "凯皮茨过渡区"
	icon_state = "fitness"
/area/bmg290/keppitz/hangar
	name = "凯皮茨私人机库"
	icon_state = "lz2"
//===============================================================================SITE
/area/bmg290/site/undiscovered
	name = "未知区域"
	icon_state = "hallE"
/area/bmg290/site/discovered
	name = "科研场地"
	icon_state = "research"
//===============================================================================CAVERNS
/area/bmg290/caverns/cave_east
	name = "紫区深处"
	icon_state = "cave"
/area/bmg290/caverns/filtration
	name = "御伽过滤隧道"
	icon_state = "filtration"
/area/bmg290/caverns/site_caves
	name = "场地深处"
	icon_state = "cave2"
/area/bmg290/caverns/cave_west
	name = "紫区深处"
	icon_state = "cave"
/area/bmg290/caverns/terranium
	name = "凯皮茨科研场区"
	icon_state = "yellow"
//===============================================================================OOB
/area/bmg290/oob/button_stuff
	name = "作战区域外"
	icon_state = "mech"
/area/bmg290/oob/plg
	name = "外围封锁大门"
	icon_state = "mech"
