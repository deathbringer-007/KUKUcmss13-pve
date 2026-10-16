//For closing an open incision first.
/datum/surgery/suture_incision
	name = "缝合切口"
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	required_surgery_skill = SKILL_SURGERY_NOVICE
	pain_reduction_required = PAIN_REDUCTION_MEDIUM
	steps = list(/datum/surgery_step/suture_incision)
	lying_required = FALSE
	self_operable = TRUE

//------------------------------------

/datum/surgery_step/suture_incision
	name = "缝合切口"
	desc = "缝合切口"
	tools = SURGERY_TOOLS_SUTURE
	//Suturing incisions closed is distinctly faster than cauterise-swaphand-suture, but slower than cautery alone, meaning it's only better if wanting to both close and suture the incision.
	time = 3.5 SECONDS
	preop_sound = 'sound/surgery/retractor1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/suture_incision/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("你开始用[tool]缝合[target]的[surgery.affected_limb.display_name]上的切口。"),
		SPAN_NOTICE("[user]开始用[tool]缝合你的[surgery.affected_limb.display_name]上的切口。"),
		SPAN_NOTICE("[user]开始用[tool]缝合[target]的[surgery.affected_limb.display_name]上的切口。"))

	target.custom_pain("你的[surgery.affected_limb.display_name]像是正在被针扎——确实如此！")
	log_interact(user, target, "[key_name(user)] began suturing an incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")

/datum/surgery_step/suture_incision/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	var/added_sutures = SEND_SIGNAL(surgery.affected_limb, COMSIG_LIMB_ADD_SUTURES, TRUE)
	if(!added_sutures) //No suture datum to answer the signal
		new /datum/suture_handler(surgery.affected_limb)
		added_sutures = SEND_SIGNAL(surgery.affected_limb, COMSIG_LIMB_ADD_SUTURES, TRUE) //This time, with feeling.

	if(added_sutures & SUTURED_FULLY)
		user.affected_message(target,
			SPAN_NOTICE("你用一排整齐的缝线闭合了[target]的[surgery.affected_limb.display_name]上的切口。"),
			SPAN_NOTICE("[user]用一排整齐的缝线闭合了你的[surgery.affected_limb.display_name]上的切口。"),
			SPAN_NOTICE("[user]用一排整齐的缝线闭合了[target]的[surgery.affected_limb.display_name]上的切口。"))

		log_interact(user, target, "[key_name(user)] finished suturing an incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")
	else
		user.affected_message(target,
			SPAN_NOTICE("你用一排整齐的缝线闭合了[target]的[surgery.affected_limb.display_name]上的切口，但仍有部分伤口尚未处理。"),
			SPAN_NOTICE("[user]用一排整齐的缝线闭合了你的[surgery.affected_limb.display_name]上的切口，但仍有部分伤口尚未处理。"),
			SPAN_NOTICE("[user]用一排整齐的缝线闭合了[target]的[surgery.affected_limb.display_name]上的切口，但仍有部分伤口尚未处理。"))

		log_interact(user, target, "[key_name(user)] finished suturing an incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool], ending [surgery].")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE

/datum/surgery_step/suture_incision/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to suture the incision in [key_name(target)]'s [surgery.affected_limb.display_name] with \the [tool].")
	return FALSE
