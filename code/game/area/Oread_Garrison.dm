/area/Oread_Garrison
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	ambience_exterior = AMBIENCE_JUNGLE
	minimap_color = MINIMAP_AREA_COLONY

/area/Oread_Garrison/outside
	name = "室外"
	icon_state = "green"
	always_unpowered = 1

/area/Oread_Garrison/outside/jungle
	minimap_color = MINIMAP_AREA_JUNGLE
	ceiling = CEILING_NONE
	icon_state = "central"
	//ambience = list('sound/ambience/jungle_amb1.ogg')

/area/Oread_Garrison/outside/jungle/clearing
	ceiling = CEILING_NONE
	icon_state = "south"

/area/Oread_Garrison/outside/jungle/river
	ceiling = CEILING_NONE
	icon_state = "bluenew"

/area/Oread_Garrison/outside/jungle/landing_zone
	ceiling = CEILING_NONE
	is_resin_allowed = FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/Oread_Garrison/inside
	name = "驻军设施内部"
	icon_state = "purple"
	ceiling = CEILING_METAL
	ambience_exterior = AMBIENCE_ALMAYER
	//ambience = list('sound/ambience/shipambience.ogg)

/area/Oread_Garrison/inside/command
	icon_state = "blueold"
	name = "指挥部"
	minimap_color = MINIMAP_AREA_COMMAND

/area/Oread_Garrison/inside/medical
	icon_state = "medbay"
	name = "医务室"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/Oread_Garrison/inside/engineering
	icon_state = "yellow"
	name = "维护室"
	minimap_color = MINIMAP_AREA_ENGI

/area/Oread_Garrison/inside/dorms
	icon_state = "Sleep"
	name = "营房"
	minimap_color = MINIMAP_AREA_SEC

/area/Oread_Garrison/inside/bunker1
	icon_state = "security"
	name = "东侧岗楼"
	minimap_color = MINIMAP_AREA_SEC

/area/Oread_Garrison/inside/bunker2
	icon_state = "security"
	name = "西侧岗楼"
	minimap_color = MINIMAP_AREA_SEC

/area/Oread_Garrison/inside/bunker3
	icon_state = "security"
	name = "南侧岗楼"
	minimap_color = MINIMAP_AREA_SEC

/area/Oread_Garrison/inside/entry
	icon_state = "security"
	name = "主入口"
	minimap_color = MINIMAP_AREA_SEC

/area/Oread_Garrison/inside/messhall
	icon_state = "cafeteria"
	name = "食堂"
	minimap_color = MINIMAP_AREA_COLONY

/area/Oread_Garrison/inside/garage
	icon_state = "yellow"
	name = "车库"
	minimap_color = MINIMAP_AREA_ENGI

/area/Oread_Garrison/inside/flag
	icon_state = "head_quarters"
	name = "旗帜区"
	minimap_color = MINIMAP_AREA_COMMAND

/area/Oread_Garrison/inside/requisitions
	icon_state = "quart"
	name = "军需部"
	minimap_color = MINIMAP_AREA_SEC






