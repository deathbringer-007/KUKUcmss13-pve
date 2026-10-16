/obj/structure/machinery/fuelcell_recycler
	name = "\improper 燃料电池再生机"
	desc = "大型机器，风扇嗡嗡作响，顶部有两个圆柱形插孔，用于再生燃料电池。"
	icon = 'icons/obj/structures/machinery/fusion_eng.dmi'
	icon_state = "recycler"
	active_power_usage = 15000
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

	///How much to recharge the cells per process
	var/recharge_amount = 5
	///A fuel cell in the recycler
	var/obj/item/fuel_cell/cell_left
	///A fuel cell in the recycler
	var/obj/item/fuel_cell/cell_right

/obj/structure/machinery/fuelcell_recycler/Destroy()
	. = ..()
	QDEL_NULL(cell_left)
	QDEL_NULL(cell_right)

/obj/structure/machinery/fuelcell_recycler/ex_act(severity)
	if(indestructible)
		return
	. = ..()

/obj/structure/machinery/fuelcell_recycler/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("设备目前[machine_processing ? "运行中" : "已停机"]。")
	if(!ishuman(user))
		return

	if(cell_left)
		. += SPAN_INFO("左侧燃料电池剩余量为[cell_left.get_fuel_percent()]%。")
	if(cell_right)
		. += SPAN_INFO("右侧燃料电池剩余量为[cell_right.get_fuel_percent()]%。")

/obj/structure/machinery/fuelcell_recycler/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/fuel_cell))
		to_chat(user, SPAN_NOTICE("[src]拒收[attacking_item]。它只能再生燃料电池。"))
		return
	var/obj/item/fuel_cell/cell = attacking_item

	if(cell_left && cell_right)
		to_chat(user, SPAN_NOTICE("[src]无法再生更多燃料电池。请先取出[cell_left]或[cell_right]。"))
		return

	if(cell.get_fuel_percent() == 100)
		to_chat(user, SPAN_NOTICE("[cell]已充满，无须再生。"))
		return

	if(!user.drop_inv_item_to_loc(cell, src))
		to_chat(user, SPAN_WARNING("你没能将[cell]装入[src]。"))
		return

	add_fingerprint(user)
	var/inserted_to_left = TRUE
	if(!cell_left)
		cell_left = cell
	else if(!cell_right)
		inserted_to_left = FALSE
		cell_right = cell

	to_chat(user, SPAN_NOTICE("你将[cell]装入了[inserted_to_left ? "左" : "右"]侧燃料电池插槽。"))
	update_icon()
	if(!machine_processing)
		visible_message(SPAN_NOTICE("[src]启动了，开始发出嗡鸣。"))
		update_use_power(USE_POWER_ACTIVE)
		start_processing()

/obj/structure/machinery/fuelcell_recycler/attack_hand(mob/user)
	if(!cell_left && !cell_right)
		to_chat(user, SPAN_NOTICE("[src]是空的。"))
		return

	add_fingerprint(user)
	cell_left?.update_icon()
	cell_right?.update_icon()

	if(cell_left && cell_right)
		if(cell_left.get_fuel_percent() >= cell_right.get_fuel_percent())
			user.put_in_hands(cell_left)
			cell_left = null
		else
			user.put_in_hands(cell_right)
			cell_right = null
		update_icon()
		return

	if(cell_left)
		user.put_in_hands(cell_left)
		cell_left = null
		update_icon()
		return

	if(cell_right)
		user.put_in_hands(cell_right)
		cell_right = null
		update_icon()

/obj/structure/machinery/fuelcell_recycler/process()
	if(inoperable())
		turn_off()
		return

	if(!cell_left && !cell_right)
		balloon_alert_to_viewers("未检测到燃料电池。")
		turn_off()
		return

	if((!cell_right && cell_left?.is_regenerated()) || (!cell_left && cell_right?.is_regenerated()) || (cell_left?.is_regenerated() && cell_right?.is_regenerated()))
		balloon_alert_to_viewers("所有燃料电池均已充满。")
		turn_off()
		return

	if(cell_left && !cell_left.is_regenerated())
		recharge_cell(cell_left)

	if(cell_right && !cell_right.is_regenerated())
		recharge_cell(cell_right)

	update_icon()

/obj/structure/machinery/fuelcell_recycler/update_icon()
	overlays.Cut()

	if(cell_left)
		overlays += "overlay_left_cell"
	if(cell_right)
		overlays += "overlay_right_cell"

	if(inoperable())
		icon_state = "recycler"
		return

	if(cell_left)
		if(cell_left.is_regenerated())
			overlays += "overlay_left_charged"
		else
			overlays += "overlay_left_charging"

	if(cell_right)
		if(cell_right.is_regenerated())
			overlays += "overlay_right_charged"
		else
			overlays += "overlay_right_charging"

	if(!machine_processing)
		icon_state = "recycler"
		return
	icon_state = "recycler_on"

/obj/structure/machinery/fuelcell_recycler/proc/turn_off()
	visible_message(SPAN_NOTICE("[src]停机了，嗡鸣随之停止。"))
	stop_processing()
	update_icon()
	update_use_power(USE_POWER_NONE)

/obj/structure/machinery/fuelcell_recycler/proc/recharge_cell(obj/item/fuel_cell/cell)
	cell.modify_fuel(recharge_amount)
	if(!cell.new_cell)
		cell.new_cell = TRUE

/obj/structure/machinery/fuelcell_recycler/full/Initialize(mapload, ...)
	. = ..()
	cell_left = new(src)
	cell_right = new(src)
	update_icon()

//reactor full cells
/obj/item/fuel_cell
	name = "\improper WL-6通用燃料电池"
	icon = 'icons/obj/structures/machinery/shuttle-parts.dmi'
	icon_state = "cell-full"
	desc = "可再充能的燃料电池，用于为夏延级运输机或韦斯廷兰S-52反应堆供能。"
	///How much fuel is in the reactor
	var/fuel_amount = 100
	///Max amount that the cell can hold
	var/max_fuel_amount = 100
	///If the fuel cell has been used since last recharge
	var/new_cell = TRUE

/obj/item/fuel_cell/update_icon()
	switch(get_fuel_percent())
		if(-INFINITY to 0)
			icon_state = "cell-empty"
		if(0 to 25)
			icon_state = "cell-low"
		if(25 to 75)
			icon_state = "cell-medium"
		if(75 to 99)
			icon_state = "cell-high"
		if(100 to INFINITY)
			icon_state = "cell-full"

/obj/item/fuel_cell/get_examine_text(mob/user)
	.  = ..()
	if(ishuman(user))
		. += "燃料表显示：[get_fuel_percent()]%"

///Percentage of fuel left in the cell
/obj/item/fuel_cell/proc/get_fuel_percent()
	return floor(100 * fuel_amount/max_fuel_amount)

///Whether the fuel cell is full
/obj/item/fuel_cell/proc/is_regenerated()
	return (fuel_amount == max_fuel_amount)

/// increase or decrease fuel, making sure it cannot go above the max
/obj/item/fuel_cell/proc/modify_fuel(amount)
	fuel_amount = clamp(fuel_amount + amount, 0, max_fuel_amount)

/obj/item/fuel_cell/used
	new_cell = FALSE
