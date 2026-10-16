/datum/xeno_strain/eggsac
	name = CARRIER_EGGSAC
	localized_name = "卵囊"
	description = "你失去储存抱脸虫和布置陷阱的能力，换取更大的等离子体容量、强力信息素，以及消耗等离子体产卵的能力。此外，你能同时携带十二枚卵，并能在比通常更远一格的位置放置卵。\n\n你也能在普通菌毯上放置少量脆弱的卵。只要你保持在十四格内，这些卵可存活五分钟；离开范围后只能存活一分钟。"
	flavor_description = "每一枚卵都是一次冒险，下一枚也许会有所不同。"
	icon_state_prefix = "Eggsac"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/retrieve_egg, // readding it so it gets at the end of the ability list
		/datum/action/xeno_action/onclick/set_hugger_reserve,
	)
	actions_to_add = list(
		/datum/action/xeno_action/active_toggle/generate_egg,
		/datum/action/xeno_action/activable/retrieve_egg, // readding it so it gets at the end of the ability list
	)

	behavior_delegate_type = /datum/behavior_delegate/carrier_eggsac

/datum/xeno_strain/eggsac/apply_strain(mob/living/carbon/xenomorph/carrier/carrier)
	carrier.plasma_types = list(PLASMA_EGG)
	carrier.phero_modifier += XENO_PHERO_MOD_LARGE // praetorian level pheremones
	carrier.recalculate_plasma()
	carrier.recalculate_pheromones()

	if(carrier.huggers_cur)
		playsound(carrier.loc, 'sound/voice/alien_facehugger_dies.ogg', 25, TRUE)
	carrier.huggers_cur = 0
	carrier.huggers_max = 0
	carrier.update_hugger_overlays()
	carrier.eggs_max = 12
	carrier.egg_planting_range = 2
	carrier.update_eggsac_overlays()

#define EGGSAC_OFF_WEED_EGGCAP 4
#define EGGSAC_EGG_SUSTAIN_DISTANCE 14

/datum/behavior_delegate/carrier_eggsac
	name = "Eggsac Carrier Behavior Delegate"
	///List of /obj/effect/alien/egg/carrier_egg sustained by the carrier on normal weeds
	var/list/eggs_sustained = list()
	///Total number of eggs which can be sustained defined as EGGSAC_OFF_WEED_EGGCAP
	var/egg_sustain_cap = EGGSAC_OFF_WEED_EGGCAP
	///Distance from the egg that the carrier can go before it stops sustaining it
	var/sustain_distance = EGGSAC_EGG_SUSTAIN_DISTANCE

/datum/behavior_delegate/carrier_eggsac/append_to_stat()
	. = list()
	. += "维持中的卵：[length(eggs_sustained)] / [egg_sustain_cap]"

/datum/behavior_delegate/carrier_eggsac/on_update_icons()
	var/mob/living/carbon/xenomorph/carrier/bound_carrier = bound_xeno
	bound_carrier.update_eggsac_overlays()

/datum/behavior_delegate/carrier_eggsac/on_life()
	if(length(eggs_sustained) > egg_sustain_cap)
		var/obj/effect/alien/egg/carrier_egg/my_egg = eggs_sustained[1]
		if(my_egg)
			remove_egg_owner(my_egg)
			my_egg.start_unstoppable_decay()
			to_chat(bound_xeno, SPAN_XENOWARNING("你最多只能维持[egg_sustain_cap]枚位于虫巢菌毯之外的卵！最早放置的卵正在迅速衰败。"))

	for(var/obj/effect/alien/egg/carrier_egg/my_egg as anything in eggs_sustained)
		//Get the distance from us to our sustained egg
		if(get_dist(bound_xeno, my_egg) <= sustain_distance)
			my_egg.last_refreshed = world.time
		else
			my_egg.check_decay()

///Remove owner of egg
/datum/behavior_delegate/carrier_eggsac/proc/remove_egg_owner(obj/effect/alien/egg/carrier_egg/egg)
	if(!egg.owner || egg.owner != bound_xeno)
		return
	eggs_sustained -= egg
	egg.owner = null

/datum/behavior_delegate/carrier_eggsac/handle_death(mob/M)
	for(var/obj/effect/alien/egg/carrier_egg/my_egg as anything in eggs_sustained)
		remove_egg_owner(my_egg)
		my_egg.start_unstoppable_decay()

	M.visible_message(SPAN_XENOWARNING("[M]痛苦地抽搐，卵囊爆裂成一摊酸液！"))
	playsound(M.loc, 'sound/effects/alien_egg_burst.ogg', 25, TRUE)

///Remove all references to src in eggs_sustained
/datum/behavior_delegate/carrier_eggsac/Destroy()
	for(var/obj/effect/alien/egg/carrier_egg/my_egg as anything in eggs_sustained)
		my_egg.owner = null
	return ..()

/datum/action/xeno_action/active_toggle/generate_egg
	name = "Generate Eggs (50)"
	localized_names = list("Generate Eggs (50)" = "产卵（50）")
	action_icon_state = "lay_egg"
	ability_name = "generate egg"
	action_type = XENO_ACTION_CLICK
	plasma_cost = 50
	plasma_use_per_tick = 15

	action_start_message = "你开始孕育异形卵。"
	action_end_message = "我们没有足够的等离子体继续产卵。"
	var/egg_generation_progress = 0

	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/active_toggle/generate_egg/should_use_plasma()
	. = FALSE
	var/mob/living/carbon/xenomorph/carrier/xeno = owner
	if(!xeno)
		return
	if(xeno.eggs_cur < xeno.eggs_max)
		return TRUE

/datum/action/xeno_action/active_toggle/generate_egg/life_tick()
	. = ..()
	if(.)
		var/mob/living/carbon/xenomorph/carrier/xeno = owner
		if(!xeno)
			return
		if(xeno.eggs_cur < xeno.eggs_max)
			egg_generation_progress++
			if(egg_generation_progress >= 15)
				egg_generation_progress = 0
				xeno.eggs_cur++
				to_chat(xeno, SPAN_XENONOTICE("我们产出了一枚卵。当前储存：[xeno.eggs_cur] / [xeno.eggs_max]。"))
				xeno.update_icons()

#undef EGGSAC_OFF_WEED_EGGCAP
#undef EGGSAC_EGG_SUSTAIN_DISTANCE
