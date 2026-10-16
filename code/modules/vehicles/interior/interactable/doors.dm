/obj/structure/interior_exit
	name = "舱门"
	desc = "穿过这里就能出去了。"
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	layer = INTERIOR_DOOR_LAYER

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	// The interior interior this exit is tied to
	var/datum/interior/interior = null
	// Which entrance to exit through
	var/entrance_id = null

/obj/structure/interior_exit/get_projectile_hit_boolean(obj/projectile/P)
	return FALSE

/obj/structure/interior_exit/attack_hand(mob/M)

	// Check if drag anything
	var/atom/dragged_atom
	if(istype(M.get_inactive_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_inactive_hand()
		dragged_atom = G.grabbed_thing
	else if(istype(M.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_active_hand()
		dragged_atom = G.grabbed_thing

	var/obj/vehicle/multitile/V = interior.exterior
	var/exit_time = V.entrance_speed
	if(dragged_atom)
		exit_time = 2 SECONDS

	to_chat(M, SPAN_NOTICE("你开始爬出[interior.exterior]。"))
	if(!do_after(M, exit_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("你的动作被打断了。"))
		return

	//Dragged stuff comes with us only if properly waited 2 seconds. No cheating!
	if(dragged_atom)
		dragged_atom = null
		if(istype(M.get_inactive_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_inactive_hand()
			interior.exit(G.grabbed_thing)
		else if(istype(M.get_active_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_active_hand()
			interior.exit(G.grabbed_thing)

	interior.exit(M)

/obj/structure/interior_exit/attack_alien(mob/living/carbon/xenomorph/M, dam_bonus)
	to_chat(M, SPAN_NOTICE("你开始爬出[interior.exterior]。"))
	if(!do_after(M, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("你的动作被打断了。"))
	else
		interior.exit(M)
	return XENO_NO_DELAY_ACTION

/obj/structure/interior_exit/vehicle/attackby(obj/item/object, mob/user)
	if(istype(object, /obj/item/explosive/grenade))
		var/obj/item/explosive/grenade/nade = object
		if(nade.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(nade, user))
			to_chat(user, SPAN_WARNING("[nade.name]的安全区防事故装置阻止了你启用手榴弹！"))
			// Let staff know, in case someone's actually about to try to grief
			msg_admin_niche("[key_name(user)] attempted to prime \a [nade.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
			return

		user.visible_message(SPAN_WARNING("[user]摆好姿势，准备把[nade]从门口扔出去。"),
		SPAN_WARNING("你摆好姿势，准备把[nade]从门口扔出去。"))
		if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			return

		user.visible_message(SPAN_WARNING("[user]把[nade]从门口扔了出去！"),
		SPAN_WARNING("你把[nade]从门口扔了出去。"))

		var/turf/exit_turf = get_exit_turf()
		user.drop_held_item()
		interior.exit(nade, exit_turf)
		if(!nade.active)
			nade.activate(user)
		return

	else
		attack_hand(user)

/obj/structure/interior_exit/attack_ghost(mob/dead/observer/user)
	if(!interior)
		return ..()

	var/turf/vehicle_turf = get_turf(interior.exterior)
	if(!vehicle_turf)
		return ..()

	user.forceMove(vehicle_turf)

/obj/structure/interior_exit/vehicle
	name = "车门"

/obj/structure/interior_exit/vehicle/Initialize()
	. = ..()
	update_icon()

/obj/structure/interior_exit/vehicle/update_icon()
	switch(dir)
		if(NORTH)
			pixel_y = 31
			layer = WALL_LAYER
		if(SOUTH)
			layer = INTERIOR_WALL_SOUTH_LAYER

/obj/structure/interior_exit/vehicle/proc/get_exit_turf()
	var/obj/vehicle/multitile/V = interior.exterior
	var/list/entrance_coords = V.entrances[entrance_id]
	return locate(V.x + entrance_coords[1], V.y + entrance_coords[2], V.z)

/obj/structure/interior_exit/vehicle/attack_hand(mob/M)

	// Check if drag anything
	var/atom/dragged_atom
	if(istype(M.get_inactive_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_inactive_hand()
		dragged_atom = G.grabbed_thing
	else if(istype(M.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_active_hand()
		dragged_atom = G.grabbed_thing

	var/obj/vehicle/multitile/V = interior.exterior
	var/exit_time = V.entrance_speed
	if(dragged_atom)
		exit_time = 2 SECONDS

	to_chat(M, SPAN_NOTICE("你开始爬出[interior.exterior]。"))
	if(!do_after(M, exit_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("你的动作被打断了。"))
		return

	var/turf/exit_turf = get_exit_turf()

	//Dragged stuff comes with us only if properly waited 2 seconds. No cheating!
	if(dragged_atom)
		dragged_atom = null
		if(istype(M.get_inactive_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_inactive_hand()
			interior.exit(G.grabbed_thing, exit_turf)
		else if(istype(M.get_active_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_active_hand()
			interior.exit(G.grabbed_thing, exit_turf)

	interior.exit(M, exit_turf)

/obj/structure/interior_exit/vehicle/attack_alien(mob/living/carbon/xenomorph/M, dam_bonus)
	to_chat(M, SPAN_NOTICE("你开始爬出[interior.exterior]。"))
	if(!do_after(M, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("你的动作被打断了。"))
	else
		interior.exit(M, get_exit_turf())
	return XENO_NO_DELAY_ACTION
