//Chinook area

//Sparse but gets the job done.

/area/adminlevel/chinook
	name = "奇努克91号地球同步轨道站"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "almayer"
	requires_power = TRUE
	statistic_exempt = TRUE
	flags_area = AREA_NOTUNNEL
	sound_environment = SOUND_ENVIRONMENT_ROOM
	unlimited_power = TRUE
	ceiling = CEILING_METAL
	ambience_exterior = AMBIENCE_ALMAYER
	soundscape_interval = 30
	ceiling_muffle = FALSE

/area/adminlevel/chinook/offices
	name = "奇努克91号地球同步轨道站 - 办公区"
	icon_state = "officerstudy"

/area/adminlevel/chinook/event
	name = "奇努克91号地球同步轨道站 - 会议区"
	icon_state = "officerrnr"

/area/adminlevel/chinook/sec
	name = "奇努克91号地球同步轨道站 - 安保区"
	icon_state = "brig"

/area/adminlevel/chinook/engineering
	name = "奇努克91号地球同步轨道站 - 工程区"
	icon_state = "engineering"

/area/adminlevel/chinook/medical
	name = "奇努克91号地球同步轨道站 - 医疗区"
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	icon_state = "medical"
	soundscape_interval = 60

/area/adminlevel/chinook/cryo
	name = "奇努克91号地球同步轨道站 - 冷冻休眠区"
	icon_state = "cryo"

/area/adminlevel/chinook/shuttle
	name = "奇努克91号地球同步轨道站 - 穿梭机库"
	icon_state = "upperhull"

/area/adminlevel/chinook/shuttle/unpowered
	name = "奇努克91号地球同步轨道站 - 穿梭机停机坪"
	icon_state = "lowerhull"
	requires_power = FALSE

/area/adminlevel/chinook/cargo
	name = "奇努克91号地球同步轨道站 - 货舱"
	icon_state = "req"
