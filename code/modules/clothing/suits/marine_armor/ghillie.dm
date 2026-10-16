#define FULL_CAMOUFLAGE_ALPHA 5
#define VISIBLE_CAMOUFLAGE_ALPHA 60

#define FULL_PVE_CAMOUFLAGE_ALPHA 20
#define VISIBLE_PVE_CAMOUFLAGE_ALPHA 75

/obj/item/clothing/suit/storage/marine/ghillie
	name = "\improper M45型吉利伪装护甲"
	desc = "一套轻便的吉利伪装服，供殖民地陆战队侦察狙击手执行侦察任务时使用。非常轻便，但防护有限。"
	icon_state = "ghillie_armor"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_VERY_LIGHT
	flags_marine_armor = ARMOR_LAMP_OVERLAY
	specialty = "M45型吉利伪装"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_PONCHO)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	unacidable = TRUE

	var/camo_active = FALSE
	var/hide_in_progress = FALSE
	var/full_camo_alpha = FULL_PVE_CAMOUFLAGE_ALPHA
	var/incremental_shooting_camo_penalty = 20
	var/current_camo = FULL_PVE_CAMOUFLAGE_ALPHA
	var/visible_camo_alpha = VISIBLE_PVE_CAMOUFLAGE_ALPHA
	var/camouflage_break = 5 SECONDS
	var/camouflage_enter_delay = 2 SECONDS
	var/can_camo = TRUE
	var/camouflage_break_message = 2 SECONDS

	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/specialist/prepare_position)

/obj/item/clothing/suit/storage/marine/ghillie/dropped(mob/user)
	if(ishuman(user) && !issynth(user))
		deactivate_camouflage(user, FALSE)

	. = ..()

/obj/item/clothing/suit/storage/marine/ghillie/verb/camouflage()
	set name = "伪装隐蔽"
	set desc = "利用吉利服和周围环境，让自己几乎隐形。"
	set category = "物品"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return

	if(!ishuman(usr) || hide_in_progress || !can_camo)
		return
	var/mob/living/carbon/human/H = usr
	if(H.wear_suit != src)
		to_chat(H, SPAN_WARNING("你必须穿上吉利服才能启用伪装！"))
		return

	if(camo_active)
		deactivate_camouflage(H)
		return

	H.visible_message(SPAN_DANGER("[H]开始调整吉利服，逐渐融入周围环境！"), SPAN_NOTICE("你开始调整吉利服。"), max_distance = 4)
	hide_in_progress = TRUE
	H.unset_interaction() // If we're sticking to a machine gun or what not.
	if(!do_after(H, camouflage_enter_delay, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		hide_in_progress = FALSE
		return
	hide_in_progress = FALSE
	RegisterSignal(H,  list(
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOB_FIRED_GUN_ATTACHMENT)
		, PROC_REF(fade_in))
	RegisterSignal(H, list(
		COMSIG_MOB_DEATH,
		COMSIG_HUMAN_EXTINGUISH
	), PROC_REF(deactivate_camouflage))
	camo_active = TRUE
	ADD_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_JACKET))
	H.alpha = full_camo_alpha
	H.FF_hit_evade = 1000


	var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
	SA.remove_from_hud(H)
	var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
	XI.remove_from_hud(H)

	playsound(H.loc, 'sound/effects/cloak_scout_on.ogg', 15, TRUE)
	anim(H.loc, H, 'icons/mob/mob.dmi', null, "cloak", null, H.dir)
	slowdown = SLOWDOWN_ARMOR_CLOAKED_GHILLIE //No super speed whilst invis, you're moving slow to ensure you stay hidden

/obj/item/clothing/suit/storage/marine/ghillie/proc/deactivate_camouflage(mob/user)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return FALSE

	if(!camo_active)
		return

	UnregisterSignal(H, list(
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOB_FIRED_GUN_ATTACHMENT,
		COMSIG_MOB_DEATH,
		COMSIG_HUMAN_EXTINGUISH
	))

	camo_active = FALSE
	playsound(H.loc, 'sound/effects/cloak_scout_off.ogg', 15, TRUE)
	anim(H.loc, H,'icons/mob/mob.dmi', null, "uncloak", null, H.dir)
	REMOVE_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_JACKET))
	H.alpha = 255
	H.FF_hit_evade = initial(H.FF_hit_evade)
	slowdown = initial(slowdown) //Back to schmoving quick

	var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(H)
	var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(H)

	H.visible_message(SPAN_DANGER("[H]的伪装失效了！"), SPAN_WARNING("你的伪装失效了！"), max_distance = 4)

/obj/item/clothing/suit/storage/marine/ghillie/proc/fade_in(mob/user)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = user
	if(camo_active)
		if(current_camo < full_camo_alpha)
			current_camo = full_camo_alpha
		current_camo = clamp(current_camo + incremental_shooting_camo_penalty, full_camo_alpha, 255)
		H.alpha = current_camo
		if(current_camo > visible_camo_alpha)
			REMOVE_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_JACKET))
			to_chat(H, SPAN_BOLDNOTICE("吉利服已经无法让你完全隐蔽！"))
		addtimer(CALLBACK(src, PROC_REF(fade_out_finish), H), camouflage_break, TIMER_OVERRIDE|TIMER_UNIQUE)
		animate(H, alpha = full_camo_alpha + 5, time = camouflage_break, easing = LINEAR_EASING, flags = ANIMATION_END_NOW)

/obj/item/clothing/suit/storage/marine/ghillie/proc/fade_out_finish(mob/living/carbon/human/H)
	if(camo_active && H.wear_suit == src)
		ADD_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_JACKET))
		to_chat(H, SPAN_BOLDNOTICE("烟雾散去，吉利服再次让你完全隐蔽！"))
		animate(H, alpha = full_camo_alpha)
		current_camo = full_camo_alpha

/datum/action/item_action/specialist/prepare_position
	ability_primacy = SPEC_PRIMARY_ACTION_1

/datum/action/item_action/specialist/prepare_position/New(mob/living/user, obj/item/holder)
	..()
	name = "伪装隐蔽"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "prepare_position")
	button.overlays += IMG

/datum/action/item_action/specialist/prepare_position/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && H.body_position == STANDING_UP && holder_item == H.wear_suit)
		return TRUE

/datum/action/item_action/specialist/prepare_position/action_activate()
	. = ..()
	var/obj/item/clothing/suit/storage/marine/ghillie/GS = holder_item
	GS.camouflage()

/obj/item/clothing/suit/storage/marine/ghillie/invis
	full_camo_alpha = FULL_CAMOUFLAGE_ALPHA
	current_camo = FULL_CAMOUFLAGE_ALPHA
	visible_camo_alpha = VISIBLE_CAMOUFLAGE_ALPHA

/obj/item/clothing/suit/storage/marine/ghillie/forecon
	name = "UDEP热隐蔽雨披"
	desc = "UDEP，即超扩散环境雨披，是一种用于抵御恶劣天气和化学品泼溅的迷彩雨披。它通常涂有吸收红外线的涂层，让陆战队员在雨中几乎无法被发现。其舒适性与实用性深受殖民地陆战队专业兵喜爱。"
	icon_state = "mercenary_miner_armor"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/ghillie/forecon/invis
	full_camo_alpha = FULL_CAMOUFLAGE_ALPHA
	current_camo = FULL_CAMOUFLAGE_ALPHA
	visible_camo_alpha = VISIBLE_CAMOUFLAGE_ALPHA

#undef FULL_CAMOUFLAGE_ALPHA
#undef VISIBLE_CAMOUFLAGE_ALPHA
#undef FULL_PVE_CAMOUFLAGE_ALPHA
#undef VISIBLE_PVE_CAMOUFLAGE_ALPHA
