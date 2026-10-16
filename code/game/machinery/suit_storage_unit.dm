//////////////////////////////////////
// inserted_suit STORAGE UNIT /////////////////
//////////////////////////////////////


/obj/structure/machinery/suit_storage_unit
	name = "太空服储存柜"
	desc = "工业级U-Stor-It随存储物柜，能容纳各种太空服。内置设备还能通过紫外线消毒循环为柜内物品去污。控制面板上垂着一张警告标签，写着：\"严禁将生物置于柜内\"。"
	icon = 'icons/obj/structures/machinery/suitstorage.dmi'
	icon_state = "closed" //order is: [has helmet][has suit][has human][is open][is locked][is UV cycling][is powered][is dirty/broken] [is superUVcycling]
	anchored = TRUE
	density = TRUE
	var/obj/item/clothing/suit/space/inserted_suit
	var/obj/item/clothing/head/helmet/space/inserted_helmet
	var/obj/item/clothing/mask/inserted_mask
	var/obj/item/tank/inserted_tank
	var/starting_suit_type
	var/starting_helmet_type
	var/starting_mask_type
	var/starting_tank_type
	var/isopen = FALSE
	var/isUV = FALSE

/obj/structure/machinery/suit_storage_unit/Initialize()
	. = ..()
	if(starting_suit_type)
		inserted_suit = new starting_suit_type(src)
	if(starting_helmet_type)
		inserted_helmet = new starting_helmet_type(src)
	if(starting_mask_type)
		inserted_mask = new starting_mask_type(src)
	if(starting_tank_type)
		inserted_tank = new starting_tank_type(src)
	update_icon()

/obj/structure/machinery/suit_storage_unit/Destroy()
	QDEL_NULL(inserted_suit)
	QDEL_NULL(inserted_helmet)
	QDEL_NULL(inserted_mask)
	QDEL_NULL(inserted_tank)
	. = ..()


/obj/structure/machinery/suit_storage_unit/update_icon()
	overlays.Cut()
	if(isUV)
		icon_state = "disinfecting"
		return
	else if(isopen)
		if(inserted_helmet)
			overlays += image("helmet")

		if(inserted_suit)
			overlays += image("suit")
		if(inserted_mask)
			overlays += image("mask")
		if(inserted_tank)
			overlays += image("tank")

		icon_state = "open"

	else
		icon_state = "closed"
	if(stat & NOPOWER)
		icon_state += "_off"


/obj/structure/machinery/suit_storage_unit/power_change()
	..()
	if(stat & NOPOWER)
		dump_everything()
		if(isUV)
			isUV = FALSE
			update_icon()

/obj/structure/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				dump_everything()
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if(prob(50))
				dump_everything() //So suits dont survive all the time
			deconstruct(FALSE)


/obj/structure/machinery/suit_storage_unit/attack_hand(mob/user)
	var/dat
	if(..())
		return
	if(stat & NOPOWER)
		dat+= "<HR><BR><A href='byond://?src=\ref[user];mach_close=suit_storage_unit'>关闭面板</A>"
		return
	if(isUV) //The thing is running its cauterisation cycle. You have to wait.
		dat += SET_CLASS("<B>正在用紫外线为柜内物品消毒，请稍候。</B>", INTERFACE_RED)
		dat += "<BR>"

	else
		dat+= SET_CLASS("<font size = 4><B>U-Stor-It随存太空服储存柜，DS1900型</B></FONT>", INTERFACE_BLUE)
		dat += "<BR>"
		dat+= "<B>欢迎使用储存柜控制面板。</B><HR>"

		dat += "<font color='black'>头盔储物舱： <B>[inserted_helmet ? inserted_helmet.name : "</font><font color ='grey'>未检测到头盔。"]</B></font><BR>"
		if(inserted_helmet && isopen)
			dat += "<A href='byond://?src=\ref[src];dispense_helmet=1'>取出头盔</A><BR>"

		dat += "<font color='black'>太空服储物舱： <B>[inserted_suit ? inserted_suit.name : "</font><font color ='grey'>未检测到太空服。"]</B></font><BR>"
		if(inserted_suit && isopen)
			dat += "<A href='byond://?src=\ref[src];dispense_suit=1'>取出太空服</A><BR>"

		dat += "<font color='black'>呼吸面罩储物舱： <B>[inserted_mask ? inserted_mask.name : "</font><font color ='grey'>未检测到呼吸面罩。"]</B></font><BR>"
		if(inserted_mask  && isopen)
			dat += "<A href='byond://?src=\ref[src];dispense_mask=1'>取出面罩</A><BR>"

		dat += "<font color='black'>气瓶储物舱： <B>[inserted_tank ? inserted_tank.name : "</font><font color ='grey'>未检测到气瓶。"]</B></font><BR>"
		if(inserted_tank  && isopen)
			dat += "<A href='byond://?src=\ref[src];dispense_tank=1'>取出气瓶</A><BR>"

		dat+= "<HR><font color='black'>储存柜状态：[isopen ? "已打开" : "已关闭"] - <A href='byond://?src=\ref[src];toggle_open=1'>[isopen ? "关闭" : "打开"]储存柜</A></font><BR>"

		dat += "<A href='byond://?src=\ref[src];start_UV=1'>启动消毒循环</A><BR>"
		dat += "<BR><BR><A href='byond://?src=\ref[user];mach_close=suit_storage_unit'>关闭控制面板</A>"

	show_browser(user, dat, "太空服储存柜", "suit_storage_unit", width = 400, height = 500)
	return


/obj/structure/machinery/suit_storage_unit/Topic(href, href_list) //I fucking HATE this proc
	if(..())
		return
	if (Adjacent(usr))
		usr.set_interaction(src)
		if (href_list["dispense_helmet"])
			dispense_helmet()
			updateUsrDialog()
			update_icon()
		if (href_list["dispense_suit"])
			dispense_suit()
			updateUsrDialog()
			update_icon()
		if (href_list["dispense_mask"])
			dispense_mask()
			updateUsrDialog()
			update_icon()
		if (href_list["dispense_tank"])
			dispense_tank()
			updateUsrDialog()
			update_icon()
		if (href_list["toggle_open"])
			toggle_open()
			updateUsrDialog()
			update_icon()
		if (href_list["start_UV"])
			start_UV(usr)
			updateUsrDialog()
			update_icon()

	add_fingerprint(usr)




/obj/structure/machinery/suit_storage_unit/proc/dispense_helmet()
	if(inserted_helmet)
		inserted_helmet.forceMove(loc)
		inserted_helmet = null



/obj/structure/machinery/suit_storage_unit/proc/dispense_suit()
	if(inserted_suit)
		inserted_suit.forceMove(loc)
		inserted_suit = null



/obj/structure/machinery/suit_storage_unit/proc/dispense_mask()
	if(inserted_mask)
		inserted_mask.forceMove(loc)
		inserted_mask = null


/obj/structure/machinery/suit_storage_unit/proc/dispense_tank()
	if(inserted_tank)
		inserted_tank.forceMove(loc)
		inserted_tank = null


/obj/structure/machinery/suit_storage_unit/proc/dump_everything()
	dispense_helmet()
	dispense_suit()
	dispense_mask()
	dispense_tank()


/obj/structure/machinery/suit_storage_unit/proc/toggle_open(mob/user as mob)
	if(isUV)
		to_chat(user, "<font color='red'>无法打开储存柜。</font>")
		return
	isopen = !isopen
	update_icon()


/obj/structure/machinery/suit_storage_unit/proc/start_UV(mob/user)
	set waitfor = 0

	if(isopen)
		to_chat(user, "<font color='red'>储存柜尚未关闭，操作已中止。</font>")
		return

	if(isUV)
		return

	if(!inserted_helmet && !inserted_mask && !inserted_suit) //shit's empty yo
		to_chat(user, "<font color='red'>储存柜内没有物品，无需消毒，操作已中止。</font>")
		return
	to_chat(user, SPAN_NOTICE("你启动了储存柜的紫外线消毒循环。"))
	isUV = 1
	update_icon()
	updateUsrDialog()

	sleep(150)

	if(QDELETED(src))
		return
	if(inserted_helmet)
		inserted_helmet.clean_blood()
	if(inserted_suit)
		inserted_suit.clean_blood()
	if(inserted_mask)
		inserted_mask.clean_blood()
	if(inserted_tank)
		inserted_tank.clean_blood()
	isUV = 0 //Cycle ends
	update_icon()
	updateUsrDialog()




/obj/structure/machinery/suit_storage_unit/attackby(obj/item/I, mob/living/user)

	if(!(stat & NOPOWER))

		if(isopen)

			if( istype(I,/obj/item/clothing/suit/space) )
				var/obj/item/clothing/suit/space/S = I
				if(inserted_suit)
					to_chat(user, SPAN_WARNING("储存柜里已经有一件太空服了。"))
					return
				if(user.drop_inv_item_to_loc(S, src))
					to_chat(user, SPAN_NOTICE("你将[S.name]放入储物舱。"))
					inserted_suit = S
					update_icon()
					updateUsrDialog()
				return

			if( istype(I,/obj/item/clothing/head/helmet) )
				var/obj/item/clothing/head/helmet/H = I
				if(inserted_helmet)
					to_chat(user, SPAN_WARNING("储存柜里已经有一顶头盔了。"))
					return
				to_chat(user, SPAN_NOTICE("你将[H.name]放入储物舱。"))
				if(user.drop_inv_item_to_loc(H, src))
					inserted_helmet = H
					update_icon()
					updateUsrDialog()
				return

			if( istype(I,/obj/item/clothing/mask) )
				var/obj/item/clothing/mask/M = I
				if(inserted_mask)
					to_chat(user, SPAN_WARNING("储存柜里已经有一个面罩了。"))
					return
				to_chat(user, SPAN_NOTICE("你将[M.name]放入储物舱。"))
				if(user.drop_inv_item_to_loc(M, src))
					inserted_mask = M
					update_icon()
					updateUsrDialog()
				return

			if( istype(I,/obj/item/tank) )
				var/obj/item/tank/T = I
				if(inserted_tank)
					to_chat(user, SPAN_WARNING("储存柜里已经有一个气瓶了。"))
					return
				to_chat(user, SPAN_NOTICE("你将[T.name]放入储物舱。"))
				if(user.drop_inv_item_to_loc(T, src))
					inserted_tank = T
					update_icon()
					updateUsrDialog()
				return



/obj/structure/machinery/suit_storage_unit/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/suit_storage_unit/carbon_unit
	starting_suit_type = /obj/item/clothing/suit/space/odyssey
	starting_helmet_type = /obj/item/clothing/head/helmet/space/odyssey
	starting_mask_type = /obj/item/clothing/mask/breath
	starting_tank_type = /obj/item/tank/oxygen

/obj/structure/machinery/suit_storage_unit/standard_unit
	starting_suit_type = /obj/item/clothing/suit/space
	starting_helmet_type = /obj/item/clothing/head/helmet/space
	starting_mask_type = /obj/item/clothing/mask/breath
	starting_tank_type = /obj/item/tank/oxygen

/obj/structure/machinery/suit_storage_unit/pressure_suit
	starting_suit_type = /obj/item/clothing/suit/space/pressure
	starting_helmet_type = /obj/item/clothing/head/helmet/space/pressure
	starting_mask_type = /obj/item/clothing/mask/breath
	starting_tank_type = /obj/item/tank/oxygen

/obj/structure/machinery/suit_storage_unit/pressure_suit/uscm
	starting_suit_type = /obj/item/clothing/suit/space/pressure/uscm
	starting_helmet_type = /obj/item/clothing/head/helmet/space/pressure/uscm
	starting_mask_type = /obj/item/clothing/mask/breath
	starting_tank_type = /obj/item/tank/oxygen/yellow

/obj/structure/machinery/suit_storage_unit/pressure_suit/upp
	starting_suit_type = /obj/item/clothing/suit/space/pressure/upp
	starting_helmet_type = /obj/item/clothing/head/helmet/space/pressure/upp
	starting_mask_type = /obj/item/clothing/mask/breath
	starting_tank_type = /obj/item/tank/oxygen/yellow
