/obj/item/storage/toolkit
	name = "工兵工具包"
	desc = "用于携带电气和机械物资进入战场的战斗工程工具包。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "toolkit"
	item_state = "fulton"
	throw_speed = SPEED_FAST
	throw_range = 8
	use_sound = "toolbox"
	matter = list("plastic" = 2000)
	can_hold = list(
		/obj/item/circuitboard,
		/obj/item/device/flashlight,
		/obj/item/clothing/glasses/welding,
		/obj/item/device/analyzer,
		/obj/item/device/demo_scanner,
		/obj/item/device/reagent_scanner,
		/obj/item/device/t_scanner,
		/obj/item/stack/cable_coil,
		/obj/item/cell,
		/obj/item/device/assembly,
		/obj/item/stock_parts,
		/obj/item/explosive/plastic,
	)
	storage_flags = STORAGE_FLAGS_BOX

	///icon state to use when kit is full
	var/icon_full

/obj/item/storage/toolkit/Initialize()
	. = ..()

	icon_full = initial(icon_state)

	update_icon()

/obj/item/storage/toolkit/update_icon()
	if(content_watchers || !length(contents))
		icon_state = "toolkit_empty"
	else
		icon_state = icon_full

/obj/item/storage/toolkit/full/fill_preset_inventory()
	new /obj/item/stack/cable_coil/random(src)
	new /obj/item/circuitboard/apc(src)
	new /obj/item/circuitboard/apc(src)
	new /obj/item/circuitboard/apc(src)
	new /obj/item/cell/high(src)
	new /obj/item/cell/high(src)
	new /obj/item/explosive/plastic(src)


/obj/item/storage/toolkit/empty/fill_preset_inventory()
	return
