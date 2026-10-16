/obj/structure/toilet
	name = "马桶"
	desc = "HT-451，采用扭矩旋转原理处理小块废物的装置。这个看起来格外干净。"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	unslashable = TRUE
	buckle_lying = 0
	/// if the lid is up
	var/open = 0
	/// if the cistern bit is open
	var/cistern = 0
	/// the combined w_class of all the items in the cistern
	var/w_items = 0
	/// the mob being given a swirlie
	var/mob/living/swirlie = null
	var/list/buckling_y = list("north" = 1, "south" = 4, "east" = 0, "west" = 0)
	var/list/buckling_x = list("north" = 0, "south" = 0, "east" = -5, "west" = 4)
	var/atom/movable/overlay/cistern_overlay


/obj/structure/toilet/Initialize()
	. = ..()
	open = floor(rand(0, 1))
	cistern_overlay = new()
	cistern_overlay.icon = icon
	cistern_overlay.layer = ABOVE_MOB_LAYER
	cistern_overlay.vis_flags = VIS_INHERIT_DIR|VIS_INHERIT_ID
	vis_contents += cistern_overlay
	update_icon()


/obj/structure/toilet/attack_hand(mob/living/user as mob)
	if(buckled_mob)
		manual_unbuckle(user)
		return

	if(swirlie)
		user.visible_message(SPAN_DANGER("[user]将马桶座圈猛砸在[swirlie.name]头上！"), SPAN_NOTICE("你将马桶座圈猛砸在[swirlie.name]头上！"), "你听到瓷器震响。")
		swirlie.apply_damage(8, BRUTE)
		return

	if(!open)
		if(cistern)
			if(!length(contents))
				to_chat(user, SPAN_NOTICE("水箱是空的。"))
				return
			else
				var/obj/item/I = pick(contents)
				if(ishuman(user))
					user.put_in_hands(I)
				else
					I.forceMove(get_turf(src))
				to_chat(user, SPAN_NOTICE("你在水箱里发现了[I]。"))
				w_items -= I.w_class
				return
		else
			open = !open // Toggles open to opposite state
			update_icon()

	else // open
		if(user.action_busy) // Prevent spamming faster than do_after speed
			return
		if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			return

		playsound(loc, 'sound/effects/toilet_flush_new.ogg', 25, 1)
		flick("toilet1[cistern]_flush", src)
		if(dir == SOUTH)
			flick("cistern[cistern]_flush", cistern_overlay)


/obj/structure/toilet/send_buckling_message(mob/M, mob/user)
	if (M == user)
		to_chat(M, SPAN_NOTICE("你坐到马桶上。"))
	else
		to_chat(user, SPAN_NOTICE("[user]将[M]安置在马桶上。"))
		to_chat(M, SPAN_NOTICE("[user]将你安置在马桶上。"))


/obj/structure/toilet/afterbuckle(mob/M)
	. = ..()

	if(. && buckled_mob == M)
		var/direction = dir2text(dir)
		M.pixel_y = buckling_y[direction] + pixel_y
		M.pixel_x = buckling_x[direction] + pixel_x
		density = TRUE

		if(dir == NORTH)
			if(cistern == 1)
				M.overlays += image("toilet01")
			else
				M.overlays += image("toilet00")
	else
		M.pixel_y = initial(buckled_mob.pixel_y)
		M.old_y = initial(buckled_mob.pixel_y)
		M.pixel_x = initial(buckled_mob.pixel_x)
		M.old_x = initial(buckled_mob.pixel_x)
		density = FALSE

		if(dir == NORTH)
			if(cistern == 1)
				M.overlays -= image("toilet01")
			else
				M.overlays -= image("toilet00")


/obj/structure/toilet/verb/flip_lid()
	set name = "翻转盖板"
	set category = "物品"
	set src in view(1)

	open = !open
	update_icon()


/obj/structure/toilet/update_icon()
	icon_state = "toilet[open][cistern]"
	cistern_overlay.icon_state = "cistern[cistern]"


/obj/structure/toilet/attackby(obj/item/I, mob/living/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_CROWBAR))
		to_chat(user, SPAN_NOTICE("你开始[cistern ? "盖上水箱盖" : "掀开水箱盖"]。"))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 25, 1)
		if(do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user][cistern ? "盖上了水箱盖" : "掀开了水箱盖"]！"), SPAN_NOTICE("你[cistern ? "盖上了水箱盖" : "掀开了水箱盖"]！"), "你听到瓷器摩擦的声音。")
			cistern = !cistern
			update_icon()
			return

	if(istype(I, /obj/item/grab))
		if(isxeno(user)) return
		var/obj/item/grab/G = I

		if(isliving(G.grabbed_thing))
			var/mob/living/GM = G.grabbed_thing

			if(user.grab_level > GRAB_PASSIVE)
				if(!GM.loc == get_turf(src))
					to_chat(user, SPAN_NOTICE("[GM.name]需要先位于马桶上。"))
					return
				if(open && !swirlie)
					user.visible_message(SPAN_DANGER("[user]开始将[GM.name]的头按进马桶冲水！"), SPAN_NOTICE("你开始将[GM.name]的头按进马桶冲水！"))
					swirlie = GM
					if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
						user.visible_message(SPAN_DANGER("[user]将[GM.name]的头按在马桶里冲水！"), SPAN_NOTICE("你将[GM.name]的头按在马桶里冲水！"), "你听到马桶冲水声。")
						if(!GM.internal)
							GM.apply_damage(5, OXY)
					swirlie = null
				else
					user.visible_message(SPAN_DANGER("[user]将[GM.name]猛撞向[src]！"), SPAN_NOTICE("你将[GM.name]猛撞向[src]！"))
					GM.apply_damage(8, BRUTE)
			else
				to_chat(user, SPAN_NOTICE("你需要抓得更紧。"))

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(I.w_class > SIZE_MEDIUM)
			to_chat(user, SPAN_NOTICE("[I]放不进去。"))
			return
		if(w_items + I.w_class > 5)
			to_chat(user, SPAN_NOTICE("水箱已满。"))
			return
		user.drop_held_item()
		I.forceMove(src)
		w_items += I.w_class
		to_chat(user, "你小心地将[I]放进水箱。")
		return
