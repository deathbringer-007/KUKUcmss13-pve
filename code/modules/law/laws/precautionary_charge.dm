/datum/law/precautionary_charge
	severity = PRECAUTIONARY_CHARGE
	brig_time = PERMABRIG_SENTENCE
	special_punishment = "不计入处决条件。"

/datum/law/precautionary_charge/discretionary_arrest
	name = "酌情拘留"
	desc = "指挥官为保障行动或安保的安全与利益，可基于任何理由酌情拘留人员。拘留时长可调整，指挥官可随时赦免或解除该项拘留。"
	special_punishment = "不计入处决条件。仅可向代理指挥官、军法监察机构或陆战队最高指挥部申诉。"

/datum/law/precautionary_charge/insanity
	name = "精神失常"
	desc = "行为表明当事人神志不清。经确认恢复神志后，可解除此项拘留。除自杀或自杀未遂情形外，仅首席医疗官或合成人可认定某人精神失常。"

/datum/law/precautionary_charge/prisoner_of_war
	name = "战俘"
	desc = "属于合法且获承认、当前与美国殖民地海军陆战队敌对的阵营。"
	special_punishment = "除特殊情况外，不得处决。"
