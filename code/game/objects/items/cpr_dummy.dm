/obj/item/cpr_dummy
	name = "\improper 心肺复苏训练假人"
	desc = "用于教新兵救人的心肺复苏训练假人！无法准确模拟战伤，也不会模拟肋骨断裂。塑料材质接触有毒，若皮肤刺激症状持续超过两小时，请联系医生。"
	icon = 'icons/obj/items/cpr_dummy.dmi'
	icon_state = "cpr_dummy"
	var/successful_cprs = 0
	var/failed_cprs = 0
	var/cpr_cooldown = 0

/obj/item/cpr_dummy/get_examine_text(mob/user)
	. = ..()
	. += "心肺复苏成功次数：[SPAN_GREEN(successful_cprs)]。"
	. += "心肺复苏失败次数：[SPAN_RED(failed_cprs)]。"

/obj/item/cpr_dummy/update_icon()
	if(anchored)
		icon_state = "[initial(icon_state)]_deployed"
	else
		icon_state = initial(icon_state)
	return ..()

/obj/item/cpr_dummy/attack_self(mob/user)
	. = ..()
	user.visible_message(SPAN_NOTICE("[user]摆好了[src]，准备开始训练！"), SPAN_NOTICE("你摆好了[src]，准备开始训练。"))
	user.drop_inv_item_on_ground(src)
	anchored = TRUE
	update_icon()

/obj/item/cpr_dummy/MouseDrop(obj/over_object as obj)
	if(CAN_PICKUP(usr, src) && !usr.is_mob_restrained())
		var/success = FALSE
		if(usr == over_object && usr.put_in_hands(src))
			success = TRUE
		else
			switch(over_object.name)
				if("r_hand")
					if(src.loc != usr || usr.drop_inv_item_on_ground(src))
						usr.put_in_r_hand(src)
						success = TRUE
				if("l_hand")
					if(src.loc != usr || usr.drop_inv_item_on_ground(src))
						usr.put_in_l_hand(src)
						success = TRUE
		if(success)
			if(anchored)
				anchored = FALSE
				update_icon()
			add_fingerprint(usr)

/obj/item/cpr_dummy/attack_hand(mob/living/carbon/human/H)
	if(!anchored || !istype(H))
		return ..()
	if(H.action_busy)
		return FALSE
	if(H.a_intent != INTENT_HELP)
		to_chat(H, SPAN_WARNING("你需要切换到帮助意图才能进行心肺复苏！"))
		return
	if((H.head && (H.head.flags_inventory & COVERMOUTH)) || (H.wear_mask && (H.wear_mask.flags_inventory & COVERMOUTH) && !(H.wear_mask.flags_inventory & ALLOWCPR)))
		to_chat(H, SPAN_BOLDNOTICE("先摘下你的面罩！"))
		return FALSE
	H.visible_message(SPAN_NOTICE("<b>[H]</b>开始对<b>[src]</b>进行<b>心肺复苏</b>。"), SPAN_HELPFUL("你开始对<b>[src]</b><b>进行心肺复苏</b>。"))
	if(!do_after(H, HUMAN_STRIP_DELAY * H.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		return
	if(cpr_cooldown < world.time)
		H.visible_message(SPAN_NOTICE("<b>[H]</b>对<b>[src]</b>进行了<b>心肺复苏</b>。"), SPAN_HELPFUL("你对<b>[src]</b>进行了<b>心肺复苏</b>。"))
		successful_cprs++
	else
		H.visible_message(SPAN_NOTICE("<b>[H]</b>对<b>[src]</b>进行心肺复苏，但失败了。"), SPAN_HELPFUL("你对<b>[src]</b>进行<b>心肺复苏</b>，但<b>失败</b>了。节奏不对，动作再<b>慢一点</b>。"))
		failed_cprs++
	cpr_cooldown = world.time + 7 SECONDS

/obj/item/cpr_dummy/verb/reset_counter()
	set name = "重置心肺复苏计数"
	set category = "物品"
	set src in oview(1)

	if(!isSEA(usr))
		to_chat(usr, SPAN_WARNING("只有资深士官顾问才能重置这个假人的计数器！"))
		return
	successful_cprs = 0
	failed_cprs = 0
	to_chat(usr, SPAN_NOTICE("你重置了[src]的计数器。"))
