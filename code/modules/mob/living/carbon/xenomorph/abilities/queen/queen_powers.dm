// devolve a xeno - lots of old, vaguely shitty code here
/datum/action/xeno_action/onclick/manage_hive/proc/de_evolve_other()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	var/plasma_cost_devolve = 500
	if(!user_xeno.check_state())
		return
	if(!user_xeno.observed_xeno)
		to_chat(user_xeno, SPAN_WARNING("你必须先监视要退化的异形。"))
		return

	var/mob/living/carbon/xenomorph/target_xeno = user_xeno.observed_xeno
	if(!user_xeno.check_plasma(plasma_cost_devolve))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno]不属于你的巢群！"))
		return

	if(target_xeno.is_ventcrawling)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno]无法在此处退化。"))
		return

	if(!isturf(target_xeno.loc))
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno]无法在此处退化。"))
		return

	if(target_xeno.health <= 0)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno]太虚弱，无法退化。"))
		return

	if(length(target_xeno.caste.deevolves_to) < 1)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno]无法退化。"))
		return

	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno]已被放逐，无法退化。"))
		return


	var/newcaste

	if(length(target_xeno.caste.deevolves_to) == 1)
		newcaste = target_xeno.caste.deevolves_to[1]
	else if(length(target_xeno.caste.deevolves_to) > 1)
		newcaste = tgui_input_list(user_xeno, "选择要将 [target_xeno] 退化成的品级。", "退化", target_xeno.caste.deevolves_to, theme="hive_status")

	if(!newcaste)
		return

	if(newcaste == "Larva")
		to_chat(user_xeno, SPAN_XENOWARNING("你无法将异形退化为幼体。"))
		return

	if (user_xeno.observed_xeno != target_xeno)
		return

	var/confirm = tgui_alert(user_xeno, "确定要将 [target_xeno] 从 [target_xeno.caste.caste_type] 退化为 [newcaste] 吗？", "退化", list("Yes", "No"))
	if(confirm != "Yes")
		return

	var/reason = stripped_input(user_xeno, "请说明将异形 [target_xeno] 退化的理由。")
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("你必须说明将[target_xeno]退化的理由。"))
		return

	if (!check_and_use_plasma_owner(plasma_cost))
		return

	to_chat(target_xeno, SPAN_XENOWARNING("女王正将你退化，理由如下：[reason]"))

	var/xeno_type
	var/level_to_switch_to = target_xeno.get_vision_level()
	switch(newcaste)
		if(XENO_CASTE_RUNNER)
			xeno_type = /mob/living/carbon/xenomorph/runner
		if(XENO_CASTE_DRONE)
			xeno_type = /mob/living/carbon/xenomorph/drone
		if(XENO_CASTE_SENTINEL)
			xeno_type = /mob/living/carbon/xenomorph/sentinel
		if(XENO_CASTE_SPITTER)
			xeno_type = /mob/living/carbon/xenomorph/spitter
		if(XENO_CASTE_LURKER)
			xeno_type = /mob/living/carbon/xenomorph/lurker
		if(XENO_CASTE_WARRIOR)
			xeno_type = /mob/living/carbon/xenomorph/warrior
		if(XENO_CASTE_DEFENDER)
			xeno_type = /mob/living/carbon/xenomorph/defender
		if(XENO_CASTE_BURROWER)
			xeno_type = /mob/living/carbon/xenomorph/burrower
	var/obj/item/organ/xeno/organ = locate() in src
	if(!isnull(organ))
		qdel(organ)
	//From there, the new xeno exists, hopefully
	var/mob/living/carbon/xenomorph/new_xeno = new xeno_type(get_turf(target_xeno), target_xeno)

	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(user_xeno, SPAN_WARNING("发生严重错误，未能生成你的新异形！请立即联系开发者！"))
		if(new_xeno)
			qdel(new_xeno)
		return

	if(target_xeno.mind)
		target_xeno.mind.transfer_to(new_xeno)
	else
		new_xeno.key = target_xeno.key
		if(new_xeno.client)
			new_xeno.client.change_view(GLOB.world_view_size)
			new_xeno.client.pixel_x = 0
			new_xeno.client.pixel_y = 0

	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()
	if(new_xeno.client)
		new_xeno.set_lighting_alpha(level_to_switch_to)
	// If the player has self-deevolved before, don't allow them to do it again
	if(!(/mob/living/carbon/xenomorph/verb/Deevolve in target_xeno.verbs))
		remove_verb(new_xeno, /mob/living/carbon/xenomorph/verb/Deevolve)

	new_xeno.visible_message(SPAN_XENODANGER("一只[new_xeno.caste.display_name || new_xeno.caste.caste_type]从[target_xeno]的躯壳中钻出。"), \
	SPAN_XENODANGER("[user_xeno]使我们退回了原先的形态。"))

	if(user_xeno.hive.living_xeno_queen && user_xeno.hive.living_xeno_queen.observed_xeno == target_xeno)
		user_xeno.hive.living_xeno_queen.overwatch(new_xeno)

	message_admins("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")
	log_admin("[key_name_admin(user_xeno)] has deevolved [key_name_admin(target_xeno)]. Reason: [reason]")

	target_xeno.transfer_observers_to(new_xeno)

	if(GLOB.round_statistics && !new_xeno.statistic_exempt)
		GLOB.round_statistics.track_new_participant(target_xeno.faction, -1) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.stop_tracking(target_xeno)
	SSround_recording.recorder.track_player(new_xeno)
	qdel(target_xeno)
	return

/datum/action/xeno_action/onclick/remove_eggsac/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return

	if(X.action_busy) return
	var/answer = alert(X, "确定要移除产卵器吗？（再次生长需要等待5分钟。）", , "Yes", "No")
	if(answer != "Yes")
		return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.visible_message(SPAN_XENOWARNING("[X]开始将身体从产卵器上分离！"), \
		SPAN_XENOWARNING("你开始将身体从产卵器上分离。"))
	if(!do_after(X, 50, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 10)) return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.dismount_ovipositor()
	return ..()

/datum/action/xeno_action/onclick/grow_ovipositor/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!xeno.check_state())
		return

	var/turf/current_turf = get_turf(xeno)
	if(!current_turf || !istype(current_turf))
		return

	if(!action_cooldown_check())
		to_chat(xeno, SPAN_XENOWARNING("你仍在从脱离旧产卵器的状态中恢复。请等待[DisplayTimeText(timeleft(cooldown_timer_id))]。"))
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(xeno, SPAN_XENOWARNING("你必须站在树脂上，才能生长产卵器。"))
		return

	if(SSinterior.in_interior(xeno))
		to_chat(xeno, SPAN_XENOWARNING("这里太狭窄，无法生长产卵器。"))
		return

	if(alien_weeds.linked_hive.hivenumber != xeno.hivenumber)
		to_chat(xeno, SPAN_XENOWARNING("这些菌毯不属于你的虫巢！你不能在这里生长产卵器。"))
		return

	if(!xeno.check_alien_construction(current_turf))
		return

	if(xeno.action_busy)
		return

	if(!xeno.check_plasma(plasma_cost))
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno]开始生长产卵器。"), \
	SPAN_XENOWARNING("你开始生长产卵器……需要二十秒，请保持不动。"))
	if(!do_after(xeno, 200, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, numticks = 20) && xeno.check_plasma(plasma_cost))
		return
	if(!xeno.check_state()) return
	if(!locate(/obj/effect/alien/weeds) in current_turf)
		return
	xeno.use_plasma(plasma_cost)
	xeno.visible_message(SPAN_XENOWARNING("[xeno]长出了产卵器！"), \
	SPAN_XENOWARNING("你长出了产卵器！"))
	xeno.mount_ovipositor()
	return ..()

/datum/action/xeno_action/onclick/set_xeno_lead/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return
	var/datum/hive_status/hive = X.hive
	if(X.observed_xeno)
		if(!length(hive.open_xeno_leader_positions) && X.observed_xeno.hive_pos == NORMAL_XENO)
			to_chat(X, SPAN_XENOWARNING("你当前已任命[length(hive.xeno_leader_list)]位领袖。力量增强前，无法维持更多领袖。"))
			return
		var/mob/living/carbon/xenomorph/T = X.observed_xeno
		if(T == X)
			to_chat(X, SPAN_XENOWARNING("你不能将自己任命为领袖！"))
			return
		apply_cooldown()
		if(T.hive_pos == NORMAL_XENO)
			if(!hive.add_hive_leader(T))
				to_chat(X, SPAN_XENOWARNING("无法任命领袖。"))
				return
			to_chat(X, SPAN_XENONOTICE("你选定[T]为虫巢领袖。"))
			to_chat(T, SPAN_XENOANNOUNCE("[X]任命你为虫巢领袖，其他异形必须听从你。你也将成为女王信息素的信标。"))
		else
			hive.remove_hive_leader(T)
			to_chat(X, SPAN_XENONOTICE("你撤去了[T]的虫巢领袖职务。"))
			to_chat(T, SPAN_XENOANNOUNCE("[X]撤去了你的虫巢领袖职务，你的领导权限和能力随之消退。"))
	else
		var/list/possible_xenos = list()
		for(var/mob/living/carbon/xenomorph/T in hive.xeno_leader_list)
			possible_xenos += T

		if(length(possible_xenos) > 1)
			var/mob/living/carbon/xenomorph/selected_xeno = tgui_input_list(X, "目标", "要监控哪位领袖？", possible_xenos, theme="hive_status")
			if(!selected_xeno || selected_xeno.hive_pos == NORMAL_XENO || selected_xeno == X.observed_xeno || selected_xeno.stat == DEAD || selected_xeno.z != X.z || !X.check_state())
				return
			X.overwatch(selected_xeno)
		else if(length(possible_xenos))
			X.overwatch(possible_xenos[1])
		else
			to_chat(X, SPAN_XENOWARNING("没有异形领袖。监视一只异形即可任命其为领袖。"))
	return ..()

/datum/action/xeno_action/activable/queen_heal/use_ability(atom/A, verbose)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/T = get_turf(A)
	if(!T)
		to_chat(X, SPAN_WARNING("你必须选择有效地格，才能治疗周围目标。"))
		return

	if(X.loc.z != T.loc.z)
		to_chat(X, SPAN_XENOWARNING("距离太远，无法在这里这样做。"))
		return

	if(!check_and_use_plasma_owner())
		return

	for(var/mob/living/carbon/xenomorph/Xa in range(4, T))
		if(!X.can_not_harm(Xa))
			continue

		if(SEND_SIGNAL(Xa, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			if(verbose)
				to_chat(X, SPAN_XENOMINORWARNING("你无法治疗[Xa]！"))
			continue

		if(Xa == X)
			continue

		if(Xa.stat == DEAD || QDELETED(Xa))
			continue

		if(!Xa.caste.can_be_queen_healed)
			continue

		new /datum/effects/heal_over_time(Xa, Xa.maxHealth * 0.3, 2 SECONDS, 2)
		Xa.flick_heal_overlay(3 SECONDS, "#D9F500") //it's already hard enough to gauge health without hp overlays!

	apply_cooldown()
	to_chat(X, SPAN_XENONOTICE("你引导等离子体，治疗此区域周围姐妹的伤口。"))
	return ..()

/datum/action/xeno_action/onclick/manage_hive/proc/give_evo_points()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	var/plasma_cost_givepoints = 100


	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost_givepoints))
		return

	if(world.time < SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK)
		to_chat(usr, SPAN_XENOWARNING("必须先给幼虫一些生成时间，才能献祭。请再等[floor((SSticker.mode.round_time_lobby + SHUTTLE_TIME_LOCK - world.time) / 600)]分钟。"))
		return

	var/choice = tgui_input_list(user_xeno, "选择要以地底幼体为代价、给予进化点数的异形：", "给予进化点数", user_xeno.hive.totalXenos, theme="hive_status")

	if(!choice)
		return
	var/evo_points_per_larva = 250
	var/required_larva = 1
	var/mob/living/carbon/xenomorph/target_xeno

	for(var/mob/living/carbon/xenomorph/xeno in user_xeno.hive.totalXenos)
		if(html_encode(xeno.name) == html_encode(choice))
			target_xeno = xeno
			break

	if(target_xeno == user_xeno)
		to_chat(user_xeno, SPAN_XENOWARNING("你不能给自己进化点数。"))
		return

	if(target_xeno.evolution_stored == target_xeno.evolution_threshold)
		to_chat(user_xeno, SPAN_XENOWARNING("这只异形已经可以进化了！"))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("这只异形不属于你的虫巢！"))
		return

	if(target_xeno.health < 0)
		to_chat(user_xeno, SPAN_XENOWARNING("有什么意义？它马上就要死了。"))
		return

	if(user_xeno.hive.stored_larva < required_larva)
		to_chat(user_xeno, SPAN_XENOWARNING("至少需要[required_larva]只潜伏幼虫，才能献祭一只换取进化点数。"))
		return

	if(tgui_alert(user_xeno, "确定要牺牲一只幼体，为 [target_xeno] 提供 [evo_points_per_larva] 点进化点数吗？", "给予进化点数", list("Yes", "No")) != "Yes")
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost) || target_xeno.health < 0 || user_xeno.hive.stored_larva < required_larva)
		return

	to_chat(target_xeno, SPAN_XENOWARNING("[user_xeno]给予了你进化点数！好好利用。"))
	to_chat(user_xeno, SPAN_XENOWARNING("[target_xeno]获得了[evo_points_per_larva]进化点数。"))

	if(target_xeno.evolution_stored + evo_points_per_larva > target_xeno.evolution_threshold)
		target_xeno.evolution_stored = target_xeno.evolution_threshold
	else
		target_xeno.evolution_stored += evo_points_per_larva

	user_xeno.hive.stored_larva--
	return



/datum/action/xeno_action/onclick/manage_hive/proc/give_jelly_reward()
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	var/plasma_cost_jelly = 500
	if(!xeno.check_state())
		return
	if(!xeno.check_plasma(plasma_cost_jelly))
		return
	if(give_jelly_award(xeno.hive))
		xeno.use_plasma(plasma_cost_jelly)
		return
/datum/action/xeno_action/onclick/manage_hive/use_ability(atom/Atom)
	var/mob/living/carbon/xenomorph/queen/queen_manager = owner
	plasma_cost = 0
	var/list/options = list("Banish (500)", "Re-Admit (100)", "De-evolve (500)", "Reward Jelly (500)", "Exchange larva for evolution (100)",)
	if(queen_manager.hive.hivenumber == XENO_HIVE_CORRUPTED)
		var/datum/hive_status/corrupted/hive = queen_manager.hive
		options += "Add Personal Ally"
		if(length(hive.personal_allies))
			options += "Remove Personal Ally"
			options += "Clear Personal Allies"

	var/choice = localized_input_list(queen_manager, "管理巢群", "巢群管理",  options, theme="hive_status")
	switch(choice)
		if("Banish (500)")
			banish()
		if("Re-Admit (100)")
			readmit()
		if("De-evolve (500)")
			de_evolve_other()
		if("Reward Jelly (500)")
			give_jelly_reward(queen_manager.hive)
		if("Exchange larva for evolution (100)")
			give_evo_points()
		if("Add Personal Ally")
			add_personal_ally()
		if("Remove Personal Ally")
			remove_personal_ally()
		if("Clear Personal Allies")
			clear_personal_allies()
	return ..()

/datum/action/xeno_action/onclick/manage_hive/proc/add_personal_ally()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(user_xeno.hive.hivenumber != XENO_HIVE_CORRUPTED)
		return

	if(!user_xeno.check_state())
		return

	var/datum/hive_status/corrupted/hive = user_xeno.hive
	var/list/target_list = list()
	if(!user_xeno.client)
		return
	for(var/mob/living/carbon/human/possible_target in range(7, user_xeno.client.eye))
		if(possible_target.stat == DEAD)
			continue
		if(possible_target.status_flags & CORRUPTED_ALLY)
			continue
		if(possible_target.hivenumber)
			continue
		target_list += possible_target

	if(!length(target_list))
		to_chat(user_xeno, SPAN_WARNING("视野内没有高个子。"))
		return
	var/mob/living/target_mob = tgui_input_list(usr, "目标", "与以下对象建立个人同盟……", target_list, theme="hive_status")

	if(!user_xeno.check_state(TRUE))
		return

	if(!target_mob)
		return

	if(target_mob.hivenumber)
		to_chat(user_xeno, SPAN_WARNING("我们不能与虫巢信徒建立私人联盟。"))
		return

	hive.add_personal_ally(target_mob)

/datum/action/xeno_action/onclick/manage_hive/proc/remove_personal_ally()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(user_xeno.hive.hivenumber != XENO_HIVE_CORRUPTED)
		return

	if(!user_xeno.check_state())
		return

	var/datum/hive_status/corrupted/hive = user_xeno.hive

	if(!length(hive.personal_allies))
		to_chat(user_xeno, SPAN_WARNING("我们没有私人盟友。"))
		return

	var/list/mob/living/allies = list()
	var/list/datum/weakref/dead_refs = list()
	for(var/datum/weakref/ally_ref as anything in hive.personal_allies)
		var/mob/living/ally = ally_ref.resolve()
		if(ally)
			allies += ally
			continue
		dead_refs += ally_ref

	hive.personal_allies -= dead_refs

	if(!length(allies))
		to_chat(user_xeno, SPAN_WARNING("我们没有私人盟友。"))
		return

	var/mob/living/target_mob = tgui_input_list(usr, "目标", "与以下对象解除个人同盟……", allies, theme="hive_status")

	if(!target_mob)
		return

	var/target_mob_ref = WEAKREF(target_mob)

	if(!(target_mob_ref in hive.personal_allies))
		return

	if(!user_xeno.check_state(TRUE))
		return

	hive.remove_personal_ally(target_mob_ref)

/datum/action/xeno_action/onclick/manage_hive/proc/clear_personal_allies()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	if(user_xeno.hive.hivenumber != XENO_HIVE_CORRUPTED)
		return

	if(!user_xeno.check_state())
		return

	var/datum/hive_status/corrupted/hive = user_xeno.hive
	if(!length(hive.personal_allies))
		to_chat(user_xeno, SPAN_WARNING("我们没有私人盟友。"))
		return

	if(tgui_alert(user_xeno, "确定要清除个人盟友吗？", "清除个人盟友", list("No", "Yes"), 10 SECONDS) != "Yes")
		return

	if(!length(hive.personal_allies))
		return

	hive.clear_personal_allies()


/datum/action/xeno_action/onclick/manage_hive/proc/banish()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	var/plasma_cost_banish = 500
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost_banish))
		return

	var/choice = tgui_input_list(user_xeno, "选择要放逐的异形：", "放逐", user_xeno.hive.totalXenos, theme="hive_status")

	if(!choice)
		return

	var/mob/living/carbon/xenomorph/target_xeno

	for(var/mob/living/carbon/xenomorph/xeno in user_xeno.hive.totalXenos)
		if(html_encode(xeno.name) == html_encode(choice))
			target_xeno = xeno
			break

	if(target_xeno == user_xeno)
		to_chat(user_xeno, SPAN_XENOWARNING("你不能放逐自己。"))
		return

	if(target_xeno.banished)
		to_chat(user_xeno, SPAN_XENOWARNING("这只异形已经被放逐了！"))
		return

	if(target_xeno.hivenumber != user_xeno.hivenumber)
		to_chat(user_xeno, SPAN_XENOWARNING("这只异形不属于你的虫巢！"))
		return

	// No banishing critted xenos
	if(target_xeno.health < 0)
		to_chat(user_xeno, SPAN_XENOWARNING("有什么意义？它已经快死了。"))
		return

	var/confirm = tgui_alert(user_xeno, "确定要将 [target_xeno] 放逐出巢群吗？必须有充分理由才能这么做。（除非重新接纳，否则其死亡后30分钟内也无法重新加入巢群。）", "放逐", list("Yes", "No"))
	if(confirm != "Yes")
		return

	var/reason = stripped_input(user_xeno, "请说明放逐 [target_xeno] 的理由。这将向整个巢群公告！")
	if(!reason)
		to_chat(user_xeno, SPAN_XENOWARNING("你必须说明放逐[target_xeno]的理由。"))
		return

	if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost_banish) || target_xeno.health < 0)
		return

	// Let everyone know they were banished
	xeno_announcement("遵照[user_xeno]的意志，[target_xeno]已被放逐出虫巢！\n\n[reason]", user_xeno.hivenumber, title=SPAN_ANNOUNCEMENT_HEADER_BLUE("放逐"))
	to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("[user_xeno]将你放逐出了虫巢！其他异形现在可以自由攻击你，但你与虫巢意志的联系仍在，无法伤害其他姐妹。")))

	target_xeno.banished = TRUE
	target_xeno.hud_update_banished()
	target_xeno.lock_evolve = TRUE
	user_xeno.hive.banished_ckeys[target_xeno.name] = target_xeno.ckey
	addtimer(CALLBACK(src, PROC_REF(remove_banish), user_xeno.hive, target_xeno.name), 30 MINUTES)

	message_admins("[key_name_admin(user_xeno)] has banished [key_name_admin(target_xeno)]. Reason: [reason]")
	return

/datum/action/xeno_action/proc/remove_banish(datum/hive_status/hive, name)
	hive.banished_ckeys.Remove(name)


// Readmission = un-banish

/datum/action/xeno_action/onclick/manage_hive/proc/readmit()
	var/mob/living/carbon/xenomorph/queen/user_xeno = owner
	var/plasma_cost_readmit = 100
	if(!user_xeno.check_state())
		return

	if(!user_xeno.check_plasma(plasma_cost_readmit))
		return

	var/choice = tgui_input_list(user_xeno, "选择要重新接纳的异形：", "重新接纳", user_xeno.hive.banished_ckeys, theme="hive_status")

	if(!choice)
		return

	var/banished_ckey
	var/banished_name

	for(var/mob_name in user_xeno.hive.banished_ckeys)
		if(user_xeno.hive.banished_ckeys[mob_name] == user_xeno.hive.banished_ckeys[choice])
			banished_ckey = user_xeno.hive.banished_ckeys[mob_name]
			banished_name = mob_name
			break

	var/banished_living = FALSE
	var/mob/living/carbon/xenomorph/target_xeno

	for(var/mob/living/carbon/xenomorph/xeno in user_xeno.hive.totalXenos)
		if(xeno.ckey == banished_ckey)
			target_xeno = xeno
			banished_living = TRUE
			break

	if(banished_living)
		if(!target_xeno.banished)
			to_chat(user_xeno, SPAN_XENOWARNING("这只异形没有被放逐！"))
			return

		var/confirm = tgui_alert(user_xeno, "确定要重新接纳 [target_xeno] 加入巢群吗？", "重新接纳", list("Yes", "No"))
		if(confirm != "Yes")
			return

		if(!user_xeno.check_state() || !check_and_use_plasma_owner(plasma_cost))
			return

		to_chat(target_xeno, FONT_SIZE_LARGE(SPAN_XENOWARNING("[user_xeno]重新接纳你加入虫巢。")))
		target_xeno.banished = FALSE
		target_xeno.hud_update_banished()
		target_xeno.lock_evolve = FALSE

	user_xeno.hive.banished_ckeys.Remove(banished_name)
	return

/datum/action/xeno_action/onclick/eye
	name = "Enter Eye Form"
	action_icon_state = "queen_eye"
	plasma_cost = 0

/datum/action/xeno_action/onclick/eye/use_ability(atom/A)
	. = ..()
	if(!owner)
		return

	new /mob/hologram/queen(owner.loc, owner)
	qdel(src)

/datum/action/xeno_action/activable/expand_weeds
	var/list/recently_built_turfs

/datum/action/xeno_action/activable/expand_weeds/New(Target, override_icon_state)
	. = ..()
	recently_built_turfs = list()

/datum/action/xeno_action/activable/expand_weeds/Destroy()
	recently_built_turfs = null
	return ..()

/datum/action/xeno_action/activable/expand_weeds/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	var/turf/T = get_turf(A)

	if(!T || T.is_weedable() < FULLY_WEEDABLE || T.density || (T.z != X.z))
		to_chat(X, SPAN_XENOWARNING("你不能在这里这样做。"))
		return

	var/area/AR = get_area(T)
	if(!AR.is_resin_allowed)
		if(AR.flags_area & AREA_UNWEEDABLE)
			to_chat(X, SPAN_XENOWARNING("这片区域不适合建立巢群！"))
			return
		to_chat(X, SPAN_XENOWARNING("现在还太早，无法将巢群扩展到这么远。"))
		return

	var/obj/effect/alien/weeds/located_weeds = locate() in T
	if(located_weeds)
		if(istype(located_weeds, /obj/effect/alien/weeds/node))
			return

		if(located_weeds.weed_strength > X.weed_level)
			to_chat(X, SPAN_XENOWARNING("这里已经有更强的菌毯节点！"))
			return

		if (!check_and_use_plasma_owner(node_plant_plasma_cost))
			return

		to_chat(X, SPAN_XENONOTICE("你在[T]种下了节点。"))
		new /obj/effect/alien/weeds/node(T, null, X)
		playsound(T, "alien_resin_build", 35)
		apply_cooldown_override(node_plant_cooldown)
		return

	var/obj/effect/alien/weeds/node/node
	for(var/direction in GLOB.cardinals)
		var/turf/weed_turf = get_step(T, direction)
		var/obj/effect/alien/weeds/W = locate() in weed_turf
		if(W && W.hivenumber == X.hivenumber && W.parent && !W.hibernate && !LinkBlocked(W, weed_turf, T))
			node = W.parent
			break

	if(!node)
		to_chat(X, SPAN_XENOWARNING("只能在已连接节点的菌毯附近铺设菌毯！"))
		return

	if(T in recently_built_turfs)
		to_chat(X, SPAN_XENOWARNING("你最近刚在这里建造过！"))
		return

	if (!check_and_use_plasma_owner())
		return

	new /obj/effect/alien/weeds(T, node, FALSE)
	playsound(T, "alien_resin_build", 35)

	recently_built_turfs += T
	addtimer(CALLBACK(src, PROC_REF(reset_turf_cooldown), T), turf_build_cooldown)

	to_chat(X, SPAN_XENONOTICE("你在[T]铺下了菌毯。"))
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/expand_weeds/proc/reset_turf_cooldown(turf/T)
	recently_built_turfs -= T

/datum/action/xeno_action/activable/place_queen_beacon/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/Q = owner
	if(!Q.check_state())
		return FALSE

	if(Q.action_busy)
		return FALSE

	var/turf/T = get_turf(A)
	if(!check_turf(Q, T))
		return FALSE
	if(!do_after(Q, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		return FALSE
	if(!check_turf(Q, T))
		return FALSE

	for(var/i in transported_xenos)
		UnregisterSignal(i, COMSIG_MOVABLE_PRE_MOVE)

	to_chat(Q, SPAN_XENONOTICE("你召集虫巢前往女王信标！"))
	LAZYCLEARLIST(transported_xenos)
	RegisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN, PROC_REF(tunnel_xeno))
	for(var/xeno in hive.totalXenos)
		if(xeno == Q)
			continue
		tunnel_xeno(src, xeno)

	addtimer(CALLBACK(src, PROC_REF(transport_xenos), T), 3 SECONDS)
	return ..()

/datum/action/xeno_action/activable/place_queen_beacon/proc/tunnel_xeno(datum/source, mob/living/carbon/xenomorph/X)
	SIGNAL_HANDLER
	if(X.z == owner.z)
		to_chat(X, SPAN_XENONOTICE("你开始掘地前往女王信标！"))
		RegisterSignal(X, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(cancel_movement))
		LAZYADD(transported_xenos, X)

/datum/action/xeno_action/activable/place_queen_beacon/proc/transport_xenos(turf/target)
	UnregisterSignal(SSdcs, COMSIG_GLOB_XENO_SPAWN)
	for(var/xeno in transported_xenos)
		var/mob/living/carbon/xenomorph/X = xeno
		to_chat(X, SPAN_XENONOTICE("你掘地抵达了女王信标！"))
		UnregisterSignal(X, COMSIG_MOVABLE_PRE_MOVE)
		if(target)
			X.forceMove(target)

/datum/action/xeno_action/activable/place_queen_beacon/proc/cancel_movement()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_MOVE

/datum/action/xeno_action/activable/place_queen_beacon/proc/check_turf(mob/living/carbon/xenomorph/queen/Q, turf/T)
	if(!T || T.density)
		to_chat(Q, SPAN_XENOWARNING("这里无法放置女王信标。"))
		return FALSE

	if(T.z != Q.z)
		to_chat(Q, SPAN_XENOWARNING("太远了！"))
		return FALSE

	var/obj/effect/alien/weeds/located_weeds = locate() in T
	if(!located_weeds)
		to_chat(Q, SPAN_XENOWARNING("女王信标必须放在菌毯上。"))
		return FALSE

	return TRUE


/datum/action/xeno_action/activable/blockade/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/Q = owner
	if(!Q.check_state())
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	if(Q.action_busy)
		return FALSE

	var/width = initial(pillar_type.width)
	var/height = initial(pillar_type.height)

	var/turf/T = get_turf(A)
	if(T.density)
		to_chat(Q, SPAN_XENOWARNING("这种路障只能建在开阔地带！"))
		return FALSE

	if(T.z != owner.z)
		to_chat(Q, SPAN_XENOWARNING("太远了！"))
		return FALSE

	if(!T.weeds)
		to_chat(Q, SPAN_XENOWARNING("这种路障只能建在菌毯上！"))
		return FALSE

	if(!Q.check_plasma(plasma_cost))
		return

	var/list/alerts = list()
	for(var/i as anything in RANGE_TURFS(floor(width/2), T))
		alerts += new /obj/effect/warning/alien(i)

	if(!do_after(Q, time_taken, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
		QDEL_NULL_LIST(alerts)
		return FALSE
	QDEL_NULL_LIST(alerts)

	if(!check_turf(Q, T))
		return FALSE

	if(!check_and_use_plasma_owner())
		return

	var/turf/new_turf = locate(max(T.x - floor(width/2), 1), max(T.y - floor(height/2), 1), T.z)
	to_chat(Q, SPAN_XENONOTICE("你升起了一道路障！"))
	var/obj/effect/alien/resin/resin_pillar/RP = new pillar_type(new_turf)
	RP.start_decay(brittle_time, decay_time)

	return ..()

/datum/action/xeno_action/activable/blockade/proc/check_turf(mob/living/carbon/xenomorph/queen/Q, turf/T)
	if(T.density)
		to_chat(Q, SPAN_XENOWARNING("这里无法放置路障。"))
		return FALSE

	return TRUE

/mob/living/carbon/xenomorph/proc/xeno_tacmap()
	set name = "查看异形战术地图"
	set desc = "打开战术地图，查看所有异形的位置。"
	set category = "Alien"
	hive.tacmap.tgui_interact(src)

