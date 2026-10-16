
//Burrower Abilities
/mob/living/carbon/xenomorph/proc/burrow()
	if(!check_state())
		return

	if(used_burrow || tunnel || is_ventcrawling || action_busy)
		return

	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return

	var/area/current_area = get_area(current_turf)
	if(current_area.flags_area & AREA_NOTUNNEL)
		to_chat(src, SPAN_XENOWARNING("这里无处可钻。"))
		return

	if(istype(current_turf, /turf/open/floor/almayer/research/containment) || istype(current_turf, /turf/closed/wall/almayer/research/containment))
		to_chat(src, SPAN_XENOWARNING("我们无法逃离这个牢笼！"))
		return

	if(clone) //Prevents burrowing on stairs
		to_chat(src, SPAN_XENOWARNING("我们无法在这里掘地！"))
		return

	if(caste_type && GLOB.xeno_datum_list[caste_type])
		caste = GLOB.xeno_datum_list[caste_type]

	used_burrow = TRUE

	to_chat(src, SPAN_XENOWARNING("我们开始钻入地下。"))
	if(!do_after(src, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
		return
	// TODO Make immune to all damage here.
	to_chat(src, SPAN_XENOWARNING("我们钻入了地下。"))
	invisibility = 101
	alpha = 100
	anchored = TRUE
	if(caste.fire_immunity == FIRE_IMMUNITY_NONE)
		RegisterSignal(src, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_immune))
		RegisterSignal(src, list(
				COMSIG_LIVING_FLAMER_CROSSED,
				COMSIG_LIVING_FLAMER_FLAMED,
		), PROC_REF(flamer_crossed_immune))
	add_traits(list(TRAIT_ABILITY_BURROWED, TRAIT_UNDENSE, TRAIT_IMMOBILIZED), TRAIT_SOURCE_ABILITY("Burrow"))
	playsound(src.loc, 'sound/effects/burrowing_b.ogg', 25)
	update_icons()
	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
	burrow_timer = world.time + 90 // How long we can be burrowed
	process_burrow()

/mob/living/carbon/xenomorph/proc/process_burrow()
	if(!HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return
	if(world.time > burrow_timer && !tunnel)
		burrow_off()
	if(observed_xeno)
		overwatch(observed_xeno, TRUE)
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		addtimer(CALLBACK(src, PROC_REF(process_burrow)), 1 SECONDS)

/mob/living/carbon/xenomorph/proc/burrow_off()
	if(caste_type && GLOB.xeno_datum_list[caste_type])
		caste = GLOB.xeno_datum_list[caste_type]
	to_chat(src, SPAN_NOTICE("我们回到了地表。"))
	if(caste.fire_immunity == FIRE_IMMUNITY_NONE)
		UnregisterSignal(src, list(
				COMSIG_LIVING_PREIGNITION,
				COMSIG_LIVING_FLAMER_CROSSED,
				COMSIG_LIVING_FLAMER_FLAMED,
		))
	remove_traits(list(TRAIT_ABILITY_BURROWED, TRAIT_UNDENSE, TRAIT_IMMOBILIZED), TRAIT_SOURCE_ABILITY("Burrow"))
	invisibility = FALSE
	alpha = initial(alpha)
	anchored = FALSE
	playsound(loc, 'sound/effects/burrowoff.ogg', 25)
	for(var/mob/living/carbon/mob in loc)
		if(!can_not_harm(mob))
			mob.apply_effect(2, WEAKEN)

	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
	update_icons()

/mob/living/carbon/xenomorph/proc/do_burrow_cooldown()
	used_burrow = FALSE
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_NOTICE("我们现在可以返回地表了。"))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()


/mob/living/carbon/xenomorph/proc/tunnel(turf/T)
	if(!check_state())
		return

	if(!HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_NOTICE("我们必须钻入地下才能这样做。"))
		return

	if(tunnel)
		tunnel = FALSE
		to_chat(src, SPAN_NOTICE("我们停止挖掘隧道。"))
		used_tunnel = TRUE
		addtimer(CALLBACK(src, PROC_REF(do_tunnel_cooldown)), (caste ? caste.tunnel_cooldown : 5 SECONDS))
		return

	if(used_tunnel)
		to_chat(src, SPAN_NOTICE("我们得等一会儿才能这样做。"))
		return

	if(!T)
		to_chat(src, SPAN_NOTICE("我们无法挖掘通往那里的隧道！"))
		return

	if(T.density)
		to_chat(src, SPAN_XENOWARNING("我们无法挖进实心墙里！"))
		return

	if(istype(T, /turf/open/space))
		to_chat(src, SPAN_XENOWARNING("我们挖的是隧道，不是虫洞！"))
		return

	if(clone) //Prevents tunnels in Z transition areas
		to_chat(src, SPAN_XENOWARNING("我们挖的是隧道，不是虫洞！"))
		return

	var/area/A = get_area(T)
	if(A.flags_area & AREA_NOTUNNEL || get_dist(src, T) > 15)
		to_chat(src, SPAN_XENOWARNING("无法挖掘通往那里的隧道。"))
		return

	for(var/obj/O in T.contents)
		if(O.density)
			if(O.flags_atom & ON_BORDER)
				continue
			to_chat(src, SPAN_WARNING("那里有坚固的东西，挡住了我们出土的路。"))
			return

	if(!T || T.density)
		to_chat(src, SPAN_NOTICE("我们无法挖到那里！"))
	tunnel = TRUE
	to_chat(src, SPAN_NOTICE("我们开始挖掘隧道！"))
	tunnel_timer = (get_dist(src, T)*10) + world.time
	process_tunnel(T)


/mob/living/carbon/xenomorph/proc/process_tunnel(turf/T)
	if(!tunnel)
		return

	if(world.time > tunnel_timer)
		tunnel = FALSE
		do_tunnel(T)
	if(tunnel && T)
		addtimer(CALLBACK(src, PROC_REF(process_tunnel), T), 1 SECONDS)

/mob/living/carbon/xenomorph/proc/do_tunnel(turf/T)
	to_chat(src, SPAN_NOTICE("我们沿隧道抵达了目的地。"))
	anchored = FALSE
	forceMove(T)
	burrow_off()

/mob/living/carbon/xenomorph/proc/do_tunnel_cooldown()
	used_tunnel = FALSE
	to_chat(src, SPAN_NOTICE("我们现在可以在地下挖掘隧道了。"))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()

/mob/living/carbon/xenomorph/proc/rename_tunnel(obj/structure/tunnel/T in oview(1))
	set name = "重命名隧道"
	set desc = "修改隧道的名称。"
	set category = null

	if(!istype(T))
		return

	var/new_name = strip_html(input("修改隧道说明：", "隧道说明") as text|null)
	new_name = replace_non_alphanumeric_plus(new_name)
	if(new_name)
		new_name = "[new_name] ([get_area_name(T)])"
		log_admin("[key_name(src)] has renamed the tunnel \"[T.tunnel_desc]\" as \"[new_name]\".")
		msg_admin_niche("[src]/([key_name(src)]) has renamed the tunnel \"[T.tunnel_desc]\" as \"[new_name]\".")
		T.tunnel_desc = "[new_name]"
	return

/datum/action/xeno_action/onclick/tremor/action_cooldown_check()
	var/mob/living/carbon/xenomorph/xeno = owner
	return !xeno.used_tremor

/mob/living/carbon/xenomorph/proc/tremor() //More support focused version of crusher earthquakes.
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED) || is_ventcrawling)
		to_chat(src, SPAN_XENOWARNING("我们必须回到地表才能这样做。"))
		return

	if(!check_state())
		return

	if(used_tremor)
		to_chat(src, SPAN_XENOWARNING("我们还没准备好再次引发震颤！"))
		return

	if(!check_plasma(100)) return

	use_plasma(100)
	playsound(loc, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
	visible_message(SPAN_XENODANGER("[src]钻入地面，撼动大地，引发猛烈震颤！"), \
	SPAN_XENODANGER("我们钻入地面，撼动大地，引发猛烈震颤！"))
	create_stomp() //Adds the visual effect. Wom wom wom
	used_tremor = 1

	for(var/mob/living/carbon/carbon_target in range(7, loc))
		to_chat(carbon_target, SPAN_WARNING("脚下的大地震动，你竭力保持站稳！"))
		shake_camera(carbon_target, 2, 3)
		if(get_dist(loc, carbon_target) <= 3 && !src.can_not_harm(carbon_target))
			if(carbon_target.mob_size >= MOB_SIZE_BIG)
				carbon_target.apply_effect(1, SLOW)
			else
				carbon_target.apply_effect(1, WEAKEN)
			to_chat(carbon_target, SPAN_WARNING("猛烈的震颤让你失去了平衡！"))

	spawn(caste.tremor_cooldown)
		used_tremor = 0
		to_chat(src, SPAN_NOTICE("我们已积蓄足够力量，可以再次引发震颤。"))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()
