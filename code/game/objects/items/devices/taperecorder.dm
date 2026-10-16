/obj/item/device/taperecorder
	name = "录音机"
	desc = "使用磁带记录对话的设备，播放时会自动翻译录音内容。"
	icon = 'icons/obj/items/walkman.dmi'
	icon_state = "taperecorder_idle"
	item_state = "analyzer"
	w_class = SIZE_SMALL

	matter = list("metal" = 60,"glass" = 30)
	force = 2
	throwforce = 2
	throw_speed = SPEED_VERY_FAST
	//speech_span = SPAN_TAPE_RECORDER
	drop_sound = 'sound/handling/taperecorder_drop.ogg'
	pickup_sound = 'sound/handling/taperecorder_pickup.ogg'
	flags_atom = FPRINT|CONDUCT|USES_HEARING

	var/recording = FALSE
	var/playing = FALSE
	var/playsleepseconds = 0
	var/obj/item/tape/mytape
	var/starting_tape_type = /obj/item/tape/regulation
	var/canprint = TRUE
	var/list/known_languages = ALL_HUMAN_LANGUAGES
	var/list/icons_available = list()
	var/radial_icon_file = 'icons/mob/radial_taperecorder.dmi'
	///Whether we've warned during this recording session that the tape is almost up.
	var/time_warned = FALSE
	///Seconds under which to warn that the tape is almost up.
	var/time_left_warning = 60 SECONDS

	var/datum/looping_sound/tape_recorder_hiss/soundloop

/obj/item/device/taperecorder/Initialize(mapload)
	. = ..()
	if(starting_tape_type)
		mytape = new starting_tape_type(src)
	soundloop = new(src)
	update_icon()

/obj/item/device/taperecorder/Destroy()
	QDEL_NULL(soundloop)
	QDEL_NULL(mytape)
	return ..()

/obj/item/device/taperecorder/proc/readout()
	if(mytape)
		if(playing)
			return SPAN_NOTICE("<b>正在播放</b>")
		else
			var/time = mytape.used_capacity / 10 //deciseconds / 10 = seconds
			var/mins = floor(time / 60)
			var/secs = time - mins * 60
			return SPAN_NOTICE("<b>[mins]</b> 分 <b>[secs]</b> 秒")
	return SPAN_NOTICE("<b>未插入磁带</b>")

/obj/item/device/taperecorder/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("按住 Alt 点击手中的录音机即可播放；若录音机在你身旁，则会打开操作菜单。")
	if(in_range(src, user) || isobserver(user))
		. += SPAN_NOTICE("显示屏上写着：")
		. += "[readout()]"

/obj/item/device/taperecorder/proc/update_available_icons()
	icons_available = list()

	if(!playing && !recording)
		icons_available += list("录音" = image(radial_icon_file,"record"))
		icons_available += list("播放" = image(radial_icon_file,"play"))
		if(canprint && length(mytape?.storedinfo))
			icons_available += list("打印录音文字稿" = image(radial_icon_file,"print"))

	if(playing || recording)
		icons_available += list("停止" = image(radial_icon_file,"stop"))

	if(mytape)
		icons_available += list("弹出" = image(radial_icon_file,"eject"))


/obj/item/device/taperecorder/proc/update_sound()
	if(!playing)
		soundloop.stop()
	else
		soundloop.start()


/obj/item/device/taperecorder/attackby(obj/item/I, mob/user, params)
	if(!mytape && istype(I, /obj/item/tape))
		if(!user.drop_inv_item_to_loc(I, src))
			return
		mytape = I
		to_chat(user, SPAN_NOTICE("你将[I]放入[src]。"))
		playsound(src, 'sound/items/taperecorder/taperecorder_close.ogg', 50, FALSE)
		update_icon()


/obj/item/device/taperecorder/proc/eject(mob/user)
	if(mytape)
		playsound(src, 'sound/items/taperecorder/taperecorder_open.ogg', 50, FALSE)
		to_chat(user, SPAN_NOTICE("你从[src]中取出[mytape]。"))
		stop()
		user.put_in_hands(mytape)
		mytape = null
		update_icon()

/obj/item/device/taperecorder/fire_act(exposed_temperature, exposed_volume)
	mytape.unspool() //Fires unspool the tape, which makes sense if you don't think about it
	..()

/obj/item/device/taperecorder/ex_act(severity, explosion_direction)
	mytape.unspool() //explosions unspool the tape, which makes sense if you don't think about it
	. = ..()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/device/taperecorder/attack_hand(mob/user, mods)
	if(loc != user || !mytape || !user.is_holding(src))
		return ..()
	eject(user)

/obj/item/device/taperecorder/clicked(mob/user, list/mods)
	if(mods[ALT_CLICK])
		if(!CAN_PICKUP(user, src))
			return ..()
		if(loc == user)
			play()
			return TRUE
		else if(Adjacent(user))
			attack_self(user)
			return TRUE
	return ..()

/obj/item/device/taperecorder/proc/can_use(mob/user)
	if(user && ismob(user))
		if(!user.is_mob_incapacitated())
			return TRUE
	return FALSE


/obj/item/device/taperecorder/verb/ejectverb()
	set name = "弹出磁带"
	set category = "物品"

	if(!can_use(usr))
		return
	if(!mytape)
		return

	eject(usr)


/obj/item/device/taperecorder/update_icon()
	if(!mytape)
		icon_state = "taperecorder_empty"
		return
	if(recording)
		icon_state = "taperecorder_recording"
		return
	else if(playing)
		icon_state = "taperecorder_playing"
		return
	icon_state = "taperecorder_idle"
	return


/obj/item/device/taperecorder/hear_talk(mob/living/M, msg, verb, datum/language/speaking, italics)
	. = ..()
	if(mytape && recording)
		mytape.timestamp += mytape.used_capacity
		var/language_known = (M.universal_speak || (speaking && (speaking.name in known_languages)))
		var/mob_name = language_known ? M.GetVoice() : "未知说话者"
		var/message = (!speaking || language_known) ? msg : speaking.scramble(msg)
		mytape.storedinfo += "\[[time2text(mytape.used_capacity,"mm:ss")]\] [mob_name][verb]：“[italics ? "<i>" : null][message][italics ? "</i>" : null]”"


/obj/item/device/taperecorder/verb/record()
	set name = "开始录音"
	set category = "物品"

	if(!can_use(usr))
		return
	if(!mytape || mytape.unspooled)
		return
	if(recording)
		return
	if(playing)
		return

	playsound(src, 'sound/items/taperecorder/taperecorder_play.ogg', 50, FALSE)

	if(mytape.used_capacity < mytape.max_capacity)
		recording = TRUE
		audible_message(SPAN_MAROON("[icon2html(src, usr)] 已开始录音。"))
		update_sound()
		update_icon()
		var/used = mytape.used_capacity //to stop runtimes when you eject the tape
		var/max = mytape.max_capacity
		while(recording && used < max)
			mytape.used_capacity += 1 SECONDS
			used += 1 SECONDS
			if(max - used < time_left_warning && !time_warned)
				time_warned = TRUE
				audible_message(SPAN_MAROON("[icon2html(src, usr)] 还可录制 [(max - used) / 10] 秒！")) //deciseconds / 10 = seconds
			sleep(1 SECONDS)
		if(used >= max)
			audible_message(SPAN_MAROON("[icon2html(src, usr)] 磁带已录满。"))
		stop()
	else
		audible_message(SPAN_MAROON("[icon2html(src, usr)] 磁带已录满！"))
		playsound(src, 'sound/items/taperecorder/taperecorder_stop.ogg', 50, FALSE)


/obj/item/device/taperecorder/verb/stop()
	set name = "停止"
	set category = "物品"

	if(!can_use(usr))
		return

	if(recording)
		playsound(src, 'sound/items/taperecorder/taperecorder_stop.ogg', 50, FALSE)
		audible_message(SPAN_MAROON("[icon2html(src, usr)] 已停止录音。"))
		recording = FALSE
	else if(playing)
		playsound(src, 'sound/items/taperecorder/taperecorder_stop.ogg', 50, FALSE)
		audible_message(SPAN_MAROON("[icon2html(src, usr)] 已停止播放。"))
		playing = FALSE
	time_warned = FALSE
	update_icon()
	update_sound()

/obj/item/device/taperecorder/verb/play()
	set name = "播放磁带"
	set category = "物品"

	if(!can_use(usr))
		return
	if(!mytape || mytape.unspooled)
		return
	if(recording)
		return
	if(playing)
		return

	if(length(mytape.storedinfo) < 1)
		audible_message(SPAN_MAROON("[icon2html(src, usr)] 磁带中没有录音。"))
		return

	playing = TRUE
	update_icon()
	update_sound()
	audible_message(SPAN_MAROON("[icon2html(src, usr)] 已开始播放。"))
	playsound(src, 'sound/items/taperecorder/taperecorder_play.ogg', 50, FALSE)
	var/used = mytape.used_capacity //to stop runtimes when you eject the tape
	var/max = mytape.max_capacity
	for(var/i = 1, used <= max, sleep(playsleepseconds))
		if(!mytape)
			break
		if(playing == FALSE)
			break
		if(length(mytape.storedinfo) < i)
			audible_message(SPAN_MAROON("[icon2html(src, usr)] 录音结束。"))
			break

		var/list/heard = get_mobs_in_view(GLOB.world_view_size, src)
		langchat_speech(mytape.storedinfo[i], heard, GLOB.all_languages, skip_language_check = TRUE, additional_styles = list("langchat_small"))

		audible_message(SPAN_MAROON("[icon2html(src, usr)] [mytape.storedinfo[i]]"))//We want to display this properly, don't double encode
		if(length(mytape.storedinfo) < i + 1)
			playsleepseconds = 1
			sleep(1 SECONDS)
		else
			playsleepseconds = mytape.timestamp[i + 1] - mytape.timestamp[i]
		if(playsleepseconds > 14 SECONDS)
			sleep(1 SECONDS)
			langchat_speech("跳过 [playsleepseconds/10] 秒静音", heard, GLOB.all_languages, skip_language_check = TRUE, additional_styles = list("langchat_small"))
			audible_message(SPAN_MAROON("[icon2html(src, usr)] 跳过 [playsleepseconds/10] 秒静音。"))
			playsleepseconds = 1 SECONDS
		i++

	stop()


/obj/item/device/taperecorder/attack_self(mob/user)
	. = ..()
	if(!mytape)
		to_chat(user, SPAN_NOTICE("[src]里没有磁带。"))
		return
	if(mytape.unspooled)
		to_chat(user, SPAN_WARNING("[src]里面的磁带坏了！"))
		return

	update_available_icons()
	if(icons_available)
		var/selection = show_radial_menu(user, src, icons_available, radius = 38, require_near = TRUE, tooltips = TRUE)
		if(!selection)
			return
		switch(selection)
			if("停止")
				stop()
			if("录音")
				record()
			if("播放")
				play()
			if("打印录音文字稿")
				print_transcript()
			if("弹出")
				eject(user)

/obj/item/device/taperecorder/verb/print_transcript()
	set name = "打印录音文字稿"
	set category = "物品"

	if(!length(mytape.storedinfo))
		return
	if(!can_use(usr))
		return
	if(!mytape)
		return
	if(!canprint)
		to_chat(usr, SPAN_WARNING("录音机无法这么快再次打印！"))
		return
	if(recording || playing)
		return

	audible_message(SPAN_MAROON("[icon2html(src, usr)] 录音文字稿已打印。"))
	playsound(src, 'sound/items/taperecorder/taperecorder_print.ogg', 50, FALSE)
	var/obj/item/paper/sheet_of_paper = new /obj/item/paper(get_turf(src))
	var/t1 = "<B>录音文字稿：</B><BR><BR>"
	for(var/i in 1 to length(mytape.storedinfo))
		t1 += "[mytape.storedinfo[i]]<BR>"
	sheet_of_paper.info = t1
	var/tapename = mytape.name
	var/prototapename = initial(mytape.name)
	sheet_of_paper.name = "录音文字稿——[tapename == prototapename ? "磁带" : "[tapename]"]"
	sheet_of_paper.update_icon()
	usr.put_in_hands(sheet_of_paper)
	canprint = FALSE
	addtimer(VARSET_CALLBACK(src, canprint, TRUE), 30 SECONDS)

//empty tape recorders
/obj/item/device/taperecorder/empty
	starting_tape_type = null

/obj/item/tape
	name = "录音带"
	desc = "每面最多可录制二十分钟内容的磁带。顶部有一条小纸签，可用笔写上标签。"
	icon_state = "cassette_gray"
	icon = 'icons/obj/items/walkman.dmi'
	item_state = "analyzer"
	w_class = SIZE_TINY
	matter = list("metal" = 20,"glass" = 5)
	force = 1
	throwforce = 0
	flags_obj = OBJ_UNIQUE_RENAME //my mixtape
	drop_sound = 'sound/handling/tape_drop.ogg'
	pickup_sound = 'sound/handling/tape_pickup.ogg'
	///Because we can't expect God to do all the work.
	var/initial_icon_state
	var/max_capacity = 20 MINUTES
	var/used_capacity = 0 SECONDS
	///Numbered list of chat messages the recorder has heard with spans and prepended timestamps. Used for playback and transcription.
	var/list/storedinfo = list()
	///Numbered list of seconds the messages in the previous list appear at on the tape. Used by playback to get the timing right.
	var/list/timestamp = list()
	var/used_capacity_otherside = 0 SECONDS //Separate my side
	var/list/storedinfo_otherside = list()
	var/list/timestamp_otherside = list()
	var/unspooled = FALSE
	var/list/icons_available = list()
	var/radial_icon_file = 'icons/mob/radial_tape.dmi'
	var/list/cassette_colors = list("blue", "gray", "green", "orange", "pink_stripe", "purple", "rainbow", "red_black", "red_stripe", "camo", "rising_sun", "orange", "blue", "ocean", "aesthetic")
	var/list/cassette_map_themes = list("solaris", "ice", "lz", "dam", "worstmap")
	inherent_traits = list(TRAIT_ITEM_RENAME_SPECIAL) //used to make the rename component work specially.
	///used to store the tape's name for one side and the other side
	var/flipped_name
	var/unflipped_name


/obj/item/tape/get_examine_text(mob/user)
	. = ..()
	if(in_range(src, user) || isobserver(user))
		if(unspooled)
			. += SPAN_WARNING("里面的磁带全被抽出来了！也许可以用螺丝刀将它卷回去。")
		else
			var/used_tape_percent = floor((used_capacity / max_capacity)*100)
			switch(used_tape_percent)
				if(0 to 5)
					. += SPAN_NOTICE("它还没有使用过。")
				if(5 to 25)
					. += SPAN_NOTICE("磁带已录了一小部分。")
				if(26 to 50)
					. += SPAN_NOTICE("磁带已录了不到一半。")
				if(51 to 75)
					. += SPAN_NOTICE("磁带已录了超过一半。")
				if(75 to 90)
					. += SPAN_WARNING("磁带快录满了！")
				if(90 to 99)
					. += SPAN_WARNING("只剩一点点可录制空间了！")
				if(100)
					. += SPAN_WARNING("磁带已完全录满。")

/obj/item/tape/fire_act(exposed_temperature, exposed_volume)
	unspool()
	..()

/obj/item/tape/ex_act(severity, explosion_direction)
	unspool()
	. = ..()


/obj/item/tape/Initialize(mapload)
	. = ..()
	initial_icon_state = icon_state //random tapes will set this after choosing their icon
	if(prob(50))
		tapeflip()
	flipped_name = name
	unflipped_name = name

/obj/item/tape/proc/update_available_icons()
	icons_available = list()

	if(!unspooled)
		icons_available += list("抽出磁带" = image(radial_icon_file,"tape_unwind"))
	icons_available += list("磁带翻面" = image(radial_icon_file,"tape_flip"))

/obj/item/tape/attack_self(mob/user)
	. = ..()

	if(unspooled)
		tapeflip()
		to_chat(user, SPAN_NOTICE("你将[src]翻面。"))
		playsound(src, 'sound/items/taperecorder/tape_flip.ogg', 70, FALSE)
		return

	update_available_icons()
	if(icons_available)
		var/selection = show_radial_menu(user, src, icons_available, radius = 38, require_near = TRUE, tooltips = TRUE)
		if(!selection)
			return
		switch(selection)
			if("磁带翻面")
				if(loc != user)
					return
				tapeflip()
				to_chat(user, SPAN_NOTICE("你将[src]翻面。"))
				playsound(src, 'sound/items/taperecorder/tape_flip.ogg', 70, FALSE)
			if("抽出磁带")
				if(loc != user)
					return
				unspool()
				to_chat(user, SPAN_WARNING("你把磁带全抽了出来！"))

/obj/item/tape/attackby(obj/item/W, mob/user)
	. = ..()
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(!unspooled)
			return FALSE
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("你开始将磁带卷回去……"))
		if(!(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC)))
			to_chat(user, SPAN_NOTICE("你停止卷回磁带。"))
			return
		to_chat(user, SPAN_NOTICE("你将磁带卷了回去。"))
		respool()

/obj/item/tape/proc/unspool()
	//Let's not add infinite amounts of overlays when our fire_act is called repeatedly
	if(!unspooled)
		overlays += "ribbon_overlay"
	unspooled = TRUE

/obj/item/tape/proc/respool()
	overlays.Cut()
	unspooled = FALSE

/obj/item/tape/proc/tapeflip()
	//first we save a copy of our current side
	var/list/storedinfo_currentside = storedinfo.Copy()
	var/list/timestamp_currentside = timestamp.Copy()
	var/used_capacity_currentside = used_capacity
	//then we overwite our current side with our other side
	storedinfo = storedinfo_otherside.Copy()
	timestamp = timestamp_otherside.Copy()
	used_capacity = used_capacity_otherside
	//then we overwrite our other side with the saved side
	storedinfo_otherside = storedinfo_currentside.Copy()
	timestamp_otherside = timestamp_currentside.Copy()
	used_capacity_otherside = used_capacity_currentside

	if(icon_state == initial_icon_state)
		icon_state = "cassette_flip"
		unflipped_name = name
		name = flipped_name
	else if(icon_state == "cassette_flip") //so flipping doesn't overwrite an unexpected icon_state (e.g. an admin's)
		icon_state = initial_icon_state
		flipped_name = name
		name = unflipped_name

//Random color tapes
/obj/item/tape/random
	icon_state = "cassette_rainbow"

/obj/item/tape/random/Initialize(mapload)
	icon_state = "cassette_[pick(cassette_colors)]"
	. = ..()

/obj/item/tape/regulation
	name = "制式录音带"
	icon_state = "cassette_regulation"
