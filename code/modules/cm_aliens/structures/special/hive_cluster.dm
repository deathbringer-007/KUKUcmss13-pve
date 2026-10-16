#define CLUSTER_REPAIR_TIME (4 SECONDS)
#define CLUSTER_WEEDS_REGROWTH_TIME (15 SECONDS)

/obj/effect/alien/resin/special/cluster
	name = XENO_STRUCTURE_CLUSTER
	desc = "一大团黏稠物质，正有节奏地搏动，仿佛在向下方的菌毯输送着什么……"
	icon = 'icons/mob/xenos/structures48x48.dmi'
	icon_state = "hive_cluster_idle"

	pixel_x = -8
	pixel_y = -8

	health = 1200
	block_range = 0

	var/node_type = /obj/effect/alien/weeds/node/pylon/cluster
	var/obj/effect/alien/weeds/node/node

	var/damaged = FALSE
	var/plasma_stored = 0
	var/plasma_required_to_repair = 300

/obj/effect/alien/resin/special/cluster/Initialize(mapload, hive_ref)
	. = ..()
	node = place_node()
	update_minimap_icon()

/obj/effect/alien/resin/special/cluster/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, MINIMAP_FLAG_XENO, "cluster")

/obj/effect/alien/resin/special/cluster/Destroy()
	QDEL_NULL(node)
	SSminimaps.remove_marker(src)
	return ..()

/obj/effect/alien/resin/special/cluster/attack_alien(mob/living/carbon/xenomorph/M)
	if(isxeno_builder(M) && M.a_intent == INTENT_HELP && M.hivenumber == linked_hive.hivenumber)
		do_repair(M) //This handles the delay itself.
		return XENO_NO_DELAY_ACTION
	else
		return ..()

/obj/effect/alien/resin/special/cluster/proc/do_repair(mob/living/carbon/xenomorph/xeno)
	if(!istype(xeno))
		return
	if(!xeno.plasma_max)
		return
	var/can_repair = damaged || health < maxhealth
	if(!can_repair)
		to_chat(xeno, SPAN_XENONOTICE("[name]完好无损，无需修复。"))
		return

	to_chat(xeno, SPAN_XENONOTICE("我们开始向[name]注入等离子体，以修复它。"))
	xeno_attack_delay(xeno)
	if(!do_after(xeno, CLUSTER_REPAIR_TIME, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src) || !can_repair)
		return

	var/amount_to_use = min(xeno.plasma_stored, (plasma_required_to_repair - plasma_stored))
	plasma_stored += amount_to_use
	xeno.plasma_stored -= amount_to_use

	if(plasma_stored < plasma_required_to_repair)
		to_chat(xeno, SPAN_WARNING("修复[name]还需要[plasma_required_to_repair - plasma_stored]点等离子体。"))
		return

	damaged = FALSE
	plasma_stored = 0
	health = initial(health)

	if(!node)
		return
	for(var/obj/effect/alien/weeds/W as anything in node.children)
		if(get_dist(node, W) >= node.node_range)
			continue
		if(istype(W, /obj/effect/alien/weeds/weedwall))
			continue
		addtimer(CALLBACK(W, TYPE_PROC_REF(/obj/effect/alien/weeds, weed_expand), node), CLUSTER_WEEDS_REGROWTH_TIME, TIMER_UNIQUE)

	to_chat(xeno, SPAN_XENONOTICE("我们成功修复了[name]。"))
	playsound(loc, "alien_resin_build", 25)

/obj/effect/alien/resin/special/cluster/proc/place_node()
	var/obj/effect/alien/weeds/node/pylon/cluster/W = new node_type(loc, null, null, linked_hive)
	W.resin_parent = src
	return W

#undef CLUSTER_REPAIR_TIME
#undef CLUSTER_WEEDS_REGROWTH_TIME
