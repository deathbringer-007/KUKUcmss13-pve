/obj/item/weapon/sword
	name = "战斗长剑"
	desc = "一把落满灰尘的长剑，通常只能在历史博物馆里见到。你究竟从哪弄来的，实在是个谜。只有雇佣兵才会疯狂到带着这种东西作战。剑刃磨得十分锋利，杀伤力惊人。"
	icon_state = "mercsword"
	item_state = "machete"
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_STRONG
	throwforce = MELEE_FORCE_WEAK
	sharp = IS_SHARP_ITEM_BIG
	flags_human_ai = MELEE_WEAPON_ITEM
	edge = 1
	w_class = SIZE_LARGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("攻击", "劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
	attack_speed = 9

/obj/item/weapon/sword/claymore
	name = "苏格兰大剑"
	desc = "还站在这里盯着看什么？快去杀敌！"
	icon_state = "claymore"
	item_state = "claymore"

/obj/item/weapon/sword/ceremonial
	name = "仪式长剑"
	desc = "一把代代相传的华丽仪式长剑。虽然年代久远，却保养得极好，状态依旧完美。"
	icon_state = "ceremonial"

/obj/item/weapon/sword/machete
	name = "\improper M2132砍刀"
	desc = "USCM最新配发的砍刀，非常适合在边远殖民地开辟丛林道路、清理灌木。侦察兵和追踪人员经常使用，不过常规装备不太方便携带它。"
	icon_state = "machete"

/obj/item/weapon/sword/machete/attack_self(mob/user)
	if(user.action_busy)
		return

	var/turf/root = get_turf(user)
	var/facing = user.dir
	var/turf/in_front = get_step(root, facing)

	// We check the tile in front of us, if it has flora that can be cut we will attempt to cut it
	for(var/obj/structure/flora/target in in_front)
		if(target.cut_level > 1)
			if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return
			target.attackby(src, user)

	return ..()

/obj/item/weapon/sword/machete/arnold
	name = "\improper M2100“恩加赫”砍刀"
	desc = "一种从未走出试验阶段的旧款USCM砍刀，设计于中非共和国。虽然钝击威力更强，刀身上的凹槽却难以清洁，因此USCM拒绝列装。常规装备也不太方便携带它。"
	icon_state = "arnold-machete"
	item_state = "arnold-machete"
	force = MELEE_FORCE_TIER_11

/obj/item/weapon/sword/machete/arnold/weak
	name = "\improper M2100砍刀"
	desc = "一种从未走出试验阶段的旧款USCM砍刀，设计于中非共和国。虽然钝击威力更强，刀身上的凹槽却难以清洁，因此USCM拒绝列装。这把保养不佳，性能已不如正式列装的M2132砍刀。"
	force = MELEE_FORCE_STRONG

/obj/item/weapon/sword/hefa
	name = "HEFA剑"
	icon_state = "hefasword"
	item_state = "hefasword"
	desc = "HEFA教团使用的刀剑，极其危险：命中目标时会爆炸，喷出一片弹雨。"
	attack_verb = list("拍打", "拍击", "重击")

	var/primed = FALSE

/obj/item/weapon/sword/hefa/proc/apply_explosion_overlay()
	var/obj/effect/overlay/O = new /obj/effect/overlay(loc)
	O.name = "手榴弹"
	O.icon = 'icons/effects/explosion.dmi'
	flick("grenade", O)
	QDEL_IN(O, 7)
	return

/obj/item/weapon/sword/hefa/attack_self(mob/user)
	..()

	primed = !primed
	var/msg = "你启动了[src]的引爆装置！现在击中他人时就会爆炸。"
	if(!primed)
		msg = "你关闭了[src]的引爆装置！"
	to_chat(user, SPAN_NOTICE(msg))

/obj/item/weapon/sword/hefa/attack(mob/target, mob/user)
	. = ..()
	if(!primed)
		return

	var/turf/epicenter = get_turf(user)
	epicenter = get_step(epicenter, user.dir)

	var/datum/cause_data/cause_data = create_cause_data(initial(name), user)
	create_shrapnel(epicenter, 48, dir, , /datum/ammo/bullet/shrapnel, cause_data)
	sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
	apply_explosion_overlay()
	cell_explosion(epicenter, 40, 18, EXPLOSION_FALLOFF_SHAPE_LINEAR, user.dir, cause_data)
	qdel(src)

/obj/item/weapon/sword/katana
	name = "武士刀"
	desc = "一把制作精良的日本刀，刀刃打磨得极其锋利，刃口薄至分子尺度，杀伤力惊人。常见于雇佣兵和日本黑帮手中。"
	icon_state = "katana"
	item_state = "katana"
	force = MELEE_FORCE_VERY_STRONG

//To do: replace the toys.
/obj/item/weapon/sword/katana/replica
	name = "仿制武士刀"
	desc = "普通刀具店里常见的廉价仿制品。仍有一定杀伤力。"
	force = MELEE_FORCE_WEAK
	throwforce = 7

/obj/item/weapon/throwing_knife
	name ="\improper M11飞刀"
	icon='icons/obj/items/weapons/weapons.dmi'
	icon_state = "throwing_knife"
	item_state = "combat_knife"
	desc = "专为投掷攻击敌人而设计的军用刀。比枪械安静得多，但需要稳健的手法才能发挥最佳效果——不过你大概还是直接用枪更好。"
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_TIER_1
	w_class = SIZE_SMALL
	throwforce = MELEE_FORCE_TIER_10 //increased by throwspeed to roughly 80
	throw_speed = SPEED_VERY_FAST
	throw_range = 7
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
	flags_equip_slot = SLOT_STORE|SLOT_FACE
	flags_armor_protection = SLOT_FACE
	flags_item = CAN_DIG_SHRAPNEL

/obj/item/weapon/unathiknife
	name = "决斗刀"
	desc = "一段缠着皮革的木头，上面嵌满剃刀般锋利的牙齿。真够粗野的。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "unathiknife"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("撕裂", "撕扯", "割伤")
	force = MELEE_FORCE_STRONG
	throwforce = MELEE_FORCE_STRONG
	edge = 1

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Colonial Companion Mk. II - Swiss Army Knife with multiple modes - sprites by Crowford.
/obj/item/weapon/swiss_army_knife
	name = "殖民伙伴Mk. II"
	desc = "每次冒险都值得信赖的伙伴。这把多功能工具可灵活折叠，在七种常用模式间切换，每种都有专门用途。无论你需要锋利的刀刃、精密的螺丝刀，还是顺手的勺子，只需手腕一翻，它就能随时应对眼前的挑战。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "swiss_stock"  // Default state when all tools are folded
	force = 0
	throwforce = 0
	sharp = 0
	throw_range = 6
	w_class = SIZE_SMALL  // Size for all modes
	var/mode = "Closed"
	attack_verb = list("击打")
	var/loaded

/obj/item/weapon/swiss_army_knife/Initialize(mapload, ...)
	. = ..()
	create_reagents(5)

/obj/item/weapon/swiss_army_knife/attack_hand(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/human = user
	if(human.l_hand != src && human.r_hand != src)
		return ..()
	var/list/tool_modes = list(
	"Closed" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "swiss_stock"),
	"Knife" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "swiss_knife"),
	"Screwdriver" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "swiss_screwdriver"),
	"Cutters" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "swiss_cutters"),
	"Spoon" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "swiss_spoon"),
	"Can Opener" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "swiss_opener"),
	"Corkscrew" = image(icon = 'icons/obj/items/weapons/weapons.dmi', icon_state = "swiss_corkscrew")
	)
	var/list/tool_labels = list("收起" = "Closed", "小刀" = "Knife", "螺丝刀" = "Screwdriver", "剪线钳" = "Cutters", "勺子" = "Spoon", "开罐器" = "Can Opener", "开瓶钻" = "Corkscrew")
	var/list/display_modes = list()
	for(var/label in tool_labels)
		display_modes[label] = tool_modes[tool_labels[label]]
	var/use_radials = user.client.prefs?.no_radials_preference ? FALSE : TRUE
	var/selected_label = use_radials ? show_radial_menu(user, user, display_modes, require_near = FALSE) : tgui_input_list(user, "选择工具", "展开附件", display_modes)
	switch_tool(tool_labels[selected_label])

/obj/item/weapon/swiss_army_knife/attack(mob/living/carbon/mob as mob, mob/living/carbon/user as mob)
	if(mode == "Cutters")
		if((mob.handcuffed) && (istype(mob.handcuffed, /obj/item/restraint/adjustable/cable)))
			user.visible_message("[usr]用[src]剪断了[mob]的束缚带！",\
			"你用[src]剪断了[mob]的束缚带！",\
			"你听见电缆被剪断的声音。")
			mob.handcuffed = null
			mob.handcuff_update()
			return
		else
			..()
	if(mode == "Spoon")
		if(!istype(mob))
			return ..()
		if(user.a_intent != INTENT_HELP)
			return ..()

		if (reagents.total_volume > 0)

			var/fullness = mob.nutrition + (mob.reagents.get_reagent_amount("nutriment") * 25)
			if(fullness > NUTRITION_HIGH)
				to_chat(user, SPAN_WARNING("[user == mob ? "你" : "对方"]现在不想再吃了。"))
				return
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(mob, reagents.total_volume)
			if(mob == user)
				for(var/mob/O in viewers(mob, null))
					O.show_message(SPAN_NOTICE("[user]用[src]吃了些[loaded]。"), SHOW_MESSAGE_VISIBLE)
				mob.reagents.add_reagent("nutriment", 1)
			else
				for(var/mob/O in viewers(mob, null))
					O.show_message(SPAN_NOTICE("[user]用[src]喂[mob]吃了些[loaded]。"), SHOW_MESSAGE_VISIBLE)
				mob.reagents.add_reagent("nutriment", 1)
			playsound(mob.loc,'sound/items/eatfood.ogg', 15, 1)
			overlays.Cut()
			return

/obj/item/weapon/swiss_army_knife/proc/switch_tool(new_state)
	switch(new_state)
		if("Closed")
			desc = initial(desc)
			force = initial(force)
			throwforce = initial(throwforce)
			sharp = initial(sharp)
			attack_verb = initial(attack_verb)
			flags_item = initial(flags_item)
			icon_state = initial(icon_state)
			attack_speed = initial(attack_speed)
			flags_atom = initial(flags_atom)
			REMOVE_TRAITS_IN(src,src)
		if("Knife")
			desc = "一把用来切东西的锋利小刀。"
			icon_state = "swiss_knife"
			sharp = IS_SHARP_ITEM_ACCURATE
			force = MELEE_FORCE_NORMAL
			throwforce = MELEE_FORCE_NORMAL
			throw_speed = SPEED_VERY_FAST
			throw_range = 6
			hitsound = 'sound/weapons/slash.ogg'
			attack_verb = list("劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
			attack_speed = 9
			flags_item = CAN_DIG_SHRAPNEL
		if("Screwdriver")
			desc = "一把可靠的螺丝刀，可满足各种紧固需求。"
			icon_state = "swiss_screwdriver"
			force = 2
			throwforce = 0
			flags_atom = FPRINT|CONDUCT
			matter = list("metal" = 75)
			attack_verb = list("刺击")
			flags_item = CAN_DIG_SHRAPNEL
			ADD_TRAIT(src,TRAIT_TOOL_SCREWDRIVER,src)
		if("Cutters")
			desc = "用于剪断电线及各种材料的剪线钳。"
			icon_state = "swiss_cutters"
			attack_verb = list("夹击", "夹剪")
			force = 5
			throwforce = 0
			flags_atom = FPRINT|CONDUCT
			sharp = IS_SHARP_ITEM_SIMPLE
			edge = 1
			ADD_TRAIT(src,TRAIT_TOOL_WIRECUTTERS,src)
		if("Spoon")
			desc = "一把普通的勺子。"
			icon_state = "swiss_spoon"
			attack_verb = list("挖戳", "搅动")
			force = 0
			throwforce = 0
			sharp = 0
		if("Can Opener")
			desc = "一个普通的开罐器，也能当刀用，只是威力较小。"
			icon_state = "swiss_opener"
			sharp = IS_SHARP_ITEM_ACCURATE
			force = MELEE_FORCE_WEAK
			throwforce = MELEE_FORCE_WEAK
			throw_speed = SPEED_VERY_FAST
			throw_range = 6
			hitsound = 'sound/weapons/slash.ogg'
			attack_verb = list("劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
			attack_speed = 9
			flags_item = CAN_DIG_SHRAPNEL
		if("Corkscrew")
			desc = "一个普通的开瓶钻。"
			icon_state = "swiss_corkscrew"
			force = 2
			throwforce = 0
			flags_atom = FPRINT|CONDUCT
			attack_verb = list("刺击")
			flags_item = CAN_DIG_SHRAPNEL
	mode = new_state
	update_icon()


/obj/item/weapon/swiss_army_knife/knife
	icon_state = "swiss_knife"
	desc = "一把用来切东西的锋利小刀。"
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_NORMAL
	throwforce = MELEE_FORCE_NORMAL
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
	attack_speed = 9
	flags_item = CAN_DIG_SHRAPNEL
/obj/item/weapon/swiss_army_knife/screwdriver
	icon_state = "swiss_screwdriver"
	desc = "一把可靠的螺丝刀，可满足各种紧固需求。"
	force = 2
	throwforce = 0
	flags_atom = FPRINT|CONDUCT
	matter = list("metal" = 75)
	attack_verb = list("刺击")
	flags_item = CAN_DIG_SHRAPNEL
	_status_traits = list(TRAIT_TOOL_SCREWDRIVER)

/obj/item/weapon/swiss_army_knife/screwdriver/attack(mob/living/carbon/mob as mob, mob/living/carbon/user as mob)
	if(!istype(mob))
		return ..()
	if(user.zone_selected != "eyes") // && user.zone_selected != "head")
		return ..()
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E)
			var/safety = H.get_eye_protection()
			if(!safety)
				user.visible_message(SPAN_DANGER("[user]用[src]刺中了[H]的眼睛！"),
					SPAN_DANGER("你用[src]刺中了[H]的眼睛！"))
				E.take_damage(rand(8,20))
	return ..()
/obj/item/weapon/swiss_army_knife/wirecutters
	icon_state = "swiss_cutters"
	desc = "用于剪断电线及各种材料的剪线钳。"
	attack_verb = list("夹击", "夹剪")
	force = 5
	throwforce = 0
	flags_atom = FPRINT|CONDUCT
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 1
	_status_traits = list(TRAIT_TOOL_WIRECUTTERS)

/obj/item/weapon/swiss_army_knife/wirecutters/attack(mob/living/carbon/mob, mob/user)
	if((mob.handcuffed) && (istype(mob.handcuffed, /obj/item/restraint/adjustable/cable)))
		user.visible_message("[usr]用[src]剪断了[mob]的束缚带！",\
		"你用[src]剪断了[mob]的束缚带！",\
		"你听见电缆被剪断的声音。")
		mob.handcuffed = null
		mob.handcuff_update()
		return
	else
		..()
/obj/item/weapon/swiss_army_knife/spoon
	icon_state = "swiss_spoon"
	desc = "一把普通的勺子。"
	attack_verb = list("挖戳", "搅动")
	force = 0
	throwforce = 0
	sharp = 0

/obj/item/weapon/swiss_army_knife/spoon/Initialize()
	. = ..()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	create_reagents(5)
	return

/obj/item/weapon/swiss_army_knife/spoon/attack(mob/living/carbon/mob as mob, mob/living/carbon/user as mob)
	if(!istype(mob))
		return ..()
	if(user.a_intent != INTENT_HELP)
		return ..()
	if (reagents.total_volume > 0)
		var/fullness = mob.nutrition + (mob.reagents.get_reagent_amount("nutriment") * 25)
		if(fullness > NUTRITION_HIGH)
			to_chat(user, SPAN_WARNING("[user == mob ? "你" : "对方"]现在不想再吃了。"))
			return
		reagents.set_source_mob(user)
		reagents.trans_to_ingest(mob, reagents.total_volume)
		if(mob == user)
			for(var/mob/O in viewers(mob, null))
				O.show_message(SPAN_NOTICE("[user]用[src]吃了些[loaded]。"), SHOW_MESSAGE_VISIBLE)
			mob.reagents.add_reagent("nutriment", 1)
		else
			for(var/mob/O in viewers(mob, null))
				O.show_message(SPAN_NOTICE("[user]用[src]喂[mob]吃了些[loaded]。"), SHOW_MESSAGE_VISIBLE)
			mob.reagents.add_reagent("nutriment", 1)
		playsound(mob.loc,'sound/items/eatfood.ogg', 15, 1)
		overlays.Cut()
		return
	else
		..()

/obj/item/weapon/swiss_army_knife/can_opener
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "swiss_opener"
	desc = "一个普通的开罐器，也能当刀用，只是威力较小。"
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
	attack_speed = 9
	flags_item = CAN_DIG_SHRAPNEL
/obj/item/weapon/swiss_army_knife/corkscrew
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "swiss_corkscrew"
	desc = "一个普通的开瓶钻。"
	attack_verb = list("旋拧", "钻刺", "戳刺", "扭转")
	force = 0
	throwforce = 0

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///For digging shrapnel out of OTHER people, not yourself. Triggered by human/attackby() so target is definitely human. User might not be.
/obj/item/proc/dig_out_shrapnel_check(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(user.a_intent == INTENT_HELP && (target == user || skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))) //Squad medics and above, or yourself
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/item, dig_out_shrapnel), target, user)
		return TRUE
	return FALSE

// If no user, it means that the embedded_human is removing it themselves
/obj/item/proc/dig_out_shrapnel(mob/living/carbon/human/embedded_human, mob/living/carbon/human/user = null)
	if(!user)
		user = embedded_human

	if(user.action_busy)
		return

	var/address_mode

	if(user != embedded_human)
		user.affected_message(embedded_human,
			SPAN_NOTICE("你开始检查[embedded_human]身上是否有弹片。"),
			SPAN_NOTICE("[user]开始检查你身上有哪些弹片需要取出。别动，可能会有点疼……"),
			SPAN_NOTICE("[user]开始检查[embedded_human]身上是否有弹片。"))
		address_mode = "[embedded_human]的" //includes "out of " to prevent capital-T 'The unknown'.
		if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, embedded_human, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			to_chat(user, SPAN_NOTICE("你的操作被打断了！"))
			return
	else
		user.visible_message(SPAN_NOTICE("[user]开始检查自己身上是否有弹片。"), \
			SPAN_NOTICE("你开始检查自己身上是否有弹片。"))
		address_mode = "你的"
		if(!do_after(embedded_human, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			to_chat(user, SPAN_NOTICE("你的操作被打断了！"))
			return

	var/list/removed_limbs = list()
	for(var/obj/item/shard/S in embedded_human.embedded_items)
		var/obj/limb/organ = S.embedded_organ

		if(!(organ.display_name in removed_limbs))
			removed_limbs += organ.display_name

		S.forceMove(embedded_human.loc)
		organ.implants -= S
		embedded_human.embedded_items -= S
		organ = null
		for(var/i in 1 to S.count-1)
			user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
			var/shrapnel = new S.type(S.loc)
			QDEL_IN(shrapnel, 300)
		user.count_niche_stat(STATISTICS_NICHE_SURGERY_SHRAPNEL)
		QDEL_IN(S, 300)

	if(length(removed_limbs))
		var/duglimbs = english_list(removed_limbs, and_text = "和", comma_text = "、", final_comma_text = "")
		user.affected_message(embedded_human,
			SPAN_NOTICE("你用[src.name]取出了[address_mode][duglimbs]里的弹片。"),
			SPAN_NOTICE("[user]用[src.name]取出了你[duglimbs]里的弹片。"),
			SPAN_NOTICE(user != embedded_human ? "[user]用[src.name]取出了[embedded_human]的[duglimbs]里的弹片。" : "[user]用[src.name]取出了自己[duglimbs]里的弹片。"))

		if(!embedded_human.stat && embedded_human.pain.feels_pain && embedded_human.pain.reduction_pain < PAIN_REDUCTION_HEAVY)
			if(prob(25))
				INVOKE_ASYNC(embedded_human, TYPE_PROC_REF(/mob, emote), "pain")
			else
				INVOKE_ASYNC(embedded_human, TYPE_PROC_REF(/mob, emote), "me", 1, pick("疼得皱起了眉头。", "疼得龇牙咧嘴。", "疼得缩了一下。"))

		SEND_SIGNAL(embedded_human, COMSIG_HUMAN_SHRAPNEL_REMOVED)

	else
		to_chat(user, SPAN_NOTICE("你没有找到任何弹片。"))

// Demo and example of a 64x64 weapon.
/obj/item/weapon/ritual
	name = "酷炫小刀"
	desc = "闪耀着强大的代码之力。"
	icon_state = "dark_blade"
	item_state = "dark_blade"
	force = MELEE_FORCE_VERY_STRONG
	throwforce = MELEE_FORCE_WEAK
	sharp = IS_SHARP_ITEM_BIG
	edge = TRUE
	w_class = SIZE_MEDIUM
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("攻击", "劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
	attack_speed = 7
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_64.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_64.dmi'
		)

/obj/item/weapon/straight_razor
	name = "折叠剃刀"
	desc = "司令最喜欢用来对付那些敢于违反仪容规定的陆战队员的武器。"
	icon_state = "razor"
	hitsound = 'sound/weapons/genhit3.ogg'
	force = MELEE_FORCE_TIER_1
	throwforce = MELEE_FORCE_TIER_1
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	w_class = SIZE_SMALL
	///Icon state for opened razor
	var/enabled_icon = "razor"
	///Icon state for closed razor
	var/disabled_icon = "razor_off"
	///If the razor is able to be used
	var/razor_opened = FALSE
	///Time taken to open/close the razor
	var/interaction_time = 3 SECONDS

/obj/item/weapon/straight_razor/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_ATTEMPTING_EQUIP, PROC_REF(can_fit_in_shoe))
	change_razor_state(razor_opened)
	if(prob(1))
		desc += "上面刻着一句话：“<i>保证给你此生最贴面的剃须体验。</i>”……"

/obj/item/weapon/straight_razor/update_icon()
	. = ..()
	if(razor_opened)
		icon_state = enabled_icon
		return
	icon_state = disabled_icon

/obj/item/weapon/straight_razor/attack_hand(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/human = user
	if(human.l_hand != src && human.r_hand != src) //Only do unique stuff if you are holding it
		return ..()

	playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	change_razor_state(!razor_opened)
	to_chat(user, SPAN_NOTICE("你[razor_opened ? "展开" : "收起"]了[src]的刀刃。"))

///Check if the item can fit as a boot knife, var/source for signals
/obj/item/weapon/straight_razor/proc/can_fit_in_shoe(source = src, mob/user, slot)
	if(slot != WEAR_IN_SHOES) //Only check if you try putting it in a shoe
		return
	if(razor_opened)
		to_chat(user, SPAN_NOTICE("必须先收起刀刃，才能把[src]放进鞋里。"))
		return COMPONENT_CANCEL_EQUIP

///Changes all the vars for the straight razor
/obj/item/weapon/straight_razor/proc/change_razor_state(opening = FALSE)
	razor_opened = opening
	update_icon()
	if(opening)
		force = MELEE_FORCE_NORMAL
		throwforce = MELEE_FORCE_NORMAL
		sharp = IS_SHARP_ITEM_ACCURATE
		edge = TRUE
		attack_verb = list("劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
		hitsound = 'sound/weapons/slash.ogg'
		if(!(flags_item & CAN_DIG_SHRAPNEL))
			flags_item |= CAN_DIG_SHRAPNEL
		return
	force = MELEE_FORCE_TIER_1
	throwforce = MELEE_FORCE_TIER_1
	sharp = FALSE
	edge = FALSE
	attack_verb = list("砸击", "殴打", "猛砸", "击打", "砸击", "痛打", "敲击")
	hitsound = 'sound/weapons/genhit3.ogg'
	if(flags_item & CAN_DIG_SHRAPNEL)
		flags_item &= ~CAN_DIG_SHRAPNEL

/obj/item/weapon/straight_razor/verb/change_hair_style()
	set name = "更换发型"
	set desc = "更换你的发型"
	set category = "物品"
	set src in usr

	var/mob/living/carbon/human/human_user = usr
	if(!istype(human_user))
		return

	if(!razor_opened)
		to_chat(human_user, SPAN_NOTICE("必须展开[src]的刀刃才能修剪发型。"))
		return

	var/list/species_facial_hair = GLOB.facial_hair_styles_list
	var/list/species_hair = GLOB.hair_styles_list

	if(human_user.species) //Facial hair
		species_facial_hair = list()
		for(var/current_style in GLOB.facial_hair_styles_list)
			var/datum/sprite_accessory/facial_hair/temp_beard_style = GLOB.facial_hair_styles_list[current_style]
			if(!(human_user.species.name in temp_beard_style.species_allowed))
				continue
			if(!temp_beard_style.selectable)
				continue
			species_facial_hair += current_style

	if(human_user.species) //Hair
		species_hair = list()
		for(var/current_style in GLOB.hair_styles_list)
			var/datum/sprite_accessory/hair/temp_hair_style = GLOB.hair_styles_list[current_style]
			if(!(human_user.species.name in temp_hair_style.species_allowed))
				continue
			if(!temp_hair_style.selectable)
				continue
			species_hair += current_style

	var/new_beard_style
	var/new_hair_style
	if(human_user.gender == MALE)
		new_beard_style = tgui_input_list(human_user, "选择胡须样式", "仪容修整", species_facial_hair)
	new_hair_style = tgui_input_list(human_user, "选择发型", "仪容修整", species_hair)

	if(loc != human_user)
		to_chat(human_user, SPAN_NOTICE("你离[src]太远，无法修剪发型。"))
		return

	if(!new_beard_style && !new_hair_style)
		return

	if(!do_after(human_user, interaction_time, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	if(!razor_opened)
		to_chat(human_user, SPAN_NOTICE("必须展开[src]的刀刃才能修剪发型。"))
		return

	if(new_beard_style)
		human_user.f_style = new_beard_style
	if(new_hair_style)
		human_user.h_style = new_hair_style

	human_user.apply_damage(rand(1,5), BRUTE, "head", src)
	human_user.update_hair()

/obj/item/weapon/straight_razor/attack(mob/target, mob/user)
	if((!ishuman(target)) || (user.a_intent == INTENT_HARM) || !razor_opened)
		return ..()
	var/mob/living/carbon/human/poor_bastard = target

	var/timer = 10 SECONDS
	var/message = "[user]开始给[poor_bastard]剃毛！"
	if(skillcheck(user, SKILL_LEADERSHIP, SKILL_LEAD_EXPERT))
		timer = 5 SECONDS
		message = "[user]开始<b>熟练地</b>给[poor_bastard]剃毛！"

	user.visible_message(SPAN_WARNING(message))
	if(!do_after(user, timer, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		return

	switch(user.zone_selected)
		if("mouth")
			poor_bastard.f_style = "Shaved"
			user.visible_message(SPAN_WARNING("[user]剃掉了[poor_bastard]的胡须！"))
		if("head")
			poor_bastard.h_style = pick("Skinhead", "Bald")
			user.visible_message(SPAN_WARNING("[user]剃掉了[poor_bastard]的头发！"))

	poor_bastard.apply_damage(rand(1,5), BRUTE, "head", src)
	poor_bastard.update_hair()
	return TRUE

/obj/item/weapon/knife/marine
	name = "\improper M13格斗刀"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "knife_gerber"
	item_state = "knife_gerber"
	desc = "阿玛特战场系统旗下的克肖-戈博公司研制的殖民地陆战队制式格斗刀。可轻松放入靴侧刀鞘，紧急情况下还能用于取出弹片。"
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_equip_slot = SLOT_WAIST|SLOT_FACE
	flags_armor_protection = SLOT_FACE
	flags_item = CAN_DIG_SHRAPNEL
	w_class = SIZE_SMALL
	edge = 1
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_NORMAL
	throwforce = MELEE_FORCE_NORMAL
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")
	attack_speed = 9

/obj/item/weapon/knife/marine/kabar
	name = "\improper KA-BAR多用途刀"
	icon_state = "knife_kabar"
	item_state = "knife_kabar"
	desc = "一把老式陆战队战斗刀。凭借标志性的外观及其与陆战队历史文化的联系，即使退出制式装备之列后，仍深受陆战队员喜爱。可轻松放入靴侧刀鞘，紧急情况下还能用于取出弹片。"

/obj/item/weapon/knife/marine/baker
	name = "\improper M1贝克式格斗刀"
	icon_state = "knife_baker"
	item_state = "knife_baker"
	desc = "在旧式设计基础上改进的现代刀具，主要配发给美国陆军和部分USASF部队。可轻松放入靴侧刀鞘，紧急情况下还能用于取出弹片。"

/obj/item/weapon/knife/marine/bowie
	name = "\improper 鲍伊格斗刀"
	icon_state = "knife_bowie"
	item_state = "knife_bowie"
	desc = "一把源自美国旧西部的大型格斗刀，威力惊人。它并非古董，而是为眼光挑剔的户外爱好者打造的优质装备。这才叫刀！"
	w_class = SIZE_MEDIUM
	force = MELEE_FORCE_TIER_6
	throwforce = MELEE_FORCE_WEAK
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("攻击", "劈砍", "刺击", "切割", "撕扯", "撕裂", "剁砍", "割伤")

/obj/item/weapon/knife/marine/bowie/kukri
	name = "\improper 廓尔喀多用途弯刀"
	icon_state = "knife_kukri"
	desc = "一种源自印度次大陆的大型反曲格斗刀，传统上由尼泊尔廓尔喀人或其太阳系外殖民地的后裔使用，极少见于外人手中。"
	flags_equip_slot = SLOT_WAIST

/obj/item/weapon/knife/marine/sas
	name = "\improper 费尔贝恩-赛克斯格斗刀"
	icon_state = "knife_fairbairn"
	item_state = "knife_gerber"
	desc = "这把刀不是用来处理猎物或干营地杂活的。它为杀人而生，数百年来一直如此。当其他一切都靠不住时，它仍会握在你手中，随时完成那残酷的使命。"
