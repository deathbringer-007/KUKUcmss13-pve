/*
 * Toy gun
 * Toy crossbow
 * Toy swords
*/



/*
 * Toy gun: Why isnt this an /obj/item/weapon/gun?
 */
/obj/item/toy/gun
	name = "响纸枪"
	desc = "还剩0发响纸弹。看起来几乎以假乱真！适合8岁及以上人群。用完后请放入自动车床回收！"
	icon_state = "capgun"
	item_state = "gun"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM

	matter = list("glass" = 10,"metal" = 10)

	attack_verb = list("敲击", "枪托击打", "击打", "重击")
	var/bullets = 7

/obj/item/toy/gun/get_examine_text(mob/user)
	desc = "还剩[bullets]发响纸弹。看起来几乎以假乱真！适合8岁及以上人群。"
	return ..()

/obj/item/toy/gun/attackby(obj/item/toy/gun_ammo/A as obj, mob/user as mob)
	if (istype(A, /obj/item/toy/gun_ammo))
		if (src.bullets >= 7)
			to_chat(user, SPAN_NOTICE("已经装满了！"))
			return 1
		if (A.amount_left <= 0)
			to_chat(user, SPAN_DANGER("没有响纸弹了！"))
			return 1
		if (A.amount_left < (7 - bullets))
			src.bullets += A.amount_left
			to_chat(user, SPAN_DANGER("你装入了[A.amount_left]发响纸弹！"))
			A.amount_left = 0
		else
			to_chat(user, SPAN_DANGER("你装入了[7 - bullets]发响纸弹！"))
			A.amount_left -= 7 - bullets
			bullets = 7
		A.update_icon()
		A.desc = "还剩[A.amount_left]发响纸弹！用完后记得将盒子放入自动车床回收。"
		return 1

/obj/item/toy/gun/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if (flag)
		return
	if (!(istype(usr, /mob/living/carbon/human) || SSticker) && SSticker.mode.name != "monkey")
		to_chat(usr, SPAN_DANGER("你的肢体不够灵巧，做不了这个！"))
		return
	src.add_fingerprint(user)
	if (src.bullets < 1)
		user.show_message(SPAN_DANGER("*咔嗒* *咔嗒*"), SHOW_MESSAGE_AUDIBLE)
		playsound(user, 'sound/weapons/gun_empty.ogg', 15, 1)
		return
	playsound(user, 'sound/weapons/Gunshot.ogg', 15, 1)
	src.bullets--
	for(var/mob/O in viewers(user, null))
		O.show_message(SPAN_DANGER("<B>[user]朝[target]发射了响纸枪！</B>"), SHOW_MESSAGE_VISIBLE, SPAN_DANGER("你听见一声枪响。"), SHOW_MESSAGE_AUDIBLE)

/obj/item/toy/gun_ammo
	name = "响纸弹盒"
	desc = "还剩7发响纸弹！用完后记得将盒子放入自动车床回收。"
	icon_state = "cap_ammo"
	w_class = SIZE_TINY

	matter = list("metal" = 10,"glass" = 10)

	var/amount_left = 7

/obj/item/toy/gun_ammo/update_icon()
	if(amount_left)
		icon_state = "cap_ammo"
	else
		icon_state = "cap_ammo_e"


/*
 * Toy crossbow
 */

/obj/item/toy/crossbow
	name = "泡沫飞镖弩"
	desc = "许多精力过剩的小孩喜欢的武器，适合8岁及以上人群。"
	icon_state = "foamcrossbow"
	item_state = "crossbow"
	w_class = SIZE_SMALL
	attack_verb = list("攻击", "敲击", "击打")
	var/bullets = 5

/obj/item/toy/crossbow/examine(mob/user)
	..()
	if (bullets)
		to_chat(user, SPAN_NOTICE("里面装有[bullets]支泡沫飞镖！"))

/obj/item/toy/crossbow/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/toy/crossbow_ammo))
		if(bullets <= 4)
			if(user.drop_held_item())
				qdel(I)
				bullets++
				to_chat(user, SPAN_NOTICE("你将泡沫飞镖装入了弩中。"))
		else
			to_chat(usr, SPAN_DANGER("已经装满了。"))


/obj/item/toy/crossbow/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(!isturf(target.loc) || target == user) return
	if(flag) return

	if (locate (/obj/structure/surface/table, src.loc))
		return
	else if (bullets)
		var/turf/trg = get_turf(target)
		var/obj/effect/foam_dart_dummy/D = new/obj/effect/foam_dart_dummy(get_turf(src))
		bullets--
		D.icon_state = "foamdart"
		D.name = "泡沫飞镖"
		playsound(user.loc, 'sound/items/syringeproj.ogg', 15, 1)

		for(var/i=0, i<6, i++)
			if (D)
				if(D.loc == trg) break
				step_towards(D,trg)

				for(var/mob/living/M in D.loc)
					if(!istype(M,/mob/living)) continue
					if(M == user) continue
					for(var/mob/O in viewers(GLOB.world_view_size, D))
						O.show_message(SPAN_DANGER("[M]被泡沫飞镖击中了！"), SHOW_MESSAGE_VISIBLE)
					new /obj/item/toy/crossbow_ammo(M.loc)
					qdel(D)
					return

				for(var/atom/A in D.loc)
					if(A == user) continue
					if(A.density)
						new /obj/item/toy/crossbow_ammo(A.loc)
						qdel(D)

			sleep(1)

		spawn(10)
			if(D)
				new /obj/item/toy/crossbow_ammo(D.loc)
				qdel(D)

		return
	else if (bullets == 0)
		user.apply_effect(5, WEAKEN)
		for(var/mob/O in viewers(GLOB.world_view_size, user))
			O.show_message(SPAN_DANGER("[user]意识到没弹药了，开始四处寻找！"), SHOW_MESSAGE_VISIBLE)


/obj/item/toy/crossbow/attack(mob/living/M as mob, mob/user as mob)
	src.add_fingerprint(user)

	if (src.bullets > 0 && M.body_position == LYING_DOWN)

		for(var/mob/O in viewers(M, null))
			if(O.client)
				O.show_message(SPAN_DANGER("<B>[user]若无其事地瞄准[M]的头，扣下了扳机！</B>"), SHOW_MESSAGE_VISIBLE, SPAN_DANGER("你听见泡沫撞上脑袋的声音！"), SHOW_MESSAGE_AUDIBLE)
				O.show_message(SPAN_DANGER("[M]的头被泡沫飞镖击中了！"), SHOW_MESSAGE_VISIBLE)

		playsound(user.loc, 'sound/items/syringeproj.ogg', 15, 1)
		new /obj/item/toy/crossbow_ammo(M.loc)
		src.bullets--
	else if (M.body_position == LYING_DOWN && src.bullets == 0)
		for(var/mob/O in viewers(M, null))
			if (O.client)
				O.show_message(SPAN_DANGER("<B>[user]若无其事地瞄准[M]的头，扣下扳机，才发现没弹药了，于是趴到地上寻找！</B>"), SHOW_MESSAGE_VISIBLE, SPAN_DANGER("你听见有人趴倒在地。"), SHOW_MESSAGE_AUDIBLE)
		user.apply_effect(5, WEAKEN)
	return

/obj/item/toy/crossbow_ammo
	name = "泡沫飞镖"
	desc = "要玩就玩NERF！适合8岁及以上人群。"
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "foamdart"
	w_class = SIZE_TINY

/obj/effect/foam_dart_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/items/toy.dmi'
	icon_state = null
	anchored = TRUE
	density = FALSE


/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "玩具剑"
	desc = "廉价的塑料能量剑仿品，音效逼真！适合8岁及以上人群。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	var/active = 0
	w_class = SIZE_SMALL
	flags_item = NOSHIELD
	attack_verb = list("攻击", "敲击", "击打")

/obj/item/toy/sword/attack_self(mob/user)
	..()

	active = !active
	if (active)
		to_chat(user, SPAN_NOTICE("你手腕一抖，甩出了塑料剑刃。"))
		playsound(user, 'sound/weapons/saberon.ogg', 15, 1)
		icon_state = "swordblue"
		item_state = "swordblue"
		w_class = SIZE_LARGE
	else
		to_chat(user, SPAN_NOTICE("你将塑料剑刃推回了剑柄。"))
		playsound(user, 'sound/weapons/saberoff.ogg', 15, 1)
		icon_state = "sword0"
		item_state = "sword0"
		w_class = SIZE_SMALL

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

	add_fingerprint(user)

/obj/item/toy/katana
	name = "仿制武士刀"
	desc = "在D20规则下弱得可怜。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "katana"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOSHIELD
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	force = 5
	throwforce = 5
	w_class = SIZE_MEDIUM
	attack_verb = list("攻击", "挥斩", "刺击", "切割")

