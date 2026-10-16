/obj/item/tool
	flags_human_ai = TOOL_ITEM

/obj/item/tool/mop
	desc = "清洁工的世界可少不了一把拖把。"
	name = "拖把"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 3
	attack_speed = 4
	throwforce = 10
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	w_class = SIZE_MEDIUM
	matter = list("metal" = 110)

	var/max_reagent_volume = 15
	var/mop_speed = 1.5 SECONDS
	var/mop_count = 0


/obj/item/tool/mop/Initialize()
	. = ..()
	create_reagents(max_reagent_volume)

/obj/item/tool/mop/attack(mob/living/M, mob/living/user)
	. = ..()
	if(.)
		user.next_move = world.time + 1 SECONDS

/obj/item/tool/mop/update_icon(cut_if_empty)
	if(cut_if_empty)
		if(!reagents.total_volume)
			overlays.Cut()
		return
	overlays.Cut()
	if(reagents.total_volume)
		var/reagent_color = mix_color_from_reagents(reagents.reagent_list)
		var/image/reagent_overlay = image(icon, null, "mop_overlay", layer + 0.01)
		reagent_overlay.color = reagent_color
		overlays += reagent_overlay

/turf/proc/clean_cleanables()
	for(var/i in cleanables)
		var/obj/effect/decal/cleanable/C = cleanables[i]
		C.cleanup_cleanable()

/turf/proc/clean(atom/source)
	if(source.reagents.has_reagent("water", 1))
		clean_cleanables()
	source.reagents.reaction(src, TOUCH, 10) //10 is the multiplier for the reaction effect. probably needed to wet the floor properly.
	source.reagents.remove_any(1) //reaction() doesn't use up the reagents


/obj/item/tool/mop/afterattack(atom/A, mob/living/user, proximity)
	if(!proximity) return
	if(istype(A, /turf) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_NOTICE("你的拖把干了！"))
			return

		var/cleaning_duration = 1.5 SECONDS * user.get_skill_duration_multiplier(SKILL_DOMESTIC)

		var/turf/cleaning_turf = get_turf(A)
		user.visible_message(SPAN_WARNING("[user]开始清洁[cleaning_turf]。"))
		user.animation_attack_on(cleaning_turf)
		user.flick_attack_overlay(cleaning_turf, "cleaning_sparkles", cleaning_duration)

		if(do_after(user, cleaning_duration, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			if(cleaning_turf)
				cleaning_turf.clean(src)
				update_icon(TRUE)
			to_chat(user, SPAN_NOTICE("你拖完地了！"))


/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tool/mop) || istype(I, /obj/item/tool/soap))
		return
	..()








/obj/item/tool/wet_sign
	name = "小心地滑警示牌"
	desc = "小心！地面湿滑！"
	icon_state = "caution"
	icon = 'icons/obj/janitor.dmi'
	force = 1
	throwforce = 3
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("警告", "告诫", "砸击")

/obj/item/tool/warning_cone
	name = "警示锥"
	desc = "这个锥桶正试图提醒你注意什么！"
	icon_state = "cone"
	icon = 'icons/obj/janitor.dmi'
	item_icons = 'icons/mob/humans/onmob/head_0.dmi'
	force = 1
	throwforce = 3
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("警告", "告诫", "砸击")
	flags_equip_slot = SLOT_HEAD
	flags_inv_hide = HIDEEARS|HIDETOPHAIR




/obj/item/tool/soap
	name = "肥皂"
	desc = "一块廉价肥皂。没有气味。"
	gender = PLURAL
	icon = 'icons/obj/items/items.dmi'
	icon_state = "soap"
	w_class = SIZE_TINY
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

/obj/item/tool/soap/Crossed(atom/movable/AM)
	if (iscarbon(AM))
		var/mob/living/carbon/C =AM
		C.slip("肥皂", 3, 2)

/obj/item/tool/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, SPAN_NOTICE("清洁[target.name]之前，你得先把它脱下来。"))
	else if(istype(target,/obj/effect/decal/cleanable))
		to_chat(user, SPAN_NOTICE("你擦掉了[target.name]。"))
		qdel(target)
	else if(isturf(target))
		var/turf/T = target
		T.clean_cleanables()
		to_chat(user, SPAN_NOTICE("你擦去了[target.name]上的所有污垢。"))
	else
		to_chat(user, SPAN_NOTICE("你清洁了[target.name]。"))
		target.clean_blood()


/obj/item/tool/soap/attack(mob/target, mob/user)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_selected == "mouth" )
		user.visible_message(SPAN_DANGER("[user]用肥皂洗了[target]的嘴！"))
		return
	..()

/obj/item/tool/soap/weyland_yutani
	desc = "一块维兰德-汤谷牌肥皂。有股弗燃素的气味。"
	icon_state = "soapnt"

/obj/item/tool/soap/deluxe
	icon_state = "soapdeluxe"

/obj/item/tool/soap/deluxe/Initialize()
	. = ..()
	desc = "一块华夫公司出品的豪华肥皂，散发着[pick("薰衣草", "香草", "草莓", "巧克力" ,"太空")]的气味。"

/obj/item/tool/soap/syndie
	desc = "一块不值得信任的肥皂，散发着恐惧的气味。"
	icon_state = "soapsyndie"
