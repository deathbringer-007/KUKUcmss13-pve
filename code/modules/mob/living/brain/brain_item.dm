/obj/item/organ/brain
	name = "大脑"
	health = 400 //They need to live awhile longer than other organs.
	desc = "从人脑袋里取出的一块鲜嫩肉团。"
	icon_state = "brain2"
	flags_atom = NO_FLAGS
	force = 1
	w_class = SIZE_SMALL
	throwforce = 1
	throw_speed = SPEED_VERY_FAST
	throw_range = 5

	attack_verb = list("攻击", "拍打", "敲打")
	organ_type = /datum/internal_organ/brain
	organ_tag = "brain"

	var/mob/living/brain/brainmob = null

/obj/item/organ/brain/xeno
	name = "异形大脑"
	desc = "虽说是大脑，看起来却像一大团紫色泡泡糖。"
	icon_state = "xenobrain"

/obj/item/organ/brain/New()
	..()
	spawn(5)
		if(brainmob && brainmob.client)
			brainmob.client.screen.len = null //clear the hud

/obj/item/organ/brain/proc/transfer_identity(mob/living/carbon/H)
	name = "[H]的大脑"
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.blood_type = H.blood_type
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)

	to_chat(brainmob, SPAN_NOTICE("你感到有些迷糊。当你只剩下一个大脑时，这很正常。"))

/obj/item/organ/brain/get_examine_text(mob/user)
	. = ..()
	if(brainmob?.client)//if thar be a brain inside... the brain.
		. += "你能感觉到它仍保留着一丝生命的火花。"
	else
		. += "它显得毫无生气，也许过些时候会恢复一点活力。"

/obj/item/organ/brain/removed(mob/living/target, mob/living/user)

	..()



	var/mob/living/carbon/human/H = target
	var/obj/item/organ/brain/B = src
	if(istype(B) && istype(H))
		B.transfer_identity(target)

/obj/item/organ/brain/replaced(mob/living/target)

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key
			if(target.client) target.client.change_view(GLOB.world_view_size)
