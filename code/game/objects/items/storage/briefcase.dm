/obj/item/storage/briefcase
	name = "公文包"
	desc = "它采用货真价实的仿皮制成，价签还没摘掉。主人一定是位真正的专业人士。"
	icon = 'icons/obj/items/storage/briefcases.dmi'
	icon_state = "briefcase"
	item_state = "briefcase"
	flags_atom = FPRINT|CONDUCT
	force = 8
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	max_storage_space = 16
	attack_verb = list("猛砸", "殴打", "重击", "痛打", "敲打")

/obj/item/storage/briefcase/attack(mob/living/M as mob, mob/living/user as mob)
	var/obj/limb/affecting = user.zone_selected
	var/drowsy_threshold = 0

	drowsy_threshold = CLOTHING_ARMOR_MEDIUM - M.getarmor(affecting, ARMOR_MELEE)

	if(affecting == "head" && istype(M, /mob/living/carbon/) && !isxeno(M))
		for(var/mob/O in viewers(user, null))
			if(M != user)
				O.show_message(text(SPAN_DANGER("<B>[user]用[name]砸中了[M]的头！</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[M]用[name]砸了自己的头！</B>")), SHOW_MESSAGE_VISIBLE)
		if(drowsy_threshold > 0)
			M.apply_effect(min(drowsy_threshold, 10) , DROWSY)

		M.apply_damage(force, BRUTE, affecting, sharp=0) //log and damage the custom hit
		user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by  [key_name(user)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
		msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	else //Regular attack text
		. = ..()

	return

/obj/item/storage/briefcase/stowaway
	name = "公文包"
	desc = "它采用货真价实的仿皮制成，价签还没摘掉。主人一定是位真正的专业人士。"
	icon_state = "suitcase"
	item_state = "suitcase"
	force = 8
