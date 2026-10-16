//this is Cupola guns that are fired from the sides of APC by support gunners
/obj/item/hardpoint/special/firing_port_weapon
	name = "\improper M56射孔武器"
	desc = "安装在M577装甲运兵车两侧的改装M56B智能机枪，作为射孔武器，由支援炮手用来掩护车辆两侧的友军步兵。"

	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'
	icon_state = "m56_FPW"
	disp_icon = "apc"
	disp_icon_state = ""
	activation_sounds = list('sound/weapons/gun_smartgun1.ogg', 'sound/weapons/gun_smartgun2.ogg', 'sound/weapons/gun_smartgun3.ogg', 'sound/weapons/gun_smartgun4.ogg')

	health = 100
	firing_arc = 120
	//FPWs reload automatically
	var/reloading = FALSE
	var/reload_time = 10 SECONDS
	var/reload_time_started = 0

	use_muzzle_flash = TRUE

	allowed_seat = VEHICLE_SUPPORT_GUNNER_ONE

	ammo = new /obj/item/ammo_magazine/hardpoint/firing_port_weapon
	max_clips = 1

	underlayer_north_muzzleflash = TRUE

	scatter = 3
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.3 SECONDS

/obj/item/hardpoint/special/firing_port_weapon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))


//for le tgui
/obj/item/hardpoint/special/firing_port_weapon/get_tgui_info()
	var/list/data = list()

	data["name"] = name
	data["uses_ammo"] = TRUE
	data["current_rounds"] = ammo.current_rounds
	data["max_rounds"] = ammo.max_rounds
	data["fpw"] = TRUE

	return data

/obj/item/hardpoint/special/firing_port_weapon/reload(mob/user)
	if(!ammo)
		ammo = new /obj/item/ammo_magazine/hardpoint/firing_port_weapon
	else
		ammo.current_rounds = ammo.max_rounds
	reloading = FALSE

	playsound(owner, 'sound/items/m56dauto_setup.ogg', 50, TRUE)

	if(user && owner.get_mob_seat(user))
		to_chat(user, SPAN_WARNING("[name]自动装填完毕。弹药：<b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b>"))

/obj/item/hardpoint/special/firing_port_weapon/proc/start_auto_reload(mob/user)
	if(reloading)
		to_chat(user, SPAN_WARNING("[name]正在装填，请等待[SPAN_HELPFUL("[((reload_time_started + reload_time - world.time) / 10)]")]秒。"))
		return
	if(user)
		to_chat(user, SPAN_WARNING("[name]弹药耗尽！请等待[reload_time / 10]秒，直至自动装填完成。"))
	reloading = TRUE
	reload_time_started = world.time
	addtimer(CALLBACK(src, PROC_REF(reload), user), reload_time)

//try adding magazine to hardpoint's backup clips. Called via weapons loader
/obj/item/hardpoint/special/firing_port_weapon/try_add_clip(obj/item/ammo_magazine/A, mob/user)
	to_chat(user, SPAN_NOTICE("[name]会自动装填。"))
	return FALSE

/obj/item/hardpoint/special/firing_port_weapon/try_fire(atom/target, mob/living/user, params)
	if(!owner)
		return NONE

	//FPW stop working at 50% hull
	if(owner.health < initial(owner.health) * 0.5)
		to_chat(user, SPAN_WARNING("<b>[owner]的车体损坏过于严重！</b>"))
		return NONE

	if(user.get_active_hand())
		to_chat(user, SPAN_WARNING("你需要腾出一只手才能使用[name]。"))
		return NONE

	if(reloading)
		to_chat(user, SPAN_NOTICE("[name]正在装填，请等待[SPAN_HELPFUL("[((reload_time_started + reload_time - world.time) / 10)]")]秒。"))
		return NONE

	if(ammo && ammo.current_rounds <= 0)
		if(reloading)
			to_chat(user, SPAN_WARNING("<b>[name]弹药耗尽！还需等待[(reload_time_started + reload_time - world.time) / 10]秒才能完成装填！"))
		else
			start_auto_reload(user)
		return NONE

	if(!in_firing_arc(target))
		to_chat(user, SPAN_WARNING("<b>目标不在射界内！</b>"))
		return NONE

	return handle_fire(target, user, params)
