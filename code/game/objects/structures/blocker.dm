// Impenetrable and invincible barriers
/obj/structure/blocker
	name = "阻挡物"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	unslashable = TRUE
	icon = 'icons/landmarks.dmi'
	icon_state = "map_blocker"

/obj/structure/blocker/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = NONE

/obj/structure/blocker/ex_act(severity)
	return

/obj/structure/blocker/invisible_wall
	name = "隐形墙"
	desc = "你无法往这边走。"
	icon_state = "invisible_wall"
	opacity = FALSE
	layer = ABOVE_FLY_LAYER + 0.1 //to make it visible in the map editor
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/blocker/invisible_wall/Collided(atom/movable/AM)
	var/msg = desc
	if(!msg)
		msg = "你无法往这边走。"
	to_chat(AM, SPAN_WARNING(msg))

/obj/structure/blocker/invisible_wall/New()
	..()
	icon_state = null

/obj/structure/blocker/invisible_wall/water
	desc = "你无法再往深处涉水了。"
	icon_state = "map_blocker"

/obj/structure/blocker/fog
	name = "浓雾"
	desc = "穿过去似乎太危险了，最好等雾散去。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	opacity = TRUE

/obj/structure/blocker/fog/Initialize(mapload, time_to_dispel)
	. = ..()

	if(!time_to_dispel)
		return INITIALIZE_HINT_QDEL

	dir = pick(CARDINAL_DIRS)
	QDEL_IN(src, time_to_dispel + rand(-5 SECONDS, 5 SECONDS))

/obj/structure/blocker/fog/attack_hand(mob/M)
	to_chat(M, SPAN_NOTICE("你透过浓雾张望，却完全看不出另一边有什么……"))

/obj/structure/blocker/fog/attack_alien(M)
	attack_hand(M)
	return XENO_NONCOMBAT_ACTION


/obj/structure/blocker/forcefield
	name = "力场"

	icon = 'icons/landmarks.dmi'
	icon_state = "map_blocker"
	anchored = TRUE
	unacidable = TRUE
	density = FALSE

	var/is_whitelist = FALSE
	var/strict_types = FALSE

	var/list/types = list()
	var/visible = FALSE

/obj/structure/blocker/forcefield/get_projectile_hit_boolean(obj/projectile/P)
	if(!is_whitelist)
		return FALSE
	. = ..()

/obj/structure/blocker/forcefield/BlockedPassDirs(atom/movable/AM, target_dir)
	var/whitelist_no_block = is_whitelist? NO_BLOCKED_MOVEMENT : BLOCKED_MOVEMENT

	if(strict_types)
		if(AM.type in types)
			return whitelist_no_block
	else
		for(var/type in types)
			if(istype(AM, type))
				return whitelist_no_block

	return !whitelist_no_block

/obj/structure/blocker/forcefield/Initialize(mapload, ...)
	. = ..()

	if(!visible)
		invisibility = 101

GLOBAL_VAR_INIT(vehicle_blockers, TRUE)

/obj/structure/blocker/forcefield/vehicles
	types = list(/obj/vehicle/)


/obj/structure/blocker/forcefield/vehicles/handle_vehicle_bump(obj/vehicle/multitile/multitile_vehicle)
	if(!GLOB.vehicle_blockers)
		return TRUE
	if(multitile_vehicle.vehicle_flags & VEHICLE_BYPASS_BLOCKERS)
		return TRUE
	return FALSE

/obj/structure/blocker/forcefield/multitile_vehicles
	types = list(/obj/vehicle/multitile/)


/obj/structure/blocker/forcefield/multitile_vehicles/handle_vehicle_bump(obj/vehicle/multitile/multitile_vehicle)
	if(!GLOB.vehicle_blockers)
		return TRUE
	if(multitile_vehicle.vehicle_flags & VEHICLE_BYPASS_BLOCKERS)
		return TRUE
	return FALSE

/obj/structure/blocker/forcefield/human
	types = list(/mob/living/carbon/human)
	icon_state = "purple_line"

	visible = TRUE

/obj/structure/blocker/forcefield/human/bulletproof/get_projectile_hit_boolean()
	return TRUE

// for fuel pump since it's a large sprite.
/obj/structure/blocker/fuelpump
	name = "\improper 燃料泵"
	desc = "在舰船各处泵送燃料的机器。"
	invisibility = 101
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/blocker/invisible_wall/directional
	name = "定向阻挡物"
	icon_state = "invisible_wall_directional"
	flags_atom = ON_BORDER
