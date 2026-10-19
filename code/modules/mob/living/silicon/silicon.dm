/mob/living/silicon
	gender = NEUTER
	voice_name = "合成语音"
	var/syndicate = 0
	immune_to_ssd = 1
	var/list/speech_synthesizer_langs = list() //which languages can be vocalized by the speech synthesizer

	//Used in say.dm.
	var/speak_statement = "陈述道"
	var/speak_exclamation = "宣告道"
	var/speak_query = "询问道"
	var/pose //Yes, now AIs can pose too.
	var/local_transmit //If set, can only speak to others of the same type within a short range.

	var/med_hud = MOB_HUD_MEDICAL_ADVANCED //Determines the med hud to use
	var/sec_hud = MOB_HUD_SECURITY_ADVANCED //Determines the sec hud to use
	var/list/HUD_toggled = list(0,0,0)

/mob/living/silicon/Initialize()
	. = ..()
	SSmob.living_misc_mobs += src
	add_language(LANGUAGE_ENGLISH)

/mob/living/silicon/Destroy()
	SSmob.living_misc_mobs -= src
	return ..()

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/drop_held_item()
	return

/mob/living/silicon/drop_held_items()
	return

/mob/living/silicon/emp_act(severity)
	. = ..()
	switch(severity)
		if(1)
			src.take_limb_damage(20)
			apply_effect(rand(5,10), STUN)
		if(2)
			src.take_limb_damage(10)
			apply_effect(rand(1,5), STUN)
	flash_eyes(1, TRUE, type = /atom/movable/screen/fullscreen/flash/noise)

	to_chat(src, SPAN_DANGER("<B>*滋啪*</B>"))
	to_chat(src, SPAN_DANGER("警告：检测到电磁脉冲。"))

/mob/living/silicon/stun_effect_act(stun_amount, agony_amount)
	return //immune

/mob/living/silicon/proc/damage_mob(brute = 0, fire = 0, tox = 0)
	return

/mob/living/silicon/IsAdvancedToolUser()
	return 1

/mob/living/silicon/apply_effect(effect = 0, effecttype = STUN, blocked = 0)
	return 0//The only effect that can hit them atm is flashes and they still directly edit so this works for now


// this function shows health in the Status panel
/mob/living/silicon/proc/show_system_integrity()
	if(!stat)
		stat(null, text("系统完整度：[floor((health/maxHealth)*100)]%"))
	else
		stat(null, text("系统无法运作"))

// this function displays the station time in the status panel
/mob/living/silicon/proc/show_station_time()
	stat(null, "站内时间：[worldtime2text()]")


// this function displays the shuttles ETA in the status panel if the shuttle has been called
/mob/living/silicon/proc/show_emergency_shuttle_eta()
	if(SShijack)
		var/eta_status = SShijack.get_evac_eta()
		if(eta_status)
			stat(null, "疏散目标：[SShijack.get_eta_display(eta_status)]")


// this function displays the stations manifest in a separate window
/mob/living/silicon/proc/show_station_manifest()
	var/dat
	dat += "<h4>舰员名册</h4>"
	dat += GLOB.data_core.get_manifest(1) // make it monochrome
	dat += "<br>"
	src << browse(dat, "window=airoster")
	onclose(src, "airoster")

//can't inject synths
/mob/living/silicon/can_inject(mob/user, error_msg)
	if(error_msg)
		to_chat(user, SPAN_WARNING("装甲板太坚固了。"))
	return 0


//Silicon mob language procs

/mob/living/silicon/can_speak(datum/language/speaking)
	return universal_speak || (speaking in src.speech_synthesizer_langs) //need speech synthesizer support to vocalize a language

/mob/living/silicon/add_language(language, can_speak=1)
	if (..(language) && can_speak)
		speech_synthesizer_langs.Add(GLOB.all_languages[language])
		return 1

/mob/living/silicon/remove_language(rem_language)
	..(rem_language)

	for (var/datum/language/L in speech_synthesizer_langs)
		if (L.name == rem_language)
			speech_synthesizer_langs -= L

/mob/living/silicon/check_languages()
	set name = "查看已知语言"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>已知语言</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		dat += "<b>[localized_player_label(L.name)] (:[L.key])</b><br/>语音合成器：<i>[(L in speech_synthesizer_langs)? "支持":"不支持"]</i><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return



/mob/living/silicon/proc/toggle_sensor_mode()
	if(!client)
		return
	var/list/listed_huds = list("医疗HUD", "安保HUD", "小队HUD")
	var/hud_choice = tgui_input_list(usr, "选择要切换的HUD", "切换HUD", listed_huds)
	if(!client)
		return
	var/datum/mob_hud/H
	var/HUD_nbr = 1
	switch(hud_choice)
		if("医疗HUD")
			H = GLOB.huds[MOB_HUD_MEDICAL_OBSERVER]
		if("安保HUD")
			H = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
			HUD_nbr = 2
		if("小队HUD")
			H = GLOB.huds[MOB_HUD_FACTION_MARINE]
			HUD_nbr = 3
		else
			return

	if(HUD_toggled[HUD_nbr])
		HUD_toggled[HUD_nbr] = 0
		H.remove_hud_from(src, src)
		to_chat(src, SPAN_NOTICE("<B>[hud_choice]已关闭</B>"))
	else
		HUD_toggled[HUD_nbr] = 1
		H.add_hud_to(src, src)
		to_chat(src, SPAN_NOTICE("<B>[hud_choice]已开启</B>"))

/mob/living/silicon/verb/pose()
	set name = "Set Pose"
	set desc = "设置一段他人观察你时可见的姿态描述。"
	set category = "IC"

	pose =  strip_html(input(usr, "这是[src]，其姿态是……", "姿态", null)  as text)

/mob/living/silicon/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "设置一段详细描写角色特征的外观文本。"
	set category = "IC"

	flavor_text =  strip_html(input(usr, "请输入新的外观描述。", "外观描述", null)  as text)

/mob/living/silicon/hear_apollo()
	return TRUE

/mob/living/silicon/rejuvenate()
	..()
	SSmob.living_misc_mobs += src

/mob/living/silicon/ex_act(severity)
	flash_eyes()

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (stat != 2)
				apply_damage(30, BRUTE)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (stat != 2)
				apply_damage(60, BRUTE)
				apply_damage(60, BURN)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if (stat != 2)
				apply_damage(100, BRUTE)
				apply_damage(100, BURN)
				if(!anchored)
					gib()

	updatehealth()
