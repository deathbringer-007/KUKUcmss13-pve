/obj/structure/ladder
	name = "梯子"
	desc = "坚固的金属梯。"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "ladder11"
	var/id = null
	var/height = 0 //The 'height' of the ladder. higher numbers are considered physically higher
	var/obj/structure/ladder/down = null //The ladder below this one
	var/obj/structure/ladder/up = null //The ladder above this one
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = LADDER_LAYER
	var/is_watching = 0
	var/obj/structure/machinery/camera/cam
	var/busy = FALSE //Ladders are wonderful creatures, only one person can use it at a time

/obj/structure/ladder/Initialize(mapload, ...)
	. = ..()
	cam = new /obj/structure/machinery/camera(src)
	cam.network = list(CAMERA_NET_LADDER)
	cam.c_tag = name

	GLOB.ladder_list += src
	return INITIALIZE_HINT_LATELOAD

/obj/structure/ladder/LateInitialize()
	. = ..()

	for(var/i in GLOB.ladder_list)
		var/obj/structure/ladder/L = i
		if(L.id == id)
			if(L.height == (height - 1))
				down = L
				continue
			if(L.height == (height + 1))
				up = L
				continue

		if(up && down) //If both our connections are filled
			break
	update_icon()

/obj/structure/ladder/Destroy()
	if(down)
		if(istype(down))
			down.up = null
		down = null
	if(up)
		if(istype(up))
			up.down = null
		up = null
	QDEL_NULL(cam)
	GLOB.ladder_list -= src
	. = ..()

/obj/structure/ladder/update_icon()
	if(up && down)
		icon_state = "ladder11"

	else if(up)
		icon_state = "ladder10"

	else if(down)
		icon_state = "ladder01"

	else //wtf make your ladders properly assholes
		icon_state = "ladder00"

/obj/structure/ladder/attack_hand(mob/living/user)
	if(user.stat || get_dist(user, src) > 1 || user.blinded || user.body_position == LYING_DOWN || user.buckled || user.anchored) return
	if(busy)
		to_chat(user, SPAN_WARNING("已经有人在使用[src]了。"))
		return
	var/ladder_dir_name
	var/obj/structure/ladder/ladder_dest
	if(up && down)
		ladder_dir_name = alert("要沿梯子向上还是向下？", "梯子", "向上", "向下", "取消")
		if(ladder_dir_name == "取消")
			return
		ladder_dir_name = lowertext(ladder_dir_name)
		if(ladder_dir_name == "向上") ladder_dest = up
		else ladder_dest = down
	else if(up)
		ladder_dir_name = "向上"
		ladder_dest = up
	else if(down)
		ladder_dir_name = "向下"
		ladder_dest = down
	else return //just in case

	step(user, get_dir(user, src))
	user.visible_message(SPAN_NOTICE("[user]开始沿[src][ladder_dir_name]攀爬。"),
	SPAN_NOTICE("你开始沿[src][ladder_dir_name]攀爬。"))
	busy = TRUE
	if(do_after(user, 20, INTERRUPT_INCAPACITATED|INTERRUPT_OUT_OF_RANGE|INTERRUPT_RESIST, BUSY_ICON_GENERIC, src, INTERRUPT_NONE))
		if(!user.is_mob_incapacitated() && get_dist(user, src) <= 1 && !user.blinded && user.body_position != LYING_DOWN && !user.buckled && !user.anchored)
			visible_message(SPAN_NOTICE("[user]沿[src][ladder_dir_name]爬去。")) //Hack to give a visible message to the people here without duplicating user message
			user.visible_message(SPAN_NOTICE("[user]沿[src][ladder_dir_name]爬去。"),
			SPAN_NOTICE("你沿[src][ladder_dir_name]爬去。"))
			ladder_dest.add_fingerprint(user)
			user.trainteleport(ladder_dest.loc)
	busy = FALSE
	add_fingerprint(user)

/obj/structure/ladder/check_eye(mob/living/user)
	//Are we capable of looking?
	if(user.is_mob_incapacitated() || get_dist(user, src) > 1 || user.blinded || user.body_position == LYING_DOWN || !user.client)
		user.unset_interaction()

	//Are ladder cameras ok?
	else if (is_watching == 1)
		if (istype(down) && down.cam && !down.cam.can_use()) //Camera doesn't work or is gone
			user.unset_interaction()
	else if (is_watching == 2)
		if (istype(up) && up.cam && !up.cam.can_use()) //Camera doesn't work or is gone
			user.unset_interaction()



/obj/structure/ladder/on_set_interaction(mob/user)
	if (is_watching == 1)
		if (istype(down) && down.cam && down.cam.can_use()) //Camera works
			user.reset_view(down.cam)
			return
	else if (is_watching == 2)
		if (istype(up) && up.cam && up.cam.can_use())
			user.reset_view(up.cam)
			return

	user.unset_interaction() //No usable cam, we stop interacting right away



/obj/structure/ladder/on_unset_interaction(mob/user)
	..()
	is_watching = 0
	user.reset_view(null)

//Peeking up/down
/obj/structure/ladder/MouseDrop(over_object, src_location, over_location)
	if((over_object == usr && (in_range(src, usr))))
		if(islarva(usr) || isobserver(usr) || usr.is_mob_incapacitated() || usr.blinded)
			to_chat(usr, "你现在的状态无法这样做。")
			return
		if(is_watching)
			to_chat(usr, "已经有人在通过[src]观察了。")
			return
		if(up && down)
			switch( alert("要沿梯子向上还是向下看？", "梯子", "向上", "向下", "取消") )
				if("向上")
					usr.visible_message(SPAN_NOTICE("[usr]沿[src]向上看！"),
					SPAN_NOTICE("你沿[src]向上看！"))
					is_watching = 2
					usr.set_interaction(src)

				if("向下")
					usr.visible_message(SPAN_NOTICE("[usr]沿[src]向下看！"),
					SPAN_NOTICE("你沿[src]向下看！"))
					is_watching = 1
					usr.set_interaction(src)

				if("取消")
					return

		else if(up)
			usr.visible_message(SPAN_NOTICE("[usr]沿[src]向上看！"),
			SPAN_NOTICE("你沿[src]向上看！"))
			is_watching = 2
			usr.set_interaction(src)


		else if(down)
			usr.visible_message(SPAN_NOTICE("[usr]沿[src]向下看！"),
			SPAN_NOTICE("你沿[src]向下看！"))
			is_watching = 1
			usr.set_interaction(src)

	add_fingerprint(usr)

/obj/structure/ladder/ex_act(severity)
	return

//Throwing Shiet
/obj/structure/ladder/attackby(obj/item/W, mob/user)
	//Throwing Grenades
	if(istype(W,/obj/item/explosive/grenade))
		var/obj/item/explosive/grenade/G = W
		var/ladder_dir_name
		var/obj/structure/ladder/ladder_dest
		if(up && down)
			ladder_dir_name = alert("向上扔还是向下扔？", "梯子", "向上", "向下", "取消")
			if(ladder_dir_name == "取消")
				return
			ladder_dir_name = lowertext(ladder_dir_name)
			if(ladder_dir_name == "向上") ladder_dest = up
			else ladder_dest = down
		else if(up)
			ladder_dir_name = "向上"
			ladder_dest = up
		else if(down)
			ladder_dir_name = "向下"
			ladder_dest = down
		else return //just in case

		if(G.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(G, user))
			to_chat(user, SPAN_WARNING("[G.name]的安全区事故抑制器阻止了你激活手雷！"))
			// Let staff know, in case someone's actually about to try to grief
			msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
			return

		user.visible_message(SPAN_WARNING("[user]摆好姿势，准备沿[src][ladder_dir_name]投掷[G]。"),
		SPAN_WARNING("你摆好姿势，准备沿[src][ladder_dir_name]投掷[G]。"))
		if(do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			user.visible_message(SPAN_WARNING("[user]沿[src][ladder_dir_name]扔出了[G]！"),
			SPAN_WARNING("你沿[src][ladder_dir_name]扔出了[G]！"))
			user.drop_held_item()
			G.forceMove(ladder_dest.loc)
			G.setDir(pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
			step_away(G, src, rand(1, 5))
			if(!G.active)
				G.activate(user)

	//Throwing Flares and flashlights
	else if(istype(W,/obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = W
		var/ladder_dir_name
		var/obj/structure/ladder/ladder_dest
		if(up && down)
			ladder_dir_name = alert("向上扔还是向下扔？", "梯子", "向上", "向下", "取消")
			if(ladder_dir_name == "取消")
				return
			ladder_dir_name = lowertext(ladder_dir_name)
			if(ladder_dir_name == "向上") ladder_dest = up
			else ladder_dest = down
		else if(up)
			ladder_dir_name = "向上"
			ladder_dest = up
		else if(down)
			ladder_dir_name = "向下"
			ladder_dest = down
		else return //just in case

		user.visible_message(SPAN_WARNING("[user]摆好姿势，准备沿[src][ladder_dir_name]投掷[F]。"),
		SPAN_WARNING("你摆好姿势，准备沿[src][ladder_dir_name]投掷[F]。"))
		if(do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			user.visible_message(SPAN_WARNING("[user]沿[src][ladder_dir_name]扔出了[F]！"),
			SPAN_WARNING("你沿[src][ladder_dir_name]扔出了[F]！"))
			user.drop_held_item()
			F.forceMove(ladder_dest.loc)
			F.setDir(pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
			step_away(F,src,rand(1, 5))
	else
		return attack_hand(user)

/obj/structure/ladder/fragile_almayer //goes away on hijack
	name = "摇晃的梯子"
	desc = "某位能干的维修技师在干船坞外安装的梯子，看起来不太稳，随时都可能塌。"

/obj/structure/ladder/fragile_almayer/Initialize()
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_IMPACTED, PROC_REF(deconstruct))

/obj/structure/ladder/fragile_almayer/deconstruct()
	new /obj/structure/prop/broken_ladder(loc)
	return ..()

/obj/structure/prop/broken_ladder
	name = "摇晃的梯子"
	desc = "唉，早晚的事。"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "ladder00"
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = LADDER_LAYER

/obj/structure/ladder/rope
	name = "绳索"
	desc = "一根结实的绳索。"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "rope"

/obj/structure/ladder/rope/update_icon()
	return

/obj/structure/ladder/maintenance
	name = "维修梯"
	desc = "这个舱口通往地下。虽然看着不轻，实际上打开舱口应该不费事！"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "hatchclosed"
	color = "#666633"
	pixel_y = 7

/obj/structure/ladder/maintenance/update_icon()
	return
