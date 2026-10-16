/obj/item/weapon/energy
	var/active = 0
	flags_atom = FPRINT|QUICK_DRAWABLE|NOBLOODY

/obj/item/weapon/energy/axe
	name = "能量斧"
	desc = "一把能量战斧。"
	icon_state = "axe0"
	force = MELEE_FORCE_VERY_STRONG
	throwforce = MELEE_FORCE_NORMAL
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	flags_atom = FPRINT|CONDUCT|QUICK_DRAWABLE|NOBLOODY
	flags_item = NOSHIELD

	attack_verb = list("攻击", "砍击", "劈开", "撕裂", "割伤")
	sharp = IS_SHARP_ITEM_BIG
	edge = 1

/obj/item/weapon/energy/axe/attack_self(mob/user)
	..()

	active = !active
	if(active)
		to_chat(user, SPAN_NOTICE("能量斧已启动。"))
		force = 150
		icon_state = "axe1"
		w_class = SIZE_HUGE
		heat_source = 3500
	else
		to_chat(user, SPAN_NOTICE("现在可以把斧头藏起来了。"))
		force = 40
		icon_state = "axe0"
		w_class = SIZE_HUGE
		heat_source = 0
	add_fingerprint(user)



/obj/item/weapon/energy/sword
	name = "能量剑"
	desc = "愿原力与你同在。"
	icon_state = "sword0"
	force = 3
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	flags_atom = FPRINT|QUICK_DRAWABLE|NOBLOODY
	flags_item = NOSHIELD

	attack_verb = list("攻击", "劈砍", "刺击", "切割", "撕裂", "撕扯", "切碎", "割伤")
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	var/base_sword_icon = "sword"
	var/sword_color

/obj/item/weapon/energy/sword/IsShield()
	if(active)
		return 1
	return 0

/obj/item/weapon/energy/sword/New()
	if(!sword_color)
		sword_color = pick("red","blue","green","purple")

/obj/item/weapon/energy/sword/attack_self(mob/living/user)
	..()

	active = !active
	if (active)
		force = 30
		heat_source = 3500
		if(base_sword_icon != "sword")
			icon_state = "[base_sword_icon]1"
		else
			icon_state = "sword[sword_color]"
		w_class = SIZE_LARGE
		playsound(user, 'sound/weapons/saberon.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("[src]已启动。"))

	else
		force = 3
		heat_source = 0
		icon_state = "[base_sword_icon]0"
		w_class = SIZE_SMALL
		playsound(user, 'sound/weapons/saberoff.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("现在可以把[src]藏起来了。"))

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	add_fingerprint(user)
	return


/obj/item/weapon/energy/sword/pirate
	name = "能量弯刀"
	desc = "哟吼，伙计！"
	icon_state = "cutlass0"
	base_sword_icon = "cutlass"

/obj/item/weapon/energy/sword/green
	sword_color = "green"


/obj/item/weapon/energy/sword/green/attack_self()
	..()
	force = active ? 80 : 3

/obj/item/weapon/energy/sword/red
	sword_color = "red"
