
/obj/item/storage/box/czsp/first_aid
	name = "急救战区支援套装"
	desc = "内含升级型医疗包、纳米夹板和升级型除颤器。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "medicbox"
	storage_slots = 3

/obj/item/storage/box/czsp/first_aid/Initialize()
	. = ..()
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	if(prob(5))
		new /obj/item/device/healthanalyzer(src)

/obj/item/storage/box/czsp/medical
	name = "医疗战区支援套装"
	desc = "内含升级型医疗包、纳米夹板和升级型除颤器。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "medicbox"
	storage_slots = 4

/obj/item/storage/box/czsp/medical/Initialize()
	. = ..()
	new /obj/item/stack/medical/advanced/bruise_pack/upgraded(src)
	new /obj/item/stack/medical/advanced/ointment/upgraded(src)
	new /obj/item/stack/medical/splint/nano(src)
	new /obj/item/device/defibrillator/upgraded(src)

/obj/item/storage/box/czsp/medic_upgraded_kits
	name = "医疗升级套装"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "upgradedkitbox"
	desc = "内含用于处理重伤的升级型创伤治疗包和烧伤治疗包。"
	max_w_class = SIZE_MEDIUM
	storage_slots = 2

/obj/item/storage/box/czsp/medic_upgraded_kits/Initialize()
	. = ..()
	new /obj/item/stack/medical/advanced/bruise_pack/upgraded(src)
	new /obj/item/stack/medical/advanced/ointment/upgraded(src)

/obj/item/stack/medical/advanced/ointment/upgraded
	name = "升级型烧伤治疗包"
	singular_name = "升级型烧伤治疗包"
	stack_id = "upgraded burn kit"

	icon_state = "burnkit_upgraded"
	desc = "升级型烧伤治疗包，效果是制式型号的三倍，且无法补充。请节省使用，仅用于最严重的烧伤。"

	max_amount = 10
	amount = 10

/obj/item/stack/medical/advanced/ointment/upgraded/Initialize(mapload, ...)
	. = ..()
	heal_burn = initial(heal_burn) * 3 // 3x stronger

/obj/item/stack/medical/advanced/bruise_pack/upgraded
	name = "升级型创伤治疗包"
	singular_name = "升级型创伤治疗包"
	stack_id = "upgraded trauma kit"

	icon_state = "traumakit_upgraded"
	desc = "升级型创伤治疗包，效果是制式型号的三倍，且无法补充。请节省使用，仅用于最严重的创伤。"

	max_amount = 10
	amount = 10

/obj/item/stack/medical/advanced/bruise_pack/upgraded/Initialize(mapload, ...)
	. = ..()
	heal_brute = initial(heal_brute) * 3 // 3x stronger

/obj/item/stack/medical/splint/nano
	name = "纳米夹板"
	singular_name = "纳米夹板"

	icon_state = "nanosplint"
	desc = "先进技术让这些夹板在固定骨骼的同时保持柔韧并耐受损伤。数量有限，请节省使用，优先固定关键部位。"

	indestructible_splints = TRUE
	amount = 5
	max_amount = 5

	stack_id = "nano splint"

/obj/item/stack/medical/splint/nano/research
	desc = "先进技术让这些夹板在固定骨骼的同时保持柔韧并耐受损伤。它们由耐用的碳纤维制成，看起来价格不菲，最好节省使用。"

/obj/item/device/defibrillator/upgraded
	name = "升级型急救除颤器"
	icon_state = "adv_defib"
	desc = "先进的可充电除颤器，通过感应穿透护甲等金属物体施加电击。效率远高于标准型号，且不会损伤心脏。"

	blocked_by_suit = FALSE
	min_heart_damage_dealt = 0
	max_heart_damage_dealt = 0
	damage_heal_threshold = 35

/obj/item/ammo_magazine/internal/pillgun
	name = "pill tube"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	default_ammo = /datum/ammo/pill
	caliber = "pill"
	max_rounds = 1
	chamber_closed = FALSE

	var/list/pills

/obj/item/ammo_magazine/internal/pillgun/Initialize(mapload, spawn_empty)
	. = ..()
	current_rounds = LAZYLEN(pills)

/obj/item/ammo_magazine/internal/pillgun/Entered(Obj, OldLoc)
	. = ..()
	if(!istype(Obj, /obj/item/reagent_container/pill))
		return

	LAZYADD(pills, Obj)
	current_rounds = LAZYLEN(pills)

/obj/item/ammo_magazine/internal/pillgun/Exited(Obj, newloc)
	. = ..()
	if(!istype(Obj, /obj/item/reagent_container/pill))
		return

	LAZYREMOVE(pills, Obj)
	current_rounds = LAZYLEN(pills)

/obj/item/ammo_magazine/internal/pillgun/super
	max_rounds = 5

// upgraded version, currently no way of getting it
/obj/item/weapon/gun/pill/super
	name = "大型药丸枪"
	current_mag = /obj/item/ammo_magazine/internal/pillgun/super

/obj/item/weapon/gun/pill
	name = "药丸枪"
	desc = "以弹簧驱动、可装填药丸的步枪，用于远距离向患者输送药物。"
	icon = 'icons/obj/items/weapons/guns/legacy/old_cmguns.dmi'
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_SLOW
	throw_range = 10
	force = 4

	current_mag = /obj/item/ammo_magazine/internal/pillgun

	flags_gun_features = GUN_INTERNAL_MAG

	matter = list("metal" = 2000)

/obj/item/weapon/gun/pill/attackby(obj/item/I as obj, mob/user as mob)
	if(I.loc == current_mag)
		return

	if(!istype(I, /obj/item/reagent_container/pill))
		return

	if(current_mag.current_rounds >= current_mag.max_rounds)
		to_chat(user, SPAN_WARNING("[src]已经装满弹药了！"))
		return

	user.drop_inv_item_on_ground(I)
	I.forceMove(current_mag)

/obj/item/weapon/gun/pill/update_icon()
	. = ..()
	if(!current_mag || !current_mag.current_rounds)
		icon_state = base_gun_icon
	else
		icon_state = base_gun_icon + "_e"

/obj/item/weapon/gun/pill/unload(mob/user, reload_override, drop_override, loc_override)
	var/obj/item/ammo_magazine/internal/pillgun/internal_mag = current_mag

	if(!istype(internal_mag))
		return

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	var/obj/item/reagent_container/pill/pill_to_use = LAZYACCESS(internal_mag.pills, 1)

	if(!pill_to_use)
		return

	pill_to_use.forceMove(get_turf(H.loc))
	H.put_in_active_hand(pill_to_use)

/obj/item/weapon/gun/pill/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	if(!able_to_fire(user))
		return NONE

	if(!current_mag.current_rounds)
		click_empty(user)
		return NONE

	if(!istype(current_mag, /obj/item/ammo_magazine/internal/pillgun))
		return NONE

	var/obj/item/ammo_magazine/internal/pillgun/internal_mag = current_mag
	var/obj/item/reagent_container/pill/pill_to_use = LAZYACCESS(internal_mag.pills, 1)

	if(QDELETED(pill_to_use))
		click_empty(user)
		return NONE

	var/obj/projectile/pill/P = new /obj/projectile/pill(src, user, src)
	P.generate_bullet(GLOB.ammo_list[/datum/ammo/pill], 0, 0)

	pill_to_use.forceMove(P)
	P.source_pill = pill_to_use

	playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)

	P.fire_at(target, user, src)
	return AUTOFIRE_CONTINUE

/datum/ammo/pill
	name = "注射器"
	icon_state = "syringe"
	flags_ammo_behavior = AMMO_IGNORE_ARMOR|AMMO_ALWAYS_FF

	damage = 0

/datum/ammo/pill/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()

	if(!ishuman(M))
		return

	if(!istype(P, /obj/projectile/pill))
		return

	var/obj/projectile/pill/pill_projectile = P

	if(QDELETED(pill_projectile.source_pill))
		pill_projectile.source_pill = null
		return

	var/datum/reagents/pill_reagents = pill_projectile.source_pill.reagents

	pill_reagents.trans_to(M, pill_reagents.total_volume)

/obj/projectile/pill
	var/obj/item/reagent_container/pill/source_pill

/obj/projectile/pill/Destroy()
	. = ..()
	source_pill = null
