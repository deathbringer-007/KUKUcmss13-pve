/* Kitchen tools
 * Contains:
 * Utensils
 * Spoons
 * Forks
 * Knives
 * Kitchen knives
 * Butcher's cleaver
 * Rolling Pins
 * Trays
 * Can openers
 */

/obj/item/tool/kitchen
	icon = 'icons/obj/items/kitchen_tools.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/kitchen_tools_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/kitchen_tools_righthand.dmi',
	)

/*
 * Utensils
 */
/obj/item/tool/kitchen/utensil
	force = 5
	w_class = SIZE_TINY
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	flags_atom = FPRINT|CONDUCT

	attack_verb = list("攻击", "刺击", "戳击")
	sharp = 0
	/// Descriptive string for currently loaded food object.
	var/loaded

/obj/item/tool/kitchen/utensil/Initialize()
	. = ..()
	if (prob(60))
		src.pixel_y = rand(0, 4)

	create_reagents(5)
	return

/obj/item/tool/kitchen/utensil/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if(user.a_intent != INTENT_HELP)
		return ..()

	if (reagents.total_volume > 0)
		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if(fullness > NUTRITION_HIGH)
			to_chat(user, SPAN_WARNING("[user == M ? "你" : "对方"]现在不想再吃了。"))
			return
		reagents.set_source_mob(user)
		reagents.trans_to_ingest(M, reagents.total_volume)
		if(M == user)
			for(var/mob/O in viewers(M, null))
				O.show_message(SPAN_NOTICE("[user]用[src]吃了一些[loaded]。"), SHOW_MESSAGE_VISIBLE)
				M.reagents.add_reagent("nutriment", 1)
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(SPAN_NOTICE("[user]用[src]喂[M]吃了一些[loaded]。"), SHOW_MESSAGE_VISIBLE)
				M.reagents.add_reagent("nutriment", 1)
		playsound(M.loc,'sound/items/eatfood.ogg', 15, 1)
		overlays.Cut()
		return
	else
		..()

/obj/item/tool/kitchen/utensil/fork
	name = "餐叉"
	desc = "一把餐叉。确实很尖。"
	icon_state = "fork"

/obj/item/tool/kitchen/utensil/pfork
	name = "塑料餐叉"
	desc = "太好了，不用洗餐具了。"
	icon_state = "pfork"

/obj/item/tool/kitchen/utensil/spoon
	name = "勺子"
	desc = "一把勺子。你能在里面看到自己倒映的脸。"
	icon_state = "spoon"
	attack_verb = list("攻击", "戳击")

/obj/item/tool/kitchen/utensil/pspoon
	name = "塑料勺子"
	desc = "一把塑料勺子。真无趣。"
	icon_state = "pspoon"
	attack_verb = list("攻击", "戳击")

/obj/item/tool/kitchen/utensil/mre_spork
	name = "MRE 即食军粮叉勺"
	desc = "一把棕色塑料叉勺，比看起来结实得多。传说曾有受困的陆战队员用它挖战壕。"
	icon_state = "mre_spork"
	attack_verb = list("攻击", "戳击")

/obj/item/tool/kitchen/utensil/mre_spork/fsr
	name = "FSR 突击口粮叉勺"
	desc = "一把棕色塑料叉勺，比看起来结实得多。传说曾有受困的陆战队员用它挖战壕。"

/*
 * Knives
 */
/obj/item/tool/kitchen/utensil/knife
	name = "餐刀"
	desc = "能切开任何食物。"
	icon_state = "knife"
	force = 10
	throwforce = 10
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = 1

/obj/item/tool/kitchen/utensil/knife/attack(target as mob, mob/living/user as mob)
	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 5)

/obj/item/tool/kitchen/utensil/pknife
	name = "塑料餐刀"
	desc = "钝得不能再钝的刀。"
	icon_state = "pknife"
	force = 10
	throwforce = 10

/obj/item/tool/kitchen/utensil/pknife/attack(target as mob, mob/living/user as mob)
	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 5)

/*
 * Kitchen knives
 */
/obj/item/tool/kitchen/knife
	name = "厨刀"
	icon_state = "knife"
	desc = "太空厨具公司生产的多用途主厨刀，保证多年使用后依然锋利。"
	flags_atom = FPRINT|CONDUCT
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = 1
	force = MELEE_FORCE_TIER_4
	w_class = SIZE_MEDIUM
	throwforce = 6
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	matter = list("metal" = 12000)

	attack_verb = list("劈砍", "刺击", "切割", "撕裂", "撕扯", "剁砍", "割伤")
	flags_human_ai = MELEE_WEAPON_ITEM | TOOL_ITEM

/*
 * Plastic Pizza Cutter
 */
/obj/item/tool/kitchen/pizzacutter
	name = "披萨刀"
	icon_state = "plasticpizzacutter"
	desc = "用于切披萨的圆形刀片。这把配着廉价的塑料手柄。"
	flags_atom = FPRINT|CONDUCT
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = TRUE
	force = 10
	w_class = SIZE_MEDIUM
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwforce = 6
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	matter = list("metal" = 12000)

	attack_verb = list("劈砍", "刺击", "切割", "撕裂", "撕扯", "剁砍", "割伤")

/*
 * Wood Pizza Cutter
 */
/obj/item/tool/kitchen/pizzacutter/wood
	icon_state = "woodpizzacutter"
	desc = "用于切披萨的圆形刀片。这把配着货真价实的木制手柄。"

/*
 * Holy Relic Pizza Cutter
 */
/obj/item/tool/kitchen/pizzacutter/holyrelic
	name = "\improper 披萨时间"
	icon_state = "holyrelicpizzacutter"
	desc = "你面前是一件远古圣物，来自伟大的披萨领主统治一切的时代。当然，它也可能只是一把大得离谱的披萨刀。"
	force = MELEE_FORCE_VERY_STRONG

/*
 * Bucher's cleaver
 */
/obj/item/tool/kitchen/knife/butcher
	name = "屠夫砍刀"
	icon_state = "butch"
	desc = "用于剁肉和切肉的大块头。小丑和小丑副产品也包括在内。"
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL
	throwforce = 8
	throw_speed = SPEED_VERY_FAST
	throw_range = 6
	matter = list("metal" = 12000)

	attack_verb = list("劈开", "劈砍", "刺击", "切割", "撕裂", "撕扯", "剁砍", "割伤")
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = 1

/obj/item/tool/kitchen/knife/butcher/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 5)

/*
 * Rolling Pins
 */

/obj/item/tool/kitchen/rollingpin
	name = "擀面杖"
	desc = "用于敲晕酒保。"
	icon_state = "rolling_pin"
	force = 8
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 7
	w_class = SIZE_MEDIUM
	attack_verb = list("猛击", "痛击", "钝击", "痛打", "重击")

/obj/item/tool/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	var/obj/limb/affecting = user.zone_selected
	var/drowsy_threshold = 0

	drowsy_threshold = CLOTHING_ARMOR_MEDIUM - M.getarmor(affecting, ARMOR_MELEE)

	if(affecting == "head" && istype(M, /mob/living/carbon/) && !isxeno(M))
		for(var/mob/O in viewers(user, null))
			if(M != user)
				O.show_message(text(SPAN_DANGER("<B>[user]用[name]砸中了[M]的头！</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[M]用[name]砸了自己的头！</B>")), SHOW_MESSAGE_VISIBLE)
		if(drowsy_threshold > 0)
			M.apply_effect(min(drowsy_threshold, 10) , DROWSY)

		M.apply_damage(force, BRUTE, affecting, sharp=0) //log and damage the custom hit
		user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by  [key_name(user)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)])</font>"
		msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(intent_text(user.a_intent))]) (DAMTYE: [uppertext(damtype)]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	else //Regular attack text
		. = ..()

	return

/*
 * Trays - Agouri
 */
/obj/item/tool/kitchen/tray
	name = "托盘"
	icon = 'icons/obj/items/kitchen_tools.dmi'
	icon_state = "tray"
	desc = "用于盛放食物的金属托盘。"
	throwforce = 12
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	flags_atom = FPRINT|CONDUCT
	matter = list("metal" = 3000)
	/// shield bash cooldown. based on world.time
	var/cooldown = 0

/obj/item/tool/kitchen/tray/attack(mob/living/carbon/M, mob/living/carbon/user)
	to_chat(user, SPAN_WARNING("你不小心用[src]砸到了自己！"))
	user.apply_effect(1, WEAKEN)
	user.take_limb_damage(2)

	playsound(M, 'sound/items/trayhit2.ogg', 25, 1) //sound playin'
	return //it always returns, but I feel like adding an extra return just for safety's sakes. EDIT; Oh well I won't :3

/obj/item/tool/kitchen/tray/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("[user]用[W]敲打[src]！"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 25, 1)
			cooldown = world.time
	else
		..()

/*
 * Can opener
 */
/obj/item/tool/kitchen/can_opener //it has code connected to it in /obj/item/reagent_container/food/drinks/cans/attackby
	name = "开罐器"
	desc = "一个简单的开罐器。进步人民联盟重视食物储存，因此这种工具在那里很受欢迎。"
	icon = 'icons/obj/items/kitchen_tools.dmi'
	icon_state = "can_opener"
	w_class = SIZE_SMALL
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 1
	force = MELEE_FORCE_TIER_2
	attack_verb = list("夹击", "夹剪", "割伤")

/obj/item/tool/kitchen/can_opener/compact
	name = "折叠开罐器"
	desc = "小巧的开罐器，可折叠成便于安全收纳的形态。进步人民联盟重视食物储存，因此这种工具在那里很受欢迎。"
	icon_state = "can_opener_compact"
	w_class = SIZE_TINY
	var/active = 0
	hitsound = null
	force = 0
	edge = 0
	sharp = 0
	attack_verb = list("轻拍", "轻敲")

/obj/item/tool/kitchen/can_opener/compact/attack_self(mob/user)
	..()

	active = !active
	if(active)
		to_chat(user, SPAN_NOTICE("你展开了[src]。"))
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
		force = MELEE_FORCE_TIER_2
		edge = 1
		sharp = IS_SHARP_ITEM_SIMPLE
		hitsound = 'sound/weapons/bladeslice.ogg'
		icon_state += "_open"
		w_class = SIZE_SMALL
		attack_verb = list("夹击", "夹剪", "割伤")
	else
		to_chat(user, SPAN_NOTICE("[src]现在可以隐蔽携带了。"))
		force = initial(force)
		edge = 0
		sharp = 0
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)
		add_fingerprint(user)
