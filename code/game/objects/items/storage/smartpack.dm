#define BACKPACK_LIGHT_LEVEL 6
#define PROTECTIVE_COST 150
#define REPAIR_COST 100
#define IMMOBILE_COST 20

#define EXOSKELETON_ON_FILTER_SIZE 0.5
#define EXOSKELETON_OFF_FILTER_SIZE 1

#define PROTECTIVE_FORM_COLOR "#369E2B"
#define IMMOBILE_FORM_COLOR "#2B719E"

/obj/item/storage/backpack/marine/smartpack
	name = "\improper S-V42原型智能背包"
	desc = "美国殖民地海军陆战队与维兰德-汤谷的联合项目，据说采用了顶尖工程技术。它配发给部署中的陆战队合成人，用于提供战场支援。握住区域电力控制器，以手指接通电路即可充电（不建议非合成人员尝试）。警告：建议使用者采取防护措施。"
	item_state = "smartpack"
	icon_state = "smartpack"
	has_gamemode_skin = FALSE
	max_storage_space = 14
	worn_accessible = TRUE
	actions_types = list(/datum/action/item_action/toggle)
	xeno_types = null

	var/show_exoskeleton = TRUE

	var/battery_charge = SMARTPACK_MAX_POWER_STORED //How much power are we storing
	var/activated_form = FALSE
	var/immobile_form = FALSE
	var/repair_form = FALSE
	var/repairing = FALSE
	var/changed_icon = FALSE

	var/protective_form_cooldown = 120
	var/immobile_form_cooldown = 10
	var/repair_form_cooldown = 180

	var/saved_melee_allowed = TRUE
	var/saved_throw_allowed = TRUE
	var/saved_gun_allowed = TRUE

/obj/item/storage/backpack/marine/smartpack/verb/toggle_exoskeleton()
	set name = "切换外骨骼"
	set category = "Object"
	set src in usr

	if(!issynth(usr))
		to_chat(usr, SPAN_WARNING("你完全不知道该怎么做！"))
		return

	show_exoskeleton = !show_exoskeleton
	to_chat(usr, SPAN_NOTICE("[src][show_exoskeleton ? "现在会显示" : "将不再显示"]外骨骼。"))
	playsound(src, 'sound/machines/click.ogg', 15, TRUE)
	update_icon(usr)

/obj/item/storage/backpack/marine/smartpack/clicked(mob/user, list/mods)
	if(mods[CTRL_CLICK] && CAN_PICKUP(user, src))
		toggle_exoskeleton()
		return TRUE
	return ..()

/obj/item/storage/backpack/marine/smartpack/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/backpack/marine/smartpack/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("当前电量为[battery_charge]/[SMARTPACK_MAX_POWER_STORED]。")

/obj/item/storage/backpack/marine/smartpack/update_icon(mob/user)
	overlays.Cut()

	if(show_exoskeleton)
		if(immobile_form)
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state) + "_i")
		else if(activated_form)
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state) + "_p")
		else if(repair_form)
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state) + "_e")
		else
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state))
	else
		LAZYSET(item_state_slots, WEAR_BACK, initial(item_state))

	if(light_on)
		overlays += "+lamp_on"
	else
		overlays += "+lamp_off"

	if(user)
		user.update_inv_back()

	for(var/datum/action/A in actions)
		A.update_button_icon()

	if(issynth(user))
		var/mob/living/M = user
		for(var/datum/action/A in M.actions)
			A.update_button_icon()

	if(content_watchers) //If someone's looking inside it, don't close the flap.
		return

	var/sum_storage_cost = 0
	for(var/obj/item/I in contents)
		sum_storage_cost += I.get_storage_cost()
	if(!sum_storage_cost)
		return
	else if(sum_storage_cost <= max_storage_space * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"

/obj/item/storage/backpack/marine/smartpack/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()

	var/light = "+lamp_on"
	if(!light_on)
		light = "+lamp_off"

	var/image/lamp = overlay_image('icons/mob/humans/onmob/back.dmi', light, color, RESET_COLOR)
	ret.overlays += lamp

	return ret

/obj/item/storage/backpack/marine/smartpack/pickup(mob/living/M)
	if(issynth(M))
		for(var/action_type in subtypesof(/datum/action/human_action/smartpack))
			if(locate(action_type) in M.actions)
				continue

			give_action(M, action_type)
	else
		to_chat(M, SPAN_DANGER("[name]发出哔声：\"未授权的使用者！\""))

	..()

/obj/item/storage/backpack/marine/smartpack/dropped(mob/living/M)
	for(var/datum/action/human_action/smartpack/S in M.actions)
		S.remove_from(M)

	if(light_on && loc != M)
		turn_light(M, toggle_on = FALSE)

	if(immobile_form)
		immobile_form = FALSE
		M.status_flags |= CANPUSH
		M.anchored = FALSE
		REMOVE_TRAIT(M, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
	..()

/obj/item/storage/backpack/marine/smartpack/attack_self(mob/user)
	..()

	if(!isturf(user.loc) || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.back != src)
		return

	turn_light(user, toggle_on = !light_on)
	return TRUE

/obj/item/storage/backpack/marine/smartpack/turn_light(mob/user, toggle_on, cooldown, sparks, forced, light_again)
	. = ..()
	if(. != CHECKS_PASSED)
		return

	if(toggle_on)
		set_light_range(BACKPACK_LIGHT_LEVEL)
		set_light_on(TRUE)
	else
		set_light_on(FALSE)
		playsound(src, 'sound/handling/click_2.ogg', 50, TRUE)

	playsound(src, 'sound/handling/light_on_1.ogg', 50, TRUE)
	update_icon(user)

/obj/item/storage/backpack/marine/smartpack/proc/protective_form(mob/living/carbon/human/user)
	if(!istype(user) || activated_form || immobile_form)
		return

	if(battery_charge < PROTECTIVE_COST)
		to_chat(user, SPAN_DANGER("电量不足，无法执行该操作。电量：[battery_charge]/[PROTECTIVE_COST]"))
		return

	activated_form = TRUE
	flags_item |= NODROP
	flags_inventory |= CANTSTRIP
	LAZYSET(user.brute_mod_override, src, 0.2)
	LAZYSET(user.burn_mod_override, src, 0.2)
	saved_melee_allowed = user.melee_allowed
	saved_gun_allowed = user.allow_gun_usage
	saved_throw_allowed = user.throw_allowed
	user.melee_allowed = FALSE
	user.allow_gun_usage = FALSE
	user.throw_allowed = FALSE
	to_chat(user, SPAN_DANGER("[name]发出哔声：\"你现在受到保护，但无法攻击。\""))
	battery_charge -= PROTECTIVE_COST
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	to_chat(user, SPAN_INFO("当前电量为[battery_charge]/[SMARTPACK_MAX_POWER_STORED]。"))
	update_icon(user)

	var/filter_color = PROTECTIVE_FORM_COLOR
	var/filter_size = EXOSKELETON_OFF_FILTER_SIZE
	if(show_exoskeleton)
		filter_size = EXOSKELETON_ON_FILTER_SIZE
	user.add_filter("synth_protective_form", priority = 1, params = list("type" = "outline", "color" = filter_color, "size" = filter_size))

	addtimer(CALLBACK(src, PROC_REF(protective_form_cooldown), user), protective_form_cooldown)

/obj/item/storage/backpack/marine/smartpack/proc/protective_form_cooldown(mob/living/carbon/human/user)
	activated_form = FALSE
	flags_item &= ~NODROP
	flags_inventory &= ~CANTSTRIP
	user.melee_allowed = saved_melee_allowed
	user.throw_allowed = saved_throw_allowed
	user.allow_gun_usage = saved_gun_allowed
	LAZYREMOVE(user.brute_mod_override, src)
	LAZYREMOVE(user.burn_mod_override, src)
	to_chat(user, SPAN_DANGER("[name]发出哔声：\"保护效果已结束。\""))
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	update_icon(user)
	user.remove_filter("synth_protective_form")


/obj/item/storage/backpack/marine/smartpack/proc/immobile_form(mob/living/user)
	if(activated_form)
		return

	if(battery_charge < IMMOBILE_COST && !immobile_form)
		to_chat(user, SPAN_DANGER("电量不足，无法执行该操作。电量：[battery_charge]/[IMMOBILE_COST]"))
		return

	immobile_form = !immobile_form
	if(immobile_form)
		battery_charge -= IMMOBILE_COST
		user.status_flags &= ~CANPUSH
		user.anchored = TRUE
		ADD_TRAIT(user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
		to_chat(user, SPAN_DANGER("[name]发出哔声：\"你已被固定在原地，无法移动。\""))
		to_chat(user, SPAN_INFO("当前电量为[battery_charge]/[SMARTPACK_MAX_POWER_STORED]。"))

		var/filter_color = IMMOBILE_FORM_COLOR
		var/filter_size = EXOSKELETON_OFF_FILTER_SIZE
		if(show_exoskeleton)
			filter_size = EXOSKELETON_ON_FILTER_SIZE
		user.add_filter("synth_immobile_form", priority = 1, params = list("type" = "outline", "color" = filter_color, "size" = filter_size))
	else
		user.status_flags |= CANPUSH
		user.anchored = FALSE
		REMOVE_TRAIT(user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
		to_chat(user, SPAN_DANGER("[name]发出哔声：\"你现在又能移动了。\""))
		user.remove_filter("synth_immobile_form")

	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	update_icon(user)
	activated_form = TRUE

	addtimer(CALLBACK(src, PROC_REF(immobile_form_cooldown), user), immobile_form_cooldown)

/obj/item/storage/backpack/marine/smartpack/proc/immobile_form_cooldown(mob/user)
	activated_form = FALSE


/obj/item/storage/backpack/marine/smartpack/proc/repair_form(mob/user)
	if(!ishuman(user) || activated_form || repairing)
		return

	if(battery_charge < REPAIR_COST)
		to_chat(user, SPAN_DANGER("电量不足，无法执行该操作。电量：[battery_charge]/[REPAIR_COST]"))
		return

	var/mob/living/carbon/human/H = user

	if(H.getBruteLoss() <= 0 && H.getFireLoss() <= 0)
		to_chat(user, SPAN_DANGER("[name]发出哔声：\"未检测到明显损伤，操作已取消。\""))
		return

	repair_form = TRUE
	repairing = TRUE
	update_icon(user)

	H.visible_message(SPAN_WARNING("[name]发出哔声：\"正在启动修复程序。\""), \
		SPAN_WARNING("[name]发出哔声：\"开始仔细检查你受到的损伤。\""))
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	if(!do_after(H, 100, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		repair_form = FALSE
		repairing = FALSE
		update_icon(user)
		to_chat(user, SPAN_DANGER("[name]发出哔声：\"修复程序已取消。\""))
		return

	playsound(loc, 'sound/items/Welder2.ogg', 25, TRUE)
	battery_charge -= REPAIR_COST
	H.heal_overall_damage(50, 50, TRUE)
	H.pain.recalculate_pain()
	repair_form = FALSE
	update_icon(user)
	to_chat(user, SPAN_INFO("当前电量为[battery_charge]/[SMARTPACK_MAX_POWER_STORED]。"))
	H.visible_message(SPAN_DANGER("[name]发出哔声：\"修复程序已完成。当前电量为[battery_charge]/[SMARTPACK_MAX_POWER_STORED]。\""))

	addtimer(CALLBACK(src, PROC_REF(repair_form_cooldown), user), repair_form_cooldown)

/obj/item/storage/backpack/marine/smartpack/proc/repair_form_cooldown(mob/user)
	repairing = FALSE
	update_icon(user)


/obj/item/storage/backpack/marine/smartpack/green
	item_state = "g_smartpack"
	icon_state = "g_smartpack"

/obj/item/storage/backpack/marine/smartpack/tan
	item_state = "t_smartpack"
	icon_state = "t_smartpack"

/obj/item/storage/backpack/marine/smartpack/black
	item_state = "b_smartpack"
	icon_state = "b_smartpack"

/obj/item/storage/backpack/marine/smartpack/white
	item_state = "w_smartpack"
	icon_state = "w_smartpack"


#undef BACKPACK_LIGHT_LEVEL
#undef PROTECTIVE_COST
#undef REPAIR_COST
#undef IMMOBILE_COST

#undef EXOSKELETON_ON_FILTER_SIZE
#undef EXOSKELETON_OFF_FILTER_SIZE

#undef PROTECTIVE_FORM_COLOR
#undef IMMOBILE_FORM_COLOR
