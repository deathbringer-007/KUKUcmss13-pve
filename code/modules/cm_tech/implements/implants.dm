/obj/item/storage/box/implant
	name = "植入物盒"
	desc = "用于存放皮下注射式植入器的无菌金属锁盒。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "implantbox"
	use_sound = "toolbox"
	storage_slots = 5
	can_hold = list(/obj/item/device/implanter)
	w_class = SIZE_SMALL


/obj/item/storage/box/implant/picker
	desc = "内置皮下注射式植入器打印机的无菌金属锁盒。"
	foldable = FALSE
	storage_slots = 2
	var/picks_left = 2
	var/list/pickable = list(
		"夜视植入物" = /obj/item/device/implanter/nvg,
		"复苏植入物" = /obj/item/device/implanter/rejuv,
		"敏捷植入物" = /obj/item/device/implanter/agility,
		"皮下护甲" = /obj/item/device/implanter/subdermal_armor
	)

/obj/item/storage/box/implant/picker/open(mob/user)
	select_implants(user)
	return ..()

/obj/item/storage/box/implant/picker/attack_self(mob/user)
	select_implants(user)
	return ..()

/obj/item/storage/box/implant/picker/proc/select_implants(mob/user)
	while(picks_left)
		if(!length(pickable))
			picks_left = 0
			break
		var/list/options = list()
		for(var/name in pickable)
			options += name
		var/choice = tgui_input_list(usr, "选择你的植入物", "选择植入物", options)
		if(!choice || !(choice in pickable))
			return
		picks_left--
		var/path = pickable[choice]
		pickable -= choice
		new path(src)
		stoplag()

/obj/item/device/implanter
	name = "植入器"
	desc = "将植入物注入身体的注射器，注射时会有强烈的刺痛。"
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "implanter"

	w_class = SIZE_SMALL

	var/implant_type
	var/uses = 1
	var/implant_time = 3 SECONDS
	var/implant_string = "棒极了。"

/obj/item/device/implanter/update_icon()
	if(!uses)
		icon_state = "[initial(icon_state)]0"
		return

	icon_state = initial(icon_state)

/obj/item/device/implanter/attack(mob/living/M, mob/living/user)
	if(!uses || !implant_type)
		return ..()

	if(LAZYISIN(M.implants, implant_type))
		to_chat(user, SPAN_WARNING("[M]已经装有这种植入物！"))
		return

	if(LAZYLEN(M.implants) >= M.max_implants)
		to_chat(user, SPAN_WARNING("[M]无法再容纳更多植入物！"))
		return

	var/self_inject = TRUE
	if(M != user)
		self_inject = FALSE
		if(!do_after(user, implant_time, INTERRUPT_ALL, BUSY_ICON_GENERIC, M, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			return

	implant(M, self_inject)

/obj/item/device/implanter/attack_self(mob/user)
	..()
	implant(user, TRUE)

/obj/item/device/implanter/proc/implant(mob/M, self_inject)
	if(uses <= 0)
		return

	if(LAZYISIN(M.implants, implant_type))
		QDEL_NULL(M.implants[implant_type])

	if(self_inject)
		to_chat(M, SPAN_NOTICE("你使用[src]为自己植入了装置。你感觉[implant_string]"))
	else
		to_chat(M, SPAN_NOTICE("有人使用[src]为你植入了装置。你感觉[implant_string]"))

	playsound(src, 'sound/items/air_release.ogg', 75, TRUE)
	var/obj/item/device/internal_implant/I = new implant_type(M)
	LAZYSET(M.implants, implant_type, I)
	I.on_implanted(M)
	uses = max(uses - 1, 0)
	if(!uses)
		garbage = TRUE
	update_icon()

/obj/item/device/internal_implant
	name = "植入物"
	desc = "通常使用植入器植入体内的装置。"
	icon_state = "implant"

	var/mob/living/host

/obj/item/device/internal_implant/proc/on_implanted(mob/living/M)
	SHOULD_CALL_PARENT(TRUE)
	host = M

/obj/item/device/internal_implant/Destroy()
	host = null
	return ..()

/obj/item/device/implanter/nvg
	name = "夜视植入物"
	desc = "赋予你夜视能力的植入物，会在宿主死亡时受损。"
	implant_type = /obj/item/device/internal_implant/nvg
	implant_string = "瞳孔扩张到了令人不安的程度。"

/obj/item/device/internal_implant/nvg
	var/implant_health = 2

/obj/item/device/internal_implant/nvg/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_HUMAN_POST_UPDATE_SIGHT, PROC_REF(give_nvg))
	RegisterSignal(M, COMSIG_MOB_DEATH, PROC_REF(remove_health))
	give_nvg(M)

/obj/item/device/internal_implant/nvg/proc/remove_health(mob/living/M)
	SIGNAL_HANDLER
	implant_health--
	if(implant_health <= 0)
		UnregisterSignal(M, list(
			COMSIG_HUMAN_POST_UPDATE_SIGHT,
			COMSIG_MOB_DEATH
		))
		to_chat(M, SPAN_WARNING("一切似乎都暗了许多。"))
	else
		to_chat(M, SPAN_WARNING("你感觉夜视植入物的效果正在减弱。"))

/obj/item/device/internal_implant/nvg/proc/give_nvg(mob/living/M)
	SIGNAL_HANDLER
	M.see_in_dark = 12
	M.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	M.sync_lighting_plane_alpha()

/obj/item/device/implanter/rejuv
	name = "复苏植入物"
	desc = "在濒死时自动启动的一次性植入物。启动后会大幅治疗伤势，并注入兴奋剂，显著加快移动速度、抑制所有疼痛。"
	implant_type = /obj/item/device/internal_implant/rejuv
	implant_string = "心脏旁边有什么东西在跳动。" //spooky second heart deep lore

/obj/item/device/internal_implant/rejuv
	/// Assoc list where the keys are the reagent ids of the reagents to be injected and the values are the amount to be injected
	var/list/stimulant_to_inject = list(
		"speed_stimulant" = 0.5,
		"redemption_stimulant" = 3,
	)

/obj/item/device/internal_implant/rejuv/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	), PROC_REF(check_revive))

/obj/item/device/internal_implant/rejuv/proc/check_revive(mob/living/M, list/damagedata, damagetype)
	SIGNAL_HANDLER
	if((M.health - damagedata["damage"]) <= HEALTH_THRESHOLD_CRIT)
		UnregisterSignal(M, list(
			COMSIG_MOB_TAKE_DAMAGE,
			COMSIG_HUMAN_TAKE_DAMAGE,
			COMSIG_XENO_TAKE_DAMAGE
		))

		INVOKE_ASYNC(src, PROC_REF(revive), M)

/obj/item/device/internal_implant/rejuv/proc/revive(mob/living/M)
	M.heal_all_damage()

	for(var/i in stimulant_to_inject)
		var/reagent_id = i
		var/injection_amt = stimulant_to_inject[i]
		M.reagents.add_reagent(reagent_id, injection_amt)

/obj/item/device/implanter/agility
	name = "敏捷植入物"
	desc = "使你更加敏捷，可以极快地翻越障碍，并以消防员式背负法扛起他人。"
	implant_type = /obj/item/device/internal_implant/agility
	implant_string = "心率显著加快，瞳孔也在扩张。"

/obj/item/device/implanter/agility/get_examine_text(user)
	. = ..()
	. += SPAN_NOTICE("要用消防员式背负法扛起某人，先用强力抓取抓住对方，再将其角色图像拖到自己身上。")

/obj/item/device/internal_implant/agility
	var/move_delay_mult  = 0.94
	var/climb_delay_mult = 0.20
	var/carry_delay_mult = 0.25
	var/grab_delay_mult  = 0.30

/obj/item/device/internal_implant/agility/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_HUMAN_POST_MOVE_DELAY, PROC_REF(handle_movedelay))
	RegisterSignal(M, COMSIG_LIVING_CLIMB_STRUCTURE, PROC_REF(handle_climbing))
	RegisterSignal(M, COMSIG_HUMAN_CARRY, PROC_REF(handle_fireman))
	RegisterSignal(M, COMSIG_MOB_GRAB_UPGRADE, PROC_REF(handle_grab))

/obj/item/device/internal_implant/agility/proc/handle_movedelay(mob/living/M, list/movedata)
	SIGNAL_HANDLER
	movedata["move_delay"] *= move_delay_mult

/obj/item/device/internal_implant/agility/proc/handle_climbing(mob/living/M, list/climbdata)
	SIGNAL_HANDLER
	climbdata["climb_delay"] *= climb_delay_mult

/obj/item/device/internal_implant/agility/proc/handle_fireman(mob/living/M, list/carrydata)
	SIGNAL_HANDLER
	carrydata["carry_delay"] *= carry_delay_mult
	return COMPONENT_CARRY_ALLOW

/obj/item/device/internal_implant/agility/proc/handle_grab(mob/living/M, list/grabdata)
	SIGNAL_HANDLER
	grabdata["grab_delay"] *= grab_delay_mult
	return TRUE

/obj/item/device/implanter/subdermal_armor
	name = "皮下护甲植入物"
	desc = "在皮肤下提供护甲，减少受到的伤害并强化骨骼。"
	implant_type = /obj/item/device/internal_implant/subdermal_armor
	implant_string = "皮肤明显变硬了……十年后可有得疼了。"

/obj/item/device/internal_implant/subdermal_armor
	var/burn_damage_mult = 0.9
	var/brute_damage_mult = 0.85
	var/bone_break_mult = 0.25

/obj/item/device/internal_implant/subdermal_armor/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	), PROC_REF(handle_damage))
	RegisterSignal(M, COMSIG_HUMAN_BONEBREAK_PROBABILITY, PROC_REF(handle_bonebreak))

/obj/item/device/internal_implant/subdermal_armor/proc/handle_damage(mob/living/M, list/damagedata, damagetype)
	SIGNAL_HANDLER
	if(damagetype == BRUTE)
		damagedata["damage"] *= brute_damage_mult
	else if(damagetype == BURN)
		damagedata["damage"] *= burn_damage_mult

/obj/item/device/internal_implant/subdermal_armor/proc/handle_bonebreak(mob/living/M, list/bonedata)
	SIGNAL_HANDLER
	bonedata["bonebreak_probability"] *= bone_break_mult
