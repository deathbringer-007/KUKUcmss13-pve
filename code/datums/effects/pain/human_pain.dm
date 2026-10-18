/datum/effects/pain/human
	var/pain_message = ""
	var/emote_message = null
	var/do_once = TRUE

/datum/effects/pain/human/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/affected_mob = affected_atom
	if((duration % 20 == 0) && affected_mob.client && affected_mob.client.prefs && (CHAT_TYPE_PAIN & affected_mob.client.prefs.chat_display_preferences)) //Do it every fifth tick
		to_chat(affected_mob, SPAN_DANGER(pain_message))

	if(emote_message && (duration % 60 == 0))
		affected_mob.emote("me", 1, pick(emote_message), FALSE)

	return TRUE


/datum/effects/pain/human/mild
	pain_message = "你痛苦地龇牙咧嘴。"


/datum/effects/pain/human/discomforting
	pain_message = "你需要一些止痛药。"


/datum/effects/pain/human/moderate
	pain_message = "你真的很需要止痛药！"


/datum/effects/pain/human/distressing
	pain_message = "疼痛难以忍受！"
	emote_message = list("痛苦地龇牙咧嘴。")

/datum/effects/pain/human/distressing/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.EyeBlur(2)
	if(affected_mob.pain && affected_mob.pain.feels_pain)
		affected_mob.TalkStutter(2)

	return TRUE


/datum/effects/pain/human/severe
	pain_message = "你感觉自己随时都可能死去！"
	emote_message = list("艰难地睁着双眼。")

/datum/effects/pain/human/severe/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	if(do_once)
		if((affected_mob.status_flags & CANKNOCKOUT))
			affected_mob.KnockDown(3)
			affected_mob.Stun(3)
		do_once = FALSE

	affected_mob.EyeBlur(2)
	if(affected_mob.pain && affected_mob.pain.feels_pain)
		affected_mob.TalkStutter(2)
	if(!affected_mob.reagents || !affected_mob.reagents.has_reagent("inaprovaline"))
		affected_mob.apply_damage(0.1, OXY)

	return TRUE


/datum/effects/pain/human/horrible
	pain_message = "你感觉自己随时都可能死去！"
	emote_message = list("几乎站不稳了。")

/datum/effects/pain/human/horrible/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.EyeBlur(2)
	if(affected_mob.pain && affected_mob.pain.feels_pain)
		affected_mob.TalkStutter(2)
	if((affected_mob.status_flags & CANKNOCKOUT))
		affected_mob.KnockDown(2)
		affected_mob.Stun(2)
	if(!affected_mob.reagents || !affected_mob.reagents.has_reagent("inaprovaline"))
		affected_mob.apply_damage(0.5, OXY)

	return TRUE
