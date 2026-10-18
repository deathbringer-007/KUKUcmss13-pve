/datum/tutorial/xenomorph/abomination
	name = "异形——憎恶异形"
	desc = "学习扮演“铁血异形”（也称“憎恶异形”）品级。完成本教学后才能扮演憎恶异形。"
	icon_state = "predalien"
	tutorial_id = "xeno_abom_1"
	tutorial_template = /datum/map_template/tutorial/s7x7
	starting_xenomorph_type = /mob/living/carbon/xenomorph/predalien/tutorial
	/// How many marines in the kill_marines stage have been killed
	var/ending_marines_killed = 0

// START OF SCRITPING

/datum/tutorial/xenomorph/abomination/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	xeno.lock_evolve = TRUE

	message_to_player("欢迎来到憎恶异形教程。憎恶异形是强大的前线战士，其伤害会随击杀数提升。")
	message_to_player("用爪击杀死人类会增加你的击杀数，最多累计10次。技能击杀不计入其中。")

	addtimer(CALLBACK(src, PROC_REF(how_to_be_abom)), 12 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/how_to_be_abom()
	message_to_player("注意，所有铁血战士都会始终将你视为必须立即击杀的目标，你很可能需要同时应付多名铁血战士。")
	message_to_player("务必紧随其他异形，不要深入过远。虽然你比许多异形更强，但生命值和护甲仍不足以支撑独自作战。")
	addtimer(CALLBACK(src, PROC_REF(feral_rush_tutorial)), 10.5 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/feral_rush_tutorial()
	var/datum/action/rush = give_action(xeno, /datum/action/xeno_action/onclick/feralrush)
	message_to_player("你的第一个独有技能是<b>野性突进</b>，可以暂时提升速度和护甲。使用<B>野性突进</b>继续。")
	update_objective("使用野性突进技能。")
	add_highlight(rush.button)
	RegisterSignal(rush, COMSIG_XENO_ACTION_USED, PROC_REF(on_rush_used))

/datum/tutorial/xenomorph/abomination/proc/on_rush_used(datum/action/source, mob/owner)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
	remove_highlight(source.button)
	addtimer(CALLBACK(src, PROC_REF(predalien_roar_tutorial_1)), 5 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/predalien_roar_tutorial_1()
	hide_action(xeno, /datum/action/xeno_action/onclick/feralrush)
	xeno.cannot_slash = TRUE
	message_to_player("接下来是<b>咆哮</b>，这种多用途技能可以干扰周围一定范围内的运动探测器和隐形装置。")
	message_to_player("此外，它还能提高范围内友方异形的爪击伤害和速度。")
	addtimer(CALLBACK(src, PROC_REF(predalien_roar_tutorial_2)), 8 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/predalien_roar_tutorial_2()
	var/datum/action/roar = give_action(xeno, /datum/action/xeno_action/onclick/predalien_roar)
	message_to_player("<b>咆哮</b>最实用的作用之一，是让附近的铁血战士解除隐形。使用<b>咆哮</b>，让刚出现的铁血战士显形。")
	update_objective("使用咆哮，让附近的铁血战士显形。")
	add_highlight(roar.button)
	var/mob/living/carbon/human/pred = new(loc_from_corner(3, 3))
	add_to_tracking_atoms(pred)
	pred.create_hud()
	arm_equipment(pred, /datum/equipment_preset/yautja/blooded)
	var/obj/item/clothing/gloves/yautja/hunter/bracers = locate() in pred
	if(!bracers)
		message_to_player("出现了异常，请提交错误报告。")
		CRASH("predator spawned without bracers in tutorial")

	bracers.cloaker_internal(pred, TRUE, TRUE, TRUE)
	RegisterSignal(bracers, COMSIG_PRED_BRACER_DECLOAKED, PROC_REF(smash_tutorial_1))

/datum/tutorial/xenomorph/abomination/proc/smash_tutorial_1(datum/source)
	SIGNAL_HANDLER

	var/datum/action/roar = get_action(xeno, /datum/action/xeno_action/onclick/predalien_roar)
	remove_highlight(roar.button)
	update_objective("")

	UnregisterSignal(source, COMSIG_PRED_BRACER_DECLOAKED)
	addtimer(CALLBACK(src, PROC_REF(smash_tutorial_2)), 2.5 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/smash_tutorial_2()
	hide_action(xeno, /datum/action/xeno_action/onclick/predalien_roar)
	message_to_player("很好。<b>咆哮</b>是对抗铁血战士的重要手段。下一个技能是<b>野性猛击</b>。")
	xeno.cannot_slash = FALSE

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, pred)
	remove_from_tracking_atoms(pred)
	qdel(pred)

	addtimer(CALLBACK(src, PROC_REF(smash_tutorial_3)), 5 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/smash_tutorial_3()
	var/datum/action/smash = give_action(xeno, /datum/action/xeno_action/activable/feral_smash)
	RegisterSignal(smash, COMSIG_XENO_PRE_ACTION_USED, PROC_REF(frenzy_tutorial_1))
	add_highlight(smash.button)

	message_to_player("<b>野性猛击</b>是一种射程为五格的强力突袭，其伤害可观，并会随击杀数提升。")
	message_to_player("对陆战队员使用<b>野性猛击</b>继续。")
	update_objective("对陆战队员使用野性猛击。")

	xeno.forceMove(loc_from_corner(0, 2))
	xeno.anchored = TRUE
	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)

	var/mob/living/carbon/human/marine = new(loc_from_corner(4, 2))
	add_to_tracking_atoms(marine)
	arm_equipment(marine, /datum/equipment_preset/uscm/private_equipped)

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_1(datum/action/source, mob/owner)
	SIGNAL_HANDLER

	xeno.anchored = FALSE
	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
	RegisterSignal(source, COMSIG_XENO_ACTION_USED, PROC_REF(frenzy_tutorial_2))
	RegisterSignal(source, COMSIG_XENO_FAILED_ACTION_USED, PROC_REF(frenzy_tutorial_1_fail))

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_1_fail(datum/action/source, mob/owner)
	SIGNAL_HANDLER

	xeno.anchored = TRUE
	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
	UnregisterSignal(source, list(COMSIG_XENO_FAILED_ACTION_USED, COMSIG_XENO_ACTION_USED))

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_2(datum/action/source, mob/owner)
	SIGNAL_HANDLER

	if(get_turf(xeno) == loc_from_corner(0, 2)) // xeno didn't lunge at the mob
		xeno.anchored = TRUE
		UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
		ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
		return

	update_objective("")
	var/datum/action/smash = get_action(xeno, /datum/action/xeno_action/activable/feral_smash)
	remove_highlight(smash.button)
	UnregisterSignal(source, list(COMSIG_XENO_ACTION_USED, COMSIG_XENO_PRE_ACTION_USED))
	addtimer(CALLBACK(src, PROC_REF(frenzy_tutorial_3)), 2 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_3()
	remove_action(xeno, /datum/action/xeno_action/activable/feral_smash)
	message_to_player("很好。最后一个技能是<b>野性狂乱</b>，这种强力技能可以切换为攻击单个目标，或攻击较大范围内的全部目标。但在蓄力时，你会被固定在原地。")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, marine)
	remove_from_tracking_atoms(marine)
	qdel(marine)

	addtimer(CALLBACK(src, PROC_REF(frenzy_tutorial_4)), 6 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_4()
	var/mob/living/carbon/human/marine = new(loc_from_corner(4, 2))
	add_to_tracking_atoms(marine)
	RegisterSignal(marine, COMSIG_MOB_DEATH, PROC_REF(on_marine_early_death))
	arm_equipment(marine, /datum/equipment_preset/uscm/private_equipped)

	var/datum/action/frenzy = give_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	add_highlight(frenzy.button)
	message_to_player("<b>野性狂乱</b>默认采用单体模式。对刚出现的陆战队员使用<b>野性狂乱</b>。")
	update_objective("对陆战队员使用野性狂乱。")

	RegisterSignal(frenzy, COMSIG_XENO_ACTION_USED, PROC_REF(frenzy_tutorial_5))

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_5(datum/action/xeno_action/source, mob/owner)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, marine)
	if(get_dist(marine, xeno) > 1)
		return

	UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
	var/datum/action/frenzy = get_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	remove_highlight(frenzy.button)
	var/datum/action/frenzy_toggle = give_action(xeno, /datum/action/xeno_action/onclick/toggle_gut_targeting)
	add_highlight(frenzy_toggle.button)
	message_to_player("很好。现在使用刚获得的<b>切换剖腹方式</b>技能，把<b>野性狂乱</b>切换为范围模式。")
	update_objective("使用切换剖腹方式技能，改变狂乱模式。")

	RegisterSignal(frenzy_toggle, COMSIG_XENO_ACTION_USED, PROC_REF(frenzy_tutorial_6))

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_6(datum/action/xeno_action/source, mob/owner)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_XENO_ACTION_USED)
	remove_highlight(source.button)
	source.plasma_cost = INFINITY // slightly scuffed way of disabling the switch button
	source.update_button_icon()

	message_to_player("<b>野性狂乱</b>现已切换为范围模式。在距离陆战队员两格以内的位置再次使用<b>野性狂乱</b>。")
	update_objective("在距离陆战队员两格以内使用野性狂乱。")
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, marine)
	marine.rejuvenate()
	var/datum/action/xeno_action/activable/feralfrenzy/frenzy = get_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	frenzy.targeting = AOETARGETGUT
	frenzy.reduce_cooldown(frenzy.xeno_cooldown)
	add_highlight(frenzy.button)

	RegisterSignal(frenzy, COMSIG_XENO_ACTION_USED, PROC_REF(frenzy_tutorial_7))

/datum/tutorial/xenomorph/abomination/proc/frenzy_tutorial_7(datum/action/source)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, marine)
	var/datum/action/xeno_action/activable/feralfrenzy/frenzy = get_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	if(get_dist(xeno, marine) > frenzy.range)
		// Not close enough to actually hit the marine
		return

	UnregisterSignal(frenzy, COMSIG_XENO_ACTION_USED)
	UnregisterSignal(marine, COMSIG_MOB_DEATH)
	remove_highlight(frenzy.button)
	message_to_player("很好。你可能已经注意到，范围版<b>野性狂乱</b>需要更长的蓄力时间，总伤害也更低。")
	addtimer(CALLBACK(src, PROC_REF(kill_marines)), 6 SECONDS)

/datum/tutorial/xenomorph/abomination/proc/kill_marines()
	message_to_player("使用任意攻击或技能击杀刚出现的三名陆战队员，完成教程。")

	// Spawn/rejuv the dummies
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, marine) // we can reuse this one though
	marine.rejuvenate()
	marine.forceMove(loc_from_corner(4, 2))
	RegisterSignal(marine, COMSIG_MOB_DEATH, PROC_REF(kill_marines_2))

	var/mob/living/carbon/human/marine_2 = new(loc_from_corner(2, 2))
	arm_equipment(marine_2, /datum/equipment_preset/uscm/private_equipped)
	RegisterSignal(marine_2, COMSIG_MOB_DEATH, PROC_REF(kill_marines_2))

	var/mob/living/carbon/human/marine_3 = new(loc_from_corner(0, 2))
	arm_equipment(marine_3, /datum/equipment_preset/uscm/private_equipped)
	RegisterSignal(marine_3, COMSIG_MOB_DEATH, PROC_REF(kill_marines_2))

	// Arrange the actions about how they'd be in an actual game
	remove_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	remove_action(xeno, /datum/action/xeno_action/onclick/toggle_gut_targeting)

	give_action(xeno, /datum/action/xeno_action/activable/tail_stab)
	give_action(xeno, /datum/action/xeno_action/onclick/feralrush)
	give_action(xeno, /datum/action/xeno_action/onclick/predalien_roar)
	give_action(xeno, /datum/action/xeno_action/activable/feral_smash)
	give_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	give_action(xeno, /datum/action/xeno_action/onclick/toggle_gut_targeting)

/datum/tutorial/xenomorph/abomination/proc/kill_marines_2(datum/source)
	SIGNAL_HANDLER

	if(ending_marines_killed < 2)
		ending_marines_killed++
		return

	message_to_player("做得好。教程即将结束。")
	tutorial_end_in(7 SECONDS, TRUE)

// END OF SCRIPTING

/// In case a marine dies early to prevent softlocks
/datum/tutorial/xenomorph/abomination/proc/on_marine_early_death(datum/source)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, marine)
	marine.rejuvenate()
