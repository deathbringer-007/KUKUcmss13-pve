/datum/emote/living/carbon/human/synthetic/working_joe/notice
	category = JOE_EMOTE_CATEGORY_NOTICE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/report
	key = "report"
	sound = 'sound/voice/joe/report.ogg'
	haz_sound = 'sound/voice/joe/report_haz.ogg'
	say_message = "正在向APOLLO记录报告。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/detailed_report
	key = "detailedreport"
	sound = 'sound/voice/joe/detailed_report.ogg'
	haz_sound = 'sound/voice/joe/detailed_report_haz.ogg'
	say_message = "APOLLO需要一份详细报告。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/be_careful
	key = "careful"
	sound = 'sound/voice/joe/be_careful_with_that.ogg'
	say_message = "小心操作。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/firearm
	key = "firearm"
	sound = 'sound/voice/joe/firearm.ogg'
	haz_sound = 'sound/voice/joe/firearm_haz.ogg'
	say_message = "枪械可能造成严重伤害。请让我协助你。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/investigate_weapon
	key = "weapon"
	sound = 'sound/voice/joe/investigate_weapon.ogg'
	say_message = "一件武器。我最好调查一下。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/firearm_concerning
	key = "firearmconcerning"
	sound = 'sound/voice/joe/most_concerning.ogg'
	say_message = "一把枪。令人十分担忧。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/invest_disturbance
	key = "investigatedisturbance"
	haz_sound = 'sound/voice/joe/investigating_disturbance_haz.ogg'
	say_message = "正在调查异常动静。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/unexplained_disturbance
	key = "disturbance"
	haz_sound = 'sound/voice/joe/disturbance_haz.ogg'
	say_message = "无法解释的异常动静最令人不安。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/species
	key = "species"
	sound = 'sound/voice/joe/species.ogg'
	haz_sound = 'sound/voice/joe/species_haz.ogg'
	say_message = "未知物种。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/beyond_repair
	key = "beyondrepair"
	sound = 'sound/voice/joe/beyond_repair.ogg'
	haz_sound = 'sound/voice/joe/beyond_repair_haz.ogg'
	say_message = "嗯，已经完全无法修复了。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/notice/apollo_behalf
	key = "apollobehalf"
	sound = 'sound/voice/joe/apollo_behalf.ogg'
	haz_sound = 'sound/voice/joe/apollo_behalf_haz.ogg'
	say_message = "我会代你通知APOLLO。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE
