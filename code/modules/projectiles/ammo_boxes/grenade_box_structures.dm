/obj/structure/magazine_box/nade_box
	name = "手榴弹箱"
	desc = "A generic grenade box. If you're seeing this, something went wrong and you should contact a GM about it."
	icon = 'icons/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	icon_state = "base_uscm_nade"
	limit_per_tile = 1
	holds_grenades = TRUE
	holds_ammo = FALSE

	var/grenades_icon = 'icons/obj/items/weapons/guns/ammo_boxes/grenades.dmi'
	flames_icon = 'icons/obj/items/weapons/guns/ammo_boxes/misc.dmi'

//---------------------GENERAL PROCS

/obj/structure/magazine_box/nade_box/Destroy()
	if(boom_box)
		qdel(boom_box)
		boom_box = null
	return ..()

/obj/structure/magazine_box/nade_box/update_icon()
	if(overlays)
		overlays.Cut()

	if(length(boom_box.contents) >= (boom_box.num_of_magazines/2))
		overlays += image(grenades_icon, icon_state = "[boom_box.overlay_grenade_type]")
	else if(length(boom_box.contents) > (boom_box.num_of_magazines/8))
		overlays += image(grenades_icon, icon_state = "[boom_box.overlay_grenade_type]_1")

/obj/structure/magazine_box/nade_box/attack_hand(mob/living/user)
	if(burning)
		to_chat(user, SPAN_DANGER("它着火了，里面的手榴弹随时可能爆炸！"))
		return
	if(length(boom_box.contents))
		var/obj/item/explosive/grenade/nade = pick(boom_box.contents)
		boom_box.contents -= nade
		user.put_in_hands(nade)
		to_chat(user, SPAN_NOTICE("你从[src]中取出[nade]。"))
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("[src]是空的。"))

/obj/structure/magazine_box/nade_box/attackby(obj/item/W, mob/living/user)
	if(burning)
		to_chat(user, SPAN_DANGER("它着火了，里面的手榴弹随时可能爆炸！"))
		return
	if(istypestrict(W,boom_box.magazine_type) || is_type_in_list(W, boom_box.allowed_magazines))
		if(istype(W, /obj/item/explosive/grenade))
			var/obj/item/explosive/grenade/nade = W
			if(nade.w_class == SIZE_HUGE)
				to_chat(user, SPAN_WARNING("[W]已经启动引信了！别犯傻！"))
				return
		if(length(boom_box.contents) < boom_box.num_of_magazines)
			user.drop_inv_item_to_loc(W, src)
			boom_box.contents += W
			to_chat(user, SPAN_NOTICE("你把[W]放入[src]。"))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("[src]已装满。"))
	else
		to_chat(user, SPAN_WARNING("你可不想把不同型号的手榴弹混放在同一箱里。"))

//---------------------FIRE HANDLING PROCS

/obj/structure/magazine_box/nade_box/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	if(burning || !boom_box)
		return
	burning = TRUE
	boom_box.flamer_fire_act(damage, flame_cause_data)
	return
