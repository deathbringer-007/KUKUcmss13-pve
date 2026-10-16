/obj/item/weapon/stunprod
	name = "异形电击棒"
	desc = "专为制伏异形生命体设计的电击棒。"
	icon_state = "stunbaton"
	item_state = "baton"
	flags_equip_slot = SLOT_WAIST
	force = 12
	throwforce = 7
	w_class = SIZE_MEDIUM
	var/charges = 12
	var/status = 0
	var/mob/foundmob = "" //Used in throwing proc.



/obj/item/weapon/stunprod/update_icon()
	if(status)
		icon_state = "stunbaton_active"
	else
		icon_state = "stunbaton"

/obj/item/weapon/stunprod/attack_self(mob/user)
	..()
	if(charges > 0)
		status = !status
		to_chat(user, SPAN_NOTICE("[src]现已[status ? "开启" : "关闭"]。"))
		playsound(src.loc, "sparks", 15, 1)
		update_icon()
	else
		status = 0
		to_chat(user, SPAN_WARNING("[src]没电了。"))
	add_fingerprint(user)

/obj/item/weapon/stunprod/attack(mob/living/M, mob/user)
	if(user.a_intent == INTENT_HARM)
		return
	else if(!status)
		M.visible_message(SPAN_WARNING("[user]用未开启的[src]戳了[M]。"))
		return

	if(status)
		M.KnockDown(6)
		M.Stun(6)
		charges -= 2
		M.visible_message(SPAN_DANGER("[user]用[src]电击了[M]！"))

		user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [key_name(M)] with [src.name]</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [key_name(user)] with [src.name]</font>"
		log_attack("[key_name(user)] stunned [key_name(M)] with [src.name]")

		playsound(src.loc, 'sound/weapons/Egloves.ogg', 25, 1)
		if(charges < 1)
			status = 0
			update_icon()

	add_fingerprint(user)


/obj/item/weapon/stunprod/emp_act(severity)
	. = ..()
	switch(severity)
		if(1)
			charges = 0
		if(2)
			charges = max(0, charges - 5)
	if(charges < 1)
		status = 0
		update_icon()


/obj/item/weapon/stunprod/improved
	charges = 30
	name = "改进型异形电击棒"
	desc = "专为制伏异形生命体设计的电击棒，效能似乎远胜于旧型号。"
	color = "#FF6666"

/obj/item/weapon/stunprod/improved/attack(mob/M, mob/user)
	..()
	M.apply_effect(14, WEAKEN)

/obj/item/weapon/stunprod/improved/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("剩余[charges]次电击电量。")
