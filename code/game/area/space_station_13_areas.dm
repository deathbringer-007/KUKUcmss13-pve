/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME (you can make as many subdivisions as you want)
	name = "NICE NAME" (not required but makes things really nice)
	icon = "ICON FILENAME" (defaults to areas.dmi)
	icon_state = "NAME OF ICON" (defaults to "unknown" (blank))
	requires_power = 0 (defaults to 1)
	music = "music/music.ogg" (defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/

/*-----------------------------------------------------------------------------*/
/area/space
	name = "\improper 太空"
	requires_power = 1
	always_unpowered = 1
	base_lighting_alpha = 255
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	temperature = TCMB
	pressure = 0
	flags_area = AREA_NOTUNNEL
	weather_enabled = FALSE

	//fix for issue https://github.com/cmss13-devs/cmss13/issues/2191
	base_muffle = AREA_MUTED

/area/engine
	//ambience = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg','sound/ambience/ambisin4.ogg')

/area/admin
	name = "\improper Admin room"
	icon_state = "start"
	ceiling = CEILING_METAL

/area/admin/droppod
	base_lighting_alpha = 255

/area/admin/droppod/holding
	name = "\improper Admin Supply Drops Droppod"

/area/admin/droppod/loading
	name = "\improper Admin Supply Drops Loading"

//Defined for fulton recovery storage
/area/space/highalt
	name = "高空"
	icon_state = "blue"

/area/start // will be unused once kurper gets his login interface patch done
	name = "起始区域"
	icon_state = "start"
	ceiling = CEILING_MAX
	requires_power = FALSE
	static_lighting = FALSE
	base_lighting_alpha = 255

// === end remove

// CENTCOM

/area/centcom
	name = "\improper 废弃中央指挥部"
	icon_state = "centcom"
	requires_power = 0
	statistic_exempt = TRUE
	ceiling = CEILING_METAL

	base_lighting_alpha = 255

/area/centcom/control
	name = "\improper 废弃中央指挥部控制室"

/area/centcom/living
	name = "\improper 废弃中央指挥部生活区"

/area/tdome
	name = "\improper 废弃雷霆竞技场"
	icon_state = "thunder"
	requires_power = 0
	flags_area = AREA_NOTUNNEL
	statistic_exempt = TRUE
	ceiling = CEILING_METAL

	base_lighting_alpha = 255

/area/tdome/tdome1
	name = "\improper 废弃雷霆竞技场（一队）"
	icon_state = "green"

/area/tdome/tdome2
	name = "\improper 废弃雷霆竞技场（二队）"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "\improper abandoned  Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "\improper 废弃雷霆竞技场（观察者）"
	icon_state = "purple"
