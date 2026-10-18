/datum/action/xeno_action/onclick/build_tunnel
	name = "Dig Tunnel (200)"
	localized_names = list("Dig Tunnel (200)" = "挖掘隧道（200）")
	action_icon_state = "build_tunnel"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_dig_tunnel
	action_type = XENO_ACTION_ACTIVATE //doesn't really need a macro

/datum/action/xeno_action/onclick/build_tunnel/can_use_action()
	if(!owner)
		return FALSE
	var/mob/living/carbon/xenomorph/X = owner
	if(!istype(X))
		return FALSE
	if(X.tunnel_delay)
		return FALSE
	return ..()

/datum/action/xeno_action/onclick/build_tunnel/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!X.check_state())
		return

	if(X.action_busy)
		to_chat(X, SPAN_XENOWARNING("我们应该先完成手头的动作再挖掘。"))
		return

	var/turf/T = X.loc
	if(!istype(T)) //logic
		to_chat(X, SPAN_XENOWARNING("我们无法从那里这样做。"))
		return

	if(!T.can_dig_xeno_tunnel() || !is_ground_level(T.z))
		to_chat(X, SPAN_XENOWARNING("我们刨了几下，但似乎无法挖穿这种地面。"))
		return

	if(locate(/obj/structure/tunnel) in X.loc)
		to_chat(X, SPAN_XENOWARNING("这里已经有一条隧道了。"))
		return

	if(locate(/obj/structure/machinery/sentry_holder/landing_zone) in X.loc)
		to_chat(X, SPAN_XENOWARNING("这个物体挡住了位置，我们无法挖掘隧道。"))
		return

	if(X.tunnel_delay)
		to_chat(X, SPAN_XENOWARNING("我们还不能再次挖掘隧道。"))
		return

	if(X.get_active_hand())
		to_chat(X, SPAN_XENOWARNING("我们需要一只空爪！"))
		return

	if(!X.check_plasma(plasma_cost))
		return

	var/area/AR = get_area(T)

	if(isnull(AR) || !(AR.is_resin_allowed))
		if(AR.flags_area & AREA_UNWEEDABLE)
			to_chat(X, SPAN_XENOWARNING("这片区域不适合虫巢栖息！"))
			return
		to_chat(X, SPAN_XENOWARNING("现在还太早，不能把虫巢扩张到这么远。"))
		return

	X.visible_message(SPAN_XENONOTICE("[X]开始挖掘隧道入口。"), \
	SPAN_XENONOTICE("我们开始挖掘隧道入口。"), null, 5)
	if(!do_after(X, 100, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(X, SPAN_WARNING("我们停止挖掘，隧道随之塌陷。"))
		return
	if(!X.check_plasma(plasma_cost))
		return
	X.visible_message(SPAN_XENONOTICE("[X]挖出了一处隧道入口。"), \
	SPAN_XENONOTICE("我们挖出了一处通往隧道网络的入口。"), null, 5)

	var/obj/structure/tunnel/tunnelobj = new(T, X.hivenumber)
	X.tunnel_delay = 1
	addtimer(CALLBACK(src, PROC_REF(cooldown_end)), 4 MINUTES)
	var/msg = strip_html(input("为隧道添加描述：", "隧道描述") as text|null)
	msg = replace_non_alphanumeric_plus(msg)
	var/description
	if(msg)
		description = msg
		msg = "[msg] ([get_area_name(tunnelobj)])"
		log_admin("[key_name(X)] has named a new tunnel \"[msg]\".")
		msg_admin_niche("[X]/([key_name(X)]) has named a new tunnel \"[msg]\".")
		tunnelobj.tunnel_desc = "[msg]"

	if(X.hive.living_xeno_queen || X.hive.allow_no_queen_actions)
		for(var/mob/living/carbon/xenomorph/target_for_message as anything in X.hive.totalXenos)
			var/overwatch_target = XENO_OVERWATCH_TARGET_HREF
			var/overwatch_src = XENO_OVERWATCH_SRC_HREF
			to_chat(target_for_message, SPAN_XENOANNOUNCE("虫巢：[X]在<b>[get_area_name(tunnelobj)]</b>建造了一条新隧道[description ? "（[description]）" : ""]（<a href='byond://?src=\ref[target_for_message];[overwatch_target]=\ref[X];[overwatch_src]=\ref[target_for_message]'>观察</a>）。"))

	X.use_plasma(plasma_cost)
	to_chat(X, SPAN_NOTICE("我们将在4分钟后能够挖掘新隧道。"))
	playsound(X.loc, 'sound/weapons/pierce.ogg', 25, 1)

	return ..()

/datum/action/xeno_action/onclick/build_tunnel/proc/cooldown_end()
	var/mob/living/carbon/xenomorph/X = owner
	to_chat(X, SPAN_NOTICE("我们又能挖掘隧道了。"))
	X.tunnel_delay = 0

//Queen Abilities
/datum/action/xeno_action/onclick/screech
	name = "Screech (250)"
	localized_names = list("Screech (250)" = "尖啸（250）")
	action_icon_state = "screech"
	ability_name = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_screech
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 50 SECONDS
	plasma_cost = 250
	cooldown_message = "我们感到喉部肌肉振动，又能发出尖啸了。"
	no_cooldown_msg = FALSE // Needed for onclick actions
	ability_primacy = XENO_SCREECH

/datum/action/xeno_action/onclick/screech/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	//screech is so powerful it kills huggers in our hands
	if(istype(xeno.r_hand, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/hugger = xeno.r_hand
		if(hugger.stat != DEAD)
			hugger.die()

	if(istype(xeno.l_hand, /obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/hugger = xeno.l_hand
		if(hugger.stat != DEAD)
			hugger.die()

	playsound(xeno.loc, pick(xeno.screech_sound_effect_list), 75, 0, status = 0)
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno]发出震耳欲聋的低沉咆哮！"))
	xeno.create_shriekwave(14) //Adds the visual effect. Wom wom wom, 14 shriekwaves

	FOR_DVIEW(var/mob/mob, world.view, owner, HIDE_INVISIBLE_OBSERVER)
		if(mob && mob.client)
			if(isxeno(mob))
				shake_camera(mob, 10, 1)
			else
				shake_camera(mob, 30, 1) //50 deciseconds, SORRY 5 seconds was way too long. 3 seconds now
	FOR_DVIEW_END

	var/list/mobs_in_view = list()
	FOR_DOVIEW(var/mob/living/carbon/M, 7, xeno, HIDE_INVISIBLE_OBSERVER)
		mobs_in_view += M
	FOR_DOVIEW_END
	for(var/mob/living/carbon/M in orange(10, xeno))
		if(SEND_SIGNAL(M, COMSIG_MOB_SCREECH_ACT, xeno) & COMPONENT_SCREECH_ACT_CANCEL)
			continue
		M.handle_queen_screech(xeno, mobs_in_view)

	apply_cooldown()

	return ..()

/datum/action/xeno_action/activable/gut
	name = "Gut (200)"
	localized_names = list("Gut (200)" = "开膛破肚（200）")
	action_icon_state = "gut"
	ability_name = "gut"
	macro_path = /datum/action/xeno_action/verb/verb_gut
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 MINUTES
	plasma_cost = 200
	cooldown_message = "我们感到怒意再次涌起，又能将猎物开膛破肚了。"

/datum/action/xeno_action/activable/gut/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	if(!action_cooldown_check())
		return
	if(xeno.queen_gut(target))
		apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/psychic_whisper
	name = "Psychic Whisper"
	localized_names = list("Psychic Whisper" = "心灵低语")
	action_icon_state = "psychic_whisper"
	plasma_cost = 0

/datum/action/xeno_action/onclick/psychic_whisper/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(xeno_player.client.prefs.muted & MUTE_IC)
		to_chat(xeno_player, SPAN_DANGER("你已被禁言，无法发送低语。"))
		return
	if(!xeno_player.check_state(TRUE))
		return
	var/list/target_list = list()
	for(var/mob/living/carbon/possible_target in view(7, xeno_player))
		if(possible_target == xeno_player || !possible_target.client) continue
		target_list += possible_target

	var/mob/living/carbon/target_mob = tgui_input_list(usr, "目标", "向谁发送心灵低语？", target_list, theme="hive_status")
	if(!target_mob) return

	if(!xeno_player.check_state(TRUE))
		return

	var/whisper = strip_html(input("讯息：", "心灵低语") as text|null)
	if(whisper)
		log_say("PsychicWhisper: [key_name(xeno_player)]->[target_mob.key] : [whisper] (AREA: [get_area_name(target_mob)])")
		if(!istype(target_mob, /mob/living/carbon/xenomorph))
			to_chat(target_mob, SPAN_XENOQUEEN("你的脑海中响起一个陌生而怪异的声音：\"[SPAN_PSYTALK(whisper)]\""))
		else
			to_chat(target_mob, SPAN_XENOQUEEN("[xeno_player]的声音在你的脑海中回响：\"[SPAN_PSYTALK(whisper)]\""))
		to_chat(xeno_player, SPAN_XENONOTICE("你向[target_mob]传递低语：\"[whisper]\""))

		for(var/mob/dead/observer/ghost as anything in GLOB.observer_list)
			if(!ghost.client || isnewplayer(ghost))
				continue
			if(ghost.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
				var/rendered_message
				var/xeno_track = "(<a href='byond://?src=\ref[ghost];track=\ref[xeno_player]'>F</a>)"
				var/target_track = "(<a href='byond://?src=\ref[ghost];track=\ref[target_mob]'>F</a>)"
				rendered_message = SPAN_XENOLEADER("心灵低语：[xeno_player.real_name][xeno_track]对[target_mob.real_name][target_track]说：<span class='normal'>“[SPAN_PSYTALK(whisper)]”</span>")
				ghost.show_message(rendered_message, SHOW_MESSAGE_AUDIBLE)

	return ..()

/datum/action/xeno_action/onclick/psychic_whisper/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno && !xeno.is_mob_incapacitated())
		return TRUE
	return FALSE

/datum/action/xeno_action/onclick/psychic_radiance
	name = "Psychic Radiance"
	localized_names = list("Psychic Radiance" = "心灵广播")
	action_icon_state = "psychic_radiance"
	plasma_cost = 100

/datum/action/xeno_action/onclick/psychic_radiance/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(xeno_player.client.prefs.muted & MUTE_IC)
		to_chat(xeno_player, SPAN_DANGER("你已被禁言，无法发送低语。"))
		return
	if(!xeno_player.check_state(TRUE))
		return
	var/list/target_list = list()
	var/whisper = strip_html(input("讯息：", "心灵广播") as text|null)
	if(!whisper || !xeno_player.check_state(TRUE))
		return
	FOR_DVIEW(var/mob/living/possible_target, 12, xeno_player, HIDE_INVISIBLE_OBSERVER)
		if(possible_target == xeno_player || !possible_target.client)
			continue
		target_list += possible_target
		if(!istype(possible_target, /mob/living/carbon/xenomorph))
			to_chat(possible_target, SPAN_XENOQUEEN("你的脑海中响起一个陌生而怪异的声音：\"[SPAN_PSYTALK(whisper)]\""))
		else
			to_chat(possible_target, SPAN_XENOQUEEN("[xeno_player]的声音在你的脑海中回响：\"[SPAN_PSYTALK(whisper)]\""))
	FOR_DVIEW_END
	if(!length(target_list))
		return
	var/targetstring = english_list(target_list, and_text = "和", comma_text = "、")
	to_chat(xeno_player, SPAN_XENONOTICE("你向[targetstring]传递讯息：\"[whisper]\""))
	log_say("PsychicRadiance: [key_name(xeno_player)]->[targetstring] : [whisper] (AREA: [get_area_name(xeno_player)])")
	for (var/mob/dead/observer/ghost as anything in GLOB.observer_list)
		if(!ghost.client || isnewplayer(ghost))
			continue
		if(ghost.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
			var/rendered_message
			var/xeno_track = "(<a href='byond://?src=\ref[ghost];track=\ref[xeno_player]'>F</a>)"
			rendered_message = SPAN_XENOLEADER("心灵广播：[xeno_player.real_name][xeno_track]向[targetstring]传达：<span class='normal'>“[SPAN_PSYTALK(whisper)]”</span>")
			ghost.show_message(rendered_message, SHOW_MESSAGE_AUDIBLE)
	return ..()

/datum/action/xeno_action/onclick/psychic_radiance/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno && !xeno.is_mob_incapacitated())
		return TRUE
	return FALSE

/datum/action/xeno_action/activable/queen_give_plasma
	name = "Give Plasma (400)"
	localized_names = list("Give Plasma (400)" = "输送等离子体（400）")
	action_icon_state = "queen_give_plasma"
	ability_name = "give plasma"
	plasma_cost = 400
	macro_path = /datum/action/xeno_action/verb/verb_plasma_xeno
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 12 SECONDS

/datum/action/xeno_action/activable/queen_give_plasma/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	var/mob/living/carbon/xenomorph/target = A
	if(!istype(target) || target.stat == DEAD)
		to_chat(X, SPAN_WARNING("你必须选中要输送等离子体的异形。"))
		return

	if(target == X)
		to_chat(X, SPAN_XENOWARNING("你不能给自己输送等离子体！"))
		return

	if(!X.can_not_harm(target))
		to_chat(X, SPAN_WARNING("你只能选中自己虫巢的异形！"))
		return

	if(!target.caste.can_be_queen_healed)
		to_chat(X, SPAN_XENOWARNING("无法向这个阶级输送等离子体！"))
		return

	if(SEND_SIGNAL(target, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
		to_chat(X, SPAN_XENOWARNING("无法向这只异形输送等离子体！"))
		return

	if(!check_and_use_plasma_owner())
		return

	target.gain_plasma(target.plasma_max * 0.75)
	target.flick_heal_overlay(3 SECONDS, COLOR_CYAN)
	apply_cooldown()
	to_chat(X, SPAN_XENONOTICE("你向[target]输送了一些等离子体。"))
	return ..()

/datum/action/xeno_action/onclick/queen_order
	name = "Give Order (100)"
	localized_names = list("Give Order (100)" = "下达命令（100）")
	action_icon_state = "queen_order"
	plasma_cost = 100

/datum/action/xeno_action/onclick/queen_order/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/xenomorph/target = X.observed_xeno
		if(target.stat != DEAD && target.client)
			if(X.check_plasma(plasma_cost))
				var/input = stripped_input(X, "这条讯息将发送给当前监视的异形。", "女皇命令", "")
				if(!input)
					return
				var/queen_order = SPAN_XENOANNOUNCE("<b>[X]</b>向你传来讯息：\"[input]\"")
				if(!X.check_state() || !X.check_plasma(plasma_cost) || X.observed_xeno != target || target.stat == DEAD)
					return
				if(target.client)
					X.use_plasma(plasma_cost)
					to_chat(target, "[queen_order]")
					log_admin("[queen_order]")
					message_admins("[key_name_admin(X)] has given the following Queen order to [target]: \"[input]\"", 1)

	else
		to_chat(X, SPAN_WARNING("你必须先监视想要下达命令的异形。"))
		return
	return ..()

/datum/action/xeno_action/onclick/queen_word
	name = "Word of the Queen (50)"
	localized_names = list("Word of the Queen (50)" = "女皇之言（50）")
	action_icon_state = "queen_word"
	plasma_cost = 50
	xeno_cooldown = 10 SECONDS

/datum/action/xeno_action/onclick/queen_word/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	// We don't test or apply the cooldown here because the proc does it since verbs can activate it too
	xeno.hive_message()
	return ..()

/datum/action/xeno_action/onclick/queen_tacmap
	name = "View Xeno Tacmap"
	localized_names = list("View Xeno Tacmap" = "查看异形战术地图")
	action_icon_state = "toggle_queen_zoom"
	plasma_cost = 0

/datum/action/xeno_action/onclick/queen_tacmap/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/queen/xeno = owner
	xeno.xeno_tacmap()
	return ..()

/////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/carbon/xenomorph/proc/add_abilities()
	if(!base_actions)
		return
	for(var/action_path in base_actions)
		give_action(src, action_path)
