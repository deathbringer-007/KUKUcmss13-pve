/datum/origin/uscm
	name = ORIGIN_USCM
	desc = "你出生在美利坚合众国，全宇宙最他妈棒的国家。"


/datum/origin/uscm/luna
	name = ORIGIN_USCM_LUNA
	desc = "你出生在绕地球运行的月球基地。要我说，这可真他妈酷。"


/datum/origin/uscm/other
	name = ORIGIN_USCM_OTHER
	desc = "你出生在美洲联盟内一个不起眼的国家。"


/datum/origin/uscm/colony
	name = ORIGIN_USCM_COLONY
	desc = "你出生在维兰德-汤谷的殖民地，逃离那个鬼地方的唯一出路，就是加入陆战队。"


/datum/origin/uscm/foreign
	name = ORIGIN_USCM_FOREIGN
	desc = "你出生在美洲联盟之外，自出生起就被视为无足轻重。"


/datum/origin/uscm/aw
	name = ORIGIN_USCM_AW
	desc = "你是某项实验性军事计划的产物，该计划试图培育完美的超级士兵。在某些方面，他们成功了。"

/datum/origin/uscm/aw/generate_human_name(gender = MALE)
	return pick(gender == MALE ? GLOB.first_names_male : GLOB.first_names_female) + " A.W. " + pick(GLOB.weapon_surnames)

/datum/origin/uscm/aw/validate_name(name_to_check)
	if(!findtext(name_to_check, "A.W. "))
		return "作为人工子宫培育士兵，角色的中间名必须是“A.W.”。"
	return null

/datum/origin/uscm/aw/correct_name(name_to_check, gender = MALE)
	if(!findtext(name_to_check, "A.W. "))
		name_to_check = generate_human_name(gender)
	return name_to_check

/datum/origin/uscm/convict/minor
	name = ORIGIN_USCM_CONVICT_MINOR
	desc = "你出生在哪里并不重要。大家只知道你因多项轻罪被定罪，而美国殖民地海军陆战队给了你一条出路。"

/datum/origin/uscm/convict/gang
	name = ORIGIN_USCM_CONVICT_GANG
	desc = "你出生在哪里并不重要。大家只知道你因帮派相关罪行被定罪，而美国殖民地海军陆战队给了你一条出路。"

/datum/origin/uscm/convict/smuggling
	name = ORIGIN_USCM_CONVICT_SMUGGLING
	desc = "你出生在哪里并不重要。大家只知道你因走私（可能还涉及海盗行为）被定罪，而美国殖民地海军陆战队给了你一条出路。"
