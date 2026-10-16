/turf/closed/wall/r_wall
	name = "加固墙"
	desc = "用于分隔房间的厚重加固金属墙体。"
	icon_state = "r_wall_mapicon"
	opacity = TRUE
	density = TRUE

	damage_cap = HEALTH_WALL_REINFORCED

	walltype = WALL_REINFORCED

	claws_minimum = CLAW_TYPE_VERY_SHARP

/turf/closed/wall/r_wall/attackby(obj/item/W, mob/user)
	if(isxeno(user) && istype(W, /obj/item/grab))
		var/obj/item/grab/attacker_grab = W
		var/mob/living/carbon/xenomorph/user_as_xenomorph = user
		user_as_xenomorph.do_nesting_host(attacker_grab.grabbed_thing, src)

	if(hull)
		return

	//get the user's location
	if( !istype(user.loc, /turf) ) return //can't do this stuff whilst inside objects and such

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting walls and the relevant effects
	if(thermite)
		if(W.heat_source >= 1000)
			if(hull)
				to_chat(user, SPAN_WARNING("[src]太坚固了，你无法用[W]对它做什么。"))
			else
				if(iswelder(W))
					var/obj/item/tool/weldingtool/WT = W
					WT.remove_fuel(0,user)
				thermitemelt(user)
			return

	if(try_weldingtool_usage(W, user) || try_nailgun_usage(W, user))
		return

	if(istype(W, /obj/item/weapon/twohanded/breacher))
		var/obj/item/weapon/twohanded/breacher/current_hammer = W
		if(user.action_busy)
			return
		if(!(HAS_TRAIT(user, TRAIT_SUPER_STRONG) || !current_hammer.really_heavy))
			to_chat(user, SPAN_WARNING("你无法正确使用[current_hammer]！"))
			return

		to_chat(user, SPAN_NOTICE("你开始拆除[src]。"))
		if(!do_after(user, 10 SECONDS, INTERRUPT_ALL_OUT_OF_RANGE, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE("你停止拆除[src]。"))
			return
		to_chat(user, SPAN_NOTICE("你拆除了[src]。"))

		playsound(src, 'sound/effects/meteorimpact.ogg', 40, 1)
		playsound(src, 'sound/effects/ceramic_shatter.ogg', 40, 1)

		take_damage(damage_cap)
		return

	//DECONSTRUCTION
	switch(d_state)
		if(WALL_STATE_WELD)
			if(iswelder(W))
				if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("你需要更强力的焊炬！"))
					return
				var/obj/item/tool/weldingtool/WT = W
				try_weldingtool_deconstruction(WT, user)

		if(WALL_STATE_SCREW)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
				user.visible_message(SPAN_NOTICE("[user]开始拆除支撑线路。"),
				SPAN_NOTICE("你开始拆除支撑线路。"))
				playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WIRECUTTER
				user.visible_message(SPAN_NOTICE("[user]拆除了支撑线路。"), SPAN_NOTICE("你拆除了支撑线路。"))
				return

		if(WALL_STATE_WIRECUTTER)
			if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
				user.visible_message(SPAN_NOTICE("[user]开始松开液压管线的压接处。"),
				SPAN_NOTICE("你开始松开液压管线的压接处。"))
				playsound(src, 'sound/items/Wirecutter.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_WRENCH
				user.visible_message(SPAN_NOTICE("[user]完成了液压管线压接处的拆解。"), SPAN_NOTICE("你完成了液压管线压接处的拆解。"))
				return

		if(WALL_STATE_WRENCH)
			if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
				user.visible_message(SPAN_NOTICE("[user]开始松开固定支撑杆的锚固螺栓。"),
				SPAN_NOTICE("你开始松开固定支撑杆的锚固螺栓。"))
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				d_state = WALL_STATE_CROWBAR
				user.visible_message(SPAN_NOTICE("[user]拆除了固定支撑杆的螺栓。"), SPAN_NOTICE("你拆除了固定支撑杆的螺栓。"))
				return

		if(WALL_STATE_CROWBAR)
			if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
				user.visible_message(SPAN_NOTICE("[user]费力地撬动连接杆。"),
				SPAN_NOTICE("你费力地撬动连接杆。"))
				playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
				if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				user.visible_message(SPAN_NOTICE("[user]撬开了连接杆。"), SPAN_NOTICE("你撬开了连接杆。"))
				new /obj/item/stack/rods(src)
				dismantle_wall()
				return

//vv OK, we weren't performing a valid deconstruction step or igniting thermite,let's check the other possibilities vv

	//DRILLING
	if (istype(W, /obj/item/tool/pickaxe/diamonddrill))

		to_chat(user, SPAN_NOTICE("你开始钻穿墙壁。"))

		if(do_after(user, 200 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!istype(src, /turf/closed/wall/r_wall))
				return
			to_chat(user, SPAN_NOTICE("你的钻头钻穿了最后一层加固板。"))
			dismantle_wall()

	//REPAIRING
	else if(damage && istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/MS = W
		user.visible_message(SPAN_NOTICE("[user]开始修复[src]上的损伤。"),
		SPAN_NOTICE("你开始修复[src]上的损伤。"))
		playsound(src, 'sound/items/Welder.ogg', 25, 1)
		if(do_after(user, max(5, floor(damage / 5) * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION)), INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && istype(src, /turf/closed/wall/r_wall))
			user.visible_message(SPAN_NOTICE("[user]完成了[src]的损伤修复。"),
			SPAN_NOTICE("你完成了[src]的损伤修复。"))
			take_damage(-damage)
			MS.use(1)

		return



	//APC
	else if( istype(W,/obj/item/frame/apc) )
		var/obj/item/frame/apc/AH = W
		AH.try_build(src)

	else if( istype(W,/obj/item/frame/air_alarm) )
		var/obj/item/frame/air_alarm/AH = W
		AH.try_build(src)

	else if(istype(W,/obj/item/frame/fire_alarm))
		var/obj/item/frame/fire_alarm/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/frame/light_fixture))
		var/obj/item/frame/light_fixture/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/frame/light_fixture/small))
		var/obj/item/frame/light_fixture/small/AH = W
		AH.try_build(src)
		return

	//Poster stuff
	else if(istype(W,/obj/item/poster))
		place_poster(W,user)
		return

	return



/turf/closed/wall/r_wall/can_be_dissolved()
	if(hull)
		return 0
	else
		return 2


//Just different looking wall
/turf/closed/wall/r_wall/research
	icon_state = "research"
	walltype = WALL_REINFORCED_RESEARCH

/turf/closed/wall/r_wall/dense
	icon_state = "iron0"
	walltype = WALL_REINFORCED_IRON
	hull = 1

/turf/closed/wall/r_wall/unmeltable
	name = "重型加固墙"
	desc = "用于分隔房间的超厚加固金属墙体。看起来几乎坚不可摧。"
	icon_state = "heavy_r_wall_mapicon"
	walltype = WALL_REINFORCED
	hull = 1

//Chigusa

/turf/closed/wall/r_wall/chigusa
	name = "设施墙壁"
	icon = 'icons/turf/walls/chigusa.dmi'
	icon_state = "chigusa"
	walltype = WALL_REINFORCED_CHIGUSA

/turf/closed/wall/r_wall/chigusa/update_icon()
	..()
	if(special_icon)
		return
	if(neighbors_list in list(EAST|WEST))
		var/r1 = rand(0,10) //Make a random chance for this to happen
		var/r2 = rand(0,3) // Which wall if we do choose it
		if(r1 >= 9)
			overlays += image(icon, icon_state = "deco_wall[r2]")

//Bunker Walls

/turf/closed/wall/r_wall/bunker
	name = "地堡墙壁"
	icon = 'icons/turf/walls/bunker.dmi'
	icon_state = "bunker"
	walltype = WALL_REINFORCED_BUNKER

//Prison

/turf/closed/wall/r_wall/prison
	name = "加固金属墙"
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "rwall"
	walltype = WALL_REINFORCED

/turf/closed/wall/r_wall/prison_unmeltable
	name = "重型加固墙"
	desc = "用于分隔房间的超厚加固金属墙体。看起来几乎坚不可摧。"
	icon = 'icons/turf/walls/prison.dmi'
	icon_state = "hwall"
	walltype = WALL_REINFORCED
	hull = 1

//Biodome

/turf/closed/wall/r_wall/biodome
	name = "加固金属墙"
	icon = 'icons/turf/walls/corsat.dmi'
	icon_state = "r_dome"
	walltype = WALL_DOMER

/turf/closed/wall/r_wall/biodome/biodome_unmeltable
	name = "重型加固墙"
	desc = "用于分隔房间的超厚加固金属墙体。看起来几乎坚不可摧。"
	icon_state = "h_dome"
	hull = TRUE

/// Destructible elevator walls, for when you want the elevator to act as a prop rather than an actual elevator
/turf/closed/wall/r_wall/elevator
	icon = 'icons/turf/elevator.dmi'
	icon_state = "wall"
	special_icon = TRUE

// Wall with gears that animate when elevator is moving
/turf/closed/wall/r_wall/elevator/gears
	icon_state = "wall_gear"

// Special wall icons
/turf/closed/wall/r_wall/elevator/research
	icon_state = "wall_research"

/turf/closed/wall/r_wall/elevator/dorm
	icon_state = "wall_dorm"

/turf/closed/wall/r_wall/elevator/freight
	icon_state = "wall_freight"

/turf/closed/wall/r_wall/elevator/arrivals
	icon_state = "wall_arrivals"

// Elevator Buttons
/turf/closed/wall/r_wall/elevator/button
	name = "电梯按钮"

/turf/closed/wall/r_wall/elevator/button/research
	icon_state = "wall_button_research"

/turf/closed/wall/r_wall/elevator/button/dorm
	icon_state = "wall_button_dorm"

/turf/closed/wall/r_wall/elevator/button/freight
	icon_state = "wall_button_freight"

/turf/closed/wall/r_wall/elevator/button/arrivals
	icon_state = "wall_button_arrivals"

