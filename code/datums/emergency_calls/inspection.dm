//USCM Provost
/datum/emergency_call/inspection_provost
	name = "Inspection - USCM Provost - ML knowledge and MP playtime required."
	mob_max = 2
	mob_min = 1
	probability = 0

/datum/emergency_call/inspection_provost/New()
	..()
	objectives = "调查 [MAIN_SHIP_NAME] 上的军法执行问题。"

/datum/emergency_call/inspection_provost/remove_nonqualifiers(list/datum/mind/candidates_list)
	var/list/datum/mind/candidates_clean = list()
	for(var/datum/mind/single_candidate in candidates_list)
		if(check_timelock(single_candidate.current?.client, JOB_POLICE, time_required_for_job))
			candidates_clean.Add(single_candidate)
			continue
		if(single_candidate.current)
			to_chat(single_candidate.current, SPAN_WARNING("你担任宪兵的游戏时长不足5小时，因此无法响应应急响应队信标！"))
	return candidates_clean

/datum/emergency_call/inspection_provost/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_WARDEN, JOB_CHIEF_POLICE), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/uscm_event/provost/inspector, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队军法监察署的监察员！"))
		to_chat(H, SPAN_ROLE_BODY("你被派往 [MAIN_SHIP_NAME]，调查一起未公开的军法执行问题。军法监察署可能提供更多细节，但你应先到禁闭区评估局势。"))
		to_chat(H, SPAN_ROLE_BODY("在行动区域内，你对军法执行拥有最终决定权，但仍必须遵守军法。运用这份权力纠正问题，确保正义得到伸张！"))
		to_chat(H, SPAN_WARNING("这个角色要求熟悉《陆战队军法》和《标准操作规程》。若有疑问，或想将角色让给他人，请向管理员求助。"))
	else
		arm_equipment(H, /datum/equipment_preset/uscm_event/provost/enforcer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队军法监察署的执法员！"))
		to_chat(H, SPAN_ROLE_BODY("你被编入派往 [MAIN_SHIP_NAME] 的监察员随行团队，兼任护卫、助手和执法人员。"))
		to_chat(H, SPAN_ROLE_BODY("你通常不负责舰上军法执法；但监察员可能在调查中要求你履行宪兵职责，此时你必须像其他宪兵一样行事。"))
		to_chat(H, SPAN_WARNING("这个角色要求熟悉《陆战队军法》和《标准操作规程》。若有疑问，或想将角色让给他人，请向管理员求助。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)


/datum/emergency_call/inspection_provost/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

//USCM High Command
/datum/emergency_call/inspection_hc
	name = "Inspection - USCM High Command"
	mob_max = 2
	mob_min = 1
	probability = 0

/datum/emergency_call/inspection_hc/New()
	..()
	objectives = "检查并评估 [MAIN_SHIP_NAME] 及其船员。"

/datum/emergency_call/inspection_hc/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_SO), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/uscm_ship/so, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队最高指挥部派出的监察员！"))
		to_chat(H, SPAN_ROLE_BODY("[MAIN_SHIP_NAME] 在当前任务期间将接受例行检查。最高指挥部可能通过无线电向你下达其他指令。"))
		to_chat(H, SPAN_ROLE_BODY("巡视舰船，检查各部门的组织、效率和标准操作规程遵守情况，访谈船员并找出问题。将检查结果同时报告给舰上指挥官和美国殖民地海军陆战队最高指挥部。"))
		to_chat(H, SPAN_WARNING("切记，检查不得打断舰船正常运作，你也无权决定军法执法事务。若有疑问，或想将角色让给他人，请向管理员求助。"))
	else
		arm_equipment(H, /datum/equipment_preset/uscm/engineer_equipped, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是美国殖民地海军陆战队最高指挥部派出的检查组成员！"))
		to_chat(H, SPAN_ROLE_BODY("[MAIN_SHIP_NAME] 在当前任务期间将接受例行检查。你既是监察员的护卫，也会在对方需要专业意见时担任助手。"))
		to_chat(H, SPAN_ROLE_BODY("跟随监察员在舰上履行职责。如有见解，可主动提出，并按要求提供帮助。切记，虽然你不直接受舰上军官指挥，仍须尊重他们的职权。"))
		to_chat(H, SPAN_WARNING("切记，不得干扰正常运作，并应始终服从监察员的命令。若有疑问，或想将角色让给他人，请向管理员求助。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)

//Weyland-Yutani
/datum/emergency_call/inspection_wy
	name = "Inspection - Corporate"
	mob_max = 2
	mob_min = 1
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item
	probability = 0

/datum/emergency_call/inspection_wy/New()
	..()
	objectives = "确保 [MAIN_SHIP_NAME] 的船员知道你们已经到来。调查企业联络员及其他公司资产，确认其仍效忠公司，并向调度部门提交详细报告。"

/datum/emergency_call/inspection_wy/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_SQUAD_LEADER), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/pmc/leader, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商监察员！"))
		to_chat(H, SPAN_ROLE_BODY("你所在的单位名义上为维兰德-汤谷执行普通安保工作，实际也会正式或秘密调查公司人员的行为。你被派往 [MAIN_SHIP_NAME]，确认当地联络员没有忘记公司的优先事项，更没有想过反咬养活自己的主人。"))
		to_chat(H, SPAN_ROLE_BODY("切记，舰上的美国殖民地海军陆战队人员可能不欢迎你。若联络员被关押，除非调度部门下令，否则不得担任其法律顾问。你的基本职责是详细记录舰上涉及联络员及其他维兰德-汤谷人员的一切情况。"))
		to_chat(H, SPAN_WARNING("除非调度部门另有命令，否则应避免与陆战队员公开冲突。若对方明显敌对，应撤退并提交报告。若有其他疑问，或想将角色让给其他玩家，请向管理员求助。"))
	else
		arm_equipment(H, /datum/equipment_preset/pmc/standard, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是维兰德-汤谷私人军事承包商调查组的一员！"))
		to_chat(H, SPAN_ROLE_BODY("你所在的单位名义上为维兰德-汤谷执行普通安保工作，实际也会正式或秘密调查公司人员的行为。首席调查员负责指挥，你应提供支援、建议及其他力所能及的帮助，确保任务成功。"))
		to_chat(H, SPAN_ROLE_BODY("切记，美国殖民地海军陆战队的部分人员可能不欢迎你们出现在舰上。除非调度部门另有命令，否则你和队长都应避免公开冲突。首要任务是确保负责人活着写完应提交的报告。"))
		to_chat(H, SPAN_WARNING("除非调度部门另有命令，否则应避免与陆战队员公开冲突。优先保证团队安全；若舰上局势过于危险，最好撤离。若有其他疑问，或想将角色让给其他玩家，请向管理员求助。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)

/datum/emergency_call/inspection_wy/spawn_items()
	var/turf/drop_spawn

	drop_spawn = get_spawn_point(TRUE)
	new /obj/item/storage/box/handcuffs(drop_spawn)
	new /obj/item/storage/box/handcuffs(drop_spawn)

/datum/emergency_call/inspection_wy/lawyer
	name = "Lawyers - Corporate"
	mob_max = 2
	mob_min = 1
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item
	probability = 0

/datum/emergency_call/inspection_wy/lawyer/New()
	..()
	objectives = "确保 [MAIN_SHIP_NAME] 的船员知道你们已经到来。调查联络员举报的违约人员，并审查其他公司资产，确认其仍效忠公司。向公司提交详细报告。"

/datum/emergency_call/inspection_wy/lawyer/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, list(JOB_SQUAD_LEADER), time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/wy/exec_supervisor/lawyer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是维兰德-汤谷首席企业律师！"))
		to_chat(H, SPAN_ROLE_BODY("企业事务部名义上为维兰德-汤谷处理日常文书，实际也会正式或秘密调查公司内外人员的行为。你被派往 [MAIN_SHIP_NAME]，确认美国殖民地海军陆战队遵守当地联络员提供并签订的合同，没有忘记真正供养他们的人。"))
		to_chat(H, SPAN_ROLE_BODY("切记，舰上的美国殖民地海军陆战队人员可能不欢迎你。若联络员被关押，你应尽力提供法律援助。你的基本职责是详细记录舰上涉及联络员、其他维兰德-汤谷人员，以及任何违约行为的情况。"))
		to_chat(H, SPAN_WARNING("你应避免与陆战队员公开冲突。若对方明显敌对，应撤退并提交报告。若有其他疑问，或想将角色让给其他玩家，请向管理员求助。"))
	else
		arm_equipment(H, /datum/equipment_preset/wy/exec_spec/lawyer, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("你是维兰德-汤谷企业律师！"))
		to_chat(H, SPAN_ROLE_BODY("企业事务部名义上为维兰德-汤谷处理日常文书，实际也会正式或秘密调查公司内外人员的行为。首席律师负责指挥，你应提供法律建议及其他力所能及的帮助，确保任务成功。"))
		to_chat(H, SPAN_ROLE_BODY("切记，美国殖民地海军陆战队的部分人员可能不欢迎你们出现在舰上。你和首席律师都应避免公开冲突。首要任务是确保你们都能活着向公司提交报告。"))
		to_chat(H, SPAN_WARNING("你应避免与陆战队员公开冲突。若对方明显敌对，应撤退并提交报告。若有其他疑问，或想将角色让给其他玩家，请向管理员求助。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("目标：[objectives]")), 1 SECONDS)


// Colonial Marshals - UA Law Enforcement / Investigative Federal Agents which usually watch over Colonies. Also a good option for prisoner transfers, investigating corporate corruption, survivor rescues, or illict trade practices(black market).
/datum/emergency_call/inspection_cmb
	name = "Inspection - Colonial Marshals Investigation Team"
	mob_max = 4
	mob_min = 1
	probability = 0
	home_base = /datum/lazy_template/ert/weyland_station

	var/max_synths = 1
	var/synths = 0

	var/will_spawn_icc_liaison
	var/icc_liaison

	var/will_spawn_cmb_observer
	var/cmb_observer

/datum/emergency_call/inspection_cmb/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME]，这里是锚点空间站殖民地执法局。一艘执法局运输舰正准备登舰，现提交联邦对接许可。请待命。"
	objectives = "从锚点空间站殖民地执法局办事处获取指令并执行。确保殖民地资产安全且受你们控制。除非被请求，否则不得在陆战队军舰上执行或凌驾于《陆战队军法》之上，这不属于你们的管辖范围。"

	will_spawn_icc_liaison = prob(90)
	will_spawn_cmb_observer = prob(10)

/datum/emergency_call/inspection_cmb/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是殖民地执法官！"))
		arm_equipment(mob, /datum/equipment_preset/cmb/marshal, TRUE, TRUE)
	else if(synths < max_synths && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_SYNTH) && mob.client.check_whitelist_status(WHITELIST_SYNTHETIC))
		synths++
		to_chat(mob, SPAN_ROLE_HEADER("你是殖民地执法局的调查型合成人！"))
		arm_equipment(mob, /datum/equipment_preset/cmb/synth, TRUE, TRUE)
	else if(!icc_liaison && will_spawn_icc_liaison && check_timelock(mob.client, JOB_CORPORATE_LIAISON, time_required_for_job))
		icc_liaison = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是派驻殖民地执法局的星际商业委员会联络员！"))
		arm_equipment(mob, /datum/equipment_preset/cmb/liaison, TRUE, TRUE)
	else if(!cmb_observer && will_spawn_cmb_observer)
		cmb_observer = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是一名星际人权观察员！"))
		arm_equipment(mob, /datum/equipment_preset/cmb/observer, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("你是殖民地执法局的副执法官！"))
		arm_equipment(mob, /datum/equipment_preset/cmb/deputy, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)


/datum/emergency_call/inspection_cmb/print_backstory(mob/living/carbon/human/M)
	if(M == leader)
		to_chat(M, SPAN_BOLD("你是殖民地执法官，来自[pick(70;"美洲联盟", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你通过[pick(50; "大学期间选择执法职业", 40;"从事执法工作", 10;"凭借自身技能被招募")]加入执法局。"))
		to_chat(M, SPAN_BOLD("你在银河各地不断晋升，因坚定维护正义、打击犯罪与腐败而闻名。"))
		to_chat(M, SPAN_BOLD("作为殖民地执法局官员，你拥有跨星际管辖权，可执行殖民地与地球法律，但在陆战队军舰上不能也不应凌驾于《陆战队军法》之上。"))
		to_chat(M, SPAN_BOLD("地球的法律适用于太阳系以外。即使他人受到诱惑、堕入腐败，你也坚守道德准则。"))
		to_chat(M, SPAN_BOLD("企业人员追逐薪水和晋升，你却致力于履行誓言、照顾民众，无论殖民地多么遥远或孤立。"))
		to_chat(M, SPAN_BOLD("你在尼洛德星区见过许多事。你能来到这里，是因为你是最优秀的人，坚持做正确的事，让边疆变得更好。"))
		to_chat(M, SPAN_BOLD("尽管人手不足，执法官坚定的誓言仍让各地社区保持安全，殖民地执法局受到许多人的尊重。你代表着这份誓言，应以出色表现履行职责。"))
	else if(issynth(M))
		to_chat(M, SPAN_BOLD("虽然型号较老，你仍凭借敏锐的感知和警觉性受到同僚认可。"))
		to_chat(M, SPAN_BOLD("除执法程序外，你还被编程为寻找证据、分析化学品及调查犯罪的顶尖专家。"))
		to_chat(M, SPAN_BOLD("你不负责执行《陆战队军法》，也不受其约束，但你了解其内容。"))
		to_chat(M, SPAN_BOLD("在太阳系完成软件和法律资料更新后，你被派往锚点空间站，协助边疆的殖民地执法局单位。"))
		to_chat(M, SPAN_BOLD("虽然预计不会发生战斗，你的背包仍携带了团队备用的轻型弹药和装备，以备不时之需。"))
		to_chat(M, SPAN_BOLD("尽管人手不足，执法官坚定的誓言仍让各地社区保持安全，殖民地执法局受到许多人的尊重。你同样代表这份誓言，应以出色表现履行职责。"))
	else if(M == icc_liaison)
		to_chat(M, SPAN_BOLD("你是星际商业联络员，来自[pick(70;"美洲联盟", 25;"太阳系", 5;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你对维兰德-汤谷持[pick(30; "怀疑", 40;"友好", 30;"支持")]态度。"))
		to_chat(M, SPAN_BOLD("你的耳机能接收多个频段，其中还有星际商业委员会母公司维兰德-汤谷赠送的密钥，试图以此争取你的支持。请用它联络。"))
		to_chat(M, SPAN_BOLD("你是派驻锚点空间站殖民地执法局办事处的星际商业委员会专员，负责观察并确保贸易公平。必要时检查并记录货物，排查涉嫌违法的活动。如需逮捕，应与执法官和指挥部协调，最好先取得搜查或逮捕令。"))
		to_chat(M, SPAN_BOLD("与这些声誉良好的人共事，使你变得更有德行，尤其比起其他大组织的企业联络员。"))
		to_chat(M, SPAN_BOLD("协助殖民地执法官开展调查。若怀疑存在走私或非法贸易，应向指挥部报告。"))
	else if(M == cmb_observer)
		to_chat(M, SPAN_BOLD("你是星际人权观察员，来自[pick(50;"美洲联盟", 10;"欧洲", 10;"月球", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你对维兰德-汤谷及其做法持[pick(60; "怀疑", 40;"友好", 10;"支持")]态度。"))
		to_chat(M, SPAN_BOLD("你对美国殖民地海军陆战队在边疆的行动持[pick(40; "怀疑", 30;"友好", 30;"支持")]态度。"))
		to_chat(M, SPAN_BOLD("经过大量努力，你的组织终于说服殖民地执法官带你前往边疆，为一篇关于当地生活质量的文章搜集资料。"))
		to_chat(M, SPAN_BOLD("观察执法人员的行动，留意其他人是否存在不人道行为。尼洛德星区的各方势力都不乏暴行。"))
		to_chat(M, SPAN_BOLD("不要挑起或发动任何对抗。你是观察员，不参与战争，只有遇到医疗紧急情况时才能介入。"))
	else
		to_chat(M, SPAN_BOLD("你是殖民地执法局的副执法官，来自[pick(70;"美洲联盟", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你通过[pick(50; "大学期间选择执法职业", 40;"从事执法工作", 10;"凭借自身技能被招募")]加入执法局。"))
		to_chat(M, SPAN_BOLD("在执法官的带领下，你因坚定维护正义、打击犯罪与腐败而闻名。"))
		to_chat(M, SPAN_BOLD("作为殖民地执法局官员，你拥有跨星际管辖权，可执行殖民地与地球法律，但在陆战队军舰上不能也不应凌驾于《陆战队军法》之上。"))
		to_chat(M, SPAN_BOLD("你已在锚点空间站驻扎[pick(80;"数月", 10;"仅仅一周", 10;"多年")]，调查边疆的恶性犯罪。"))
		to_chat(M, SPAN_BOLD("地球的法律适用于太阳系以外。即使他人堕入腐败，你也坚守道德准则。"))
		to_chat(M, SPAN_BOLD("企业人员追逐薪水和晋升，你却致力于履行誓言、照顾民众，无论殖民地多么遥远或孤立。"))
		to_chat(M, SPAN_BOLD("尽管人手不足，执法官坚定的誓言仍让各地社区保持安全，殖民地执法局受到许多人的尊重。你同样代表这份誓言，应以出色表现履行职责。"))

/datum/emergency_call/inspection_cmb/black_market
	name = "Inspection - Colonial Marshals Ledger Investigation Team"
	mob_max = 3 //Marshal, Deputy, ICC CL
	mob_min = 2
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2

	max_synths = 0
	will_spawn_icc_liaison = TRUE
	will_spawn_cmb_observer = FALSE

/datum/emergency_call/inspection_cmb/black_market/New()
	..()
	dispatch_message = "第三舰队最高指挥部呼叫[MAIN_SHIP_NAME]。我们收到的补给清单存在矛盾，你舰自动仓储检索系统也有异常，因此已要求殖民地执法局调查组登舰调查，确认你们是否存在违规行为。"
	arrival_message = "收到传讯：[MAIN_SHIP_NAME]，这里是锚点空间站殖民地执法局。应GSO-91请求，我们正派遣一组执法人员登舰。现提交授权对接许可，完毕。"
	objectives = "调查 [MAIN_SHIP_NAME] 自动仓储检索系统的异常。若发现违法行为，收集证据并向锚点空间站殖民地执法局指挥部报告。必要时，星际商业委员会联络员的交易频段合规设备可修复自动仓储检索系统计算机。请与 [MAIN_SHIP_NAME] 的宪兵部队合作。"

/datum/emergency_call/inspection_cmb/black_market/create_member(datum/mind/current_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	current_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是殖民地执法官！"))
		arm_equipment(mob, /datum/equipment_preset/cmb/marshal, TRUE, TRUE)
	else if(!icc_liaison && will_spawn_icc_liaison && check_timelock(mob.client, JOB_CORPORATE_LIAISON, time_required_for_job))
		icc_liaison = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是派驻殖民地执法局的星际商业委员会联络员！"))
		arm_equipment(mob, /datum/equipment_preset/cmb/liaison, TRUE, TRUE) //ICC CL gets a custom item
	else
		to_chat(mob, SPAN_ROLE_HEADER("你是殖民地执法局的副执法官！"))
		arm_equipment(mob, /datum/equipment_preset/cmb/deputy, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)
