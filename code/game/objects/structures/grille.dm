/obj/structure/grille
	desc = "由金属杆组成的脆弱格栅，用螺丝固定在地板上。"
	name = "金属格栅"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "grille"
	density = TRUE
	anchored = TRUE
	debris = list(/obj/item/stack/rods)
	flags_atom = FPRINT|CONDUCT
	layer = OBJ_LAYER
	health = 10
	var/destroyed = 0

/obj/structure/grille/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_THROUGH|PASS_BUILDING_ONLY

/obj/structure/grille/fence
	var/width = 3
	health = 50

/obj/structure/grille/fence/Initialize()
	. = ..()

	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size


/obj/structure/grille/fence/east_west
	//width=80
	//height=42
	icon='icons/obj/structures/props/fence_ew.dmi'
	icon_state = "fence-ew"
	dir = EAST

/obj/structure/grille/fence/north_south
	//width=80
	//height=42
	icon='icons/obj/structures/props/fence_ns.dmi'
	icon_state = "fence-ns"

/obj/structure/grille/fence/healthcheck()
	if(health <= 0)
		density = FALSE
		destroyed = 1
		handle_debris()
		qdel(src)
	return

/obj/structure/grille/ex_act(severity,direction)
	handle_debris(severity, direction)
	deconstruct(FALSE)

/obj/structure/grille/Collided(atom/user)
	if(ismob(user)) shock(user, 70)

/obj/structure/grille/attack_hand(mob/user as mob)

	playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)

	var/damage_dealt
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			damage_dealt = 5
			user.visible_message(SPAN_WARNING("[user]扭坏了[src]。"), \
						SPAN_WARNING("你扭坏了[src]。"), \
						"你听到金属扭曲的声音。")

	if(!damage_dealt)
		user.visible_message(SPAN_WARNING("[user]踢向[src]。"), \
						SPAN_WARNING("你踢向[src]。"), \
						"你听到金属扭曲的声音。")

	if(shock(user, 70))
		return

	damage_dealt++

	health -= damage_dealt
	healthcheck()


/obj/structure/grille/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0) return

	playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
	M.visible_message(SPAN_WARNING("[M]猛撞[src]。"), \
					SPAN_WARNING("你猛撞[src]。"), \
					"你听到金属扭曲的声音。")

	health -= M.melee_damage_upper
	healthcheck()
	return


/obj/structure/grille/BlockedPassDirs(atom/movable/mover, target_dir)
	if(istype(mover, /obj/projectile) && prob(90))
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/grille/bullet_act(obj/projectile/Proj)

	//Tasers and the like should not damage grilles.
	if(Proj.ammo.damage_type == HALLOSS)
		return 0

	src.health -= floor(Proj.damage*0.3)
	healthcheck()
	return 1

/obj/structure/grille/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		if(!shock(user, 100))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			handle_debris()
			qdel(src)
	else if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && istype(loc, /turf/open))
		if(!shock(user, 90))
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			anchored = !anchored
			user.visible_message(SPAN_NOTICE("[user][anchored ? "固定了" : "松开了"]格栅。"), \
								SPAN_NOTICE("你已[anchored ? "将格栅固定在地板上" : "解除格栅与地板的固定"]。"))
			return

//window placing begin
	else if(istype(W,/obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/ST = W
		var/dir_to_set = 1
		if(loc == user.loc)
			dir_to_set = user.dir
		else
			if( ( x == user.x ) || (y == user.y) ) //Only supposed to work for cardinal directions.
				if( x == user.x )
					if( y > user.y )
						dir_to_set = 2
					else
						dir_to_set = 1
				else if( y == user.y )
					if( x > user.x )
						dir_to_set = 8
					else
						dir_to_set = 4
			else
				to_chat(user, SPAN_NOTICE("你够不着。"))
				return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)
				to_chat(user, SPAN_NOTICE("那里已经有一扇朝这个方向的窗户了。"))
				return
		to_chat(user, SPAN_NOTICE("你开始安装窗户。"))
		if(do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
					to_chat(user, SPAN_NOTICE("那里已经有一扇朝这个方向的窗户了。"))
					return

			var/wtype = ST.created_window
			if (ST.use(1))
				var/obj/structure/window/WD = new wtype(loc)
				WD.set_constructed_window(dir_to_set)
				to_chat(user, SPAN_NOTICE("你将[WD]安装在[src]上。"))
		return
//window placing end

	else if(istype(W, /obj/item/shard))
		health -= W.force * 0.1
	else if(!shock(user, 70))
		playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
		switch(W.damtype)
			if("fire")
				health -= W.force
			if("brute")
				health -= W.force * 0.1
	healthcheck()
	..()
	return


/obj/structure/grille/proc/healthcheck()
	if(health <= 0)
		if(!destroyed)
			icon_state = "brokengrille"
			density = FALSE
			destroyed = 1
			handle_debris()

		else
			if(health <= -6)
				handle_debris()
				qdel(src)
				return
	return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user as mob, prb)

	if(!anchored || destroyed) // anchored/destroyed grilles are never connected
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			return 1
		else
			return 0
	return 0

/obj/structure/grille/fire_act(exposed_temperature, exposed_volume)
	if(!destroyed)
		if(exposed_temperature > T0C + 1500)
			health--
			healthcheck()
	..()
