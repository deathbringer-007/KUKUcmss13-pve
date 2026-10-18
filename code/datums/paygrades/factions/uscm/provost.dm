/datum/paygrade/provost
	name = "Provost Paygrade"
	localized_name = "军法监察职级"
	pay_multiplier = 2
	default_faction = FACTION_MARINE

/datum/paygrade/provost/inspector
	paygrade = PAY_SHORT_PVI
	name = "Provost Inspector"
	localized_name = "军法监察官"
	localized_prefix = "监察官"
	prefix = "Insp."
	rank_pin = /obj/item/clothing/accessory/ranks/special/insp
	officer_grade = GRADE_FLAG //Not really a flag officer, but they have special access to things for their job.

/datum/paygrade/provost/inspector/chief
	paygrade = PAY_SHORT_PVCI
	name = "Provost Chief Inspector"
	localized_name = "军法总监察官"
	localized_prefix = "总监察官"
	prefix = "Chief Insp."
	rank_pin = /obj/item/clothing/accessory/ranks/special/insp
	officer_grade = GRADE_FLAG //Not really a flag officer, but they have special access to things for their job.

/datum/paygrade/provost/marshal/deputy
	paygrade = PAY_SHORT_PVDM
	name = "Provost Deputy Marshal"
	localized_name = "军法副总监"
	localized_prefix = "副总监"
	prefix = "Dep. Marshal"
	officer_grade = GRADE_FLAG

/datum/paygrade/provost/marshal
	paygrade = PAY_SHORT_PVM
	name = "Provost Marshal"
	localized_name = "军法总监"
	localized_prefix = "总监"
	prefix = "Marshal"
	officer_grade = GRADE_FLAG

/datum/paygrade/provost/sectormarshal
	paygrade = PAY_SHORT_PVSM
	name = "Provost Sector Marshal"
	localized_name = "星区军法总监"
	localized_prefix = "星区军法总监"
	prefix = "S. Marshal"
	officer_grade = GRADE_FLAG

/datum/paygrade/provost/chiefmarshal
	paygrade = PAY_SHORT_PVCM
	name = "Provost Chief Marshal"
	localized_name = "军法总监长"
	localized_prefix = "总监长"
	prefix = "Chief Marshal"
	officer_grade = GRADE_FLAG
