/datum/emote/living/brain
	mob_type_allowed_typecache = list(/mob/living/brain)
	keybind = FALSE

/datum/emote/brain/can_run_emote(mob/user, status_check = TRUE, intentional = FALSE)
	. = ..()
	var/mob/living/brain/brain_user = user
	if(!istype(brain_user) || (!(brain_user.container && istype(brain_user.container, /obj/item/device/mmi))))
		return FALSE

/datum/emote/living/brain/alarm
	key = "alarm"
	message = "发出警报声。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/alert
	key = "alert"
	message = "发出焦急的声音。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/notice
	key = "notice"
	message = "奏出一声响亮的音调。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/flash
	key = "flash"
	message = "指示灯快速闪烁！"

/datum/emote/living/brain/blink
	key = "blink"
	message = "眨了眨眼。"

/datum/emote/living/brain/whistle
	key = "whistle"
	message = "吹了声口哨。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/beep
	key = "beep"
	message = "发出哔声。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/brain/boop
	key = "boop"
	message = "发出啵声。"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
