/datum/action/xeno_action/activable/throw_hugger/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/carrier/X = owner
	X.throw_hugger(A)
	return ..()

/datum/action/xeno_action/activable/throw_hugger/process_ai(mob/living/carbon/xenomorph/X, delta_time)
	var/distance = get_dist(X, X.current_target)
	if(!DT_PROB(ai_prob_chance, delta_time) || distance < 3 || distance > 8)
		return

	use_ability_async(X.current_target)

/datum/action/xeno_action/activable/retrieve_egg/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/carrier/X = owner
	X.retrieve_egg(A)
	return ..()

/datum/action/xeno_action/onclick/set_hugger_reserve/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/carrier/carrier = owner
	carrier.huggers_reserved = tgui_input_number(usr,
		"你想预留多少只抱脸虫，以免它们被想作为抱脸虫加入的观察者占用？",
		"预留数量",
		carrier.huggers_reserved, carrier.huggers_max, 0
	)
	to_chat(carrier, SPAN_XENONOTICE("我们为自己预留了[carrier.huggers_reserved]只抱脸虫。"))
	return ..()
