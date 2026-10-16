#define CAMERA_WIRE_FOCUS 1
#define CAMERA_WIRE_POWER 2
#define CAMERA_WIRE_LIGHT 3
#define CAMERA_WIRE_ALARM 4
#define CAMERA_WIRE_NOTHING1 5
#define CAMERA_WIRE_NOTHING2 6

/obj/structure/machinery/camera/proc/randomCameraWires()
	//to make this not randomize the wires, just set index to 1 and increment it in the flag for loop (after doing everything else).
	var/list/wires = list(0, 0, 0, 0, 0, 0)
	IndexToFlag = list(0, 0, 0, 0, 0, 0)
	IndexToWireColor = list(0, 0, 0, 0, 0, 0)
	WireColorToIndex = list(0, 0, 0, 0, 0, 0)
	var/flagIndex = 1
	//I think it's easier to read this way, also doesn't rely on the random number generator to land on a new wire.
	var/list/colorIndexList = list(CAMERA_WIRE_FOCUS, CAMERA_WIRE_POWER, CAMERA_WIRE_LIGHT, CAMERA_WIRE_ALARM, CAMERA_WIRE_NOTHING1, CAMERA_WIRE_NOTHING2)
	for (var/flag = 1, flag <= 32, flag += flag)
		var/colorIndex = pick(colorIndexList)
		if (wires[colorIndex]==0)
			wires[colorIndex] = flag
			IndexToFlag[flagIndex] = flag
			IndexToWireColor[flagIndex] = colorIndex
			WireColorToIndex[colorIndex] = flagIndex
			colorIndexList -= colorIndex // Shortens the list.
		//world.log << "Flag: [flag], CIndex: [colorIndex], FIndex: [flagIndex]"
		flagIndex+=1
	return wires

/obj/structure/machinery/camera/proc/isWireColorCut(wireColor)
	var/wireFlag = WireColorToFlag[wireColor]
	return ((src.wires & wireFlag) == 0)

/obj/structure/machinery/camera/proc/isWireCut(wireIndex)
	var/wireFlag = IndexToFlag[wireIndex]
	return ((src.wires & wireFlag) == 0)

/obj/structure/machinery/camera/proc/canDeconstruct()
	if(isWireCut(CAMERA_WIRE_POWER) && isWireCut(CAMERA_WIRE_FOCUS) && isWireCut(CAMERA_WIRE_LIGHT) && isWireCut(CAMERA_WIRE_NOTHING1) && isWireCut(CAMERA_WIRE_NOTHING2))
		return 1
	else
		return 0

/obj/structure/machinery/camera/proc/cut(wireColor)
	var/wireFlag = WireColorToFlag[wireColor]
	var/wireIndex = WireColorToIndex[wireColor]
	wires &= ~wireFlag
	switch(wireIndex)
		if(CAMERA_WIRE_FOCUS)
			setViewRange(short_range)

		if(CAMERA_WIRE_POWER)
			if(status)
				toggle_cam_status(usr)

		if(CAMERA_WIRE_LIGHT)
			light_disabled = 1

		if(CAMERA_WIRE_ALARM)
			triggerCameraAlarm()

	src.interact(usr)

/obj/structure/machinery/camera/proc/mend(wireColor)
	var/wireFlag = WireColorToFlag[wireColor]
	var/wireIndex = WireColorToIndex[wireColor]
	wires |= wireFlag
	switch(wireIndex)
		if(CAMERA_WIRE_FOCUS)
			setViewRange(initial(view_range))

		if(CAMERA_WIRE_POWER)
			if(!status)
				toggle_cam_status(usr)

		if(CAMERA_WIRE_LIGHT)
			light_disabled = 0

		if(CAMERA_WIRE_ALARM)
			cancelCameraAlarm()

	src.interact(usr)


/obj/structure/machinery/camera/proc/pulse(wireColor)
	var/wireIndex = WireColorToIndex[wireColor]
	switch(wireIndex)
		if(CAMERA_WIRE_FOCUS)
			var/new_range = (view_range == initial(view_range) ? short_range : initial(view_range))
			setViewRange(new_range)

		if(CAMERA_WIRE_POWER)
			toggle_cam_status(usr) // Kicks anyone watching the camera

		if(CAMERA_WIRE_LIGHT)
			light_disabled = !light_disabled

		if(CAMERA_WIRE_ALARM)
			src.visible_message("[icon2html(src, hearers(src))] *哔*", "[icon2html(src, hearers(src))] *哔*")

	src.interact(usr)

/obj/structure/machinery/camera/interact(mob/living/user as mob)
	if(!panel_open)
		return

	user.set_interaction(src)
	var/t1 = text("<B>检修面板</B><br>\n")
	var/list/wires = list(
		"橙色" = 1,
		"暗红色" = 2,
		"白色" = 3,
		"黄色" = 4,
		"蓝色" = 5,
		"粉色" = 6
	)
	for(var/wiredesc in wires)
		var/is_uncut = src.wires & WireColorToFlag[wires[wiredesc]]
		t1 += "[wiredesc]电线："
		if(!is_uncut)
			t1 += "<a href='byond://?src=\ref[src];wires=[wires[wiredesc]]'>接合</a>"
		else
			t1 += "<a href='byond://?src=\ref[src];wires=[wires[wiredesc]]'>剪断</a> "
			t1 += "<a href='byond://?src=\ref[src];pulse=[wires[wiredesc]]'>脉冲</a> "
		t1 += "<br>"

	t1 += "<br>\n[(src.view_range == initial(view_range) ? "聚焦指示灯亮着。" : "聚焦指示灯熄灭。")]"
	t1 += "<br>\n[(src.can_use() ? "电源连接指示灯亮着。" : "电源连接指示灯熄灭。")]"
	t1 += "<br>\n[(light_disabled ? "摄像头照明已关闭。" : "摄像头照明已开启。")]"
	t1 += "<br>\n[(alarm_on ? "警报指示灯亮着。" : "警报指示灯熄灭。")]"

	t1 += "<p><a href='byond://?src=\ref[src];close2=1'>关闭</a></p>\n"
	show_browser(user, t1, "摄像头检修面板", "wires")



/obj/structure/machinery/camera/Topic(href, href_list)
	..()
	if (in_range(src, usr) && istype(src.loc, /turf))
		usr.set_interaction(src)
		if (href_list["wires"])
			var/t1 = text2num(href_list["wires"])
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(usr, SPAN_WARNING("你需要剪线钳！"))
				return
			if (src.isWireColorCut(t1))
				src.mend(t1)
			else
				src.cut(t1)
		else if (href_list["pulse"])
			var/t1 = text2num(href_list["pulse"])
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
				to_chat(usr, SPAN_WARNING("你需要多功能工具！"))
				return
			if (src.isWireColorCut(t1))
				to_chat(usr, SPAN_WARNING("你无法向已剪断的电线发送脉冲。"))
				return
			else
				src.pulse(t1)
		else if (href_list["close2"])
			close_browser(usr, "wires")
			usr.unset_interaction()
			return


#undef CAMERA_WIRE_FOCUS
#undef CAMERA_WIRE_POWER
#undef CAMERA_WIRE_LIGHT
#undef CAMERA_WIRE_ALARM
#undef CAMERA_WIRE_NOTHING1
#undef CAMERA_WIRE_NOTHING2
