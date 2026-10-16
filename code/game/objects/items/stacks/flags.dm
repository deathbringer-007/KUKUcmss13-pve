// Flags.

/obj/item/stack/flag
	name = "旗帜"
	desc = "一些色彩鲜艳的旗帜。"
	singular_name = "旗帜"
	amount = 10
	max_amount = 10
	icon = 'icons/obj/structures/props/mining.dmi'
	stack_id = "flags"
	var/upright = FALSE
	var/base_state

/obj/item/stack/flag/Initialize()
	. = ..()
	base_state = icon_state

/obj/item/stack/flag/red
	name = "红色旗帜"
	singular_name = "红色旗帜"
	icon_state = "redflag"

/obj/item/stack/flag/yellow
	name = "黄色旗帜"
	singular_name = "黄色旗帜"
	icon_state = "yellowflag"

/obj/item/stack/flag/green
	name = "绿色旗帜"
	singular_name = "绿色旗帜"
	icon_state = "greenflag"

/obj/item/stack/flag/blue
	name = "蓝色旗帜"
	singular_name = "蓝色旗帜"
	icon_state = "blueflag"

/obj/item/stack/flag/purple
	name = "紫色旗帜"
	singular_name = "紫色旗帜"
	icon_state = "purpleflag"

/obj/item/stack/flag/attackby(obj/item/W, mob/user)
	if(upright && istype(W,src.type))
		src.attack_hand(user)
	else
		..()

/obj/item/stack/flag/attack_hand(user)
	if(upright)
		upright = 0
		icon_state = base_state
		anchored = FALSE
		src.visible_message("<b>[user]</b>放倒了[src]。")
	else
		..()

/obj/item/stack/flag/attack_self(mob/user)
	..()

	var/turf/T = get_turf(src)
	if(!T)
		to_chat(user, "这种地形无法竖起旗帜。")
		return

	var/obj/item/stack/flag/F = locate() in get_turf(src)
	if(F && F.upright)
		to_chat(user, "这里已经有一面旗帜了。")
		return

	var/obj/item/stack/flag/newflag = new src.type(T)
	newflag.amount = 1
	newflag.upright = TRUE
	newflag.anchored = TRUE
	newflag.name = newflag.singular_name
	newflag.icon_state = "[newflag.base_state]_open"
	newflag.visible_message("<b>[user]</b>将[newflag]牢牢插在地上。")
	src.use(1)


/// PLANTABLE FLAG

/obj/structure/flag/plantable
	name = "旗帜"
	desc = "一面不知代表什么的旗帜。看起来可以收起来。"
	icon = 'icons/obj/structures/plantable_flag.dmi'
	pixel_x = 9 // All flags need to be offset to the right by 9 to be centered.
	layer = ABOVE_XENO_LAYER
	health = 150
	unacidable = TRUE

	/// The typepath for the flag item that gets spawned when the flag is taken down.
	var/flag_type = /obj/item/flag/plantable
	/// Used to limit the spam of the warcry_extra_sound
	COOLDOWN_DECLARE(warcry_cooldown_struc)

/obj/structure/flag/plantable/attack_hand(mob/user)
	..()
	disassemble(user, flag_type)

/// Proc for dismantling the flag into an item that can be picked up.
/obj/structure/flag/plantable/proc/disassemble(mob/user, flag_type)
	if(user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user]开始收起[src]……"), SPAN_NOTICE("你开始收起[src]……"))

	playsound(loc, 'sound/effects/flag_raising.ogg', 30)
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC) || QDELETED(src))
		return

	playsound(loc, 'sound/effects/flag_raised.ogg', 30)
	user.visible_message(SPAN_NOTICE("[user]收起了[src]！"), SPAN_NOTICE("你收起了[src]！"))
	var/obj/item/flag/plantable/flag_item = new flag_type(loc)
	user.put_in_hands(flag_item)
	COOLDOWN_START(flag_item, warcry_cooldown_item, COOLDOWN_TIMELEFT(src, warcry_cooldown_struc))
	qdel(src)

/// Proc for when the flag gets forcefully dismantled (due to general damage, explosions, etc.)
/obj/structure/flag/plantable/proc/demolish(flag_type)
	playsound(loc, 'sound/effects/flag_raised.ogg', 30)
	visible_message(SPAN_WARNING("[src]倒在了地上！"))
	var/obj/item/flag/plantable/flag_item = new flag_type(loc)
	COOLDOWN_START(flag_item, warcry_cooldown_item, COOLDOWN_TIMELEFT(src, warcry_cooldown_struc))
	qdel(src)

// Procs for handling damage.
/obj/structure/flag/plantable/update_health(damage)
	if(damage)
		health -= damage
	if(health <= 0)
		demolish(flag_type)

/obj/structure/flag/plantable/ex_act(severity)
	if(health <= 0)
		return
	update_health(severity)

/obj/structure/flag/plantable/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent == INTENT_HARM)
		if(unslashable)
			return
		xeno.animation_attack_on(src)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno]挥爪抓向[src]！"), SPAN_DANGER("我们挥爪抓向[src]！"), null, 5, CHAT_TYPE_XENO_COMBAT)
		update_health(rand(xeno.melee_damage_lower, xeno.melee_damage_upper))
		return XENO_ATTACK_ACTION
	else
		to_chat(xeno, SPAN_WARNING("我们茫然地盯着[src]。"))
		return XENO_NONCOMBAT_ACTION

/obj/structure/flag/plantable/bullet_act(obj/projectile/bullet)
	bullet_ping(bullet)
	visible_message(SPAN_DANGER("[bullet]击中了[src]！"), null, 4, CHAT_TYPE_TAKING_HIT)
	update_health(bullet.damage)
	return TRUE

/obj/structure/flag/plantable/attackby(obj/item/weapon, mob/living/user)
	if(!indestructible)
		visible_message(SPAN_DANGER("[user]用[weapon]击中了[src]！"), null, 5, CHAT_TYPE_MELEE_HIT)
		user.animation_attack_on(src)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		update_health(weapon.force * weapon.demolition_mod)

/obj/item/flag/plantable
	name = "可插设旗帜"
	desc = "一面不知代表什么的旗帜。已经可以插在地上了。"
	w_class = SIZE_LARGE
	throw_range = 2
	icon = 'icons/obj/structures/plantable_flag.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 15
	throwforce = 5
	hitsound = "swing_hit"
	unacidable = TRUE
	indestructible = TRUE
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_64.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_64.dmi'
		)

	/// The typepath of the flag structure that gets spawned when the flag is planted.
	var/flag_type = /obj/structure/flag/plantable
	/// Used to check if nearby mobs belong to a faction when calculating for the stronger warcry.
	var/faction
	/// Does the flag play a unique warcry when planted? (Only while on harm intent.)
	var/play_warcry = FALSE
	/// The warcry's sound path.
	var/warcry_sound
	/// When there are more than 14 allies nearby, play this stronger warcry.
	var/warcry_extra_sound
	/// How many nearby allies do we need for the stronger warcry to be played?
	var/allies_required = 14
	/// Used to limit the spam of the warcry_extra_sound
	COOLDOWN_DECLARE(warcry_cooldown_item)

/obj/item/flag/plantable/get_examine_text(mob/user)
	. = ..()
	if(play_warcry && user.faction == faction)
		. += SPAN_NOTICE("以<b>伤害意图</b>插下旗帜时，你会发出鼓舞士气的战吼！")

/// Proc for turning the flag item into a structure.
/obj/item/flag/plantable/proc/plant_flag(mob/living/user, play_warcry = FALSE, warcry_sound, warcry_extra_sound, faction)
	if(user.action_busy)
		return

	if(SSinterior.in_interior(user))
		to_chat(usr, SPAN_WARNING("这里没法插设[src]！"))
		return

	var/turf/turf_to_plant = get_step(user, user.dir)
	if(istype(turf_to_plant, /turf/open))
		var/turf/open/floor = turf_to_plant
		if(!floor.allow_construction || istype(floor, /turf/open/space))
			to_chat(user, SPAN_WARNING("这里无法插设[src]，找一处更稳固的地面吧！"))
			return
	else
		to_chat(user, SPAN_WARNING("[turf_to_plant]挡住了位置，无法插设[src]！"))
		return

	for(var/obj/object in turf_to_plant)
		if(object.density)
			to_chat(usr, SPAN_WARNING("你需要一片没有障碍物的空地才能插设[src]，前方有东西挡住了！"))
			return

	user.visible_message(SPAN_NOTICE("[user]开始将[src]插入地面……"), SPAN_NOTICE("你开始将[src]插入地面……"))
	playsound(user, 'sound/effects/flag_raising.ogg', 30)
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	user.visible_message(SPAN_NOTICE("[user]将[src]插在了地上！"), SPAN_NOTICE("你将[src]插在了地上！"))
	var/obj/structure/flag/plantable/planted_flag = new flag_type(turf_to_plant)

	// If there are more than 14 allies nearby, play a stronger rallying cry.
	// Otherwise, play the default warcry sound if there is one. If not, play a generic flag raising sfx.
	if(play_warcry && user.faction == faction && user.a_intent == INTENT_HARM)
		var/allies_nearby = 0
		if(COOLDOWN_FINISHED(src, warcry_cooldown_item))
			for(var/mob/living/carbon/human in orange(planted_flag, 7))
				if(human.is_dead() || human.faction != faction)
					continue
				allies_nearby++

		user.show_speech_bubble("warcry")
		if(allies_nearby >= allies_required)
			playsound(user, warcry_extra_sound, 40)
			// Start a cooldown on the flag structure. This way we can keep track of the cooldown when the flag is hoisted and taken down.
			COOLDOWN_START(planted_flag, warcry_cooldown_struc, 90 SECONDS)
			user.manual_emote("发出了振奋人心的集结战吼！")
		else
			playsound(user, warcry_sound, 30)
			user.manual_emote("发出了鼓舞士气的战吼！")
			// Ditto. If the cooldown isn't finished we have to transfer the leftover time to the structure.
			COOLDOWN_START(planted_flag, warcry_cooldown_struc, COOLDOWN_TIMELEFT(src, warcry_cooldown_item))
	else
		playsound(loc, 'sound/effects/flag_raised.ogg', 30)

	qdel(src)

/obj/item/flag/plantable/attack_self(mob/user)
	..()
	plant_flag(user, play_warcry, warcry_sound, warcry_extra_sound, faction)

// UNITED AMERICAS FLAG //
//////////////////////////

/obj/item/flag/plantable/ua
	name = "\improper 美洲联盟旗帜"
	desc = "美洲联盟的旗帜。已经可以插在地上了。"
	icon = 'icons/obj/structures/plantable_flag.dmi'
	icon_state = "flag_ua"
	flag_type = /obj/structure/flag/plantable/ua
	faction = FACTION_MARINE
	play_warcry = TRUE
	warcry_sound = 'sound/effects/flag_warcry_ua.ogg'
	warcry_extra_sound = 'sound/effects/flag_warcry_ua_extra.ogg'

/obj/structure/flag/plantable/ua
	name = "\improper 美洲联盟旗帜"
	desc = "美洲联盟的旗帜。"
	icon_state = "flag_ua_planted"
	flag_type = /obj/item/flag/plantable/ua

// UNITED STATES OF AMERICA FLAG //
//////////////////////////

/obj/item/flag/plantable/usa
	name = "\improper 美利坚合众国国旗"
	desc = "美利坚合众国的国旗。已经可以插在地上了。"
	icon = 'icons/obj/structures/plantable_flag.dmi'
	icon_state = "flag_usa"
	flag_type = /obj/structure/flag/plantable/usa
	faction = FACTION_MARINE

/obj/structure/flag/plantable/usa
	name = "\improper 美利坚合众国国旗"
	desc = "美利坚合众国的国旗。愿上帝保佑美利坚。"
	icon_state = "flag_usa_planted"
	flag_type = /obj/item/flag/plantable/usa


// UNION OF PROGRESSIVE PEOPLES FLAG //
//////////////////////////

/obj/item/flag/plantable/upp
	name = "\improper 进步人民联盟旗帜"
	desc = "进步人民联盟的旗帜。已经可以插在地上了。"
	icon = 'icons/obj/structures/plantable_flag.dmi'
	icon_state = "flag_upp"
	flag_type = /obj/structure/flag/plantable/upp
	faction = FACTION_UPP
	play_warcry = TRUE
	warcry_sound = 'sound/effects/flag_upp_warcry.ogg'
	warcry_extra_sound = 'sound/effects/flag_upp_warcry_extra.ogg'

/obj/structure/flag/plantable/upp
	name = "\improper 进步人民联盟旗帜"
	desc = "进步人民联盟的旗帜。以力量求团结，以团结求自由。"
	icon_state = "flag_upp_planted"
	flag_type = /obj/item/flag/plantable/upp

// BRAZIL FLAG //
//////////////////////////

/obj/item/flag/plantable/brazil
	name = "\improper 巴西国旗"
	desc = "巴西的国旗。已经可以插在地上了。"
	icon = 'icons/obj/structures/plantable_flag.dmi'
	icon_state = "flag_brazil"
	flag_type = /obj/structure/flag/plantable/brazil
	faction = FACTION_COLONIST

/obj/structure/flag/plantable/brazil
	name = "\improper 巴西国旗"
	desc = "巴西的国旗。"
	icon_state = "flag_brazil_planted"
	flag_type = /obj/item/flag/plantable/brazil
