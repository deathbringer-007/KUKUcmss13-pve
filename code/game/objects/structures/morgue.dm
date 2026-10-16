/*
 * Morgue
 */
/obj/structure/morgue
	name = "停尸柜"
	desc = "用于存放尸体，直至有人将其领走。"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = TRUE
	var/obj/structure/morgue_tray/connected = null
	var/morgue_type = "morgue"
	var/tray_path = /obj/structure/morgue_tray
	var/morgue_open = 0
	var/exit_stun = 2
	var/update_name = TRUE
	anchored = TRUE
	throwpass = 1

/obj/structure/morgue/Initialize()
	. = ..()
	connected = new tray_path(src)

/obj/structure/morgue/Destroy()
	for(var/atom/movable/object in contents)
		object.forceMove(loc)
	. = ..()
	QDEL_NULL(connected)

/obj/structure/morgue/update_icon()
	if(morgue_open)
		icon_state = "[morgue_type]0"
	else
		if(length(contents) > 1) //not counting the morgue tray
			icon_state = "[morgue_type]2"
		else
			icon_state = "[morgue_type]1"

/obj/structure/morgue/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				return
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(95))
				return
	contents_explosion(severity)
	deconstruct(FALSE)

/obj/structure/morgue/attack_hand(mob/user)
	toggle_morgue(user)

/obj/structure/morgue/proc/toggle_morgue(mob/user)
	add_fingerprint(user)
	if(!connected) return
	if(morgue_open)
		for(var/atom/movable/A in connected.loc)
			if(!A.anchored)
				A.forceMove(src)
		connected.forceMove(src)
		if(update_name)
			name = initial(name)
			var/mob/living/L = locate(/mob/living) in contents
			if(L)
				name = "[name] ([L])"
			else
				var/obj/structure/closet/bodybag/B = locate(/obj/structure/closet/bodybag) in contents
				if(B)
					L = locate(/mob/living) in B.contents
					if(L)
						name = "[name] ([L])"

	else
		name = initial(name)
		connected.forceMove(loc)
		if(step(connected, dir))
			connected.setDir(dir)
			for(var/atom/movable/A in src)
				A.forceMove(connected.loc)
		else
			connected.forceMove(src)
			return
	morgue_open = !morgue_open
	playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
	update_icon()


/obj/structure/morgue/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/zombie_claws))
		attack_hand()
		return
	else if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/prior_label_text
		var/datum/component/label/labelcomponent = src.GetComponent(/datum/component/label)
		if(labelcomponent)
			prior_label_text = labelcomponent.label_name
		var/tmp_label = sanitize(input(user, "为[name]输入标签","标签", prior_label_text))
		if(tmp_label == "" || !tmp_label)
			if(labelcomponent)
				labelcomponent.remove_label()
				user.visible_message(SPAN_NOTICE("[user]撕下了[src]上的标签。"), \
				SPAN_NOTICE("你撕下了[src]上的标签。"))
				return
			else
				return
		if(length(tmp_label) > MAX_NAME_LEN)
			to_chat(user, SPAN_WARNING("标签最多可包含[MAX_NAME_LEN]个字符。"))
		else
			user.visible_message(SPAN_NOTICE("[user]给[src]贴上了“[tmp_label]”的标签。"), \
			SPAN_NOTICE("你给[src]贴上了“[tmp_label]”的标签。"))
			AddComponent(/datum/component/label, tmp_label)
			playsound(src, "paper_writing", 15, TRUE)
	else
		. = ..()

/obj/structure/morgue/relaymove(mob/living/user)
	if(user.is_mob_incapacitated())
		return
	if(exit_stun)
		user.apply_effect(exit_stun, STUN)
		if(user.mobility_flags & MOBILITY_MOVE)
			user.visible_message(SPAN_WARNING("[user]突然从[src]里钻了出来！"),
			SPAN_WARNING("你从[src]里钻出来，重新辨清了方向！"))
		toggle_morgue(user)


/*
 * Morgue tray
 */

/obj/structure/morgue_tray
	name = "停尸柜托盘"
	desc = "关闭前请放入尸体。"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "morguet"
	var/icon_tray = ""
	density = TRUE
	layer = OBJ_LAYER
	var/obj/structure/morgue/linked_morgue = null
	anchored = TRUE
	unslashable = TRUE
	throwpass = 1
	var/bloody = FALSE

/obj/structure/morgue_tray/New(loc, obj/structure/morgue/morgue_source)
	icon_tray = initial(icon_state)
	if(morgue_source)
		linked_morgue = morgue_source
	..()

/obj/structure/morgue_tray/Destroy()
	. = ..()
	linked_morgue = null

/obj/structure/morgue_tray/MouseDrop_T(atom/movable/O, mob/user)
	if(!istype(O) || O.anchored || !isturf(O.loc))
		return
	if(!ismob(O) && !istype(O, /obj/structure/closet/bodybag))
		return
	if(!istype(user) || user.is_mob_incapacitated() || !isturf(user.loc))
		return
	O.forceMove(loc)
	if(user != O)
		for(var/mob/B in viewers(user, 3))
			B.show_message(SPAN_DANGER("[user]将[O]塞进了[src]！"), SHOW_MESSAGE_VISIBLE)
			if(B.stat==DEAD)
				bloody = TRUE
				update_icon()

/obj/structure/morgue_tray/update_icon()
	if(bloody)
		icon_state = icon_tray + "_b"
	else
		icon_state = icon_tray

/obj/structure/morgue_tray/clean_blood()
	bloody = FALSE
	update_icon()
	. = ..()


/*
 * Crematorium
 */

/obj/structure/morgue/crematorium
	name = "焚尸炉"
	desc = "用于焚烧人体的炉子。烧烤之夜也很好用。"
	icon_state = "crema1"
	dir = SOUTH
	tray_path = /obj/structure/morgue_tray/crematorium
	morgue_type = "crema"
	var/cremating = 0
	var/id = 1


/obj/structure/morgue/crematorium/toggle_morgue(mob/user)
	if(cremating)
		to_chat(user, SPAN_WARNING("它锁着。"))
		return
	..()


/obj/structure/morgue/crematorium/relaymove(mob/user)
	if(cremating) return
	..()


/obj/structure/morgue/crematorium/update_icon()
	if(cremating)
		icon_state = "[morgue_type]_active"
	else
		..()


/obj/structure/morgue/crematorium/proc/cremate(mob/user)
	set waitfor = 0
	if(cremating)
		return

	if(length(contents) <= 1) //1 because the tray is inside.
		visible_message(SPAN_DANGER("你听到空洞的噼啪声。"))
	else
		visible_message(SPAN_DANGER("焚尸炉启动，发出一阵轰鸣。"))

		cremating = 1

		update_icon()

		for(var/mob/living/M in contents)
			if(M.stat!=DEAD)
				if(!ishuman(M))
					M.emote("scream")
				else
					var/mob/living/carbon/human/H = M
					if(H.pain.feels_pain)
						H.emote("scream")

			user.attack_log +="\[[time_stamp()]\] Cremated <b>[key_name(M)]</b>"
			msg_admin_attack("\[[time_stamp()]\] <b>[key_name(user)]</b> cremated <b>[key_name(M)]</b> in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
			M.death(create_cause_data("cremation", user), TRUE)
			M.ghostize()
			qdel(M)

		for(var/obj/O in contents)
			if(istype(O, /obj/structure/morgue_tray)) continue
			qdel(O)

		new /obj/effect/decal/cleanable/ash(src)
		sleep(30)
		cremating = 0
		update_icon()
		playsound(src.loc, 'sound/machines/ding.ogg', 25, 1)


/*
 * Crematorium tray
 */

/obj/structure/morgue_tray/crematorium
	name = "焚尸炉托盘"
	desc = "焚烧前请放入尸体。"
	icon_state = "cremat"


/*
 * Crematorium switch
 */

/obj/structure/machinery/crema_switch/attack_hand(mob/user)
	if(allowed(user))
		for(var/obj/structure/morgue/crematorium/C in range(7,src))
			if(C.id == id)
				if(!C.cremating)
					C.cremate(user)
	else
		to_chat(user, SPAN_DANGER("权限不足。"))



/*
 * Sarcophagus
 */

/obj/structure/morgue/sarcophagus
	name = "石棺"
	desc = "用于安放阵亡战士。"
	icon_state = "sarcophagus1"
	morgue_type = "sarcophagus"
	tray_path = /obj/structure/morgue_tray/sarcophagus
	update_name = FALSE


/*
 * Sarcophagus tray
 */

/obj/structure/morgue_tray/sarcophagus
	name = "石棺托盘"
	desc = "关闭前请放入尸体。"
	icon_state = "sarcomat"
