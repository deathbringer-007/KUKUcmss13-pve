//TAIPEI STATION AREAS//


/area/taipei
	ceiling = CEILING_DEEP_UNDERGROUND_METAL
	ceiling_muffle = FALSE
	powernet_name = "ground"
	can_build_special = TRUE
	icon_state = "lv-626"
	ambience_exterior = AMBIENCE_SHIP
	soundscape_interval = 0
	//ambience = list('sound/ambience/shipambience.ogg)

/area/taipei/underground
	always_unpowered = 1
	name = "\improper 小行星"
	icon_state = "caves"

/area/taipei/club
	name = "\improper 天鹅绒流苏"
	icon_state = "blue"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/taipei/maints
	name = "维护隧道"
	sound_environment = SOUND_ENVIRONMENT_HALLWAY
	soundscape_interval = 0

/area/taipei/maints/south
	name = "\improper 南侧维护隧道"
	icon_state = "south"

/area/taipei/maints/north
	name = "\improper 北侧维护隧道"
	icon_state = "north"

/area/taipei/atrium
	name = "\improper 主中庭"
	sound_environment = SOUND_ENVIRONMENT_PARKING_LOT
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120
	icon_state = "green"

/area/taipei/atrium/medbay
	name = "\improper 诊所"
	icon_state = "medbay"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/taipei/cmb
	name = "\improper 殖民地执法局"
	icon_state = "security"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/taipei/cargo
	name = "\improper 货运通道"
	icon_state = "primarystorage"
	sound_environment = SOUND_ENVIRONMENT_HANGAR

/area/taipei/hangar
	name = "\improper 出入机库"
	icon_state = "yellow"
	sound_environment = SOUND_ENVIRONMENT_HANGAR
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 30

/area/taipei/hangar/landingzone
	name = "\improper 一号降落区"
	is_landing_zone = TRUE
	icon_state = "lv-626"

/area/taipei/telecomms
	name = "\improper 通讯区"
	icon_state = "purple"
	soundscape_playlist = SCAPE_PL_AICORE
	soundscape_interval = 5
	sound_environment = SOUND_ENVIRONMENT_GENERIC

/area/taipei/atrium/laundry
	name = "\improper 自助洗衣店"
	icon_state = "gruntrnr"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/taipei/atrium/store
	name = "\improper 便利店"
	icon_state = "req"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/taipei/theatre
	name = "\improper 电影之星"
	icon_state = "almayer"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM

/area/taipei/atrium/offices
	name = "\improper 管理办公室"
	icon_state = "livingspace"
	sound_environment = SOUND_ENVIRONMENT_LIVINGROOM

/area/taipei/reactor
	name = "\improper 反应堆控制室"
	icon_state = "upperengineering"
	sound_environment = SOUND_ENVIRONMENT_GENERIC
	soundscape_playlist = SCAPE_PL_ENG
	soundscape_interval = 15

/area/taipei/reactor/chamber
	name = "\improper 反应堆室"
	icon_state = "green"
	sound_environment = SOUND_ENVIRONMENT_MOUNTAINS

/area/taipei/atrium/restaurant
	name = "\improper 萨尔面馆"
	icon_state = "pink"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/taipei/atrium/bookstore
	name = "\improper 满屋书书店"
	icon_state = "yellow"
	sound_environment = SOUND_ENVIRONMENT_LIVINGROOM

/area/taipei/hangar/cargoshuttle
	name = "\improper 货运驳船"
	icon_state = "green"
	sound_environment = SOUND_ENVIRONMENT_HALLWAY

/area/taipei/elevator
	name = "电梯"
	icon_state = "yellow"

/area/taipei/elevator/arrivals
	name = "\improper 入站电梯"

/area/taipei/elevator/departures
	name = "\improper 离站电梯"

/area/taipei/atrium/hotel
	name = "\improper 短期食宿区"
	icon_state = "green"
	sound_environment = SOUND_ENVIRONMENT_CARPETED_HALLWAY
