/obj/structure/fence
	name = "围栏"
	desc = "两根立柱间张着大片金属网，用于低成本隔离区域，同时保持视野通透。"
	icon = 'icons/obj/structures/props/fence.dmi'
	icon_state = "fence0"
	throwpass = TRUE
	density = TRUE
	anchored = TRUE
	layer = WINDOW_LAYER
	flags_atom = FPRINT
	health = 50
	minimap_color = MINIMAP_FENCE
	var/health_max = 50
	var/cut = 0 //Cut fences can be passed through
	var/junction = 0 //Because everything is terrible, I'm making this a fence-level var
	var/basestate = "fence"

/obj/structure/fence/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_THROUGH|PASS_HIGH_OVER_ONLY

//create_debris creates debris like shards and rods. This also includes the window frame for explosions
//If an user is passed, it will create a "user smashes through the window" message. AM is the item that hits
//Please only fire this after a hit
/obj/structure/fence/proc/healthcheck(make_hit_sound = 1, create_debris = 1, mob/user, atom/movable/AM)

	if(cut) //It's broken/cut, just a frame!
		return
	if(health <= 0)
		if(user)
			user.visible_message(SPAN_DANGER("[user][AM ? "用[AM]":""]撞破了[src]！"))
		playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
		cut_grille()
	if(make_hit_sound)
		playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)

/obj/structure/fence/bullet_act(obj/projectile/Proj)
	//Tasers and the like should not damage windows.
	var/ammo_flags = Proj.ammo.flags_ammo_behavior | Proj.projectile_override_flags
	if(Proj.ammo.damage_type == HALLOSS || Proj.damage <= 0 || ammo_flags == AMMO_ENERGY)
		return 0

	health -= Proj.damage * 0.02
	..()
	healthcheck()
	return 1

/obj/structure/fence/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			health -= severity/2
			healthcheck(0, 1)
		if(EXPLOSION_THRESHOLD_LOW to INFINITY)
			deconstruct(TRUE)

/obj/structure/fence/hitby(atom/movable/AM)
	..()
	visible_message(SPAN_DANGER("[src]被[AM]击中了。"))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce/10 //Adjust higher if needed to stop knife-throwing bampots
	health = max(0, health - tforce)
	healthcheck()

/obj/structure/fence/attack_hand(mob/user as mob)
	if(ishuman(user) && user.a_intent == INTENT_HARM)
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_generic(H, 25)

//Used by attack_animal
/obj/structure/fence/proc/attack_generic(mob/living/user, damage = 0)
	health -= damage
	user.animation_attack_on(src)
	user.visible_message(SPAN_DANGER("[user]猛撞在[src]上！"))
	healthcheck(1, 1, user)

/obj/structure/fence/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	attack_generic(M, M.melee_damage_upper)

/obj/structure/fence/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/stack/barbed_wire) && health < health_max)
		if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_ENGI))
			to_chat(user, SPAN_WARNING("你没有修复[src]网线所需的技能。"))
			return
		var/obj/item/stack/barbed_wire/R = W
		var/amount_needed = 2
		if(health)
			amount_needed = 1
		if(R.amount >= amount_needed)
			user.visible_message(SPAN_NOTICE("[user]开始用[R]修复[src]。"),
			SPAN_NOTICE("你开始用[R]修复[src]。"))
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
			if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				if(R.amount < amount_needed)
					to_chat(user, SPAN_WARNING("你需要更多带刺铁丝才能修复[src]。"))
					return
				R.use(amount_needed)
				health = health_max
				cut = 0
				density = TRUE
				update_icon()
				playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user]用[R]修好了[src]。"),
				SPAN_NOTICE("你用[R]修好了[src]。"))
				return
		else
			to_chat(user, SPAN_WARNING("你需要更多带刺铁丝才能修复[src]。"))
			return

	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && cut)
		user.visible_message(SPAN_NOTICE("[user]开始用[W]剪除[src]的残骸。"),
		SPAN_NOTICE("你开始用[W]剪除[src]的残骸。"))
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user]用[W]剪除了[src]的残骸。"),
			SPAN_NOTICE("你用[W]剪除了[src]的残骸。"))
			deconstruct()
			return

	if(cut) //Cut/brokn grilles can't be messed with further than this
		return

	if(istype(W, /obj/item/grab) && get_dist(src, user) < 2)
		var/obj/item/grab/G = W
		if(istype(G.grabbed_thing, /mob/living))
			var/mob/living/M = G.grabbed_thing
			var/state = user.grab_level
			user.drop_held_item()
			switch(state)
				if(GRAB_PASSIVE)
					M.visible_message(SPAN_WARNING("[user]将[M]猛推向\the [src]！"))
					M.apply_damage(7)
					health -= 10
				if(GRAB_AGGRESSIVE)
					M.visible_message(SPAN_DANGER("[user]将[M]砸向\the [src]！"))
					if(prob(50))
						M.apply_effect(1, WEAKEN)
					M.apply_damage(10)
					health -= 25
				if(GRAB_CHOKE)
					M.visible_message(SPAN_DANGER("[user]将[M]狠狠压向\the [src]！"))
					M.apply_effect(5, WEAKEN)
					M.apply_damage(20)
					health -= 50

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slammed against [src] by [key_name(user)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>slammed [key_name(M)] against [src]</font>")
			msg_admin_attack("[key_name(user)] slammed [key_name(M)] against [src] at [get_area_name(M)]", M.loc.x, M.loc.y, M.loc.z)

			healthcheck(1, 1, M) //The person thrown into the window literally shattered it
		return

	if(W.flags_item & NOBLUDGEON) return

	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		user.visible_message(SPAN_NOTICE("[user]开始用[W]剪开[src]。"),
		SPAN_NOTICE("你开始用[W]剪开[src]。"))
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
		if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user]用[W]剪开了[src]。"),
			SPAN_NOTICE("你用[W]剪开了[src]。"))
			cut_grille()
		return

	if(istype(W, /obj/item/attachable/bayonet) || istype(W, /obj/item/weapon/knife) && get_dist(src, user) < 2)
		user.visible_message(SPAN_NOTICE("[user]开始用[W]剪开[src]。"),
		SPAN_NOTICE("你开始用[W]剪开[src]。"))
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
		if(do_after(user, 210 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user]用[W]剪开了[src]。"),
			SPAN_NOTICE("你用[W]剪开了[src]。"))
			cut_grille()
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.force * W.demolition_mod
			if("brute")
				health -= W.force * W.demolition_mod * 0.1
		healthcheck(1, 1, user, W)
		..()

/obj/structure/fence/deconstruct(disassembled = TRUE)
	if(disassembled)
		new /obj/item/stack/rods(loc, 10)
	return ..()

/obj/structure/fence/proc/cut_grille()
	health = 0
	cut = 1
	density = FALSE
	update_icon() //Make it appear cut through!

/obj/structure/fence/Initialize(mapload, start_dir = null, constructed = 0)
	. = ..()

	if(start_dir)
		setDir(start_dir)

	healthcheck()
	update_nearby_icons()

/obj/structure/fence/Destroy()
	density = FALSE
	update_nearby_icons()
	. = ..()

/obj/structure/fence/Move()
	var/ini_dir = dir
	. = ..()
	setDir(ini_dir)

//This proc is used to update the icons of nearby windows.
/obj/structure/fence/proc/update_nearby_icons()
	update_icon()
	for(var/direction in GLOB.cardinals)
		for(var/obj/structure/fence/W in get_step(src, direction))
			W.update_icon()

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/fence/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	//This spawn is here so windows get properly updated when one gets deleted.
	spawn(2)
		if(!src) return
		for(var/obj/structure/fence/W in orange(src, 1))
			if(abs(x - W.x) - abs(y - W.y)) //Doesn't count grilles, placed diagonally to src
				junction |= get_dir(src, W)
		if(cut)
			icon_state = "broken[basestate][junction]"
		else
			icon_state = "[basestate][junction]"

/obj/structure/fence/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 800)
		health -= floor(exposed_volume / 100)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()
