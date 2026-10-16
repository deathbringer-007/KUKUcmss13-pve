
/datum/reagent/stimulant
	reagent_state = LIQUID
	custom_metabolism = AMOUNT_PER_TIME(1, 1 MINUTES) // Consumes 1 unit per minute.
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_NONE
	flags = REAGENT_SCANNABLE | REAGENT_TYPE_STIMULANT
	var/jitter_speed = 0.3 SECONDS
	var/jitter_per_amount = 2
	var/jitter = 2

/datum/reagent/stimulant/on_mob_life(mob/living/M, alien, delta_time)
	. = ..()
	// Stimulants drain faster for each stimulant in the drug.
	// Having 2 stimulants means the duration will be 2x shorter, having 3 will be 3x shorter, etc
	if(holder)
		for(var/datum/reagent/R in holder.reagent_list)
			if(R == src)
				continue

			if(R.flags & REAGENT_TYPE_STIMULANT)
				holder.remove_reagent(R, custom_metabolism)

	// We multiply delta_time by 1.5 so that it looks like it is consistent.
	var/time_per_animate = (jitter_speed/(jitter_per_amount + 2))

	animate(M, pixel_x = rand(-jitter, jitter), pixel_y = rand(-jitter, jitter), time = time_per_animate, flags=ANIMATION_END_NOW)
	for(var/i in 1 to jitter_per_amount)
		animate(pixel_x = rand(-jitter, jitter), pixel_y = rand(-jitter, jitter), time = time_per_animate)
	animate(pixel_x = 0, pixel_y = 0, time = time_per_animate)

/datum/reagent/stimulant/speed_stimulant
	name = "Speed Stimulant"
	localized_name = "疾速兴奋剂"
	id = "speed_stimulant"
	description = "一种用于增强身体机能的高度实验性兴奋剂，不会成瘾。"
	color = "#ffff00"
	properties = list(
		PROPERTY_MUSCLESTIMULATING = 40,
		PROPERTY_PAINKILLING = 3,
	)

/datum/reagent/stimulant/brain_stimulant
	name = "Brain Stimulant"
	localized_name = "脑部兴奋剂"
	id = "brain_stimulant"
	description = "一种高度实验性的中枢神经兴奋剂。"
	color = "#a800ff"
	properties = list(
		PROPERTY_NERVESTIMULATING = 30,
		PROPERTY_PAINKILLING = 6,
		PROPERTY_NEUROSHIELDING = 13,
	)

/datum/reagent/stimulant/redemption_stimulant
	name = "Redemption Stimulant"
	localized_name = "救赎兴奋剂"
	id = "redemption_stimulant"
	overdose = LOW_REAGENTS_OVERDOSE
	overdose_critical = LOW_REAGENTS_OVERDOSE_CRITICAL
	description = {"\
		一种高度实验性的骨骼、器官和肌肉兴奋剂。\
		可增强皮肤和骨骼的耐受能力，并消除一切疼痛。\
		只要药物还在体内，就无法感受到疼痛。\
		药物代谢期间，功能失常的器官也能正常运作。"}
	color = "#00ffa8"
	properties = list(
		PROPERTY_NERVESTIMULATING = 2,
		PROPERTY_MUSCLESTIMULATING = 2,
		PROPERTY_PAINKILLING = 100,
		PROPERTY_BONEMENDING = 100,
		PROPERTY_ORGAN_HEALING = 100,
		PROPERTY_HYPERDENSIFICATING = 1,
		PROPERTY_ORGANSTABILIZE = 1,
	)
