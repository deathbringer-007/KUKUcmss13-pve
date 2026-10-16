/datum/law/minor_law
	severity = MINOR_CRIME

/datum/law/minor_law/contraband
	name = "违禁品"
	desc = "未经上士或更高军衔人员授权，持有来自作战区域的物品或武器。"
	special_punishment = "没收违禁品"
	brig_time = 7.5

/datum/law/minor_law/damage_to_government_property
	name = "损坏政府财产"
	desc = "轻度损坏舰船，或违反标准操作规程擅自改造舰船，例如打碎窗户或损伤墙壁。"
	special_punishment = "修复赔偿"
	brig_time = 7.5

/datum/law/minor_law/insubordination
	name = "违抗命令"
	desc = "未遵从上级下达、但并非专门针对本人的合法命令；或不尊重军衔或职务更高的非军官人员。"
	brig_time = 7.5

/datum/law/minor_law/interference
	name = "妨碍执法"
	desc = "并无恶意但妨碍了依法实施的逮捕，例如挡路或扶起被捕者。"
	brig_time = 7.5

/datum/law/minor_law/trespassing
	name = "擅自闯入"
	desc = "未经许可进入本人无权进入的区域，且未获有权限人员批准。"
	special_punishment = "押送离开"
	brig_time = 7.5

/datum/law/minor_law/listening_bugs
	name = "未经授权使用窃听设备"
	desc = "违反标准操作规程，在健身房等公共区域使用窃听设备。"
	special_punishment = "没收窃听设备"
	brig_time = 7.5

/datum/law/minor_law/disrespect
	name = "不敬上级军官"
	desc = "以侮辱性称呼或直接无礼的行为对待军衔或职务高于自己的委任军官。"
	brig_time = 10

/datum/law/minor_law/failure_to_follow_procedure
	name = "违反规程"
	desc = "未遵守标准操作规程中的规定。"
	special_punishment = "没收装备"
	brig_time = 10

/datum/law/minor_law/intoxication
	name = "醉酒或药物影响"
	desc = "饮酒或摄入致幻药物等物质，导致履职能力受损。"
	brig_time = 10

/datum/law/minor_law/theft
	name = "盗窃"
	desc = "未经明确许可取走他人或组织的物品或财产，或继续持有未经许可取得的物品。包括擅自将售货机移出部门区域。"
	special_punishment = "归还被盗物品"
	brig_time = 10

/datum/law/minor_law/false_testimony
	name = "伪证"
	desc = "在合法调查中，故意向宪兵或获授权执法的人员撒谎，意图妨碍调查。"
	brig_time = 5
