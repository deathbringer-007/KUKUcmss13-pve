/datum/paygrade/upp
	name = "UPP Paygrade"
	localized_name = "进步人民联盟军衔"
	pay_multiplier = 0.1 //lol. lmao
	default_faction = FACTION_UPP


//UPP Enlisted

/datum/paygrade/upp/ue1
	paygrade = PAY_SHORT_UE1
	name = "Private"
	localized_name = "列兵"
	localized_prefix = "列兵"
	prefix = "Pvt."

/datum/paygrade/upp/ue2
	paygrade = PAY_SHORT_UE2
	name = "Senior Private"
	localized_name = "上等兵"
	localized_prefix = "上等兵"
	prefix = "SrPvt."
	pay_multiplier = 0.2

/datum/paygrade/upp/ue3
	paygrade = PAY_SHORT_UE3
	name = "Corporal"
	localized_name = "下士"
	localized_prefix = "下士"
	prefix = "Cpl."
	pay_multiplier = 0.3

/datum/paygrade/upp/ue4
	paygrade = PAY_SHORT_UE4
	name = "Junior Sergeant"
	localized_name = "初级中士"
	localized_prefix = "初级中士"
	prefix = "JrSgt."
	pay_multiplier = 0.5

/datum/paygrade/upp/ue5
	paygrade = PAY_SHORT_UE5
	name = "Sergeant"
	localized_name = "中士"
	localized_prefix = "中士"
	prefix = "Sgt."
	pay_multiplier = 0.7

/datum/paygrade/upp/ue6
	paygrade = PAY_SHORT_UE6
	name = "Senior Sergeant"
	localized_name = "高级中士"
	localized_prefix = "高级中士"
	prefix = "SrSgt."
	pay_multiplier = 0.9

/datum/paygrade/upp/ue7
	paygrade = PAY_SHORT_UE7
	name = "Sergeant Major"
	localized_name = "总军士长"
	localized_prefix = "总军士长"
	prefix = "SgtMaj."
	pay_multiplier = 1

//UPP Commandos
/datum/paygrade/upp/uk1
	paygrade = "UK1"
	name = "Junior Kommando"
	localized_name = "初级突击队员"
	localized_prefix = "初级突击队员"
	prefix = "JKdo."
	pay_multiplier = 1.5

/datum/paygrade/upp/uk2
	paygrade = "UK2"
	name = "2nd Kommando"
	localized_name = "二级突击队员"
	localized_prefix = "二级突击队员"
	prefix = "2ndKdo."
	pay_multiplier = 2
	officer_grade = GRADE_OFFICER

/datum/paygrade/upp/uk3
	paygrade = "UK3"
	name = "1st Kommando"
	localized_name = "一级突击队员"
	localized_prefix = "一级突击队员"
	prefix = "1stKdo."
	pay_multiplier = 2.5
	officer_grade = GRADE_OFFICER

//UPP Officers
/datum/paygrade/upp/uo1
	paygrade = PAY_SHORT_UO1
	name = "Junior Lieutenant"
	localized_name = "初级中尉"
	localized_prefix = "初级中尉"
	prefix = "Jr. Lt."
	pay_multiplier = 1.25
	officer_grade = GRADE_OFFICER

/datum/paygrade/upp/uo2
	paygrade = PAY_SHORT_UO2
	name = "Senior Lieutenant"
	localized_name = "高级中尉"
	localized_prefix = "高级中尉"
	prefix = "Sr. LT."
	pay_multiplier = 1.5
	officer_grade = GRADE_OFFICER

/datum/paygrade/upp/uo3
	paygrade = PAY_SHORT_UO3
	name = "Captain"
	localized_name = "上尉"
	localized_prefix = "上尉"
	prefix = "Cpt."
	pay_multiplier = 2
	officer_grade = GRADE_OFFICER

/datum/paygrade/upp/uo4
	paygrade = PAY_SHORT_UO4
	name = "Major"
	localized_name = "少校"
	localized_prefix = "少校"
	prefix = "Mjr."
	pay_multiplier = 2.5
	officer_grade = GRADE_OFFICER

/datum/paygrade/upp/uo4p
	paygrade = PAY_SHORT_UO4P
	name = "Political Commissar"
	localized_name = "政治委员"
	localized_prefix = "政治委员"
	prefix = "Pol."
	pay_multiplier = 5
	officer_grade = GRADE_OFFICER

/datum/paygrade/upp/uo5
	paygrade = PAY_SHORT_UO5
	name = "Lieutenant Colonel"
	localized_name = "中校"
	localized_prefix = "中校"
	prefix = "Lt. Col."
	pay_multiplier = 3
	officer_grade = GRADE_OFFICER

/datum/paygrade/upp/uo6
	paygrade = PAY_SHORT_UO6
	name = "Colonel"
	localized_name = "上校"
	localized_prefix = "上校"
	prefix = "Col."
	pay_multiplier = 4
	officer_grade = GRADE_OFFICER

/datum/paygrade/upp/uo7
	paygrade = PAY_SHORT_UO7
	name = "Major General"
	localized_name = "少将"
	localized_prefix = "少将"
	prefix = "Maj. Gen."
	pay_multiplier = 5
	officer_grade = GRADE_FLAG

/datum/paygrade/upp/uo8
	paygrade = PAY_SHORT_UO8
	name = "Lieutenant General"
	localized_name = "中将"
	localized_prefix = "中将"
	prefix = "Lt. Gen."
	pay_multiplier = 6
	officer_grade = GRADE_FLAG

/datum/paygrade/upp/uo9
	paygrade = PAY_SHORT_UO9
	name = "Army General"
	localized_name = "大将"
	localized_prefix = "大将"
	prefix = "Gen."
	pay_multiplier = 7
	officer_grade = GRADE_FLAG

//UPP Colonists

/datum/paygrade/upp/militsiya
	paygrade = PAY_SHORT_UC1
	name = "Militsioner"
	localized_name = "民警"
	localized_prefix = "民警"
	prefix = "Milit."
	pay_multiplier = 0.3
