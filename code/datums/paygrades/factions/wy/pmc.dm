/datum/paygrade/pmc
	name = "PMC Paygrade"
	localized_name = "私人军事承包商职级"
	fprefix = "PMC."
	pay_multiplier = 2.5 // they have money. but they sold their soul to the company. is it really worth it
	default_faction = FACTION_PMC

//Standard PMCs
/datum/paygrade/pmc/standard
	paygrade = PAY_SHORT_PMC_OP
	name = "Operator"
	localized_name = "作战人员"
	localized_prefix = "作战人员"
	prefix = "OPR."

/datum/paygrade/pmc/enforcer
	paygrade = PAY_SHORT_PMC_EN
	name = "Enforcer"
	localized_name = "执法员"
	localized_prefix = "执法员"
	prefix = "ENF."
	pay_multiplier = 2.6

//PMC Field Specialists
/datum/paygrade/pmc/vehicle
	paygrade = PAY_SHORT_PMC_VS
	name = "Vehicle Specialist"
	localized_name = "载具专家"
	localized_prefix = "载具专家"
	prefix = "SPV."
	pay_multiplier = 2.8

/datum/paygrade/pmc/support
	paygrade = PAY_SHORT_PMC_SS
	name = "Support Specialist"
	localized_name = "支援专家"
	localized_prefix = "支援专家"
	prefix = "SPS."
	pay_multiplier = 2.8

/datum/paygrade/pmc/medic
	paygrade = PAY_SHORT_PMC_MS
	name = "Medical Specialist"
	localized_name = "医疗专家"
	localized_prefix = "医疗专家"
	prefix = "SPM."
	pay_multiplier = 2.8

/datum/paygrade/pmc/spec
	paygrade = PAY_SHORT_PMC_WS
	name = "Weapon Specialist"
	localized_name = "武器专家"
	localized_prefix = "武器专家"
	prefix = "SPW."
	pay_multiplier = 3

/datum/paygrade/pmc/handler
	paygrade = PAY_SHORT_PMC_XS
	name = "Xeno Specialist"
	localized_name = "异形专家"
	localized_prefix = "异形专家"
	prefix = "SPX."
	pay_multiplier = 4
	officer_grade = GRADE_OFFICER

//PMC Support Staff
/datum/paygrade/pmc/doctor
	paygrade = PAY_SHORT_PMC_DOC
	name = "Trauma Surgeon"
	localized_name = "创伤外科医生"
	localized_prefix = "创伤外科医生"
	prefix = "Dr."
	pay_multiplier = 4
	officer_grade = GRADE_OFFICER

/datum/paygrade/pmc/engineer
	paygrade = PAY_SHORT_PMC_TEC
	name = "Corporate Technician"
	localized_name = "公司技术员"
	localized_prefix = "公司技术员"
	prefix = "TEC."
	pay_multiplier = 4

//PMC Elite
/datum/paygrade/pmc/elite
	paygrade = PAY_SHORT_PMC_ELR
	name = "Elite Responder"
	localized_name = "精英应急队员"
	localized_prefix = "精英应急队员"
	prefix = "ELR."
	pay_multiplier = 4
	officer_grade = GRADE_OFFICER

/datum/paygrade/pmc/medic/elite
	paygrade = PAY_SHORT_PMC_ELM
	name = "Elite Medic"
	localized_name = "精英医疗兵"
	localized_prefix = "精英医疗兵"
	prefix = "ELM."
	pay_multiplier = 4.5
	officer_grade = GRADE_OFFICER

/datum/paygrade/pmc/spec/elite
	paygrade = PAY_SHORT_PMC_ELG
	name = "Elite Gunner"
	localized_name = "精英机枪手"
	localized_prefix = "精英机枪手"
	prefix = "ELG."
	pay_multiplier = 5
	officer_grade = GRADE_OFFICER

//PMC Command
/datum/paygrade/pmc/teamlead
	paygrade = PAY_SHORT_PMC_TL
	name = "Team Leader"
	localized_name = "小队长"
	localized_prefix = "小队长"
	prefix = "TML."
	pay_multiplier = 3.5
	officer_grade = GRADE_OFFICER

/datum/paygrade/pmc/oplead
	paygrade = "PMC-OL"
	name = "Operations Leader"
	localized_name = "行动指挥官"
	localized_prefix = "行动指挥官"
	prefix = "OPL."
	pay_multiplier = 3.5


/datum/paygrade/pmc/elitelead
	paygrade = PAY_SHORT_PMC_ETL
	name = "Elite Team Leader"
	localized_name = "精英小队长"
	localized_prefix = "精英小队长"
	prefix = "ETML."
	pay_multiplier = 5.5
	officer_grade = GRADE_OFFICER

/datum/paygrade/pmc/director
	paygrade = PAY_SHORT_PMC_DIR
	name = "Site Director"
	localized_name = "基地主管"
	localized_prefix = "基地主管"
	prefix = "DIR."
	pay_multiplier = 10 //it's a corpo director. money is what they care about.
	officer_grade = GRADE_FLAG

/datum/paygrade/pmc/overwatch
	paygrade = "PMC-OW"
	name = "Overwatch"
	localized_name = "战术监控员"
	localized_prefix = "战术监控员"
	prefix = "OW."
	pay_multiplier = 10
	officer_grade = GRADE_OFFICER
