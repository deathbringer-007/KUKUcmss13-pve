/obj/item/stack/nanopaste
	name = "纳米修复膏"
	singular_name = "纳米机器人群"
	desc = "一管含有大量维修纳米机器人的膏剂，修复机器人和机械装置的效果极佳。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "tube"

	attack_speed = 3
	amount = 10
	max_amount = 10
	w_class = SIZE_SMALL
	stack_id = "nanopaste"
	black_market_value = 25
	flags_human_ai = HEALING_ITEM

/obj/item/stack/nanopaste/attack(mob/living/M as mob, mob/user as mob)
	if (!istype(M) || !istype(user))
		return 0

	if (istype(M,/mob/living/carbon/human)) //Repairing robolimbs
		var/mob/living/carbon/human/H = M
		var/obj/limb/S = H.get_limb(user.zone_selected)

		if (S && (S.status & (LIMB_ROBOT|LIMB_SYNTHSKIN)))
			if(S.get_damage())
				S.heal_damage(15, 15, robo_repair = 1)
				H.pain.recalculate_pain()
				H.updatehealth()
				use(1)
				var/others_msg = "[user]用[src]将纳米修复膏涂在[user != M ? "[M]的" : "自己的"][S.display_name]上。" // Needs to create vars for these messages because macro doesn't work otherwise
				var/user_msg = "你将纳米修复膏涂在[user == M ? "自己的" : "[M]的"][S.display_name]上。"
				user.visible_message(SPAN_NOTICE("[others_msg]"),\
					SPAN_NOTICE("[user_msg]"))
			else
				to_chat(user, SPAN_NOTICE("这里没有需要修复的损伤。"))

/obj/item/stack/nanopaste/ai_can_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	if(!issynth(target))
		return FALSE

	for(var/obj/limb/limb as anything in target.limbs)
		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal)
				continue

			return TRUE

	return FALSE

/obj/item/stack/nanopaste/ai_use(mob/living/carbon/human/user, datum/human_ai_brain/ai_brain, mob/living/carbon/human/target)
	for(var/obj/limb/limb as anything in target.limbs)
		if(QDELETED(src))
			return

		for(var/datum/wound/wound in limb.wounds)
			if(wound.internal)
				continue

			if(QDELETED(src))
				return

			user.zone_selected = limb.name
			attack(target, user)
			sleep(ai_brain.short_action_delay * ai_brain.action_delay_mult)
