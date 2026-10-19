//-------------------------------------------------------
//SNIPER RIFLES
//Keyword rifles. They are subtype of rifles, but still contained here as a specialist weapon.

//Because this parent type did not exist
//Note that this means that snipers will have a slowdown of 3, due to the scope
/obj/item/weapon/gun/rifle/sniper
	mouse_pointer = 'icons/effects/mouse_pointer/sniper_mouse.dmi'

	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	wield_delay = WIELD_DELAY_SLOW

	var/has_aimed_shot = TRUE
	var/aiming_time = 1.25 SECONDS
	var/aimed_shot_cooldown
	var/aimed_shot_cooldown_delay = 2.5 SECONDS

	var/enable_aimed_shot_laser = TRUE
	var/sniper_lockon_icon = "sniper_lockon"
	var/obj/effect/ebeam/sniper_beam_type = /obj/effect/ebeam/laser
	var/sniper_beam_icon = "laser_beam"
	var/skill_locked = FALSE

	/// How far out people can tell the direction of the shot, baseline of the hAI marksman firing range
	var/fire_message_range = 30
	///If the sniper will generate a message when shot
	var/loud = TRUE

	/// Variables for Focus Fire and alternate icons for lockon and laser.
	var/enable_aimed_shot_icon_alt = FALSE
	var/sniper_lockon_icon_max = "sniper_lockon_intense"
	var/sniper_beam_icon_max = "laser_beam_intense"

/obj/item/weapon/gun/rifle/sniper/get_examine_text(mob/user)
	. = ..()
	if(!has_aimed_shot)
		return
	. += SPAN_NOTICE("此武器拥有“瞄准射击”特殊能力，经过准备后可造成更高伤害，并依据弹药附加不同的致残效果。<br><b>观测手或追踪激光能加快瞄准射击。追踪激光默认开启，也可关闭。</b>")

/obj/item/weapon/gun/rifle/sniper/Initialize(mapload, spawn_empty)
	if(has_aimed_shot)
		LAZYADD(actions_types, list(/datum/action/item_action/specialist/aimed_shot, /datum/action/item_action/specialist/toggle_laser))
	return ..()

/obj/item/weapon/gun/rifle/sniper/able_to_fire(mob/living/user)
	. = ..()
	if(. && istype(user) && skill_locked) //Let's check all that other stuff first.
		if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SNIPER)
			to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
			return 0

/obj/item/weapon/gun/rifle/sniper/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	. = ..()
	if(!.)
		return .
	if(!loud)
		return .
	for(var/mob/current_mob as anything in get_mobs_in_z_level_range(get_turf(user), fire_message_range) - user)
		var/relative_dir = Get_Compass_Dir(current_mob, user)
		var/final_dir = dir2text(relative_dir)
		if(current_mob.faction != user.faction)
			to_chat(current_mob, SPAN_HIGHDANGER("你听到[final_dir ? "[localized_player_label(final_dir)]方向" : "附近"]传来响亮的枪声！"))
		else
			to_chat(current_mob, SPAN_WARNING("你听到[final_dir ? "[localized_player_label(final_dir)]方向" : "附近"]传来响亮的枪声！"))
		if(current_mob.client)
			playsound_client(current_mob.client, 'sound/weapons/gun_vulture_report.ogg', src, 30)

	return .

// Aimed shot ability
/datum/action/item_action/specialist/aimed_shot
	ability_primacy = SPEC_PRIMARY_ACTION_2
	var/minimum_aim_distance = 2

/datum/action/item_action/specialist/aimed_shot/New(mob/living/user, obj/item/holder)
	..()
	name = "Aimed Shot"
	button.name = "瞄准射击"
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "sniper_aim")
	button.overlays += IMG
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item
	sniper_rifle.aimed_shot_cooldown = world.time

/*
		ACTIONS SPECIALSIT SNIPER CAN TAKE
*/
/datum/action/item_action/specialist/aimed_shot/action_activate()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.selected_ability == src)
		to_chat(H, "你将不再通过[H.get_ability_mouse_name()]使用[name]。")
		button.icon_state = "template"
		H.set_selected_ability(null)
	else
		to_chat(H, "你现在会通过[H.get_ability_mouse_name()]使用[name]。")
		if(H.selected_ability)
			H.selected_ability.button.icon_state = "template"
			H.set_selected_ability(null)
		button.icon_state = "template_on"
		H.set_selected_ability(src)

/datum/action/item_action/specialist/aimed_shot/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && (holder_item == H.r_hand || holder_item || H.l_hand))
		return TRUE

/datum/action/item_action/specialist/aimed_shot/proc/use_ability(atom/A)
	var/mob/living/carbon/human/human = owner
	if(!istype(A, /mob/living))
		return

	var/mob/living/target = A

	if(target.stat == DEAD || target == human)
		return

	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item
	if(world.time < sniper_rifle.aimed_shot_cooldown)
		return

	if(!check_can_use(target))
		return

	human.face_atom(target)

	///Add a decisecond to the default 1.5 seconds for each two tiles to hit.
	var/distance = floor(get_dist(target, human) * 0.5)
	var/f_aiming_time = sniper_rifle.aiming_time + distance

	var/aim_multiplier = 1
	var/aiming_buffs

	if(sniper_rifle.enable_aimed_shot_laser)
		aim_multiplier = 0.6
		aiming_buffs++

	var/mob/living/carbon/xenomorph/bug
	if(target == bug)
		aim_multiplier = 0.5
		aiming_buffs++

	if(HAS_TRAIT(target, TRAIT_SPOTTER_LAZED))
		aim_multiplier = 0.5
		aiming_buffs++

	if(aiming_buffs > 1)
		aim_multiplier = 0.35

	f_aiming_time *= aim_multiplier

	var/beam
	var/lockon

	if(istype(sniper_rifle, /obj/item/weapon/gun/rifle/sniper/XM43E1))
		var/obj/item/weapon/gun/rifle/sniper/XM43E1/amr = sniper_rifle
		if((amr.focused_fire_counter >= 1 && amr.focused_fire_counter < 3) && (target == amr.focused_fire_target?.resolve()))
			sniper_rifle.enable_aimed_shot_icon_alt = TRUE
		else
			sniper_rifle.enable_aimed_shot_icon_alt = FALSE

	if(sniper_rifle.enable_aimed_shot_icon_alt)
		beam = sniper_rifle.sniper_beam_icon_max
		lockon = sniper_rifle.sniper_lockon_icon_max
	else
		beam = sniper_rifle.sniper_beam_icon
		lockon = sniper_rifle.sniper_lockon_icon

	var/image/lockon_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = lockon)

	var/x_offset =  -target.pixel_x + target.base_pixel_x
	var/y_offset = (target.icon_size - world.icon_size) * 0.5 - target.pixel_y + target.base_pixel_y

	lockon_icon.pixel_x = x_offset
	lockon_icon.pixel_y = y_offset
	target.overlays += lockon_icon

	var/image/lockon_direction_icon
	if(!sniper_rifle.enable_aimed_shot_laser)
		lockon_direction_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "[lockon]_direction", dir = get_cardinal_dir(target, human))
		lockon_direction_icon.pixel_x = x_offset
		lockon_direction_icon.pixel_y = y_offset
		target.overlays += lockon_direction_icon
	if(human.client)
		playsound_client(human.client, 'sound/weapons/TargetOn.ogg', human, 50)
	playsound(target, 'sound/weapons/TargetOn.ogg', 70, FALSE, 8, falloff = 0.4)

	var/datum/beam/laser_beam
	if(sniper_rifle.enable_aimed_shot_laser)
		laser_beam = target.beam(human, beam, 'icons/effects/beam.dmi', (f_aiming_time + 1 SECONDS), beam_type = sniper_rifle.sniper_beam_type)
		laser_beam.visuals.alpha = 0
		animate(laser_beam.visuals, alpha = initial(laser_beam.visuals.alpha), f_aiming_time, easing = SINE_EASING|EASE_OUT)

	////timer is (f_spotting_time + 1 SECONDS) because sometimes it janks out before the doafter is done. blame sleeps or something

	if(!do_after(human, f_aiming_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, NO_BUSY_ICON))
		target.overlays -= lockon_icon
		target.overlays -= lockon_direction_icon
		qdel(laser_beam)
		return

	target.overlays -= lockon_icon
	target.overlays -= lockon_direction_icon
	qdel(laser_beam)

	if(!check_can_use(target, TRUE) || target.is_dead())
		return

	var/obj/projectile/aimed_proj = sniper_rifle.in_chamber
	aimed_proj.projectile_flags |= PROJECTILE_BULLSEYE
	aimed_proj.AddComponent(/datum/component/homing_projectile, target, human)
	sniper_rifle.Fire(target, human)

/datum/action/item_action/specialist/aimed_shot/proc/check_can_use(mob/M, cover_lose_focus)
	var/mob/living/carbon/human/H = owner
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item

	if(!can_use_action())
		return FALSE

	if(sniper_rifle != H.r_hand && sniper_rifle != H.l_hand)
		to_chat(H, SPAN_WARNING("没有狙击步枪，你打算怎么做？"))
		return FALSE

	if(!(sniper_rifle.flags_item & WIELDED))
		to_chat(H, SPAN_WARNING("单手瞄准不够稳定，请双手持枪！"))
		return FALSE

	if(!sniper_rifle.in_chamber)
		to_chat(H, SPAN_WARNING("[sniper_rifle]没有装填！"))
		return FALSE

	if(get_dist(H, M) < minimum_aim_distance)
		to_chat(H, SPAN_WARNING("[M]太近，无法好好瞄准！"))
		return FALSE

	var/obj/projectile/P = sniper_rifle.in_chamber
	// TODO: Make the below logic only occur in certain circumstances. Check goggles, maybe? -Kaga
	if(check_shot_is_blocked(H, M, P))
		to_chat(H, SPAN_WARNING("有东西挡着，或者目标已超出射程！"))
		if(cover_lose_focus)
			to_chat(H, SPAN_WARNING("你失去了专注。"))
			COOLDOWN_START(sniper_rifle, aimed_shot_cooldown, sniper_rifle.aimed_shot_cooldown_delay * 0.5)
		return FALSE

	COOLDOWN_START(sniper_rifle, aimed_shot_cooldown, sniper_rifle.aimed_shot_cooldown_delay)
	return TRUE

/datum/action/item_action/specialist/aimed_shot/proc/check_shot_is_blocked(mob/firer, mob/target, obj/projectile/P)
	var/list/turf/path = get_line(firer, target, include_start_atom = FALSE)
	if(!length(path) || get_dist(firer, target) > P.ammo.max_range)
		return TRUE

	var/blocked = FALSE
	for(var/turf/T in path)
		if(T.density && T.opacity)
			blocked = TRUE
			break

		for(var/obj/O in T)
			if(O.get_projectile_hit_boolean(P) && O.opacity)
				blocked = TRUE
				break

		for(var/obj/effect/particle_effect/smoke/S in T)
			blocked = TRUE
			break

	return blocked

// Snipers may enable or disable their laser tracker at will.
/datum/action/item_action/specialist/toggle_laser

/datum/action/item_action/specialist/toggle_laser/New(mob/living/user, obj/item/holder)
	..()
	name = "Toggle Tracker Laser"
	button.name = "切换追踪激光"
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "sniper_toggle_laser_on")
	button.overlays += IMG
	update_button_icon()

/datum/action/item_action/specialist/toggle_laser/update_button_icon()
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item

	var/icon = 'icons/mob/hud/actions.dmi'
	var/icon_state = "sniper_toggle_laser_[sniper_rifle.enable_aimed_shot_laser ? "on" : "off"]"

	button.overlays.Cut()
	var/image/IMG = image(icon, button, icon_state)
	button.overlays += IMG

/datum/action/item_action/specialist/toggle_laser/can_use_action()
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item

	if(owner.is_mob_incapacitated())
		return FALSE

	if(owner.get_held_item() != sniper_rifle)
		to_chat(owner, SPAN_WARNING("手里没有狙击步枪，你打算怎么做？"))
		return FALSE
	return TRUE

/datum/action/item_action/specialist/toggle_laser/action_activate()
	. = ..()
	var/obj/item/weapon/gun/rifle/sniper/sniper_rifle = holder_item

	if(owner.get_held_item() != sniper_rifle)
		to_chat(owner, SPAN_WARNING("手里没有狙击步枪，你打算怎么做？"))
		return FALSE
	sniper_rifle.toggle_laser(owner, src)

/obj/item/weapon/gun/rifle/sniper/proc/toggle_laser(mob/user, datum/action/toggling_action)
	enable_aimed_shot_laser = !enable_aimed_shot_laser
	to_chat(user, SPAN_NOTICE("你拨动[src]上的开关，[enable_aimed_shot_laser ? "启用" : "停用"]了瞄准激光。"))
	playsound(user, 'sound/machines/click.ogg', 15, TRUE)
	if(!toggling_action)
		toggling_action = locate(/datum/action/item_action/specialist/toggle_laser) in actions
	if(toggling_action)
		toggling_action.update_button_icon()

/obj/item/weapon/gun/rifle/sniper/verb/toggle_gun_laser()
	set category = "Weapons"
	set name = "Toggle Laser"
	set desc = "开启或关闭激光瞄准器。"
	set src = usr.contents

	var/obj/item/weapon/gun/rifle/sniper/sniper = get_active_firearm(usr)
	if((sniper == src) && has_aimed_shot)
		toggle_laser(usr)

//Pow! Headshot.

// end of actions sniper spe can take.

/obj/item/weapon/gun/rifle/sniper/M42A
	name = "M42A 带镜步枪"
	desc = "阿玛特系统制造的重型狙击步枪，配有瞄准镜系统，使用 15 发弹匣发射穿甲弹。\n“以优势火力换取和平。”"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m42a"
	item_state = "m42a"
	unacidable = TRUE
	indestructible = 1
	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/sniper
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod)
	starting_attachment_types = list(/obj/item/attachable/sniperbarrel)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	map_specific_decoration = FALSE
	flags_item = TWOHANDED|NO_CRYO_STORE

/obj/item/weapon/gun/rifle/sniper/M42A/verb/toggle_scope_zoom_level()
	set name = "Toggle Scope Zoom Level"
	set category = "Weapons"
	set src in usr
	var/obj/item/attachable/scope/variable_zoom/S = attachments["rail"]
	S.toggle_zoom_level()

/obj/item/weapon/gun/rifle/sniper/M42A/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/variable_zoom/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/sniper/M42A/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/rifle/sniper/M42A/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 39, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 20, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)


/obj/item/weapon/gun/rifle/sniper/M42A/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SNIPER)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/sniper/M42A/basic
	current_mag = /obj/item/ammo_magazine/sniper/basic

/obj/item/weapon/gun/rifle/sniper/M42A/silenced
	name = "M42A2 SSR 狙击步枪"
	desc = "M42A2 消音带镜步枪，简称 SSR，是阿玛特系统制造的重型狙击步枪。改装了集成消音器，配有瞄准镜系统，使用 15 发弹匣发射穿甲弹。\n“以优势火力换取和平。”"
	starting_attachment_types = list(/obj/item/attachable/supsniperbarrel)
	loud = FALSE

/obj/item/weapon/gun/rifle/sniper/M42A/silenced/unloaded
	current_mag = null
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_TRIGGER_SAFETY

/obj/item/weapon/gun/rifle/sniper/XM43E1
	name = "XM43E1 实验型反器材步枪"
	desc = "阿玛特系统制造的实验型反器材步枪，最近从一座废弃原型设施的深层仓库中重新取出。这一把正在进行实地测试，使用 10x99mm 无壳弹。\n\n可穿透薄金属板和墙壁，但会因此损失大部分杀伤力。它甚至能用于拆毁建筑：熟练使用者只需一只标准 10x99mm 弹匣，就能拆掉一段坚固的强化墙。没有炸药或工兵时，他们用 8 发子弹逐一破坏关键承重结构，使墙体解体。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "xm43e1"
	item_state = "xm43e1"
	unacidable = TRUE
	indestructible = 1
	aiming_time = 2 SECONDS
	aimed_shot_cooldown_delay = 4.5 SECONDS
	var/focused_fire_counter = 0
	var/datum/weakref/focused_fire_target = null

	fire_sound = 'sound/weapons/sniper_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/anti_materiel //Renamed from anti-tank to align with new identity/description. Other references have been changed as well. -Kaga
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS
	starting_attachment_types = list(/obj/item/attachable/pmc_sniperbarrel)
	sniper_beam_type = /obj/effect/ebeam/laser
	sniper_beam_icon = "laser_beam"
	sniper_lockon_icon = "sniper_lockon"

/obj/item/weapon/gun/rifle/sniper/XM43E1/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/variable_zoom/S = new(src)
	S.icon_state = "pmcscope"
	S.attach_icon = "pmcscope"
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)


/obj/item/weapon/gun/rifle/sniper/XM43E1/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 15, "rail_y" = 19, "under_x" = 20, "under_y" = 15, "stock_x" = 20, "stock_y" = 15)


/obj/item/weapon/gun/rifle/sniper/XM43E1/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_AMR)//Big boy damage, but it takes a lot of time to fire a shot.
	//Kaga: Fixed back to half the M42A's firerate (3 seconds), using a new define.
	//This outright deals less DPS than the normal sniper rifle, 125 vs 140 per 3s.
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT + 2*HIT_ACCURACY_MULT_TIER_10 //Who coded this like this, and why? It just calculates out to 1+1=2. Leaving a note here to check back later.
	scatter = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/rifle/sniper/XM43E1/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff),
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 11, GLOB.damage_boost_turfs),
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 15, GLOB.damage_boost_breaching),
		//At 2090 per shot vs resin and 2850 vs normal, it'll take 1 shot to break resin turfs usually (thick resin at 1350, RNG may vary), and half a mag (4 rounds) to break reinforced walls.
		//Much more effective at breaking resin doors and membranes, which have less HP and slow down the projectile less.
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 6, GLOB.damage_boost_pylons)
		//At 1140 per shot it'll take 2 to break a Pylon (1800 HP). No Damage Boost vs other xeno structures yet, those will require a whole new list w/ the damage_boost trait.
	))

/*
//Disabled until an identity is better defined. -Kaga
/obj/item/weapon/gun/rifle/sniper/M42B/afterattack(atom/target, mob/user, flag)
	if(able_to_fire(user))
		if(get_dist(target,user) <= 8)
			to_chat(user, SPAN_WARNING("The [src.name] beeps, indicating that the target is within an unsafe proximity to the rifle, refusing to fire."))
			return
		else ..()
*/

/obj/item/weapon/gun/rifle/sniper/elite
	name = "\improper M42C 瞄准步枪"
	desc = "维兰德－阿玛特的高端紧凑型精确射手步枪，使用 10×28 毫米无壳弹。几乎只见于公司私人军事部队，是 M42A 的阔气表亲。开发目标是通过更高射速与更小枪身，填补狙击步枪和精确射手步枪之间的空白。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/wy.dmi'
	icon_state = "m42c"
	item_state = "m42c" //NEEDS A TWOHANDED STATE

	fire_sound = 'sound/weapons/sniper_heavy.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/elite/basic
	force = 17
	zoomdevicename = "scope"
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WY_RESTRICTED|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS
	starting_attachment_types = list(/obj/item/attachable/pmc_sniperbarrel)
	sniper_beam_type = /obj/effect/ebeam/laser/intense
	sniper_beam_icon = "laser_beam_intense"
	sniper_lockon_icon = "sniper_lockon_intense"
	aim_slowdown = SLOWDOWN_ADS_RIFLE

/obj/item/weapon/gun/rifle/sniper/elite/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/variable_zoom/PMC_Scope = new(src)
	PMC_Scope.icon_state = "pmcscope"
	PMC_Scope.attach_icon = "pmcscope"
	PMC_Scope.flags_attach_features &= ~ATTACH_REMOVABLE
	PMC_Scope.Attach(src)
	update_attachable(PMC_Scope.slot)

/obj/item/weapon/gun/rifle/sniper/elite/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 15, "rail_y" = 19, "under_x" = 20, "under_y" = 15, "stock_x" = 20, "stock_y" = 15)

/obj/item/weapon/gun/rifle/sniper/elite/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_2)
	set_burst_amount(0)
	accuracy_mult = BASE_ACCURACY_MULT * 3
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_1

/obj/item/weapon/gun/rifle/sniper/elite/heap
	current_mag = /obj/item/ammo_magazine/sniper/elite

//Type 88 //Based on the actual Dragunov DMR rifle.

/obj/item/weapon/gun/rifle/sniper/svd
	name = "88 式精确射手步枪"
	desc = "UPP 制式精确射手步枪。88 式的高精度让竞技射手与恐怖分子都趋之若鹜。通常使用装有 12 发 7.62x54mmR 穿甲弹的弹匣。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "type88"
	item_state = "type88"

	fire_sound = 'sound/weapons/gun_mg.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/svd
	attachable_allowed = list(
		//Muzzle,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp/surplus,
		/obj/item/attachable/bayonet/upp,
		//Under,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/verticalgrip/upp,
		/obj/item/attachable/bipod,
		//Integrated,
		/obj/item/attachable/type88_barrel,
	)
	has_aimed_shot = FALSE
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	starting_attachment_types = list()
	sniper_beam_type = null
	skill_locked = FALSE

/obj/item/weapon/gun/rifle/sniper/svd/handle_starting_attachment()
	..()
	var/obj/item/attachable/attachie = new /obj/item/attachable/type88_barrel(src)
	attachie.flags_attach_features &= ~ATTACH_REMOVABLE
	attachie.Attach(src)
	update_attachable(attachie.slot)

	var/obj/item/attachable/scope/variable_zoom/integrated/type88sight = new(src)
	type88sight.flags_attach_features &= ~ATTACH_REMOVABLE
	type88sight.hidden = TRUE
	type88sight.Attach(src)
	update_attachable(type88sight.slot)

/obj/item/weapon/gun/rifle/sniper/svd/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 13, "rail_y" = 19, "under_x" = 26, "under_y" = 14, "stock_x" = 24, "stock_y" = 13, "special_x" = 39, "special_y" = 18)

/obj/item/weapon/gun/rifle/sniper/svd/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_VULTURE)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	damage_falloff_mult = 0

/obj/item/weapon/gun/rifle/sniper/svd/iff
	name = "\improper 88-I 式精确射手步枪"
	desc = /obj/item/weapon/gun/rifle/sniper/svd::desc + " 这把配备敌我识别系统，并经过改装以提高射速。"
	actions_types = list(/datum/action/item_action/toggle_iff_svd)
	var/iff_enabled = TRUE

/obj/item/weapon/gun/rifle/sniper/svd/iff/handle_starting_attachment()
	var/obj/item/attachable/attachie = new /obj/item/attachable/type88_barrel(src)
	attachie.flags_attach_features &= ~ATTACH_REMOVABLE
	attachie.Attach(src)
	update_attachable(attachie.slot)

	var/obj/item/attachable/scope/variable_zoom/integrated/svd_iff/type88sight = new(src)
	type88sight.flags_attach_features &= ~ATTACH_REMOVABLE
	type88sight.hidden = FALSE //cagged out
	type88sight.Attach(src)
	update_attachable(type88sight.slot)

/obj/item/weapon/gun/rifle/sniper/svd/iff/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff) //it has no PVE IFF mechanics because its innacurate as hell and is used for suppression and not as assault weapon.
	))

/datum/action/item_action/toggle_iff_svd/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle IFF"
	action_icon_state = "iff_toggle_on"
	button.name = "切换敌我识别"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle_iff_svd/action_activate()
	. = ..()

	var/obj/item/weapon/gun/rifle/sniper/svd/iff/G = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.is_mob_incapacitated() || G.get_active_firearm(H, FALSE) != holder_item)
		return

	G.toggle_lethal_mode(usr)
	if(G.iff_enabled)
		action_icon_state = "iff_toggle_on"
	else
		action_icon_state = "iff_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/obj/item/weapon/gun/rifle/sniper/svd/iff/proc/toggle_lethal_mode(mob/user)
	to_chat(user, "[icon2html(src, usr)]你[iff_enabled? "<B>停用</b>" : "<B>启用</b>"]了[src]的射击限制。现在会[iff_enabled ? "伤害挡在面前的任何人" : "通过敌我识别系统筛选目标"]。")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	iff_enabled = !iff_enabled
	if(iff_enabled)
		add_bullet_trait(BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff))
	if(!iff_enabled)
		remove_bullet_trait("iff")
	SEND_SIGNAL(src, COMSIG_GUN_IFF_TOGGLED, iff_enabled)

/obj/item/weapon/gun/rifle/sniper/svd/iff/stored
	current_mag = null
	flags_gun_features = /obj/item/weapon/gun/rifle/sniper/svd/iff::flags_gun_features | GUN_TRIGGER_SAFETY


/obj/item/weapon/gun/rifle/sniper/svd/pve
	current_mag = /obj/item/ammo_magazine/sniper/svd/pve

/obj/item/weapon/gun/rifle/sniper/rmc
	name = "L64A3 精确射手步枪"
	desc = "丰友精密机械为皇家陆战队研制的轻型精确射手步枪，旨在提供比旧 F903 更远、更灵敏的远程火力。连续装药碎甲战斗部取代了传统钢芯穿甲弹的需求，并提高远距离伤害保持能力。更快的枪机循环与轻扳机，即使在千米距离也能迅速精准地补射。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/twe_guns.dmi'
	icon_state = "rmcdmr"
	item_state = "rmcdmr"
	unacidable = TRUE
	indestructible = 1
	aiming_time = 0.6 SECONDS
	aimed_shot_cooldown_delay = 1.2 SECONDS
	fire_sound = "gun_rmcdmr"
	reload_sound = 'sound/weapons/handling/gun_rmcdmr_reload.ogg'
	unload_sound = 'sound/weapons/handling/gun_rmcdmr_unload.ogg'
	current_mag = /obj/item/ammo_magazine/sniper/rmc
	wield_delay = WIELD_DELAY_FAST
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod)
	starting_attachment_types = list(/obj/item/attachable/stock/rmcdmr)
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER
	map_specific_decoration = FALSE
	flags_item = TWOHANDED
	loud = FALSE

/obj/item/weapon/gun/rifle/sniper/rmc/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/rmcdmr/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/sniper/rmc/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 39, "muzzle_y" = 17,"rail_x" = 10, "rail_y" = 20, "under_x" = 19, "under_y" = 14, "stock_x" = 22, "stock_y" = 11)

/obj/item/weapon/gun/rifle/sniper/rmc/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_8)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_9
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
