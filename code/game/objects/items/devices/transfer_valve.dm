/obj/item/device/transfer_valve
	icon = 'icons/obj/items/assemblies.dmi'
	name = "气罐连接阀"
	icon_state = "valve_1"
	desc = "用于调节两个气罐之间的气体流动。"
	var/obj/item/tank/tank_one
	var/obj/item/tank/tank_two
	var/obj/item/device/attached_device
	var/mob/attacher = null
	var/valve_open = 0
	var/toggle = 1

/obj/item/device/transfer_valve/IsAssemblyHolder()
	return TRUE

/obj/item/device/transfer_valve/attack_self(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("你茫然地看着[src]。"))

/obj/item/device/transfer_valve/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/tank))
		if(tank_one && tank_two)
			to_chat(user, SPAN_WARNING("已经连接了两个气罐，请先拆下一个。"))
			return

		if(!tank_one)
			if(user.drop_held_item())
				tank_one = item
				item.forceMove(src)
				to_chat(user, SPAN_NOTICE("你将气罐接到连接阀上。"))
		else if(!tank_two)
			if(user.drop_held_item())
				tank_two = item
				item.forceMove(src)
				to_chat(user, SPAN_NOTICE("你将气罐接到连接阀上。"))

		update_icon()

	else if(isassembly(item))
		var/obj/item/device/assembly/A = item
		if(A.secured)
			to_chat(user, SPAN_NOTICE("该装置已锁定。"))
			return
		if(attached_device)
			to_chat(user, SPAN_WARNING("阀门上已经装有一个装置，请先将其拆下。"))
			return
		user.temp_drop_inv_item(A)
		attached_device = A
		A.forceMove(src)
		to_chat(user, SPAN_NOTICE("你将[item]接到阀门控制机构上，并将其固定。"))
		A.holder = src
		A.toggle_secure() //this calls update_icon(), which calls update_icon() on the holder (i.e. the bomb).

		attacher = user

/obj/item/device/transfer_valve/HasProximity(atom/movable/AM)
	if(!attached_device)
		return
	attached_device.HasProximity(AM)

/obj/item/device/transfer_valve/update_icon()
	overlays.Cut()
	underlays = null

	if(!tank_one && !tank_two && !attached_device)
		icon_state = "valve_1"
		return
	icon_state = "valve"

	if(tank_one)
		overlays += "[tank_one.icon_state]"
	if(tank_two)
		var/icon/J = new(icon, icon_state = "[tank_two.icon_state]")
		J.Shift(WEST, 13)
		underlays += J
	if(attached_device)
		overlays += "device"

// this doesn't do anything but the timer etc. expects it to be here
// eventually maybe have it update icon to show state (timer, prox etc.) like old bombs
/obj/item/device/transfer_valve/proc/c_state()
	return
