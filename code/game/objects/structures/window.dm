/obj/structure/window
	name = "窗户"
	desc = "玻璃窗，看起来又薄又脆，随便拿点什么敲几下就会碎。"
	icon = 'icons/turf/walls/windows.dmi'
	icon_state = "window"
	density = TRUE
	anchored = TRUE
	layer = WINDOW_LAYER
	flags_atom = ON_BORDER|FPRINT
	health = 15
	var/state = 2
	var/reinf = 0
	var/basestate = "window"
	var/shardtype = /obj/item/shard
	var/windowknock_cooldown = 0
	var/static_frame = 0 //True/false. If true, can't move the window
	var/junction = 0 //Because everything is terrible, I'm making this a window-level var
	var/not_damageable = 0
	var/not_deconstructable = 0
	var/legacy_full = FALSE //for old fulltile windows

	minimap_color = MINIMAP_FENCE

///fixes up layering on northern and southern windows, breaks fulltile windows, those shouldn't be used in the first place regardless.
/obj/structure/window/Initialize()
	. = ..()
	update_icon()

	if(shardtype)
		LAZYADD(debris, shardtype)

	if(reinf)
		LAZYADD(debris, /obj/item/stack/rods)

	if(is_full_window())
		LAZYADD(debris, shardtype)
		update_nearby_icons()

/obj/structure/window/Destroy(force)
	density = FALSE
	if(is_full_window())
		update_nearby_icons()
	. = ..()

/obj/structure/window/setDir(newdir)
	. = ..()
	update_icon()

/obj/structure/window/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_GLASS

/obj/structure/window/proc/set_constructed_window(start_dir)
	state = 0
	anchored = FALSE

	if(start_dir)
		setDir(start_dir)

	if(is_full_window())
		update_nearby_icons()

	update_icon()


/obj/structure/window/update_icon(loc, direction)
	if(QDELETED(src))
		return
	if(flags_atom & ON_BORDER)
		if(direction)
			setDir(direction)
		switch(dir)
			if(NORTH)
				layer = BELOW_TABLE_LAYER
			if(SOUTH)
				layer = ABOVE_MOB_LAYER
			else
				layer = initial(layer)
	else if(legacy_full)
		junction = 0
		if(anchored)
			var/turf/TU
			for(var/dirn in GLOB.cardinals)
				TU = get_step(src, dirn)
				var/obj/structure/window/W = locate() in TU
				if(W && W.anchored && W.density && W.legacy_full) //Only counts anchored, non-destroyed, legacy full-tile windows.
					junction |= dirn
		icon_state = "[basestate][junction]"
	..()

/obj/structure/window/Move()
	var/ini_dir = dir
	. = ..()
	setDir(ini_dir)


//create_debris creates debris like shards and rods. This also includes the window frame for explosions
//If an user is passed, it will create a "user smashes through the window" message. AM is the item that hits
//Please only fire this after a hit
/obj/structure/window/proc/healthcheck(make_hit_sound = 1, make_shatter_sound = 1, create_debris = 1, mob/user, atom/movable/AM)
	if(not_damageable)
		if(make_hit_sound) //We'll still make the noise for immersion's sake
			playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
		return
	if(health <= 0)
		if(user && istype(user))
			user.count_niche_stat(STATISTICS_NICHE_DESTRUCTION_WINDOWS, 1)
			SEND_SIGNAL(user, COMSIG_MOB_DESTROY_WINDOW, src)
			user.visible_message(SPAN_DANGER("[user][AM ? "用[AM]":""]砸穿了[src]！"))
			if(is_mainship_level(z))
				SSclues.create_print(get_turf(user), user, "这枚指纹上附着一小片玻璃。")
		if(make_shatter_sound)
			playsound(src, "windowshatter", 50, 1)
		shatter_window(create_debris)
	else
		if(make_hit_sound)
			playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)

/obj/structure/window/bullet_act(obj/projectile/Proj)
	//Tasers and the like should not damage windows.
	var/ammo_flags = Proj.ammo.flags_ammo_behavior | Proj.projectile_override_flags
	if(Proj.ammo.damage_type == HALLOSS || Proj.damage <= 0 || ammo_flags == AMMO_ENERGY)
		return 0

	if(!not_damageable) //Impossible to destroy
		health -= Proj.damage
	..()
	healthcheck(user = Proj.firer)
	return 1

/obj/structure/window/ex_act(severity, explosion_direction, datum/cause_data/cause_data)
	if(not_damageable) //Impossible to destroy
		return

	health -= severity * EXPLOSION_DAMAGE_MULTIPLIER_WINDOW

	var/mob/M = cause_data?.resolve_mob()
	if(health > 0)
		healthcheck(FALSE, TRUE, user = M)
		return

	if(health >= -2000)
		var/location = get_turf(src)
		playsound(src, "windowshatter", 50, 1)
		create_shrapnel(location, rand(1,5), explosion_direction, shrapnel_type = /datum/ammo/bullet/shrapnel/light/glass, cause_data = cause_data)

	if(M)
		M.count_niche_stat(STATISTICS_NICHE_DESTRUCTION_WINDOWS, 1)
		SEND_SIGNAL(M, COMSIG_MOB_WINDOW_EXPLODED, src)

	handle_debris(severity, explosion_direction)
	deconstruct(FALSE)
	return

/obj/structure/window/get_explosion_resistance(direction)
	if(not_damageable)
		return 1000000

	if(flags_atom & ON_BORDER)
		if( direction == turn(dir, 90) || direction == turn(dir, -90) )
			return 0

	return health/EXPLOSION_DAMAGE_MULTIPLIER_WINDOW

/obj/structure/window/hitby(atom/movable/AM)
	..()
	visible_message(SPAN_DANGER("[src]被[AM]击中了。"))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf) tforce *= 0.25
	if(!not_damageable) //Impossible to destroy
		health = max(0, health - tforce)
		if(health <= 7 && !reinf && !static_frame)
			anchored = FALSE
			update_nearby_icons()
			step(src, get_dir(AM, src))
	healthcheck(user = AM.launch_metadata.thrower)

/obj/structure/window/attack_hand(mob/user as mob)
	if(user.a_intent == INTENT_HARM && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_generic(H, 25)
			return

		if(windowknock_cooldown > world.time)
			return

		playsound(loc, 'sound/effects/glassbash.ogg', 25, 1)
		user.visible_message(SPAN_WARNING("[user]用力拍打[src]！"),
		SPAN_WARNING("你用力拍打[src]！"),
		SPAN_WARNING("你听见砰砰的拍打声。"))
		windowknock_cooldown = world.time + 100
	else
		if(windowknock_cooldown > world.time)
			return
		playsound(loc, 'sound/effects/glassknock.ogg', 15, 1)
		user.visible_message(SPAN_NOTICE("[user]敲了敲[src]。"),
		SPAN_NOTICE("你敲了敲[src]。"),
		SPAN_NOTICE("你听见敲击声。"))
		windowknock_cooldown = world.time + 100

//Used by attack_animal
/obj/structure/window/proc/attack_generic(mob/living/user, damage = 0)
	if(!not_damageable) //Impossible to destroy
		health -= damage
	user.animation_attack_on(src)
	user.visible_message(SPAN_DANGER("[user]猛击[src]！"))
	healthcheck(1, 1, 1, user)

/obj/structure/window/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	attack_generic(M, M.melee_damage_upper)

/obj/structure/window/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/grab) && get_dist(src, user) < 2)
		if(isxeno(user)) return
		var/obj/item/grab/G = W
		if(istype(G.grabbed_thing, /mob/living))
			var/mob/living/M = G.grabbed_thing
			var/state = user.grab_level
			user.drop_held_item()
			switch(state)
				if(GRAB_PASSIVE)
					M.visible_message(SPAN_WARNING("[user]把[M]撞向[src]！"))
					M.apply_damage(7)
					if(!not_damageable) //Impossible to destroy
						health -= 10
				if(GRAB_AGGRESSIVE)
					M.visible_message(SPAN_DANGER("[user]把[M]狠狠撞向[src]！"))
					if(prob(50))
						M.apply_effect(1, WEAKEN)
					M.apply_damage(10)
					if(!not_damageable) //Impossible to destroy
						health -= 25
				if(GRAB_CHOKE)
					M.visible_message(SPAN_DANGER("[user]把[M]重重砸向[src]！"))
					M.apply_effect(5, WEAKEN)
					M.apply_damage(20)
					if(!not_damageable) //Impossible to destroy
						health -= 50

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slammed against [src] by [key_name(user)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>slammed [key_name(M)] against [src]</font>")
			msg_admin_attack("[key_name(user)] slammed [key_name(M)] against [src] at [get_area_name(M)]", M.loc.x, M.loc.y, M.loc.z)

			healthcheck(1, 1, 1, M) //The person thrown into the window literally shattered it
		return

	if(W.flags_item & NOBLUDGEON) return

	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && !not_deconstructable)
		if(!anchored)
			var/turf/open/T = loc
			var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in T // for M2C HMG, look at smartgun_mount.dm
			if(!(istype(T) && T.allow_construction))
				to_chat(user, SPAN_WARNING("必须把[src]固定在合适的表面上！"))
				return
			if(AC)
				to_chat(usr, SPAN_WARNING("[src]不能固定在这里！"))  //might cause some friendly fire regarding other items like barbed wire, shouldn't be a problem?
				return

		if(reinf && state >= 1)
			state = 3 - state
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, (state == 1 ? SPAN_NOTICE("你松开了窗户与窗框之间的固定件。") : SPAN_NOTICE("你把窗户固定在了窗框上。")))
		else if(reinf && state == 0 && !static_frame)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, (anchored ? SPAN_NOTICE("你把窗框固定在了地板上。") : SPAN_NOTICE("你松开了窗框与地板之间的固定件。")))
		else if(!reinf && !static_frame)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, (anchored ? SPAN_NOTICE("你把窗户固定在了地板上。") : SPAN_NOTICE("你松开了窗户的固定件。")))
		else if(static_frame && state == 0)
			SEND_SIGNAL(user, COMSIG_MOB_DISASSEMBLE_WINDOW, src)
			deconstruct(TRUE)
	else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR) && reinf && state <= 1 && !not_deconstructable)
		state = 1 - state
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		to_chat(user, (state ? SPAN_NOTICE("你把窗户撬进了窗框。") : SPAN_NOTICE("你把窗户从窗框中撬了出来。")))
	else
		if(!not_damageable) //Impossible to destroy
			health -= W.force * W.demolition_mod
			if(health <= 7  && !reinf && !static_frame && !not_deconstructable)
				anchored = FALSE
				update_nearby_icons()
				step(src, get_dir(user, src))
		healthcheck(1, 1, 1, user, W)
		..()
	return

/obj/structure/window/proc/is_full_window()
	return !(flags_atom & ON_BORDER)

/obj/structure/window/deconstruct(disassembled = TRUE)
	if(disassembled)
		if(reinf)
			new /obj/item/stack/sheet/glass/reinforced(loc, 2)
		else
			new /obj/item/stack/sheet/glass(loc, 2)
	return ..()


/obj/structure/window/proc/shatter_window(create_debris)
	if(create_debris)
		handle_debris()
	deconstruct(FALSE)

/obj/structure/window/clicked(mob/user, list/mods)
	if(mods[ALT_CLICK])
		revrotate(user)
		return TRUE

	return ..()

/obj/structure/window/verb/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(static_frame || not_deconstructable || !(flags_atom & ON_BORDER))
		return 0

	if(anchored)
		to_chat(usr, SPAN_WARNING("它已固定在地板上，无法旋转！"))
		return 0

	setDir(turn(dir, 90))



/obj/structure/window/verb/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(static_frame || not_deconstructable || !(flags_atom & ON_BORDER))
		return 0
	if(anchored)
		to_chat(usr, SPAN_WARNING("它已固定在地板上，无法旋转！"))
		return 0

	setDir(turn(dir, 270))



//This proc is used to update the icons of nearby windows.
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/direction in GLOB.cardinals)
		for(var/obj/structure/window/W in get_step(src, direction))
			W.update_icon()

/obj/structure/window/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 800)
		if(!not_damageable)
			health -= floor(exposed_volume / 100)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()

/obj/structure/window/phoronbasic
	name = "弗燃玻璃窗"
	desc = "一扇弗燃玻璃合金窗，看起来极难打碎，似乎也极难烧穿。"
	icon_state = "phoronwindow0"
	shardtype = /obj/item/shard/phoron
	health = 120

/obj/structure/window/phoronbasic/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 32000)
		health -= floor(exposed_volume / 1000)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()

/obj/structure/window/phoronbasic/full
	flags_atom = FPRINT
	icon_state = "phoronwindow0"
	basestate = "phoronwindow"
	legacy_full = TRUE


/obj/structure/window/phoronreinforced
	name = "强化弗燃玻璃窗"
	desc = "一扇带有杆状骨架的弗燃玻璃合金窗，看起来坚固得让人无从下手。考虑到普通弗燃玻璃窗已经极其耐火，这扇窗似乎更是完全防火。"
	icon_state = "phoronrwindow0"
	shardtype = /obj/item/shard/phoron
	reinf = 1
	health = 160

/obj/structure/window/phoronreinforced/fire_act(exposed_temperature, exposed_volume)
	return

/obj/structure/window/phoronreinforced/full
	flags_atom = FPRINT
	icon_state = "phoronrwindow0"
	basestate = "phoronrwindow"
	legacy_full = TRUE


/obj/structure/window/reinforced
	name = "强化窗"
	desc = "一扇用支撑杆加固的玻璃窗，看起来相当结实，可能需要几次重击才能打碎。"
	icon_state = "rwindow"
	basestate = "rwindow"
	health = 40
	reinf = 1

/obj/structure/window/reinforced/toughened
	name = "安全玻璃窗"
	desc = "一扇以钢化玻璃和支撑杆加固的窗户，看起来极其结实，可能还能防弹。"
	icon_state = "rwindow"
	basestate = "rwindow"
	health = 300
	reinf = 1



/obj/structure/window/reinforced/tinted
	name = "着色玻璃窗"
	desc = "一扇着色玻璃窗，看起来相当结实且不透明，可能需要几次重击才能打碎。"
	icon_state = "twindow"
	basestate = "twindow"
	opacity = TRUE

/obj/structure/window/reinforced/tinted/frosted
	name = "隐私窗"
	desc = "一扇保护隐私的玻璃窗，看起来比普通强化窗更容易打碎一些。"
	icon_state = "fwindow"
	basestate = "fwindow"
	health = 30

/obj/structure/window/reinforced/ultra
	name = "超强化窗"
	desc = "一扇超强化窗，用于保障简报讲台区域的安全。"
	icon_state = "fwindow"
	basestate = "fwindow"
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/window/reinforced/ultra/initialize_pass_flags(datum/pass_flags_container/PF)
	. = ..()
	if (PF)
		PF.flags_can_pass_all = NONE
		PF.flags_can_pass_front = NONE
		PF.flags_can_pass_behind = PASS_OVER^(PASS_OVER_ACID_SPRAY)
	flags_can_pass_front_temp = NONE
	flags_can_pass_behind_temp = NONE

/obj/structure/window/reinforced/ultra/Initialize()
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_IMPACTED, PROC_REF(deconstruct))

/obj/structure/window/reinforced/full
	flags_atom = FPRINT
	icon_state = "rwindow0"
	basestate = "rwindow"
	legacy_full = TRUE

/obj/structure/window/shuttle
	name = "穿梭艇舷窗"
	desc = "一扇带有专用耐热杆状骨架的穿梭艇玻璃窗，看起来相当结实，可能需要几次重击才能打碎。"
	icon = 'icons/turf/podwindows.dmi'
	icon_state = "window"
	basestate = "window"
	health = 40
	reinf = 1
	flags_atom = FPRINT

/obj/structure/window/shuttle/update_icon() //icon_state has to be set manually
	return

/obj/structure/window/full
	flags_atom = FPRINT
	icon_state = "window0"
	basestate = "window"
	legacy_full = TRUE



//Framed windows

/obj/structure/window/framed
	name = "窗户原型"
	layer = TABLE_LAYER
	static_frame = 1
	flags_atom = FPRINT
	var/window_frame //For perspective windows,so the window frame doesn't magically dissapear
	var/list/tiles_special = list(/obj/structure/machinery/door/airlock,
		/obj/structure/window/framed,
		/obj/structure/girder,
		/obj/structure/window_frame)
	tiles_with = list(/turf/closed/wall)

/obj/structure/window/framed/Initialize()
	. = ..()
	relativewall()
	relativewall_neighbours()

/obj/structure/window/framed/Destroy(force)
	for(var/obj/effect/alien/weeds/weedwall/window/found_weedwall in get_turf(src))
		qdel(found_weedwall)
	var/list/turf/cardinal_neighbors = list(get_step(src, NORTH), get_step(src, SOUTH), get_step(src, EAST), get_step(src, WEST))
	for(var/turf/cardinal_turf as anything in cardinal_neighbors)
		for(var/obj/structure/bed/nest/found_nest in cardinal_turf)
			if(found_nest.dir == get_dir(found_nest, src))
				qdel(found_nest) //nests are built on walls, no walls, no nest
	. = ..()

/obj/structure/window/framed/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_GLASS

/obj/structure/window/framed/update_nearby_icons()
	relativewall_neighbours()

/obj/structure/window/framed/update_icon()
	relativewall()

/obj/structure/window/framed/ex_act(severity, explosion_direction, datum/cause_data/cause_data)
	if(not_damageable) //Impossible to destroy
		return

	health -= severity * EXPLOSION_DAMAGE_MULTIPLIER_WINDOW

	var/mob/M = cause_data?.resolve_mob()
	if(health > 0)
		healthcheck(FALSE, TRUE, user = M)
		return

	if(M)
		M.count_niche_stat(STATISTICS_NICHE_DESTRUCTION_WINDOWS, 1)
		SEND_SIGNAL(M, COMSIG_MOB_EXPLODE_W_FRAME, src)

	if(health >= -3000)
		var/location = get_turf(src)
		playsound(src, "windowshatter", 50, 1)
		handle_debris(severity, explosion_direction)
		deconstruct(disassembled = FALSE)
		create_shrapnel(location, rand(1,5), explosion_direction, , /datum/ammo/bullet/shrapnel/light/glass, cause_data)
	else
		qdel(src)
	return


/obj/structure/window/framed/deconstruct(disassembled = TRUE)
	if(window_frame)
		var/obj/structure/window_frame/new_window_frame = new window_frame(loc, TRUE)
		new_window_frame.icon_state = "[new_window_frame.basestate][junction]_frame"
		new_window_frame.setDir(dir)
	return ..()

/obj/structure/window/framed/almayer
	name = "强化窗"
	desc = "墙框内嵌有特殊杆状骨架的玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。"
	icon_state = "alm_rwindow0"
	basestate = "alm_rwindow"
	health = 100 //Was 600
	reinf = 1
	dir = NORTHEAST
	window_frame = /obj/structure/window_frame/almayer

/obj/structure/window/framed/almayer/hull
	name = "舰体舷窗"
	desc = "一扇嵌在墙框内、带有特殊杆状骨架的玻璃窗。它采用特殊材料制成，以防止舰体破损，根本无法从这里穿过去。"
	//icon_state = "rwindow0_debug" //Uncomment to check hull in the map editor
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window/framed/almayer/hull/hijack_bustable //I exist to explode after hijack, that is all.

/obj/structure/window/framed/almayer/hull/hijack_bustable/Initialize()
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_IMPACTED, PROC_REF(deconstruct))

/obj/structure/window/framed/almayer/white
	icon_state = "white_rwindow0"
	basestate = "white_rwindow"
	window_frame = /obj/structure/window_frame/almayer/white

/obj/structure/window/framed/almayer/white/hull
	name = "舰体舷窗"
	desc = "一扇用于保障科研区域安全的超强化窗，采用特殊材料制成，以防止舰体破损，根本无法从这里穿过去。"
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window/framed/almayer/aicore
	icon_state = "ai_rwindow0"
	basestate = "ai_rwindow"
	window_frame = /obj/structure/window_frame/almayer/aicore

/obj/structure/window/framed/almayer/aicore/hull
	name = "舰体舷窗"
	desc = "一扇用于保护AI核心的超强化窗，采用特殊材料制成，以防止舰体破损，什么也别想从这里穿过去。"
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window/framed/almayer/aicore/white
	icon_state = "w_ai_rwindow0"
	basestate = "w_ai_rwindow"
	window_frame = /obj/structure/window_frame/almayer/aicore/white

/obj/structure/window/framed/almayer/aicore/black
	icon_state = "alm_ai_rwindow0"
	basestate = "alm_ai_rwindow"
	window_frame = /obj/structure/window_frame/almayer/aicore/black

/obj/structure/window/framed/almayer/aicore/hull/black
	icon_state = "alm_ai_rwindow0"
	basestate = "alm_ai_rwindow"
	window_frame = /obj/structure/window_frame/almayer/aicore/black
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window/framed/almayer/aicore/hull/black/hijack_bustable //I exist to explode after hijack, that is all.

/obj/structure/window/framed/almayer/aicore/hull/black/hijack_bustable/Initialize()
	. = ..()
	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_HIJACK_IMPACTED, PROC_REF(deconstruct))

/obj/structure/window/framed/almayer/aicore/white/hull
	name = "舰体舷窗"
	desc = "一扇用于保护AI核心的超强化窗，采用特殊材料制成，以防止舰体破损，什么也别想从这里穿过去。"
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window/framed/colony
	name = "窗户"
	icon_state = "col_window0"
	basestate = "col_window"
	window_frame = /obj/structure/window_frame/colony

/obj/structure/window/framed/colony/reinforced
	name = "强化窗"
	icon_state = "col_rwindow0"
	basestate = "col_rwindow"
	desc = "墙框内嵌有特殊杆状骨架的玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/colony/reinforced

/obj/structure/window/framed/colony/reinforced/tinted
	name =  "着色强化窗"
	desc = "墙框内嵌有特殊杆状骨架的玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。这扇窗不透明，你不安地觉得另一边可能有人在看着你。"
	opacity = TRUE

/obj/structure/window/framed/colony/reinforced/hull
	name = "舰体舷窗"
	desc = "一扇嵌在墙框内、带有特殊杆状骨架的玻璃窗。它采用特殊材料制成，以防止舰体破损，根本无法从这里穿过去。"
	//icon_state = "rwindow0_debug" //Uncomment to check hull in the map editor
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter



//Chigusa windows

/obj/structure/window/framed/chigusa
	name = "强化窗"
	icon_state = "chig_rwindow0"
	basestate = "chig_rwindow"
	desc = "墙框内嵌有特殊杆状骨架的玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/chigusa


//Desert Dam Windows

/obj/structure/window/framed/hangar
	name = "窗户"
	icon_state = "hngr_window0"
	basestate = "hngr_window"
	desc = "一扇嵌在墙框内的玻璃窗。"
	health = 40
	window_frame = /obj/structure/window_frame/hangar

/obj/structure/window/framed/hangar/reinforced
	name = "强化窗"
	icon_state = "hngr_rwindow0"
	basestate = "hngr_rwindow"
	desc = "墙框内嵌有特殊杆状骨架的玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/hangar/reinforced

/obj/structure/window/framed/bunker
	name = "窗户"
	icon_state = "bnkr_window0"
	basestate = "bnkr_window"
	desc = "一扇嵌在墙框内的玻璃窗。"
	health = 40
	window_frame = /obj/structure/window_frame/bunker

/obj/structure/window/framed/bunker/reinforced
	name = "强化窗"
	icon_state = "bnkr_rwindow0"
	basestate = "bnkr_rwindow"
	desc = "墙框内嵌有特殊杆状骨架的玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/bunker/reinforced


/obj/structure/window/framed/wood
	name = "窗户"
	icon_state = "wood_window0"
	basestate = "wood_window"
	window_frame = /obj/structure/window_frame/wood

/obj/structure/window/framed/wood/reinforced
	name = "强化窗"
	desc = "墙框内嵌有特殊杆状骨架的玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1
	icon_state = "wood_rwindow0"
	basestate = "wood_rwindow"
	window_frame = /obj/structure/window_frame/wood

//Strata windows

/obj/structure/window/framed/strata
	name = "窗户"
	icon = 'icons/turf/walls/strata_windows.dmi'
	icon_state = "strata_window0"
	basestate = "strata_window"
	desc = "一扇嵌在墙框内的玻璃窗。"
	health = 40
	window_frame = /obj/structure/window_frame/strata

/obj/structure/window/framed/strata/reinforced
	name = "强化窗"
	icon_state = "strata_window0"
	basestate = "strata_window"
	desc = "一扇玻璃窗，透过它看去，光线的折射有些异常。看起来相当结实，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/strata/reinforced

/obj/structure/window/framed/strata/hull
	icon_state = "strata_window0"
	basestate = "strata_window"
	desc = "一扇玻璃窗。不知为何，你觉得它无论如何都无法摧毁。"
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000

//Kutjevo Windows

/obj/structure/window/framed/kutjevo
	name = "窗户"
	icon = 'icons/turf/walls/kutjevo/kutjevo_windows.dmi'
	icon_state = "kutjevo_window0"
	basestate = "kutjevo_window"
	desc = "一扇嵌在墙框内的玻璃窗。"
	health = 40
	window_frame = /obj/structure/window_frame/kutjevo

/obj/structure/window/framed/kutjevo/reinforced
	name = "强化窗"
	icon_state = "kutjevo_window_alt0"
	basestate = "kutjevo_window_alt"
	desc = "一扇能看见交叉支撑杆的玻璃窗，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/kutjevo/reinforced

/obj/structure/window/framed/kutjevo/reinforced/hull
	icon_state = "kutjevo_window_hull"
	desc = "一扇玻璃窗。不知为何，你觉得它无论如何都无法摧毁。"
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000

/obj/structure/window/framed/shiva
	name = "聚合凯夫纶框窗"
	icon = 'icons/turf/walls/ice_colony/shiva_windows.dmi'
	icon_state = "shiva_window0"
	basestate = "shiva_window"
	desc = "一块嵌在聚合凯夫纶框内的半透明材料板，并非完全不透光，很容易砸碎。"
	health = 40
	window_frame = /obj/structure/window_frame/shiva

/obj/structure/window/framed/prefab
	name = "聚合凯夫纶框窗"
	icon = 'icons/turf/walls/ice_colony/shiva_windows.dmi'
	icon_state = "prefab_window0"
	basestate = "prefab_window"
	desc = "一块嵌在聚合凯夫纶框内的半透明材料板，并非完全不透光，很容易砸碎。"
	health = 40
	window_frame = /obj/structure/window_frame/prefab

//Solaris windows

/obj/structure/window/framed/solaris
	name = "窗户"
	icon = 'icons/turf/walls/solaris/solaris_windows.dmi'
	icon_state = "solaris_window0"
	basestate = "solaris_window"
	desc = "一扇嵌在墙框内的玻璃窗。"
	health = 40
	window_frame = /obj/structure/window_frame/solaris

/obj/structure/window/framed/solaris/reinforced
	name = "强化窗"
	icon_state = "solaris_rwindow0"
	basestate = "solaris_rwindow"
	desc = "一扇玻璃窗，内部沿底边以几根经过钢化处理的骨架杆加固。看起来相当结实，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/solaris/reinforced

/obj/structure/window/framed/solaris/reinforced/hull
	desc = "一扇玻璃窗。不知为何，你觉得它无论如何都无法摧毁。"
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000

/obj/structure/window/framed/solaris/reinforced/tinted
	desc = "一扇着色玻璃窗，看起来相当结实且不透明，可能需要几次重击才能打碎。"
	opacity = TRUE

//GREYBOX DEV WINDOWS

/obj/structure/window/framed/dev
	name = "greybox window"
	icon = 'icons/turf/walls/dev/dev_windows.dmi'
	icon_state = "dev_window0"
	basestate = "dev_window"
	desc = "A glass window inside a wall frame. Just like in the orange box!"
	health = 40
	window_frame = /obj/structure/window_frame/dev

/obj/structure/window/framed/dev/reinforced
	name = "greybox reinforced window"
	icon_state = "dev_rwindow0"
	basestate = "dev_rwindow"
	desc = "A glass window inside a reinforced wall frame. Just like in the orange box!"
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/dev/reinforced

/obj/structure/window/framed/dev/reinforced/hull
	desc = "A glass window. Something tells you this one is somehow indestructible."
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000


//Prison windows


/obj/structure/window/framed/prison
	name = "窗户"
	icon_state = "prison_window0"
	basestate = "prison_window"
	window_frame = /obj/structure/window_frame/prison

/obj/structure/window/framed/prison/reinforced
	name = "强化窗"
	desc = "墙框内嵌有特殊杆状骨架的玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1
	icon_state = "prison_rwindow0"
	basestate = "prison_rwindow"
	window_frame = /obj/structure/window_frame/prison/reinforced

/obj/structure/window/framed/prison/reinforced/hull
	name = "舰体舷窗"
	desc = "一扇嵌在墙框内、带有特殊杆状骨架的玻璃窗，配有自动闸门系统，可防止气体泄漏。"
	health = 200
	//icon_state = "rwindow0_debug" //Uncomment to check hull in the map editor
	var/triggered = FALSE //indicates if the shutters have already been triggered

/obj/structure/window/framed/prison/reinforced/hull/Destroy(force)
	if(force)
		return ..()
	spawn_shutters()
	. = ..()

/obj/structure/window/framed/prison/reinforced/hull/proc/spawn_shutters(from_dir = 0)
	if(triggered)
		return

	triggered = TRUE
	for(var/direction in GLOB.cardinals)
		if(direction == from_dir)
			continue //doesn't check backwards
		for(var/obj/structure/window/framed/prison/reinforced/hull/W in get_step(src,direction) )
			W.spawn_shutters(turn(direction,180))
	var/obj/structure/machinery/door/poddoor/shutters/almayer/pressure/pressure_door = new(get_turf(src))
	switch(junction)
		if(4,5,8,9,12)
			pressure_door.setDir(SOUTH)
		else
			pressure_door.setDir(EAST)
	pressure_door.close()

/obj/structure/window/framed/prison/cell
	name = "牢房窗"
	icon_state = "prison_cellwindow0"
	basestate = "prison_cellwindow"
	desc = "一扇嵌在墙框内、带有特殊杆状骨架的玻璃窗。"

//Biodome windows

/obj/structure/window/framed/corsat
	name = "强化窗"
	desc = "墙框内嵌有特殊杆状骨架的玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。"
	health = 100
	reinf = TRUE
	icon = 'icons/turf/walls/windows_corsat.dmi'
	icon_state = "padded_rwindow0"
	basestate = "padded_rwindow"
	window_frame = /obj/structure/window_frame/corsat

/obj/structure/window/framed/corsat/research
	desc = "一扇嵌在墙框内、带有特殊杆状骨架的紫色玻璃窗，看起来相当坚固，可能需要几次重击才能打碎。"
	health = 200
	icon_state = "paddedresearch_rwindow0"
	basestate = "paddedresearch_rwindow"
	window_frame = /obj/structure/window_frame/corsat/research

/obj/structure/window/framed/corsat/security
	desc = "一扇嵌在墙框内、带有特殊杆状骨架的红色玻璃窗，看起来非常坚固。"
	health = 300
	icon_state = "paddedsec_rwindow0"
	basestate = "paddedsec_rwindow"
	window_frame = /obj/structure/window_frame/corsat/security

/obj/structure/window/framed/corsat/cell
	name = "牢房窗"
	icon_state = "padded_cellwindow0"
	basestate = "padded_cellwindow"
	desc = "一扇嵌在墙框内、带有特殊杆状骨架的玻璃窗。它采用特殊材料制成，以防止舰体破损，根本无法从这里穿过去。"
	not_damageable = TRUE
	not_deconstructable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window/framed/corsat/cell/research
	icon_state = "paddedresearch_cellwindow0"
	basestate = "paddedresearch_cellwindow"

/obj/structure/window/framed/corsat/cell/security
	icon_state = "paddedsec_cellwindow0"
	basestate = "paddedsec_cellwindow"

/obj/structure/window/framed/corsat/hull
	name = "舰体舷窗"
	desc = "一扇嵌在墙框内、带有特殊杆状骨架的玻璃窗，配有自动闸门系统，可防止气体泄漏。"
	health = 200
	var/triggered = FALSE //indicates if the shutters have already been triggered

/obj/structure/window/framed/corsat/hull/research
	icon_state = "paddedresearch_rwindow0"
	basestate = "paddedresearch_rwindow"
	window_frame = /obj/structure/window_frame/corsat/research
	health = 300

/obj/structure/window/framed/corsat/hull/security
	icon_state = "paddedsec_rwindow0"
	basestate = "paddedsec_rwindow"
	window_frame = /obj/structure/window_frame/corsat/security
	health = 400

/obj/structure/window/framed/corsat/hull/Destroy(force)
	if(force)
		return ..()

	spawn_shutters()
	. = ..()

/obj/structure/window/framed/corsat/hull/proc/spawn_shutters(from_dir = 0)
	if(triggered)
		return

	triggered = 1
	for(var/direction in GLOB.cardinals)
		if(direction == from_dir)
			continue //doesn't check backwards

		for(var/obj/structure/window/framed/corsat/hull/W in get_step(src,direction) )
			W.spawn_shutters(turn(direction,180))

	var/obj/structure/machinery/door/poddoor/shutters/almayer/pressure/pressure_door = new(get_turf(src))
	switch(junction)
		if(4,5,8,9,12)
			pressure_door.setDir(SOUTH)
		else
			pressure_door.setDir(EAST)

	INVOKE_ASYNC(pressure_door, TYPE_PROC_REF(/obj/structure/machinery/door, close))

/obj/structure/window/framed/corsat/indestructible/
	name = "舰体舷窗"
	desc = "一扇嵌在墙框内、带有特殊杆状骨架的玻璃窗，经过加固，几乎能承受宇宙中任何东西的冲击。"
	not_damageable = TRUE
	not_deconstructable = TRUE
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000

/obj/structure/window/framed/corsat/indestructible/research
	icon_state = "paddedresearch_rwindow0"
	basestate = "paddedresearch_rwindow"
	window_frame = /obj/structure/window_frame/corsat/research

/obj/structure/window/framed/corsat/indestructible/security
	icon_state = "paddedsec_rwindow0"
	basestate = "paddedsec_rwindow"
	window_frame = /obj/structure/window_frame/corsat/security

/obj/structure/window/framed/upp
	name = "军用级玻璃窗"
	desc = "一扇玻璃窗，透过它看去，光线的折射有些异常。看起来相当结实，可能需要几次重击才能打碎。"
	health = 100
	reinf = 1

/obj/structure/window/framed/upp/green
	icon = 'icons/turf/walls/upp_green_windows.dmi'
	icon_state = "uppwall_window0"
	basestate = "uppwall_window"
	window_frame = /obj/structure/window_frame/upp/green

/obj/structure/window/framed/upp/grey
	icon = 'icons/turf/walls/upp_grey_windows.dmi'
	icon_state = "uppwall_window0"
	basestate = "uppwall_window"
	window_frame = /obj/structure/window_frame/upp/grey
