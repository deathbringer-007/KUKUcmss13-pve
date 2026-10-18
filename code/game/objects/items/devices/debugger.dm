/obj/item/device/debugger
	name = "电子故障诊断器"
	desc = "用于排查电子设备的故障。"
	icon_state = "hacktool-g"
	flags_atom = FPRINT|CONDUCT
	force = 5
	w_class = SIZE_SMALL
	throwforce = 5
	throw_range = 15
	throw_speed = SPEED_VERY_FAST
	desc = "可以用它尝试入侵气闸门或区域电力控制器，无需剪断电线。"

	matter = list("metal" = 50,"glass" = 20)


	var/obj/structure/machinery/telecomms/buffer // simple machine buffer for device linkage

/obj/item/device/debugger/is_used_on(obj/O, mob/user)
	if(istype(O, /obj/structure/machinery/power/apc))
		to_chat(user, SPAN_NOTICE(" 设备的软件似乎没有问题。"))
		return 1
	if(istype(O, /obj/structure/machinery/door))
		var/obj/structure/machinery/door/D = O
		if(D.operating == -1)
			to_chat(user, SPAN_DANGER("设备存在软件错误。"))
		else
			to_chat(user, SPAN_NOTICE(" 设备的软件似乎没有问题。"))
		return 1
	else if(istype(O, /obj/structure/machinery))
		to_chat(user, SPAN_NOTICE(" 设备的软件似乎没有问题。"))
		return 1
