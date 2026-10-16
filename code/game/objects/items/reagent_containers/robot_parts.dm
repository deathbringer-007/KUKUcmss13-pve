/obj/item/robot_parts
	name = "机器人零件"
	icon = 'icons/obj/items/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	matter = list("metal" = 500, "glass" = 0)
	var/list/part = null

/obj/item/robot_parts/arm/l_arm
	name = "机器人左臂"
	desc = "由人造肌肉包覆的肢体骨架，外壳导电性较低。"
	icon_state = "l_arm"
	part = list("l_arm","l_hand")

/obj/item/robot_parts/arm/r_arm
	name = "机器人右臂"
	desc = "由人造肌肉包覆的肢体骨架，外壳导电性较低。"
	icon_state = "r_arm"
	part = list("r_arm","r_hand")

/obj/item/robot_parts/leg/l_leg
	name = "机器人左腿"
	desc = "由人造肌肉包覆的肢体骨架，外壳导电性较低。"
	icon_state = "l_leg"
	part = list("l_leg","l_foot")

/obj/item/robot_parts/leg/r_leg
	name = "机器人右腿"
	desc = "由人造肌肉包覆的肢体骨架，外壳导电性较低。"
	icon_state = "r_leg"
	part = list("r_leg","r_foot")

/obj/item/robot_parts/hand/l_hand
	name = "机器人左手"
	desc = "由人造肌肉包覆的肢体骨架，外壳导电性较低。"
	icon_state = "l_hand"
	part = list("l_hand")

/obj/item/robot_parts/hand/r_hand
	name = "机器人右手"
	desc = "由人造肌肉包覆的肢体骨架，外壳导电性较低。"
	icon_state = "r_hand"
	part = list("r_hand")

/obj/item/robot_parts/foot/l_foot
	name = "机器人左脚"
	desc = "由人造肌肉包覆的肢体骨架，外壳导电性较低。"
	icon_state = "l_foot"
	part = list("l_foot")

/obj/item/robot_parts/foot/r_foot
	name = "机器人右脚"
	desc = "由人造肌肉包覆的肢体骨架，外壳导电性较低。"
	icon_state = "r_foot"
	part = list("r_foot")

/obj/item/robot_parts/chest
	name = "机器人躯干"
	desc = "经过重度加固的外壳，内置机器人的逻辑电路板，并留有安装标准电池的空间。"
	icon_state = "chest"
	var/wires = 0
	var/obj/item/cell/cell = null

/obj/item/robot_parts/head
	name = "机器人头部"
	desc = "标准的强化脑壳，配有连接脊柱的神经接口和传感器万向架。"
	icon_state = "head"
	var/obj/item/device/flash/flash1 = null
	var/obj/item/device/flash/flash2 = null

/// A cameo of a real robotic head with limited gameplay functionality
/obj/item/fake_robot_head
	name = "故障机器人头部"
	desc = "标准的强化脑壳——前提是它的制造工艺合格。这一个看起来有缺陷。"
	icon = 'icons/obj/items/robot_parts.dmi'
	icon_state = "head"
	item_state = "buildpipe"
	flags_equip_slot = SLOT_WAIST
	matter = list("metal" = 500, "glass" = 0)

/obj/item/robot_parts/robot_suit
	name = "机器人内骨骼"
	desc = "复杂的金属脊柱，配有标准肢体接口和人造肌肉固定点。"
	icon_state = "robo_suit"
	var/obj/item/robot_parts/arm/l_arm/l_arm = null
	var/obj/item/robot_parts/arm/r_arm/r_arm = null
	var/obj/item/robot_parts/leg/l_leg/l_leg = null
	var/obj/item/robot_parts/leg/r_leg/r_leg = null
	var/obj/item/robot_parts/chest/chest = null
	var/obj/item/robot_parts/head/head = null
	var/created_name = ""

/obj/item/robot_parts/robot_suit/New()
	..()
	src.updateicon()

/obj/item/robot_parts/robot_suit/proc/updateicon()
	src.overlays.Cut()
	if(src.l_arm)
		src.overlays += "l_arm+o"
	if(src.r_arm)
		src.overlays += "r_arm+o"
	if(src.chest)
		src.overlays += "chest+o"
	if(src.l_leg)
		src.overlays += "l_leg+o"
	if(src.r_leg)
		src.overlays += "r_leg+o"
	if(src.head)
		src.overlays += "head+o"

/obj/item/robot_parts/robot_suit/proc/check_completion()
	if(src.l_arm && src.r_arm)
		if(src.l_leg && src.r_leg)
			if(src.chest && src.head)
				return 1
	return 0

/obj/item/robot_parts/robot_suit/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/leg/l_leg))
		if(l_leg) return
		if(user.drop_inv_item_to_loc(W, src))
			l_leg = W
			updateicon()

	if(istype(W, /obj/item/robot_parts/leg/r_leg))
		if(r_leg) return
		if(user.drop_inv_item_to_loc(W, src))
			r_leg = W
			updateicon()

	if(istype(W, /obj/item/robot_parts/arm/l_arm))
		if(l_arm) return
		if(user.drop_inv_item_to_loc(W, src))
			l_arm = W
			updateicon()

	if(istype(W, /obj/item/robot_parts/arm/r_arm))
		if(r_arm) return
		if(user.drop_inv_item_to_loc(W, src))
			r_arm = W
			updateicon()

	if(istype(W, /obj/item/robot_parts/chest))
		if(chest) return
		if(W:wires && W:cell)
			if(user.drop_inv_item_to_loc(W, src))
				chest = W
				updateicon()
		else if(!W:wires)
			to_chat(user, SPAN_NOTICE("你得先给它接好电线！"))
		else
			to_chat(user, SPAN_NOTICE("你得先给它装上电池！"))

	if(istype(W, /obj/item/robot_parts/head))
		if(head) return
		if(W:flash2 && W:flash1)
			if(user.drop_inv_item_to_loc(W, src))
				head = W
				updateicon()
		else
			to_chat(user, SPAN_NOTICE("你得先给它装上闪光器！"))

	return

/obj/item/robot_parts/chest/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/cell))
		if(src.cell)
			to_chat(user, SPAN_NOTICE("你已经装好电池了！"))
			return
		else
			if(user.drop_inv_item_to_loc(W, src))
				cell = W
				to_chat(user, SPAN_NOTICE("你装入了电池！"))
	if(istype(W, /obj/item/stack/cable_coil))
		if(src.wires)
			to_chat(user, SPAN_NOTICE("你已经接好电线了！"))
			return
		else
			var/obj/item/stack/cable_coil/coil = W
			coil.use(1)
			src.wires = 1
			to_chat(user, SPAN_NOTICE("你接好了电线！"))
	return

/obj/item/robot_parts/head/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/device/flash))
		if(istype(user,/mob/living/silicon/robot))
			to_chat(user, SPAN_DANGER("你打算怎么做到这一点？"))
			return
		else if(src.flash1 && src.flash2)
			to_chat(user, SPAN_NOTICE("你已经装好眼睛了！"))
			return
		else if(src.flash1)
			if(user.drop_inv_item_to_loc(W, src))
				flash2 = W
				to_chat(user, SPAN_NOTICE("你把闪光器装进了眼窝！"))
		else
			user.drop_inv_item_to_loc(W, src)
			flash1 = W
			to_chat(user, SPAN_NOTICE("你把闪光器装进了眼窝！"))
	else if(istype(W, /obj/item/stock_parts/manipulator))
		to_chat(user, SPAN_NOTICE("你装上一些机械臂并改造头部，造出了能正常运作的蜘蛛机器人！"))
		new /mob/living/simple_animal/spiderbot(get_turf(loc))
		user.temp_drop_inv_item(W)
		qdel(W)
		qdel(src)
		return
	return

/obj/item/fake_robot_head/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/device/flash))
		to_chat(user, SPAN_DANGER("这东西看起来已经彻底报废，没法再利用了……"))
	// I lied
	else if(istype(W, /obj/item/stock_parts/manipulator))
		to_chat(user, SPAN_NOTICE("你用一些机械臂凑合修好了这个头部，造出了基本能正常运作的蜘蛛机器人！"))
		new /mob/living/simple_animal/spiderbot(get_turf(loc))
		qdel(W)
		qdel(src)
