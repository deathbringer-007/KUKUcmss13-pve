/datum/paygrade/civilian
	name = "Civilian Paygrade"
	localized_name = "平民职级"
	pay_multiplier = 0.5 // civvies are poor

/datum/paygrade/civilian/civilian
	paygrade = PAY_SHORT_CIV
	name = "Civilian"
	localized_name = "平民"
	localized_prefix = "平民"
	prefix = null

/datum/paygrade/civilian/nurse
	paygrade = PAY_SHORT_CNUR
	name = "Nurse"
	localized_name = "护士"
	localized_prefix = "护士"
	prefix = "Nrs."

/datum/paygrade/civilian/doctor
	paygrade = PAY_SHORT_CDOC
	name = "Doctor"
	localized_name = "医生"
	localized_prefix = "医生"
	prefix = "Dr."
	pay_multiplier = 0.75

/datum/paygrade/civilian/professor
	paygrade = PAY_SHORT_CCMO
	name = "Professor"
	localized_name = "教授"
	localized_prefix = "教授"
	prefix = "Prof."
	pay_multiplier = 1
	officer_grade = GRADE_OFFICER

/datum/paygrade/civillian/representative
	paygrade = PAY_SHORT_CREP
	name = "Representative"
	localized_name = "代表"
	localized_prefix = "代表"
	prefix = "Rep."
	pay_multiplier = 1

/datum/paygrade/civillian/officer
	paygrade = PAY_SHORT_CPO
	name = "Officer"
	localized_name = "警官"
	localized_prefix = "警官"
	prefix = "Off."
	pay_multiplier = 0.66

/datum/paygrade/civillian/officer/senior
	paygrade = PAY_SHORT_CSPO
	name = "Senior Officer"
	localized_name = "高级警官"
	localized_prefix = "高级警官"
	prefix = "Sr. Off."
	pay_multiplier = 0.8
	officer_grade = GRADE_OFFICER

/datum/paygrade/civilian/rebel
	paygrade = PAY_SHORT_REB
	name = "Rebel"
	localized_name = "叛军"

/datum/paygrade/civilian/rebel/leader
	paygrade = PAY_SHORT_REBC
	name = "Rebel Commander"
	localized_name = "叛军指挥官"
	localized_prefix = "叛军指挥官"
	prefix = "CMDR."
	officer_grade = GRADE_OFFICER
