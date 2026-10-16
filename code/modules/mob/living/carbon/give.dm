/mob/living/carbon/verb/give()
	set category = "IC"
	set name = "递交"
	set src in oview(1)

	receive_from(usr)

/mob/living/carbon/proc/receive_from(mob/living/carbon/giver)
	if(stat == DEAD || giver.stat == DEAD || client == null)
		return
	if(src == giver)
		return
	if(giver.mob_flags & GIVING)
		to_chat(giver, SPAN_WARNING("你已经在向别人递交物品了！"))
		return
	var/obj/item/I
	if(!giver.hand && giver.r_hand == null)
		to_chat(giver, SPAN_WARNING("你的右手没有可交给[name]的物品。"))
		return
	if(giver.hand && giver.l_hand == null)
		to_chat(giver, SPAN_WARNING("你的左手没有可交给[name]的物品。"))
		return
	if(!ishuman(src) || !ishuman(giver))
		return
	if(giver.hand)
		I = giver.l_hand
	else if(!giver.hand)
		I = giver.r_hand
	if(!istype(I) || (I.flags_item & (DELONDROP|NODROP|ITEM_ABSTRACT)))
		return
	if(body_position == LYING_DOWN) // replace by mobiilty_flags probably
		to_chat(giver, SPAN_WARNING("[src]躺着时无法拿住它。"))
		return
	if(r_hand && l_hand)
		to_chat(giver, SPAN_WARNING("[src]双手已满。"))
		return
	giver.mob_flags |= GIVING
	if(tgui_alert(src, "[giver]想把[I]交给你，是否接受？", "接收物品", list("否", "是"), 10 SECONDS) == "是")
		giver.mob_flags &= ~GIVING
		if(!I || !giver || !istype(I))
			return
		if(!Adjacent(giver))
			to_chat(giver, SPAN_WARNING("递交物品时，你需要保持在伸手可及的距离内。"))
			to_chat(src, SPAN_WARNING("[giver]走得太远了。"))
			return
		if((giver.hand && giver.l_hand != I) || (!giver.hand && giver.r_hand != I))
			to_chat(giver, SPAN_WARNING("你需要一直用当前手拿着要递交的物品。"))
			to_chat(src, SPAN_WARNING("[giver]似乎放弃了把[I]交给你。"))
			return
		if(body_position == LYING_DOWN)
			to_chat(src, SPAN_WARNING("你躺着时无法拿住它。"))
			to_chat(giver, SPAN_WARNING("[src]躺着时无法拿住它。"))
			return
		if(r_hand && l_hand)
			to_chat(src, SPAN_WARNING("你的双手已满。"))
			to_chat(giver, SPAN_WARNING("[src]双手已满。"))
			return
		if(giver.drop_held_item())
			if(put_in_hands(I))
				giver.visible_message(SPAN_NOTICE("[giver]把[I]交给了[src]。"),
				SPAN_NOTICE("你把[I]交给了[src]。"), null, 4)
	else
		giver.mob_flags &= ~GIVING
		return
