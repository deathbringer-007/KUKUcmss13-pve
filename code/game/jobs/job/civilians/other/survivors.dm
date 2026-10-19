#define SURVIVOR_TO_TOTAL_SPAWN_RATIO 1/9

/datum/job/civilian/survivor
	title = JOB_SURVIVOR
	selection_class = "job_special"
	// For the roundstart precount, then gets further limited by set_spawn_positions.
	total_positions = 8
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_CUSTOM_SPAWN
	late_joinable = FALSE
	job_options = SURVIVOR_VARIANT_LIST
	var/intro_text
	var/story_text
	/// Whether or not the survivor is an inherently hostile to marines.
	var/hostile = FALSE

/datum/job/civilian/survivor/set_spawn_positions(count)
	spawn_positions = clamp((floor(count * SURVIVOR_TO_TOTAL_SPAWN_RATIO)), 2, 8)
	total_positions = spawn_positions

/datum/job/civilian/survivor/equip_job(mob/living/survivor)
	var/generated_account = generate_money_account(survivor)
	addtimer(CALLBACK(src, PROC_REF(announce_entry_message), survivor, generated_account), 2 SECONDS)
	return

/datum/job/civilian/survivor/announce_entry_message(mob/living/carbon/human/survivor, datum/money_account/account, whitelist_status) //The actual message that is displayed to the mob when they enter the game as a new player.
	if(survivor?.loc && survivor.client)
		//Document syntax cannot have tabs for proper formatting.
		var/entrydisplay = " \
			[SPAN_ROLE_BODY("|______________________|")] \n\
			[SPAN_ROLE_BODY("[generate_entry_message(survivor)]<br>[account ? "你的账号是： <b>[account.account_number]</b>. 你的账户个人识别码是： <b>[account.remote_access_pin]</b>." : "你没有银行账户。"]")] \n\
			[SPAN_ROLE_BODY("|______________________|")] \
		"
		to_chat_spaced(survivor, html = entrydisplay)

/datum/job/civilian/survivor/spawn_in_player(mob/new_player/NP)
	. = ..()
	var/mob/living/carbon/human/H = .

	var/list/potential_spawners = list()
	for(var/priority = 1 to LOWEST_SPAWN_PRIORITY)
		if(length(GLOB.survivor_spawns_by_priority["[priority]"]))
			for(var/obj/effect/landmark/survivor_spawner/spawner as anything in GLOB.survivor_spawns_by_priority["[priority]"])
				if(spawner.check_can_spawn(H))
					potential_spawners += spawner
			if(length(potential_spawners))
				break
	var/obj/effect/landmark/survivor_spawner/picked_spawner = pick(potential_spawners)
	H.forceMove(get_turf(picked_spawner))

	handle_equip_gear(H, picked_spawner)

	if(picked_spawner.roundstart_damage_max > 0)
		if(istype(picked_spawner) && picked_spawner.roundstart_damage_max > 0)
			for(var/i in 0 to picked_spawner.roundstart_damage_times)
				H.take_limb_damage(rand(picked_spawner.roundstart_damage_min, picked_spawner.roundstart_damage_max), 0)

	H.name = H.get_visible_name()

	if(length(picked_spawner.intro_text))
		intro_text = picked_spawner.intro_text

	if(picked_spawner.story_text)
		story_text = picked_spawner.story_text

	if(picked_spawner.hostile)
		hostile = TRUE

/datum/job/civilian/survivor/generate_entry_message(mob/living/carbon/human/survivor)
	if(intro_text)
		for(var/line in intro_text)
			to_chat(survivor, line)
	else
		to_chat(survivor, "<h2>你是一名幸存者！</h2>")
		to_chat(survivor, SPAN_NOTICE(SSmapping.configs[GROUND_MAP].survivor_message))
		to_chat(survivor, SPAN_NOTICE("你完全了解异形威胁，可以自行决定如何运用这些知识。"))
		to_chat(survivor, SPAN_NOTICE("你不了解陆战队员或他们的意图。"))

	if(story_text)
		to_chat(survivor, story_text)
		survivor.mind.memory += story_text
	else
		tell_survivor_story(survivor)

	if(hostile)
		to_chat(survivor, SPAN_HIGHDANGER("你与美国殖民地海军陆战队敌对！"))
	else if(survivor.faction == FACTION_CLF)
		to_chat(survivor, SPAN_HIGHDANGER("你与美国殖民地海军陆战队敌对，但不与其他幸存者敌对！"))
	else
		to_chat(survivor, SPAN_XENOHIGHDANGER("你与美国殖民地海军陆战队并不敌对！"))

/datum/job/civilian/survivor/proc/tell_survivor_story(mob/living/carbon/human/H)
	var/list/survivor_story = list(
								"你眼看着一只幼体从朋友{name}的胸口破体而出。你试图抓住那只外星生物，却被它钻进通风管逃走了。",
								"{name}遭到一只抱脸虫袭击，体内被植入了外星生命。后来，一只怪物从{name}的胸口钻出，鲜血与碎肉四处飞溅。",
								"你惊恐地看着外星生物的酸液溅到{name}的皮肤上，将血肉腐蚀殆尽。那阵恐惧的尖叫至今仍在你耳边回荡。",
								"殖民地执法官{name}发布公告，称敌对生物已杀害许多人，要求所有人躲藏起来，或待在紧闭的门后。",
								"外星生物冲进食堂、拖走其他人时，你就在现场。那景象惨不忍睹，从此你总是尽量避开大片空旷地带。",
								"你亲眼看见朋友{name}遭到可怕怪物的撕咬，那一幕太恐怖了。痛苦的惨叫不断萦绕在你的梦中，令你无法安睡。",
								"你拼尽全力躲藏，也曾见过那些生物穿行于地下隧道和通风井之间。它们似乎喜欢黑暗。",
								"醒来时，你感觉自己仿佛已经沉睡了很多年。过去的生活几乎全都记不清了，也许只剩自己的名字。你身上到底发生了什么？",
								"你曾在前线试图抵抗异形。你亲眼见过它们从其他人体内孵出更多怪物，也已明白不该再去白白送死。",
								"你发现了某样东西，某样不可思议的东西。然而怪物突然出现，开始抓走人们，你的发现也就此中断。该死的畜生！",
								"{name}在异形来袭时保护了你。你不知道后来发生了什么；那已是前一阵子的事，你此后再没见过对方。也许人还活着。"
								)

	/*
	var/list/survivor_multi_story = list(
										"You were separated from your friend, {surv}. You hope they're still alive.",
										"You were having some drinks at the bar with {surv} and {name} when an alien crawled out of the vent and dragged {name} away. You and {surv} split up to find help.",
										"Something spooked you when you were out with {surv} scavenging. You took off in the opposite direction from them, and you haven't seen them since.",
										"When {name} became infected, you and {surv} argued over what to do with the afflicted. You nearly came to blows before walking away, leaving them behind.",
										"You ran into {surv} when out looking for supplies. After a tense stand off, you agreed to stay out of each other's way. They didn't seem so bad.",
										"A lunatic by the name of {name} was preaching doomsday to anyone who would listen. {surv} was there too, and you two shared a laugh before the creatures arrived.",
										"Your last decent memory before everything went to hell is of {surv}. They were generally a good person to have around, and they helped you through tough times.",
										"When {name} called for evacuation, {surv} came with you. The aliens appeared soon after and everyone scattered. You hope your friend {surv} is alright.",
										"You remember an explosion. Then everything went dark. You can only recall {name} and {surv}, who were there. Maybe they know what really happened?",
										"The aliens took your mutual friend, {name}. {surv} helped with the rescue. When you got to the alien hive, your friend was dead. You took different passages out.",
										"You were playing basketball with {surv} when the creatures descended. You bolted in opposite directions, and actually managed to lose the monsters, somehow."
										)
										*/

	var/random_name = pick(random_name(FEMALE), random_name(MALE))
	var/temp_story = "<b>你的经历</b>：" + replacetext(pick(survivor_story), "{name}", "[random_name]")
	to_chat(H, temp_story)
	H.mind.memory += temp_story

	return TRUE

/datum/job/civilian/survivor/proc/handle_equip_gear(mob/living/carbon/human/equipping_human, obj/effect/landmark/survivor_spawner/picked_spawner)
	if(picked_spawner.equipment)
		arm_equipment(equipping_human, picked_spawner.equipment, FALSE, TRUE)
	else
		var/preferred_variant = ANY_SURVIVOR
		if(equipping_human.client?.prefs?.pref_special_job_options[JOB_SURVIVOR] != ANY_SURVIVOR)
			preferred_variant = equipping_human.client?.prefs?.pref_special_job_options[JOB_SURVIVOR]
			if(MAX_SURVIVOR_PER_TYPE[preferred_variant] != -1 && SSticker.mode.survivors_by_type_amounts[preferred_variant] && SSticker.mode.survivors_by_type_amounts[preferred_variant] >= MAX_SURVIVOR_PER_TYPE[preferred_variant])
				preferred_variant = ANY_SURVIVOR

		var/list/survivor_types = preferred_variant != ANY_SURVIVOR && length(SSmapping.configs[GROUND_MAP].survivor_types_by_variant[preferred_variant]) ? SSmapping.configs[GROUND_MAP].survivor_types_by_variant[preferred_variant] : SSmapping.configs[GROUND_MAP].survivor_types
		arm_equipment(equipping_human, pick(survivor_types), FALSE, TRUE)

		SSticker.mode.survivors_by_type_amounts[preferred_variant] += 1

/datum/job/civilian/survivor/synth
	title = JOB_SYNTH_SURVIVOR
	selection_class = "job_synth"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_SYNTHETIC
	total_positions = 1
	spawn_positions = 1
	job_options = null

/datum/job/civilian/survivor/synth/set_spawn_positions(count)
	return spawn_positions

/datum/job/civilian/survivor/synth/handle_equip_gear(mob/living/carbon/human/equipping_human, obj/effect/landmark/survivor_spawner/picked_spawner)
	if(picked_spawner.synth_equipment)
		arm_equipment(equipping_human, picked_spawner.synth_equipment, FALSE, TRUE)
	else
		var/preferred_variant = ANY_SURVIVOR
		if(equipping_human.client?.prefs?.pref_special_job_options[JOB_SURVIVOR] != ANY_SURVIVOR)
			preferred_variant = equipping_human.client?.prefs?.pref_special_job_options[JOB_SURVIVOR]
			if(MAX_SURVIVOR_PER_TYPE[preferred_variant] != -1 && SSticker.mode.survivors_by_type_amounts[preferred_variant] && SSticker.mode.survivors_by_type_amounts[preferred_variant] >= MAX_SURVIVOR_PER_TYPE[preferred_variant])
				preferred_variant = ANY_SURVIVOR

		var/list/synth_survivor_types = preferred_variant != ANY_SURVIVOR && length(SSmapping.configs[GROUND_MAP].synth_survivor_types_by_variant[preferred_variant]) ? SSmapping.configs[GROUND_MAP].synth_survivor_types_by_variant[preferred_variant] : SSmapping.configs[GROUND_MAP].synth_survivor_types
		arm_equipment(equipping_human, pick(synth_survivor_types), FALSE, TRUE)

		SSticker.mode.survivors_by_type_amounts[preferred_variant] += 1

/datum/job/civilian/survivor/commanding_officer
	title = JOB_CO_SURVIVOR
	selection_class = "job_co"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_COMMANDER
	total_positions = 0
	spawn_positions = 0
	job_options = null

/datum/job/civilian/survivor/commanding_officer/set_spawn_positions()
	var/list/CO_survivor_types = SSmapping.configs[GROUND_MAP].CO_survivor_types
	if(length(CO_survivor_types))
		total_positions = 1
		spawn_positions = 1
	return spawn_positions

/datum/job/civilian/survivor/commanding_officer/handle_equip_gear(mob/living/carbon/human/equipping_human, obj/effect/landmark/survivor_spawner/picked_spawner)
	if(picked_spawner.CO_equipment)
		arm_equipment(equipping_human, picked_spawner.CO_equipment, FALSE, TRUE)
		return
	else
		var/list/CO_survivor_types = SSmapping.configs[GROUND_MAP].CO_survivor_types
		arm_equipment(equipping_human, pick(CO_survivor_types), FALSE, TRUE)
		return
