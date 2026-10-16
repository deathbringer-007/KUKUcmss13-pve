/datum/xeno_strain/resin_whisperer
	name = HIVELORD_RESIN_WHISPERER
	localized_name = "树脂低语者"
	description = "你失去腐蚀酸液、分泌厚实树脂、加固树脂建筑以及在菌毯之外种植节点的能力，并牺牲五分之一的等离子体容量，换取更好的视野及与树脂更紧密的联系。现在你可以在最远十二格外远程建造树脂建筑，包括菌毯节点！"
	flavor_description = "让树脂指引我们。它正在低语，仔细聆听。"
	icon_state_prefix = "Resin Whisperer"

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/secrete_resin/remote, //third macro
		/datum/action/xeno_action/activable/transfer_plasma/hivelord, // readding it so it gets at the end of the ability list
		/datum/action/xeno_action/active_toggle/toggle_speed, // readding it so it gets at the end of the ability list
	)

/datum/xeno_strain/resin_whisperer/apply_strain(mob/living/carbon/xenomorph/hivelord/hivelord)
	hivelord.plasmapool_modifier = 0.8 // -20% plasma pool
	hivelord.extra_build_dist = 12 // 1 + 12 = 13 tile build range
	hivelord.can_stack_builds = TRUE
	hivelord.recalculate_plasma()

	hivelord.client?.change_view(10, src)

	hivelord.set_resin_build_order(GLOB.resin_build_order_hivelord_whisperer)
	for(var/datum/action/xeno_action/action in hivelord.actions)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			if(choose_resin_ability)
				choose_resin_ability.update_button_icon(hivelord.selected_resin)
				break // Don't need to keep looking

/*
 * Coerce Resin ability
 */

// Remote resin building
/datum/action/xeno_action/activable/secrete_resin/remote
	name = "Coerce Resin (100)"
	localized_names = list("Coerce Resin (100)" = "驱使树脂（100）")
	action_icon_state = "secrete_resin"
	ability_name = "coerce resin"
	xeno_cooldown = 1 SECONDS
	thick = FALSE
	make_message = FALSE

	no_cooldown_msg = TRUE

	build_speed_mod = 2 // the actual building part takes twice as long

	macro_path = /datum/action/xeno_action/verb/verb_coerce_resin
	action_type = XENO_ACTION_CLICK

	var/last_use = 0
	var/care_about_adjacency = TRUE

/datum/action/xeno_action/activable/secrete_resin/remote/use_ability(atom/target_atom, mods)
	if(!can_remote_build())
		to_chat(owner, SPAN_XENONOTICE("我们必须站在菌毯上才能与树脂建立联系。"))
		return

	if(!action_cooldown_check())
		return

	if(mods[CLICK_CATCHER])
		return

	var/turf/target_turf = get_turf(target_atom)
	if(!target_turf)
		return

	if(care_about_adjacency && !(target_turf in view(10, owner)))
		to_chat(owner, SPAN_XENONOTICE("目标必须在我们的直视范围内！"))
		return

	/// Check if the target is a resin door and open or close it
	if(istype(target_atom, /obj/structure/mineral_door/resin))
		var/obj/structure/mineral_door/resin/resin_door = target_atom
		resin_door.TryToSwitchState(owner)
		if(resin_door.open)
			to_chat(owner, SPAN_XENONOTICE("我们集中与树脂的联系，远程关闭了树脂门。"))
		else
			to_chat(owner, SPAN_XENONOTICE("我们集中与树脂的联系，远程打开了树脂门。"))
		return

	// since actions are instanced per hivelord, and only one construction can be made at a time, tweaking the datum on the fly here is fine. you're going to have to figure something out if these conditions change, though
	if(care_about_adjacency)
		if(owner.Adjacent(target_turf))
			build_speed_mod = 1
		else
			build_speed_mod = initial(build_speed_mod)

	var/mob/living/carbon/xenomorph/hivelord = owner
	if(!..())
		return

	if(!hivelord.selected_resin)
		return

	var/datum/resin_construction/resing_construction = GLOB.resin_constructions_list[hivelord.selected_resin]
	target_turf.visible_message(SPAN_XENONOTICE("菌毯开始剧烈搏动，分泌树脂形成了[resing_construction.construction_name]！"), null, 5)
	to_chat(owner, SPAN_XENONOTICE("我们将等离子体注入脚下的菌毯，驱使其分泌树脂形成[resing_construction.construction_name]。"))
	playsound(target_turf, "alien_resin_build", 25)
	return TRUE

// By default, the xeno must be on a weed tile in order to build from a distance.
/datum/action/xeno_action/activable/secrete_resin/remote/proc/can_remote_build()
	if(!locate(/obj/effect/alien/weeds) in get_turf(owner))
		return FALSE
	return TRUE

/datum/action/xeno_action/verb/verb_coerce_resin()
	set category = "Alien"
	set name = "Coerce Resin"
	set hidden = TRUE
	var/action_name = "Coerce Resin (150)"
	handle_xeno_macro(src, action_name)
