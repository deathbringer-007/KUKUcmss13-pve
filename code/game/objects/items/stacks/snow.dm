GLOBAL_LIST_INIT(snow_recipes, list(
	new /datum/stack_recipe("雪墙路障", /obj/structure/barricade/snow, 3, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = TRUE, flags = RESULT_REQUIRES_SNOW),
	new /datum/stack_recipe("雪球", /obj/item/snowball, 1)
	))


/obj/item/stack/snow
	name = "雪堆"
	desc = "一堆积雪。"
	singular_name = "积雪层"
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "snow_stack"
	w_class = SIZE_HUGE
	force = 2
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 1
	max_amount = 25
	stack_id = "snow pile"

/obj/item/stack/snow/Initialize(mapload, amount)
	recipes = GLOB.snow_recipes
	return ..()

/obj/item/stack/snow/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tool/shovel))
		var/obj/item/tool/shovel/ET = W
		if(isturf(loc))
			if(ET.dirt_amt)
				if(ET.dirt_type == DIRT_TYPE_SNOW)
					if(amount < max_amount + ET.dirt_amt)
						amount += ET.dirt_amt
					else
						new /obj/item/stack/snow(loc, ET.dirt_amt)
					ET.dirt_amt = 0
					ET.update_icon()
			else
				to_chat(user, SPAN_NOTICE("你开始从[src]中铲雪。"))
				playsound(user.loc, 'sound/effects/thud.ogg', 40, 1, 6)
				if(!do_after(user, ET.shovelspeed * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					to_chat(user, SPAN_NOTICE("你停止了从[src]中铲雪。"))
					return
				var/transf_amt = ET.dirt_amt_per_dig
				if(amount < ET.dirt_amt_per_dig)
					transf_amt = amount
				ET.dirt_amt = transf_amt
				ET.dirt_type = DIRT_TYPE_SNOW
				to_chat(user, SPAN_NOTICE("你从[src]中铲起了一些雪。"))
				ET.update_icon()
				use(transf_amt)
				return TRUE
	else
		. = ..()




/obj/item/stack/snow/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /turf/open))
		if(user.action_busy)
			return
		var/turf/open/T = target
		if(istype(T,/turf/open/snow) || istype(T,/turf/open/auto_turf/snow))
			if(T.bleed_layer >= 3)
				to_chat(user, "这片地面已经堆满了雪。")
				return
			to_chat(user, "你开始将积雪铺回地面。")
			if(!do_after(user, 15, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				to_chat(user, "你停止了向地面铺雪。")
				return
			if(T.bleed_layer >= 3)
				return
			to_chat(user, "你在地面上铺了一层新雪。")
			if(istype(T,/turf/open/auto_turf/snow))
				var/turf/open/auto_turf/snow/AT = T
				AT.changing_layer(AT.bleed_layer += 1)
			else
				T.bleed_layer++
				T.update_icon(TRUE, FALSE)
			use(1)

/obj/item/snowball
	name = "雪球"
	desc = "一件大规模杀伤性武器。这件精心制作的杰作足以重创敌军，前提是没有鲸头鹳挡住你的投射路线……"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "snowball"
	item_state = "lgloves"
	flags_atom = ITEM_UNCATCHABLE
	force = 0
	w_class = SIZE_SMALL
	throwforce = 0
	throw_speed = SPEED_AVERAGE
	throw_range = 7
	attack_verb = list("砸击", "拍击", "猛击")
	flags_equip_slot = SLOT_STORE // tactical snowball

/obj/item/snowball/attack(mob/living/M, mob/living/user)
	. = ..()
	M.apply_effect(2, SLOW)
	M.apply_effect(2, DAZE)
	qdel(src)

/obj/item/snowball/launch_impact(atom/hit_atom)
	. = ..()
	qdel(src)

/obj/item/snowball/mob_launch_collision(mob/living/L)
	. = ..()
	L.apply_effect(2, SLOW)
	L.apply_effect(2, DAZE)
