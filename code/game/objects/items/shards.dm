// Glass shards

/obj/item/shard
	name = "玻璃碎片"
	icon = 'icons/obj/items/shards.dmi'
	icon_state = ""
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 1
	desc = "一块碎玻璃。也许能用来……当投掷武器？"
	w_class = SIZE_TINY
	force = 5
	throwforce = 8
	item_state = "shard-glass"
	matter = list("glass" = 3750)
	attack_verb = list("刺击", "劈砍", "切割", "割伤")
	var/source_sheet_type = /obj/item/stack/sheet/glass
	var/shardsize
	var/count = 1
	garbage = TRUE

/obj/item/shard/attack(mob/living/carbon/M, mob/living/carbon/user)
	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 6)


/obj/item/shard/Initialize()
	. = ..()
	shardsize = pick("large", "medium", "small")
	switch(shardsize)
		if("small")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
			icon_state += shardsize
		if("medium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
			icon_state += shardsize
		if("large")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)
			icon_state += shardsize



/obj/item/shard/attackby(obj/item/W, mob/user)
	if ( iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要功率更大的焊炬！"))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(source_sheet_type) //can be melted into something
			if(WT.remove_fuel(0, user))
				var/obj/item/stack/sheet/NG = new source_sheet_type(user.loc)
				for (var/obj/item/stack/sheet/G in user.loc)
					if(G==NG)
						continue
					if(!istype(G, source_sheet_type))
						continue
					if(G.amount>=G.max_amount)
						continue
					G.attackby(NG, user)
					to_chat(user, "你把刚熔成的玻璃板放进了堆里，现在共有[NG.amount]块。")
				qdel(src)
				return
	return ..()

/obj/item/shard/phoron
	name = "弗燃玻璃碎片"
	desc = "一块弗燃玻璃碎片，比普通玻璃碎片坚固得多。显然拿来当窗户还是不够结实。"
	force = 8
	throwforce = 15
	icon_state = "phoron"
	source_sheet_type = /obj/item/stack/sheet/glass/phoronglass


// Shrapnel.
// on_embed is called from projectile.dm, bullet_act(obj/projectile/P).
// on_embedded_movement is called from human.dm, handle_embedded_objects().

/obj/item/large_shrapnel/proc/on_embedded_movement(mob/living/embedded_mob)
	return

/obj/item/large_shrapnel/proc/on_embed(mob/embedded_mob, obj/limb/target_organ, silent = FALSE)
	return

/obj/item/large_shrapnel/at_rocket_dud
	name = "未爆反坦克火箭弹"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "custom_rocket_no_fuel"
	desc = "一枚未引爆的反坦克火箭弹，大概是撞上了什么柔软的东西。千万别把它摔在地上……"
	/// same as custom warhead
	matter = list("metal" = 11250)
	w_class = SIZE_LARGE
	force = 20
	throw_range = 5
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	var/damage_on_move = 2
	var/vehicle_slowdown_time = 5 SECONDS
	var/throw_channel = 2 SECONDS
	var/detonating = 0
	var/thrown = 0
	var/cause = null
	/// % chance of it detonating when dropped. THIS ALSO TRIGGERS WHEN PUTTING IT IN A BAG.
	var/drop_sensitivity = 25
	/// % chance of it detonating when thrown and hitting an atom.
	var/impact_sensitivity = 75

/obj/item/large_shrapnel/at_rocket_dud/dropped(mob/user)
	. = ..()

	if(!detonating && !thrown && !cause && prob(drop_sensitivity))
		cause = "accidental"
		visible_message(SPAN_DANGER("[user]丢下[src]时，你听见里面的机关咔嗒一声被触发了。糟了。"))
		manual_detonate(get_turf(src), user)
	cause = null

/obj/item/large_shrapnel/at_rocket_dud/try_to_throw(mob/living/user)
	to_chat(user, SPAN_NOTICE("你用力举起[src]，准备把它扔出去。"))
	user.visible_message(SPAN_DANGER("[user]吃力地举起[src]，看来是想把它扔出去！"))
	throw_range = 5
	throw_channel = 2 SECONDS
	if(HAS_TRAIT(user, TRAIT_SUPER_STRONG))
		throw_range = 8
		throw_channel = 1 SECONDS
	if(!do_after(user, throw_channel, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_WARNING("你投掷[src]的动作被打断了！"))
		return FALSE
	cause = "manually triggered"
	thrown = 1
	return TRUE

/obj/item/large_shrapnel/at_rocket_dud/launch_impact(atom/hit_atom)
	. = ..()
	var/datum/launch_metadata/LM = src.launch_metadata
	var/user = LM.thrower
	if(!detonating && prob(impact_sensitivity))
		cause = "manually triggered"
		visible_message(SPAN_DANGER("你听见[src]里面的机关咔嗒一声被触发了。糟了。"))
		vehicle_impact(hit_atom, user)
		manual_detonate(hit_atom, user, 0)
		return
	cause = null
	thrown = 0

/obj/item/large_shrapnel/at_rocket_dud/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!detonating && (user.a_intent == INTENT_HARM) && proximity_flag && (istype(target, /obj/vehicle) || istype(target, /obj/structure) || istype(target, /turf)))
		cause = "manually triggered"
		vehicle_impact(target, user)
		manual_detonate(target, user)
		return
	cause = null

/obj/item/large_shrapnel/at_rocket_dud/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!detonating && (user.a_intent == INTENT_HARM) && istype(M, /mob/living/carbon))
		cause = "manually triggered"
		manual_detonate(M, user)
		return
	cause = null

/obj/item/large_shrapnel/at_rocket_dud/proc/vehicle_impact(atom/T, mob/U)
	if(istype(T, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/M = T
		M.next_move = world.time + vehicle_slowdown_time
		playsound(M, 'sound/effects/meteorimpact.ogg', 35)
		M.at_munition_interior_explosion_effect(cause_data = create_cause_data("Anti-Tank Rocket", U))
		M.interior_crash_effect()
		M.ex_act(1000, get_dir(U, T), create_cause_data("Anti-Tank Rocket", U))
		return TRUE
	return FALSE

/obj/item/large_shrapnel/at_rocket_dud/proc/manual_detonate(atom/target, mob/living/user, melee = 1, direction = null)
	detonating = 1
	if(user && (cause == "manually triggered"))
		user.visible_message(SPAN_DANGER("[user][melee?"把[src]猛砸向":"把[src]扔向"][target]！"))
	if((!direction) && target && user)
		direction = get_dir(user, target)
	cell_explosion(get_turf(target), 200, 150, EXPLOSION_FALLOFF_SHAPE_LINEAR, direction, create_cause_data("[cause] UXO detonation", user))
	qdel(src)

/obj/item/large_shrapnel/at_rocket_dud/on_embed(mob/embedded_mob, obj/limb/target_organ, silent = FALSE)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	if(istype(target_organ))
		target_organ.embed(src, silent)

/obj/item/large_shrapnel/at_rocket_dud/on_embedded_movement(mob/living/embedded_mob)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	var/obj/limb/organ = embedded_organ
	if(istype(organ))
		organ.take_damage(damage_on_move, 0, 0, no_limb_loss = TRUE)
		embedded_mob.pain.apply_pain(damage_on_move)
		if(prob(5))
			to_chat(embedded_mob, SPAN_DANGER("插在你身上的[src]剧烈晃动，顶着你的内脏！糟了。"))
			embedded_mob.visible_message(SPAN_DANGER("插在[embedded_mob]身上的[src]突然爆炸了！"))
			cell_explosion(get_turf(embedded_mob), 200, 150, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("accidental UXO detonation", embedded_mob))

/obj/item/shard/shrapnel
	name = "弹片"
	icon_state = "shrapnel"
	desc = "一堆细小的金属碎片。"
	matter = list("metal" = 50)
	source_sheet_type = null
	var/damage_on_move = 0.5

/obj/item/shard/shrapnel/proc/on_embed(mob/embedded_mob, obj/limb/target_organ, silent = FALSE)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	if(istype(target_organ))
		target_organ.embed(src, silent)

/obj/item/shard/shrapnel/proc/on_embedded_movement(mob/living/embedded_mob)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	var/obj/limb/organ = embedded_organ
	if(istype(organ) && damage_on_move)
		organ.take_damage(damage_on_move * count, 0, 0, no_limb_loss = TRUE)
		embedded_mob.pain.apply_pain(damage_on_move * count)

/obj/item/shard/shrapnel/upp
	name = "小弹片"
	desc = "曾经嵌在某人皮下的弹片。"
	icon_state = "small"
	damage_on_move = 2

/obj/item/shard/shrapnel/upp/bits
	name = "微小弹片"
	desc = "一块曾经嵌在某人皮下的微小弹片。"
	icon_state = "tiny"
	damage_on_move = 0.5

/obj/item/shard/shrapnel/bone_chips
	name = "骨质弹片"
	gender = PLURAL
	icon_state = "bonechips"
	matter = list("bone" = 50)
	desc = "看起来像是来自某种史前动物。"
	damage_on_move = 0.6

/obj/item/shard/shrapnel/bone_chips/human
	name = "人骨碎片"
	icon_state = "humanbonechips"
	desc = "天哪，碎骨散落得到处都是！"

/obj/item/shard/shrapnel/bone_chips/xeno
	name = "异形骨骼碎片"
	icon_state = "alienbonechips"
	desc = "尖锐、参差不齐的异形骨骼碎片。看来它原来的主人被炸得很惨……"

/obj/item/sharp
	name = "尖锐镖弹碎片"
	desc = "看起来是一枚用过的9X-E 黏附式爆炸镖，已经没用了。"
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "sonicharpoon"
	sharp = IS_SHARP_ITEM_BIG
	w_class = SIZE_SMALL
	edge = TRUE
	force = 0
	throwforce = 0
	var/damage_on_move = 3
	var/count = 1
	garbage = TRUE

/obj/item/sharp/Initialize(mapload, dir)
	. = ..()
	if(dir && dir <= 6)
		turn_object(90)
	else
		turn_object(270)

/obj/item/sharp/proc/on_embed(mob/embedded_mob, obj/limb/target_organ)
	return

/obj/item/sharp/proc/on_embedded_movement(mob/living/embedded_mob)
	if(!ishuman(embedded_mob))
		return
	var/mob/living/carbon/human/H = embedded_mob
	if(H.species.flags & NO_SHRAPNEL)
		return
	var/obj/limb/organ = embedded_organ
	if(istype(organ))
		organ.take_damage(damage_on_move * count, 0, 0, no_limb_loss = TRUE)

		embedded_mob.pain.apply_pain(damage_on_move * count)

/obj/item/sharp/proc/turn_object(amount)
	var/matrix/initial_matrix = matrix(transform)
	initial_matrix.Turn(amount)
	apply_transform(initial_matrix)

/obj/item/sharp/explosive
	name = "\improper 9X-E 黏附式爆炸镖"

/obj/item/sharp/track
	name = "\improper 9X-T 黏附式追踪镖"
	desc = "看起来是一枚用过的9X-T 黏附式追踪镖，已经没用了。"
	icon_state = "sonicharpoon_tracker"

/obj/item/sharp/flechette
	name = "\improper 9X-F 箭形镖"
	desc = "看起来是一枚用过的9X-F 箭形镖，已经没用了。"
	icon_state = "sonicharpoon_flechette"
/obj/item/shard/shrapnel/tutorial
	damage_on_move = 0

