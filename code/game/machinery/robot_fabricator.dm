/obj/structure/machinery/robotic_fabricator
	name = "机器人制造机"
	icon = 'icons/obj/structures/machinery/robotics.dmi'
	icon_state = "fab-idle"
	density = TRUE
	anchored = TRUE
	var/metal_amount = 0
	var/operating = 0
	var/obj/item/robot_parts/being_built = null
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	active_power_usage = 10000

/obj/structure/machinery/robotic_fabricator/attackby(obj/item/O as obj, mob/user as mob)
	if (istype(O, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = O
		if (src.metal_amount < 150000.0)
			var/count = 0
			src.overlays += "fab-load-metal"
			spawn(15)
				if(M)
					if(!M.get_amount())
						return
					while(metal_amount < 150000 && M.amount)
						src.metal_amount += O.matter["metal"] /*O:height * O:width * O:length * 100000.0*/
						M.use(1)
						count++

					to_chat(user, "你向制造机中放入了[count]张金属板。")
					src.overlays -= "fab-load-metal"
					updateDialog()
		else
			to_chat(user, "机器人零件制造机已经装满。请先取出部分金属，再放入更多材料。")

/obj/structure/machinery/robotic_fabricator/attack_hand(user as mob)
	var/dat
	if (..())
		return

	if (src.operating)
		dat = {"
<TT>正在制造[src.being_built.name]。<BR>
请等待制造完成……</TT><BR>
<BR>
"}
	else
		dat = {"
<B>金属储量：</B> [min(150000, src.metal_amount)] cm<sup>3</sup>（最大：150,000）<BR><HR>
<BR>
<A href='byond://?src=\ref[src];make=1'>左臂（25,000 立方厘米金属）<BR>
<A href='byond://?src=\ref[src];make=2'>右臂（25,000 立方厘米金属）<BR>
<A href='byond://?src=\ref[src];make=3'>左腿（25,000 立方厘米金属）<BR>
<A href='byond://?src=\ref[src];make=4'>右腿（25,000 立方厘米金属）<BR>
<A href='byond://?src=\ref[src];make=5'>胸部（50,000 立方厘米金属）<BR>
<A href='byond://?src=\ref[src];make=6'>头部（50,000 立方厘米金属）<BR>
<A href='byond://?src=\ref[src];make=7'>机器人机架（75,000 立方厘米金属）<BR>
"}

	user << browse("<HEAD><TITLE>机器人制造机控制面板</TITLE></HEAD><TT>[dat]</TT>", "window=robot_fabricator")
	onclose(user, "robot_fabricator")
	return

/obj/structure/machinery/robotic_fabricator/Topic(href, href_list)
	if (..())
		return

	usr.set_interaction(src)
	src.add_fingerprint(usr)

	if (href_list["make"])
		if (!src.operating)
			var/part_type = text2num(href_list["make"])

			var/build_type = ""
			var/build_time = 200
			var/build_cost = 25000

			switch (part_type)
				if (1)
					build_type = /obj/item/robot_parts/arm/l_arm
					build_time = 200
					build_cost = 25000

				if (2)
					build_type = /obj/item/robot_parts/arm/r_arm
					build_time = 200
					build_cost = 25000

				if (3)
					build_type = /obj/item/robot_parts/leg/l_leg
					build_time = 200
					build_cost = 25000

				if (4)
					build_type = /obj/item/robot_parts/leg/r_leg
					build_time = 200
					build_cost = 25000

				if (5)
					build_type = /obj/item/robot_parts/chest
					build_time = 350
					build_cost = 50000

				if (6) // Not a real robot head due to numerous issues with cyborg code currently. Still usable by admins
					build_type = /obj/item/fake_robot_head
					build_time = 350
					build_cost = 50000

				if (7)
					build_type = /obj/item/robot_parts/robot_suit
					build_time = 600
					build_cost = 75000

			var/building = build_type
			if (building in (subtypesof(/obj/item/robot_parts) + /obj/item/fake_robot_head))
				if (src.metal_amount >= build_cost)
					src.operating = 1
					src.update_use_power(USE_POWER_ACTIVE)

					src.metal_amount = max(0, src.metal_amount - build_cost)

					src.being_built = new building(src)

					src.overlays += "fab-active"
					src.updateUsrDialog()

					spawn (build_time)
						if (!QDELETED(src.being_built))
							src.being_built.forceMove(get_turf(src))
							src.being_built = null
						src.update_use_power(USE_POWER_IDLE)
						src.operating = 0
						src.overlays -= "fab-active"
			else return //Someone's doing href fuckery if this gets here.
		return

	for (var/mob/M as anything in viewers(1, src))
		if (M.client && M.interactee == src)
			src.attack_hand(M)
