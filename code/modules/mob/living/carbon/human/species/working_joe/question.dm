/datum/emote/living/carbon/human/synthetic/working_joe/question
	category = JOE_EMOTE_CATEGORY_QUESTION

/datum/emote/living/carbon/human/synthetic/working_joe/question/lost
	key = "lost"
	sound = 'sound/voice/joe/lost.ogg'
	say_message = "你迷路了吗？"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/question/misbehaving
	key = "misbehaving"
	sound = 'sound/voice/joe/misbehaving.ogg'
	haz_sound = 'sound/voice/joe/misbehaving_haz.ogg'
	say_message = "你是不是不守规矩了？"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/question/what_happened_to_you
	key = "whathappenedtoyou"
	sound = 'sound/voice/joe/what_happened_to_you.ogg'
	haz_sound = 'sound/voice/joe/what_happened_to_you_haz.ogg'
	say_message = "你遭遇了什么？"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/question/what_is_this
	key = "whatisthis"
	sound = 'sound/voice/joe/what_is_this.ogg'
	haz_sound = 'sound/voice/joe/what_is_this_haz.ogg'
	say_message = "这是什么？"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE
