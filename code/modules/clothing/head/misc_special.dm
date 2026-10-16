/*
 * Contents:
 * Welding mask
 * Cakehat
 * Ushanka
 * Pumpkin head
 *
 */

/*
 * Welding mask
 */
/obj/item/clothing/head/welding
	name = "焊接头盔"
	desc = "一种头戴式面罩，能全面保护佩戴者的眼睛免受太空电弧伤害。"
	icon_state = "welding"
	item_state = "welding"
	matter = list("metal" = 3000, "glass" = 1000)
	var/up = 0
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	flags_atom = FPRINT|CONDUCT
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	actions_types = list(/datum/action/item_action/toggle)
	siemens_coefficient = 0.9
	w_class = SIZE_MEDIUM
	eye_protection = EYE_PROTECTION_WELDING
	vision_impair = VISION_IMPAIR_MAX

/obj/item/clothing/head/welding/attack_self(mob/user)
	..()
	toggle()


/obj/item/clothing/head/welding/verb/toggle()
	set category = "物品"
	set name = "调整焊接面罩"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	if(up)
		vision_impair = VISION_IMPAIR_MAX
		flags_inventory |= COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
		flags_inv_hide |= HIDEEARS|HIDEEYES|HIDEFACE
		icon_state = initial(icon_state)
		eye_protection = initial(eye_protection)
		to_chat(usr, SPAN_NOTICE("你放下[src]，保护双眼。"))
	else
		vision_impair = VISION_IMPAIR_NONE
		flags_inventory &= ~(COVEREYES|COVERMOUTH|BLOCKSHARPOBJ)
		flags_inv_hide &= ~(HIDEEARS|HIDEEYES|HIDEFACE)
		icon_state = "[initial(icon_state)]up"
		eye_protection = EYE_PROTECTION_NONE
		to_chat(usr, SPAN_NOTICE("你将[src]推到额头上，露出面部。"))
	up = !up

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.head == src)
			H.update_tint()

	update_clothing_icon() //so our mob-overlays update

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/*
 * Cakehat
 */
/obj/item/clothing/head/cakehat
	name = "蛋糕帽"
	desc = "看起来很好吃！"
	icon_state = "cake0"
	flags_inventory = COVEREYES
	var/onfire = 0
	var/status = 0
	var/fire_resist = T0C+1300 //this is the max temp it can stand before you start to cook. although it might not burn away, you take damage
	var/processing = 0 //I dont think this is used anywhere.
	flags_armor_protection = BODY_FLAG_EYES

/obj/item/clothing/head/cakehat/process()
	if(!onfire)
		STOP_PROCESSING(SSobj, src)
		return

/obj/item/clothing/head/cakehat/attack_self(mob/user)
	..()

	if(status > 1)
		return

	onfire = !onfire
	if (onfire)
		force = 3
		damtype = "fire"
		icon_state = "cake1"
		START_PROCESSING(SSobj, src)
	else
		force = null
		damtype = "brute"
		icon_state = "cake0"


/*
 * Pumpkin head
 */
/obj/item/clothing/head/pumpkinhead
	name = "雕刻南瓜"
	desc = "南瓜灯！据说可以驱赶邪灵。"
	icon_state = "hardhat0_pumpkin"//Could stand to be renamed
	item_state = "hardhat0_pumpkin"
	flags_inventory = COVEREYES|COVERMOUTH
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_EYES
	var/brightness_on = 2 //luminosity when on
	var/on = 0
	w_class = SIZE_MEDIUM
	anti_hug = 1

/obj/item/clothing/head/pumpkinhead/attack_self(mob/user)
	..()

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("你在[user.loc]内时无法[on ? "关闭" : "打开" ]灯光。")) //To prevent some lighting anomalies.
		return

	on = !on
	icon_state = "hardhat[on]_pumpkin"

	if(on)
		set_light_range(brightness_on)
		set_light_on(TRUE)
	else
		set_light_on(FALSE)
