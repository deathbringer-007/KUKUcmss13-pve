/obj/structure/barricade/handrail
	name = "扶手"
	desc = "给你的手扶的栏杆。哇哦。"
	icon = 'icons/obj/structures/handrail.dmi'
	icon_state = "handrail_a_0"
	barricade_type = "handrail"
	health = 30
	maxhealth = 30
	climb_delay = CLIMB_DELAY_SHORT
	stack_type = /obj/item/stack/sheet/metal
	debris = list(/obj/item/stack/sheet/metal)
	stack_amount = 2
	destroyed_stack_amount = 1
	crusher_resistant = FALSE
	can_wire = FALSE
	barricade_hitsound = 'sound/effects/metalhit.ogg'
	projectile_coverage = PROJECTILE_COVERAGE_MINIMAL
	var/build_state = BARRICADE_BSTATE_SECURED
	var/reinforced = FALSE //Reinforced to be a cade or not
	var/can_be_reinforced = TRUE //can we even reinforce this handrail or not?

/obj/structure/barricade/handrail/update_icon()
	overlays.Cut()
	switch(dir)
		if(SOUTH)
			layer = ABOVE_MOB_LAYER
		if(NORTH)
			layer = initial(layer) - 0.01
		else
			layer = initial(layer)
	if(!anchored)
		layer = initial(layer)
	if(build_state == BARRICADE_BSTATE_FORTIFIED)
		if(reinforced)
			overlays += image('icons/obj/structures/handrail.dmi', icon_state = "[barricade_type]_reinforced_[damage_state]")
		else
			overlays += image('icons/obj/structures/handrail.dmi', icon_state = "[barricade_type]_welder_step")

	for(var/datum/effects/E in effects_list)
		if(E.icon_path && E.obj_icon_state_path)
			overlays += image(E.icon_path, icon_state = E.obj_icon_state_path)

/obj/structure/barricade/handrail/get_examine_text(mob/user)
	. = ..()
	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			. += SPAN_INFO("扶手已牢牢固定在地面上。")
		if(BARRICADE_BSTATE_UNSECURED)
			. += SPAN_INFO("将它固定在地面的螺栓已被松开。")
		if(BARRICADE_BSTATE_FORTIFIED)
			if(reinforced)
				. += SPAN_INFO("扶手已用金属加固。")
			else
				. += SPAN_INFO("扶手上已放好金属板，焊接即可固定。")

/obj/structure/barricade/handrail/proc/reinforce()
	if(reinforced)
		if(health == maxhealth) // Drop metal if full hp when unreinforcing
			new /obj/item/stack/sheet/metal(loc)
		health = initial(health)
		maxhealth = initial(maxhealth)
		projectile_coverage = initial(projectile_coverage)
	else
		health = 350
		maxhealth = 350
		projectile_coverage = PROJECTILE_COVERAGE_HIGH
	reinforced = !reinforced
	update_icon()

/obj/structure/barricade/handrail/attackby(obj/item/item, mob/user)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "它正在熔化，你无法靠近！")
			return

	switch(build_state)
		if(BARRICADE_BSTATE_SECURED) //Non-reinforced. Wrench to unsecure. Screwdriver to disassemble into metal. 1 metal to reinforce.
			if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH)) // Make unsecure
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没受过松开[src]固定件的训练……"))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user]松开了[src]的地脚螺栓。"),
				SPAN_NOTICE("你松开了[src]的地脚螺栓。"))
				anchored = FALSE
				build_state = BARRICADE_BSTATE_UNSECURED
				update_icon()
				return
			if(istype(item, /obj/item/stack/sheet/metal)) // Start reinforcing
				if(!can_be_reinforced)
					return
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没受过加固[src]的训练……"))
					return
				var/obj/item/stack/sheet/metal/M = item
				playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, 1)
				if(M.amount >= 1 && do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD)) //Shouldnt be possible, but doesnt hurt to check
					if(!M.use(1))
						return
					build_state = BARRICADE_BSTATE_FORTIFIED
					update_icon()
				else
					to_chat(user, SPAN_WARNING("你需要至少一块金属板才能这样做。"))
				return

		if(BARRICADE_BSTATE_UNSECURED)
			if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH)) // Secure again
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没受过固定[src]的训练……"))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user]拧紧了[src]的地脚螺栓。"),
				SPAN_NOTICE("你拧紧了[src]的地脚螺栓。"))
				anchored = TRUE
				build_state = BARRICADE_BSTATE_SECURED
				update_icon()
				return
			if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER)) // Disassemble into metal
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没受过拆解[src]的训练……"))
					return
				user.visible_message(SPAN_NOTICE("[user]开始拧下[src]面板上的螺丝。"),
				SPAN_NOTICE("你卸下[src]的面板，开始拆解。"))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
				user.visible_message(SPAN_NOTICE("[user]拆解了[src]。"),
				SPAN_NOTICE("你拆解了[src]。"))
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				deconstruct(TRUE)
				return

		if(BARRICADE_BSTATE_FORTIFIED)
			if(reinforced)
				if(HAS_TRAIT(item, TRAIT_TOOL_CROWBAR)) // Un-reinforce
					if(user.action_busy)
						return
					if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
						to_chat(user, SPAN_WARNING("你没受过移除[src]加固结构的训练……"))
						return
					playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
					if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
					user.visible_message(SPAN_NOTICE("[user]撬下了[src]额外的金属面板。"),
					SPAN_NOTICE("你撬下了[src]额外的金属面板。"))
					build_state = BARRICADE_BSTATE_SECURED
					reinforce()
					return
			else
				if(iswelder(item)) // Finish reinforcing
					if(!HAS_TRAIT(item, TRAIT_TOOL_BLOWTORCH))
						to_chat(user, SPAN_WARNING("你需要功率更大的焊枪！"))
						return
					if(user.action_busy)
						return
					if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
						to_chat(user, SPAN_WARNING("你没受过加固[src]的训练……"))
						return
					playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
					if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src)) return
					user.visible_message(SPAN_NOTICE("[user]固定好了[src]的金属面板。"),
					SPAN_NOTICE("你固定好了[src]的金属面板。"))
					reinforce()
					return
	. = ..()

/obj/structure/barricade/handrail/type_b
	icon_state = "handrail_b_0"

/obj/structure/barricade/handrail/strata
	icon_state = "handrail_strata"

/obj/structure/barricade/handrail/medical
	icon_state = "handrail_med"

/obj/structure/barricade/handrail/kutjevo
	icon_state = "hr_kutjevo"

/obj/structure/barricade/handrail/wire
	icon_state = "wire_rail"
	climb_delay = CLIMB_DELAY_SHORT

/obj/structure/barricade/handrail/sandstone
	name = "砂岩扶手"
	icon_state = "hr_sandstone"
	can_be_reinforced = FALSE
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	stack_type = /obj/item/stack/sheet/mineral/sandstone
	debris = list(/obj/item/stack/sheet/mineral/sandstone)

/obj/structure/barricade/handrail/sandstone/b
	icon_state = "hr_sandstone_b"

/obj/structure/barricade/handrail/pizza
	name = "\improper 餐馆半高隔墙"
	icon_state = "hr_sandstone" //temp, getting sprites soontm
	color = "#b51c0b"
	can_be_reinforced = FALSE
	projectile_coverage = PROJECTILE_COVERAGE_LOW
	layer = MOB_LAYER + 0.01
