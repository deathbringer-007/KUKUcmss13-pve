/datum/law/major_law
	severity = MAJOR_CRIME

/datum/law/major_law/damage_to_government_property
	name = "损坏政府财产"
	desc = "严重损坏舰船，或违反标准操作规程擅自改造舰船，例如摧毁或拆除多面墙壁或多扇窗户。"
	special_punishment = "修复赔偿"
	brig_time = 10

/datum/law/major_law/disorderly_conduct
	name = "扰乱秩序"
	desc = "直接且故意干扰舰船主要事务，例如在补给处排队区斗殴或扰乱简报会议。"
	brig_time = 10

/datum/law/major_law/assault
	name = "袭击"
	desc = "怀有恶意威胁他人或对他人使用武力，但无杀人意图。"
	brig_time = 15

/datum/law/major_law/contraband
	name = "违禁品"
	desc = "持有或散布标准操作规程所定义的管制物质、未经授权的物品或武器，或摧心毒素等致失能、致醉或成瘾药物。不包括自行调配的医用药物混合物或剂量。"
	special_punishment = "没收违禁品"
	brig_time = 15

/datum/law/major_law/insubordination
	name = "违抗命令"
	desc = "未遵从上级专门向本人下达的合法命令。"
	brig_time = 15

/datum/law/major_law/interference
	name = "妨碍执法"
	desc = "恶意干扰正在依法实施的逮捕，明确试图阻碍逮捕行动。"
	brig_time = 15

/datum/law/major_law/neglect_of_duty
	name = "玩忽职守"
	desc = "未能以可接受的标准履行职责。例如指挥官未能妥善组织人员并确保下达命令，未遵循适当程序而损害履职，或舰员未经指挥官或部门负责人授权离舰。军官犯罪时，除相应罪名外，还可附加玩忽职守指控。"
	brig_time = 15

/datum/law/major_law/listening_bugs
	name = "未经授权使用窃听设备"
	desc = "违反标准操作规程，在战斗情报中心等受限区域使用窃听设备。使用与外国政府或恐怖组织有关的窃听设备还构成颠覆活动。"
	special_punishment = "没收窃听设备"
	brig_time = 15

/datum/law/major_law/subterfuge
	name = "颠覆活动"
	desc = "执行针对美国殖民地海军陆战队的行动目标，或与记载此类行动计划的材料有关。须有确凿证据证明当事人正在对抗陆战队。在受限区域使用与外国政府或恐怖组织有关的窃听设备也属于颠覆活动。"
	special_punishment = "注销身份卡／遣送至星球"
	brig_time = 15

/datum/law/major_law/assault_with_a_deadly_weapon
	name = "持致命武器袭击"
	desc = "怀有恶意，使用手枪、刀刃或步枪等致命武器威胁他人或对他人使用武力。"
	brig_time = 20

/datum/law/major_law/illegal_confinement
	name = "非法拘禁"
	desc = "违背他人意愿非法拘留，包括绑架、劫持人质，以及未提出犯罪指控便将人关入牢房。不适用于战俘。"
	brig_time = 20

/datum/law/major_law/manslaughter
	name = "过失杀人"
	desc = "无恶意杀害他人。若斗殴时并无杀人意图却造成死亡，可适用过失杀人指控。"
	brig_time = 20
	special_punishment = "降职"

/datum/law/major_law/prevarication
	name = "枉法执法"
	desc = "故意以虚假罪名下令逮捕事后证实无罪的人，或施加不当、滥用性质的非司法惩罚。也包括未接到命令而自行故意以虚假罪名逮捕他人。"
	brig_time = 20

/datum/law/major_law/sexual_harrasment
	name = "性骚扰"
	desc = "不受欢迎的性示好，或带有性意味的言语、身体行为。骚扰导致工作环境具有威胁性、敌意或侮辱性。"
	brig_time = 30

/datum/law/major_law/animal_cruelty
	name = "虐待动物"
	desc = "恶意伤害或杀死家养动物或野生动物。用于化学研究及科学用途的实验猴，以及具有敌意的野生动物除外。"
	brig_time = 30

/datum/law/major_law/misuse_of_authority
	name = "滥用职权"
	desc = "宪兵或代行宪兵职责的获授权人员恶意行使权力，例如殴打倒地囚犯、过度使用伤害性或非致命武力，或以其他虐待行为伤害被拘押者。对被拘留的嫌疑人所用武力不得超过制伏所需；对反抗或逃跑者，也仅可使用足以将其制伏的武力。"
	brig_time = 20

/datum/law/major_law/unauthorized_deployment
	name = "未经授权部署"
	desc = "仍以履行本职任务为目的，却未经相关部门负责人或适用情况下的指挥官许可进入作战区域。（例如医生未经许可，为实施战地手术而部署。）若无意履行本职任务，则仍按逃兵行为处理。"
	brig_time = 10
