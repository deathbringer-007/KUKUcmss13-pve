/obj/item/device/pinpointer
	name = "定向定位器"
	icon_state = "pinoff"
	flags_atom = FPRINT | CONDUCT
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_TINY
	item_state = "electronic"
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	matter = list("metal" = 500)
	var/obj/item/disk/nuclear/the_disk = null
	var/active = 0


/obj/item/device/pinpointer/attack_self()
	..()

	if(!active)
		active = 1
		workdisk()
		to_chat(usr, SPAN_NOTICE("你启动了定向定位器。"))
	else
		active = 0
		icon_state = "pinoff"
		to_chat(usr, SPAN_NOTICE("你关闭了定向定位器。"))

/obj/item/device/pinpointer/proc/workdisk()
	if(!active) return
	if(!the_disk)
		the_disk = locate()
		if(!the_disk)
			icon_state = "pinonnull"
			return
	setDir(Get_Compass_Dir(src,the_disk))
	switch(get_dist(src,the_disk))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
	spawn(5) .()

/obj/item/device/pinpointer/get_examine_text(mob/user)
	. = ..()
	for(var/obj/structure/machinery/nuclearbomb/bomb in GLOB.machines)
		if(bomb.timing)
			. += "极度危险。检测到武装信号。剩余时间：[bomb.timeleft]"


/obj/item/device/pinpointer/advpinpointer
	name = "高级定向定位器"
	desc = "普通定向定位器的加大型号，配备实用的量子纠缠探测系统，能够定位各种不发送定位信号的物体。"
	var/mode = 0  // Mode 0 locates disk, mode 1 locates coordinates.
	var/turf/location = null
	var/obj/target = null

/obj/item/device/pinpointer/advpinpointer/attack_self()
	..()
	if(!active)
		active = 1
		if(mode == 0)
			workdisk()
		if(mode == 1)
			worklocation()
		if(mode == 2)
			workobj()
		to_chat(usr, SPAN_NOTICE("你启动了定向定位器。"))
	else
		active = 0
		icon_state = "pinoff"
		to_chat(usr, SPAN_NOTICE("你关闭了定向定位器。"))


/obj/item/device/pinpointer/advpinpointer/proc/worklocation()
	if(!active)
		return
	if(!location)
		icon_state = "pinonnull"
		return
	setDir(Get_Compass_Dir(src,location))
	switch(get_dist(src,location))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
	spawn(5) .()


/obj/item/device/pinpointer/advpinpointer/proc/workobj()
	if(!active)
		return
	if(!target)
		icon_state = "pinonnull"
		return
	setDir(Get_Compass_Dir(src,target))
	switch(get_dist(src,target))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
	spawn(5) .()

/obj/item/device/pinpointer/advpinpointer/verb/toggle_mode()
	set category = "物品"
	set name = "切换定向定位器模式"
	set src in view(1)

	active = 0
	icon_state = "pinoff"
	target=null
	location = null

	switch(alert("请选择定向定位器的工作模式。", "选择定向定位器模式", "坐标定位", "寻找磁盘", "其他特征信号"))
		if("坐标定位")
			mode = 1

			var/locationx = tgui_input_real_number(usr, "请输入目标位置的 X 坐标。", "目标位置")
			if(!locationx || !(usr in dview(1, src)))
				return
			var/locationy = tgui_input_real_number(usr, "请输入目标位置的 Y 坐标。", "目标位置")
			if(!locationy || !(usr in dview(1, src)))
				return

			var/turf/Z = get_turf(src)

			location = locate(locationx,locationy,Z.z)

			to_chat(usr, "你将定向定位器的目标坐标设为 [locationx]，[locationy]。")


			return attack_self()

		if("寻找磁盘")
			mode = 0
			return attack_self()
