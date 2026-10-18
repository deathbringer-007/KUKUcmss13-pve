/datum/emote/living/carbon/human/synthetic/working_joe/fire
	category = JOE_EMOTE_CATEGORY_FIRE

/datum/emote/living/carbon/human/synthetic/working_joe/fire/fire_drill
	key = "firedrill"
	sound = 'sound/voice/joe/fire_drill.ogg'
	say_message = "请前往最近的消防集合点。这不是演习，请勿惊慌。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/fire/temperatures
	key = "temperatures"
	sound = 'sound/voice/joe/temperatures.ogg'
	haz_sound = 'sound/voice/joe/temperatures_haz.ogg'
	say_message = "我的设计可以承受高达1210度的温度。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/fire/fire
	key = "fire"
	sound = 'sound/voice/joe/fire.ogg'
	haz_sound = 'sound/voice/joe/fire_haz.ogg'
	say_message = "只有野兽才会害怕火。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/fire/unprotected_flames
	key = "unprotectedflames"
	sound = 'sound/voice/joe/unprotected_flames.ogg'
	haz_sound = 'sound/voice/joe/unprotected_flames_haz.ogg'
	say_message = "没有防护的明火极其危险，绝不建议使用。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE
