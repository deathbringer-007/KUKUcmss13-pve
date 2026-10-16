



//Floorbot
/obj/structure/machinery/bot/floorbot
	name = "地板维修机器人"
	desc = "小巧的地板维修机器人，看起来兴奋极了！"
	icon = 'icons/obj/structures/machinery/aibots.dmi'
	icon_state = "floorbot0"
	density = FALSE
	anchored = FALSE
	health = 25
	maxhealth = 25
	//weight = 1.0E7
	var/amount = 10
	var/repairing = 0
	var/improvefloors = 0
	var/eattiles = 0
	var/maketiles = 0
	var/turf/target
	var/turf/oldtarget
	var/oldloc = null
	req_access = list(ACCESS_CIVILIAN_ENGINEERING)
	var/path[] = new()
	var/targetdirection


/obj/structure/machinery/bot/floorbot/New()
	..()
	src.updateicon()
	start_processing()

/obj/structure/machinery/bot/floorbot/turn_on()
	. = ..()
	src.updateicon()
	src.updateUsrDialog()

/obj/structure/machinery/bot/floorbot/turn_off()
	..()
	src.target = null
	src.oldtarget = null
	src.oldloc = null
	src.updateicon()
	src.path = new()
	src.updateUsrDialog()

/obj/structure/machinery/bot/floorbot/attack_hand(mob/user as mob)
	. = ..()
	if (.)
		return
	usr.set_interaction(src)
	interact(user)

/obj/structure/machinery/bot/floorbot/interact(mob/user as mob)
	var/dat
	dat += "<TT><B>自动地板维修机器人v1.0</B></TT><BR><BR>"
	dat += "状态：<A href='byond://?src=\ref[src];operation=start'>[src.on ? "开启" : "关闭"]</A><BR>"
	dat += "维护面板[src.open ? "已打开" : "已关闭"]<BR>"
	dat += "剩余地砖：[src.amount]<BR>"
	dat += "行为控制[src.locked ? "已锁定" : "已解锁"]<BR>"
	if(!src.locked || isRemoteControlling(user))
		dat += "改善地板： <A href='byond://?src=\ref[src];operation=improve'>[src.improvefloors ? "是" : "否"]</A><BR>"
		dat += "寻找地砖： <A href='byond://?src=\ref[src];operation=tiles'>[src.eattiles ? "是" : "否"]</A><BR>"
		dat += "地砖用尽时将单块金属加工为地砖： <A href='byond://?src=\ref[src];operation=make'>[src.maketiles ? "是" : "否"]</A><BR>"
		var/list/direction_names = list("north" = "北", "south" = "南", "east" = "东", "west" = "西", "northeast" = "东北", "northwest" = "西北", "southeast" = "东南", "southwest" = "西南")
		var/bmode
		if (src.targetdirection)
			bmode = direction_names[dir2text(src.targetdirection)]
		else
			bmode = "已禁用"
		dat += "<BR><BR>搭桥模式： <A href='byond://?src=\ref[src];operation=bridgemode'>[bmode]</A><BR>"

	show_browser(user, dat, "地板维修机器人v1.0控制", "autorepair")
	return


/obj/structure/machinery/bot/floorbot/attackby(obj/item/W , mob/user as mob)
	if(istype(W, /obj/item/stack/tile/plasteel))
		var/obj/item/stack/tile/plasteel/T = W
		if(src.amount >= 50)
			return
		var/loaded = min(50-src.amount, T.get_amount())
		T.use(loaded)
		src.amount += loaded
		to_chat(user, SPAN_NOTICE("你向地板维修机器人装入了[loaded]块地砖，现在共有[src.amount]块。"))
		src.updateicon()
	else if(istype(W, /obj/item/card/id))
		if(src.allowed(usr) && !open)
			src.locked = !src.locked
			to_chat(user, SPAN_NOTICE("你[src.locked ? "锁定" : "解锁"]了[src]的行为控制。"))
		else
			if(open)
				to_chat(user, SPAN_WARNING("锁定前请先关上维护面板。"))
			else
				to_chat(user, SPAN_WARNING("拒绝访问。"))
		src.updateUsrDialog()
	else
		..()

/obj/structure/machinery/bot/floorbot/Topic(href, href_list)
	if(..())
		return
	usr.set_interaction(src)
	src.add_fingerprint(usr)
	switch(href_list["operation"])
		if("start")
			if (src.on)
				turn_off()
			else
				turn_on()
		if("improve")
			src.improvefloors = !src.improvefloors
			src.updateUsrDialog()
		if("tiles")
			src.eattiles = !src.eattiles
			src.updateUsrDialog()
		if("make")
			src.maketiles = !src.maketiles
			src.updateUsrDialog()
		if("bridgemode")
			switch(src.targetdirection)
				if(null)
					targetdirection = 1
				if(1)
					targetdirection = 2
				if(2)
					targetdirection = 4
				if(4)
					targetdirection = 8
				if(8)
					targetdirection = null
				else
					targetdirection = null
			src.updateUsrDialog()

/obj/structure/machinery/bot/floorbot/process()
	set background = 1

	if(!src.on)
		return
	if(src.repairing)
		return
	var/list/floorbottargets = list()
	if(src.amount <= 0 && ((src.target == null) || !src.target))
		if(src.eattiles)
			for(var/obj/item/stack/tile/plasteel/T in view(7, src))
				if(T != src.oldtarget && !(target in floorbottargets))
					src.oldtarget = T
					src.target = T
					break
		if(src.target == null || !src.target)
			if(src.maketiles)
				if(src.target == null || !src.target)
					for(var/obj/item/stack/sheet/metal/M in view(7, src))
						if(!(M in floorbottargets) && M != src.oldtarget && M.amount == 1 && !(istype(M.loc, /turf/closed)))
							src.oldtarget = M
							src.target = M
							break
		else
			return
	if(prob(5))
		visible_message("[src]兴奋地发出一串嘟嘟哔哔声！")

	if(!src.target || src.target == null)
		if(targetdirection != null)
			/*
			for (var/turf/open/space/D in view(7,src))
				if(!(D in floorbottargets) && D != src.oldtarget) // Added for bridging mode -- TLE
					if(get_dir(src, D) == targetdirection)
						src.oldtarget = D
						src.target = D
						break
			*/
			var/turf/T = get_step(src, targetdirection)
			if(istype(T, /turf/open/space))
				src.oldtarget = T
				src.target = T
		if(!src.target || src.target == null)
			for (var/turf/open/space/D in view(7,src))
				if(!(D in floorbottargets) && D != src.oldtarget && (D.loc.name != "Space"))
					src.oldtarget = D
					src.target = D
					break
		if((!src.target || src.target == null ) && src.improvefloors)
			for (var/turf/open/floor/F in view(7,src))
				if(!(F in floorbottargets) && F != src.oldtarget && F.icon_state == "Floor1" && !(istype(F, /turf/open/floor/plating)))
					src.oldtarget = F
					src.target = F
					break
		if((!src.target || src.target == null) && src.eattiles)
			for(var/obj/item/stack/tile/plasteel/T in view(7, src))
				if(!(T in floorbottargets) && T != src.oldtarget)
					src.oldtarget = T
					src.target = T
					break

	if(!src.target || src.target == null)
		if(src.loc != src.oldloc)
			src.oldtarget = null
		return

	if(src.target && (src.target != null) && length(src.path) == 0)
		spawn(0)
			if(!istype(src.target, /turf/))
				src.path = AStar(src.loc, src.target.loc, /turf/proc/AdjacentTurfsSpace, /turf/proc/Distance, 0, 30, id=botcard)
			else
				src.path = AStar(src.loc, src.target, /turf/proc/AdjacentTurfsSpace, /turf/proc/Distance, 0, 30, id=botcard)
			if (!src.path) src.path = list()
			if(length(src.path) == 0)
				src.oldtarget = src.target
				src.target = null
		return
	if(length(src.path) > 0 && src.target && (src.target != null))
		step_to(src, src.path[1])
		src.path -= src.path[1]
	else if(length(src.path) == 1)
		step_to(src, target)
		src.path = new()

	if(src.loc == src.target || src.loc == src.target.loc)
		if(istype(src.target, /obj/item/stack/tile/plasteel))
			src.eattile(src.target)
		else if(istype(src.target, /obj/item/stack/sheet/metal))
			src.maketile(src.target)
		else if(istype(src.target, /turf/))
			repair(src.target)
		src.path = new()
		return

	src.oldloc = src.loc


/obj/structure/machinery/bot/floorbot/proc/repair(turf/target)
	if(istype(target, /turf/open/space/))
		if(target.loc.name == "Space")
			return
	else if(!istype(target, /turf/open/floor))
		return
	if(src.amount <= 0)
		return
	src.anchored = TRUE
	src.icon_state = "floorbot-c"
	if(istype(target, /turf/open/space/))
		visible_message(SPAN_DANGER("[src]开始修补地板上的洞。"))
		var/obj/item/stack/tile/plasteel/T = new /obj/item/stack/tile/plasteel
		src.repairing = 1
		spawn(50)
			T.build(src.loc)
			src.repairing = 0
			src.amount--
			src.updateicon()
			src.anchored = FALSE
			src.target = null
	else
		visible_message(SPAN_DANGER("[src]开始改善地板。"))
		src.repairing = 1
		spawn(50)
			src.loc.icon_state = "floor"
			src.repairing = 0
			src.amount--
			src.updateicon()
			src.anchored = FALSE
			src.target = null

/obj/structure/machinery/bot/floorbot/proc/eattile(obj/item/stack/tile/plasteel/T)
	if(!istype(T, /obj/item/stack/tile/plasteel))
		return
	visible_message(SPAN_DANGER("[src]开始收集地砖。"))
	src.repairing = 1
	spawn(20)
		if(isnull(T))
			src.target = null
			src.repairing = 0
			return
		if(src.amount + T.get_amount() > 50)
			var/i = 50 - src.amount
			src.amount += i
			T.use(i)
		else
			src.amount += T.get_amount()
			qdel(T)
		src.updateicon()
		src.target = null
		src.repairing = 0

/obj/structure/machinery/bot/floorbot/proc/maketile(obj/item/stack/sheet/metal/M)
	if(!istype(M, /obj/item/stack/sheet/metal))
		return
	if(M.get_amount() > 1)
		return
	visible_message(SPAN_DANGER("[src]开始制作地砖。"))
	src.repairing = 1
	spawn(20)
		if(QDELETED(M))
			src.target = null
			src.repairing = 0
			return
		var/obj/item/stack/tile/plasteel/T = new /obj/item/stack/tile/plasteel
		T.amount = 4
		T.forceMove(M.loc)
		qdel(M)
		src.target = null
		src.repairing = 0

/obj/structure/machinery/bot/floorbot/proc/updateicon()
	if(src.amount > 0)
		src.icon_state = "floorbot[src.on]"
	else
		src.icon_state = "floorbot[src.on]e"

/obj/structure/machinery/bot/floorbot/explode()
	src.on = 0
	src.visible_message(SPAN_DANGER("<B>[src]炸得四分五裂！</B>"), null, null, 1)
	var/turf/Tsec = get_turf(src)

	var/obj/item/storage/toolbox/mechanical/N = new /obj/item/storage/toolbox/mechanical(Tsec)
	N.contents = list()

	new /obj/item/device/assembly/prox_sensor(Tsec)

	if (prob(50))
		new /obj/item/robot_parts/arm/l_arm(Tsec)

	while (amount)//Dumps the tiles into the appropriate sized stacks
		if(amount >= 16)
			var/obj/item/stack/tile/plasteel/T = new (Tsec)
			T.amount = 16
			amount -= 16
		else
			var/obj/item/stack/tile/plasteel/T = new (Tsec)
			T.amount = src.amount
			amount = 0

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return


/obj/item/storage/toolbox/mechanical/attackby(obj/item/stack/tile/plasteel/T, mob/user as mob)
	if(!istype(T, /obj/item/stack/tile/plasteel))
		..()
		return
	if(length(src.contents) >= 1)
		to_chat(user, SPAN_NOTICE("放不进去，里面已经有东西了。"))
		return
	for(var/mob/M in content_watchers)
		storage_close(M)
	if (T.use(10))
		var/obj/item/frame/toolbox_tiles/B = new /obj/item/frame/toolbox_tiles
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("你将地砖放入空工具箱，它们从箱顶伸了出来。"))
		user.temp_drop_inv_item(src)
		qdel(src)
	else
		to_chat(user, SPAN_WARNING("制作地板维修机器人需要10块地砖。"))
	return
