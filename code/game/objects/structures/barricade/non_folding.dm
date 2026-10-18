/obj/structure/barricade/metal
	name = "金属路障"
	desc = "用金属板制成的坚固路障，组装方便，常用于快速构筑防御工事。可用焊炬修复。"
	icon_state = "metal_0"
	health = 450
	maxhealth = 450
	burn_multiplier = 1.15
	brute_multiplier = 1
	crusher_resistant = TRUE
	force_level_absorption = 10
	stack_type = /obj/item/stack/sheet/metal
	debris = list(/obj/item/stack/sheet/metal)
	stack_amount = 4
	destroyed_stack_amount = 2
	barricade_hitsound = 'sound/effects/metalhit.ogg'
	barricade_type = "metal"
	can_wire = TRUE
	repair_materials = list("metal" = 0.3, "plasteel" = 0.45)
	var/build_state = BARRICADE_BSTATE_SECURED //Look at __game.dm for barricade defines
	var/upgrade = null

	welder_lower_damage_limit = BARRICADE_DMG_HEAVY

/obj/structure/barricade/metal/update_icon()
	. = ..()
	if(dir > 2)
		layer = OBJ_LAYER //This prevents cades from becoming invisible under a north/south facing plasteel cade.

/obj/structure/barricade/metal/get_examine_text(mob/user)
	. = ..()
	switch(build_state)
		if(BARRICADE_BSTATE_SECURED)
			. += SPAN_INFO("防护面板仍被螺丝牢牢固定着。")
		if(BARRICADE_BSTATE_UNSECURED)
			. += SPAN_INFO("防护面板已拆下，可以看到锚固螺栓。")
		if(BARRICADE_BSTATE_MOVABLE)
			. += SPAN_INFO("防护面板已拆下，锚固螺栓已松开，可以拆解了。")

	switch(upgrade)
		if(BARRICADE_UPGRADE_BURN)
			. += SPAN_NOTICE("路障装有生化防护升级件。")
		if(BARRICADE_UPGRADE_BRUTE)
			. += SPAN_NOTICE("路障装有加固升级件。")
		if(BARRICADE_UPGRADE_ANTIFF)
			. += SPAN_NOTICE("路障装有复合装甲升级件。")

/obj/structure/barricade/metal/can_weld(obj/item/item, mob/user, silent)
	if(!..())
		return FALSE

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE))
		if(!silent)
			to_chat(user, SPAN_WARNING("你没有接受过修复[src]的训练……"))
		return FALSE

	return TRUE

/obj/structure/barricade/metal/attackby(obj/item/item, mob/user)
	if(iswelder(item))
		try_weld_cade(item, user)
		return

	if(try_nailgun_usage(item, user))
		return

	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "它正在熔化，你无法靠近！")
			return

	switch(build_state)
		if(BARRICADE_BSTATE_SECURED) //Fully constructed step. Use screwdriver to remove the protection panels to reveal the bolts
			if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没有接受过操作[src]的训练……"))
					return
				if(user.action_busy)
					return
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user]拆下了[src]的防护面板。"),
				SPAN_NOTICE("你拆下了[src]的防护面板，露出了锚固螺栓。"))
				build_state = BARRICADE_BSTATE_UNSECURED
				return

			if(istype(item, /obj/item/stack/sheet/metal))
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没有接受过操作[src]的训练……"))
					return
				if(upgraded)
					to_chat(user, SPAN_NOTICE("这个路障已经升级过了。"))
					return
				var/obj/item/stack/sheet/metal/metal = item
				if(user.client?.prefs?.no_radials_preference)
					var/choice = tgui_input_list(user, "选择要应用于路障的升级。", "应用升级", list(BARRICADE_UPGRADE_BURN, BARRICADE_UPGRADE_BRUTE, BARRICADE_UPGRADE_ANTIFF))
					if(!choice)
						return
					if(!user.Adjacent(src))
						to_chat(user, SPAN_NOTICE("你离得太远了！"))
						return
					if(upgraded)
						to_chat(user, SPAN_NOTICE("这个路障已经升级过了。"))
						return
					if(metal.get_amount() < 2)
						to_chat(user, SPAN_NOTICE("你没有足够的金属。"))
						return
					if((usr.get_active_hand()) != metal)
						to_chat(user, SPAN_WARNING("你必须拿着[metal]才能升级[src]！"))
						return

					switch(choice)
						if(BARRICADE_UPGRADE_BURN)
							burn_multiplier = 0.75
							burn_flame_multiplier = 0.75
							upgraded = BARRICADE_UPGRADE_BURN
							to_chat(user, SPAN_NOTICE("你安装了生化防护升级件。"))
						if(BARRICADE_UPGRADE_BRUTE)
							brute_multiplier = 0.75
							brute_projectile_multiplier = 0.375
							upgraded = BARRICADE_UPGRADE_BRUTE
							to_chat(user, SPAN_NOTICE("你安装了加固升级件。"))
						if(BARRICADE_UPGRADE_ANTIFF)
							explosive_multiplier = 0.5
							brute_projectile_multiplier = 0.25
							burn_flame_multiplier = 0.5
							upgraded = BARRICADE_UPGRADE_ANTIFF
							to_chat(user, SPAN_NOTICE("你安装了复合装甲升级件。"))

					metal.use(2)
					user.count_niche_stat(STATISTICS_NICHE_UPGRADE_CADES)
					update_icon()
					return
				else
					var/static/list/cade_types = list(BARRICADE_UPGRADE_ANTIFF = image(icon = 'icons/obj/structures/barricades.dmi', icon_state = "explosive_obj"), BARRICADE_UPGRADE_BRUTE = image(icon = 'icons/obj/structures/barricades.dmi', icon_state = "brute_obj"), BARRICADE_UPGRADE_BURN = image(icon = 'icons/obj/structures/barricades.dmi', icon_state = "burn_obj"))
					var/choice = show_radial_menu(user, src, cade_types, require_near = TRUE)
					if(!choice)
						return
					if(!user.Adjacent(src))
						to_chat(user, SPAN_NOTICE("你离得太远了！"))
						return
					if(upgraded)
						to_chat(user, SPAN_NOTICE("这个路障已经升级过了。"))
						return
					if(metal.get_amount() < 2)
						to_chat(user, SPAN_NOTICE("你没有足够的金属。"))
						return
					if((usr.get_active_hand()) != metal)
						to_chat(user, SPAN_WARNING("你必须拿着[metal]才能升级[src]！"))
						return

					switch(choice)
						if(BARRICADE_UPGRADE_BURN)
							burn_multiplier = 0.75
							burn_flame_multiplier = 0.75
							upgraded = BARRICADE_UPGRADE_BURN
							to_chat(user, SPAN_NOTICE("你安装了生化防护升级件。"))
						if(BARRICADE_UPGRADE_BRUTE)
							brute_multiplier = 0.75
							brute_projectile_multiplier = 0.375
							upgraded = BARRICADE_UPGRADE_BRUTE
							to_chat(user, SPAN_NOTICE("你安装了加固升级件。"))
						if(BARRICADE_UPGRADE_ANTIFF)
							explosive_multiplier = 0.5
							brute_projectile_multiplier = 0.25
							burn_flame_multiplier = 0.5
							upgraded = BARRICADE_UPGRADE_ANTIFF
							to_chat(user, SPAN_NOTICE("你安装了复合装甲升级件。"))

					metal.use(2)
					user.count_niche_stat(STATISTICS_NICHE_UPGRADE_CADES)
					update_icon()
					return

			if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没有接受过操作[src]的训练……"))
					return
				if(user.action_busy || !upgraded)
					return
				if(!do_after(user, 5, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user]拆除了[src]的升级件。"),
					SPAN_NOTICE("你拆除了[src]的升级件，使其恢复为普通路障。"))
				upgraded = null
				explosive_multiplier = initial(explosive_multiplier)
				brute_multiplier = initial(brute_multiplier)
				brute_projectile_multiplier = initial(brute_projectile_multiplier)
				burn_multiplier = initial(burn_multiplier)
				burn_flame_multiplier = initial(burn_flame_multiplier)
				new stack_type (loc, 1)
				update_icon()
				return

		if(BARRICADE_BSTATE_UNSECURED) //Protection panel removed step. Screwdriver to put the panel back, wrench to unsecure the anchor bolts
			if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没有接受过组装[src]的训练……"))
					return
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user]装回了[src]的防护面板。"),
				SPAN_NOTICE("你装回了[src]的防护面板。"))
				build_state = BARRICADE_BSTATE_SECURED
				return

			if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没有接受过拆解[src]的训练……"))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user]松开了[src]的锚固螺栓。"),
				SPAN_NOTICE("你松开了[src]的锚固螺栓。"))
				anchored = FALSE
				build_state = BARRICADE_BSTATE_MOVABLE
				update_icon() //unanchored changes layer
				return

		if(BARRICADE_BSTATE_MOVABLE) //Anchor bolts loosened step. Apply crowbar to unseat the panel and take apart the whole thing. Apply wrench to resecure anchor bolts
			if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没有接受过组装[src]的训练……"))
					return
				for(var/obj/structure/barricade/B in loc)
					if(B != src && B.dir == dir)
						to_chat(user, SPAN_WARNING("这里已经有路障了。"))
						return
				var/turf/open/turf = loc
				if(!(istype(turf) && turf.allow_construction))
					to_chat(user, SPAN_WARNING("[src]必须固定在合适的表面上！"))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					return
				user.visible_message(SPAN_NOTICE("[user]拧紧了[src]的锚固螺栓。"),
				SPAN_NOTICE("你拧紧了[src]的锚固螺栓。"))
				build_state = BARRICADE_BSTATE_UNSECURED
				anchored = TRUE
				update_icon() //unanchored changes layer
				return

			if(HAS_TRAIT(item, TRAIT_TOOL_CROWBAR))
				if(user.action_busy)
					return
				if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
					to_chat(user, SPAN_WARNING("你没有接受过拆解[src]的训练……"))
					return
				user.visible_message(SPAN_NOTICE("[user]开始拆卸[src]的板材。"),
				SPAN_NOTICE("你开始拆卸[src]的板材。"))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					user.visible_message(SPAN_NOTICE("[user]拆下了[src]的板材。"),
					SPAN_NOTICE("你拆下了[src]的板材。"))
					playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
					deconstruct(TRUE) //Note : Handles deconstruction too !
				return

	return ..()

/obj/structure/barricade/metal/wired/Initialize(mapload, mob/user)
	. = ..()
	maxhealth += 50
	update_health(-50)
	can_wire = FALSE
	is_wired = TRUE
	climbable = FALSE
	update_icon()

/obj/structure/barricade/metal/wired/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	flags_can_pass_front_temp &= ~PASS_OVER_THROW_MOB
	flags_can_pass_behind_temp &= ~PASS_OVER_THROW_MOB

/obj/structure/barricade/metal/plasteel
	name = "塑钢路障"
	desc = "用加固塑钢板制成的坚固路障，组装方便，堪称防御工事的顶级之选。可用焊炬修复。"
	icon_state = "new_plasteel_0"
	health = 900
	maxhealth = 900
	crusher_resistant = TRUE
	force_level_absorption = 20
	stack_type = /obj/item/stack/sheet/plasteel
	debris = list(/obj/item/stack/sheet/plasteel)
	destroyed_stack_amount = 3
	barricade_type = "new_plasteel"
	repair_materials = list("plasteel" = 0.45)

/obj/structure/barricade/metal/plasteel/wired/Initialize(mapload, mob/user)
	maxhealth += 50
	update_health(-50)
	can_wire = FALSE
	is_wired = TRUE
	climbable = FALSE
	update_icon()
	return ..()

/obj/structure/barricade/metal/plasteel/wired/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	flags_can_pass_front_temp &= ~PASS_OVER_THROW_MOB
	flags_can_pass_behind_temp &= ~PASS_OVER_THROW_MOB
