

//Cleanbot assembly
/obj/item/frame/bucket_sensor
	desc = "一个装着传感器的水桶。"
	name = "感应水桶"
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "bucket_proxy"
	force = 3
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	var/created_name = "清洁机器人"


/obj/item/frame/bucket_sensor/attackby(obj/item/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/arm/l_arm) || istype(W, /obj/item/robot_parts/arm/r_arm))
		user.drop_held_item()
		qdel(W)
		var/turf/T = get_turf(src.loc)
		var/obj/structure/machinery/bot/cleanbot/A = new /obj/structure/machinery/bot/cleanbot(T)
		A.name = src.created_name
		to_chat(user, SPAN_NOTICE("你把机械臂装到水桶和传感器组成的组件上。哔哔啵！"))
		user.temp_drop_inv_item(src)
		qdel(src)

	else if (HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/t = copytext(stripped_input(user, "输入机器人的新名称", src.name, src.created_name),1,MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return
		src.created_name = t



//Floorbot assemblies
/obj/item/frame/toolbox_tiles
	desc = "一个工具箱，顶部露出几块地砖。"
	name = "地砖与工具箱组件"
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "toolbox_tiles"
	force = 3
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	var/created_name = "铺地机器人"


/obj/item/frame/toolbox_tiles/attackby(obj/item/W, mob/user as mob)
	..()
	if(isprox(W))
		qdel(W)
		var/obj/item/frame/toolbox_tiles_sensor/B = new /obj/item/frame/toolbox_tiles_sensor()
		B.created_name = src.created_name
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("你把传感器装到工具箱和地砖组成的组件上！"))
		user.temp_drop_inv_item(src)
		qdel(src)

	else if (HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/t = copytext(stripped_input(user, "输入机器人的新名称", src.name, src.created_name),1,MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.created_name = t



/obj/item/frame/toolbox_tiles_sensor
	desc = "一个顶部露出地砖、还装着传感器的工具箱。"
	name = "地砖、工具箱与传感器组件"
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "toolbox_tiles_sensor"
	force = 3
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	var/created_name = "铺地机器人"

/obj/item/frame/toolbox_tiles_sensor/attackby(obj/item/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/arm/l_arm) || istype(W, /obj/item/robot_parts/arm/r_arm))
		qdel(W)
		var/turf/T = get_turf(user.loc)
		var/obj/structure/machinery/bot/floorbot/A = new /obj/structure/machinery/bot/floorbot(T)
		A.name = src.created_name
		to_chat(user, SPAN_NOTICE("你把机械臂装到这个古怪的工具箱组件上！啵哔哔！"))
		user.temp_drop_inv_item(src)
		qdel(src)
	else if (HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/t = stripped_input(user, "输入机器人的新名称", src.name, src.created_name)

		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.created_name = t







/obj/item/frame/firstaid_arm_assembly
	name = "急救箱与机械臂组件"
	desc = "一个牢牢装着机械臂的急救箱。"
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "firstaid_arm"
	var/build_step = 0
	var/created_name = "医疗机器人" //To preserve the name if it's a unique medbot I guess
	var/skin = null //Same as medbot, set to tox or ointment for the respective kits.
	w_class = SIZE_MEDIUM

/obj/item/frame/firstaid_arm_assembly/New()
	..()
	spawn(5)
		if(src.skin)
			src.overlays += image('icons/obj/structures/machinery/aibots.dmi', "kit_skin_[src.skin]")


/obj/item/frame/firstaid_arm_assembly/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(HAS_TRAIT(W, TRAIT_TOOL_PEN))
		var/t = copytext(stripped_input(user, "输入机器人的新名称", src.name, src.created_name),1,MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return
		src.created_name = t
	else
		switch(build_step)
			if(0)
				if(istype(W, /obj/item/device/healthanalyzer/soul))
					user.drop_held_item()
					qdel(W)
					src.build_step++
					to_chat(user, SPAN_NOTICE("你把健康扫描仪装到了[src]上。"))
					src.name = "急救箱、机械臂与健康分析仪组件"
					src.overlays += image('icons/obj/structures/machinery/aibots.dmi', "na_scanner")

			if(1)
				if(isprox(W))
					user.drop_held_item()
					qdel(W)
					src.build_step++
					to_chat(user, SPAN_NOTICE("你组装好了医疗机器人！哔哔啵。"))
					var/turf/T = get_turf(src)
					var/obj/structure/machinery/bot/medbot/S = new /obj/structure/machinery/bot/medbot(T)
					S.skin = src.skin
					S.name = src.created_name
					user.temp_drop_inv_item(src)
					qdel(src)
