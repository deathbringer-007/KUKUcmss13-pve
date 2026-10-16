/datum/xeno_strain/gardener
	name = DRONE_GARDENER
	localized_name = "园丁"
	description = "你失去自由选择树脂建筑、腐蚀酸液和输送等离子体的能力，换取在菌毯上略快的生命恢复，以及多种新技能：种植更坚韧的菌毯、消耗等离子体暂时加固建筑，以及为姐妹种植最多六枚强效树脂果实。每塑造一枚果实都要分泌生命体液，消耗少量生命值。树脂涌动可以加速果实生长。"
	flavor_description = "园艺的荣耀：双手扎根菌毯，头颅隐于黑暗，心与树脂相连。"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/activable/transfer_plasma,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/plant_weeds/gardener, // second macro
		/datum/action/xeno_action/activable/resin_surge, // third macro
		/datum/action/xeno_action/onclick/plant_resin_fruit/greater, // fourth macro
		/datum/action/xeno_action/onclick/change_fruit,
		/datum/action/xeno_action/activable/transfer_plasma,
	)

	behavior_delegate_type = /datum/behavior_delegate/drone_gardener

/datum/xeno_strain/gardener/apply_strain(mob/living/carbon/xenomorph/drone/drone)
	drone.available_fruits = list(
		/obj/effect/alien/resin/fruit/greater,
		/obj/effect/alien/resin/fruit/unstable,
		/obj/effect/alien/resin/fruit/spore,
		/obj/effect/alien/resin/fruit/speed,
		/obj/effect/alien/resin/fruit/plasma
	)
	drone.selected_fruit = /obj/effect/alien/resin/fruit/greater
	drone.max_placeable = 6
	drone.regeneration_multiplier = XENO_REGEN_MULTIPLIER_TIER_1

	// Also change the primacy value for our place construction ability (because we want it in the same place but have another primacy ability)
	for(var/datum/action/xeno_action/action in drone.actions)
		if(istype(action, /datum/action/xeno_action/activable/place_construction))
			action.ability_primacy = XENO_NOT_PRIMARY_ACTION
			break // Don't need to keep looking

/datum/action/xeno_action/onclick/plant_resin_fruit
	name = "Plant Resin Fruit (50)"
	localized_names = list("Plant Resin Fruit (50)" = "种植树脂果实（50）")
	action_icon_state = "gardener_plant"
	ability_name = "plant resin fruit"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/plant_resin_fruit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 5 SECONDS
	var/health_cost = 50

/datum/action/xeno_action/onclick/plant_resin_fruit/greater
	name = "Plant Resin Fruit (100)"
	localized_names = list("Plant Resin Fruit (100)" = "种植树脂果实（100）")
	plasma_cost = 100
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/verb/plant_resin_fruit()
	set category = "Alien"
	set name = "Plant Resin Fruit"
	set hidden = TRUE
	var/action_name = "Plant Resin Fruit"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/plant_resin_fruit/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return
	var/turf/target_turf = xeno.loc

	if(!istype(target_turf))
		to_chat(xeno, SPAN_WARNING("没有菌毯花园，我们就无法种植果实。"))
		return

	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf
	if(!target_weeds)
		to_chat(xeno, SPAN_WARNING("这里没有可供种植果实的菌毯！"))
		return

	if(target_weeds.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_WARNING("这些菌毯不属于我们的虫巢，它们排斥我们的果实。"))
		return

	if(locate(/obj/effect/alien/resin/trap) in range(1, target_turf))
		to_chat(xeno, SPAN_XENOWARNING("这里离树脂陷坑太近了！"))
		return

	if(locate(/obj/effect/alien/resin/fruit) in target_turf)
		to_chat(xeno, SPAN_XENOWARNING("这里离另一枚果实太近了！"))
		return

	if (check_and_use_plasma_owner())
		if(length(xeno.current_fruits) >= xeno.max_placeable)
			to_chat(xeno, SPAN_XENOWARNING("我们无法维持更多果实，其中一枚会枯萎，为这枚果实让出生存空间！"))
			var/obj/effect/alien/resin/fruit/old_fruit = xeno.current_fruits[1]
			xeno.current_fruits.Remove(old_fruit)
			qdel(old_fruit)

		xeno.visible_message(SPAN_XENONOTICE("[xeno]分泌出体液，将其塑成了一枚果实！"), \
		SPAN_XENONOTICE("我们分泌一部分生命体液，将其塑成了一枚果实！"), null, 5)

		var/obj/effect/alien/resin/fruit/fruit = new xeno.selected_fruit(target_weeds.loc, target_weeds, xeno)
		if(!fruit)
			to_chat(xeno, SPAN_XENOHIGHDANGER("找不到要放置的果实！请联系开发者！"))
			return
		xeno.adjustBruteLoss(health_cost)
		xeno.updatehealth()
		playsound(xeno.loc, "alien_resin_build", 25)
		xeno.current_fruits.Add(fruit)

		var/number_of_fruit = length(xeno.current_fruits)
		button.set_maptext(SMALL_FONTS_COLOR(7, number_of_fruit, "#e69d00"), 19, 2)
		update_button_icon()
		xeno.update_icons()

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/change_fruit
	name = "Change Fruit"
	localized_names = list("Change Fruit" = "更换果实")
	action_icon_state = "blank"
	ability_name = "change fruit"
	plasma_cost = 0
	xeno_cooldown = 0
	macro_path = /datum/action/xeno_action/verb/verb_resin_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/onclick/change_fruit/give_to(mob/living/carbon/xenomorph/xeno)
	. = ..()

	button.overlays.Cut()
	button.overlays += image(icon_file, button, action_icon_state)
	button.overlays += image('icons/mob/xenos/fruits.dmi', button, initial(xeno.selected_fruit.mature_icon_state))

/datum/action/xeno_action/onclick/change_fruit/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	tgui_interact(xeno)
	return ..()

/datum/action/xeno_action/onclick/change_fruit/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/choose_fruit))

/datum/action/xeno_action/onclick/change_fruit/ui_static_data(mob/user)
	var/mob/living/carbon/xenomorph/xeno = user
	if(!istype(xeno))
		return

	. = list()

	var/list/fruits = list()
	for(var/obj/effect/alien/resin/fruit/fruit as anything in xeno.available_fruits)
		var/list/entry = list()

		entry["name"] = initial(fruit.name)
		entry["desc"] = initial(fruit.desc)
		entry["image"] = replacetext(initial(fruit.mature_icon_state), " ", "-")
		entry["id"] = "[fruit]"
		fruits += list(entry)

	.["fruits"] = fruits

/datum/action/xeno_action/onclick/change_fruit/ui_data(mob/user)
	var/mob/living/carbon/xenomorph/xeno = user
	if(!istype(xeno))
		return

	. = list()
	.["selected_fruit"] = xeno.selected_fruit


/datum/action/xeno_action/onclick/change_fruit/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChooseFruit", "选择果实")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/action/xeno_action/onclick/change_fruit/Destroy()
	SStgui.close_uis(src)
	return ..()

/datum/action/xeno_action/onclick/change_fruit/ui_state(mob/user)
	return GLOB.always_state

/datum/action/xeno_action/onclick/change_fruit/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/xenomorph/xeno = usr
	if(!istype(xeno))
		return

	switch(action)
		if("choose_fruit")
			var/selected_type = text2path(params["type"])
			if(!(selected_type in xeno.available_fruits))
				return

			var/obj/effect/alien/resin/fruit/fruit = selected_type
			to_chat(xeno, SPAN_NOTICE("现在分泌树脂时，我们将塑造<b>[initial(fruit.name)]</b>。"))
			//update the button's overlay with new choice
			xeno.update_icons()
			button.overlays.Cut()
			button.overlays += image(icon_file, button, action_icon_state)
			button.overlays += image('icons/mob/xenos/fruits.dmi', button, initial(fruit.mature_icon_state))
			xeno.selected_fruit = selected_type
			. = TRUE

		if("refresh_ui")
			. = TRUE
/*
	Resin Surge
*/

/datum/action/xeno_action/activable/resin_surge
	name = "Resin Surge (75)"
	localized_names = list("Resin Surge (75)" = "树脂涌动（75）")
	action_icon_state = "gardener_resin_surge"
	ability_name = "resin surge"
	plasma_cost = 75
	xeno_cooldown = 10 SECONDS
	macro_path = /datum/action/xeno_action/verb/verb_resin_surge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	var/channel_in_progress = FALSE
	var/max_range = 7

/datum/action/xeno_action/activable/resin_surge/use_ability(atom/target_atom, mods)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state(TRUE))
		return

	if(mods[CLICK_CATCHER])
		return

	if(ismob(target_atom)) // to prevent using thermal vision to bypass clickcatcher
		if(!can_see(xeno, target_atom, max_range))
			to_chat(xeno, SPAN_XENODANGER("我们看不到那个位置！"))
			return
	else
		if(get_dist(xeno, target_atom) > max_range)
			to_chat(xeno, SPAN_WARNING("那里太远了！"))
			return

	if (!check_and_use_plasma_owner())
		return

	var/turf/target_turf = get_turf(target_atom)

	var/obj/effect/alien/weeds/target_weeds = locate(/obj/effect/alien/weeds) in target_turf
	var/obj/effect/alien/resin/fruit/F = locate(/obj/effect/alien/resin/fruit) in target_turf
	var/obj/structure/mineral_door/resin/door = target_atom
	var/turf/closed/wall/resin/wall = target_turf

	var/wall_present = istype(wall) && wall.hivenumber == xeno.hivenumber
	var/door_present = istype(door) && door.hivenumber == xeno.hivenumber
	// Is my tile either a wall or a door
	if(door_present || wall_present)
		var/structure_to_buff = door || wall
		var/buff_already_present = FALSE
		if(door_present )
			for(var/datum/effects/xeno_structure_reinforcement/sf in door.effects_list)
				buff_already_present = TRUE
				break
		else if(wall_present)
			for(var/datum/effects/xeno_structure_reinforcement/sf in wall.effects_list)
				buff_already_present = TRUE
				break

		if(!buff_already_present)
			new /datum/effects/xeno_structure_reinforcement(structure_to_buff, xeno, ttl = 15 SECONDS)
			xeno.visible_message(SPAN_XENODANGER("[xeno]让[structure_to_buff]周围的树脂涌动，使其暂时变得几乎无法摧毁！"), \
			SPAN_XENONOTICE("我们让[structure_to_buff]周围的树脂涌动，使其暂时变得几乎无法摧毁！"), null, 5)
		else
			to_chat(xeno, SPAN_XENONOTICE("我们试图让[structure_to_buff]周围的树脂涌动，却发现它已经加固过了。我们需要片刻恢复。"))
			xeno_cooldown = xeno_cooldown * 0.5

	else if(F && F.hivenumber == xeno.hivenumber)
		if(F.mature)
			to_chat(xeno, SPAN_XENONOTICE("[F]已经成熟，[get_display_name()]不会产生效果。"))
			xeno_cooldown = xeno_cooldown * 0.5
		else
			to_chat(xeno, SPAN_XENONOTICE("我们让[F]周围的树脂涌动，加快了它的生长！"))
			F.reduce_timer(5 SECONDS)

	else if(target_weeds && istype(target_turf, /turf/open) && target_weeds.hivenumber == xeno.hivenumber)
		xeno.visible_message(SPAN_XENODANGER("[xeno]让树脂涌动，形成一堵不稳定的墙！"), \
		SPAN_XENONOTICE("我们让树脂涌动，形成一堵不稳定的墙！"), null, 5)
		target_turf.PlaceOnTop(/turf/closed/wall/resin/weak)
		var/turf/closed/wall/resin/weak_wall = target_turf
		weak_wall.hivenumber = xeno.hivenumber
		set_hive_data(weak_wall, xeno.hivenumber)

	else if(target_turf)
		if(channel_in_progress)
			return
		channel_in_progress = TRUE
		if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			channel_in_progress = FALSE
			return
		channel_in_progress = FALSE
		xeno.visible_message(SPAN_XENODANGER("[xeno]让深层树脂涌动，形成一片不稳定的黏性树脂！"), \
		SPAN_XENONOTICE("我们让深层树脂涌动，形成一片不稳定的黏性树脂！"), null, 5)
		for (var/turf/targetTurf in orange(1, target_turf))
			if(!locate(/obj/effect/alien/resin/sticky) in targetTurf)
				new /obj/effect/alien/resin/sticky/thin/weak(targetTurf, xeno.hivenumber)
		if(!locate(/obj/effect/alien/resin/sticky) in target_turf)
			new /obj/effect/alien/resin/sticky/thin/weak(target_turf, xeno.hivenumber)

	else
		xeno_cooldown = xeno_cooldown * 0.5

	apply_cooldown()

	xeno_cooldown = initial(xeno_cooldown)
	return ..()

/datum/action/xeno_action/verb/verb_resin_surge()
	set category = "Alien"
	set name = "Resin Surge"
	set hidden = TRUE
	var/action_name = "Resin Surge"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/plant_weeds/gardener
	name = "Plant Hardy Weeds (125)"
	localized_names = list("Plant Hardy Weeds (125)" = "种植坚韧菌毯（125）")
	ability_name = "Plant Hardy Weeds"
	action_icon_state = "plant_gardener_weeds"
	plasma_cost = 125
	macro_path = /datum/action/xeno_action/verb/verb_plant_gardening_weeds
	xeno_cooldown = 2 MINUTES
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	node_type = /obj/effect/alien/weeds/node/gardener

/obj/effect/alien/weeds/node/gardener
	spread_on_semiweedable = TRUE
	fruit_growth_multiplier = 0.8
	weed_strength = WEED_LEVEL_HARDY

/datum/action/xeno_action/verb/verb_plant_gardening_weeds()
	set category = "Alien"
	set name = "Plant Hardy Weeds"
	set hidden = TRUE
	var/action_name = "Plant Hardy Weeds (125)"
	handle_xeno_macro(src, action_name)

/datum/behavior_delegate/drone_gardener
	name = "Gardener Drone Behavior Delegate"

	var/mutable_appearance/fruit_sac_overlay_icon

/datum/behavior_delegate/drone_gardener/on_update_icons()
	if(!fruit_sac_overlay_icon)
		fruit_sac_overlay_icon = mutable_appearance('icons/mob/xenos/drone_strain_overlays.dmi', "Gardener Drone Walking")

	bound_xeno.overlays -= fruit_sac_overlay_icon
	fruit_sac_overlay_icon.overlays.Cut()

	if(bound_xeno.stat == DEAD)
		fruit_sac_overlay_icon.icon_state = "Gardener Drone Dead"
	else if(bound_xeno.body_position == LYING_DOWN)
		if(!HAS_TRAIT(bound_xeno, TRAIT_INCAPACITATED) && !HAS_TRAIT(bound_xeno, TRAIT_FLOORED))
			fruit_sac_overlay_icon.icon_state = "Gardener Drone Sleeping"
		else
			fruit_sac_overlay_icon.icon_state = "Gardener Drone Knocked Down"
	else
		fruit_sac_overlay_icon.icon_state = "Gardener Drone Walking"

	var/fruit_sac_color = initial(bound_xeno.selected_fruit.gardener_sac_color)

	fruit_sac_overlay_icon.color = fruit_sac_color
	bound_xeno.overlays += fruit_sac_overlay_icon
/*
Swapping to greater fruit changes the color to #17991B
Swapping to spore fruit changes the color to #994617
Swapping to unstable fruit changes the color to #179973
Swapping to speed fruit changes the color to #5B248C
Swapping to plasma fruit changes the color to #287A90
*/
