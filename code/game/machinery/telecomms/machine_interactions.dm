//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32


/*

	All telecommunications interactions:

*/

#define TELECOMM_GROUND_Z "station_z"

/obj/structure/machinery/telecomms
	var/temp = "" // output message
	var/construct_op = 0
	var/deconstructable = FALSE


/obj/structure/machinery/telecomms/attackby(obj/item/P as obj, mob/user as mob)

	// Using a multitool lets you access the receiver's interface
	if(istype(P, /obj/item/device/multitool))
		attack_hand(user)

	else
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你茫然地盯着[src]，不知该如何下手……"))
			return 0

	switch(construct_op)
		if(0)
			if(HAS_TRAIT(P, TRAIT_TOOL_SCREWDRIVER) && deconstructable)
				to_chat(user, "你松开了螺栓。")
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				construct_op ++
		if(1)
			if(HAS_TRAIT(P, TRAIT_TOOL_SCREWDRIVER))
				to_chat(user, "你拧紧了螺栓。")
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				construct_op --
			if(HAS_TRAIT(P, TRAIT_TOOL_WRENCH))
				to_chat(user, "你松开了外部面板。")
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				construct_op ++
		if(2)
			if(HAS_TRAIT(P, TRAIT_TOOL_WRENCH))
				to_chat(user, "你固定好了外部面板。")
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				construct_op --
			if(HAS_TRAIT(P, TRAIT_TOOL_WIRECUTTERS))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				to_chat(user, "你拆除了线缆。")
				construct_op ++
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( user.loc )
				A.amount = 5
				stat |= BROKEN // the machine's been borked!
		if(3)
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/A = P
				if (A.use(5))
					to_chat(user, SPAN_NOTICE("你接入了线缆。"))
					construct_op--
					stat &= ~BROKEN // the machine's not borked anymore!
				else
					to_chat(user, SPAN_WARNING("这需要5段线缆。"))
			if(HAS_TRAIT(P, TRAIT_TOOL_CROWBAR))
				to_chat(user, "你开始撬出电路板和其他部件……")
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				if(do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					to_chat(user, "你撬出了所有部件。")

					// Drop all the component stuff
					if(length(contents) > 0)
						for(var/obj/x in src)
							x.forceMove(user.loc)
					else

						// If the machine wasn't made during runtime, probably doesn't have components:
						// manually find the components and drop them!
						var/newpath = circuitboard
						var/obj/item/circuitboard/machine/C = new newpath
						for(var/I in C.req_components)
							for(var/i = 1, i <= C.req_components[I], i++)
								newpath = I
								var/obj/item/s = new newpath
								s.forceMove(user.loc)
								if(istype(P, /obj/item/stack/cable_coil))
									var/obj/item/stack/cable_coil/A = P
									A.amount = 1

						// Drop a circuit board too
						C.forceMove(user.loc)
					deconstruct()

/obj/structure/machinery/telecomms/deconstruct(disassembled = TRUE)
	if(disassembled) // Create a machine frame and delete the current machine
		new /obj/structure/machinery/constructable_frame(src)
	return ..()

/obj/structure/machinery/telecomms/attack_remote(mob/user as mob)
	attack_hand(user)

/obj/structure/machinery/telecomms/attack_hand(mob/user as mob)

	// You need a multitool to use this, or be silicon
	if(!isSilicon(user))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你茫然地盯着[src]，不知该如何下手……"))
			return
		// istype returns false if the value is null
		var/obj/item/held_item = user.get_active_hand()
		if(!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
			return

	if(inoperable())
		return

	user.set_interaction(src)
	var/dat
	dat = "<font face = \"Courier\">"
	dat += "<br>[temp]<br>"
	dat += "<br>电源状态：<a href='byond://?src=\ref[src];input=toggle'>[src.toggled ? "开启" : "关闭"]</a>"
	if(on && toggled)
		if(id != "" && id)
			dat += "<br>标识字符串：<a href='byond://?src=\ref[src];input=id'>[id]</a>"
		else
			dat += "<br>标识字符串：<a href='byond://?src=\ref[src];input=id'>未设置</a>"
		dat += "<br>网络：<a href='byond://?src=\ref[src];input=network'>[network]</a>"
		dat += "<br>预设配置：[length(autolinkers) ? "是" : "否"]"
		if(hide) dat += "<br>隐蔽链接：已启用</a>"

		//Show additional options for certain GLOB.machines.
		dat += Options_Menu()

		dat += "<br>已连接的网络设备：<ol>"

		var/i = 0
		for(var/obj/structure/machinery/telecomms/T in links)
			i++
			if(T.hide && !src.hide)
				continue
			dat += "<li>\ref[T] [T.name] ([T.id])  <a href='byond://?src=\ref[src];unlink=[i]'>\[X\]</a></li>"
		dat += "</ol>"

		dat += "<br>筛选频率："

		i = 0
		if(length(freq_listening))
			for(var/x in freq_listening)
				i++
				if(i < length(freq_listening))
					dat += "[format_frequency(x)] GHz<a href='byond://?src=\ref[src];delete=[x]'>\[X\]</a>; "
				else
					dat += "[format_frequency(x)] GHz<a href='byond://?src=\ref[src];delete=[x]'>\[X\]</a>"
		else
			dat += "无"

		dat += "<br>  <a href='byond://?src=\ref[src];input=freq'>\[添加筛选频率\]</a>"
		dat += "<hr>"

	dat += "</font>"
	temp = ""
	show_browser(user, dat, "[src]控制界面", "tcommachine", "can_resize=0", width = 520, height = 500)
	onclose(user, "tcommachine")


// Off-Site Relays
//
// You are able to send/receive signals from the station's z level (changeable in the STATION_Z #define) if
// the relay is on the telecomm satellite (changable in the TELECOMM_Z #define)


/obj/structure/machinery/telecomms/relay/proc/toggle_level()

	var/turf/position = get_turf(src)

	// Toggle on/off getting signals from the station or the current Z level
	if(src.listening_level == TELECOMM_GROUND_Z) // equals the station
		src.listening_level = position.z
		return 1
	else if(should_block_game_interaction(position))
		src.listening_level = TELECOMM_GROUND_Z
		return 1
	return 0

// Additional Options for certain GLOB.machines. Use this when you want to add an option to a specific machine.
// Example of how to use below.

/obj/structure/machinery/telecomms/proc/Options_Menu()
	return ""

/*
// Add an option to the processor to switch processing mode. (COMPRESS -> UNCOMPRESS or UNCOMPRESS -> COMPRESS)
/obj/structure/machinery/telecomms/processor/Options_Menu()
	var/dat = "<br>Processing Mode: <A href='byond://?src=\ref[src];process=1'>[process_mode ? "UNCOMPRESS" : "COMPRESS"]</a>"
	return dat
*/
// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/structure/machinery/telecomms/proc/Options_Topic(href, href_list)
	return

/*
/obj/structure/machinery/telecomms/processor/Options_Topic(href, href_list)

	if(href_list["process"])
		temp = "<font color = #666633>-% Processing mode changed. %-</font color>"
		src.process_mode = !src.process_mode
*/

// RELAY

/obj/structure/machinery/telecomms/relay/Options_Menu()
	var/dat = ""
	if(should_block_game_interaction(src))
		dat += "<br>信号锁定空间站：<A href='byond://?src=\ref[src];change_listening=1'>[listening_level == TELECOMM_GROUND_Z ? "是" : "否"]</a>"
	dat += "<br>广播：<A href='byond://?src=\ref[src];broadcast=1'>[broadcasting ? "开启" : "关闭"]</a>"
	dat += "<br>接收：<A href='byond://?src=\ref[src];receive=1'>[receiving ? "开启" : "关闭"]</a>"
	return dat

/obj/structure/machinery/telecomms/relay/Options_Topic(href, href_list)

	if(href_list["receive"])
		receiving = !receiving
		temp = "<font color = #666633>-% 接收模式已更改。 %-</font color>"
	if(href_list["broadcast"])
		broadcasting = !broadcasting
		temp = "<font color = #666633>-% 广播模式已更改。 %-</font color>"
	if(href_list["change_listening"])
		//Lock to the station OR lock to the current position!
		//You need at least two receivers and two broadcasters for this to work, this includes the machine.
		var/result = toggle_level()
		if(result)
			temp = "<font color = #666633>-% [src]的信号已成功更改。</font color>"
		else
			temp = "<font color = #666633>-% [src]无法将信号锁定到空间站。需要两个广播器或接收器。</font color>"

// BUS

/obj/structure/machinery/telecomms/bus/Options_Menu()
	var/dat = "<br>转换信号频率：<A href='byond://?src=\ref[src];change_freq=1'>[change_frequency ? "启用（[change_frequency]）" : "关闭"]</a>"
	return dat

/obj/structure/machinery/telecomms/bus/Options_Topic(href, href_list)

	if(href_list["change_freq"])

		var/newfreq = input(usr, "指定新信号要转换到的频率。留空可关闭频率转换，小数点将自动添加。", src, network) as null|num
		if(canAccess(usr))
			if(newfreq)
				if(findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place
				if(newfreq < 10000)
					change_frequency = newfreq
					temp = "<font color = #666633>-% 已设置新的目标频率：“[newfreq] GHz” %-</font color>"
			else
				change_frequency = 0
				temp = "<font color = #666633>-% 已关闭频率转换 %-</font color>"


/obj/structure/machinery/telecomms/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!isSilicon(usr))
		var/obj/item/held_item = usr.get_held_item()
		if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
			return

	if(inoperable())
		return

	if(href_list["input"])
		switch(href_list["input"])

			if("toggle")
				src.toggled = !src.toggled
				temp = "<font color = #666633>-% [src]已[src.toggled ? "启用" : "停用"]。</font color>"
				toggle_state(usr)

			/*
			if("hide")
				src.hide = !hide
				temp = "<font color = #666633>-% Shadow Link has been [src.hide ? "activated" : "deactivated"].</font color>"
			*/

			if("id")
				var/newid = copytext(reject_bad_text(input(usr, "指定这台机器的新 ID", src, id) as null|text),1,MAX_MESSAGE_LEN)
				if(newid && canAccess(usr))
					id = newid
					temp = "<font color = #666633>-% 已设置新 ID：“[id]” %-</font color>"

			if("network")
				var/newnet = stripped_input(usr, "指定这台机器的新网络。这将断开当前的所有链接。", src, network)
				if(newnet && canAccess(usr))

					if(length(newnet) > 15)
						temp = "<font color = #666633>-% 新网络标签的字符过多 %-</font color>"

					else
						for(var/obj/structure/machinery/telecomms/T in links)
							T.links.Remove(src)

						network = newnet
						links = list()
						temp = "<font color = #666633>-% 已设置新网络标签：“[network]” %-</font color>"


			if("freq")
				var/newfreq = input(usr, "指定新的筛选频率（GHz），小数点将自动添加。", src, network) as null|num
				if(newfreq && canAccess(usr))
					if(findtext(num2text(newfreq), "."))
						newfreq *= 10 // shift the decimal one place
					if(!(newfreq in freq_listening) && newfreq < 10000)
						freq_listening.Add(newfreq)
						temp = "<font color = #666633>-% 已添加筛选频率：“[newfreq] GHz” %-</font color>"

	if(href_list["delete"])

		// changed the layout about to workaround a pesky runtime -- Doohl

		var/x = text2num(href_list["delete"])
		temp = "<font color = #666633>-% 已移除筛选频率[x] %-</font color>"
		freq_listening.Remove(x)

	if(href_list["unlink"])

		if(text2num(href_list["unlink"]) <= length(links))
			var/obj/structure/machinery/telecomms/T = links[text2num(href_list["unlink"])]
			if(istype(T))
				temp = "<font color = #666633>-% 已从连接设备中移除\ref[T] [T.name]。 %-</font color>"

				// Remove link entries from both T and src.

				if(src in T.links)
					T.links.Remove(src)
				links.Remove(T)

	src.Options_Topic(href, href_list)

	usr.set_interaction(src)
	src.add_fingerprint(usr)

	updateUsrDialog()

/obj/structure/machinery/telecomms/proc/canAccess(mob/user)
	if(isRemoteControlling(user) || in_range(user, src))
		return 1
	return 0
