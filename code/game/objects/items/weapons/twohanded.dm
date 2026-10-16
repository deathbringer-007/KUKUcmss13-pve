	/*##################################################################
	Much improved now. Leaving the overall item procs here since they're
	easier to find that way. Theoretically any item may be twohanded,
	but only these items and guns benefit from it. ~N
	####################################################################*/

/obj/item/weapon/twohanded
	var/force_wielded = 0
	var/wieldsound = null
	var/unwieldsound = null
	force = MELEE_FORCE_NORMAL
	force_wielded = MELEE_FORCE_VERY_STRONG
	flags_item = TWOHANDED

/obj/item/weapon/twohanded/update_icon()
	return

/obj/item/weapon/twohanded/mob_can_equip(mob/user)
	unwield(user)
	return ..()

/obj/item/weapon/twohanded/dropped(mob/user)
	..()
	unwield(user)

/obj/item/proc/wield(mob/user)
	if( !(flags_item & TWOHANDED) || flags_item & WIELDED ) return

	var/obj/item/I = user.get_inactive_hand()
	if(I)
		user.drop_inv_item_on_ground(I)

	if(ishuman(user))
		var/check_hand = user.r_hand == src ? "l_hand" : "r_hand"
		var/mob/living/carbon/human/wielder = user
		var/obj/limb/hand = wielder.get_limb(check_hand)
		if( !istype(hand) || !hand.is_usable() )
			to_chat(user, SPAN_WARNING("你的另一只手无法握住[src]！"))
			return

	flags_item    ^= WIELDED
	name    += "（双手持握）"
	item_state += "_w"
	place_offhand(user,initial(name))
	return 1

/obj/item/proc/unwield(mob/user)
	if( (flags_item|TWOHANDED|WIELDED) != flags_item)
		return FALSE//Have to be actually a twohander and wielded.
	flags_item ^= WIELDED
	SEND_SIGNAL(src, COMSIG_ITEM_UNWIELD, user)
	var/wielded_suffix = "（双手持握）"
	if(copytext(name, -10) == " (Wielded)")
		wielded_suffix = " (Wielded)"
	name = copytext(name, 1, -length(wielded_suffix))
	item_state  = copytext(item_state,1,-2)
	remove_offhand(user)
	return TRUE

/obj/item/proc/place_offhand(mob/user,item_name)
	to_chat(user, SPAN_NOTICE("你用双手握住了[item_name]。"))
	user.recalculate_move_delay = TRUE
	var/obj/item/weapon/twohanded/offhand/offhand = new /obj/item/weapon/twohanded/offhand(user)
	offhand.name = "[item_name]——副手握持"
	offhand.desc = "你用另一只手握住了[item_name]。"
	offhand.flags_item |= WIELDED
	user.put_in_inactive_hand(offhand)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand()

/obj/item/proc/remove_offhand(mob/user)
	to_chat(user, SPAN_NOTICE("你现在单手拿着[name]。"))
	user.recalculate_move_delay = TRUE
	var/obj/item/weapon/twohanded/offhand/offhand = user.get_inactive_hand()
	if(istype(offhand)) offhand.unwield(user)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand()

/obj/item/weapon/twohanded/wield(mob/user)
	. = ..()
	if(!.) return
	user.recalculate_move_delay = TRUE
	if(wieldsound) playsound(user, wieldsound, 15, 1)
	force = force_wielded

/obj/item/weapon/twohanded/unwield(mob/user)
	. = ..()
	if(!.) return
	user.recalculate_move_delay = TRUE
	if(unwieldsound) playsound(user, unwieldsound, 15, 1)
	force = initial(force)

/obj/item/weapon/twohanded/attack_self(mob/user)
	..()
	if(ismonkey(user))
		to_chat(user, SPAN_WARNING("这东西太重，你无法用双手握持！"))
		return

	if(flags_item & WIELDED) unwield(user)
	else wield(user)

///////////OFFHAND///////////////
/obj/item/weapon/twohanded/offhand
	w_class = SIZE_HUGE
	icon_state = "offhand"
	name = "副手握持"
	flags_item = DELONDROP|TWOHANDED|WIELDED|CANTSTRIP

/obj/item/weapon/twohanded/offhand/unwield(mob/user)
	if(flags_item & WIELDED)
		flags_item &= ~WIELDED
		user.temp_drop_inv_item(src)
		qdel(src)

/obj/item/weapon/twohanded/offhand/wield()
	qdel(src) //This shouldn't even happen.

/obj/item/weapon/twohanded/offhand/dropped(mob/user)
	..()
	//This hand should be holding the main weapon. If everything worked correctly, it should not be wielded.
	//If it is, looks like we got our hand torn off or something.
	if(!QDESTROYING(src))
		var/obj/item/main_hand = user.get_active_hand()
		if(main_hand) main_hand.unwield(user)

/*
 * Fireaxe
 */
/obj/item/weapon/twohanded/fireaxe
	name = "消防斧"
	desc = "真是疯子才会用的武器。谁会想到拿斧头来灭火？"
	icon_state = "fireaxe"
	item_state = "fireaxe"
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_item = TWOHANDED
	attack_verb = list("攻击", "劈砍", "劈开", "撕扯", "割伤")

/obj/item/weapon/twohanded/fireaxe/wield(mob/user)
	. = ..()
	if(!.) return
	pry_capable = IS_PRY_CAPABLE_SIMPLE

/obj/item/weapon/twohanded/fireaxe/unwield(mob/user)
	. = ..()
	if(!.) return
	pry_capable = 0

/obj/item/weapon/twohanded/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && (flags_item & WIELDED) && istype(A,/obj/structure/grille)) //destroys grilles in one hit
		qdel(A)

/obj/item/weapon/twohanded/sledgehammer
	name = "大锤"
	desc = "一根长柄末端装着大块金属。砸个痛快！"
	icon_state = "sledgehammer"
	item_state = "sledgehammer"
	sharp = null
	edge = 0
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_item = TWOHANDED
	attack_verb = list("砸击", "殴打", "猛砸", "击打", "砸击", "痛打", "敲击")

//The following is copypasta and not the sledge being a child of the fireaxe due to the fire axe being able to crowbar airlocks
/obj/item/weapon/twohanded/sledgehammer/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && (flags_item & WIELDED) && istype(A,/obj/structure/grille)) //destroys grilles in one hit
		qdel(A)

/*
 * Double-Bladed Energy Swords - Cheridan
 */
/obj/item/weapon/twohanded/dualsaber
	name = "双刃能量剑"
	desc = "请小心使用。"
	icon_state = "dualsaber"
	item_state = "dualsaber"
	force = 3
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	force_wielded = 75
	wieldsound = 'sound/weapons/saberon.ogg'
	unwieldsound = 'sound/weapons/saberoff.ogg'
	flags_atom = FPRINT|QUICK_DRAWABLE|NOBLOODY
	flags_item = NOSHIELD|TWOHANDED

	attack_verb = list("攻击", "劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
	sharp = IS_SHARP_ITEM_BIG
	edge = 1

/obj/item/weapon/twohanded/dualsaber/attack(target as mob, mob/living/user as mob)
	..()
	if((flags_item & WIELDED) && prob(50))
		spawn(0)
			for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
				user.setDir(i)
				sleep(1)

/obj/item/weapon/twohanded/dualsaber/IsShield()
	if(flags_item & WIELDED) return 1

/obj/item/weapon/twohanded/dualsaber/wield(mob/user)
	. = ..()
	if(!.) return
	icon_state += "_w"

/obj/item/weapon/twohanded/dualsaber/unwield(mob/user)
	. = ..()
	if(!.) return
	icon_state = copytext(icon_state,1,-2)

/obj/item/weapon/twohanded/spear
	name = "长矛"
	desc = "一件沿用古老设计的武器，虽制作粗糙，却依然致命。"
	icon_state = "spearglass"
	item_state = "spearglass"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	throwforce = 35
	throw_speed = SPEED_VERY_FAST
	edge = 1
	sharp = IS_SHARP_ITEM_SIMPLE
	flags_item = NOSHIELD|TWOHANDED
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("攻击", "刺击", "戳击", "撕扯", "刺穿")

/obj/item/weapon/twohanded/lungemine
	name = "刺突爆雷"
	icon_state = "lungemine"
	item_state = "lungemine"
	desc = "一枚粗制而庞大的聚能装药，固定在长杆末端，光看着就令人胆寒。使用时须双手握紧，将装药前端的触杆刺向目标。爆炸会在使用者面前发生，设计者似乎对此毫不在意。真正属于英雄的武器。"
	force = MELEE_FORCE_WEAK
	force_wielded = 1
	attack_verb = list("猛击")
	hitsound = "swing_hit"

	var/detonating = FALSE
	var/wielded_attack_verb = list("冲撞")
	var/wielded_hitsound = null
	var/unwielded_attack_verb = list("猛击")
	var/unwielded_hitsound = "swing_hit"

	/// This controls how strong the explosion will be on the lunge mine. Higher is better.
	var/detonation_force = 150

/obj/item/weapon/twohanded/lungemine/wield(mob/user)
	. = ..()
	if(!.) return
	attack_verb = wielded_attack_verb
	hitsound = wielded_hitsound

/obj/item/weapon/twohanded/lungemine/unwield(mob/user)
	. = ..()
	if(!.) return
	attack_verb = unwielded_attack_verb
	hitsound = unwielded_hitsound

/obj/item/weapon/twohanded/lungemine/attack(mob/living/M, mob/living/user)
	. = ..()
	detonate_check(M, user)

/obj/item/weapon/twohanded/lungemine/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag)
		detonate_check(target, user)

/obj/item/weapon/twohanded/lungemine/proc/detonate_check(atom/target, mob/user)
	if(detonating) //don't detonate twice
		return

	if(!(flags_item & WIELDED)) //must be wielded to detonate
		return

	if(!istype(target))
		return

	if(!target.density && !istype(target, /mob))
		return

	if(target == user)
		return

	detonating = TRUE
	playsound(user, 'sound/items/Wirecutter.ogg', 50, 1)

	sleep(3)

	var/turf/epicenter = get_turf(target)
	target.ex_act(400, null, src, user, 100)
	cell_explosion(epicenter, detonation_force, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), user))
	qdel(src)

/obj/item/weapon/twohanded/lungemine/damaged
	name = "受损的刺突爆雷"
	desc = "一枚粗制而庞大的聚能装药，固定在长杆末端，光看着就令人胆寒。使用时须双手握紧，将装药前端的触杆刺向目标。爆炸会在使用者面前发生，设计者似乎对此毫不在意。真正属于英雄的武器。这枚似乎损坏严重，你最好连捡都别捡。"
	detonation_force = 50

/obj/item/weapon/twohanded/breacher
	name = "\improper D2破障锤"
	desc = "B5破障锤的轻量化版本，挥击力量足以轻松拆墙。它几乎无坚不摧，冲击力如同卡车撞击；与前代不同，多数成年人都能使用。"
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "d2_breacher"
	item_state = "d2_breacher"
	force = MELEE_FORCE_NORMAL
	force_wielded = MELEE_FORCE_NORMAL
	w_class = SIZE_LARGE
	flags_item = TWOHANDED
	flags_equip_slot = SLOT_BACK
	attack_verb = list("粉碎", "砸击", "重击", "碾碎", "锤击", "砸毁")
	var/really_heavy = FALSE

/obj/item/weapon/twohanded/breacher/synth
	name = "\improper B5破障锤"
	desc = "这把重达100磅的巨锤由实心碳化钨制成，一记挥击就足以轻松拆墙。它能砸穿钢铁和混凝土，冲击力如同卡车撞击，没有超人般的力量根本无法使用。"
	icon_state = "syn_breacher"
	item_state = "syn_breacher"
	force_wielded = MELEE_FORCE_VERY_STRONG
	really_heavy = TRUE
	var/move_delay_addition = 1.5

/obj/item/weapon/twohanded/breacher/synth/pickup(mob/user)
	if(!(HAS_TRAIT(user, TRAIT_SUPER_STRONG)))
		to_chat(user, SPAN_HIGHDANGER("你勉强将[src]举过膝盖。这东西对你来说恐怕派不上用场。"))
		user.apply_effect(3, EYE_BLUR)
		RegisterSignal(user, COMSIG_HUMAN_POST_MOVE_DELAY, PROC_REF(handle_movedelay))

		return
	..()

/obj/item/weapon/twohanded/breacher/synth/proc/handle_movedelay(mob/living/M, list/movedata)
	SIGNAL_HANDLER
	movedata["move_delay"] += move_delay_addition

/obj/item/weapon/twohanded/breacher/synth/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_HUMAN_POST_MOVE_DELAY)

/obj/item/weapon/twohanded/breacher/synth/attack(target as mob, mob/living/user as mob)
	if(!HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		to_chat(user, SPAN_WARNING("[src]太重了，你无法用它作战！"))
		return
	..()
