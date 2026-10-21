//*************************************
//----------------COMMANDER--------------
//*************************************/

/datum/job/command/commander/whiskey
	title = JOB_WO_CO
	gear_preset = /datum/equipment_preset/wo/commander

/datum/job/command/commander/whiskey/generate_entry_message()
	. = {"这一职位需要深入的角色扮演，你必须始终保持角色身份。
当地居民曾警告过你，在LV-624的丛林中建立基地可不是什么好主意……
坚守哨站一小时，直到能启动求救信标，向其余尘土突袭者发送信号！
协调队伍，准备防御，消灭巡逻队的东西正在赶来！
依靠海军少校和荣誉卫队队长的协助！
活下去，祝你顺利，指挥官！"}

/datum/job/command/commander/whiskey/announce_entry_message(mob/living/carbon/human/H)
	if(..())
		return
	sleep(15)
	if(H?.loc)
		marine_announcement("全体部队注意，地面指挥官[H.real_name]现已接管指挥！")


//*************************************
//---------EXECUITIVE OFFICER-----------
//*************************************/
/datum/job/command/executive/whiskey
	title = JOB_WO_XO
	gear_preset = /datum/equipment_preset/wo/xo

/datum/job/command/executive/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"从记事起，你就一直追随指挥官。与荣誉卫队队长那位运动健将相比，你向来是个埋头书本的书呆子，也因此成了指挥官的得力助手。
协助指挥官确保威士忌哨站坚持足够长的时间，直到能够发出求救信号。
为USCM争光！"}


//*************************************
//----------------CMP-------------
//*************************************/

//Chief MP
/datum/job/command/warrant/whiskey
	title = JOB_WO_CHIEF_POLICE
	selection_class = "job_honor_guard_sl"
	gear_preset = /datum/equipment_preset/wo/cmp

/datum/job/command/warrant/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"指挥官是这座哨站最大的希望！至少在你看来如此。你们多次互救性命，足以证明这一点；相识之久，已经没人记得清了。你是他的左膀右臂，位次仅在海军少校之后。你俩都是汉子，铁骨铮铮的汉子。
你的老兵经验丰富，能够使用战场监控台指挥其他人，但年轻人仍是刚从新兵营出来的菜鸟；把他们锻造成合格士兵，就是你的职责！
你必须率领指挥官的荣誉卫队，也就是他的精锐陆战队员，保护指挥官，确保胜利！
"}


//*************************************
//-------------STAFF OFFICER------------
//*************************************/
/datum/job/command/bridge/whiskey
	title = JOB_WO_SO
	gear_preset = /datum/equipment_preset/wo/vhg

/datum/job/command/bridge/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"你奉命在这片危险环境中保护指挥官，这一点并未改变。别浪费你接受的额外训练和配发的装备！
你历经多次战斗，因而获准接受更多训练，能够使用战场监控台并下达命令。
除了指挥官，你还应保卫整个掩体；外围防御就交给陆战队员。
荣耀归于指挥官，荣耀归于USCM。"}


//*************************************
//----------------CREWMAN---------------
//*************************************/
/datum/job/command/tank_crew/whiskey
	title = JOB_WO_CREWMAN
	gear_preset = /datum/equipment_preset/wo/hgs

/datum/job/command/tank_crew/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"你奉命在这片危险环境中保护指挥官，这一点并未改变。别浪费你接受的额外训练和配发的装备！
除了指挥官，你还应保卫整个掩体；外围防御就交给陆战队员。
你经历过许多战斗，因此接受了特种武器训练。好好发挥。
荣耀归于指挥官，荣耀归于USCM。"}


//*************************************
//------------MILITARY POLICE----------
//*************************************/
/datum/job/command/police/whiskey
	title = JOB_WO_POLICE
	gear_preset = /datum/equipment_preset/wo/hg

/datum/job/command/police/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"你奉命在这片危险环境中保护指挥官，这一点并未改变。别浪费你接受的额外训练和配发的装备！
除了指挥官，你还应保卫整个掩体；外围防御就交给陆战队员。
荣耀归于指挥官，荣耀归于USCM。"}


//*************************************
//----------------PILOT----------------
//*************************************/
/datum/job/command/pilot/whiskey
	title = JOB_WO_PILOT
	gear_preset = /datum/equipment_preset/wo/mortar_crew

/datum/job/command/pilot/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"你受托维护哨站的迫击炮。你原以为顶多炮击一些殖民地解放阵线人员，没想到会碰上这种情况……
监听无线电，集中注意力，为陆战队员提供火力支援。小心误伤友军！"}


//*************************************
//---------REQUISITIONS OFFICER--------
//*************************************/
/datum/job/logistics/requisition/whiskey
	title = JOB_WO_CHIEF_REQUISITION
	gear_preset = /datum/equipment_preset/wo/quartermaster

/datum/job/logistics/requisition/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"这是你的补给库，无论陆战队员还是怪物，谁都别想在这里为所欲为。
确保物资得到合理配给，不要浪费。其他哨站会尽力送来补给，务必物尽其用！
没有专职货运技师时，你可以命令掩体组员协助。"}


//*************************************
//--------CHIEF MEDICAL OFFICER--------
//*************************************/
/datum/job/civilian/professor/whiskey
	title = JOB_WO_CMO
	gear_preset = /datum/equipment_preset/wo/head_surgeon

/datum/job/civilian/professor/whiskey/generate_entry_message()
	. = {"你自愿协助地面的医疗工作。现在看来，这或许是个错误。
治疗伤员，指导分诊，并尽可能活得久一点。"}


//*************************************
//----------------DOCTOR---------------
//*************************************/
/datum/job/civilian/doctor/whiskey
	title = JOB_WO_DOCTOR
	gear_preset = /datum/equipment_preset/wo/doctor
	job_options = null //Does not inherit regular doctor's variants, uses unique preset instead.

/datum/job/civilian/doctor/whiskey/handle_job_options()
	return

/datum/job/civilian/doctor/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"你自愿协助地面的医疗工作。现在看来，这或许是个错误。
治疗伤员，进行分诊，并尽可能活得久一点。"}


//*************************************
//---------------RESEARCHER-------------
//*************************************/
/datum/job/civilian/researcher/whiskey
	title = JOB_WO_RESEARCHER
	gear_preset = /datum/equipment_preset/wo/chemist

/datum/job/civilian/researcher/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"你自愿协助生产药物，并检验本地野生动物能否安全食用。现在看来，这或许是个错误。
嘿，至少你现在可以试试那些被禁用的化学品了；反正这里也没人执法。"}


//*************************************
//------------CHIEF ENGINEER-----------
//*************************************/
/datum/job/logistics/engineering/whiskey
	title = JOB_WO_CHIEF_ENGINEER
	gear_preset = /datum/equipment_preset/wo/bcm

/datum/job/logistics/engineering/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"这座掩体里的一切都是你的，至少你表现得像是这样。你和手下把这里维护得很好，绝不会让任何肮脏的异形夺走它。
确保电力正常、掩体防御稳固。你与军需官共用这支掩体工作队。"}


//*************************************
//---------------MAINT TECH-------------
//*************************************/
/datum/job/logistics/tech/maint/whiskey
	title = JOB_WO_ORDNANCE_TECH
	supervisors = "掩体班长与军需官"
	gear_preset = /datum/equipment_preset/wo/bc

/datum/job/logistics/tech/maint/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"你在这里工作了一阵子，本以为这份差事挺安逸。现在却得为自己的性命而战了。祝你玩得开心。
协助掩体班长和军需官履行职责。"}


//*************************************
//--------------CARGO TECH-------------
//*************************************/
/datum/job/logistics/cargo/whiskey
	title = JOB_WO_REQUISITION
	supervisors = "掩体班长与军需官"
	selection_class = "job_bunker_crew"
	gear_preset = /datum/equipment_preset/wo/cargo


/datum/job/logistics/cargo/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"你在这里工作了一阵子，本以为这份差事挺安逸。现在却得为自己的性命而战了。祝你玩得开心。
协助掩体班长和军需官履行职责。"}


//Giving the liaison a role on whiskey outpost! Nothing can go wrong here. N o t h i n g.
//*************************************
//-----------------LIAISON---------------
//*************************************/
/datum/job/civilian/liaison/whiskey
	title = JOB_WO_CORPORATE_LIAISON
	supervisors = "新闻机构"
	gear_preset = /datum/equipment_preset/wo/reporter

/datum/job/civilian/liaison/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"大新闻！你跟着陆战队来到LV-624，想看看他们又会在这里惹出什么麻烦，结果麻烦自己找上门了！
这可能成为轰动全球的报道！“英勇陆战队员与未知敌对外星生命展开残酷战斗！”如果带回这样的新闻，办公室里的帕克森先生一定会注意到你！
你只需要先活着走出这片丛林，才能把故事讲出去！"}

//this calls  self-setting headsets for marines AFTER they are assigned squads
/datum/game_mode/whiskey_outpost/proc/self_set_headset(mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/obj/item/device/radio/headset/almayer/marine/self_setting/headset = H.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine/self_setting)
	if(headset)
		headset.self_set()
