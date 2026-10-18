/datum/chem_property/neutral
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_IRRITANT
	value = -1

/datum/chem_property/neutral/cryometabolizing
	name = PROPERTY_CRYOMETABOLIZING
	code = "CMB"
	description = "温度高于170开尔文时，这种化学品只会被动代谢，不产生其他效果。温度低于此值时，其代谢效果会增强。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE
	value = 1

/datum/chem_property/neutral/cryometabolizing/pre_process(mob/living/M)
	if(M.bodytemperature > 170)
		return list(REAGENT_CANCEL = TRUE)
	return list(REAGENT_BOOST = POTENCY_MULTIPLIER_LOW * level)

/datum/chem_property/neutral/thanatometabolizing
	name = PROPERTY_THANATOMETABOL
	code = "TMB"
	description = "这种化学品需要在低氧或低血流状态下才能发挥作用。该特性的效力会影响其他特性的效率。"
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_METABOLITE
	value = 1

/datum/chem_property/neutral/thanatometabolizing/pre_process(mob/living/M)
	if(M.stat != DEAD && M.oxyloss < 50 && floor(M.blood_volume) > BLOOD_VOLUME_OKAY)
		return list(REAGENT_CANCEL = TRUE)
	var/effectiveness = 1
	if(M.stat != DEAD)
		effectiveness = clamp(max(M.oxyloss / 10, (BLOOD_VOLUME_NORMAL - M.blood_volume) / BLOOD_VOLUME_NORMAL) * 0.1 * level, 0.1, 1)
	return list(REAGENT_FORCE = TRUE, REAGENT_EFFECT = effectiveness)

/datum/chem_property/neutral/excreting
	name = PROPERTY_EXCRETING
	code = "EXT"
	description = "利用肾脏将血液中的所有化学物质转化为尿液并排出体外。"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT

/datum/chem_property/neutral/excreting/pre_process(mob/living/M)
	return list(REAGENT_PURGE = level)

/datum/chem_property/neutral/nutritious
	name = PROPERTY_NUTRITIOUS
	code = "NTR"
	description = "这种化合物可直接作为营养，或被分解为供细胞代谢使用的营养物质。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE
	value = 0

/datum/chem_property/neutral/nutritious/pre_process(mob/living/M)
	if(M.stat == DEAD)
		return

	if(M.nutrition + (holder.nutriment_factor * level) >= NUTRITION_MAX)
		M.nutrition = NUTRITION_MAX
		return
	else
		M.nutrition += holder.nutriment_factor * level

/datum/chem_property/neutral/nutritious/reset_reagent()
	holder.nutriment_factor = initial(holder.nutriment_factor)
	..()

/datum/chem_property/neutral/nutritious/update_reagent()
	holder.nutriment_factor += level
	..()

/datum/chem_property/neutral/ketogenic
	name = PROPERTY_KETOGENIC
	code = "KTG"
	description = "启动酮症，使肝脏快速燃烧体内的脂肪酸和酒精，从而减轻体重。浓度过高可能引发酮症酸中毒，导致酸性物质积累、血液pH值降低。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE

/datum/chem_property/neutral/ketogenic/process(mob/living/M, potency = 1)
	M.nutrition = max(M.nutrition - POTENCY_MULTIPLIER_VHIGH * potency, 0)
	M.overeatduration = 0
	if(M.reagents.remove_all_type(/datum/reagent/ethanol, potency, 0, 1)) //Ketosis causes rapid metabolization of alcohols
		M.confused = min(M.confused + potency,10*potency)
		M.drowsyness = min(M.drowsyness + potency,15*potency)

/datum/chem_property/neutral/ketogenic/process_overdose(mob/living/M, potency = 1, delta_time)
	M.nutrition = max(M.nutrition - 5 * potency * delta_time, 0)
	M.apply_damage(potency, TOX)
	if(prob(2.5 * potency * delta_time) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.vomit()

/datum/chem_property/neutral/ketogenic/process_critical(mob/living/M, potency = 1, delta_time)
	M.apply_effect(20, PARALYZE)

/datum/chem_property/neutral/neuroinhibiting
	name = PROPERTY_NEUROINHIBITING
	code = "NIH"
	description = "抑制大脑中与视觉、听觉和语言有关的神经活动，可能造成相应残疾。需要手术才能恢复。"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_TOXICANT
	value = -1
	max_level = 7

/datum/chem_property/neutral/neuroinhibiting/process(mob/living/M, potency = 1, delta_time)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
			return
	if(potency > 1)
		M.sdisabilities |= DISABILITY_BLIND
	else
		M.disabilities |= NEARSIGHTED
	if(potency > 2)
		M.sdisabilities |= DISABILITY_DEAF
	if(potency > 3)
		M.sdisabilities |= DISABILITY_MUTE

/datum/chem_property/neutral/neuroinhibiting/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, BRAIN)
	M.disabilities |= NERVOUS

/datum/chem_property/neutral/neuroinhibiting/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_MEDIUM * potency, BRAIN)

/datum/chem_property/neutral/alcoholic
	name = PROPERTY_ALCOHOLIC
	code = "AOL"
	description = "与谷氨酸神经递质和γ-氨基丁酸（GABA）结合，减缓大脑对刺激的反应。这种效果也称为醉酒。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT
	value = 0

/datum/chem_property/neutral/alcoholic/process(mob/living/mob, potency = 1, delta_time)
	if(ishuman(mob))
		var/mob/living/carbon/human/human = mob
		if(human.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
			return

	mob.dizziness = min(mob.dizziness + POTENCY_MULTIPLIER_VVLOW * potency * delta_time, POTENCY_MULTIPLIER_VHIGH * potency)
	mob.drowsyness = min(mob.drowsyness + POTENCY_MULTIPLIER_LOW * potency * delta_time, POTENCY_MULTIPLIER_VHIGH * potency)

	if(prob(50 * delta_time) || potency >= 5)
		mob.confused = min(mob.confused + POTENCY_MULTIPLIER_LOW * potency * delta_time, POTENCY_MULTIPLIER_VHIGH * potency)
		mob.slurring = min(mob.slurring + POTENCY_MULTIPLIER_VLOW * potency * delta_time, POTENCY_MULTIPLIER_VHIGH * potency)

/datum/chem_property/neutral/alcoholic/process_overdose(mob/living/mob, potency = 1, delta_time)
	mob.apply_damage(POTENCY_MULTIPLIER_VLOW * potency * delta_time, TOX)
	mob.apply_damage(POTENCY_MULTIPLIER_LOW * potency * delta_time, OXY)

	mob.dizziness = min(mob.dizziness + POTENCY_MULTIPLIER_VLOW * potency * delta_time, POTENCY_MULTIPLIER_HIGHEXTREMEINTER * potency)
	mob.drowsyness = min(mob.drowsyness + potency * delta_time, POTENCY_MULTIPLIER_HIGHEXTREMEINTER * potency)

	if(prob(POTENCY_MULTIPLIER_MEDIUM * delta_time))
		mob.sleeping = min(mob.sleeping + POTENCY_MULTIPLIER_LOW * potency * delta_time, POTENCY_MULTIPLIER_HIGHEXTREMEINTER * potency)

	if(prob(POTENCY_MULTIPLIER_MEDIUM * potency * delta_time) && ishuman(mob))
		var/mob/living/carbon/human/human = mob
		human.vomit()

	if(prob(75 * delta_time) || potency >= 5)
		mob.confused = min(mob.confused + potency * delta_time, POTENCY_MULTIPLIER_HIGHEXTREMEINTER * potency)
		mob.slurring = min(mob.slurring + POTENCY_MULTIPLIER_LOW * potency * delta_time, POTENCY_MULTIPLIER_HIGHEXTREMEINTER * potency)

/datum/chem_property/neutral/alcoholic/process_critical(mob/living/mob, potency = 1, delta_time)
	mob.apply_damage(POTENCY_MULTIPLIER_VVLOW * potency * delta_time, TOX)
	mob.apply_damage(POTENCY_MULTIPLIER_VLOW * potency * delta_time, OXY)

	mob.confused = min(mob.confused + POTENCY_MULTIPLIER_MEDIUM * potency * delta_time, POTENCY_MULTIPLIER_EXTREME * potency)
	mob.dizziness = min(mob.dizziness + POTENCY_MULTIPLIER_LOW * potency * delta_time, POTENCY_MULTIPLIER_EXTREME * potency)
	mob.drowsyness = min(mob.drowsyness + POTENCY_MULTIPLIER_MEDIUM * potency * delta_time, POTENCY_MULTIPLIER_EXTREME * potency)
	mob.slurring = min(mob.slurring + potency * delta_time, POTENCY_MULTIPLIER_EXTREME * potency)

	if(prob(POTENCY_MULTIPLIER_VHIGH * potency * delta_time))
		mob.sleeping = min(mob.sleeping + POTENCY_MULTIPLIER_LOW * potency * delta_time, POTENCY_MULTIPLIER_EXTREME * potency)

	if(prob(POTENCY_MULTIPLIER_VHIGH * potency * delta_time) && ishuman(mob))
		var/mob/living/carbon/human/human = mob
		human.vomit()

	if(ishuman(mob))
		var/mob/living/carbon/human/human = mob
		var/datum/internal_organ/liver/liver = human.internal_organs_by_name["liver"]
		if(liver)
			liver.take_damage(POTENCY_MULTIPLIER_VLOW * potency, TRUE)

/datum/chem_property/neutral/hallucinogenic
	name = PROPERTY_HALLUCINOGENIC
	code = "HLG"
	description = "在没有外界刺激的情况下产生类似真实感知的体验。这些体验生动清晰，具有正常感知的强度和影响，却不受意志控制。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/hallucinogenic/process(mob/living/M, potency = 1, delta_time)
	if(prob(5 * delta_time))
		M.emote(pick("twitch","drool","moan","giggle"))
	if(potency > CREATE_MAX_TIER_1)
		M.hallucination = min(M.hallucination + potency, potency * 10)
		M.make_jittery(5)
	M.druggy = min(M.druggy + 0.5 * potency * delta_time, potency * 10)

/datum/chem_property/neutral/hallucinogenic/process_overdose(mob/living/M, potency = 1, delta_time)
	if(isturf(M.loc) && !istype(M.loc, /turf/open/space) && (M.mobility_flags & MOBILITY_MOVE) && !M.is_mob_restrained())
		step(M, pick(GLOB.cardinals))
	M.hallucination += 10
	M.make_jittery(5)

/datum/chem_property/neutral/hallucinogenic/process_critical(mob/living/M, potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, BRAIN)
	M.apply_effect(20, PARALYZE)

/datum/chem_property/neutral/relaxing
	name = PROPERTY_RELAXING
	code = "RLX"
	description = "镇静神经肌肉接头，减弱肌肉收缩力。浓度过高可能引发呼吸衰竭和心脏骤停。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/relaxing/process(mob/living/M, potency = 1, delta_time)
	M.reagent_move_delay_modifier += potency
	if(prob(5 * delta_time))
		M.emote("yawn")
	M.recalculate_move_delay = TRUE

/datum/chem_property/neutral/relaxing/process_overdose(mob/living/M, potency = 1, delta_time)
	//heart beats slower
	M.reagent_move_delay_modifier += POTENCY_MULTIPLIER_MEDIUM * potency
	if(prob(10))
		to_chat(M, SPAN_WARNING("你感到极度虚弱！"))

/datum/chem_property/neutral/relaxing/process_critical(mob/living/M, potency = 1, delta_time)
	//heart stops beating, lungs stop working
	if(prob(7.5 * potency * delta_time))
		M.apply_effect(potency, PARALYZE)
	M.apply_damage(0.5 * potency * delta_time, OXY)
	if(prob(2.5 * delta_time))
		to_chat(M, SPAN_WARNING("你几乎喘不过气！"))
	M.apply_internal_damage(POTENCY_MULTIPLIER_LOW * potency, "heart")

/datum/chem_property/neutral/hyperthermic
	name = PROPERTY_HYPERTHERMIC
	code = "HPR"
	description = "在体内代谢时发生放热反应，提高核心体温。警告：此反应可能点燃化学品。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_METABOLITE
	volatile = TRUE

/datum/chem_property/neutral/hyperthermic/process(mob/living/M, potency = 1, delta_time)
	if(prob(5 * delta_time))
		M.emote("gasp")
		to_chat(M, SPAN_DANGER("<b>你的体内热得难受！</b>"))
	M.bodytemperature = max(M.bodytemperature + POTENCY_MULTIPLIER_MEDIUM * potency,0)
	if(potency >= CREATE_MAX_TIER_1)
		M.make_dizzy(potency * POTENCY_MULTIPLIER_MEDIUM)
		M.apply_effect(potency,AGONY,0)
	M.recalculate_move_delay = TRUE

/datum/chem_property/neutral/hyperthermic/process_overdose(mob/living/M, potency = 1)
	M.bodytemperature = max(M.bodytemperature + POTENCY_MULTIPLIER_VHIGH * potency,0)
	M.apply_effect(POTENCY_MULTIPLIER_MEDIUM * potency,AGONY,0)

/datum/chem_property/neutral/hyperthermic/process_critical(mob/living/M, potency = 1, delta_time)
	M.apply_effect(20, PARALYZE)

/datum/chem_property/neutral/hypothermic
	name = PROPERTY_HYPOTHERMIC
	code = "HPO"
	description = "在体内代谢时发生吸热反应，降低核心体温。"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_METABOLITE

/datum/chem_property/neutral/hypothermic/process(mob/living/M, potency = 1, delta_time)
	if(prob(5 * delta_time * potency))
		M.emote("shiver")
	if(ishuman(M))
		var/mob/living/carbon/human/human_becoming_cold = M
		human_becoming_cold.bodytemperature = max(human_becoming_cold.bodytemperature - POTENCY_MULTIPLIER_MEDIUM * potency, ((potency < 1) ? human_becoming_cold.species.body_temperature : 0))
	else
		M.bodytemperature = max(M.bodytemperature - POTENCY_MULTIPLIER_MEDIUM * potency, ((potency < 1) ? 309 : 0))
	M.recalculate_move_delay = TRUE

/datum/chem_property/neutral/hypothermic/process_overdose(mob/living/M, potency = 1)
	if(ishuman(M))
		var/mob/living/carbon/human/human_becoming_cold = M
		human_becoming_cold.bodytemperature = max(human_becoming_cold.bodytemperature - POTENCY_MULTIPLIER_VHIGH * potency, ((potency < 1) ? human_becoming_cold.species.body_temperature : 0))
	else
		M.bodytemperature = max(M.bodytemperature - POTENCY_MULTIPLIER_VHIGH * potency, ((potency < 1) ? 309 : 0))
	if(potency < 1)
		M.dizziness = max(M.dizziness, 130)
	else
		M.drowsyness  = max(M.drowsyness, 30)

/datum/chem_property/neutral/hypothermic/process_critical(mob/living/M, potency = 1, delta_time)
	if(potency < 1)
		M.apply_effect(20, PARALYZE)
	else
		M.apply_effect(20, DAZE)


/datum/chem_property/neutral/balding
	name = PROPERTY_BALDING
	code = "BLD"
	description = "损伤皮肤中的毛囊，引发严重脱发，也就是秃头。"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT
	value = 0
	max_level = 2

/datum/chem_property/neutral/balding/process(mob/living/M, potency = 1, delta_time)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if((H.h_style != "Bald" || H.f_style != "Shaved"))
			to_chat(M, SPAN_WARNING("你的头发脱落了！"))
			H.h_style = "Bald"
			H.f_style = "Shaved"
			H.update_hair()

/datum/chem_property/neutral/balding/process_overdose(mob/living/M, potency = 1)
	M.adjustCloneLoss(POTENCY_MULTIPLIER_LOW * potency)

/datum/chem_property/neutral/balding/process_critical(mob/living/M, potency = 1, delta_time)
	M.adjustCloneLoss(0.5 * potency * delta_time)

/datum/chem_property/neutral/fluffing
	name = PROPERTY_FLUFFING
	code = "FLF"
	description = "加速毛囊中的细胞分裂，导致毛发随机、过度生长。"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT
	value = 0

/datum/chem_property/neutral/fluffing/process(mob/living/M, potency = 1, delta_time)
	if(prob(2.5 * potency * delta_time) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.h_style = "Bald"
		H.f_style = "Shaved"
		H.h_style = pick(GLOB.hair_styles_list)
		H.f_style = pick(GLOB.facial_hair_styles_list)
		H.update_hair()
		to_chat(M, SPAN_NOTICE("你的头感觉有些不一样……"))

/datum/chem_property/neutral/fluffing/process_overdose(mob/living/M, potency = 1, delta_time)
	if(prob(2.5 * potency * delta_time))
		to_chat(M, SPAN_WARNING("你浑身发痒！"))
		M.take_limb_damage(potency) //Hair growing inside your body

/datum/chem_property/neutral/fluffing/process_critical(mob/living/M, potency = 1, delta_time)
	to_chat(M, SPAN_WARNING("你感觉有什么东西正刺入头骨！"))
	M.apply_damage(0.5 * potency * delta_time, BRAIN) //Hair growing into brain

/datum/chem_property/neutral/allergenic
	name = PROPERTY_ALLERGENIC
	code = "ALG"
	description = "引发过度免疫反应，造成刺激症状。"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT
	value = 0

/datum/chem_property/neutral/allergenic/process(mob/living/M, potency = 1)
	if(prob(POTENCY_MULTIPLIER_VHIGH * potency))
		M.emote(pick("sneeze","blink","cough"))

/datum/chem_property/neutral/euphoric
	name = PROPERTY_EUPHORIC
	code = "EPH"
	description = "促使内啡肽释放，产生强烈的兴奋感和愉悦感。"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_STIMULANT
	value = 1

/datum/chem_property/neutral/euphoric/on_delete(mob/living/M)
	..()

	M.pain.reset_pain_reduction()

/datum/chem_property/neutral/euphoric/process(mob/living/M, potency = 1, delta_time)
	if(!..())
		return

	M.pain.apply_pain_reduction(PAIN_REDUCTION_MULTIPLIER * potency) //Endorphins are natural painkillers
	if(prob(POTENCY_MULTIPLIER_VHIGH * potency))
		M.emote(pick("laugh","giggle","chuckle","grin","smile","twitch"))

/datum/chem_property/neutral/euphoric/process_overdose(mob/living/M, potency = 1)
	if(prob(POTENCY_MULTIPLIER_VHIGH * potency))
		M.emote("collapse") //ROFL

/datum/chem_property/neutral/euphoric/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)
	to_chat(M, SPAN_WARNING("你笑得喘不过气！"))

/datum/chem_property/neutral/emetic
	name = PROPERTY_EMETIC
	code = "EME"
	description = "作用于肠神经系统，诱发呕吐，使胃内容物被强行排空。"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_IRRITANT

/datum/chem_property/neutral/emetic/process(mob/living/M, potency = 1, delta_time)
	if(prob(0.5 * holder.volume * potency * delta_time) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.vomit() //vomit() already has a timer on in

/datum/chem_property/neutral/emetic/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_LOW * potency, TOX)

/datum/chem_property/neutral/emetic/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_LOW * potency, TOX)

/datum/chem_property/neutral/psychostimulating
	name = PROPERTY_PSYCHOSTIMULATING
	code = "PST"
	description = "刺激心理活动，提高感知力与专注度，并产生抗抑郁效果。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT
	value = 0
	max_level = 7

/datum/chem_property/neutral/psychostimulating/process(mob/living/M, potency = 1, delta_time)
	if(holder.volume <= 0.1 && holder.data != -1)
		holder.data = -1
		if(potency == 1)
			to_chat(M, SPAN_WARNING("你的精神似乎有点不稳定了……"))
		else if(potency == 2)
			to_chat(M, SPAN_WARNING("你的注意力开始涣散……"))
		else if(potency == 3)
			to_chat(M, SPAN_WARNING("你的精神似乎更加不稳定了……"))
		else
			to_chat(M, SPAN_WARNING("你失去了原本完美的专注……"))
	else
		if(world.time > holder.data + ANTIDEPRESSANT_MESSAGE_DELAY)
			holder.data = world.time
			if(potency == 1)
				to_chat(M, SPAN_NOTICE("你的精神感觉稳定了……稍微稳定了一些。"))
				M.confused = max(M.confused-1,0)
			else if(potency == 2)
				to_chat(M, SPAN_NOTICE("你的思绪专注而统一。"))
				M.confused = max(M.confused-2,0)
			else if(potency == 3)
				to_chat(M, SPAN_NOTICE("你的精神稳定多了。"))
				M.confused = max(M.confused-3,0)
			else
				to_chat(M, SPAN_NOTICE("你的注意力无比集中。"))
				M.confused = 0

/datum/chem_property/neutral/psychostimulating/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, BRAIN)

/datum/chem_property/neutral/psychostimulating/process_critical(mob/living/M, potency = 1, delta_time)
	M.hallucination = min(200, M.hallucination)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, BRAIN)

/datum/chem_property/neutral/antihallucinogenic
	name = PROPERTY_ANTIHALLUCINOGENIC
	code = "AHL"
	description = "缓解摧心毒素引发的幻觉等感知异常。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT
	value = 1

/datum/chem_property/neutral/antihallucinogenic/process(mob/living/M, potency = 1)
	M.reagents.remove_reagent("mindbreaker", 5)
	M.reagents.remove_reagent("space_drugs", 5)
	M.hallucination = max(0, M.hallucination - POTENCY_MULTIPLIER_EXTREME * potency)
	M.druggy = max(0, M.druggy - POTENCY_MULTIPLIER_EXTREME * potency)

/datum/chem_property/neutral/antihallucinogenic/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, TOX)

/datum/chem_property/neutral/antihallucinogenic/process_critical(mob/living/M, potency = 1)
	M.apply_damages(potency, potency, POTENCY_MULTIPLIER_HIGH * potency)

/datum/chem_property/neutral/hypometabolic
	name = PROPERTY_HYPOMETABOLIC
	code = "OMB"
	description = "延长这种化学品的代谢时间，使每单位药剂在血液中停留得更久。"
	rarity = PROPERTY_UNCOMMON
	category = PROPERTY_TYPE_METABOLITE
	value = 2

/datum/chem_property/neutral/hypometabolic/reset_reagent()
	holder.custom_metabolism = initial(holder.custom_metabolism)
	..()

/datum/chem_property/neutral/hypometabolic/update_reagent()
	holder.custom_metabolism = max(holder.custom_metabolism / (1 + 0.35 * level), 0.005)
	..()

/datum/chem_property/neutral/sedative
	name = PROPERTY_SEDATIVE
	code = "SDT"
	description = "促使身体释放褪黑素，加重困意。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT

/datum/chem_property/neutral/sedative/process(mob/living/M, potency = 1, delta_time)
	if(M.confused < 25 && M.sleeping < 20)
		M.confused += POTENCY_MULTIPLIER_MEDIUM * potency
	if(M.confused > 25)
		M.AdjustSleeping(POTENCY_MULTIPLIER_MEDIUM * potency)
		M.confused -= POTENCY_MULTIPLIER_MEDIUM * potency //so when they wake up they aren't still confused
	else if(prob(25))
		M.emote("yawn")

/datum/chem_property/neutral/sedative/process_overdose(mob/living/M, potency = 1, delta_time)
	M.adjust_effect(0.5 * potency * delta_time, PARALYZE)

/datum/chem_property/neutral/sedative/process_critical(mob/living/M, potency = 1)
	M.apply_damage(POTENCY_MULTIPLIER_VHIGH * potency, OXY)

/datum/chem_property/neutral/hyperthrottling
	name = PROPERTY_HYPERTHROTTLING
	code = "HTR"
	description = "使大脑以正常速度的数千倍运转。出于某种原因，即使原本不懂某种语言，也能理解面前所说的所有语言。"
	rarity = PROPERTY_RARE
	category = PROPERTY_TYPE_STIMULANT
	value = 3

/datum/chem_property/neutral/hyperthrottling/process(mob/living/M, potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	M.reagent_move_delay_modifier += POTENCY_MULTIPLIER_HIGH * potency
	M.recalculate_move_delay = TRUE
	M.druggy = min(M.druggy + 0.5 * potency * delta_time, 10)
	if(H.chem_effect_flags & CHEM_EFFECT_HYPER_THROTTLE)
		return
	H.chem_effect_flags |= CHEM_EFFECT_HYPER_THROTTLE
	to_chat(M, SPAN_NOTICE("你仿佛置身梦境，整个世界似乎静止了。"))
	M.universal_understand = TRUE //Brain is working so fast it can understand the intension of everything it hears

/datum/chem_property/neutral/hyperthrottling/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(1.5 * potency * delta_time, BRAIN)

/datum/chem_property/neutral/hyperthrottling/process_critical(mob/living/M, potency = 1, delta_time)
	M.apply_effect(potency * delta_time, PARALYZE)

/datum/chem_property/neutral/encephalophrasive
	name = PROPERTY_ENCEPHALOPHRASIVE
	code = "ESP"
	description = "大幅提高γ和β脑波的振幅，使宿主能够广播自己的思维。"
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_STIMULANT
	value = 8

/datum/chem_property/neutral/encephalophrasive/on_delete(mob/living/chem_host)
	..()

	chem_host.pain.recalculate_pain()
	remove_action(chem_host, /datum/action/human_action/psychic_whisper)
	to_chat(chem_host, SPAN_NOTICE("头痛消退，你却感到一种奇怪的孤独。"))

/datum/chem_property/neutral/encephalophrasive/reaction_mob(mob/chem_host, method=INGEST, volume, potency)
	give_action(chem_host, /datum/action/human_action/psychic_whisper)
	to_chat(chem_host, SPAN_NOTICE("剧烈头痛袭来，随后你突然觉得自己的意识离开了头骨。"))

/datum/chem_property/neutral/encephalophrasive/process(mob/living/chem_host, potency = 1, delta_time)
	chem_host.pain.apply_pain(1 * potency)

/datum/chem_property/neutral/encephalophrasive/process_overdose(mob/living/chem_host, potency = 1, delta_time)
	chem_host.apply_damage(0.5 * potency * POTENCY_MULTIPLIER_VHIGH * delta_time, BRAIN)

/datum/chem_property/neutral/encephalophrasive/process_critical(mob/living/chem_host, potency = 1, delta_time)
	chem_host.apply_effect(20, PARALYZE)

/datum/chem_property/neutral/viscous
	name = PROPERTY_VISCOUS
	code = "VIS"
	description = "这种化学品表面张力较高，质地浓稠黏滞，泼洒后不会扩散太远，可缩小化学火焰的范围。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_COMBUSTIBLE

/datum/chem_property/neutral/viscous/reset_reagent()
	holder.chemfiresupp = initial(holder.chemfiresupp)
	holder.radiusmod = initial(holder.radiusmod)
	..()

/datum/chem_property/neutral/viscous/update_reagent()
	holder.chemfiresupp = TRUE
	holder.radiusmod -= 0.025 * level
	..()

//PROPERTY_DISABLED (in generation)
/datum/chem_property/neutral/thermostabilizing
	name = PROPERTY_THERMOSTABILIZING
	code = "TSL"
	description = "在血液中同时引发吸热与放热反应，以稳定核心体温。"
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_REACTANT
	value = 1

/datum/chem_property/neutral/thermostabilizing/process(mob/living/M, potency = 1, delta_time)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (20 * potency * delta_time * TEMPERATURE_DAMAGE_COEFFICIENT))
		M.recalculate_move_delay = TRUE
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (20 * potency * delta_time * TEMPERATURE_DAMAGE_COEFFICIENT))
		M.recalculate_move_delay = TRUE

/datum/chem_property/neutral/thermostabilizing/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_effect(20, PARALYZE)

/datum/chem_property/neutral/thermostabilizing/process_critical(mob/living/M, potency = 1, delta_time)
	M.drowsyness  = max(M.drowsyness, 30)

/datum/chem_property/neutral/focusing
	name = PROPERTY_FOCUSING
	code = "FCS"
	description = "清除血液中的常见酒精类物质，并提高专注力。"
	rarity = PROPERTY_COMMON
	category = PROPERTY_TYPE_STIMULANT
	value = 0

/datum/chem_property/neutral/focusing/process(mob/living/M, potency = 1)
	M.reagents.remove_all_type(/datum/reagent/ethanol, potency, 0, 1)
	M.stuttering = max(M.stuttering - POTENCY_MULTIPLIER_MEDIUM * potency, 0)
	M.confused = max(M.confused - POTENCY_MULTIPLIER_MEDIUM * potency, 0)
	M.ReduceEyeBlur(POTENCY_MULTIPLIER_MEDIUM * potency)
	M.drowsyness = max(M.drowsyness - POTENCY_MULTIPLIER_MEDIUM * potency, 0)
	M.dizziness = max(M.dizziness - POTENCY_MULTIPLIER_MEDIUM * potency, 0)
	M.jitteriness = max(M.jitteriness - POTENCY_MULTIPLIER_MEDIUM * potency, 0)
	if(potency >= POTENCY_MAX_TIER_1)
		M.SetEyeBlind(0)
		M.silent = 0

/datum/chem_property/neutral/focusing/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(potency, TOX)

/datum/chem_property/neutral/focusing/process_critical(mob/living/M, potency = 1)
	M.apply_damage(potency * POTENCY_MULTIPLIER_HIGH, TOX)

/datum/chem_property/neutral/transformative
	name = PROPERTY_TRANSFORMATIVE
	code = "TRF"
	description = "修复受损组织，同时产生少量弱毒素作为副产物。毒素随后进入血液，对受药者造成伤害。"
	rarity = PROPERTY_RARE
	starter = FALSE
	value = 3
	cost_penalty = FALSE
	var/heal_amount = 0.75

/datum/chem_property/neutral/transformative/process(mob/living/M, potency = 1, delta_time)
	var/true_heal = heal_amount * potency * delta_time
	if(M.getBruteLoss())
		M.apply_damage(-true_heal, BRUTE)
		M.apply_damage(true_heal * 0.1, TOX)
	if(M.getFireLoss())
		M.apply_damage(-true_heal, BURN)
		M.apply_damage(true_heal * 0.1, TOX)

/datum/chem_property/neutral/transformative/process_overdose(mob/living/M, potency = 1)
	M.apply_damage(heal_amount * (potency * POTENCY_MULTIPLIER_LOW), TOX)

/datum/chem_property/neutral/transformative/process_critical(mob/living/M, potency = 1, delta_time)
	M.apply_damage(heal_amount * potency * delta_time, TOX)

/datum/chem_property/neutral/unknown
	name = PROPERTY_UNKNOWN
	code = "UNK"
	description = "这种化学品具有合成模拟器无法定义的独特特性。修改化学品后，该特性可能失效。"
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_ANOMALOUS|PROPERTY_TYPE_UNADJUSTABLE

/datum/chem_property/neutral/unknown/process_overdose(mob/living/M, potency = 1, delta_time)
	M.apply_damage(0.5 * potency * delta_time, BRUTE)

/datum/chem_property/neutral/unknown/process_critical(mob/living/M, potency = 1)
	M.apply_damages(POTENCY_MULTIPLIER_HIGH * potency, POTENCY_MULTIPLIER_HIGH * potency, POTENCY_MULTIPLIER_HIGH * potency)
