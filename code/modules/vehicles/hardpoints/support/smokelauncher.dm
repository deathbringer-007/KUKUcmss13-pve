/obj/item/hardpoint/support/smoke_launcher
	name = "\improper M-39P烟幕发射器"
	desc = "全地形车用支援模块，可发射M60燃烧烟幕弹，吓退想搭便车的家伙。"
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "slauncher"
	disp_icon = "apc"
	disp_icon_state = "slauncher"
	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	activatable = TRUE

	health = 1500
	firing_arc = 120

	allowed_seat = VEHICLE_DRIVER

	ammo = new /obj/item/ammo_magazine/hardpoint/turret_smoke/incen
	max_clips = 3

	use_muzzle_flash = FALSE

	fire_delay = 1.0 SECONDS

/obj/item/hardpoint/support/smoke_launcher/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/support/smoke_launcher/aev
	name = "\improper M-39Q烟幕发射器"
	desc = "装甲工程车用支援模块，可发射M60燃烧烟幕弹，吓退想搭便车的家伙。"
	icon = 'icons/obj/vehicles/hardpoints/tank.dmi'

	icon_state = "slauncher_0"
	disp_icon = "tank"

	firing_arc = 150
	ammo = new /obj/item/ammo_magazine/hardpoint/turret_smoke/incen/aev
	max_clips = 5

	scatter = 3
	gun_firemode = GUN_FIREMODE_BURSTFIRE
	gun_firemode_list = list(
		GUN_FIREMODE_BURSTFIRE,
	)
	burst_amount = 2
	burst_delay = 1.0 SECONDS

/obj/item/hardpoint/support/smoke_launcher/aev/try_fire(atom/target, mob/living/user, params)
	var/turf/L
	var/turf/R
	switch(owner.dir)
		if(NORTH)
			L = locate(owner.x - 2, owner.y + 4, owner.z)
			R = locate(owner.x + 2, owner.y + 4, owner.z)
		if(SOUTH)
			L = locate(owner.x + 2, owner.y - 4, owner.z)
			R = locate(owner.x - 2, owner.y - 4, owner.z)
		if(EAST)
			L = locate(owner.x + 4, owner.y + 2, owner.z)
			R = locate(owner.x + 4, owner.y - 2, owner.z)
		else
			L = locate(owner.x - 4, owner.y + 2, owner.z)
			R = locate(owner.x - 4, owner.y - 2, owner.z)

	if(shots_fired)
		target = R
	else
		target = L

	return ..()
