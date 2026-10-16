//SULACO AREAS--------------------------------------//
/area/shuttle
	ceiling = CEILING_METAL
	requires_power = 0
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE


//Drop Pods
/area/shuttle/drop1
	//soundscape_playlist = list('sound/soundscape/drum1.ogg')
	soundscape_interval = 30 //seconds
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop1/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop1/sulaco
	name = "\improper 阿拉莫号运输机"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255

/area/shuttle/drop1/LV624
	name = "\improper 阿拉莫号运输机"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle"

/area/shuttle/drop1/prison
	name = "\improper 阿拉莫号运输机"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle"

/area/shuttle/drop1/BigRed
	name = "\improper 阿拉莫号运输机"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle"

/area/shuttle/drop1/ice_colony
	name = "\improper 阿拉莫号运输机"
	icon_state = "shuttle"

/area/shuttle/drop1/DesertDam
	name = "\improper 阿拉莫号运输机"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle"

/area/shuttle/drop1/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper 阿拉莫号运输机航行区"
	icon_state = "shuttle2"

/area/shuttle/drop1/lz1
	name = "\improper 阿拉莫号降落区"
	icon_state = "away1"




/area/shuttle/drop2
	//soundscape_playlist = list('sound/soundscape/drum1.ogg')
	soundscape_interval = 30 //seconds
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop2/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop2/sulaco
	name = "\improper 诺曼底号运输机"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255

/area/shuttle/drop2/LV624
	name = "\improper 诺曼底号运输机"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop2/prison
	name = "\improper 诺曼底号运输机"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop2/BigRed
	name = "\improper 诺曼底号运输机"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop2/ice_colony
	name = "\improper 诺曼底号运输机"
	icon_state = "shuttle2"

/area/shuttle/drop2/DesertDam
	name = "\improper 诺曼底号运输机"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop2/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper 诺曼底号运输机航行区"
	icon_state = "shuttlered"

/area/shuttle/drop2/lz2
	name = "\improper 诺曼底号降落区"
	icon_state = "away2"

/area/shuttle/midway
	name = "\improper 中途岛号运输机"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL

/area/shuttle/midway/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/ds_upp
	name = "科学院号运输机"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL

/area/shuttle/ds_upp/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/cyclone
	name = "旋风号运输机"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL

/area/shuttle/cyclone/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/pmc
	name = "现金流号运输机"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL

/area/shuttle/pmc/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/tornado
	name = "龙卷风号指挥运输机"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL

/area/shuttle/tornado/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/typhoon
	name = "台风号重型运输机"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL

/area/shuttle/typhoon/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/tripoli
	name = "的黎波里号运输机"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL

/area/shuttle/tripoli/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/gibraltar
	name = "\improper 直布罗陀号运输机"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	soundscape_interval = 30
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL

/area/shuttle/gibraltar/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop3
	//soundscape_playlist = list('sound/soundscape/drum1.ogg')
	soundscape_interval = 30 //seconds
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop3/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop3/sulaco
	name = "\improper 塞班号运输机"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255

/area/shuttle/drop3/LV624
	name = "\improper 塞班号运输机"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop3/prison
	name = "\improper 塞班号运输机"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop3/BigRed
	name = "\improper 塞班号运输机"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop3/ice_colony
	name = "\improper 塞班号运输机"
	icon_state = "shuttle2"

/area/shuttle/drop3/DesertDam
	name = "\improper 塞班号运输机"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop3/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper 塞班号运输机航行区"
	icon_state = "shuttlered"

/area/shuttle/drop3/lz3
	name = "\improper 塞班号降落区"
	icon_state = "away2"


//DISTRESS SHUTTLES

/area/shuttle/distress
	base_lighting_alpha = 255
	unique = TRUE

/area/shuttle/distress/start
	name = "\improper 救援穿梭机"
	icon_state = "away1"
	flags_atom = AREA_ALLOW_XENO_JOIN

/area/shuttle/distress/transit
	name = "\improper 救援穿梭机航行区"
	icon_state = "away2"


/area/shuttle/distress/start_pmc
	name = "\improper PMC救援穿梭机"
	icon_state = "away1"

/area/shuttle/distress/transit_pmc
	name = "\improper PMC救援穿梭机航行区"
	icon_state = "away2"


/area/shuttle/distress/start_upp
	name = "\improper UPP救援穿梭机"
	icon_state = "away1"


/area/shuttle/distress/transit_upp
	name = "\improper UPP救援穿梭机航行区"
	icon_state = "away2"


/area/shuttle/distress/start_big
	name = "\improper 大型救援穿梭机"
	icon_state = "away1"


/area/shuttle/distress/transit_big
	name = "\improper 大型救援穿梭机航行区"
	icon_state = "away2"


/area/shuttle/distress/arrive_1
	name = "\improper 救援穿梭机"
	icon_state = "away3"

/area/shuttle/distress/arrive_2
	name = "\improper 救援穿梭机"
	icon_state = "away4"

/area/shuttle/distress/arrive_3
	name = "\improper 救援穿梭机"
	icon_state = "away"


/area/shuttle/distress/arrive_n_hangar
	name = "\improper 救援穿梭机"
	icon_state = "away"

/area/shuttle/distress/arrive_s_hangar
	name = "\improper 救援穿梭机"
	icon_state = "away3"

/area/shuttle/distress/start_small
	name = "\improper 贵宾穿梭机"
	icon_state = "away3"

/area/shuttle/distress/transit_small
	name = "\improper 贵宾穿梭机航行区"
	icon_state = "away2"

/area/shuttle/distress/arrive_n_engi
	name = "\improper 贵宾穿梭机"
	icon_state = "away"

/area/shuttle/distress/arrive_s_engi
	name = "\improper 贵宾穿梭机"
	icon_state = "away2"
