/obj/item/weapon/banhammer
	desc = "一把封禁之锤。"
	name = "封禁之锤"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "toyhammer"
	flags_equip_slot = SLOT_WAIST
	throwforce = 0
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	attack_verb = list("封禁")

/obj/item/weapon/nullrod
	name = "抑灵杖"
	desc = "一根纯黑曜石制成的杖，仅凭其存在就能干扰并抑制超自然力量。"
	icon_state = "nullrod"
	item_state = "nullrod"
	flags_equip_slot = SLOT_WAIST
	force = 15
	throw_speed = SPEED_FAST
	throw_range = 4
	throwforce = 10
	w_class = SIZE_SMALL

/obj/item/weapon/harpoon
	name = "捕鲸叉"
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 0
	desc = "看呐，鲸鱼喷气了！"
	icon_state = "harpoon"
	item_state = "harpoon"
	force = 20
	throwforce = 15
	w_class = SIZE_MEDIUM
	attack_verb = list("戳击","刺击","撕裂")

/obj/item/weapon/ice_axe
	name = "冰镐"
	desc = "主要用于攀登，也能当作不错的应急武器。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "ice_axe"
	item_state = "ice_axe"
	sharp = IS_SHARP_ITEM_ACCURATE
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	force = MELEE_FORCE_TIER_4
	throw_speed = SPEED_FAST
	throw_range = 2
	throwforce = 40

/obj/item/weapon/ice_axe/red
	icon_state = "ice_axe_red"

/obj/item/weapon/ice_axe/green
	icon_state = "ice_axe_green"

/obj/item/weapon/baseballbat
	name = "\improper 木制棒球棍"
	desc = "一根大号木制棒球棍。常用于殖民地的娱乐活动，也可用于自卫。地痞流氓往往随身携带。"
	icon_state = "woodbat"
	item_state = "woodbat"
	sharp = 0
	edge = 0
	w_class = SIZE_MEDIUM
	force = MELEE_FORCE_NORMAL
	throw_speed = SPEED_VERY_FAST
	throw_range = 7
	throwforce = 7
	attack_verb = list("砸击", "殴打", "猛砸", "击打", "砸击", "痛打", "敲击")
	hitsound = 'sound/weapons/genhit3.ogg'

/obj/item/weapon/baseballbat/metal
	name = "\improper 金属棒球棍"
	desc = "一根大号金属棒球棍。比起木制款，金属款的打击力更强。地痞流氓往往随身携带。"
	icon_state = "metalbat"
	item_state = "metalbat"
	force = MELEE_FORCE_STRONG
	w_class = SIZE_MEDIUM



/obj/item/weapon/butterfly
	name = "蝴蝶刀"
	desc = "一把普通的金属刀刃，藏在轻便的塑钢刀柄中。折叠后小巧得足以放进口袋。"
	icon_state = "butterflyknife"
	item_state = null
	hitsound = null
	var/active = 0
	w_class = SIZE_TINY
	force = MELEE_FORCE_WEAK
	sharp = 0
	edge = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 4
	throwforce = 7
	attack_verb = list("轻拍", "轻敲")
	attack_speed = 10


/obj/item/weapon/butterfly/attack_self(mob/user)
	..()

	active = !active
	if(active)
		to_chat(user, SPAN_NOTICE("你甩开了[src]的刀刃。"))
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
		force = MELEE_FORCE_STRONG //bay adjustments
		throwforce = MELEE_FORCE_NORMAL
		edge = 1
		sharp = IS_SHARP_ITEM_ACCURATE
		hitsound = 'sound/weapons/bladeslice.ogg'
		icon_state += "_open"
		w_class = SIZE_MEDIUM
		attack_verb = list("攻击", "劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
	else
		to_chat(user, SPAN_NOTICE("现在可以将[src]藏起来了。"))
		force = initial(force)
		edge = 0
		sharp = 0
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)
		add_fingerprint(user)

/obj/item/weapon/butterfly/switchblade
	name = "弹簧刀"
	desc = "一把带金色雕花的经典弹簧刀。光是拿着它，就让你觉得自己像个黑帮成员。"
	icon_state = "switchblade"

/obj/item/weapon/butterfly/katana
	name = "武士刀"
	desc = "一种源自日本的古老武器。"
	icon_state = "samurai"
	force = MELEE_FORCE_VERY_STRONG

/obj/item/weapon/wirerod
	name = "缠线金属棒"
	desc = "一根顶端缠有电线的金属棒，很容易在顶端固定些东西。"
	icon_state = "wiredrod"
	item_state = "rods"
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	w_class = SIZE_MEDIUM
	attack_verb = list("击打", "重击", "猛击", "敲打")

/obj/item/weapon/wirerod/attackby(obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/shard))
		var/obj/item/weapon/twohanded/spear/S = new /obj/item/weapon/twohanded/spear

		user.put_in_hands(S)
		to_chat(user, SPAN_NOTICE("你用电缆将玻璃碎片固定在金属棒顶端。"))
		qdel(I)
		qdel(src)
		update_icon(user)

	else if(HAS_TRAIT(I, TRAIT_TOOL_WIRECUTTERS))
		var/obj/item/weapon/baton/cattleprod/P = new /obj/item/weapon/baton/cattleprod

		user.put_in_hands(P)
		to_chat(user, SPAN_NOTICE("你用电缆将剪线钳固定在金属棒顶端，钳口朝外。"))
		qdel(I)
		qdel(src)
		update_icon(user)
	update_icon(user)


/obj/item/weapon/sword/katana/sharp
	name = "锋利得离谱的武士刀"
	desc = "<p>够了。我受够了CM-SS13现在这些吹捧\"大师级手半剑\"的鬼话。武士刀值得更高的评价，高得多得多。</p>\
<p>我当然知道自己在说什么。我亲自在日本花了2,400,000日元（大约20,000美元）订做了一把真正的武士刀，练了快两年。我甚至能用它斩开实心钢板。</p>\
<p>日本刀匠会花上数年锻造一把武士刀，折叠锻打多达一百万次，打造出人类已知最优秀的刀刃。</p>\
<p>武士刀的锋利度是欧洲剑的三倍，硬度也是三倍。长剑能斩开的东西，武士刀都能斩得更好。我很确信，只要一记竖劈，武士刀就能轻松把全身板甲的骑士劈成两半。</p>\
<p>想过中世纪的欧洲为什么从没去征服日本吗？没错，他们怕了那些纪律严明的武士和毁天灭地的武士刀。甚至到了二战，美军也会优先攻击拿武士刀的人，因为他们对武士刀的杀伤力既畏惧又敬重。</p>"
	icon_state = "katana"
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	force = 4444
	throwforce = MELEE_FORCE_VERY_STRONG
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	w_class = SIZE_MEDIUM
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_speed = 1

	var/kill_delay = 25
	var/number_of_cuts = 8
	var/list/already_dead = list()

	attack_verb = list("切割", "剁砍", "割伤")

/obj/item/weapon/sword/katana/sharp/attack(mob/living/M, mob/living/user)

	if(flags_item & NOBLUDGEON)
		return

	if (!istype(M)) // not sure if this is the right thing...
		return 0

	if( (M in already_dead) || (M.stat == DEAD) )
		to_chat(user, "[M]已经死了。")
		return 0

	already_dead += M
	spawn(kill_delay)
		already_dead -= M

	/////////////////////////
	M.last_damage_data = create_cause_data(initial(name), user)

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [key_name(user)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
	msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	/////////////////////////

	add_fingerprint(user)

	var/power = force
	if(user.skills)
		power = floor(power * (1 + 0.3*user.skills.get_skill_level(SKILL_MELEE_WEAPONS))) //30% bonus per melee level


	//if the target also has a katana (and we aren't attacking ourselves), we add some suspense
	if( ( istype(M.get_active_hand(), /obj/item/weapon/sword/katana) || istype(M.get_inactive_hand(), /obj/item/weapon/sword/katana) ) && M != user )

		if(prob(50))
			user.visible_message(SPAN_DANGER("[M]与[user]的刀刃交击！"))
		else
			M.visible_message(SPAN_DANGER("[user]与[M]的刀刃交击！"))
		playsound(user, 'sound/weapons/bladeslice.ogg', 25, 1)
		playsound(M, 'sound/weapons/bladeslice.ogg', 25, 1)
		user.animation_attack_on(M)
		user.flick_attack_overlay(M, "punch")
		M.animation_attack_on(user)
		M.flick_attack_overlay(user, "punch")
		spawn(5)
			user.apply_effect((kill_delay-5)/15, STUN)
			M.apply_effect((kill_delay-5)/15, STUN)

	else //No katana

		var/showname = "某人"
		if(user)
			showname = "[user]"
		if(!(user in viewers(M, null)))
			showname = "某人"

		var/used_verb = "攻击"
		if(LAZYLEN(attack_verb))
			used_verb = pick(attack_verb)
		user.visible_message(SPAN_DANGER("[M]遭到[showname]用[src][used_verb]。"),\
						SPAN_DANGER("你用[src][used_verb]了[M]。"), null, 5)

		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1)
		user.animation_attack_on(M)
		user.flick_attack_overlay(M, "punch")

		M.apply_effect(kill_delay/15, STUN)


	for (var/mob/O in hearers(GLOB.world_view_size, M))
		O << sound('sound/effects/Heart Beat.ogg', repeat = 1, wait = 0, volume = 100, channel = 2) //play on same channel as ambience
		spawn(kill_delay)
			O << sound(, , , , channel = 2) //cut sound


	spawn(kill_delay) //OMAE WA MOU SHINDEIRU

		playsound(M, 'sound/effects/bone_break1.ogg', 100, 1)

		for(var/i=1, i <= number_of_cuts, i++)
			var/def_zone = pick("head","l_leg","l_foot","r_leg","r_foot","l_arm","l_hand","r_arm","r_hand")
			switch(damtype)
				if("brute")
					M.apply_damage(power,BRUTE,def_zone)
				if("fire")
					M.apply_damage(power,BURN,def_zone)

	return 1
