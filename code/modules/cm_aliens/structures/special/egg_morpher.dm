#define EGGMORPG_RANGE 2

//Eggmorpher - Basically a big reusable egg
/obj/effect/alien/resin/special/eggmorph
	name = XENO_STRUCTURE_EGGMORPH
	desc = "令人作呕的有机处理器，散发着腐肉的恶臭，连骨头都能融化，转化成更有用的东西。"
	icon_state = "eggmorph"
	health = 300
	var/last_spawned = 0
	var/spawn_cooldown = 20 SECONDS
	var/stored_huggers = 0
	var/huggers_to_grow = 0
	var/huggers_per_corpse = 6
	var/huggers_to_grow_max = 12
	var/huggers_reserved = 0
	var/mob/captured_mob
	var/datum/shape/range_bounds

	appearance_flags = KEEP_TOGETHER
	layer = FACEHUGGER_LAYER

/obj/effect/alien/resin/special/eggmorph/Initialize(mapload, hive_ref)
	. = ..()
	range_bounds = SQUARE(x, y, EGGMORPG_RANGE)

/obj/effect/alien/resin/special/eggmorph/Destroy()
	if (stored_huggers && linked_hive)
		//Hugger explosion, like a carrier
		var/obj/item/clothing/mask/facehugger/F
		var/chance = 60
		visible_message(SPAN_XENOWARNING("一大群吱吱作响的小异形正试图从[src]中逃出来！"))
		for(var/i in 1 to stored_huggers)
			if(prob(chance))
				F = new(loc, linked_hive.hivenumber)
				step_away(F,src,1)

	vis_contents.Cut()
	QDEL_NULL(captured_mob)
	range_bounds = null

	. = ..()

/obj/effect/alien/resin/special/eggmorph/get_examine_text(mob/user)
	. = ..()
	if(isxeno(user) || isobserver(user))
		. += "其中存有[stored_huggers]只抱脸虫，另有[huggers_to_grow]只正在生长（保留数量：[huggers_reserved]）。"
	if(isobserver(user))
		var/current_hugger_count = linked_hive.get_current_playable_facehugger_count();
		. += "虫巢目前有[SPAN_NOTICE("[current_hugger_count]")]只抱脸虫，目前最多可供养[SPAN_NOTICE("[linked_hive.playable_hugger_limit]")]只。"

/obj/effect/alien/resin/special/eggmorph/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/grab))
		if(!isxeno(user)) return
		var/obj/item/grab/G = I
		if(iscarbon(G.grabbed_thing))
			var/mob/living/carbon/M = G.grabbed_thing
			if(M.buckled)
				to_chat(user, SPAN_XENOWARNING("先解除固定！"))
				return
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.is_revivable())
					to_chat(user, SPAN_XENOWARNING("这个目前还不适合！"))
					return
			if(isxeno(M))
				return
			if(M == captured_mob)
				to_chat(user, SPAN_XENOWARNING("[src]已经在消化[M]了！"))
				return
			if(huggers_to_grow + stored_huggers >= huggers_to_grow_max)
				to_chat(user, SPAN_XENOWARNING("[src]已经满了！现在使用这个只会浪费……"))
				return
			if(!do_after(user, 10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
				return
			visible_message(SPAN_DANGER("[src]翻腾起来，开始消化[M]，喷出阵阵恶臭的烟气！"))
			playsound(src, "alien_drool", 25)
			if(captured_mob)
				//Get rid of what we have there, we're overwriting it
				qdel(captured_mob)
			captured_mob = M
			captured_mob.setDir(SOUTH)
			captured_mob.moveToNullspace()
			var/matrix/MX = matrix()
			captured_mob.apply_transform(MX)
			captured_mob.pixel_x = 16
			captured_mob.pixel_y = 16
			vis_contents += captured_mob
			user.stop_pulling() // Automatically remove the grab
			huggers_to_grow += huggers_per_corpse
			update_icon()
		return
	if(istype(I, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = I
		if(F.stat != DEAD)
			if(stored_huggers >= huggers_to_grow_max)
				to_chat(user, SPAN_XENOWARNING("[src]里面已经装满了孩子。"))
				return
			if(user)
				visible_message(SPAN_XENOWARNING("[user]将[F]放回了[src]。"), \
					SPAN_XENONOTICE("你将孩子放回了[src]。"))
				user.temp_drop_inv_item(F)
			else
				visible_message(SPAN_XENOWARNING("[F]爬回了[src]！"))
			stored_huggers = min(huggers_to_grow_max, stored_huggers + 1)
			qdel(F)
		else to_chat(user, SPAN_XENOWARNING("这个孩子已经死了。"))
		return
	//refill egg morpher from an egg
	if(istype(I, /obj/item/xeno_egg))
		var/obj/item/xeno_egg/egg = I
		if(stored_huggers >= huggers_to_grow_max)
			to_chat(user, SPAN_XENOWARNING("[src]里面已经装满了孩子。"))
			return
		if(user)
			visible_message(SPAN_XENOWARNING("[user]将一只抱脸虫从[egg]中取出，放入[src]。"), \
				SPAN_XENONOTICE("你将卵里的孩子放入了[src]。"))
			user.temp_drop_inv_item(egg)
		stored_huggers = min(huggers_to_grow_max, stored_huggers + 1)
		playsound(src.loc, "sound/effects/alien_egg_move.ogg", 25)
		qdel(egg)
		return
	return ..(I, user)

/obj/effect/alien/resin/special/eggmorph/update_icon()
	..()
	appearance_flags |= KEEP_TOGETHER
	overlays.Cut()
	underlays.Cut()
	if(captured_mob)
		var/image/J = new(icon = icon, icon_state = "[icon_state]", layer = captured_mob.layer + 0.1)
		overlays += J
		var/image/I = new(icon = icon, icon_state = "[icon_state]_overlay", layer = captured_mob.layer + 0.2)
		overlays += I
	underlays += "[icon_state]_underlay"

/obj/effect/alien/resin/special/eggmorph/process()
	check_facehugger_target()

	if(!linked_hive || !captured_mob || world.time < (last_spawned + spawn_cooldown))
		return
	last_spawned = world.time
	if(huggers_to_grow > 0)
		huggers_to_grow--
		stored_huggers = min(huggers_to_grow_max, stored_huggers + 1)
		if(huggers_to_grow <= 0)
			visible_message(SPAN_DANGER("[src]发出低沉的呻吟，里面的东西被彻底消化了！"))
			vis_contents.Cut()

			for(var/atom/movable/A in captured_mob.contents_recursive()) // Get rid of any intel objects so we don't delete them
				if(isitem(A))
					var/obj/item/item = A
					if(item.is_objective && item.unacidable)
						item.forceMove(get_step(loc, pick(GLOB.alldirs)))
						item.mouse_opacity = initial(item.mouse_opacity)

			QDEL_NULL(captured_mob)
			update_icon()

/obj/effect/alien/resin/special/eggmorph/proc/check_facehugger_target()
	if(!range_bounds)
		range_bounds = SQUARE(x, y, EGGMORPG_RANGE)

	var/list/targets = SSquadtree.players_in_range(range_bounds, z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	if(isnull(targets) || !length(targets))
		return

	var/target = pick(targets)
	if(isnull(target))
		return

	HasProximity(target)

/obj/effect/alien/resin/special/eggmorph/HasProximity(atom/movable/AM as mob|obj)
	if(!stored_huggers || issynth(AM))
		return

	if (!linked_hive)
		return

	if(!can_hug(AM, linked_hive.hivenumber))
		return

	stored_huggers = max(0, stored_huggers - 1)

	var/obj/item/clothing/mask/facehugger/child = new(loc, linked_hive.hivenumber)
	child.leap_at_nearest_target()

/obj/effect/alien/resin/special/eggmorph/attack_alien(mob/living/carbon/xenomorph/M)
	if(!istype(M))
		return attack_hand(M)
	if(!linked_hive || (M.hivenumber != linked_hive.hivenumber))
		return ..(M)
	if(stored_huggers)
		to_chat(M, SPAN_XENONOTICE("你取出一个孩子。"))
		stored_huggers = max(0, stored_huggers - 1)
		var/obj/item/clothing/mask/facehugger/hugger = new(loc, linked_hive.hivenumber)
		SEND_SIGNAL(M, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER, hugger)
		return XENO_NONCOMBAT_ACTION
	..()

/obj/effect/alien/resin/special/eggmorph/attack_ghost(mob/dead/observer/user)
	. = ..() //Do a view printout as needed just in case the observer doesn't want to join as a Hugger but wants info
	join_as_facehugger_from_this(user)

/obj/effect/alien/resin/special/eggmorph/proc/join_as_facehugger_from_this(mob/dead/observer/user)
	if(stored_huggers <= huggers_reserved)
		to_chat(user, SPAN_WARNING("[src]里没有可供附身的抱脸虫。"))
		return
	if(!linked_hive.can_spawn_as_hugger(user))
		return
	//Need to check again because time passed due to the confirmation window
	if(stored_huggers <= huggers_reserved)
		to_chat(user, SPAN_WARNING("[src]里没有可供附身的抱脸虫。"))
		return
	linked_hive.spawn_as_hugger(user, src)
	stored_huggers--

/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher(obj/effect/alien/resin/special/eggmorph/morpher in oview(1))
	set name = "设置抱脸虫保留数量"
	set desc = "设置抱脸虫保留数量"
	set category = null

	if(!istype(morpher))
		return

	if(morpher.linked_hive)
		if(hivenumber != morpher.linked_hive.hivenumber)
			to_chat(usr, SPAN_WARNING("这属于另一个虫巢！真恶心！"))
			return

	morpher.huggers_reserved = tgui_input_number(usr, "你想为姐妹们保留多少只抱脸虫，不让观察者附身加入？", "保留多少只？", 0, morpher.huggers_to_grow_max, morpher.huggers_reserved)

	to_chat(usr, SPAN_XENONOTICE("你为姐妹们保留了[morpher.huggers_reserved]只抱脸虫。"))

#undef EGGMORPG_RANGE
