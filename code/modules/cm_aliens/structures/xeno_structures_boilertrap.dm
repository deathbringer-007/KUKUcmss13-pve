// Special boiler trap

// Tightly coupled with the boiler trapper strain. Pretty unavoidable given
// the amount of references this has to pass back and forth
/obj/effect/alien/resin/boilertrap
	desc = "这似乎是用来捕捉高大宿主的陷阱。"
	name = "树脂陷坑"
	icon_state = "trap_boiler"
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	health = 1
	layer = RESIN_STRUCTURE_LAYER
	var/list/tripwires = list()
	var/hivenumber = XENO_HIVE_NORMAL
	var/root_duration = 17.5

	var/mob/living/carbon/xenomorph/bound_xeno // Boiler linked to this trap

/obj/effect/alien/resin/boilertrap/empowered
	root_duration = 30

/obj/effect/alien/resin/boilertrap/Initialize(mapload, mob/living/carbon/xenomorph/X)
	if(mapload || !istype(X))
		return INITIALIZE_HINT_QDEL
	bound_xeno = X
	hivenumber = X.hivenumber
	set_hive_data(src, hivenumber)
	return ..()

/obj/effect/alien/resin/boilertrap/Destroy(force)
	bound_xeno = null
	QDEL_NULL_LIST(tripwires)
	return ..()

/obj/effect/alien/resin/boilertrap/get_examine_text(mob/user)
	if(!isxeno(user))
		return ..()
	. = ..()
	. += SPAN_XENOWARNING("用来捕捉高大宿主并将其困住的陷阱。")

/obj/effect/alien/resin/boilertrap/fire_act()
	. = ..()
	qdel(src)

/obj/effect/alien/resin/boilertrap/bullet_act(obj/projectile/P)
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_XENO))
		return
	return ..()

/obj/effect/alien/resin/boilertrap/proc/trigger_trap(mob/M)
	if(!istype(M) || !istype(bound_xeno))
		return
	var/datum/effects/boiler_trap/F = new(M, bound_xeno, name)
	QDEL_IN(F, root_duration)
	to_chat(bound_xeno, SPAN_XENOHIGHDANGER("你感到自己的一个陷阱捕获了高大宿主！"))
	to_chat(M, SPAN_XENOHIGHDANGER("你被恶臭树脂制成的陷阱困住了！"))
	qdel(src)

/obj/effect/alien/resin/boilertrap/attack_alien(mob/living/carbon/xenomorph/X)
	to_chat(X, SPAN_XENOWARNING("最好别去碰那个陷阱。"))
	return XENO_NO_DELAY_ACTION

/obj/effect/alien/resin/boilertrap/Crossed(atom/A)
	if (isxeno(A))
		var/mob/living/carbon/xenomorph/X = A
		if (X.hivenumber != hivenumber)
			trigger_trap(A)
	else if(ishuman(A))
		trigger_trap(A)

	return ..()

/obj/effect/hole_tripwire_boiler
	name = "hole tripwire"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/effect/alien/resin/boilertrap/linked_trap

/obj/effect/hole_tripwire_boiler/Destroy(force)
	linked_trap?.tripwires -= src
	linked_trap = null
	return ..()

/obj/effect/hole_tripwire_boiler/Crossed(atom/A)
	if(!linked_trap)
		qdel(src)
		return

	if(ishuman(A))
		linked_trap.trigger_trap(A)
