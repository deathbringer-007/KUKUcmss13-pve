//PARENT AREAS

/area/canyon32B
	icon = 'icons/turf/areas.dmi'
	powernet_name = "ground"
	temperature = ICE_COLONY_TEMPERATURE
	minimap_color = MINIMAP_AREA_COLONY

/area/canyon32B/OOB
	icon = 'icons/turf/area_shiva.dmi'
	name = "32B峡谷 - 冰层下方"
	ceiling = CEILING_MAX

/area/canyon32B/interior
	ceiling = CEILING_METAL
	sound_environment = SOUND_ENVIRONMENT_ROOM
	temperature = T20C

/area/canyon32B/exterior
	soundscape_playlist = SCAPE_PL_WIND
	sound_environment = SOUND_ENVIRONMENT_MOUNTAINS
	ceiling = CEILING_NONE
	icon = 'icons/turf/areas.dmi'

//INTERIOR

/area/canyon32B/interior/bar
	name = "32B峡谷 - 酒吧"
	icon_state = "cafeteria"

/area/canyon32B/interior/gatehouse
	icon = 'icons/turf/area_shiva.dmi'
	icon_state = "hangars0"

/area/canyon32B/interior/gatehouse/northern
	name = "四号检查站 - 北侧岗楼"

/area/canyon32B/interior/gatehouse/southern
	name = "四号检查站 - 南侧岗楼"

/area/canyon32B/interior/gatehouse/pillbox_alpha
	name = "四号检查站 - 阿尔法碉堡"

/area/canyon32B/interior/gatehouse/pillbox_bravo
	name = "四号检查站 - 布拉沃碉堡"

/area/canyon32B/interior/overhang
	name = "四号检查站 - 地堡入口"
	icon_state = "blue"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/canyon32B/interior/bunker
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/canyon32B/interior/bunker/entrance
	name = "四号检查站 - 安保气闸"
	icon = 'icons/turf/area_shiva.dmi'
	icon_state = "caves3"

/area/canyon32B/interior/bunker/hallway
	name = "四号检查站 - 主走廊"
	sound_environment = SOUND_ENVIRONMENT_HALLWAY
	icon_state = "hallC1"

/area/canyon32B/interior/bunker/unloading
	name = "四号检查站 - 卸货区"
	icon_state = "ass_line"

/area/canyon32B/interior/bunker/storage
	name = "四号检查站 - 储物间"
	icon_state = "storage"

/area/canyon32B/interior/bunker/medbay
	name = "四号检查站 - 医务室"
	icon_state = "medbay"

/area/canyon32B/interior/bunker/detainment
	name = "四号检查站 - 拘留室"
	icon_state = "security"

/area/canyon32B/interior/bunker/bathroom
	name = "四号检查站 - 浴室"
	icon_state = "toilet"

/area/canyon32B/interior/bunker/armory
	name = "四号检查站 - 军械库"
	icon_state = "armory"

/area/canyon32B/interior/bunker/bunks
	name = "四号检查站 - 铺位区"
	icon_state = "Sleep"

/area/canyon32B/interior/bunker/mess
	name = "四号检查站 - 食堂"
	icon_state = "kitchen"

/area/canyon32B/interior/bunker/overwatch
	name = "四号检查站 - 战术监控办公室"
	icon_state = "captain"

/area/canyon32B/interior/bunker/engineering
	name = "四号检查站 - 维护区"
	icon_state = "engine_smes"

/area/canyon32B/interior/bunker/engineering/power
	name = "四号检查站 - 发电机区"
//EXTERIOR

/area/canyon32B/exterior/checkpoint
	name = "四号检查站 - 地表"
	icon_state = "blue"

/area/canyon32B/exterior/north
	name = "32B峡谷 - 峡谷北段"
	icon_state = "north"

/area/canyon32B/exterior/south
	name = "32B峡谷 - 峡谷南段"
	icon_state = "south"

/area/canyon32B/exterior/south/bar
	name = "32B峡谷 - 酒吧停车场"
