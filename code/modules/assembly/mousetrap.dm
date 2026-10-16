/obj/item/device/assembly/mousetrap
	name = "捕鼠夹"
	desc = "方便实用的小型弹簧陷阱，用于捕捉恼人的鼠类。"
	icon_state = "mousetrap"
	matter = list("metal" = 100, "waste" = 10)

	var/armed = 0

/obj/item/device/assembly/mousetrap/attackby()
	return

/obj/item/device/assembly/mousetrap/get_examine_text(mob/user)
	. = ..()
	if(armed)
		. += "它看起来已经设好了。"

/obj/item/device/assembly/mousetrap/update_icon()
	if(armed)
		icon_state = "mousetraparmed"
	else
		icon_state = "mousetrap"
	if(holder)
		holder.update_icon()

/obj/item/device/assembly/mousetrap/proc/triggered(mob/target as mob, type = "feet")
	if(!armed)
		return
	var/obj/limb/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		switch(type)
			if("feet")
				if(!H.shoes)
					affecting = H.get_limb(pick("l_leg", "r_leg"))
					H.apply_effect(3, WEAKEN)
			if("l_hand", "r_hand")
				if(!H.gloves)
					affecting = H.get_limb(type)
					H.apply_effect(3, STUN)
		if(affecting)
			if(affecting.take_damage(1, 0))
				H.UpdateDamageIcon()
			H.updatehealth()
	else if(ismouse(target))
		var/mob/living/simple_animal/mouse/M = target
		visible_message(SPAN_DANGER("<b>啪叽！</b>"))
		M.splat()
	if(!target) return
	playsound(target.loc, 'sound/effects/snap.ogg', 25, 1)
	layer = MOB_LAYER - 0.2
	armed = 0
	update_icon()
	pulse(0)


/obj/item/device/assembly/mousetrap/attack_self(mob/living/user)
	..()

	if(!armed)
		to_chat(user, SPAN_NOTICE("你设好了[src]。"))
	else
		if((user.getBrainLoss() >= 60) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message(SPAN_WARNING("[user]意外触发了[src]，夹断了自己的手指。"), SPAN_WARNING("你意外触发了[src]！"))
			return
		to_chat(user, SPAN_NOTICE("你解除了[src]。"))
	armed = !armed
	update_icon()
	playsound(user.loc, 'sound/weapons/handcuffs.ogg', 25, 1, 6)


/obj/item/device/assembly/mousetrap/attack_hand(mob/living/user as mob)
	if(armed)
		if((user.getBrainLoss() >= 60) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message(SPAN_WARNING("[user]意外触发了[src]，夹断了自己的手指。"),SPAN_WARNING("你意外触发了[src]！"))
			return
	..()


/obj/item/device/assembly/mousetrap/Crossed(atom/movable/AM)
	if(armed)
		if(ishuman(AM))
			var/mob/living/carbon/H = AM
			triggered(H)
			H.visible_message(SPAN_WARNING("[H]意外踩中了[src]。"),SPAN_WARNING("你意外踩中了[src]。"))
		if(ismouse(AM))
			triggered(AM)
	..()


/obj/item/device/assembly/mousetrap/on_found(mob/finder as mob)
	if(armed)
		finder.visible_message(SPAN_WARNING("[finder]意外触发了[src]，夹断了自己的手指。"),SPAN_WARNING("你意外触发了[src]！"))
		triggered(finder, finder.hand ? "l_hand" : "r_hand")
		return 1 //end the search!
	return 0


/obj/item/device/assembly/mousetrap/hitby(atom/movable/AM)
	if(!armed)
		return ..()
	visible_message(SPAN_WARNING("[AM]触发了[src]。"))
	triggered(null)


/obj/item/device/assembly/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = 1


/obj/item/device/assembly/mousetrap/verb/hide_under()
	set src in oview(1)
	set name = "隐藏"
	set category = "物品"

	if(usr.stat)
		return

	layer = TURF_LAYER+0.2
	to_chat(usr, SPAN_NOTICE("你藏起了[src]。"))
