/datum/paygrade/contractors
	name = "Contractor Paygrade"
	localized_name = "承包商职级"
	fprefix = "VAI"
	pay_multiplier = 1.5

/datum/paygrade/contractors/standard
	paygrade = PAY_SHORT_VAI_S
	name = "VAI Mercenary"
	localized_name = "VAI雇佣兵"
	localized_prefix = "VAI雇佣兵"
	prefix = "Merc."

/datum/paygrade/contractors/med
	paygrade = PAY_SHORT_VAI_M
	name = "VAI Medical Specialist"
	localized_name = "VAI医疗专家"
	localized_prefix = "VAI医疗专家"
	prefix = "Med."
	pay_multiplier = 1.75

/datum/paygrade/contractors/mg
	paygrade = PAY_SHORT_VAI_G
	name = "VAI Machinegunner"
	localized_name = "VAI机枪手"
	localized_prefix = "VAI机枪手"
	prefix = "MG."
	pay_multiplier = 1.75

/datum/paygrade/contractors/engi
	paygrade = PAY_SHORT_VAI_E
	name = "VAI Engineering Specialist"
	localized_name = "VAI工程专家"
	localized_prefix = "VAI工程专家"
	prefix = "Eng."
	pay_multiplier = 1.75

/datum/paygrade/contractors/syn
	paygrade = PAY_SHORT_VAI_SN
	name = "VAI Synthetic"
	localized_name = "VAI合成人"
	pay_multiplier = 0

/datum/paygrade/contractors/lead
	paygrade = PAY_SHORT_VAI_L
	name = "VAI Team Leader"
	localized_name = "VAI小队长"
	localized_prefix = "VAI小队长"
	prefix = "TL."
	pay_multiplier = 2.25
	officer_grade = GRADE_OFFICER
