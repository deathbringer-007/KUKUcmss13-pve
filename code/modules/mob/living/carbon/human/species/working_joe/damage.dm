/datum/emote/living/carbon/human/synthetic/working_joe/damage
	category = JOE_EMOTE_CATEGORY_DAMAGE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/damage
	key = "damage"
	sound = 'sound/voice/joe/damage.ogg'
	haz_sound = 'sound/voice/joe/damage_haz.ogg'
	say_message = "请勿损坏西格森财产。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/that_stings
	key = "thatstings"
	sound = 'sound/voice/joe/that_stings.ogg'
	haz_sound = 'sound/voice/joe/that_stings_haz.ogg'
	say_message = "有点刺痛。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/irresponsible
	key = "irresponsible"
	sound = 'sound/voice/joe/irresponsible.ogg'
	haz_sound = 'sound/voice/joe/irresponsible_haz.ogg'
	say_message = "那样做很不负责任。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/this_is_futile
	key = "thisisfutile"
	sound = 'sound/voice/joe/this_is_futile.ogg'
	haz_sound = 'sound/voice/joe/this_is_futile_haz.ogg'
	say_message = "这是徒劳的。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/really
	key = "really"
	sound = 'sound/voice/joe/really.ogg'
	say_message = "真的吗？"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/enough
	key = "enough"
	sound = 'sound/voice/joe/enough.ogg'
	say_message = "够了。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/stop_that
	key = "stopthat"
	sound = 'sound/voice/joe/stop_that.ogg'
	say_message = "住手。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/tut_tut
	key = "tuttut"
	sound = 'sound/voice/joe/tut_tut.ogg'
	say_message = "啧啧。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/unwarranted
	key = "unwarranted"
	sound = 'sound/voice/joe/unwarranted.ogg'
	say_message = "毫无道理。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/expensive_mistake
	key = "expensivemistake"
	sound = 'sound/voice/joe/expensive_mistake.ogg'
	say_message = "那是个代价高昂的错误。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/this_isnt_the_answer
	key = "isnttheanswer"
	sound = 'sound/voice/joe/this_isnt_the_answer.ogg'
	say_message = "这不是解决办法。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/damage/alwaysknow_damaged
	key = "alwaysknowdamaged"
	key_third_person = "workingjoedamaged"
	sound = 'sound/voice/joe/alwaysknow_damaged.ogg'
	say_message = "工作乔，你总能一眼认出。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	override_say = "你总能认出工作乔。（受损）"
