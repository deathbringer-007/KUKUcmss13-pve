//=========================//MARINES\\===================================//
//=======================================================================//


/obj/item/clothing/under/marine
	name = "USCM 制服"
	desc = "陆战队制式制服，在要害处装有文拉纤维护甲内衬，可抵御刀刃与枪弹。"
	siemens_coefficient = 0.9
	icon_state = "marine_jumpsuit"
	worn_state = "marine_jumpsuit"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	drop_sound = "armorequip"
	///Makes it so that we can see the right name in the vendor.
	var/specialty = "USCM"
	///List of map variants that use sleeve rolling on something else, like snow uniforms rolling the collar, and therefore shouldn't hide patches etc when rolled.
	var/list/map_variants_roll_accessories = list("s_")
	layer = UPPER_ITEM_LAYER

	//speciality does NOTHING if you have NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/Initialize(mapload, new_protection[] = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT), override_icon_state[] = null)
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]"
		if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
			name += "寒区制服"
		else
			name += "制服"
	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type, override_icon_state, new_protection)
	. = ..() //Done after above in case gamemode skin is missing sprites.

/obj/item/clothing/under/marine/set_sensors(mob/user)
	if(!skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
		to_chat(user, SPAN_WARNING("The sensors in \the [src] can't be modified."))
		return
	. = ..()

/obj/item/clothing/under/marine/standard
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/medic
	name = "USCM 医疗兵制服"
	desc = "陆战队医疗兵制式作训服，在要害处装有文拉纤维护甲内衬，可抵御刀刃与枪弹。"
	icon_state = "marine_medic"
	worn_state = "marine_medic"
	specialty = "USCM Hospital Corpsman"

/obj/item/clothing/under/marine/medic/standard
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/engineer
	name = "USCM 战斗技术员制服"
	desc = "USCMC 战斗技术员作训服，带有文拉纤维护板。由于“预算优先级调整”，已不再具备电气绝缘功能。"
	icon_state = "marine_engineer"
	worn_state = "marine_engineer"
	specialty = "USCM Combat Technician"

/obj/item/clothing/under/marine/engineer/standard
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/engineer/darker
	icon_state = "d_marine_engineer"
	worn_state = "d_marine_engineer"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/rto
	name = "\improper USCM radio telephone operator uniform"
	desc = "The uniform of a USCMC radio-telephone operator. Venlar panels provide marginal protection from shrapnel and ballistics."
	icon_state = "marine_rto"
	item_state = "marine_rto"
	specialty = "marine Radio Telephone Operator"

/obj/item/clothing/under/marine/sniper
	name = "\improper USCM sniper uniform"
	flags_jumpsuit = FALSE
	specialty = "USCM Sniper"

/obj/item/clothing/under/marine/tanker
	name = "\improper USCM tanker uniform"
	icon_state = "marine_tanker"
	worn_state = "marine_tanker"
	flags_jumpsuit = FALSE
	specialty = "USCM tanker"

/obj/item/clothing/under/marine/tanker/New(loc,
	new_protection = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT),
	override_icon_state = list(MAP_ICE_COLONY = "s_marine_tanker"))

	..(loc, new_protection, override_icon_state)

/obj/item/clothing/under/marine/chef
	name = "USCM 炊事员制服"
	desc = "食堂技术员的防污制服。没人知道 USCMC 为什么还要求他们穿文拉纤维护甲内衬。"
	icon_state = "chef_uniform"
	worn_state = "chef_uniform"
	flags_jumpsuit = FALSE
	specialty = "USCM mess technician"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/mp
	name = "USCMC 宪兵制服"
	desc = "耐割防刺的 USCMC 宪兵制服。文拉纤维内衬也能提供少量弹道防护。"
	icon_state = "MP_jumpsuit"
	worn_state = "MP_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine, /obj/item/clothing/suit/storage/jacket/marine/service/mp)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_SLEEVE_CUTTABLE|UNIFORM_JACKET_REMOVABLE
	specialty = "military police"

/obj/item/clothing/under/marine/mp/standard
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/mp/darker
	icon_state = "d_MP_jumpsuit"
	worn_state = "d_MP_jumpsuit"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/warden
	name = "军事监狱长连体服"
	desc = "宪兵监狱长的连体服，照例带有护甲。"
	icon_state = "warden_jumpsuit"
	worn_state = "warden_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine, /obj/item/clothing/suit/storage/jacket/marine/service/warden)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_SLEEVE_CUTTABLE|UNIFORM_JACKET_REMOVABLE
	specialty = "military warden"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer
	name = "陆战队军官制服"
	desc = "舒适得多的军官制服。面对真正的威胁时防护仍和一张纸差不多，但至少失血时不会穿得难受。"
	icon_state = "officertanclothes"
	item_state = "officertanclothes"
	worn_state = "officertanclothes"
	suit_restricted = null //so most officers can wear whatever suit they want
	flags_jumpsuit = FALSE
	specialty = "marine officer"
	black_market_value = 25

/obj/item/clothing/under/marine/officer/intel
	name = "\improper marine intelligence officer sweatsuit"
	desc = "Intelligence work is dangerous, but it's slightly less dangerous when your duty uniform can almost stop a bullet. Also features many pockets and attachment points for all storage needs."
	icon_state = "io"
	item_state = "io"
	worn_state = "io"
	specialty = "marine intelligence officer"

/obj/item/clothing/under/marine/officer/warrant
	name = "USCM 宪兵长制服"
	desc = "USCMC 宪兵长制服。除标准护板外，还配有不太舒适的能量分散聚合物内衬，并具备低等级任务导向防护姿态（MOPP）环境适用等级。"
	icon_state = "WO_jumpsuit"
	item_state = "WO_jumpsuit"
	worn_state = "WO_jumpsuit"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine, /obj/item/clothing/suit/armor/riot/marine, /obj/item/clothing/suit/storage/jacket/marine/service/cmp)
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	specialty = "chief MP"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/technical
	name = "technical officer uniform"
	icon_state = "johnny"
	worn_state = "johnny"
	specialty = "technical officer"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/pilot
	name = "飞行员紧身服"
	desc = "USCM 与 USASF 飞行员穿着的紧身服，适合驾驶通往地狱的高速电梯。文拉纤维护甲织层能提供一定的弹片和枪弹防护。"
	icon_state = "pilot_flightsuit"
	item_state = "pilot_flightsuit"
	worn_state = "pilot_flightsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_NAME_OVERRIDE
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT
	suit_restricted = list(/obj/item/clothing/suit/armor/vest/pilot, /obj/item/clothing/suit/storage/marine/light/vest/dcc, /obj/item/clothing/suit/storage/jacket/marine/pilot, /obj/item/clothing/suit/storage/marine/light/vest)

/obj/item/clothing/under/marine/officer/pilot/flight
	name = "战术飞行员飞行服"
	desc = "USCM 与 USASF 飞行员穿着的飞行服，带有大量皮带、收纳袋和其他你永远用不上的必备装备。看起来很酷。"
	icon_state = "pilot_flightsuit_alt"
	item_state = "pilot_flightsuit_alt"
	worn_state = "pilot_flightsuit_alt"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/under/marine/officer/pilot/dcc
	name = "dropship crew chief bodysuit"
	desc = "Dropship crew chief's bodysuit. The program that procured the latest line for some reason implemented a dozen odd survival features into it, which all don't really work. It also accepts standard venlar panels."
	icon_state = "crewchief_flightsuit"
	item_state = "crewchief_flightsuit"
	worn_state = "crewchief_flightsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/officer/tanker
	name = "载具乘员制服"
	desc = "USCMC 坦克兵与装甲骑兵乘员穿着的装甲载具制服。文拉纤维护板负责防弹片，帅不帅则取决于驾驶技术。给陆战队争光吧。"
	icon_state = "marine_tanker"
	worn_state = "marine_tanker"
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/tanker, /obj/item/clothing/suit/storage/jacket/marine/service/tanker)
	specialty = "vehicle crewman"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	item_state_slots = list(WEAR_BODY = "marine_tanker")

/obj/item/clothing/under/marine/officer/bridge
	name = "陆战队常服"
	desc = "有些过时的军官制服。没人明白为什么它需要防破片等级。"
	icon_state = "service_uniform"
	item_state = "service_uniform"
	worn_state = "service_uniform"
	specialty = "marine service"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/boiler
	name = "多军种作战连体服"
	desc = "深受很少上前线的美洲联盟军人喜爱的制服，看起来有些过时。"
	icon_state = "command_jumpsuit"
	item_state = "command_jumpsuit"
	worn_state = "command_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/qm_suit
	name = "后勤军官制服"
	desc = "合身的后勤军官制服，兼顾风格与实用性。含有轻型凯夫拉护片，可辅助抵御刺击和枪弹。"
	icon_state = "RO_jumpsuit"
	worn_state = "RO_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/cargo
	name = "support uniform"
	desc = "A pair of hard-wearing BDU pants & a short-sleeve breathable shirt. Perfect for those who work to support the frontline troops in various ways."
	icon_state = "cargotech"
	worn_state = "cargotech"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/command
	name = "USCM 军官制服"
	desc = "USCMC 指挥官制服，在符合规定的前提下定制剪裁，尽可能舒适。"
	icon_state = "CO_jumpsuit"
	worn_state = "CO_jumpsuit"
	specialty = "USCM officer"

/obj/item/clothing/under/marine/officer/general
	name = "将官制服"
	desc = "舰队将军穿着的深黑制服，带有淡淡光泽。织物看起来足够坚韧，能提供轻度防护。"
	item_state = "general_jumpsuit"
	worn_state = "general_jumpsuit"
	specialty = "general"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/ce
	name = "总工程师制服"
	desc = "总工程师制服。经过特殊处理，适合危险环境作业；高密度夹层还可提供一定辐射防护。"
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	icon_state = "EC_jumpsuit"
	worn_state = "EC_jumpsuit"
	specialty = "chief engineer"
	flags_atom = NO_SNOW_TYPE
	item_state_slots = list(WEAR_BODY = "EC_jumpsuit")

/obj/item/clothing/under/marine/officer/engi
	name = "船员制服"
	desc = "美洲联盟太空舰船船员的制服，经过特殊处理，适合接触危险物质和恶劣环境。"
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	icon_state = "mt_jumpsuit"
	worn_state = "mt_jumpsuit"
	specialty = "crew"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_SNOW_TYPE
	item_state_slots = list(WEAR_BODY = "mt_jumpsuit")

/obj/item/clothing/under/marine/officer/engi/OT
	name = "ordnance technician uniform"
	desc = "Ordinance technician's uniform. Improved protection from explosives and shrapnel provided by more extensive venlar coverage and hard bracing elements."
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	icon_state = "ot_jumpsuit"
	worn_state = "ot_jumpsuit"
	item_state_slots = list(WEAR_BODY = "ot_jumpsuit")

/obj/item/clothing/under/marine/officer/researcher
	name = "研究员服装"
	desc = "研究员穿着的一套普通便服。"
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	icon_state = "research_jumpsuit"
	worn_state = "research_jumpsuit"
	specialty = "researcher"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/formal/servicedress
	name = "指挥官礼服衬衫"
	desc = "高级军官两件式海军常礼服的衬衫与领带。穿出风度，也穿出分量。"
	specialty = "captain's service dress"
	icon_state = "CO_service"
	worn_state = "CO_service"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/formal/white
	name = "指挥官白色礼服"
	desc = "熨烫整齐的 USCM 军官制服，亮白色配金色饰边，适合阅兵或炎热天气。自豪地穿上它吧。"
	icon_state = "CO_formal_white"
	worn_state = "CO_formal_white"
	specialty = "captain's white formal"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/officer/formal/black
	name = "指挥官灰色礼服"
	desc = "熨烫整齐的 USCM 军官制服，低调灰色配金色饰边，适合正式或肃穆场合。自豪地穿上它吧。"
	icon_state = "CO_formal_black"
	worn_state = "CO_formal_black"
	specialty = "captain's gray formal"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/dress
	name = "陆战队正式常服"
	desc = "USCM 陆战队员常穿的正式常服。比标准常服更正式，同时仍然实用。"
	icon_state = "formal_jumpsuit"
	worn_state = "formal_jumpsuit"
	specialty = "marine formal"
	flags_atom = NO_SNOW_TYPE
	flags_jumpsuit = FALSE
	black_market_value = 15

/obj/item/clothing/under/marine/dress/command
	name = "marine officer formal service uniform"
	desc = "A formal service uniform typically worn by marines of the USCM. Still practicable while still being more formal than the standard service uniform. This one belongs to an officer."
	icon_state = "formal_jumpsuit"
	worn_state = "formal_jumpsuit"
	specialty = "command formal"
	black_market_value = 20

//=========================//DRESS BLUES\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/dress/blues
	name = "陆战队士兵蓝色礼服制服"
	desc = "传奇陆战队蓝色礼服的衬衣和长裤，自 19 世纪以来几乎没有改变。这款朴素型号供 E-1 至 E-3 级士兵穿着。"
	icon = 'icons/mob/humans/onmob/contained/marinedressblues.dmi'
	icon_state = "enlisted"
	item_state = "enlisted"
	worn_state = "enlisted"
	contained_sprite = TRUE
	item_state_slots = null

/obj/item/clothing/under/marine/dress/blues/senior
	name = "陆战队高级军官蓝色礼服制服"
	desc = "传奇陆战队蓝色礼服的衬衣和长裤，自 19 世纪以来几乎没有改变。此型号带有标志性的血红裤线，供士官与军官穿着。"
	icon_state = "senior"
	item_state = "senior"
	worn_state = "senior"

/obj/item/clothing/under/marine/dress/blues/general
	name = "陆战队高级军官蓝色礼服制服"
	desc = "传奇陆战队蓝色礼服的衬衣和长裤，自 19 世纪以来几乎没有改变。这款将官型号采用黑色长裤和宽大的血红裤线。"
	icon_state = "general"
	item_state = "general"
	worn_state = "general"

//=========================//PROVOST\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/mp/provost
	flags_jumpsuit = FALSE
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

	name = "\improper Provost Uniform"
	desc = "The crisp uniform of a Provost Officer."
	icon_state = "provost"
	worn_state = "provost"
	specialty = "provost"

	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/under/marine/mp/provost/senior
	name = "\improper Provost Senior Uniform"
	desc = "The crisp uniform of a senior member of the Provost Office."
	icon_state = "provost_tml"
	worn_state = "provost_tml"

/obj/item/clothing/under/marine/mp/provost/chief
	name = "\improper Provost Command Uniform"
	desc = "The crisp uniform of a commanding member of the Provost Office."
	icon_state = "provost_ci"
	worn_state = "provost_ci"

/obj/item/clothing/under/marine/mp/provost/marshal
	name = "\improper Provost Marshal Uniform"
	desc = "The crisp uniform of a Provost Marshal."
	icon_state = "provost_marshal"
	worn_state = "provost_marshal"

//=========================//USCM Survivors\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/reconnaissance
	name = "\improper damaged USCM uniform"
	desc = "Torn, Burned and blood stained. This uniform has seen much more than you could possibly imagine."
	icon_state = "damage_marine_jumpsuit"
	worn_state = "damage_marine_jumpsuit"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/under/marine/reconnaissance/Initialize(mapload)
	. = ..()
	var/R = rand(1,4)
	switch(R) //this is no longer shitcode, courtesy of stan_albatross
		if(1)
			roll_suit_sleeves(FALSE)
		if(2)
			roll_suit_jacket(FALSE)
		if(3)
			cut_suit_jacket(FALSE)


//=========================//RESPONDERS\\================================\\
//=======================================================================\\

/obj/item/clothing/under/marine/veteran
	flags_jumpsuit = FALSE
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make them keep their original name.

//=========================//Marine Raiders\\================================\\

/obj/item/clothing/under/marine/veteran/marsoc
	name = "black uniform"
	desc = "Non-standard black battle dress uniform, with venlar armor inserts at critical areas to protect from blades and ballistics."
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE
	icon_state = "marsoc_jumpsuit"
	worn_state = "marsoc_jumpsuit"
	flags_item = NO_SNOW_TYPE

//=========================//PMC\\================================\\

/obj/item/clothing/under/marine/veteran/pmc
	name = "PMC 作训服"
	desc = "为私人安保人员设计的白色作训服，印有维兰德-汤谷公司标志。"
	icon_state = "pmc_jumpsuit"
	worn_state = "pmc_jumpsuit"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	undershirt = TRUE

/obj/item/clothing/under/marine/veteran/pmc/leader
	name = "\improper PMC command fatigues"
	desc = "A white set of fatigues, designed for private security operators. The symbol of the Weyland-Yutani corporation is emblazed on the suit. This particular suit looks like it belongs to a high-ranking officer."
	icon_state = "officer_jumpsuit"
	worn_state = "officer_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/pmc/commando
	name = "\improper PMC commando uniform"
	desc = "An armored uniform worn by Weyland-Yutani elite commandos. It is well protected while remaining light and comfortable."
	icon_state = "commando_jumpsuit"
	worn_state = "commando_jumpsuit"
	flags_inventory = BLOCKGASEFFECT

/obj/item/clothing/under/marine/veteran/pmc/corporate
	name = "\improper WY corporate security uniform"
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant is commonly worn by what are known as 'goons'."
	icon = 'icons/mob/humans/onmob/contained/wy_goons.dmi'
	icon_state = "uniform"
	item_state = "uniform"
	worn_state = "uniform"
	contained_sprite = TRUE
	item_state_slots = null
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/marine/veteran/pmc/corporate/lead
	desc = "An armored uniform worn by Weyland-Yutani corporate security members. This variant is commonly worn by the lead of the 'goonsquad', as they are colloquially known."
	icon_state = "lead_uniform"
	item_state = "lead_uniform"
	worn_state = "lead_uniform"

//=========================//UPP\\================================\\

/obj/item/clothing/under/marine/veteran/bear
	name = "\improper Iron Bear uniform"
	desc = "A uniform worn by Iron Bears mercenaries in the service of Mother Russia. Smells a little like an actual bear."
	icon_state = "bear_jumpsuit"
	worn_state = "bear_jumpsuit"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_NO_SENSORS

	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/uniform_1.dmi',
	)

/obj/item/clothing/under/marine/veteran/UPP
	name = "UPP 作训服"
	desc = "UPP 联合武装制式作训服，在要害处装有文拉纤维护甲内衬，可抵御刀刃和小口径枪弹。"
	icon_state = "upp_uniform"
	worn_state = "upp_uniform"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_UPP
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW

/obj/item/clothing/under/marine/veteran/UPP/boiler
	name = "\improper UPP operations boilersuit"
	desc = "It's a deep green boilersuit common with UPP Armed Collective personnel outside of combat zones but still featuring venlar armor inserts at critical areas to protect from blades and low caliber ballistics."
	icon_state = "upp_boiler"
	worn_state = "upp_boiler"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/marine/veteran/UPP/pap
	name = "\improper PaP service uniform"
	desc = "A pair of blue-grey slacks coupled with a blue shirt, featuring venlar armor inserts at critical areas to protect from blades and low caliber ballistics."
	icon_state = "upp_uniform_pap"
	worn_state = "upp_uniform_pap"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_LIST_UPP_COLONY
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/marine/veteran/UPP/service
	name = "\improper UPP service uniform"
	desc = "A pair of brown-green slacks coupled with a green shirt, featuring venlar armor inserts at critical areas to protect from blades and low caliber ballistics."
	icon_state = "upp_uniform_service"
	worn_state = "upp_uniform_service"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/marine/veteran/UPP/naval
	name = "\improper UPP naval infantry uniform"
	flags_armor_protection = BODY_FLAG_GROIN|BODY_FLAG_LEGS
	desc = "A pair of black bell bottom naval pants matched with a blue telnyashka."
	icon_state = "upp_uniform_naval"
	worn_state = "upp_uniform_naval"
	flags_jumpsuit = UNIFORM_SLEEVE_CUT
	valid_accessory_slots = list(ACCESSORY_SLOT_UTILITY, ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_UTILITY, ACCESSORY_SLOT_HOLSTER)


/obj/item/clothing/under/marine/veteran/canc
	name = "\improper CANC fatigues"
	desc = "It's a set of standard-issue CANC combat fatigues featuring venlar armor inserts at critical areas to protect from blades and low caliber ballistics."
	icon_state = "canc_uniform"
	worn_state = "canc_uniform"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_CANC
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW

//=========================//Freelancer\\================================\\

/obj/item/clothing/under/marine/veteran/freelancer
	name = "\improper freelancer fatigues"
	desc = "A set of loose-fitting fatigues, perfect for an informal mercenary. Smells like gunpowder, apple pie, and covered in grease and sake stains."
	icon_state = "freelancer_uniform"
	worn_state = "freelancer_uniform"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_NO_SENSORS
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/faction/freelancer, /obj/item/clothing/suit/storage/webbing, /obj/item/clothing/suit/storage/utility_vest)

//=========================//Dutch Dozen\\================================\\

/obj/item/clothing/under/marine/veteran/dutch
	name = "\improper Dutch's Dozen uniform"
	desc = "A comfortable uniform worn by the Dutch's Dozen mercenaries. It's seen some definite wear and tear, but is still in good condition."
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	icon_state = "dutch_jumpsuit"
	worn_state = "dutch_jumpsuit"
	has_sensor = UNIFORM_NO_SENSORS
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/dutch, /obj/item/clothing/suit/armor/vest/dutch)


/obj/item/clothing/under/marine/veteran/dutch/ranger
	icon_state = "dutch_jumpsuit2"

/obj/item/clothing/under/marine/veteran/van_bandolier
	name = "hunting clothes"
	desc = "A set of tailored clothes, made from fine but sturdy reinforced fabrics. Protects from thorns, weather, and the cuts and scrapes that forever bedevil outdoorsmen."
	icon_state = "van_bandolier"
	worn_state = "van_bandolier"
	item_state = "van_bandolier_clothes"
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT
	has_sensor = UNIFORM_NO_SENSORS

//=========================//OWLF\\================================\\

/obj/item/clothing/under/marine/veteran/owlf
	name = "\improper OWLF thermal field uniform"
	desc = "A high-tech uniform with built-in thermal cloaking technology. It looks like it's worth more than your life."
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS //This is all a copy and paste of the Dutch's stuff for now.
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	icon_state = "owlf_uniform"
	worn_state = "owlf_uniform"
	has_sensor = UNIFORM_NO_SENSORS
	hood_state = /obj/item/clothing/head/owlf_hood

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/under/marine/veteran/mercenary
	name = "\improper Mercenary fatigues"
	desc = "A thick, beige suit with a red armband. There is an unknown symbol is emblazed on the suit."
	icon_state = "mercenary_heavy_uniform"
	worn_state = "mercenary_heavy_uniform"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	suit_restricted = list(/obj/item/clothing/suit/storage/marine/veteran/mercenary)

/obj/item/clothing/under/marine/veteran/mercenary/miner
	name = "\improper Mercenary miner fatigues"
	desc = "A beige suit with a red armband. It looks a little thin, like it wasn't designed for protection. There is an unknown symbol is emblazed on the suit."
	icon_state = "mercenary_miner_uniform"
	worn_state = "mercenary_miner_uniform"

/obj/item/clothing/under/marine/veteran/mercenary/support
	name = "\improper Mercenary engineer fatigues"
	desc = "A blue suit with yellow accents, used by engineers. There is an unknown symbol is emblazed on the suit."
	icon_state = "mercenary_engineer_uniform"
	worn_state = "mercenary_engineer_uniform"


////// Civilians /////////

/obj/item/clothing/under/marine/ua_riot
	name = "\improper United American security uniform"
	desc = "Overalls made of kevlon cover a snazzy blue dress shirt. UA branded security uniforms are notorious for their association with anti-union riot control teams."
	icon_state = "ua_riot"
	worn_state = "ua_riot"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make them keep their original name.
	flags_jumpsuit = FALSE
	suit_restricted = null

/obj/item/clothing/under/marine/ucf_clown
	name = "\improper UCF uniform"
	desc = "A Unified Clown Federation combat uniform. Features the latest in anti-mime technology."
	icon_state = "clown"
	worn_state = "clown"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make them keep their original name.
	black_market_value = 25

/obj/item/clothing/under/pizza
	name = "pizza delivery uniform"
	desc = "An ill-fitting, slightly stained uniform for a pizza delivery pilot. Smells of cheese."
	icon_state = "redshirt2"
	item_state = "r_suit"
	worn_state = "redshirt2"
	has_sensor = UNIFORM_NO_SENSORS

/obj/item/clothing/under/souto
	name = "\improper Souto Man's cargo pants"
	desc = "The white cargo pants worn by the one and only Souto man. As cool as an ice cold can of Souto Grape!"
	icon_state = "souto_man"
	worn_state = "souto_man"
	has_sensor = UNIFORM_NO_SENSORS

/obj/item/clothing/under/colonist
	name = "殖民者服装原型"
	desc = "不要生成这个！"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_COLONIST

/obj/item/clothing/under/colonist/workwear
	name = "灰色工作服"
	desc = "黑色休闲裤搭配灰色短袖工作衫。维兰德-汤谷殖民地运营和行政人员的标准制服。"
	icon_state = "workwear_grey"
	worn_state = "workwear_grey"

/obj/item/clothing/under/colonist/workwear/khaki
	name = "卡其色工作服"
	desc = "牛仔裤搭配卡其色工作衫，低调的外观深受蓝领工人喜爱。"
	icon_state = "workwear_khaki"
	worn_state = "workwear_khaki"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/workwear/pink
	name = "粉红色工作服"
	desc = "牛仔裤搭配粉红色工作衫。粉红色？你妻子或许不觉得，但这种离经叛道的打扮足以招来公司安保盘问。你是什么崇尚自由思想的无政府主义者吗？"
	icon_state = "workwear_pink"
	worn_state = "workwear_pink"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/workwear/blue
	name = "blue workwear"
	desc = "A pair of brown canvas workpants paired with a dark blue workshirt. A common pairing among blue-collar workers."
	icon_state = "workwear_blue"
	worn_state = "workwear_blue"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/workwear/green
	name = "绿色工作服"
	desc = "棕色帆布工装裤搭配绿色工作衫，是蓝领工人常见的穿搭。"
	icon_state = "workwear_green"
	worn_state = "workwear_green"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/boilersuit
	name = "light-blue boilersuit"
	desc = "A light-blue boilersuit."
	icon_state = "boilersuit_lightblue"
	worn_state = "boilersuit_lightblue"
	flags_jumpsuit = UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/boilersuit/darkblue
	name = "dark-blue boilersuit"
	desc = "A dark-blue boilersuit."
	icon_state = "boilersuit_darkblue"
	worn_state = "boilersuit_darkblue"

/obj/item/clothing/under/colonist/boilersuit/khaki
	name = "khaki boilersuit"
	desc = "A khaki boilersuit."
	icon_state = "boilersuit_khaki"
	worn_state = "boilersuit_khaki"

/obj/item/clothing/under/colonist/boilersuit/white
	name = "white boilersuit"
	desc = "An off-white boilersuit."
	icon_state = "boilersuit_white"
	worn_state = "boilersuit_white"

/obj/item/clothing/under/colonist/boilersuit/cyan
	name = "cyan boilersuit"
	desc = "A cyan boilersuit."
	icon_state = "boilersuit_cyan"
	worn_state = "boilersuit_cyan"

/obj/item/clothing/under/colonist/boilersuit/grey
	name = "grey boilersuit"
	desc = "A grey boilersuit."
	icon_state = "boilersuit_steel"
	worn_state = "boilersuit_steel"

/obj/item/clothing/under/colonist/clf
	name = "殖民地解放阵线制服"
	desc = "时髦的灰绿色殖民者制式连体服。这一款在部分位置印有殖民地解放阵线标志。"
	icon_state = "clf_uniform"
	worn_state = "clf_uniform"
	sensor_faction = FACTION_CLF

/obj/item/clothing/under/colonist/prison_boiler
	name = "\improper prisoner boiler uniform"
	desc = "A standardised prisoner-wear boiler uniform."
	icon_state = "prison_boiler"
	worn_state = "prison_boiler"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/colonist/ua_civvies
	name = "UA 灰色勤务服"
	desc = "时髦的灰色连体服，美洲联盟平民支援人员的制式服装。"
	icon_state = "ua_civvies"
	worn_state = "ua_civvies"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/colonist/wy_davisone
	name = "UA 棕色勤务服"
	desc = "时髦的棕色连体服，美洲联盟平民支援人员的制式服装。"
	icon_state = "wy_davisone"
	worn_state = "wy_davisone"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/colonist/white_service
	name = "白色常服"
	desc = "白色正装衬衫、领带配上利落长裤，是商务人士的标准着装。"
	icon_state = "CO_service"
	worn_state = "CO_service"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/colonist/wy_joliet_shopsteward
	name = "勤务员勤务服"
	desc = "时髦的棕色背心和短裤，职员与工会代表常穿这种制服。"
	icon_state = "wy_joliet_shopsteward"
	worn_state = "wy_joliet_shopsteward"
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/tshirt
	name = "T恤原型"
	has_sensor = UNIFORM_NO_SENSORS

/obj/item/clothing/under/tshirt/w_br
	name = "白色 T恤与棕色长裤"
	desc = "舒适的白色 T 恤和棕色牛仔裤。"
	icon_state = "tshirt_w_br"
	worn_state = "tshirt_w_br"
	displays_id = FALSE
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/tshirt/gray_blu
	name = "灰色 T恤与牛仔裤"
	desc = "舒适的灰色 T 恤和蓝色牛仔裤。"
	icon_state = "tshirt_gray_blu"
	worn_state = "tshirt_gray_blu"
	displays_id = FALSE
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/tshirt/r_bla
	name = "红色 T恤与黑色长裤"
	desc = "舒适的红色 T 恤和黑色牛仔裤。"
	icon_state = "tshirt_r_bla"
	worn_state = "tshirt_r_bla"
	displays_id = FALSE
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_MARINE

/obj/item/clothing/under/cmb
	name = "\improper Colonial Marshal uniform"
	desc = "A pair of off-white slacks and a blue button-down shirt with a dark brown tie; the standard uniform of the Colonial Marshals."
	icon_state = "marshal"
	worn_state = "marshal"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE|UNIFORM_JACKET_REMOVABLE

/obj/item/clothing/under/liaison_suit
	name = "联络员棕褐色外套"
	desc = "维兰德-汤谷商务人士常穿的挺括时髦棕褐色西装。精心剪裁，让你一看就像个混蛋。"
	icon_state = "liaison_regular"
	worn_state = "liaison_regular"

/obj/item/clothing/under/liaison_suit/charcoal
	name = "联络员炭灰色外套"
	desc = "维兰德-汤谷商务人士常穿的挺括时髦炭灰色西装。精心剪裁，让你一看就像个混蛋。"
	icon_state = "liaison_charcoal"
	worn_state = "liaison_charcoal"

/obj/item/clothing/under/liaison_suit/outing
	name = "liaison's outfit"
	desc = "A casual outfit consisting of a collared shirt and a vest. Looks like something you might wear on the weekends, or on a visit to a derelict colony."
	icon_state = "liaison_outing"
	worn_state = "liaison_outing"

/obj/item/clothing/under/liaison_suit/outing/red
	icon_state = "liaison_outing_red"
	worn_state = "liaison_outing_red"

/obj/item/clothing/under/liaison_suit/formal
	name = "联络员白色外套"
	desc = "正式的白色西装，适合出席葬礼、维兰德-汤谷公司晚宴，或者两者兼有。硬得像块板，却让你感觉刚从劳斯莱斯里走出来。"
	icon_state = "liaison_formal"
	worn_state = "liaison_formal"

/obj/item/clothing/under/liaison_suit/suspenders
	name = "联络员背带装"
	desc = "有领衬衫配背带，供维兰德-汤谷负责追问棘手问题的员工穿着。隐约散发着雪茄和拙劣演技的气息。"
	icon_state = "liaison_suspenders"
	worn_state = "liaison_suspenders"

/obj/item/clothing/under/liaison_suit/blazer
	name = "联络员蓝色西装上衣"
	desc = "挺括又不失休闲的蓝色西装上衣，在维兰德-汤谷的任何办公室都能见到。银河系最精明的人，当然只穿最好的。"
	icon_state = "liaison_blue_blazer"
	worn_state = "liaison_blue_blazer"

/obj/item/clothing/under/liaison_suit/field
	name = "商务便装"
	desc = "深棕色休闲裤搭配深蓝色纽扣衬衫，深受那些主要在夜总会谈生意的商界人士喜爱。"
	icon_state = "corporate_field"
	worn_state = "corporate_field"

/obj/item/clothing/under/liaison_suit/ivy
	name = "乡村俱乐部服装"
	desc = "卡其色休闲裤搭配浅蓝色纽扣衬衫，深受那些主要在乡村俱乐部谈生意的商界人士喜爱。"
	icon_state = "corporate_ivy"
	worn_state = "corporate_ivy"

/obj/item/clothing/under/liaison_suit/orange
	name = "橙色套装"
	desc = "黑色长裤搭配很有维兰德-汤谷风格的橙色衬衫，深受那些主要在维兰德-汤谷办公室谈生意的商界人士喜爱。"
	icon_state = "corporate_orange"
	worn_state = "corporate_orange"

/obj/item/clothing/under/liaison_suit/corporate_formal
	name = "白色西装裤"
	desc = "象牙白休闲裤搭配白衬衫，是正式公司活动中的热门穿搭。"
	icon_state = "corporate_formal"
	worn_state = "corporate_formal"

/obj/item/clothing/under/liaison_suit/black
	name = "黑色西装裤"
	desc = "黑色休闲裤搭配白衬衫，公司职员最常见的穿搭。"
	icon_state = "corporate_black"
	worn_state = "corporate_black"

/obj/item/clothing/under/liaison_suit/brown
	name = "棕色西装裤"
	desc = "棕色休闲裤搭配白衬衫，公司职员常见的穿搭。"
	icon_state = "corporate_brown"
	worn_state = "corporate_brown"

/obj/item/clothing/under/liaison_suit/blue
	name = "蓝色西装裤"
	desc = "蓝色休闲裤搭配白衬衫，公司职员常见的穿搭。"
	icon_state = "corporate_blue"
	worn_state = "corporate_blue"

/obj/item/clothing/under/liaison_suit/grey
	name = "grey suit pants"
	desc = "A pair of grey slacks paired with a white shirt. A common pairing among corporate workers."
	icon_state = "corporate_grey"
	worn_state = "corporate_grey"

/obj/item/clothing/under/liaison_suit/khaki
	name = "khaki suit pants"
	desc = "A pair of khaki slacks paired with a white shirt. A common pairing among corporate workers."
	icon_state = "corporate_khaki"
	worn_state = "corporate_khaki"

/obj/item/clothing/under/marine/reporter
	name = "战地记者制服"
	desc = "宽松耐穿的制服，能满足各种报道任务的需求。"
	icon_state = "cc_white"
	worn_state = "cc_white"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/uniform_1.dmi',
	)

/obj/item/clothing/under/marine/reporter/black
	icon_state = "cc_black"
	worn_state = "cc_black"

/obj/item/clothing/under/marine/reporter/orange
	icon_state = "cc_orange"
	worn_state = "cc_orange"

/obj/item/clothing/under/marine/reporter/red
	icon_state = "cc_red"
	worn_state = "cc_red"

/obj/item/clothing/under/twe_suit
	name = "representative's fine suit"
	desc = "A stiff, stylish blue suit commonly worn by gentlemen from the Three World Empire. Expertly crafted to make you look as important as possible."
	icon_state = "twe_suit"
	worn_state = "twe_suit"

/obj/item/clothing/under/stowaway
	name = "dirty suit"
	desc = "A stiff, stylish tan suit commonly worn by businessmen from the Weyland-Yutani corporation. Expertly crafted to make you look like a prick."
	icon_state = "stowaway_uniform"
	worn_state = "stowaway_uniform"

/obj/item/clothing/under/rank/chef/exec
	name = "\improper Weyland-Yutani suit"
	desc = "A formal white undersuit."
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/synthetic
	name = "USCM 支援制服"
	desc = "为合成人船员制作的简单制服。"
	icon_state = "rdalt"
	worn_state = "rdalt"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/synthetic/frontier
	name = "边疆连体服"
	desc = "经过轻便化改造的货运连体服，可保障全幅活动范围，并采用先进的边疆温控技术。工程师在外帷幕地区能穿到的最佳服装。"
	icon_state = "synth_cargo_light"
	worn_state = "synth_cargo_light"
	displays_id = FALSE

/obj/item/clothing/under/rank/synthetic/utility
	name = "UA 勤务服"
	desc = "深浅绿色搭配的勤务服，常配发给美洲联盟边疆合同工。"
	icon_state = "synth_green_utility"
	worn_state = "synth_green_utility"
	displays_id = FALSE

/obj/item/clothing/under/rank/synthetic/utility/yellow
	name = "勤务服"
	desc = "灰色勤务服，搭配黄色背带，供舰内船员使用。"
	icon_state = "synth_yellow_utility"
	worn_state = "synth_yellow_utility"

/obj/item/clothing/under/rank/synthetic/utility/red
	name = "勤务服"
	desc = "灰色勤务服，搭配红色背带与蓝色牛仔裤，是老练工人或不按小时计酬者的标志。"
	icon_state = "synth_red_utility"
	worn_state = "synth_red_utility"

/obj/item/clothing/under/rank/synthetic/utility/blue
	name = "勤务服"
	desc = "蓝色勤务服，配有青绿色背带和耐磨长裤。"
	icon_state = "synth_blue_utility"
	worn_state = "synth_blue_utility"

/obj/item/clothing/under/rank/synthetic/councillor
	name = "\improper USCM Pristine Support Uniform"
	desc = "A nicely handcrafted uniform made for Synthetic crewmembers."
	icon_state = "synth_councillor"
	worn_state = "synth_councillor"
	displays_id = FALSE

/obj/item/clothing/under/rank/synthetic/flight
	name = "战术飞行服"
	desc = "带有大量皮带、收纳袋和其他必备装备的飞行服。"
	icon_state = "pilot_flightsuit_alt"
	item_state = "pilot_flightsuit_alt"
	worn_state = "pilot_flightsuit_alt"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_cold_protection = ICE_PLANET_MIN_COLD_PROT

/obj/item/clothing/under/rank/synthetic/old
	icon_state = "rdalt_s"
	worn_state = "rdalt_s"

/obj/item/clothing/under/rank/synthetic/joe
	name = "工作乔制服"
	desc = "为合成人劳工制作的廉价制服。共创明天。"
	icon_state = "working_joe"
	worn_state = "working_joe"
	flags_item = NO_CRYO_STORE
	var/obj/structure/machinery/camera/camera

/obj/item/clothing/under/rank/synthetic/joe/Initialize()
	. = ..()
	camera = new /obj/structure/machinery/camera/autoname/almayer/containment/ares(src)

/obj/item/clothing/under/rank/synthetic/joe/Destroy()
	QDEL_NULL(camera)
	return ..()

/obj/item/clothing/under/rank/synthetic/joe/equipped(mob/living/carbon/human/mob, slot)
	if(camera)
		camera.c_tag = mob.name
	..()

/obj/item/clothing/under/rank/synthetic/joe/dropped(mob/living/carbon/human/mob)
	if(camera)
		camera.c_tag = "3RR0R"
	..()

/obj/item/clothing/under/rank/synthetic/joe/get_examine_text(mob/user)
	. = ..()
	if(camera)
		. += SPAN_ORANGE("There is a small camera mounted to the front.")

/obj/item/clothing/under/rank/synthetic/joe/engi
	name = "\improper Working Joe Hazardous Uniform"
	desc = "A reinforced uniform used for Synthetic labor in hazardous areas. Tomorrow, Together."
	icon_state = "working_joe_engi"
	worn_state = "working_joe_engi"
	flags_inventory = CANTSTRIP
	armor_melee = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/rank/synthetic/joe/engi/overalls
	name = "\improper Working Joe Hazardous Uniform"
	desc = "A reinforced uniform used for Synthetic labor in hazardous areas. Comes with an additional layer for liquid hazards. Tomorrow, Together."
	icon_state = "working_joe_overalls"
	worn_state = "working_joe_overalls"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	unacidable = TRUE

//=ROYAL MARINES=\\

/obj/item/clothing/under/marine/veteran/royal_marine
	name = "陆战队突击队制服"
	desc = "皇家陆战突击队的低调迷彩野战服，在要害处装有文拉纤维护甲内衬，可抵御刀刃与枪弹。"
	icon_state = "rmc_uniform"
	worn_state = "rmc_uniform"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	contained_sprite = TRUE
	icon = 'icons/mob/humans/onmob/contained/royal_marines_commando.dmi'

/obj/item/clothing/under/marine/veteran/royal_marine/lt
	name = "marine commando officer field uniform"
	desc = "Subdued-camouflage field-officer uniform of the royal marine commandos. Has venlar armor inserts at critical areas to protect from blades and ballistics."
	icon_state = "rmc_uniform_lt"
	worn_state = "rmc_uniform_lt"

/obj/item/clothing/under/marine/veteran/royal_marine/lt/service
	name = "marine commando officers service uniform"
	desc = "The officers uniform of the royal marine commandos. Commonly seen worn by high-ranking officers who don't typically take to the field."
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	icon_state = "rmc_service_uniform"
	worn_state = "rmc_service_uniform"

/obj/item/clothing/under/marine/pve_mopp
	name = "\improper M2 MOPP suit"
	desc = "M2 MOPP suits are purpose built to defend the wearer against biological and radioactive contaminants, from nerve gas to nuclear fallout."
	desc_lore = "The several-paragraph long expository pamphlet that usually comes with these is missing."
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_inventory = BLOCKGASEFFECT
	flags_jumpsuit = NO_FLAGS
	icon_state = "cbrn"
	worn_state = "cbrn"

	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/uniform_1.dmi',
	)


/obj/item/clothing/under/marine/cbrn //CBRN MOPP suit
	name = "\improper M3 MOPP suit"
	desc = "M3 MOPP suits are specially designed and engineered to protect the wearer from unshielded exposure to any Chemical, Biological, Radiological, or Nuclear (CBRN) threats in the field. The suit has a recommended lifespan of twenty-four hours once contact with a toxic environment is made, but depending on the severity this can be shortened to eight hours or less."
	desc_lore = "Since the outbreak of the New Earth Plague in 2157 and the subsequent Interstellar Commerce Commission (ICC) sanctioned decontamination of the colony and its 40 million inhabitants, the abandoned colony has been left under a strict quarantine blockade to prevent any potential scavengers from spreading what’s left of the highly-durable airborne flesh-eating bacteria. Following those events, the three major superpowers have been investing heavily in the development and procurement of CBRN equipment, in no small part due to the extensive damage that the plague and other similar bioweapons could do. The \"Marine 70\" upgrade package and the launch of the M3 pattern armor series saw the first M3-M prototypes approved for CBRN usage."
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_inventory = BLOCKGASEFFECT
	icon_state = "cbrn"
	worn_state = "cbrn"
	flags_jumpsuit = NO_FLAGS
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_VERYLOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGHPLUS
	fire_intensity_resistance = BURN_LEVEL_TIER_1
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	actions_types = list(/datum/action/item_action/specialist/toggle_cbrn_hood)

	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/uniform_1.dmi',
	)

	///Whether the hood and gas mask were worn through the hood toggle verb
	var/hood_enabled = FALSE
	///Whether enabling the hood protects you from fire
	var/supports_fire_protection = TRUE
	///Typepath of the attached hood
	var/hood_type = /obj/item/clothing/head/helmet/marine/cbrn_hood
	///The head clothing that the suit uses as a hood
	var/obj/item/clothing/head/linked_hood

/obj/item/clothing/under/marine/cbrn/Initialize()
	linked_hood = new hood_type(src)
	. = ..()

/obj/item/clothing/under/marine/cbrn/Destroy()
	. = ..()
	if(linked_hood)
		qdel(linked_hood)

/obj/item/clothing/under/marine/cbrn/verb/hood_toggle()
	set name = "Toggle Hood"
	set desc = "Pull your hood and gasmask up over your face and head."
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr

	if(user.w_uniform != src)
		to_chat(user, SPAN_WARNING("You must be wearing [src] to put on [linked_hood] attached to it!"))
		return

	if(!linked_hood)
		to_chat(user, SPAN_BOLDWARNING("You are missing a linked_hood! This should not be possible."))
		CRASH("[user] attempted to toggle hood on [src] that was missing a linked_hood.")

	playsound(user.loc, "armorequip", 25, 1)
	if(hood_enabled)
		disable_hood(user, FALSE)
		return
	enable_hood(user)

/obj/item/clothing/under/marine/cbrn/proc/enable_hood(mob/living/carbon/human/user)
	if(!istype(user))
		user = usr

	if(!linked_hood.mob_can_equip(user, WEAR_HEAD))
		to_chat(user, SPAN_WARNING("You are unable to equip [linked_hood]."))
		return

	user.equip_to_slot(linked_hood, WEAR_HEAD)

	hood_enabled = TRUE
	RegisterSignal(src, COMSIG_ITEM_UNEQUIPPED, PROC_REF(disable_hood))
	RegisterSignal(linked_hood, COMSIG_ITEM_UNEQUIPPED, PROC_REF(disable_hood))

	if(!supports_fire_protection)
		return
	to_chat(user, SPAN_NOTICE("You raise [linked_hood] over your head. You will no longer catch fire."))
	toggle_fire_protection(user, TRUE)

/obj/item/clothing/under/marine/cbrn/proc/disable_hood(mob/living/carbon/human/user, forced = TRUE)
	if(!istype(user))
		user = usr

	UnregisterSignal(src, COMSIG_ITEM_UNEQUIPPED)
	UnregisterSignal(linked_hood, COMSIG_ITEM_UNEQUIPPED)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon/human, drop_inv_item_to_loc), linked_hood, src), 1) //0.1s delay cause you can grab the hood
	addtimer(CALLBACK(src, PROC_REF(check_remove_headgear)), 2) //Checks if it is still not in contents, incase it was dropped

	hood_enabled = FALSE
	if(!forced)
		to_chat(user, SPAN_NOTICE("You take off [linked_hood]."))

	if(supports_fire_protection)
		toggle_fire_protection(user, FALSE)

/obj/item/clothing/under/marine/cbrn/proc/check_remove_headgear(obj/item/clothing/under/marine/cbrn/uniform = src)
	for(var/current_atom in contents)
		if(current_atom == linked_hood)
			return
	linked_hood.forceMove(uniform)

/obj/item/clothing/under/marine/cbrn/proc/toggle_fire_protection(mob/living/carbon/user, enable_fire_protection)
	if(enable_fire_protection)
		RegisterSignal(user, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_shield_is_on))
		RegisterSignal(user, list(COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED), PROC_REF(flamer_fire_callback))
		return
	UnregisterSignal(user, list(COMSIG_LIVING_PREIGNITION, COMSIG_LIVING_FLAMER_CROSSED, COMSIG_LIVING_FLAMER_FLAMED))

/obj/item/clothing/under/marine/cbrn/proc/fire_shield_is_on(mob/living/burning_mob) //Stealing it from the pyro spec armor
	SIGNAL_HANDLER

	if(burning_mob.fire_reagent?.fire_penetrating)
		return

	return COMPONENT_CANCEL_IGNITION

/obj/item/clothing/under/marine/cbrn/proc/flamer_fire_callback(mob/living/burning_mob, datum/reagent/fire_reagent)
	SIGNAL_HANDLER

	if(fire_reagent.fire_penetrating)
		return

	. = COMPONENT_NO_IGNITE|COMPONENT_NO_BURN

/datum/action/item_action/specialist/toggle_cbrn_hood
	ability_primacy = SPEC_PRIMARY_ACTION_2

/datum/action/item_action/specialist/toggle_cbrn_hood/New(obj/item/clothing/under/marine/cbrn/armor, obj/item/holder)
	..()
	name = "Toggle Hood"
	button.name = name
	button.overlays.Cut()
	var/image/button_overlay = image(armor.linked_hood.icon, armor, armor.linked_hood.icon_state)
	button.overlays += button_overlay

/datum/action/item_action/specialist/toggle_cbrn_hood/action_activate()
	. = ..()
	var/obj/item/clothing/under/marine/cbrn/armor = holder_item
	if(!istype(armor))
		return
	armor.hood_toggle()

/obj/item/clothing/under/marine/cbrn/advanced
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	hood_type = /obj/item/clothing/head/helmet/marine/cbrn_hood/advanced

//=USASF & ARMY=\\

/obj/item/clothing/under/navy/officer
	name = "\improper duty officer uniform"
	desc = "The uniform of a duty officer in the USASF. Specially treated for hazardous conditions work, high density layers provide some level of radiation protection."
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	icon_state = "boilersuit_khaki"
	worn_state = "boilersuit_khaki"
	suit_restricted = null //so most officers can wear whatever suit they want
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	item_state_slots = list(WEAR_BODY = "boilersuit_khaki")

/obj/item/clothing/under/navy/tech
	name = "\improper engineering technician uniform"
	desc = "The uniform of an engineering technician. Specially treated for hazardous materials handing and hostile conditions, with reinforced material around the elbows and knees."
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	icon_state = "mt_jumpsuit"
	worn_state = "mt_jumpsuit"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	item_state_slots = list(WEAR_BODY = "mt_jumpsuit")

/obj/item/clothing/under/marine/standard/navy
	name = "\improper USASF combat uniform"
	icon_state = "navy_jumpsuit"
	item_state = "navy_jumpsuit"
	worn_state = "navy_jumpsuit"
	desc = "Standard-issue USASF Security Forces uniform in a distintive blue steel color scheme, complete with venlar armor inserts at critical areas to protect from blades and ballistics."
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/officer/engi/OT/navy
	name = "\improper damage-control crew uniform"
	desc = "The uniform of an aerospace force crewman. Specially treated for hazardous materials handing and hostile conditions. This one has the color-flashes of a member of the ship damage-control teams on it."
	icon_state = "ot_jumpsuit"
	worn_state = "ot_jumpsuit"
	item_state_slots = list(WEAR_BODY = "ot_jumpsuit")
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/officer/engi/navy/tech
	name = "\improper engineering technician uniform"
	desc = "The uniform of an aerospace force engineering technician. Specially treated for hazardous materials handing and hostile conditions, with reinforced material around the elbows and knees."
	icon_state = "boilersuit_darkblue"
	worn_state = "boilersuit_darkblue"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/officer/pilot/flight/para
	name = "\improper para-rescue flightsuit"
	desc = "A flightsuit worn by the elite para-rescue forces of the USASF, with all the necessary straps and rigging for supporting the sheer balls these servicemen have. Looks badass."
	suit_restricted = null
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/officer/intel/navy
	name = "\improper USASF combat uniform"
	desc = "Forward-observation work is dangerous, but it's slightly less dangerous when your duty uniform can almost stop a bullet. Also features many pockets and attachment points for all storage needs."
	icon_state = "jfo"
	item_state = "jfo"
	worn_state = "jfo"
	suit_restricted = null
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/under/marine/standard/army
	name = "\improper army combat uniform"
	icon_state = "army_jumpsuit"
	item_state = "army_jumpsuit"
	worn_state = "army_jumpsuit"
	desc = "Standard-issue Army uniform in a two-tone desert/temperate color scheme, complete with venlar armor inserts at critical areas to protect from blades and ballistics."
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

