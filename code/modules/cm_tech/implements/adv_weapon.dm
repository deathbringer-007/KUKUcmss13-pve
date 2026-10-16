
/obj/item/techtree_advanced_weapon_kit
	name = "先进武器套装"
	desc = "看起来是供你选择先进武器的套装。"

	icon = 'icons/obj/items/items.dmi'
	icon_state = "wrench"

	var/gun_type = /obj/item/weapon/gun/shotgun/pump
	var/ammo_type = /obj/item/ammo_magazine/shotgun/buckshot
	var/ammo_type_count = 3


/obj/item/techtree_advanced_weapon_kit/attack_self(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user

	new gun_type(get_turf(H))
	for (var/i in 1 to ammo_type_count)
		new ammo_type(get_turf(H))

	qdel(src)

/obj/item/techtree_advanced_weapon_kit/railgun
	name = "先进武器套装"
	desc = "看起来是供你选择先进武器的套装。"

	icon = 'icons/obj/items/items.dmi'
	icon_state = "wrench"

	gun_type = /obj/item/weapon/gun/rifle/techweb_railgun
	ammo_type = /obj/item/ammo_magazine/techweb_railgun
	ammo_type_count = 5


/obj/item/weapon/gun/rifle/techweb_railgun
	name = "\improper 轨道枪"
	desc = "一把酷毙了的地狱湮灭器。"
	icon_state = "m42a"
	item_state = "m42a"
	unacidable = TRUE
	indestructible = 1

	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/techweb_railgun
	force = 12
	wield_delay = WIELD_DELAY_HORRIBLE //Ends up being 1.6 seconds due to scope
	zoomdevicename = "瞄准镜"
	attachable_allowed = list()
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY
	map_specific_decoration = TRUE
	actions_types = list(/datum/action/item_action/techweb_railgun_start_charge, /datum/action/item_action/techweb_railgun_abort_charge)

	// Hellpullverizer ready or not??
	var/charged = FALSE

/obj/item/weapon/gun/rifle/techweb_railgun/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/rifle/techweb_railgun/able_to_fire()
	return charged

/obj/item/weapon/gun/rifle/techweb_railgun/proc/start_charging(user)
	if (charged)
		to_chat(user, SPAN_WARNING("你的轨道枪已经充能完毕。"))
		return

	to_chat(user, SPAN_WARNING("你开始为轨道枪充能。"))
	if (!do_after(user, 8 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_WARNING("你停止为轨道枪充能。"))
		return

	to_chat(user, SPAN_WARNING("你完成了轨道枪的充能。"))

	charged = TRUE
	return

/obj/item/weapon/gun/rifle/techweb_railgun/on_enter_storage()
	if (charged)
		abort_charge()
	. = ..()

/obj/item/weapon/gun/rifle/techweb_railgun/proc/abort_charge(user)
	if (!charged)
		return
	charged = FALSE
	if (user)
		to_chat(user, SPAN_WARNING("你释放了轨道枪的储能，以便收起它。"))
	return

/obj/item/weapon/gun/rifle/techweb_railgun/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/S = new(src)
	S.hidden = TRUE
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/rifle/techweb_railgun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6*5)
	set_burst_amount(BURST_AMOUNT_TIER_1)
	accuracy_mult = BASE_ACCURACY_MULT * 3 //you HAVE to be able to hit
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5

/obj/item/weapon/gun/rifle/techweb_railgun/unique_action(mob/user)
	if (in_chamber)
		to_chat(user, SPAN_WARNING("枪膛内已经有一发弹药了！"))
		return

	var/result = load_into_chamber()
	if (result)
		to_chat(user, SPAN_WARNING("你拉动[src]的枪栓，将一发弹药送入枪膛！"))
	else
		to_chat(user, SPAN_WARNING("你拉动[src]的枪栓，但已经没有弹药了！"))

// normally, ready_in_chamber gets called by this proc. However, it never gets called because we override.
// so we don't need to override ready_in_chamber, which is what makes the bullet and puts it in the chamber var.
/obj/item/weapon/gun/rifle/techweb_railgun/reload_into_chamber(mob/user)
	charged = FALSE
	in_chamber = null // blackpilled again
	return null

/datum/action/item_action/techweb_railgun_start_charge
	name = "开始充能"

/datum/action/item_action/techweb_railgun_start_charge/action_activate()
	. = ..()
	if (target)
		var/obj/item/weapon/gun/rifle/techweb_railgun/TR = target
		TR.start_charging(owner)

/datum/action/item_action/techweb_railgun_abort_charge
	name = "中止充能"

/datum/action/item_action/techweb_railgun_abort_charge/action_activate()
	. = ..()
	if (target)
		var/obj/item/weapon/gun/rifle/techweb_railgun/TR = target
		TR.abort_charge(owner)

/obj/item/ammo_magazine/techweb_railgun
	name = "\improper 轨道枪弹药（5发）"
	desc = "酷炫轨道枪使用的弹匣。"
	caliber = "14mm"
	icon_state = "m42c" //PLACEHOLDER
	w_class = SIZE_MEDIUM
	max_rounds = 5
	default_ammo = /datum/ammo/bullet/sniper/railgun
	gun_type = /obj/item/weapon/gun/rifle/techweb_railgun

/datum/ammo/bullet/sniper/railgun
	name = "轨道枪弹丸"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER
	accurate_range_min = 4

	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 32
	max_range = 32
	scatter = 0
	damage = 3*100
	penetration= ARMOR_PENETRATION_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	damage_falloff = 0

/datum/ammo/bullet/sniper/railgun/on_hit_mob(mob/M, _unused)
	if (isxeno(M))
		M.apply_effect(1, SLOW)
