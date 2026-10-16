// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "能力"
	set name = "扑倒"
	set desc = "将目标扑倒。"

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || buckled)
		to_chat(src, "你现在无法扑倒别人。")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = tgui_input_list(src,"你想扑倒谁？", "扑倒", choices)

	if(!T || !src || stat || !Adjacent(T))
		return

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || buckled)
		to_chat(src, "你现在无法进行扑倒。")
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.apply_effect(rand(0.5,3), WEAKEN)
	else
		apply_effect(rand(2,4), WEAKEN)
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1)
	if(failed)
		apply_effect(rand(2,4), WEAKEN)

	for(var/mob/O in viewers(src, null))
		if((O.client && !( O.blinded )))
			O.show_message(SPAN_DANGER("<B>[src][failed ? "试图扑倒" : "扑倒了"][T]！</B>"), SHOW_MESSAGE_VISIBLE)

/mob/living/carbon/human/proc/leap()
	set category = "能力"
	set name = "跃击"
	set desc = "跃向目标并将其牢牢抓住。"

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || body_position != STANDING_UP || buckled)
		to_chat(src, "你现在无法跃击。")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(6,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = tgui_input_list(src,"你想跃向谁？", "跃击", choices)

	if(!T || !src || stat || get_dist(get_turf(T), get_turf(src)) > 6)
		return

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || body_position != STANDING_UP || buckled)
		to_chat(src, "你现在无法跃击。")
		return

	last_special = world.time + 75
	status_flags |= LEAPING

	visible_message(SPAN_WARNING("<b>[src]</b>跃向[T]！"))
	var/target = get_step(get_turf(T), get_turf(src))
	throw_atom(target, 5, SPEED_VERY_FAST, src)
	playsound(loc, 'sound/voice/shriek1.ogg', 25, 1)

	addtimer(CALLBACK(src, PROC_REF(finish_leap), T), 5)

/mob/living/carbon/human/proc/finish_leap(mob/living/T)
	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!Adjacent(T))
		to_chat(src, SPAN_DANGER("你扑空了！"))
		return

	T.apply_effect(5, WEAKEN)

	if(T == src || T.anchored)
		return FALSE

	start_pulling(T)

/mob/living/carbon/human/proc/gut()
	set category = "能力"
	set name = "开膛破肚"
	set desc = "牢牢抓住目标后，将其开膛破肚或撕成碎片。"

	if(last_special > world.time)
		return

	if(is_mob_incapacitated() || body_position != STANDING_UP)
		to_chat(src, SPAN_DANGER("你现在无法这样做。"))
		return

	var/obj/item/grab/G = locate() in src
	if(!G || !istype(G))
		to_chat(src, SPAN_DANGER("你没有抓住任何人。"))
		return

	if(usr.grab_level < GRAB_AGGRESSIVE)
		to_chat(src, SPAN_DANGER("你必须牢牢抓住猎物，才能将其开膛破肚！"))
		return

	last_special = world.time + 50

	visible_message(SPAN_WARNING("<b>[src]</b>用利爪凶狠地撕扯[G.grabbed_thing]的身体！"))

	if(istype(G.grabbed_thing,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.grabbed_thing
		H.apply_damage(50,BRUTE)
		if(H.stat == 2)
			H.gib(create_cause_data("gutting", usr))
	else
		var/mob/living/M = G.grabbed_thing
		if(!istype(M))
			return //wut
		M.apply_damage(50,BRUTE)
		if(M.stat == 2)
			M.gib(create_cause_data("gutting", usr))

/mob/living/carbon/human/proc/commune()
	set category = "能力"
	set name = "心灵交谈"
	set desc = "向一位不幸的接收者传递心灵讯息。"

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = tgui_input_list(usr, "选择交谈对象！", "心灵交谈", targets)

	if(!target)
		return

	text = input("你想说什么？", "心灵交谈", null, null)

	text = trim(strip_html(text))

	if(!text)
		return

	var/mob/M = targets[target]

	if(istype(M, /mob/dead/observer) || M.stat == DEAD)
		to_chat(src, "即使是[species.name]也无法与死者交谈。")
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text] (AREA: [get_area_name(loc)])")

	to_chat(M, SPAN_NOTICE(" 仿佛铅块坠入大海，一股异样的思绪沉入你的脑海：[text]"))
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == species.name)
			return
		to_chat(H, SPAN_DANGER("你的鼻子开始流血……"))
		H.drip(1)

/mob/living/carbon/human/proc/psychic_whisper(mob/target_mob as mob in oview())
	set name = "心灵低语"
	set desc = "从远处向某人无声传递低语。"
	set category = "能力"

	var/whisper = strip_html(input("讯息：", "心灵低语") as text|null)
	if(whisper)
		log_say("PsychicWhisper: [key_name(src)]->[target_mob.key] : [whisper] (AREA: [get_area_name(loc)])")
		to_chat(target_mob, SPAN_XENOWARNING(" 你的脑海中响起一个陌生而怪异的声音……<i>[SPAN_PSYTALK(whisper)]</i>"))
		to_chat(src, SPAN_XENOWARNING(" 你向[target_mob]传递心灵低语：\"[whisper]\""))
		for (var/mob/dead/observer/ghost as anything in GLOB.observer_list)
			if(!ghost.client || isnewplayer(ghost))
				continue
			if(ghost.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
				var/rendered_message
				var/human_track = "(<a href='byond://?src=\ref[ghost];track=\ref[src]'>F</a>)"
				var/target_track = "(<a href='byond://?src=\ref[ghost];track=\ref[target_mob]'>F</a>)"
				rendered_message = SPAN_XENOLEADER("PsychicWhisper: [real_name][human_track] to [target_mob.real_name][target_track], <span class='normal'>'[SPAN_PSYTALK(whisper)]'</span>")
				ghost.show_message(rendered_message, SHOW_MESSAGE_AUDIBLE)
	return

/mob/living/verb/lay_down()
	set name = "休息"
	set category = "IC"
	set_resting(!resting, FALSE, TRUE)

///Proc to hook behavior to the change of value in the resting variable.
/mob/living/proc/set_resting(new_resting, silent = TRUE, instant = FALSE)
	if(!(mobility_flags & MOBILITY_REST))
		return
	if(new_resting == resting)
		return
	if(!COOLDOWN_FINISHED(src, rest_cooldown))
		to_chat(src, SPAN_WARNING("[isxeno(src) ? "我们" : "你"]不能这么频繁地切换休息姿态，缓一缓！"))
		return
	COOLDOWN_START(src, rest_cooldown, 1 SECONDS)

	. = resting
	resting = new_resting
	if(new_resting)
		if(body_position == LYING_DOWN)
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "我们" : "你"]现在会尽量保持躺卧。"))
		else if(HAS_TRAIT(src, TRAIT_FORCED_STANDING) || (buckled && buckled.buckle_lying != NO_BUCKLE_LYING))
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "我们" : "你"]会在[isxeno(src) ? "我们" : "你"]能够行动时立即躺下。"))
		else
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "我们" : "你"]躺下了。"))
			set_lying_down()
	else
		if(body_position == STANDING_UP)
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "我们" : "你"]现在会尽量保持站立。"))
		else if(HAS_TRAIT(src, TRAIT_FLOORED) || (buckled && buckled.buckle_lying != NO_BUCKLE_LYING))
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "我们" : "你"]会在[isxeno(src) ? "我们" : "你"]能够行动时立即站起来。"))
		else
			if(!silent)
				to_chat(src, SPAN_NOTICE("[isxeno(src) ? "我们" : "你"]站了起来。"))
			get_up(instant)

//	SEND_SIGNAL(src, COMSIG_LIVING_RESTING, new_resting, silent, instant)
//	update_resting() // HUD icons

/mob/living/carbon/human/proc/toggle_inherent_nightvison()
	set category = "合成人"
	set name = "切换夜视"
	set desc = "切换自身的夜视能力。"

	if(usr.is_mob_incapacitated())
		return

	default_lighting_alpha = default_lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE ? LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE : LIGHTING_PLANE_ALPHA_VISIBLE
	update_sight()

	to_chat(src, SPAN_NOTICE("你的视野已设为<b>[default_lighting_alpha == LIGHTING_PLANE_ALPHA_VISIBLE ? "普通视野" : "夜视"]</b>。"))

// Used for synthetics
/mob/living/carbon/human/synthetic/proc/toggle_HUD()
	set category = "合成人"
	set name = "切换抬头显示"
	set desc = "切换各种抬头显示功能。"

	if(!issynth(usr) || usr.is_mob_incapacitated())
		return

	var/hud_choice = tgui_input_list(usr, "选择要切换的抬头显示", "切换抬头显示", list("医疗抬头显示", "安保抬头显示"))
	if(usr.is_mob_incapacitated())
		return

	var/datum/mob_hud/H
	var/chosen_HUD = 1
	switch(hud_choice)
		if("医疗抬头显示")
			H = GLOB.huds[MOB_HUD_MEDICAL_ADVANCED]
		if("安保抬头显示")
			H = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
			chosen_HUD = 2
		else
			return

	if(synthetic_HUD_toggled[chosen_HUD])
		synthetic_HUD_toggled[chosen_HUD] = FALSE
		H.remove_hud_from(src, src)
		to_chat(src, SPAN_INFO("<B>[hud_choice]已禁用</B>"))
	else
		synthetic_HUD_toggled[chosen_HUD] = TRUE
		H.add_hud_to(src, src)
		to_chat(src, SPAN_INFO("<B>[hud_choice]已启用</B>"))
