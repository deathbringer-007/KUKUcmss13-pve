// The Colonial Marshal Bureau, a UA Federal investigative/law enforcement functionary from Sol which oversees many colonies among the frontier. They are friendly to USCM.
/datum/emergency_call/cmb
	name = "CMB - Colonial Marshals Patrol Team (Friendly)"
	mob_max = 5
	probability = 10
	home_base = /datum/lazy_template/ert/weyland_station

	var/max_synths = 1
	var/synths = 0

	var/will_spawn_icc_liaison
	var/icc_liaison

	var/will_spawn_cmb_observer
	var/cmb_observer


/datum/emergency_call/cmb/New()
	..()
	arrival_message = "收到传讯：[MAIN_SHIP_NAME]，这里是锚点空间站殖民地执法局。我们已收到求救信号，正派遣附近的小队登舰。请待命。"
	objectives = "调查 [MAIN_SHIP_NAME] 上的求救信号，尽可能协助船员开展救援。如有必要，一支殖民地陆战队分队可作为快速反应部队支援你们。"

	will_spawn_icc_liaison = prob(50)
	will_spawn_cmb_observer = prob(20)

/datum/emergency_call/cmb/create_member(datum/mind/M, turf/override_spawn_loc)
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


/datum/emergency_call/cmb/print_backstory(mob/living/carbon/human/M)
	if(M == leader)
		to_chat(M, SPAN_BOLD("你是殖民地执法官，来自[pick(70;"美洲联盟", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你通过[pick(50; "大学期间选择执法职业", 40;"从事执法工作", 10;"凭借自身技能被招募")]加入执法局。"))
		to_chat(M, SPAN_BOLD("你在银河各地不断晋升，因坚定维护正义、打击犯罪与腐败而闻名。"))
		to_chat(M, SPAN_BOLD("你原本正在前往处理[pick(20; "凶杀案", 20;"企业腐败调查", 10; "人质事件", 10;"恐怖袭击", 10;"囚犯转运", 10;"缉毒突袭", 10;"逃犯据守事件", 5;"涉嫌走私事件", 5;"人口贩卖事件" )]，却因求救信标被锚点空间站指挥部改派往 [MAIN_SHIP_NAME]。"))
		to_chat(M, SPAN_BOLD("地球的法律适用于太阳系以外。即使他人受到诱惑、堕入腐败，你也坚守道德准则。"))
		to_chat(M, SPAN_BOLD("企业人员追逐薪水和晋升，你却致力于履行誓言、照顾民众，无论殖民地多么遥远或孤立。"))
		to_chat(M, SPAN_BOLD("你在尼洛德星区见过许多事。你能来到这里，是因为你是最优秀的人，坚持做正确的事，让边疆变得更好。"))
		to_chat(M, SPAN_BOLD("尽管人手不足，执法官坚定的誓言仍让各地社区保持安全，殖民地执法局受到许多人的尊重。你代表着这份誓言，应以出色表现履行职责。"))
	else if(issynth(M))
		to_chat(M, SPAN_BOLD("虽然型号较老，你仍凭借敏锐的感知和警觉性受到同僚认可。"))
		to_chat(M, SPAN_BOLD("除执法程序外，你还被编程为寻找证据、分析化学品及调查犯罪的顶尖专家。"))
		to_chat(M, SPAN_BOLD("你不负责执行《陆战队军法》，也不受其约束，但你了解其内容。"))
		to_chat(M, SPAN_BOLD("在太阳系完成软件和法律资料更新后，你被派往锚点空间站，协助边疆的殖民地执法局单位。"))
		to_chat(M, SPAN_BOLD("你原本正在前往调查，却因求救信标被指挥部改派往 [MAIN_SHIP_NAME]。"))
		to_chat(M, SPAN_BOLD("必要时，可将背包中携带的轻型弹药和装备储备分发给团队。"))
		to_chat(M, SPAN_BOLD("尽管人手不足，执法官坚定的誓言仍让各地社区保持安全，殖民地执法局受到许多人的尊重。你同样代表这份誓言，应以出色表现履行职责。"))
	else if(M == icc_liaison)
		to_chat(M, SPAN_BOLD("你是星际商业联络员，来自[pick(70;"美洲联盟", 25;"太阳系", 5;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你对维兰德-汤谷持[pick(30; "怀疑", 40;"友好", 30;"支持")]态度。"))
		to_chat(M, SPAN_BOLD("你的耳机能接收多个频段，其中还有星际商业委员会母公司维兰德-汤谷赠送的密钥，试图以此争取你的支持。请用它联络。"))
		to_chat(M, SPAN_BOLD("你是派驻锚点空间站殖民地执法局办事处的星际商业委员会专员，负责观察并确保贸易公平。"))
		to_chat(M, SPAN_BOLD("与这些声誉良好的人共事，使你变得更有德行，尤其比起其他大组织的企业联络员。"))
		to_chat(M, SPAN_BOLD("协助殖民地执法官开展调查。若怀疑存在走私或非法贸易，应向指挥部报告。"))
		to_chat(M, SPAN_BOLD("你原本正在前往犯罪现场，却因求救信标而被改派往 [MAIN_SHIP_NAME]。"))
	else if(M == cmb_observer)
		to_chat(M, SPAN_BOLD("你是星际人权观察员，来自[pick(50;"美洲联盟", 10;"欧洲", 10;"月球", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你对维兰德-汤谷及其做法持[pick(60; "怀疑", 40;"友好", 10;"支持")]态度。"))
		to_chat(M, SPAN_BOLD("你对美国殖民地海军陆战队在边疆的行动持[pick(40; "怀疑", 30;"友好", 30;"支持")]态度。"))
		to_chat(M, SPAN_BOLD("经过大量努力，你的组织终于说服殖民地执法官带你前往边疆，为一篇关于当地生活质量的文章搜集资料。"))
		to_chat(M, SPAN_BOLD("观察执法人员的行动，留意其他人是否存在不人道行为。尼洛德星区的各方势力都不乏暴行。"))
		to_chat(M, SPAN_BOLD("不要挑起或发动任何对抗。你是观察员，不参与战争，只有遇到医疗紧急情况时才能介入。"))
		to_chat(M, SPAN_BOLD("你原本正在前往犯罪现场，却因求救信标而被改派往 [MAIN_SHIP_NAME]。"))
	else
		to_chat(M, SPAN_BOLD("你是殖民地执法局的副执法官，来自[pick(70;"美洲联盟", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你通过[pick(50; "大学期间选择执法职业", 40;"从事执法工作", 10;"凭借自身技能被招募")]加入执法局。"))
		to_chat(M, SPAN_BOLD("在执法官的带领下，你因坚定维护正义、打击犯罪与腐败而闻名。"))
		to_chat(M, SPAN_BOLD("你原本正在前往调查，却因求救信标被锚点空间站指挥部改派往 [MAIN_SHIP_NAME]。"))
		to_chat(M, SPAN_BOLD("你已在锚点空间站驻扎[pick(80;"数月", 10;"仅仅一周", 10;"多年")]，调查边疆的恶性犯罪。"))
		to_chat(M, SPAN_BOLD("地球的法律适用于太阳系以外。即使他人堕入腐败，你也坚守道德准则。"))
		to_chat(M, SPAN_BOLD("企业人员追逐薪水和晋升，你却致力于履行誓言、照顾民众，无论殖民地多么遥远或孤立。"))
		to_chat(M, SPAN_BOLD("尽管人手不足，执法官坚定的誓言仍让各地社区保持安全，殖民地执法局受到许多人的尊重。你同样代表这份誓言，应以出色表现履行职责。"))


// A Nearby Colonial Marshal patrol team responding to Marshals in Distress.
/datum/emergency_call/cmb/alt
	name = "CMB - Patrol Team - Marshals in Distress (Friendly)"
	mob_max = 5
	mob_min = 1
	probability = 0

/datum/emergency_call/cmb/alt/New()
	..()
	arrival_message = "执法局小队，这里是锚点空间站。我们已确认你们遇险，正在调派附近单位支援！"
	objectives = "5807巡逻单位，附近有执法人员遇险！立即找到并支援他们。"

// Anchorpoint Station Colonial Marines, use this primarily for reinforcing or evacuating the CMB, as the CMB themselves are not equipped to handle heavy engagements.
/datum/emergency_call/cmb/anchorpoint
	name = "CMB - Anchorpoint Station Colonial Marine QRF (Friendly)"
	mob_max = 6
	mob_min = 3
	max_medics = 1
	max_engineers = 1
	max_smartgunners = 1
	probability = 0

/datum/emergency_call/cmb/anchorpoint/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME]，这里是锚点空间站。一支殖民地陆战队快速反应小队正尝试登舰。请开放舱口，现传送对接代码。请待命。"
	objectives = "快速反应小队，你们负责支援先前部署的殖民地执法局小队。与执法官及副执法官取得联系并合作，必要时保护并协助他们撤离。次要目标：调查 [MAIN_SHIP_NAME] 发出求救的原因，尽可能协助船员。"

/datum/emergency_call/cmb/anchorpoint/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("你是锚点空间站陆战队战斗组的组长！"))
		arm_equipment(mob, /datum/equipment_preset/uscm/leader_equipped, TRUE, TRUE) // placeholder
	else if(smartgunners < max_smartgunners && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("你是锚点空间站的一名智能机枪手！"))
		arm_equipment(mob, /datum/equipment_preset/uscm/smartgunner_equipped, TRUE, TRUE)
	else if (medics < max_medics && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("你是锚点空间站的一名陆战队医疗兵！"))
		arm_equipment(mob, /datum/equipment_preset/uscm/medic_equipped, TRUE, TRUE)
	else if(engineers < max_engineers && HAS_FLAG(mob?.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		to_chat(mob, SPAN_ROLE_HEADER("你是锚点空间站的一名技术专家！"))
		arm_equipment(mob, /datum/equipment_preset/uscm/tl_equipped, TRUE, TRUE)
	else
		to_chat(mob, SPAN_ROLE_HEADER("你是锚点空间站的一名陆战队步枪兵！"))
		arm_equipment(mob, /datum/equipment_preset/uscm/private_equipped, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("目标：</b>[objectives]")), 1 SECONDS)


/datum/emergency_call/cmb/anchorpoint/print_backstory(mob/living/carbon/human/M)
	if(M == leader)
		to_chat(M, SPAN_BOLD("你是锚点空间站快速反应部队的战斗组长，来自[pick(70;"美洲联盟", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你已在空间站服役[pick(50; "一个太阳年、一个轮值期", 40;"几个月", 10;"六年、三个轮值期")]。"))
		to_chat(M, SPAN_BOLD("在锚点空间站与殖民地执法官共同生活、训练和工作，让你保持严明纪律，也一直为自己能担当援军而自豪。"))
		to_chat(M, SPAN_BOLD("在锚点空间站期间，你[pick(20; "曾被殖民地执法官救过性命", 20;"平息过一场企业暴乱", 10; "抵御过进步人民联盟对空间站的入侵", 10;"经历过病原体疫情", 10;"在实施戒严时协助过殖民地执法官", 10;"曾被派往 [MAIN_SHIP_NAME]，了解其布局", 10;"协助殖民地执法官处理过逃犯据守事件", 5;"帮助星际商业委员会打掉过一个涉嫌走私的团伙", 5;"与殖民地执法官一起挫败过人口贩卖活动" )]。"))
		to_chat(M, SPAN_BOLD("多次与殖民地执法官共同处理事件，使两个组织之间建立了情谊。他们负责调查和警务，而你们在暴乱或入侵时出面解决问题。哪里需要硬仗，哪里就有你们。"))
		to_chat(M, SPAN_BOLD("你作为快速反应部队的一员被召集，前去支援陷入困境的殖民地执法官。"))
		to_chat(M, SPAN_BOLD("你原本不确定这是否误报，结果并不是……"))
		to_chat(M, SPAN_BOLD("看来又到你们担当援军的时候了。向部下简报，出发！"))
	else if(M == smartgunners)
		to_chat(M, SPAN_BOLD("你是锚点空间站快速反应部队的智能机枪手，来自[pick(70;"美洲联盟", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你已在空间站服役[pick(45; "一个太阳年、一个轮值期", 20;"几个月", 5;"漫长的六年、连续三个轮值期")]。"))
		to_chat(M, SPAN_BOLD("在锚点空间站与殖民地执法官共同生活、训练和工作，让你保持严明纪律，也一直为自己能担当援军而自豪。"))
		to_chat(M, SPAN_BOLD("在锚点空间站期间，你[pick(20; "曾被殖民地执法官救过性命", 20;"平息过一场企业暴乱", 10; "抵御过进步人民联盟对空间站的入侵", 10;"经历过病原体疫情", 10;"在实施戒严时协助过殖民地执法官", 10;"曾被派往 [MAIN_SHIP_NAME]，了解其布局", 10;"协助殖民地执法官处理过逃犯据守事件", 5;"帮助星际商业委员会打掉过一个涉嫌走私的团伙", 5;"与殖民地执法官一起挫败过人口贩卖活动" )]。"))
		to_chat(M, SPAN_BOLD("多次与殖民地执法官共同处理事件，使两个组织之间建立了情谊。他们负责调查和警务，而你们在暴乱或入侵时出面解决问题。哪里需要硬仗，哪里就有你们。"))
		to_chat(M, SPAN_BOLD("你作为快速反应部队的一员被召集，前去支援陷入困境的殖民地执法官。"))
		to_chat(M, SPAN_BOLD("你原本不确定这是否误报，结果并不是……不过，你早就在等一个让M56尽情开火的理由。"))
		to_chat(M, SPAN_BOLD("看来又到你们担当援军的时候了。来大干一场吧！"))
	else if(M == medics)
		to_chat(M, SPAN_BOLD("你是锚点空间站快速反应部队的医疗兵，来自[pick(70;"美洲联盟", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你已在空间站服役[pick(45; "一个太阳年、一个轮值期", 20;"几个月", 5;"漫长的六年、连续三个轮值期")]。"))
		to_chat(M, SPAN_BOLD("在锚点空间站与殖民地执法官共同生活、训练和工作，让你保持严明纪律，也一直为自己能担当援军而自豪。"))
		to_chat(M, SPAN_BOLD("在锚点空间站期间，你[pick(20; "曾被殖民地执法官救过性命", 20;"平息过一场企业暴乱", 10; "抵御过进步人民联盟对空间站的入侵", 10;"经历过病原体疫情", 10;"在实施戒严时协助过殖民地执法官", 10;"曾被派往 [MAIN_SHIP_NAME]，了解其布局", 10;"协助殖民地执法官处理过逃犯据守事件", 5;"帮助星际商业委员会打掉过一个涉嫌走私的团伙", 5;"与殖民地执法官一起挫败过人口贩卖活动" )]。"))
		to_chat(M, SPAN_BOLD("多次与殖民地执法官共同处理事件，使两个组织之间建立了情谊。他们负责调查和警务，而你们在暴乱或入侵时出面解决问题。哪里需要硬仗，哪里就有你们。"))
		to_chat(M, SPAN_BOLD("你作为快速反应部队的一员被召集，前去支援陷入困境的殖民地执法官。"))
		to_chat(M, SPAN_BOLD("你原本不确定这是否误报，结果并不是……"))
		to_chat(M, SPAN_BOLD("看来又到你们担当援军的时候了。"))
	else if(M == engineers)
		to_chat(M, SPAN_BOLD("你是锚点空间站快速反应部队的技术专家，来自[pick(70;"美洲联盟", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你已在空间站服役[pick(45; "一个太阳年、一个轮值期", 20;"几个月", 5;"漫长的六年、连续三个轮值期")]。"))
		to_chat(M, SPAN_BOLD("在锚点空间站与殖民地执法官共同生活、训练和工作，让你保持严明纪律，也一直为自己能担当援军而自豪。"))
		to_chat(M, SPAN_BOLD("在锚点空间站期间，你[pick(20; "曾被殖民地执法官救过性命", 20;"平息过一场企业暴乱", 10; "抵御过进步人民联盟对空间站的入侵", 10;"经历过病原体疫情", 10;"在实施戒严时协助过殖民地执法官", 10;"曾被派往 [MAIN_SHIP_NAME]，了解其布局", 10;"协助殖民地执法官处理过逃犯据守事件", 5;"帮助星际商业委员会打掉过一个涉嫌走私的团伙", 5;"与殖民地执法官一起挫败过人口贩卖活动" )]。"))
		to_chat(M, SPAN_BOLD("多次与殖民地执法官共同处理事件，使两个组织之间建立了情谊。他们负责调查和警务，而你们在暴乱或入侵时出面解决问题。哪里需要硬仗，哪里就有你们。"))
		to_chat(M, SPAN_BOLD("你作为快速反应部队的一员被召集，前去支援陷入困境的殖民地执法官。"))
		to_chat(M, SPAN_BOLD("你原本不确定这是否误报，结果并不是……"))
		to_chat(M, SPAN_BOLD("看来又到你们担当援军的时候了。信号清晰。"))
	else
		to_chat(M, SPAN_BOLD("你是锚点空间站快速反应部队的一名步枪兵，来自[pick(70;"美洲联盟", 20;"太阳系", 10;"边疆的一个殖民地")]。"))
		to_chat(M, SPAN_BOLD("你已在空间站服役[pick(45; "一个太阳年、一个轮值期", 20;"几个月", 5;"漫长的六年、连续三个轮值期")]。"))
		to_chat(M, SPAN_BOLD("在锚点空间站与殖民地执法官共同生活、训练和工作，让你保持严明纪律，也一直为自己能担当援军而自豪。"))
		to_chat(M, SPAN_BOLD("在锚点空间站期间，你[pick(20; "曾被殖民地执法官救过性命", 20;"平息过一场企业暴乱", 10; "抵御过进步人民联盟对空间站的入侵", 10;"经历过病原体疫情", 10;"在实施戒严时协助过殖民地执法官", 10;"曾被派往 [MAIN_SHIP_NAME]，了解其布局", 10;"协助殖民地执法官处理过逃犯据守事件", 5;"帮助星际商业委员会打掉过一个涉嫌走私的团伙", 5;"与殖民地执法官一起挫败过人口贩卖活动" )]。"))
		to_chat(M, SPAN_BOLD("多次与殖民地执法官共同处理事件，使两个组织之间建立了情谊。他们负责调查和警务，而你们在暴乱或入侵时出面解决问题。哪里需要硬仗，哪里就有你们。"))
		to_chat(M, SPAN_BOLD("你作为快速反应部队的一员被召集，前去支援陷入困境的殖民地执法官。"))
		to_chat(M, SPAN_BOLD("你原本不确定这是否误报，结果并不是……"))
		to_chat(M, SPAN_BOLD("看来又到你们担当援军的时候了。"))
