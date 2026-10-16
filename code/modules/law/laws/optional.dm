/datum/law/optional_law
	severity = OPTIONAL_CRIME

/datum/law/optional_law/minor_unruly
	name = "拘押期间轻度扰乱秩序"
	desc = "被捕并关押在禁闭室期间，以轻微程度扰乱秩序，即实施违反轻罪条款的行为。此项可附加于任何指控。"
	brig_time = 7.5
/datum/law/optional_law/aiding
	name = "协助与教唆犯罪"
	desc = "直接或间接协助他人犯罪，或鼓励他人犯罪。"
	brig_time = 10
	special_punishment = "与主犯相同"

/datum/law/optional_law/resisting
	name = "拒捕"
	desc = "抗拒宪兵依法实施的逮捕或搜查。"
	brig_time = 10

/datum/law/optional_law/major_unruly
	name = "拘押期间严重扰乱秩序"
	desc = "被捕并关押在禁闭室期间，以严重程度扰乱秩序，即实施违反重罪条款的行为。此项可附加于任何指控。"
	brig_time = 15
