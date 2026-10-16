//Recovery Node - Heals xenomorphs around it

/obj/effect/alien/resin/special/recovery
	name = XENO_STRUCTURE_RECOVERY
	desc = "一个温暖柔和的光源，伴着轻微的嗡鸣有节奏地闪烁。"
	icon_state = "recovery"
	health = 400
	var/heal_amount = 20
	var/heal_cooldown = 5 SECONDS
	var/last_healed

/obj/effect/alien/resin/special/recovery/get_examine_text(mob/user)
	. = ..()
	if((isxeno(user) || isobserver(user)) && linked_hive)
		. += "恢复相邻异形的生命值。"

/obj/effect/alien/resin/special/recovery/process()
	if(last_healed && world.time < last_healed + heal_cooldown)
		return
	var/list/heal_candidates = list()
	for(var/mob/living/carbon/xenomorph/X in orange(src, 1))
		if(X.health >= X.maxHealth || !X.resting || X.hivenumber != linked_hive.hivenumber)
			continue
		heal_candidates += X
	last_healed = world.time
	if(!length(heal_candidates))
		return
	var/mob/living/carbon/xenomorph/picked_candidate = pick(heal_candidates)
	picked_candidate.visible_message(SPAN_HELPFUL("温暖的光晕笼罩着[picked_candidate]，使其散发出光芒。"), \
				SPAN_HELPFUL("你感到温暖的光晕笼罩着自己。"))
	if(!do_after(picked_candidate, heal_cooldown, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		return
	picked_candidate.gain_health(heal_amount)
