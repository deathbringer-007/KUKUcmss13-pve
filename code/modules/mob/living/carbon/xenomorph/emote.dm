/datum/emote/living/carbon/xeno
	mob_type_allowed_typecache = list(/mob/living/carbon/xenomorph)
	mob_type_blacklist_typecache = list(/mob/living/carbon/xenomorph/hellhound, /mob/living/carbon/xenomorph/facehugger, /mob/living/carbon/xenomorph/larva)
	keybind_category = CATEGORY_XENO_EMOTE
	var/predalien_sound
	var/larva_sound

/datum/emote/living/carbon/xeno/get_sound(mob/living/user)
	. = ..()

	if(ispredalien(user) && predalien_sound)
		. = predalien_sound

	if(islarva(user) && larva_sound)
		. = larva_sound

/datum/emote/living/carbon/xeno/growl
	key = "growl"
	message = "低吼起来。"
	sound = "alien_growl"
	predalien_sound = 'sound/voice/predalien_growl.ogg'
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/hiss
	key = "hiss"
	message = "发出嘶嘶声。"
	sound = "alien_hiss"
	predalien_sound = 'sound/voice/predalien_hiss.ogg'
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/needshelp
	key = "needshelp"
	message = "需要帮助！"
	sound = "alien_help"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/roar
	mob_type_blacklist_typecache = list()

	key = "roar"
	message = "咆哮起来！"
	sound = "alien_roar"
	predalien_sound = 'sound/voice/predalien_roar.ogg'
	larva_sound = "alien_roar_larva"
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/tail
	key = "tail"
	message = "甩动尾巴。"
	sound = "alien_tail_swipe"

/datum/emote/living/carbon/xeno/hellhound
	mob_type_allowed_typecache = list(/mob/living/carbon/xenomorph/hellhound)
	keybind = FALSE

/datum/emote/living/carbon/xeno/hellhound/roar
	key = "roar"
	key_third_person = "roars"
	message = "咆哮起来！"
	sound = 'sound/voice/ed209_20sec.ogg'
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/xeno/hellhound/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "挠了挠。"
	hands_use_check = TRUE

/datum/emote/living/carbon/xeno/hellhound/paw
	key = "paw"
	key_third_person = "paws"
	message = "挥舞着爪子。"
	hands_use_check = TRUE

/datum/emote/living/carbon/xeno/hellhound/sway
	key = "sway"
	key_third_person = "sways"
	message = "晕乎乎地摇晃着。"

/datum/emote/living/carbon/xeno/hellhound/snore
	key = "snore"
	key_third_person = "snores"
	message = "打起鼾来。"

/datum/emote/living/carbon/xeno/hellhound/grunt
	key = "grunt"
	key_third_person = "grunts"
	message = "发出哼声。"

/datum/emote/living/carbon/xeno/hellhound/rumble
	key = "rumble"
	key_third_person = "rumbles"
	message = "发出低沉的轰鸣。"

/datum/emote/living/carbon/xeno/hellhound/howl
	key = "howl"
	key_third_person = "howls"
	message = "嚎叫起来！"

/datum/emote/living/carbon/xeno/hellhound/growl
	key = "growl"
	key_third_person = "growls"
	message = "发出奇怪而充满威胁的低吼。"

/datum/emote/living/carbon/xeno/hellhound/stare
	key = "stare"
	key_third_person = "stares"
	message = "凝视着。"

/datum/emote/living/carbon/xeno/hellhound/sniff
	key = "sniff"
	key_third_person = "sniffs"
	message = "四下嗅闻。"
