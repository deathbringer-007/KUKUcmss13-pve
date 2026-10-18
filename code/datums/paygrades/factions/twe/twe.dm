/datum/paygrade/twe
	name = "TWE Paygrade"
	localized_name = "三世界帝国军衔"
	pay_multiplier = 2 // less people = more to pay them
	default_faction = FACTION_TWE

//RMC Emlisted
/datum/paygrade/twe/e1
	paygrade = PAY_SHORT_RMC1
	name = "Marine"
	localized_name = "陆战队员"
	localized_prefix = "陆战队员"
	prefix = "Mne"

/datum/paygrade/twe/e2
	paygrade = PAY_SHORT_RMC2
	name = "Lance Corporal"
	localized_name = "准下士"
	localized_prefix = "准下士"
	prefix = "LCpl"
	pay_multiplier = 2.1

/datum/paygrade/twe/e2n //RMC medics are attached naval personnel, don't see them forgoing this tradition even in the aliens universe
	paygrade = PAY_SHORT_RMC2N
	name = "Medical Assistant"
	localized_name = "医疗助理"
	localized_prefix = "医疗助理"
	prefix = "MA"
	pay_multiplier = 2.2

/datum/paygrade/twe/e2e //RMC gets combat engineering support from the army royal engineers, as above, don't see them changing that tradition
	paygrade = PAY_SHORT_RMC2E
	name = "Sapper"
	localized_name = "工兵"
	localized_prefix = "工兵"
	prefix = "Spr"
	pay_multiplier = 2

/datum/paygrade/twe/e2g //RMC also gets indirect fire support from the army royal artillery. Again, don't see them changing that tradition
	paygrade = PAY_SHORT_RMC2G
	name = "Gunner"
	localized_name = "炮手"
	localized_prefix = "炮手"
	prefix = "Gnr"
	pay_multiplier = 2

/datum/paygrade/twe/e3
	paygrade = PAY_SHORT_RMC3
	name = "Corporal"
	localized_name = "下士"
	localized_prefix = "下士"
	prefix = "Cpl"
	pay_multiplier = 2.2

/datum/paygrade/twe/e4
	paygrade = PAY_SHORT_RMC4
	name = "Sergeant"
	localized_name = "中士"
	localized_prefix = "中士"
	prefix = "Sgt"
	pay_multiplier = 2.3

/datum/paygrade/twe/e5
	paygrade = PAY_SHORT_RMC5
	name = "Colour Sergeant"
	localized_name = "掌旗上士"
	localized_prefix = "掌旗上士"
	prefix = "CSgt"
	pay_multiplier = 2.4

//RMC Warrant Officer - Different from US ones, equiv to US E8 & E9 technical & command track ranks for the brits
/datum/paygrade/twe/wo1
	paygrade = PAY_SHORT_RMOW
	name = "Warrant Officer"
	localized_name = "军士长"
	localized_prefix = "军士长"
	prefix = "WO"
	pay_multiplier = 3.5

//RMC Officers
/datum/paygrade/twe/o1
	paygrade = PAY_SHORT_RMO1
	name = "Second Lieutenant"
	localized_name = "少尉"
	localized_prefix = "少尉"
	prefix = "2nd LT"
	pay_multiplier = 3
	officer_grade = GRADE_OFFICER

/datum/paygrade/twe/o2
	paygrade = PAY_SHORT_RMO2
	name = "Lieutenant"
	localized_name = "中尉"
	localized_prefix = "中尉"
	prefix = "LT"
	pay_multiplier = 3.25
	officer_grade = GRADE_OFFICER

/datum/paygrade/twe/o3
	paygrade = PAY_SHORT_RMO3
	name = "Captain"
	localized_name = "上尉"
	localized_prefix = "上尉"
	prefix = "Capt"
	pay_multiplier = 3.5
	officer_grade = GRADE_OFFICER

/datum/paygrade/twe/o4
	paygrade = PAY_SHORT_RMO4
	name = "Major"
	localized_name = "少校"
	localized_prefix = "少校"
	prefix = "Maj"
	pay_multiplier = 5
	officer_grade = GRADE_OFFICER

/datum/paygrade/twe/o5
	paygrade = PAY_SHORT_RMO5
	name = "Lieutenant Colonel"
	localized_name = "中校"
	localized_prefix = "中校"
	prefix = "Lt Col"
	pay_multiplier = 7
	officer_grade = GRADE_OFFICER

/datum/paygrade/twe/o6
	paygrade = PAY_SHORT_RMO6
	name = "Colonel"
	localized_name = "上校"
	localized_prefix = "上校"
	prefix = "Col"
	pay_multiplier = 9
	officer_grade = GRADE_FLAG

/datum/paygrade/twe/o7
	paygrade = PAY_SHORT_RMO7
	name = "Brigadier"
	localized_name = "准将"
	localized_prefix = "准将"
	prefix = "Brig"
	pay_multiplier = 10
	officer_grade = GRADE_FLAG
