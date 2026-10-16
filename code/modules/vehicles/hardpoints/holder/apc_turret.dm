/obj/item/hardpoint/holder/apc_turret
	name = "\improper ZSL-68炮塔"
	desc = "这是ZSL-68的BM-7/U.E.M炮塔。U.E.M即“通用装备模块”，由乌克兰与中国联合研发，不过大部分实际研发工作在乌克兰完成。这是一套遥控、高度模块化的系统，可搭载多种武器组合。"
	icon = 'icons/obj/vehicles/uppapc.dmi'
	icon_state = "apc_turret_0"
	disp_icon = "uppapc"
	disp_icon_state = "apc_turret"
	activation_sounds = list('sound/weapons/vehicles/smokelauncher_fire.ogg')
	pixel_x = -65
	pixel_y = -65

	density = TRUE //come on, it's huge

	activatable = TRUE

	ammo = new /obj/item/ammo_magazine/hardpoint/turret_smoke/uppapc
	max_clips = 5
	use_muzzle_flash = FALSE

	w_class = SIZE_MASSIVE
	density = TRUE
	anchored = TRUE

	allowed_seat = VEHICLE_DRIVER

	slot = HDPT_TURRET

	// big beefy chonk of metal
	health = 1500
	damage_multiplier = 0.05

	accepted_hardpoints = list(
		// primaries
		/obj/item/hardpoint/primary/gshk_minigun,
		// secondaries
		/obj/item/hardpoint/secondary/hj35launcher,
	)

	hdpt_layer = HDPT_LAYER_TURRET
	px_offsets = list(
		"1" = list(0, 10),
		"2" = list(0, 10),
		"4" = list(-0, 27),
		"8" = list(-0, 27)
	)

	var/gyro = FALSE

	// How long the windup is before the turret rotates
	var/rotation_windup = 5
	// Used during the windup
	var/rotating = FALSE

	scatter = 2
	gun_firemode = GUN_FIREMODE_BURSTFIRE
	gun_firemode_list = list(
		GUN_FIREMODE_BURSTFIRE,
	)
	burst_amount = 2
	burst_delay = 1.0 SECONDS
	extra_delay = 5.0 SECONDS

/obj/item/hardpoint/holder/apc_turret/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/holder/apc_turret/update_icon()
	var/broken = (health <= 0)
	icon_state = "apc_turret_[broken]"

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_turret")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		overlays += damage_overlay

	..()

/obj/item/hardpoint/holder/apc_turret/get_icon_image(x_offset, y_offset, new_dir)
	var/icon_state_suffix = "0"
	if(health <= 0)
		icon_state_suffix = "1"

	var/image/I = image(icon = disp_icon, icon_state = "[disp_icon_state]_[icon_state_suffix]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_turret")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		I.overlays += damage_overlay

	return I

// no picking this big beast up

/obj/item/hardpoint/holder/apc_turret/attack_hand(mob/user)
	return

/obj/item/hardpoint/holder/apc_turret/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(!PC.linked_powerloader)
			qdel(PC)
			return TRUE

		if(health < 1)
			visible_message(SPAN_WARNING("[src]因损坏过重而散成了一堆废料！"))
			qdel(src)
			return TRUE

		PC.grab_object(user, src, "vehicle_module", 'sound/machines/hydraulics_2.ogg')
		update_icon()
		return TRUE
	..()

/obj/item/hardpoint/holder/apc_turret/get_tgui_info()
	var/list/data = list()

	data += list(list( // turret smokescreen data
		"name" = "ZSL炮塔烟幕系统",
		"health" = health <= 0 ? null : floor(get_integrity_percent()),
		"uses_ammo" = TRUE,
		"current_rounds" = ammo.current_rounds / 2,
		"max_rounds"= ammo.max_rounds / 2,
		"mags" = LAZYLEN(backup_clips),
		"max_mags" = max_clips,
	))

	for(var/obj/item/hardpoint/H in hardpoints)
		data += list(H.get_tgui_info())

	return data

//gyro ON locks the turret in one direction, OFF will make turret turning when tank turns
/obj/item/hardpoint/holder/apc_turret/proc/toggle_gyro(mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("[src]的稳定系统已损坏！"))
		return

	gyro = !gyro
	to_chat(user, SPAN_NOTICE("你将[src]的陀螺稳定器[gyro ? "开启" :"关闭"]。"))

/obj/item/hardpoint/holder/apc_turret/proc/user_rotation(mob/user, deg)
	// no rotating a broken turret
	if(health <= 0)
		return

	if(rotating)
		return

	rotating = TRUE
	to_chat(user, SPAN_NOTICE("你开始将炮塔转向[list("north" = "北", "south" = "南", "east" = "东", "west" = "西", "northeast" = "东北", "southeast" = "东南", "northwest" = "西北", "southwest" = "西南")[dir2text(turn(dir,deg))]]方。"))

	if(!do_after(user, rotation_windup, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		rotating = FALSE
		return
	rotating = FALSE

	rotate(deg, TRUE)

/obj/item/hardpoint/holder/apc_turret/rotate(deg, override_gyro = FALSE)
	if(gyro && !override_gyro)
		return

	..(deg)

/obj/item/hardpoint/holder/apc_turret/try_fire(atom/target, mob/living/user, params)
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
