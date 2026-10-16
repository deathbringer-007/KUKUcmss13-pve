//Empty sandbags
/obj/item/stack/sandbags_empty
	name = "空沙袋"
	desc = "一些空沙袋，使用之前最好先装满。"
	singular_name = "沙袋"
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "sandbag_stack"
	item_state = "sandbag_stack"
	w_class = SIZE_SMALL
	force = 2
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 50
	attack_verb = list("击打", "拍打", "猛击")
	stack_id = "empty sandbags"

/obj/item/stack/sandbags_empty/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/shovel))
		var/obj/item/tool/shovel/ET = W
		if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_MAKE_BARRICADES))
			to_chat(usr, SPAN_WARNING("无法填装沙袋！"))
			return
		if(ET.dirt_amt)
			ET.dirt_amt--
			ET.update_icon()
			var/obj/item/stack/sandbags/new_bags = new(user.loc)
			new_bags.add_to_stacks(user)
			var/obj/item/stack/sandbags_empty/E = src
			src = null
			var/replace = (user.get_inactive_hand() == E)
			playsound(user.loc, "rustle", 30, 1, 6)
			E.use(1)
			if(!E && replace)
				user.put_in_hands(new_bags)

	else if (istype(W, /obj/item/stack/snow))
		var/obj/item/stack/S = W
		var/obj/item/stack/sandbags/new_bags = new(user.loc)
		new_bags.add_to_stacks(user)
		S.use(1)
		use(1)
	else
		return ..()


//half a max stack
/obj/item/stack/sandbags_empty/small_stack
	amount = STACK_10

/obj/item/stack/sandbags_empty/half
	amount = 25

//full stack
/obj/item/stack/sandbags_empty/full
	amount = STACK_50

//Full sandbags
/obj/item/stack/sandbags
	name = "沙袋"
	desc = "装满沙子的袋子。眼下搬着累赘，很快就能成为防御工事。"
	singular_name = "沙袋"
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "sandbag_pile"
	item_state = "sandbag_pile"
	w_class = SIZE_MEDIUM
	force = 9
	throwforce = 15
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 50
	attack_verb = list("击打", "重击", "猛击")
	stack_id = "sandbags"

/obj/item/stack/sandbags/large_stack
	amount = 50

/obj/item/stack/sandbags/small_stack
	amount = 5

/obj/item/stack/sandbags/attack_self(mob/living/user)
	..()
	add_fingerprint(user)

	if(!isturf(user.loc))
		return
	if(istype(user.loc, /turf/open/shuttle))
		to_chat(user, SPAN_WARNING("不行。这里必须留给运输机和人员通行。"))
		return
	if(!istype(user.loc, /turf/open))
		var/turf/open/OT = user.loc
		if(!OT.allow_construction)
			to_chat(user, SPAN_WARNING("沙袋路障必须建在合适的地面上！"))
			return

	//Using same safeties as other constructions
	for(var/obj/O in user.loc) //Objects, we don't care about mobs. Turfs are checked elsewhere
		var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in usr.loc // for M2C HMG, look at smartgun_mount.dm
		if(O.density)
			if(O.flags_atom & ON_BORDER)
				if(O.dir == user.dir)
					to_chat(user, SPAN_WARNING("这个方向已经有[O.name]了！"))
					return
			else
				to_chat(user, SPAN_WARNING("你需要一片没有障碍物的空地才能建造沙袋路障！"))
				return
		if(AC)
			to_chat(usr, SPAN_WARNING("这里不能建造[O.name]！"))
			return

	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_MAKE_BARRICADES))
		to_chat(usr, SPAN_WARNING("无法放置沙袋。"))
		return

	if(user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user]开始堆砌沙袋路障。"),
	SPAN_NOTICE("你开始堆砌沙袋路障。"))

	if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	for(var/obj/O in user.loc) //Objects, we don't care about mobs. Turfs are checked elsewhere
		if(O.density)
			if(!(O.flags_atom & ON_BORDER) || O.dir == user.dir)
				return

	var/build_stack = amount
	if(amount >= 5)
		build_stack = 5

	var/obj/structure/barricade/sandbags/SB = new(user.loc, user, user.dir, build_stack)
	user.visible_message(SPAN_NOTICE("[user]堆好了沙袋路障。"),
	SPAN_NOTICE("你堆好了沙袋路障。"))
	SB.setDir(user.dir)
	SB.add_fingerprint(user)
	use(build_stack)
