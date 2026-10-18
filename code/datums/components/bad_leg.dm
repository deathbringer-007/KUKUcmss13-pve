//not variables to save on overhead

#define MESSAGE_COOLDOWN 1.5 SECONDS

/// Maximum amount of steps you can take until you get stunned from pain.
#define MAX_STEPS 30

/datum/component/bad_leg
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Tracker for steps walked.
	var/steps_walking
	/// Holds the last time a message was sent to prevent spam.
	var/last_message_time
	/// The bound action to reduce steps tracker.
	var/datum/action/human_action/rest_legs/bound_action
	/// Bound human.
	var/mob/living/carbon/human/parent_human
	/// Bound limb.
	var/obj/limb/affected_limb

/datum/component/bad_leg/Initialize(forced_limb)
	. = ..()
	parent_human = parent
	if(!istype(parent_human))
		return COMPONENT_INCOMPATIBLE

	var/chosen_leg = forced_limb ? forced_limb : "l_leg" // always left leg by default first because i'm lazy and dont know how to add options to quirks
	affected_limb = parent_human.get_limb(chosen_leg)
	if(!affected_limb || affected_limb.status & LIMB_ROBOT)
		chosen_leg = "r_leg"
		affected_limb = parent_human.get_limb(chosen_leg)
	if(!affected_limb || affected_limb.status & LIMB_ROBOT)
		to_chat(parent_human, SPAN_NOTICE("你原本长着[chosen_leg == "r_leg" ? "右腿" : "左腿"]的部位传来奇怪而不适的幻觉。"))
		qdel(src)

/datum/component/bad_leg/Destroy(force, silent)
	handle_qdel()
	. = ..()


/datum/component/bad_leg/RegisterWithParent()
	..()
	RegisterSignal(parent_human, COMSIG_MOVABLE_MOVED, PROC_REF(stumble))
	RegisterSignal(parent_human, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdel))
	give_action(parent_human, /datum/action/human_action/rest_legs, null, null, src)

/datum/component/bad_leg/proc/handle_qdel()
	SIGNAL_HANDLER
	QDEL_NULL(bound_action)
	parent_human = null
	affected_limb = null

/datum/component/bad_leg/UnregisterFromParent()
	..()
	if(parent_human)
		UnregisterSignal(parent_human, COMSIG_MOVABLE_MOVED, PROC_REF(stumble))
		bound_action?.unique_remove_action(parent_human, /datum/action/human_action/rest_legs, src)


/datum/component/bad_leg/proc/stumble(mob/living/carbon/human/parent_human)
	SIGNAL_HANDLER

	///This prevents weird shit like corpses being dragged triggering the messages.
	if(parent_human.stat || parent_human.buckled && !HAS_TRAIT(parent_human, TRAIT_USING_WHEELCHAIR) || parent_human.is_mob_incapacitated() || parent_human.is_mob_restrained())
		return

	if(parent_human.throwing == TRUE)
		return // unaffected on throws

	if(HAS_TRAIT(parent_human, TRAIT_USING_WHEELCHAIR))
		if(last_message_time + MESSAGE_COOLDOWN * 10 < world.time) //longer cooldown if using wheelchairs.
			parent_human.visible_message(SPAN_NOTICE("[parent_human] 推着轮椅移动。"), SPAN_NOTICE("轮椅让你能在移动时休息[affected_limb.display_name]，减轻其痛苦。"))
			last_message_time = world.time
		steps_walking = max(steps_walking - 1, 0)
		return

	if(HAS_TRAIT(parent_human, TRAIT_HOLDS_CANE))
		if(last_message_time + MESSAGE_COOLDOWN * 10 < world.time) //longer cooldown if using canes
			parent_human.visible_message(SPAN_NOTICE("[parent_human] 拄着手杖调整步伐。"), SPAN_NOTICE("手杖让你能控制步伐，减轻[affected_limb.display_name]的痛苦。"))
			last_message_time = world.time
		steps_walking = max(steps_walking - 1, 0)
		return

	steps_walking++

	switch(steps_walking)
		if(MAX_STEPS * 0.3 to MAX_STEPS * 0.6)
			if(last_message_time + MESSAGE_COOLDOWN < world.time)
				to_chat(parent_human, SPAN_WARNING("疼痛不断加剧，你受伤的[affected_limb.display_name]突然失控，踉跄了半步。"))
				last_message_time = world.time
		if(MAX_STEPS * 0.6 to MAX_STEPS - 1)
			if(last_message_time + MESSAGE_COOLDOWN < world.time)
				to_chat(parent_human, SPAN_DANGER("你的[affected_limb.display_name]不听使唤，你痛苦地绊了一下。你觉得自己需要喘口气才能继续走。"))
				last_message_time = world.time
		if(MAX_STEPS to INFINITY)
			to_chat(parent_human, SPAN_HIGHDANGER("你的[affected_limb.display_name]因难以言喻的疼痛而剧烈抽搐！"))
			steps_walking = POSITIVE(steps_walking - MAX_STEPS * 0.3) //pity reduction
			INVOKE_ASYNC(parent_human, TYPE_PROC_REF(/mob/living/carbon/human, emote), "pain")
			var/stun_time = 2.5
			parent_human.Shake(pixelshiftx = 32, pixelshifty = 0, duration = stun_time SECONDS)
			parent_human.apply_effect(stun_time, STUN)
			addtimer(CALLBACK(src, PROC_REF(rest_legs_pain), parent_human, FALSE), stun_time SECONDS)
			return

	INVOKE_ASYNC(src, PROC_REF(rest_legs), parent_human, FALSE)

/datum/component/bad_leg/proc/rest_legs_pain(mob/living/parent_human, action = FALSE)
	to_chat(parent_human, SPAN_NOTICE("你又能移动了，但最好再休息一会儿。"))
	rest_legs(parent_human, action)

/datum/component/bad_leg/proc/rest_legs(mob/living/parent_human, action = FALSE)

	if(!steps_walking)
		bound_action.in_use = FALSE
		if(!action)
			return FALSE
		to_chat(parent_human, SPAN_WARNING("你的[affected_limb.display_name]似乎已经稳定下来了。"))
		return FALSE

	var/show_icon = action ? BUSY_ICON_FRIENDLY : NO_BUSY_ICON
	bound_action.in_use = TRUE
	if(!do_after(parent_human, 1.5 SECONDS, INTERRUPT_MOVED, show_icon))
		bound_action.in_use = FALSE
		if(!action)
			return FALSE
		to_chat(parent_human, SPAN_WARNING("你需要站着不动，让[affected_limb.display_name]休息片刻。"))
		return FALSE

	if(action)
		to_chat(parent_human, SPAN_HELPFUL("短暂休息后，你[affected_limb.display_name]的疼痛[ (steps_walking > MAX_STEPS * 0.3) ? "稍微减轻" : "消退"]了。"))
	steps_walking = max(steps_walking - MAX_STEPS * 0.3, 0)
	bound_action.in_use = FALSE
	rest_legs(parent_human, action)
	return TRUE

/datum/action/human_action/rest_legs
	name = "Rest Leg"
	action_icon_state = "stumble"
	var/in_use = FALSE
	var/datum/component/bad_leg/bound_component

/datum/action/human_action/rest_legs/New(target, override_icon_state, datum/component/bad_leg/bound_component)
	. = ..()
	if(bound_component)
		name = "Rest [bound_component.affected_limb.display_name]"
		src.bound_component = bound_component
		src.bound_component.bound_action = src
	else
		CRASH("No bound wound to link action")

/datum/action/human_action/rest_legs/action_activate()
	. = ..()
	var/mob/living/carbon/human/homan = owner
	if(in_use)
		to_chat(homan, SPAN_WARNING("你已经在这么做了！"))
		return
	in_use = bound_component.rest_legs(homan, TRUE)

// Needs unique remove action due to possibility of two of these on the same mob.
/datum/action/human_action/rest_legs/proc/unique_remove_action(mob/mob, action_path, datum/component/bad_leg/bound_component)
	for(var/datum/action/acton as anything in mob.actions)
		if(acton.type == action_path && src.bound_component == bound_component)
			acton.remove_from(mob)
			return acton

#undef MESSAGE_COOLDOWN

#undef MAX_STEPS
