//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/recharger
	name = "\improper 充电器"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "recharger"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 4
	active_power_usage = 15000 //15 kW
	black_market_value = 35
	var/obj/item/charging = null
	var/percent_charge_complete = 0
	var/list/allowed_devices = list(/obj/item/weapon/baton, /obj/item/cell, /obj/item/weapon/gun/energy, /obj/item/device/defibrillator, /obj/item/tool/portadialysis, /obj/item/clothing/suit/auto_cpr, /obj/item/smartgun_battery, /obj/item/device/helmet_visor/night_vision)

	var/charge_amount = 1000

/obj/structure/machinery/recharger/attackby(obj/item/G as obj, mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	var/allowed = 0
	for (var/allowed_type in allowed_devices)
		if (istype(G, allowed_type)) allowed = 1

	if(allowed)
		if(charging)
			to_chat(user, SPAN_DANGER("这里已经有[charging]在充电了。"))
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		var/area/a = get_area(src)
		if(!isarea(a) || (a.power_equip == 0 && !a.unlimited_power))
			to_chat(user, SPAN_DANGER("你试图放入物品时，[name]闪烁红光！"))
			return
		if(istype(G, /obj/item/device/defibrillator))
			var/obj/item/device/defibrillator/D = G
			if(D.ready)
				to_chat(user, SPAN_WARNING("放不进去，先将电极板放回[D]！"))
				return
		if(istype(G, /obj/item/tool/portadialysis))
			var/obj/item/tool/portadialysis/P = G
			if(P.attached)
				to_chat(user, SPAN_WARNING("放不进去，先将它从[P.attached]上拆下来！"))
				return
		if(user.drop_inv_item_to_loc(G, src))
			charging = G
			start_processing()
			update_icon()
	else if(HAS_TRAIT(G, TRAIT_TOOL_WRENCH))
		if(charging)
			to_chat(user, SPAN_DANGER("先取出[charging]！"))
			return
		anchored = !anchored
		to_chat(user, "你[anchored ? "固定" : "松开"]了充电器。")
		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)

/obj/structure/machinery/recharger/attack_hand(mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		stop_processing()
		percent_charge_complete = 0
		update_icon()

/obj/structure/machinery/recharger/process()
	if(inoperable() || !anchored)
		update_use_power(USE_POWER_NONE)
		update_icon()
		return
	if(!charging)
		update_use_power(USE_POWER_IDLE)
		percent_charge_complete = 0
		update_icon()
	//This is an awful check. Holy cow.
	else
		if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			if(!E.works_in_recharger)
				return;
			if(!E.cell.fully_charged())
				E.cell.give(charge_amount)
				percent_charge_complete = E.cell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		if(istype(charging, /obj/item/weapon/baton))
			var/obj/item/weapon/baton/B = charging
			if(B.bcell)
				if(!B.bcell.fully_charged())
					B.bcell.give(charge_amount)
					percent_charge_complete = B.bcell.percent()
					update_use_power(USE_POWER_ACTIVE)
					update_icon()
				else
					percent_charge_complete = 100
					update_use_power(USE_POWER_IDLE)
					update_icon()
			else
				percent_charge_complete = 0
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		if(istype(charging, /obj/item/device/defibrillator))
			var/obj/item/device/defibrillator/D = charging
			if(!D.dcell.fully_charged())
				D.dcell.give(active_power_usage*CELLRATE)
				percent_charge_complete = D.dcell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return



		if(istype(charging, /obj/item/clothing/suit/auto_cpr))
			var/obj/item/clothing/suit/auto_cpr/A = charging
			if(!A.pdcell.fully_charged())
				A.pdcell.give(active_power_usage*CELLRATE)
				percent_charge_complete = A.pdcell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		if(istype(charging, /obj/item/tool/portadialysis))
			var/obj/item/tool/portadialysis/P = charging
			if(!P.pdcell.fully_charged())
				P.pdcell.give(active_power_usage*CELLRATE)
				percent_charge_complete = P.pdcell.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		if(istype(charging, /obj/item/cell))
			var/obj/item/cell/C = charging
			if(!C.fully_charged())
				C.give(active_power_usage*CELLRATE)
				percent_charge_complete = C.percent()
				update_use_power(USE_POWER_ACTIVE)
				update_icon()
			else
				percent_charge_complete = 100
				update_use_power(USE_POWER_IDLE)
				update_icon()
			return

		if(istype(charging, /obj/item/smartgun_battery))
			var/obj/item/smartgun_battery/charging_smartgun_battery = charging
			if(charging_smartgun_battery.power_cell)
				if(!charging_smartgun_battery.power_cell.fully_charged())
					charging_smartgun_battery.power_cell.give(charge_amount)
					percent_charge_complete = charging_smartgun_battery.power_cell.percent()
					update_use_power(USE_POWER_ACTIVE)
					update_icon()
					return

			percent_charge_complete = 100
			update_use_power(USE_POWER_IDLE)
			update_icon()
			return

		if(istype(charging, /obj/item/device/helmet_visor/night_vision))
			var/obj/item/device/helmet_visor/night_vision/charging_night_vision_visor = charging
			if(charging_night_vision_visor.power_cell)
				if(!charging_night_vision_visor.power_cell.fully_charged())
					charging_night_vision_visor.power_cell.give(charge_amount)
					percent_charge_complete = charging_night_vision_visor.power_cell.percent()
					update_use_power(USE_POWER_ACTIVE)
					update_icon()
					return

			percent_charge_complete = 100
			update_use_power(USE_POWER_IDLE)
			update_icon()
			return

		/* Disable defib recharging
		if(istype(charging, /obj/item/device/defibrillator))
			var/obj/item/device/defibrillator/D = charging
			if(D.dcell)
				if(!D.dcell.fully_charged())
					icon_state = icon_state_charging
					D.dcell.give(active_power_usage*CELLRATE)
					update_use_power(USE_POWER_ACTIVE)
				else
					icon_state = icon_state_charged
					update_use_power(USE_POWER_IDLE)
			else
				icon_state = icon_state_idle
				update_use_power(USE_POWER_IDLE)
			return
		*/

/obj/structure/machinery/recharger/emp_act(severity)
	. = ..()
	if(inoperable() || !anchored)
		return

	if(istype(charging, /obj/item/weapon/baton))
		var/obj/item/weapon/baton/B = charging
		if(B.bcell)
			B.bcell.charge = 0

/obj/structure/machinery/recharger/update_icon() //we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	src.overlays = 0
	if((inoperable()))
		return
	else if(!charging)
		overlays += "recharger-power"
		return

	if(percent_charge_complete < 25)
		overlays += "recharger-10"
	else if(percent_charge_complete >= 25 && percent_charge_complete < 50)
		overlays += "recharger-25"
	else if(percent_charge_complete >= 50 && percent_charge_complete < 75)
		overlays += "recharger-50"
	else if(percent_charge_complete >= 75 && percent_charge_complete < 100)
		overlays += "recharger-75"
	else if(percent_charge_complete >= 100)
		overlays += "recharger-100"

	if(istype(charging, /obj/item/weapon/gun/energy))
		overlays += "recharger-taser"//todo make more generic I guess. It works for now -trii
	else if(istype(charging, /obj/item/weapon/baton))
		overlays += "recharger-baton"

/obj/structure/machinery/recharger/get_examine_text(mob/user)
	. = ..()
	. += "充电器内[charging ? "装着[charging]" : "空无一物"]。"
	if(charging)
		if(istype(charging, /obj/item/cell))
			var/obj/item/cell/C = charging
			. += "当前电量：[C.charge]（[C.percent()]%）"

/obj/structure/machinery/recharger/unanchored
	anchored = FALSE

/*
/obj/structure/machinery/recharger/wallcharger
	name = "wall recharger"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "wrecharger0"
	active_power_usage = 25000 //25 kW , It's more specialized than the standalone recharger (guns and batons only) so make it more powerful
	allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/baton)
	icon_state_charged = "wrecharger2"
	icon_state_idle = "wrecharger0"
	icon_state_charging = "wrecharger1"
*/
