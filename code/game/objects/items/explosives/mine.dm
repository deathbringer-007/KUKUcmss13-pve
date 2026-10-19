///***MINES***///
//Mines have an invisible "tripwire" atom that explodes when crossed
//Stepping directly on the mine will also blow it up
/obj/item/explosive/mine
	name = "M20 阔剑反步兵地雷"
	desc = "M20 阔剑是 USCMC 的定向反步兵智能地雷。当有效目标从其前方或上方经过时，会喷出 120 度锥形弹片。正面写着“此面向敌”。"
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "m20"
	force = 5
	w_class = SIZE_SMALL
	// whoever commented that they wanted to prevent claymores from being hidden was a dork (derogatory).
	throwforce = 5
	throw_range = 6
	throw_speed = SPEED_VERY_FAST
	// claymores are now acidable.
	flags_atom = FPRINT|CONDUCT
	allowed_sensors = list(/obj/item/device/assembly/prox_sensor)
	max_container_volume = 120
	reaction_limits = list( "max_ex_power" = 105, "base_ex_falloff" = 60, "max_ex_shards" = 32,
							"max_fire_rad" = 5, "max_fire_int" = 12, "max_fire_dur" = 18,
							"min_fire_rad" = 2, "min_fire_int" = 3, "min_fire_dur" = 3
	)
	angle = 60
	use_dir = TRUE
	var/shrapnel_count = 40
	var/shrapnel_type = /datum/ammo/bullet/shrapnel/claymore
	var/explosive_power = 60
	var/explosive_falloff = 25
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR
	var/iff_signal = FACTION_MARINE
	var/triggered = FALSE
	var/hard_iff_lock = FALSE
	var/obj/effect/mine_tripwire/tripwire

	var/map_deployed = FALSE

/obj/item/explosive/mine/Initialize()
	. = ..()
	if(map_deployed)
		deploy_mine(null)

/obj/item/explosive/mine/Destroy()
	QDEL_NULL(tripwire)
	. = ..()

/obj/item/explosive/mine/ex_act()
	prime() //We don't care about how strong the explosion was.

/obj/item/explosive/mine/emp_act()
	. = ..()
	prime() //Same here. Don't care about the effect strength.

//checks for things that would prevent us from placing the mine.
/obj/item/explosive/mine/proc/check_for_obstacles(mob/living/user)
	if(locate(/obj/item/explosive/mine) in get_turf(src))
		to_chat(user, SPAN_WARNING("这里已经有一枚地雷！"))
		return TRUE
	if(user.loc && (user.loc.density || locate(/obj/structure/fence) in user.loc))
		to_chat(user, SPAN_WARNING("你无法在这里布雷。"))
		return TRUE
	if(SSinterior.in_interior(user))
		to_chat(user, SPAN_WARNING("这里太拥挤，无法部署[src]。"))
		return TRUE

//Arming
/obj/item/explosive/mine/attack_self(mob/living/user)
	if(!..())
		return

	if(check_for_obstacles(user))
		return

	if(active || user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user]开始部署[src]。"),
		SPAN_NOTICE("你开始部署[src]。"))
	if(!do_after(user, 40, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		user.visible_message(SPAN_NOTICE("[user]停止部署[src]。"), \
			SPAN_NOTICE("你停止部署[src]。"))
		return

	if(active)
		return

	if(check_for_obstacles(user))
		return

	user.visible_message(SPAN_NOTICE("[user]完成了[src]的部署。"), \
		SPAN_NOTICE("你完成了[src]的部署。"))

	deploy_mine(user)

/obj/item/explosive/mine/proc/deploy_mine(mob/user)
	if(!hard_iff_lock && user)
		iff_signal = user.faction

	cause_data = create_cause_data(initial(name), user)
	anchored = TRUE
	playsound(loc, 'sound/weapons/mine_armed.ogg', 25, 1)
	if(user)
		user.drop_inv_item_on_ground(src)
	setDir(user ? user.dir : dir) //The direction it is planted in is the direction the user faces at that time
	activate_sensors()
	update_icon()

//Disarming
/obj/item/explosive/mine/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
		if(active)
			if(user.action_busy)
				return
			if(user.faction == iff_signal)
				user.visible_message(SPAN_NOTICE("[user]开始拆除[src]。"), \
				SPAN_NOTICE("你开始拆除[src]。"))
			else
				user.visible_message(SPAN_NOTICE("[user]开始摆弄[src]，试图将其拆除。"), \
				SPAN_NOTICE("你开始拆除[src]，但你不知道它的敌我识别数据。这可能会出事……"))
			if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
				user.visible_message(SPAN_WARNING("[user]停止拆除[src]。"), \
					SPAN_WARNING("你停止拆除[src]。"))
				return
			if(user.faction != iff_signal) //ow!
				if(prob(5))
					triggered = TRUE
					if(tripwire)
						var/direction = GLOB.reverse_dir[src.dir]
						var/step_direction = get_step(src, direction)
						tripwire.forceMove(step_direction)
					prime()
			if(!active)//someone beat us to it
				return
			user.visible_message(SPAN_NOTICE("[user]完成了[src]的拆除。"), \
			SPAN_NOTICE("你完成了[src]的拆除。"))
			disarm()

	else
		return ..()

/obj/item/explosive/mine/proc/disarm()
	if(customizable)
		activate_sensors()
	anchored = FALSE
	active = FALSE
	triggered = FALSE
	update_icon()
	QDEL_NULL(tripwire)

/obj/item/explosive/mine/activate_sensors()
	if(active)
		return

	if(!customizable)
		set_tripwire()
		return;

	if(!detonator)
		active = TRUE
		return

	if(customizable && assembly_stage == ASSEMBLY_LOCKED)
		if(isigniter(detonator.a_right) && isigniter(detonator.a_left))
			set_tripwire()
			use_dir = TRUE
			return
		else
			..()
			// that's stupid. also prevents people from triggering it manually which is cool.
			//use_dir = FALSE // Claymore defaults to radial in these case. Poor man C4
			triggered = TRUE // Delegating the tripwire/crossed function to the sensor.


/obj/item/explosive/mine/proc/set_tripwire()
	if(!active && !tripwire)
		var/tripwire_loc = get_turf(get_step(loc, dir))
		tripwire = new(tripwire_loc)
		tripwire.linked_claymore = src
		active = TRUE


//Mine can also be triggered if you "cross right in front of it" (same tile)
/obj/item/explosive/mine/Crossed(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat == DEAD)//so dragged corpses don't trigger mines.
			return
		else
			try_to_prime(A)

/obj/item/explosive/mine/Collided(atom/movable/AM)
	try_to_prime(AM)


/obj/item/explosive/mine/proc/try_to_prime(mob/living/L)
	if(!active || triggered || (customizable && !detonator))
		return
	if(!istype(L))
		return
	if(L.stat == DEAD)
		return
	if(L.get_target_lock(iff_signal))
		return
	if(HAS_TRAIT(L, TRAIT_ABILITY_BURROWED))
		return
	L.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))][L]走到[name]前方时，它发出一声咔嗒。"), \
	SPAN_DANGER("[icon2html(src, L)]你走到[name]前方时，它发出一声咔嗒。"), \
	SPAN_DANGER("你听到一声咔嗒。"))

	triggered = TRUE
	playsound(loc, 'sound/weapons/mine_tripped.ogg', 25, 1)
	prime()



//Note : May not be actual explosion depending on linked method
/obj/item/explosive/mine/prime()
	set waitfor = 0

	if(!customizable)
		create_shrapnel(loc, shrapnel_count, dir, angle, shrapnel_type, cause_data)
		// a claymore is essentially a block of C4 with metal in the front. Shit's fuckin nasty.
		cell_explosion(loc, explosive_power, explosive_falloff, falloff_mode, dir, cause_data)
		qdel(src)
	else
		. = ..()
		if(!QDELETED(src))
			disarm()


/obj/item/explosive/mine/attack_alien(mob/living/carbon/xenomorph/M)
	if(triggered) //Mine is already set to go off
		return XENO_NO_DELAY_ACTION

	if(M.a_intent == INTENT_HELP)
		to_chat(M, SPAN_XENONOTICE("如果用力击打它，很可能会爆炸。"))
		return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	M.visible_message(SPAN_DANGER("[M]劈砍了[src]！"), \
		SPAN_DANGER("你劈砍了[src]！"))
	playsound(loc, 'sound/weapons/slice.ogg', 25, 1)

	//We move the tripwire randomly in either of the four cardinal directions
	triggered = TRUE
	if(tripwire)
		var/direction = pick(GLOB.cardinals)
		var/step_direction = get_step(src, direction)
		tripwire.forceMove(step_direction)
	prime()
	if(!QDELETED(src))
		disarm()
	return XENO_ATTACK_ACTION

/obj/item/explosive/mine/flamer_fire_act(damage, flame_cause_data) //adding mine explosions
	cause_data = flame_cause_data
	prime()
	if(!QDELETED(src))
		disarm()


/obj/effect/mine_tripwire
	name = "阔剑地雷绊线"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/item/explosive/mine/linked_claymore

/obj/effect/mine_tripwire/Destroy()
	if(linked_claymore)
		if(linked_claymore.tripwire == src)
			linked_claymore.tripwire = null
		linked_claymore = null
	. = ..()

//immune to explosions.
/obj/effect/mine_tripwire/ex_act(severity)
	return

/obj/effect/mine_tripwire/Crossed(atom/movable/AM)
	if(!linked_claymore)
		qdel(src)
		return

	if(linked_claymore.triggered) //Mine is already set to go off
		return

	if(linked_claymore)
		linked_claymore.try_to_prime(AM)

/obj/item/explosive/mine/active
	icon_state = "m20_active"
	base_icon_state = "m20"
	map_deployed = TRUE

/obj/item/explosive/mine/no_iff
	iff_signal = null

/obj/item/explosive/mine/active/no_iff
	iff_signal = null

//Player-given claymore. More lethal than the other sort.
/obj/item/explosive/mine/strong
	name = "M20A2 阔剑反步兵地雷"
	shrapnel_type = /datum/ammo/bullet/shrapnel/claymore/strong
	explosive_power = 90
	explosive_falloff = 35

//ditto, but armed.
/obj/item/explosive/mine/strong/active
	icon_state = "m20_active"
	base_icon_state = "m20"
	map_deployed = TRUE

/obj/item/explosive/mine/pmc
	name = "\improper M20P 阔剑反步兵地雷"
	desc = "为公司私人军事部队改装的 M20P 阔剑定向反步兵智能地雷。有效目标从前方经过或踩上它时，会向前方 120 度扇形区域喷射破片。正面写着“此面向敌”。"
	icon_state = "m20p"
	iff_signal = FACTION_PMC
	hard_iff_lock = TRUE
	shrapnel_count = 50

/obj/item/explosive/mine/pmc/active
	icon_state = "m20p_active"
	base_icon_state = "m20p"
	map_deployed = TRUE

/obj/item/explosive/mine/pmc/strong
	name = "\improper M20A2P 阔剑反步兵地雷"
	shrapnel_count = 60
	shrapnel_type = /datum/ammo/bullet/shrapnel/claymore/strong
	explosive_power = 90
	explosive_falloff = 35

/obj/item/explosive/mine/custom
	name = "自制地雷"
	desc = "用 M20 外壳组装的自制化学地雷。"
	icon_state = "m20_custom"
	customizable = TRUE
	matter = list("metal" = 3750)
	has_blast_wave_dampener = TRUE

/obj/item/explosive/mine/sharp
	name = "\improper P9 SHARP 爆炸飞镖"
	desc = "阿玛特系统公司为美国殖民地陆战队设计的实验型 P9 SHARP 近炸飞镖，具有 360 度全向探测能力。"
	icon_state = "sonicharpoon_g"
	angle = 360
	var/disarmed = FALSE
	var/explosion_size = 200
	var/explosion_falloff = 100

/obj/item/explosive/mine/sharp/check_for_obstacles(mob/living/user)
	return FALSE

/obj/item/explosive/mine/sharp/attackby(obj/item/W, mob/user)
	return

/obj/item/explosive/mine/sharp/set_tripwire()
	if(!active && !tripwire)
		for(var/direction in CARDINAL_ALL_DIRS)
			var/tripwire_loc = get_turf(get_step(loc,direction))
			tripwire = new(tripwire_loc)
			tripwire.linked_claymore = src
			active = TRUE

/obj/item/explosive/mine/sharp/prime(mob/user)
	set waitfor = 0
	if(!cause_data)
		cause_data = create_cause_data(initial(name), user)
	cell_explosion(loc, explosion_size, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, CARDINAL_ALL_DIRS, cause_data)
	playsound(loc, 'sound/weapons/gun_sharp_explode.ogg', 45)
	qdel(src)

/obj/item/explosive/mine/sharp/disarm()
	anchored = FALSE
	active = FALSE
	triggered = FALSE
	icon_state = base_icon_state + "_disarmed"
	QDEL_NULL(tripwire)
	disarmed = TRUE
	add_to_garbage(src)

/obj/item/explosive/mine/sharp/attack_self(mob/living/user)
	if(disarmed)
		return
	. = ..()

/obj/item/explosive/mine/sharp/deploy_mine(mob/user)
	if(disarmed)
		return
	if(!hard_iff_lock && user)
		iff_signal = user.faction

	cause_data = create_cause_data(initial(name), user)
	if(user)
		user.drop_inv_item_on_ground(src)
	setDir(user ? user.dir : dir) //The direction it is planted in is the direction the user faces at that time
	activate_sensors()
	update_icon()
	for(var/mob/living/carbon/mob in range(1, src))
		src.try_to_prime(mob)

/obj/item/explosive/mine/sharp/attack_alien()
	if(disarmed)
		..()
	else
		return
/obj/item/explosive/mine/sebb
	name = "\improper G2 电击手榴弹"
	icon_state = "grenade_sebb_planted"
	desc = "作为地雷埋设的 G2 电击手榴弹。"
	pixel_y = -5
	anchored = TRUE // this is supposed to be planeted already when spawned

/obj/item/explosive/mine/sebb/disarm()
	. = ..()
	new /obj/item/explosive/grenade/sebb(get_turf(src))
	qdel(src)

/obj/item/explosive/mine/sebb/prime()
	new /obj/item/explosive/grenade/sebb/primed(get_turf(src))
	qdel(src)

/obj/item/explosive/mine/sebb/active
	icon_state = "grenade_sebb_planted_active"
	base_icon_state = "grenade_sebb"
	map_deployed = TRUE
