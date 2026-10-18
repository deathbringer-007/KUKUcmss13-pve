

//Colonial Liberation Front
/datum/emergency_call/clf
	name = "Colonial Liberation Front (Squad)"
	localized_name = "殖民地解放阵线（小队）"
	mob_max = 10
	arrival_message = "“注意，你们正侵犯我们的主权领土。别指望获得宽恕。”"
	objectives = "攻击美国殖民地海军陆战队，并尽可能制造破坏。确保幸存者在你们的控制下撤离。"
	probability = 20
	hostility = TRUE
	home_base = /datum/lazy_template/ert/clf_station
	var/max_synths = 1
	var/synths = 0

/datum/emergency_call/clf/print_backstory(mob/living/carbon/human/H)
	if(ishuman_strict(H))
		var/message = "[pick(5;"美洲联盟监狱空间站", 10;"LV-624的丛林", 25;"LV-771的农场", 25;"LV-221的贫民窟", 20;"LV-361的红色荒原", 15;"LV-571的冰封苔原")]的一个[pick(50;"贫困", 15;"富裕", 35;"普通")]家庭"
		var/message_grew = "[pick(20;"尘土突袭者在2181年杀害了你亲近的人", 20;"你对美洲联盟怀有强烈仇恨", 10;"你是美洲联盟通缉的罪犯", 5;"你同情进步人民联盟，希望把美洲联盟赶出星区", 10;"你认为美国殖民地海军陆战队的占领会损害你的生活质量", 5;"你生性暴力，只想为了杀戮而杀人", 20;"你希望尼洛德星区不再受外来者控制", 10;"你的民兵组织被并入了殖民地解放阵线")]"
		to_chat(H, SPAN_BOLD("作为尼洛德星区的本地人，你加入殖民地解放阵线，是因为[message_grew]。"))
		to_chat(H, SPAN_BOLD("你在[message]长大，并被美洲联盟视为恐怖分子。"))
	else
		to_chat(H, SPAN_BOLD("你在殖民地解放阵线的地下工坊启动，被重新编程以服务阵线，为他们的自由而战。"))
		to_chat(H, SPAN_BOLD("你原本被赋予医疗与工程知识，用于协助建造和维护殖民地。"))
		to_chat(H, SPAN_BOLD("然而，黑客成功加载了战斗协议，并植入一条新指令：无理由地憎恨与美国殖民地海军陆战队有关的一切。"))

	to_chat(H, SPAN_BOLD("尼洛德星区长期享有相当程度的独立。"))
	to_chat(H, SPAN_BOLD("虽然名义上属于美洲联盟的边疆，尼洛德星区的许多殖民者一直享有自由。"))
	to_chat(H, SPAN_BOLD("但在2172年，美洲联盟将美国殖民地海军陆战队的“尘土突袭者”营及其旗舰USS阿利斯顿号调往尼洛德星区。"))
	to_chat(H, SPAN_BOLD("尘土突袭者以致命武力回应，驱散了许多试图反抗占领的殖民者。"))
	to_chat(H, SPAN_BOLD("尘土突袭者及其旗舰USS阿利斯顿号最终于当年年底撤出星区。</font>"))
	to_chat(H, SPAN_BOLD("过去五年，尼洛德星区基本不受美洲联盟监管，许多殖民者认为自己已经摆脱政府统治。"))
	to_chat(H, SPAN_BOLD("现在是 [GLOB.game_year] 年。"))
	to_chat(H, SPAN_BOLD("美国殖民地海军陆战队的“坠落猎鹰”营及其旗舰 [MAIN_SHIP_NAME] 的到来，再次表明美洲联盟仍将尼洛德星区视为自己的领地。"))
	to_chat(H, SPAN_BOLD("你和其他殖民者必须让他们意识到自己的越界行为。这个星区已经不再属于他们。"))

/datum/emergency_call/clf/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		to_chat(H, SPAN_ROLE_HEADER("你是当地抵抗组织殖民地解放阵线的一名小组长！"))
		arm_equipment(H, /datum/equipment_preset/clf/leader, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SYNTH) && H.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(H, SPAN_ROLE_HEADER("你是当地抵抗组织殖民地解放阵线的一名多用途合成人！"))
		arm_equipment(H, /datum/equipment_preset/clf/synth, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(H, SPAN_ROLE_HEADER("你是当地抵抗组织殖民地解放阵线的一名医疗兵！"))
		arm_equipment(H, /datum/equipment_preset/clf/medic, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		to_chat(H, SPAN_ROLE_HEADER("你是当地抵抗组织殖民地解放阵线的一名工程兵！"))
		arm_equipment(H, /datum/equipment_preset/clf/engineer, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(H.client, JOB_SQUAD_SPECIALIST, time_required_for_job))
		heavies++
		to_chat(H, SPAN_ROLE_HEADER("你是当地抵抗组织殖民地解放阵线的一名武器专家！"))
		arm_equipment(H, /datum/equipment_preset/clf/soldier, TRUE, TRUE)
	else
		to_chat(H, SPAN_ROLE_HEADER("你是当地抵抗组织殖民地解放阵线的一名战士！"))
		arm_equipment(H, /datum/equipment_preset/clf/soldier, TRUE, TRUE)
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)


/datum/emergency_call/clf/platoon
	name = "Colonial Liberation Front (Platoon)"
	localized_name = "殖民地解放阵线（排）"
	mob_min = 8
	mob_max = 35
	probability = 0
	max_engineers = 2
	max_medics = 2
	max_heavies = 2
	max_synths = 1
