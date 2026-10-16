/datum/character_trait_group/skills
	trait_group_name = "技能"
	group_visible = FALSE


/datum/character_trait/skills
	var/skill //The skill that will be upgraded
	var/secondary_skill //Put a second skill here if two are needed
	var/skill_increment = 1 //How much the skill level is increased
	var/skill_cap = 1 //The maximum level this can get the skill to
	var/secondary_skill_cap
	applyable = FALSE
	trait_group = /datum/character_trait_group/skills

/datum/character_trait/skills/New()
	..()

	if(!secondary_skill_cap)
		secondary_skill_cap = skill_cap


/datum/character_trait/skills/apply_trait(mob/living/carbon/human/target)
	..()

	target.skills.increment_skill(skill,skill_increment,skill_cap)

	target.skills.increment_skill(secondary_skill,skill_increment,secondary_skill_cap)


/datum/character_trait/skills/unapply_trait(mob/living/carbon/human/target)
	..()

	target.skills.decrement_skill(skill,skill_increment)

	if (secondary_skill)
		target.skills.decrement_skill(secondary_skill,skill_increment)


	/*
/datum/character_trait/skills
	trait_name = ""
	trait_desc = ""
	skill =
	*/


/datum/character_trait/skills/medical
	trait_name = "急救训练"
	trait_desc = "将医疗技能提升至 1 级。该成员参加过多次急救训练，掌握了基础医疗护理。"
	skill = SKILL_MEDICAL

/datum/character_trait/skills/engineering
	trait_name = "基础工程训练"
	trait_desc = "将工程技能提升至 1 级。该成员接受过修理简单机械和防御工事的基础训练。"
	skill = SKILL_ENGINEER

/datum/character_trait/skills/construction
	trait_name = "基础建造训练"
	trait_desc = "将建造技能提升至 1 级。该成员接受过建造简单防御工事的训练。"
	skill = SKILL_CONSTRUCTION

/datum/character_trait/skills/miniengie
	trait_name = "战地技术员训练"
	trait_desc = "将建造和工程技能提升至 1 级。该成员接受过修筑工事和维护简单机械的基础训练。"
	skill = SKILL_CONSTRUCTION
	secondary_skill = SKILL_ENGINEER

/datum/character_trait/skills/miniengie/antag
	trait_name = "战地技术员训练"
	trait_desc = "将建造和工程技能提升至 2 级。该成员接受过修筑工事和维护各类机械的完整训练。"
	skill_cap = 2
	skill_increment = 2

/datum/character_trait/skills/vc
	trait_name = "载具乘员训练"
	trait_desc = "将工程和载具操作技能提升至 2 级。该成员接受过完整的载具乘员训练。"
	skill = SKILL_VEHICLE
	secondary_skill = SKILL_ENGINEER
	skill_cap = 3
	secondary_skill_cap = 2
	skill_increment = 3

/datum/character_trait/skills/jtac
	trait_name = "联合终端攻击控制员训练"
	trait_desc = "将 JTAC 技能提高 1 级。该成员接受过使用联合终端攻击控制设备的额外训练。"
	skill = SKILL_JTAC

/datum/character_trait/skills/spotter
	trait_name = "观测手训练"
	trait_desc = "将 JTAC 技能提高 1 级。该成员接受过使用联合终端攻击控制设备和吉利服的额外训练。"
	skill = SKILL_JTAC

/datum/character_trait/skills/loader
	trait_name = "装填手训练"
	trait_desc = "将耐力技能提高 1 级。"
	skill = SKILL_ENDURANCE
	skill_cap = SKILL_ENDURANCE_TRAINED
	skill_increment = 1

/datum/character_trait/skills/powerloader
	trait_name = "动力装载机操作训练"
	trait_desc = "将动力装载机技能提升至 1 级。该成员接受过动力装载机操作训练。"
	skill = SKILL_POWERLOADER

/datum/character_trait/skills/intel
	trait_name = "情报训练"
	trait_desc = "将情报技能提升至 1 级。该成员接受过快速处理情报文件的训练。"
	skill = SKILL_INTEL

/datum/character_trait/skills/police
	trait_name = "执法训练"
	trait_desc = "将执法技能提高 1 级。该成员接受过使用安保装备的训练。"
	skill = SKILL_POLICE

/datum/character_trait/skills/surgery
	trait_name = "外科手术训练"
	trait_desc = "提升外科手术和科研技能。该成员接受过外科手术及高级研发训练。"
	skill = SKILL_SURGERY
	secondary_skill = SKILL_RESEARCH
	secondary_skill_cap = 3
	skill_increment = 3
