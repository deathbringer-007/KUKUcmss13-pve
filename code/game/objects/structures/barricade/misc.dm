/*----------------------*/
// SNOW
/*----------------------*/

/obj/structure/barricade/snow
	name = "积雪路障"
	desc = "堆成斜坡状矮墙的积雪。统计表明，总比躲在空气后面强。"
	icon_state = "snow_0"
	barricade_type = "snow"
	health = 75 //Actual health depends on snow layer
	maxhealth = 75
	stack_type = /obj/item/stack/snow
	debris = list(/obj/item/stack/snow)
	stack_amount = 3
	destroyed_stack_amount = 0
	can_wire = FALSE
	metallic = FALSE

/obj/structure/barricade/snow/New(loc, mob/user, direction)
	if(direction)
		setDir(direction)
	..(loc, user)



//Item Attack
/obj/structure/barricade/snow/attackby(obj/item/W, mob/user)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "它正在熔化，你无法靠近！")
			return
	//Removing the barricades
	if(istype(W, /obj/item/tool/shovel) && user.a_intent != INTENT_HARM)
		var/obj/item/tool/shovel/ET = W
		if(ET.folded)
			return
		if(user.action_busy)
			to_chat(user, SPAN_WARNING("你已经在铲了！"))
			return
		user.visible_message("[user.name]开始清除\the [src]。","你开始清除\the [src]。")
		if(!do_after(user, ET.shovelspeed * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			return
		if(!ET.folded)
			user.visible_message(SPAN_NOTICE("\The [user]清除了\the [src]。"))
			deconstruct(TRUE)
		return

	return ..()

/obj/structure/barricade/snow/hit_barricade(obj/item/I)
	switch(I.damtype)
		if("fire")
			take_damage( I.force * I.demolition_mod * 0.6 )
		if("brute")
			take_damage( I.force * I.demolition_mod * 0.3 )

	return


/*----------------------*/
// WOOD
/*----------------------*/

/obj/structure/barricade/wooden
	name = "木制路障"
	desc = "用木板钉成的一堵墙，不太坚固，但能提供些许遮蔽。"
	icon_state = "wooden"
	health = 100
	maxhealth = 100
	layer = OBJ_LAYER
	stack_type = /obj/item/stack/sheet/wood
	debris = list(/obj/item/stack/sheet/wood)
	stack_amount = 5
	destroyed_stack_amount = 3
	barricade_hitsound = 'sound/effects/woodhit.ogg'
	can_change_dmg_state = 0
	barricade_type = "wooden"
	can_wire = FALSE
	repair_materials = list("wood" = 1)
	metallic = FALSE

/obj/structure/barricade/wooden/attackby(obj/item/W as obj, mob/user as mob)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "它正在熔化，你无法靠近！")
			return
	if(istype(W, /obj/item/stack/sheet/wood))
		var/obj/item/stack/sheet/wood/D = W
		if(health < maxhealth)
			if(D.get_amount() < 1)
				to_chat(user, SPAN_WARNING("你需要一块木板才能修复[src]。"))
				return
			visible_message(SPAN_NOTICE("[user]开始修复[src]。"))
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src) && health < maxhealth)
				if (D.use(1))
					update_health(-0.5*maxhealth)
					update_damage_state()
					visible_message(SPAN_NOTICE("[user]笨拙地修好了[src]。"))
		return

	if(try_nailgun_usage(W, user))
		return

	return ..()

/obj/structure/barricade/wooden/hit_barricade(obj/item/I)
	switch(I.damtype)
		if("fire")
			take_damage( I.force * I.demolition_mod * 1.5 )
		if("brute")
			take_damage( I.force * I.demolition_mod * 0.75 )

// Prop flipped tables

/obj/structure/barricade/table
	name = "桌子路障"
	desc = "四条腿支撑着方形金属桌面，适合摆放物品，紧急时可以掀倒充当掩体。"
	icon = 'icons/obj/structures/barricades.dmi'
	icon_state = "metalflip"
	health = 100
	maxhealth = 100
	can_change_dmg_state = 0
	can_wire = FALSE
	stack_type = /obj/item/stack/sheet/metal
	stack_amount = 1 
	destroyed_stack_amount = 1
	debris = list(/obj/item/stack/sheet/metal)
	layer = OBJ_LAYER
	barricade_type = "metalflip"
	barricade_hitsound = 'sound/effects/metalhit.ogg'

/obj/structure/barricade/table/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && !(user.a_intent == INTENT_HELP))
		user.visible_message(SPAN_NOTICE("[user]开始拆除[src]。"),
		SPAN_NOTICE("你开始拆除[src]。"))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user]拆除了[src]。"),
			SPAN_NOTICE("你拆除了[src]。"))
			deconstruct(TRUE)
		return

/obj/structure/barricade/table/wood
	name = "木桌路障"
	desc = "四条腿支撑着方形木桌面，适合摆放物品，紧急时可以掀倒充当掩体。"
	icon_state = "woodflip"
	barricade_hitsound = 'sound/effects/woodhit.ogg'
	barricade_type = "woodflip"
	repair_materials = list("wood" = 1)
	stack_type = /obj/item/stack/sheet/wood
	debris = list(/obj/item/stack/sheet/wood)

/obj/structure/barricade/table/wood/poor
	name = "劣质木桌路障"
	desc = "做工有些粗糙的木桌面由四条腿支撑，适合摆放物品，紧急时可以掀倒充当掩体。"
	icon_state = "pwoodflip"
	barricade_type = "pwoodflip"

/obj/structure/barricade/table/wood/gambling
	name = "赌桌路障"
	desc = "四条腿支撑着铺有毯面的弧形木桌，用于赌博游戏，紧急时可以掀倒充当掩体。"
	icon_state = "gambleflip"
	barricade_type = "gambleflip"

/obj/structure/barricade/table/reinforced
	name = "加固桌子路障"
	desc = "四条腿支撑着方形金属桌面，带有侧板，适合办公，却无法掀倒。"
	icon_state = "reinfflip"
	barricade_type = "reinfflip"

/obj/structure/barricade/table/almayer
	desc = "厚重的金属底座支撑着方形金属桌面。没有腿的桌子可没法掀倒。"
	icon_state = "almflip"
	barricade_type = "almflip"

/obj/structure/barricade/table/prison
	desc = "四条腿支撑着方形金属桌面，带有侧板，适合办公，却无法掀倒。"
	icon_state = "prisonflip"
	barricade_type = "prisonflip"
