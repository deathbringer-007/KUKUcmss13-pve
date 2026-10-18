/datum/paygrade/navy
	name = "Navy Paygrade"
	localized_name = "海军军衔"
	rank_pin = /obj/item/clothing/accessory/ranks/navy
	pay_multiplier = 1.8	//Less members but also more technical work, paid a bit better across the board
	default_faction = FACTION_NAVY

// ENLISTED PAYGRADES

/datum/paygrade/navy/e1
	paygrade = PAY_SHORT_NE1
	name = "Crewman Recruit"
	localized_name = "海军新兵"
	localized_prefix = "海军新兵"
	prefix = "CR"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e1
	ranking = 0
	pay_multiplier = 1.8

/datum/paygrade/navy/e2
	paygrade = PAY_SHORT_NE2
	name = "Crewman Apprentice"
	localized_name = "海军学徒兵"
	localized_prefix = "海军学徒兵"
	prefix = "CA"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e2
	ranking = 1
	pay_multiplier = 1.9

/datum/paygrade/navy/e3
	paygrade = PAY_SHORT_NE3
	name = "Crewman"
	localized_name = "海军水兵"
	localized_prefix = "海军水兵"
	prefix = "CMN"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e3
	ranking = 2
	pay_multiplier = 2.1

/datum/paygrade/navy/e4
	paygrade = PAY_SHORT_NE4
	name = "Petty Officer 3rd Class"
	localized_name = "海军三级军士"
	localized_prefix = "海军三级军士"
	prefix = "PO3"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e4
	ranking = 3
	pay_multiplier = 2.3

/datum/paygrade/navy/e5
	paygrade = PAY_SHORT_NE5
	name = "Petty Officer 2nd Class"
	localized_name = "海军二级军士"
	localized_prefix = "海军二级军士"
	prefix = "PO2"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e5
	ranking = 4
	pay_multiplier = 2.5

/datum/paygrade/navy/e6
	paygrade = PAY_SHORT_NE6
	name = "Petty Officer 1st Class"
	localized_name = "海军一级军士"
	localized_prefix = "海军一级军士"
	prefix = "PO1"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e6
	ranking = 5
	pay_multiplier = 2.7

/datum/paygrade/navy/e7
	paygrade = PAY_SHORT_NE7
	name = "Chief Petty Officer"
	localized_name = "海军上士"
	localized_prefix = "海军上士"
	prefix = "CPO"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e7
	ranking = 6
	pay_multiplier = 3

/datum/paygrade/navy/e8
	paygrade = PAY_SHORT_NE8
	name = "Senior Chief Petty Officer"
	localized_name = "海军高级上士"
	localized_prefix = "海军高级上士"
	prefix = "SCPO"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e8
	ranking = 7
	pay_multiplier = 3.1

/datum/paygrade/navy/e8c
	paygrade = PAY_SHORT_NE8C
	name = "Command Senior Chief Petty Officer"
	localized_name = "海军指挥高级上士"
	localized_prefix = "海军指挥高级上士"
	prefix = "CSCPO"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e8c
	ranking = 8
	pay_multiplier = 3.3

/datum/paygrade/navy/e9
	paygrade = PAY_SHORT_NE9
	name = "Master Chief Petty Officer"
	localized_name = "海军总军士长"
	localized_prefix = "海军总军士长"
	prefix = "MCPO"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e9
	ranking = 9
	pay_multiplier = 3.3

/datum/paygrade/navy/e9c
	paygrade = PAY_SHORT_NE9C
	name = "Command Master Chief Petty Officer"
	localized_name = "海军指挥总军士长"
	localized_prefix = "海军指挥总军士长"
	prefix = "CMCPO"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/e9c
	ranking = 10
	pay_multiplier = 3.5

// WARRANT OFFICER PAYGRADES

/datum/paygrade/navy/w1
	paygrade = PAY_SHORT_NW1
	name = "Warrant Officer"
	localized_name = "海军准尉"
	localized_prefix = "海军准尉"
	prefix = "WO1"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/w1
	ranking = 11
	pay_multiplier = 3.1	//Pay on par with E7 to begin with

/datum/paygrade/navy/w2
	paygrade = PAY_SHORT_NW2
	name = "Chief Warrant Officer 2"
	localized_name = "海军二级高级准尉"
	localized_prefix = "海军二级高级准尉"
	prefix = "CWO2"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/w2
	ranking = 12
	pay_multiplier = 3.2

/datum/paygrade/navy/w3
	paygrade = PAY_SHORT_NW3
	name = "Chief Warrant Officer 3"
	localized_name = "海军三级高级准尉"
	localized_prefix = "海军三级高级准尉"
	prefix = "CWO3"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/w3
	ranking = 13
	pay_multiplier = 3.3

/datum/paygrade/navy/w4
	paygrade = PAY_SHORT_NW4
	name = "Chief Warrant Officer 4"
	localized_name = "海军四级高级准尉"
	localized_prefix = "海军四级高级准尉"
	prefix = "CWO4"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/w4
	ranking = 14
	pay_multiplier = 3.4

/datum/paygrade/navy/w5
	paygrade = PAY_SHORT_NW5
	name = "Chief Warrant Officer 5"
	localized_name = "海军五级高级准尉"
	localized_prefix = "海军五级高级准尉"
	prefix = "CWO5"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/w5
	ranking = 15
	pay_multiplier = 3.5

// COMMISSIONED PAYGRADES

/datum/paygrade/navy/o1
	paygrade = PAY_SHORT_NO1
	name = "Ensign"
	localized_name = "海军少尉"
	localized_prefix = "海军少尉"
	prefix = "ENS"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o1
	ranking = 16
	pay_multiplier = 3.5
	officer_grade = GRADE_OFFICER

/datum/paygrade/navy/o2
	paygrade = PAY_SHORT_NO2
	name = "Lieutenant Junior Grade"
	localized_name = "海军中尉"
	localized_prefix = "海军中尉"
	prefix = "LTJG"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o2
	ranking = 17
	pay_multiplier = 3.7
	officer_grade = GRADE_OFFICER

/datum/paygrade/navy/o3
	paygrade = PAY_SHORT_NO3
	name = "Lieutenant"
	localized_name = "海军上尉"
	localized_prefix = "海军上尉"
	prefix = "LT"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o3
	ranking = 18
	pay_multiplier = 4.2
	officer_grade = GRADE_OFFICER

/datum/paygrade/navy/o4
	paygrade = PAY_SHORT_NO4
	name = "Lieutenant Commander"
	localized_name = "海军少校"
	localized_prefix = "海军少校"
	prefix = "LCDR"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o4
	ranking = 19
	pay_multiplier = 4.5
	officer_grade = GRADE_OFFICER

/datum/paygrade/navy/o5
	paygrade = PAY_SHORT_NO5
	name = "Commander"
	localized_name = "海军中校"
	localized_prefix = "海军中校"
	prefix = "CDR"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o5
	ranking = 20
	pay_multiplier = 4.8
	officer_grade = GRADE_OFFICER

/datum/paygrade/navy/o6
	paygrade = PAY_SHORT_NO6
	name = "Captain"
	localized_name = "海军上校"
	localized_prefix = "海军上校"
	prefix = "CAPT"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o6
	ranking = 21
	pay_multiplier = 5
	officer_grade = GRADE_OFFICER

/datum/paygrade/navy/o6e
	paygrade = PAY_SHORT_NO6E
	name = "Commodore"
	localized_name = "海军准将"
	localized_prefix = "海军准将"
	prefix = "CDRE"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o6e
	ranking = 22
	pay_multiplier = 5.2
	officer_grade = GRADE_OFFICER

/datum/paygrade/navy/o6c
	paygrade = PAY_SHORT_NO6C
	name = "Senior Commodore"
	localized_name = "海军高级准将"
	localized_prefix = "海军高级准将"
	prefix = "Snr CDRE"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o6e
	ranking = 23
	pay_multiplier = 5.4
	officer_grade = GRADE_OFFICER

// Admirality (Naval High Command)
/datum/paygrade/navy/o7
	paygrade = PAY_SHORT_NO7
	name = "Rear Admiral (Lower Half)"
	localized_name = "海军准少将"
	localized_prefix = "海军准少将"
	prefix = "RDML"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o7
	ranking = 24
	pay_multiplier = 7.5
	officer_grade = GRADE_FLAG

/datum/paygrade/navy/o8
	paygrade = PAY_SHORT_NO8
	name = "Rear Admiral (Upper Half)"
	localized_name = "海军少将"
	localized_prefix = "海军少将"
	prefix = "RADM"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o8
	ranking = 25
	pay_multiplier = 7.7
	officer_grade = GRADE_FLAG

/datum/paygrade/navy/o9
	paygrade = PAY_SHORT_NO9
	name = "Vice Admiral"
	localized_name = "海军中将"
	localized_prefix = "海军中将"
	prefix = "VADM"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o9
	ranking = 26
	pay_multiplier = 8
	officer_grade = GRADE_FLAG

/datum/paygrade/navy/o10
	paygrade = PAY_SHORT_NO10
	name = "Admiral"
	localized_name = "海军上将"
	localized_prefix = "海军上将"
	prefix = "ADM"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o10
	ranking = 27
	pay_multiplier = 8.2
	officer_grade = GRADE_FLAG

/datum/paygrade/navy/o10c
	paygrade = PAY_SHORT_NO10C
	name = "Chief of Aerospace Operations"
	localized_name = "航空航天作战部长"
	localized_prefix = "航空航天作战部长"
	prefix = "CAO"
	rank_pin = /obj/item/clothing/accessory/ranks/navy/o10c
	ranking = 28
	pay_multiplier = 8.5
	officer_grade = GRADE_FLAG
