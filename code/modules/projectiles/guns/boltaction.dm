
// Bolt Action Rifle Code, credit to Alardun and Optimisticdude. This is for bolt action rifles which use external magazines, such as the AWM International, rather than internally fed rifles such as the Mosin-Nagant.
// For internally fed bolt actions, it'd be more advised to use pump shotgun code, or obj/item/weapon/gun/shotgun/pump, to create that type of variant of bolt action rifle.

/obj/item/weapon/gun/boltaction
	name = "巴西拉-阿姆斯特朗栓动猎枪"
	desc = "以古怪设计师们命名的巴西拉-阿姆斯特朗，是廉价可靠的民用栓动步枪，常见于外缘殖民地。虽然弹匣容量受法律限制，但轻便和传奇般的精度使它深受猎人与竞技射手欢迎。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "boltaction"
	item_state = "hunting"
	mouse_pointer = 'icons/effects/mouse_pointer/sniper_mouse.dmi'

	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	force = 5
	flags_gun_features = GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY
	gun_category = GUN_CATEGORY_RIFLE
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	wield_delay = WIELD_DELAY_NORMAL
	current_mag = /obj/item/ammo_magazine/rifle/boltaction
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/co2,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini/hunting,
		/obj/item/attachable/stock/hunting,
	)
	starting_attachment_types = list(/obj/item/attachable/stock/hunting, /obj/item/attachable/scope/mini/hunting)
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	wield_delay = WIELD_DELAY_NORMAL
	civilian_usable_override = TRUE
	unacidable = TRUE // Like other 1-of-a-kind weapons, it can't be gotten rid of that fast
	indestructible = TRUE

	cocked_sound = 'sound/weapons/gun_cocked2.ogg'
	fire_sound = 'sound/weapons/gun_boltaction.ogg'
	var/open_bolt_sound ='sound/weapons/handling/gun_boltaction_open.ogg'
	var/close_bolt_sound ='sound/weapons/handling/gun_boltaction_close.ogg'

	var/bolted = TRUE // FALSE IS OPEN, TRUE IS CLOSE
	var/bolt_delay
	var/recent_cycle //world.time to see when they last bolted it.
	/// If this gun should change icon states when the bolt is open
	var/has_openbolt_icon = TRUE

/obj/item/weapon/gun/boltaction/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 5, "rail_y" = 18, "under_x" = 25, "under_y" = 14, "stock_x" = 20, "stock_y" = 9)

/obj/item/weapon/gun/boltaction/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()
	bolt_delay = FIRE_DELAY_TIER_5

/obj/item/weapon/gun/boltaction/update_icon() // needed for bolt action sprites
	..()

	var/new_icon_state = icon_state
	if(!bolted && has_openbolt_icon)
		new_icon_state += "_o"

	icon_state = new_icon_state

/obj/item/weapon/gun/boltaction/set_gun_config_values()
	..()
	set_burst_amount(0)
	set_fire_delay(FIRE_DELAY_TIER_4)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_8
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/boltaction/unique_action(mob/M)
	if(world.time < (recent_cycle + bolt_delay) )  //Don't spam it.
		to_chat(M, SPAN_DANGER("你暂时还不能再次拉动枪栓。"))
		return

	bolted = !bolted

	if(bolted)
		to_chat(M, SPAN_DANGER("你推上了[src]的枪栓！"))
		playsound(get_turf(src), open_bolt_sound, 15, TRUE, 1)
		ready_in_chamber()
		recent_cycle = world.time
	else
		to_chat(M, SPAN_DANGER("你拉开了[src]的枪栓！"))
		playsound(get_turf(src), close_bolt_sound, 65, TRUE, 1)
		eject_casing()
		unload_chamber(M)

	update_icon()

/obj/item/weapon/gun/boltaction/able_to_fire(mob/user)
	. = ..()

	if(. && !bolted)
		to_chat(user, SPAN_WARNING("枪栓尚未闭合，无法发射[src]。"))
		return FALSE

/obj/item/weapon/gun/boltaction/load_into_chamber(mob/user)
	return in_chamber

/obj/item/weapon/gun/boltaction/reload_into_chamber(mob/user)
	in_chamber = null
	return TRUE

/obj/item/weapon/gun/boltaction/cock(mob/user)
	return

/obj/item/weapon/gun/boltaction/replace_magazine(mob/user, obj/item/ammo_magazine/magazine) //mostly standard but without the cock-and-load if unchambered.
	user.drop_inv_item_to_loc(magazine, src) //Click!
	current_mag = magazine
	replace_ammo(user,magazine)
	user.visible_message(SPAN_NOTICE("[user]将[magazine]装入[src]！"),
		SPAN_NOTICE("你将[magazine]装入[src]！"), null, 3, CHAT_TYPE_COMBAT_ACTION)
	if(reload_sound)
		playsound(user, reload_sound, 25, 1, 5)


/obj/item/weapon/gun/boltaction/vulture
	name = "\improper M707“秃鹫”反器材步枪"
	desc = "M707是一支结构粗糙却威力强大的步枪，专为瘫痪轻型装甲车辆和打击建筑内的目标而设计。笨重的瞄准镜与大口径使它需要观测手配合才能充分发挥效能；没有观测手时，瞄准镜会出现严重漂移。"
	desc_lore = {"
		M707 于2175年投产，以较低成本应对外环日益猖獗的武装活动。其设计源自林纳349战役中缴获的临时拼装反器材步枪。

		叛军被美国殖民地海军陆战队俗称为“虫崽子”和“比波普”。在诺伊绍讷，他们用这种步枪射击携带焚烧器的陆战队员，引爆队列中的凝固汽油燃料罐，取得了显著战果。此后，陆战队将这类步枪的使用者列为优先打击目标，并相应调整了巡逻战术。

		战役初期，载具乘员很快就发现了这些“比波普”拼装步枪的缺陷与怪癖。多部回忆录都记载过类似的说法：“一听到雨声，就知道中埋伏了。”

		乘员听到的“雨点”声，其实是多支步枪击中载具外部装甲却无法击穿的声音。研究了缴获的反器材步枪后，陆战队将研制自用型号列为优先任务。最终设计采用了比叛军版本更大的口径，使 M707 能在犬之战争或天津事件再次发生时，击穿进步人民联盟轻型载具的装甲。"}

	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi' // overridden with camos
	icon_state = "vulture"
	item_state = "vulture"
	cocked_sound = 'sound/weapons/gun_cocked2.ogg'
	fire_sound = 'sound/weapons/gun_vulture_fire.ogg'
	open_bolt_sound ='sound/weapons/handling/gun_vulture_bolt_eject.ogg'
	close_bolt_sound ='sound/weapons/handling/gun_vulture_bolt_close.ogg'
	flags_equip_slot = SLOT_BACK|SLOT_BLOCK_SUIT_STORE
	w_class = SIZE_LARGE
	force = 5
	flags_gun_features = NONE
	gun_category = GUN_CATEGORY_HEAVY
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST // Consider SUPERWEAPON, but it's not like you can fire this without being bipodded
	wield_delay = WIELD_DELAY_VERY_SLOW
	map_specific_decoration = TRUE
	current_mag = /obj/item/ammo_magazine/rifle/boltaction/vulture
	attachable_allowed = list(
		/obj/item/attachable/sniperbarrel/vulture,
		/obj/item/attachable/vulture_scope,
		/obj/item/attachable/bipod/vulture,
		/obj/item/attachable/stock/vulture,
	)
	starting_attachment_types = list(
		/obj/item/attachable/sniperbarrel/vulture,
		/obj/item/attachable/vulture_scope,
		/obj/item/attachable/bipod/vulture,
		/obj/item/attachable/stock/vulture,
	)
	civilian_usable_override = FALSE
	projectile_type = /obj/projectile/vulture
	actions_types = list(
		/datum/action/item_action/vulture,
	)
	has_openbolt_icon = FALSE
	bolt_delay = 1 SECONDS
	/// How far out people can tell the direction of the shot
	var/fire_message_range = 25
	/// If the gun should bypass the trait requirement
	var/bypass_trait = FALSE

/obj/item/weapon/gun/boltaction/vulture/update_icon()
	..()
	var/new_icon_state = src::icon_state
	if(!current_mag)
		new_icon_state += "_e"

	icon_state = new_icon_state

	if(!bolted)
		overlays += "vulture_bolt_open"


/obj/item/weapon/gun/boltaction/vulture/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_VULTURE)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4
	recoil_unwielded = RECOIL_AMOUNT_TIER_2
	damage_falloff_mult = 0

/obj/item/weapon/gun/boltaction/vulture/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 19, "rail_x" = 11, "rail_y" = 24, "under_x" = 25, "under_y" = 14, "stock_x" = 11, "stock_y" = 15)

/obj/item/weapon/gun/boltaction/vulture/able_to_fire(mob/user)
	if(!bypass_trait && !HAS_TRAIT(user, TRAIT_VULTURE_USER))
		to_chat(user, SPAN_WARNING("你不知道如何使用它！"))
		return FALSE

	return ..()

/obj/item/weapon/gun/boltaction/vulture/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	var/obj/item/attachable/vulture_scope/scope = attachments["rail"]
	if(istype(scope) && scope.scoping)
		var/turf/viewed_turf = scope.get_viewed_turf()
		target = viewed_turf
		var/mob/living/living_mob = locate(/mob/living) in viewed_turf
		if(living_mob)
			target = living_mob

	. = ..()
	if(!.)
		return .

	for(var/mob/current_mob as anything in get_mobs_in_z_level_range(get_turf(user), fire_message_range) - user)
		var/relative_dir = Get_Compass_Dir(current_mob, user)
		var/final_dir = dir2text(relative_dir)
		to_chat(current_mob, SPAN_HIGHDANGER("你听到[final_dir ? "[localized_player_label(final_dir)]方" : "附近"]传来一声巨响！"))
		if(current_mob.client)
			playsound_client(current_mob.client, 'sound/weapons/gun_vulture_report.ogg', src, 25)

	if(!HAS_TRAIT(src, TRAIT_GUN_BIPODDED))
		fired_without_bipod(user)
	else
		shake_camera(user, 3, 4) // equivalent to getting hit with a heavy round

	return .

/// Someone tried to fire this without using a bipod, so we break their arm along with sending them flying backwards
/obj/item/weapon/gun/boltaction/vulture/proc/fired_without_bipod(mob/living/user)
	SEND_SIGNAL(src, COMSIG_GUN_VULTURE_FIRED_ONEHAND)
	to_chat(user, SPAN_HIGHDANGER("发射[src]时，你被猛烈的后坐力抛向后方，开枪的手臂也被折断了！"))
	user.apply_effect(0.7, WEAKEN)
	user.apply_effect(1, SUPERSLOW)
	user.apply_effect(2, SLOW)

	if(ishuman(user))
		if(user.hand)
			break_arm(user, RIGHT)
		else
			break_arm(user, LEFT)

	//Either knockback or slam them into an obstacle.
	var/direction = REVERSE_DIR(user.dir)
	if(direction && !step(user, direction))
		user.animation_attack_on(get_step(user, direction))
		user.visible_message(SPAN_DANGER("[user]撞上了障碍物！"), SPAN_HIGHDANGER("你撞上了障碍物！"), null, 4, CHAT_TYPE_TAKING_HIT)
		user.apply_damage(MELEE_FORCE_TIER_2)

	shake_camera(user, 7, 6) // Around 2x worse than getting hit with a heavy round

/// The code that takes care of breaking a person's firing arm
/obj/item/weapon/gun/boltaction/vulture/proc/break_arm(mob/living/carbon/human/user, arm = LEFT)
	var/obj/limb/arm/found_limb
	var/obj/limb/hand/found_hand
	if(arm == LEFT)
		found_limb = locate(/obj/limb/arm/l_arm) in user.limbs
		found_hand = locate(/obj/limb/hand/l_hand) in user.limbs
	else
		found_limb = locate(/obj/limb/arm/r_arm) in user.limbs
		found_hand = locate(/obj/limb/hand/r_hand) in user.limbs

	if(!found_limb || !found_hand)
		return
	found_limb.take_damage((found_limb.status & LIMB_BROKEN) ? rand(25, 30) : rand(10, 15))
	found_hand.take_damage((found_hand.status & LIMB_BROKEN) ? rand(25, 30) : rand(10, 15))
	found_limb.fracture(100)
	found_hand.fracture(100)

	for(var/obj/limb/limb as anything in list(found_limb, found_hand))
		if(!(limb.status & LIMB_SPLINTED_INDESTRUCTIBLE) && (limb.status & LIMB_SPLINTED)) //If they have it splinted, the splint won't hold.
			limb.status &= ~LIMB_SPLINTED
			playsound(user, 'sound/items/splintbreaks.ogg', 20)
			to_chat(user, SPAN_DANGER("你[localized_player_label(limb.display_name)]上的夹板被后坐力震散了！"))
			user.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)
			user.update_med_icon()


/obj/item/weapon/gun/boltaction/vulture/skillless
	bypass_trait = TRUE

/obj/item/weapon/gun/boltaction/vulture/holo_target
	current_mag = /obj/item/ammo_magazine/rifle/boltaction/vulture/holo_target

/obj/item/weapon/gun/boltaction/vulture/holo_target/skillless
	bypass_trait = TRUE
