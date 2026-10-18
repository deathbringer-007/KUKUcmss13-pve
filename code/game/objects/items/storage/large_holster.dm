

/obj/item/storage/large_holster
	name = "步枪枪套"
	desc = "枪套。"
	icon = 'icons/obj/items/storage/holsters.dmi'
	icon_state = "m37_holster"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	max_w_class = SIZE_LARGE
	storage_slots = 1
	max_storage_space = 4
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_USING_DRAWING_METHOD|STORAGE_ALLOW_QUICKDRAW
	///Icon/item states change based on contents; this stores base icon state.
	var/base_icon
	var/drawSound = 'sound/weapons/gun_rifle_draw.ogg'


/obj/item/storage/large_holster/post_skin_selection()
	base_icon = icon_state

/obj/item/storage/large_holster/update_icon()
	if(length(contents))
		icon_state = "[base_icon]_full"
	else
		icon_state = base_icon

	item_state = icon_state

	var/mob/living/carbon/human/user = loc
	if(istype(user))
		if(src == user.back)
			user.update_inv_back()
		else if(src == user.belt)
			user.update_inv_belt()
		else if(src == user.s_store)
			user.update_inv_s_store()

/obj/item/storage/large_holster/equipped(mob/user, slot)
	if(slot == WEAR_BACK || slot == WEAR_WAIST || slot == WEAR_J_STORE)
		mouse_opacity = MOUSE_OPACITY_OPAQUE //so it's easier to click when properly equipped.
	..()

/obj/item/storage/large_holster/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()

/obj/item/storage/large_holster/_item_insertion(obj/item/W, prevent_warning = 0)
	..()
	if(drawSound)
		playsound(src, drawSound, 15, TRUE)

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/storage/large_holster/_item_removal(obj/item/W, atom/new_location)
	..()
	if(drawSound)
		playsound(src, drawSound, 15, TRUE)

/obj/item/storage/large_holster/m37
	name = "L44 M37A2 刀鞘"
	desc = "适配 USCM 制式霰弹枪的大型皮革枪套，带有背部固定带，便于收纳。"
	icon_state = "m37_holster"
	max_w_class = SIZE_HUGE
	can_hold = list(
		/obj/item/weapon/gun/shotgun/pump,
		/obj/item/weapon/gun/shotgun/combat,
		/obj/item/weapon/gun/shotgun/double/mou53,
	)
	has_gamemode_skin = FALSE

/obj/item/storage/large_holster/m37/standard
	has_gamemode_skin = FALSE

/obj/item/storage/large_holster/m37/full/fill_preset_inventory()
	new /obj/item/weapon/gun/shotgun/pump(src)

/obj/item/storage/large_holster/m37/full/noammo/fill_preset_inventory()
	new /obj/item/weapon/gun/shotgun/pump/unloaded (src)

/obj/item/storage/large_holster/machete
	name = "H5 式 M2132 砍刀鞘"
	desc = "用于携带 M2132 砍刀的大型皮革刀鞘，可固定在背部或护甲上。"
	icon_state = "machete_holster"
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	can_hold = list(/obj/item/weapon/sword/machete)

/obj/item/storage/large_holster/machete/full/fill_preset_inventory()
	new /obj/item/weapon/sword/machete(src)

/obj/item/storage/large_holster/machete/arnold
	name = "QH20 式 M2100 定制砍刀鞘"
	desc = "用于携带 M2100“恩加杰”砍刀的大型皮革刀鞘，可固定在背部或护甲上。"
	icon_state = "arnold-machete-pouch"

/obj/item/storage/large_holster/machete/arnold/full/fill_preset_inventory()
	new /obj/item/weapon/sword/machete/arnold(src)

/obj/item/storage/large_holster/machete/arnold/weak
	name = "QH20 式 M2100 砍刀鞘"
	desc = "用于携带 M2100 砍刀的大型皮革刀鞘，可固定在背部或护甲上。"

/obj/item/storage/large_holster/machete/arnold/weak/fill_preset_inventory()
	new /obj/item/weapon/sword/machete/arnold/weak(src)

/obj/item/storage/large_holster/machete/smartgunner
	name = "M56 背带砍刀鞘"
	desc = "连接在 M56 战斗背带上的刀鞘，用于携带 M2132 砍刀。"
	icon_state = "smartgun_machete_holster"
	flags_equip_slot = SLOT_BACK
	flags_item = SMARTGUNNER_BACKPACK_OVERRIDE

/obj/item/storage/large_holster/machete/smartgunner/mob_can_equip(mob/equipping_mob, slot, disable_warning)
	. = ..()

	var/mob/living/carbon/human/user = equipping_mob
	if(!ishuman(user))
		return FALSE

	if(!user.wear_suit || !(user.wear_suit.flags_inventory & SMARTGUN_HARNESS))
		if(!disable_warning)
			to_chat(equipping_mob, SPAN_WARNING("You can't equip [src] without a harness."))
		return FALSE

/obj/item/storage/large_holster/machete/smartgunner/full/fill_preset_inventory()
	new /obj/item/weapon/sword/machete(src)

/obj/item/storage/large_holster/katana
	name = "武士刀鞘"
	desc = "用于携带日本刀的大型鲜艳刀鞘，可背在背上或挂在腰间。坚固木壳使它在紧急时也能充当不错的防身武器。"
	icon_state = "katana_holster"
	force = 12
	attack_verb = list("bludgeoned", "struck", "cracked")
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	can_hold = list(/obj/item/weapon/sword/katana)

/obj/item/storage/large_holster/katana/full/fill_preset_inventory()
	new /obj/item/weapon/sword/katana(src)

/obj/item/storage/large_holster/ceremonial_sword
	name = "礼仪剑鞘"
	desc = "用于携带礼仪剑的大型鲜艳剑鞘。"
	icon_state = "ceremonial_sword_holster"//object icon is duplicate of katana holster, needs new icon at some point.
	force = 12
	flags_equip_slot = SLOT_WAIST
	can_hold = list(/obj/item/weapon/sword/ceremonial)

/obj/item/storage/large_holster/ceremonial_sword/full/fill_preset_inventory()
	new /obj/item/weapon/sword/ceremonial(src)

/obj/item/storage/large_holster/m39
	name = "M276 式 M39 枪套挂具"
	desc = "M276 是 USCM 的标准携行装备，由模块化腰带与多种挂扣组成。此枪套用较大框架和硬质背板支撑冲锋枪，原为 M39 设计，但可调挂扣也适配大多数紧凑型冲锋枪。设计较特殊，仅作特别配发，因此并不常见。"
	icon_state = "m39_holster"
	icon = 'icons/obj/items/clothing/belts.dmi'
	flags_equip_slot = SLOT_WAIST|SLOT_SUIT_STORE
	max_w_class = 5
	can_hold = list(
		/obj/item/weapon/gun/smg/m39,
		/obj/item/weapon/gun/smg/mp27,
		/obj/item/weapon/gun/smg/mac15,
		/obj/item/weapon/gun/pistol/skorpion,
	)
	///Guns have a hud offset that throws the vis_contents alignment off.
	var/gun_offset = 0
	///Whether the gun had pixel scaling set before being holstered.
	var/gun_scaling = FALSE

/obj/item/storage/large_holster/m39/_item_insertion(obj/item/W, prevent_warning)
	if(istype(W)) //Doing this before calling parent so that the gun isn't misaligned in the inventory screen.
		if(W.appearance_flags & PIXEL_SCALE)
			gun_scaling = TRUE
		else
			W.appearance_flags |= PIXEL_SCALE

		gun_offset = W.hud_offset
		W.hud_offset = 0
		W.pixel_x = 0
		W.transform = turn(matrix(0.82, MATRIX_SCALE), 90) //0.82x is the right size and gives reasonably accurate results with pixel scaling.

		W.vis_flags |= VIS_INHERIT_ID|VIS_INHERIT_PLANE //Means the gun is just visual and doesn't block picking up or clicking on the holster.
		vis_contents += W

	..()

/obj/item/storage/large_holster/m39/_item_removal(obj/item/W, atom/new_location)
	if(gun_scaling)
		gun_scaling = FALSE
	else
		W.appearance_flags &= ~PIXEL_SCALE

	W.hud_offset = gun_offset
	W.pixel_x = gun_offset
	W.transform = null

	W.vis_flags &= ~VIS_INHERIT_ID|VIS_INHERIT_PLANE
	vis_contents -= W

	..()

/obj/item/storage/large_holster/m39/update_icon()
	item_state = length(contents) ? "[base_icon]_full" : base_icon

	var/mob/living/carbon/human/user = loc
	if(istype(user))
		user.update_inv_belt()

/obj/item/storage/large_holster/m39/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/m39())

/obj/item/storage/large_holster/m39/full/elite/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/smg/m39/elite())


/obj/item/storage/large_holster/fuelpack
	name = "炙炉-T 柔性补燃系统"
	desc = "承载炙炉-T 柔性补油系统的专用背带，由 USCM 火焰兵为自己设计。"
	icon = 'icons/obj/items/clothing/backpacks.dmi'
	icon_state = "flamethrower_broiler"
	flags_atom = FPRINT|CONDUCT
	var/obj/item/ammo_magazine/flamer_tank/large/fuel
	var/obj/item/ammo_magazine/flamer_tank/large/B/fuelB
	var/obj/item/ammo_magazine/flamer_tank/large/X/fuelX
	var/obj/item/ammo_magazine/flamer_tank/large/active_fuel
	var/obj/item/weapon/gun/flamer/M240T/linked_flamer
	var/toggling = FALSE
	var/image/flamer_overlay
	actions_types = list(/datum/action/item_action/specialist/toggle_fuel)
	can_hold = list(/obj/item/weapon/gun/flamer/M240T)
	has_gamemode_skin = FALSE

/obj/item/storage/large_holster/fuelpack/Initialize()
	. = ..()
	fuel = new /obj/item/ammo_magazine/flamer_tank/large()
	fuelB = new /obj/item/ammo_magazine/flamer_tank/large/B()
	fuelX = new /obj/item/ammo_magazine/flamer_tank/large/X()
	active_fuel = fuel
	flamer_overlay = overlay_image('icons/obj/items/clothing/backpacks.dmi', "+m240t")

/obj/item/storage/large_holster/fuelpack/Destroy()
	QDEL_NULL(active_fuel)
	QDEL_NULL(fuel)
	QDEL_NULL(fuelB)
	QDEL_NULL(fuelX)
	if(linked_flamer)
		linked_flamer.fuelpack = null
		linked_flamer = null
	QDEL_NULL(flamer_overlay)
	. = ..()

/obj/item/storage/large_holster/fuelpack/update_icon()
	overlays -= flamer_overlay
	if(length(contents))
		overlays += flamer_overlay

	var/mob/living/carbon/human/user = loc
	if(istype(user))
		user.update_inv_back()

/obj/item/storage/large_holster/fuelpack/dropped(mob/user)
	if(linked_flamer)
		linked_flamer.fuelpack = null
		if(linked_flamer.current_mag in list(fuel, fuelB, fuelX))
			linked_flamer.current_mag = null
		linked_flamer.update_icon()
		linked_flamer = null
	..()

// Get the right onmob icon when we have flamer holstered.
/obj/item/storage/large_holster/fuelpack/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(slot == WEAR_BACK)
		if(length(contents))
			var/image/weapon_holstered = overlay_image('icons/mob/humans/onmob/back.dmi', "+m240t", color, RESET_COLOR)
			ret.overlays += weapon_holstered

	return ret

/obj/item/storage/large_holster/fuelpack/attack_self(mob/user)
	..()
	do_toggle_fuel(user)

/obj/item/storage/large_holster/fuelpack/proc/do_toggle_fuel(mob/user)
	if(!ishuman(user) || user.is_mob_incapacitated())
		return FALSE

	if(user.back != src)
		to_chat(user, SPAN_WARNING("[src] must be equipped before you can switch types."))
		return

	if(!linked_flamer)
		to_chat(user, SPAN_WARNING("An incinerator unit must be linked in order to switch fuel types."))
		return

	if(user.get_active_hand() != linked_flamer)
		to_chat(user, SPAN_WARNING("You must be holding [linked_flamer] to use [src]."))
		return

	if(!active_fuel)
		return

	// Toggle to the next one

	// Handles toggling of fuel. Snowflake way of changing action icon. Change icon, update action icon, change icon back
	if(istype(active_fuel, /obj/item/ammo_magazine/flamer_tank/large/X))
		active_fuel = fuel
	else if(istype(active_fuel, /obj/item/ammo_magazine/flamer_tank/large/B))
		active_fuel = fuelX
	else
		active_fuel = fuelB

	for(var/datum/action/action_added as anything in actions)
		action_added.update_button_icon()

	to_chat(user, "You switch the fuel tank to <b>[active_fuel.caliber]</b>")
	playsound(src, 'sound/machines/click.ogg', 25, TRUE)
	linked_flamer.current_mag = active_fuel
	linked_flamer.update_icon()

	return TRUE

/obj/item/storage/large_holster/fuelpack/verb/toggle_fuel()
	set name = "Toggle Fuel Type"
	set desc = "切换燃料类型。"
	set category = "Pyro"
	set src in usr
	do_toggle_fuel(usr)


/obj/item/storage/large_holster/fuelpack/attackby(obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/ammo_magazine/flamer_tank/large/))
		switch_fuel(A, user)
		return

	var/obj/item/weapon/gun/flamer/M240T/F = A
	if(istype(F) && !(F.fuelpack))
		F.link_fuelpack(user)
		if(F.current_mag && !(F.current_mag in list(fuel,fuelB,fuelX)))
			to_chat(user, SPAN_WARNING("\The [F.current_mag] is ejected by the Broiler-T back harness and replaced with \the [active_fuel]!"))
			F.unload(user, drop_override = TRUE)
			F.current_mag = active_fuel
			F.update_icon()

	. = ..()

/obj/item/storage/large_holster/fuelpack/proc/switch_fuel(obj/item/ammo_magazine/flamer_tank/large/new_fuel, mob/user)
	// Switch out the currently stored fuel and drop it
	if(istype(new_fuel, /obj/item/ammo_magazine/flamer_tank/large/X/))
		fuelX.forceMove(get_turf(user))
		fuelX = new_fuel
	else if(istype(new_fuel, /obj/item/ammo_magazine/flamer_tank/large/B/))
		fuelB.forceMove(get_turf(user))
		fuelB = new_fuel
	else
		fuel.forceMove(get_turf(user))
		fuel = new_fuel
	visible_message("[user] swaps out the fuel tank in [src].","You swap out the fuel tank in [src] and drop the old one.")
	to_chat(user, "The newly inserted [new_fuel.caliber] contains: [floor(new_fuel.get_ammo_percent())]% fuel.")
	user.temp_drop_inv_item(new_fuel)
	new_fuel.moveToNullspace() //necessary to not confuse the storage system
	playsound(src, 'sound/machines/click.ogg', 25, TRUE)
	// If the fuel being switched is the active one, set it as new_fuel until it gets toggled
	if(istype(new_fuel, active_fuel))
		active_fuel = new_fuel


/obj/item/storage/large_holster/fuelpack/get_examine_text(mob/user)
	. = ..()
	if(length(contents))
		. += "It is storing a M240-T incinerator unit."
	if (get_dist(user, src) <= 1)
		if(fuel)
			. += "The [fuel.caliber] currently contains: [floor(fuel.get_ammo_percent())]% fuel."
		if(fuelB)
			. += "The [fuelB.caliber] currently contains: [floor(fuelB.get_ammo_percent())]% fuel."
		if(fuelX)
			. += "The [fuelX.caliber] currently contains: [floor(fuelX.get_ammo_percent())]% fuel."

/datum/action/item_action/specialist/toggle_fuel
	ability_primacy = SPEC_PRIMARY_ACTION_1

/datum/action/item_action/specialist/toggle_fuel/New(mob/living/user, obj/item/holder)
	..()
	name = "Toggle Fuel Type"
	button.name = name
	update_button_icon()

/datum/action/item_action/specialist/toggle_fuel/update_button_icon()
	var/obj/item/storage/large_holster/fuelpack/FP = holder_item
	if (!istype(FP))
		return

	var/icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	var/icon_state
	if(istype(FP.active_fuel, /obj/item/ammo_magazine/flamer_tank/large/X))
		icon_state = "flametank_large_blue"
	else if(istype(FP.active_fuel, /obj/item/ammo_magazine/flamer_tank/large/B))
		icon_state = "flametank_large_green"
	else
		icon_state = "flametank_large"

	button.overlays.Cut()
	var/image/IMG = image(icon, button, icon_state)
	button.overlays += IMG

/datum/action/item_action/specialist/toggle_fuel/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && H.body_position == STANDING_UP && holder_item == H.back)
		return TRUE

/datum/action/item_action/specialist/toggle_fuel/action_activate()
	. = ..()
	var/obj/item/storage/large_holster/fuelpack/FP = holder_item
	if (!istype(FP))
		return
	FP.toggle_fuel()
