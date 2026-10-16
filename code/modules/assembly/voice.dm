/obj/item/device/assembly/voice
	name = "语音分析器"
	desc = "可录制一段语音样本的小型电子装置，再次听到相同内容时会发出信号。"
	icon_state = "voice"
	matter = list("metal" = 500, "glass" = 50, "waste" = 10)

	var/listening = 0
	var/recorded //the activation message

/obj/item/device/assembly/voice/hear_talk(mob/living/M as mob, msg)
	if(listening)
		recorded = msg
		listening = 0
		var/turf/T = get_turf(src) //otherwise it won't work in hand
		T.visible_message("[icon2html(src, hearers(src))]发出哔声：“触发语句为‘[recorded]’。”")
	else
		if(findtext(msg, recorded))
			pulse(0)

/obj/item/device/assembly/voice/activate()
	if(secured)
		if(!holder)
			listening = !listening
			var/turf/T = get_turf(src)
			T.visible_message("[icon2html(src, hearers(src))]发出哔声：“[listening ? "开始" : "停止"]录制语音。”")


/obj/item/device/assembly/voice/attack_self(mob/user)
	..()

	if(!user)
		return

	activate()


/obj/item/device/assembly/voice/toggle_secure()
	. = ..()
	listening = 0
