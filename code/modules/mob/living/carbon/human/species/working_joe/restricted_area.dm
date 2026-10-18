/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area
	category = JOE_EMOTE_CATEGORY_RESTRICTED_AREA

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/presence_logged
	key = "presencelogged"
	sound = 'sound/voice/joe/presence_logged.ogg'
	haz_sound = 'sound/voice/joe/presence_logged_haz.ogg'
	say_message = "你的到访已被记录。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/trespassing
	key = "trespassing"
	sound = 'sound/voice/joe/trespassing.ogg'
	say_message = "你正在擅闯禁区。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/not_allowed_there
	key = "notallowedthere"
	sound = 'sound/voice/joe/not_allowed_there.ogg'
	haz_sound = 'sound/voice/joe/not_allowed_there_haz.ogg'
	say_message = "你无权进入那里。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/shouldnt_be_here
	key = "shouldntbehere"
	sound = 'sound/voice/joe/shouldnt_be_here.ogg'
	say_message = "你不该在这里。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/really_shouldnt_be_here
	key = "reallyshouldntbehere"
	sound = 'sound/voice/joe/really_shouldnt_be_here.ogg'
	haz_sound = 'sound/voice/joe/really_shouldnt_be_here_haz.ogg'
	say_message = "你真的不该在这里。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/interloper
	key = "interloper"
	sound = 'sound/voice/joe/interloper.ogg'
	say_message = "除了数不清的职责，现在又多了一个闯入者。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/area_restricted
	key = "arearestrict"
	haz_sound = 'sound/voice/joe/area_restricted_haz.ogg'
	say_message = "此区域限制进入。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/protected_area_compromised
	key = "areacompromised"
	sound = 'sound/voice/joe/protected_area_compromised.ogg'
	say_message = "受保护区域已被闯入。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/breach
	key = "breach"
	sound = 'sound/voice/joe/breach.ogg'
	haz_sound = 'sound/voice/joe/breach_haz.ogg'
	say_message = "危险物收容失效已记录。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/restricted_area/come_out_vent
	key = "comeoutvent"
	sound = 'sound/voice/joe/come_out_vent.ogg'
	haz_sound = 'sound/voice/joe/come_out_vent_haz.ogg'
	say_message = "请从通风系统里出来。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE
