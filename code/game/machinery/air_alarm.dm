////////////////////////////////////////
//CONTAINS: Air Alarms and Fire Alarms//
////////////////////////////////////////

/proc/RandomAAlarmWires()
	//to make this not randomize the wires, just set index to 1 and increment it in the flag for loop (after doing everything else).
	var/list/AAlarmwires = list(0, 0, 0, 0, 0)
	GLOB.AAlarmIndexToFlag = list(0, 0, 0, 0, 0)
	GLOB.AAlarmIndexToWireColor = list(0, 0, 0, 0, 0)
	GLOB.AAlarmWireColorToIndex = list(0, 0, 0, 0, 0)
	var/flagIndex = 1
	for (var/flag=1, flag<32, flag+=flag)
		var/valid = 0
		while (!valid)
			var/colorIndex = rand(1, 5)
			if (AAlarmwires[colorIndex]==0)
				valid = 1
				AAlarmwires[colorIndex] = flag
				GLOB.AAlarmIndexToFlag[flagIndex] = flag
				GLOB.AAlarmIndexToWireColor[flagIndex] = colorIndex
				GLOB.AAlarmWireColorToIndex[colorIndex] = flagIndex
		flagIndex+=1
	return AAlarmwires

#define AALARM_WIRE_IDSCAN 1 //Added wires
#define AALARM_WIRE_POWER 2
#define AALARM_WIRE_SYPHON 3
#define AALARM_WIRE_AI_CONTROL 4
#define AALARM_WIRE_AALARM 5

GLOBAL_LIST_INIT(aalarm_wire_descriptions, flatten_numeric_alist(alist(
		AALARM_WIRE_IDSCAN = "身份卡扫描器",
		AALARM_WIRE_POWER = "主电源",
		AALARM_WIRE_SYPHON = "抽气",
		AALARM_WIRE_AI_CONTROL = "人工智能控制",
		AALARM_WIRE_AALARM = "空气警报",
	)))

#define AALARM_MODE_SCRUBBING 1
#define AALARM_MODE_REPLACEMENT 2 //like scrubbing, but faster.
#define AALARM_MODE_PANIC 3 //constantly sucks all air
#define AALARM_MODE_CYCLE 4 //sucks off all air, then refill and switches to scrubbing
#define AALARM_MODE_FILL 5 //emergency fill
#define AALARM_MODE_OFF 6 //Shuts it all down.

GLOBAL_LIST_INIT(aalarm_mode_descriptions, flatten_numeric_alist(alist(
		AALARM_MODE_SCRUBBING = "过滤——清除污染物",
		AALARM_MODE_REPLACEMENT = SET_CLASS("换气——一边抽出空气，一边补充新鲜空气", INTERFACE_BLUE),
		AALARM_MODE_PANIC = SET_CLASS("紧急抽气——抽空房间内的空气", INTERFACE_RED),
		AALARM_MODE_CYCLE = SET_CLASS("循环——先抽空空气，再补充新鲜空气", INTERFACE_RED),
		AALARM_MODE_FILL = SET_CLASS("充气——关闭洗涤器，打开通风口", INTERFACE_GREEN),
		AALARM_MODE_OFF = SET_CLASS("关闭——关闭通风口和洗涤器", INTERFACE_BLUE),
	)))

#define AALARM_SCREEN_MAIN 1
#define AALARM_SCREEN_VENT 2
#define AALARM_SCREEN_SCRUB 3
#define AALARM_SCREEN_MODE 4
#define AALARM_SCREEN_SENSORS 5

#define AALARM_REPORT_TIMEOUT 100

#define RCON_NO 1
#define RCON_AUTO 2
#define RCON_YES 3

#define MAX_TEMPERATURE 90
#define MIN_TEMPERATURE -40

//all air alarms in area are connected via magic
/area
	var/obj/structure/machinery/alarm/master_air_alarm
	var/list/air_vent_names = list()
	var/list/air_scrub_names = list()
	var/list/air_vent_info = list()
	var/list/air_scrub_info = list()

/obj/structure/machinery/alarm
	name = "警报器"
	icon = 'icons/obj/structures/machinery/monitors.dmi' // I made these really quickly because idk where they have their new air alarm ~Art
	icon_state = "alarm0"
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 80
	active_power_usage = 1000 //For heating/cooling rooms. 1000 joules equates to about 1 degree every 2 seconds for a single tile of air.
	power_channel = POWER_CHANNEL_ENVIRON
	req_one_access = list(ACCESS_CIVILIAN_ENGINEERING)
	var/alarm_id = null
	var/breach_detection = 1 // Whether to use automatic breach detection or not
	var/frequency = 1439
	//var/skipprocess = 0 //Experimenting
	var/alarm_frequency = 1437
	var/remote_control = 0
	var/rcon_setting = 2
	var/rcon_time = 0
	var/locked = 1
	var/wiresexposed = 0 // If it's been screwdrivered open.
	var/aidisabled = 0
	var/AAlarmwires = 31
	var/shorted = 0

	var/mode = AALARM_MODE_SCRUBBING
	var/screen = AALARM_SCREEN_MAIN
	var/area_uid
	var/area/alarm_area
	var/buildstage = 2 //2 is built, 1 is building, 0 is frame.

	var/target_temperature = T0C+20
	var/regulating_temperature = 0

	var/datum/radio_frequency/radio_connection

	var/list/TLV = list()

	var/danger_level = 0
	var/pressure_dangerlevel = 0
	var/oxygen_dangerlevel = 0
	var/co2_dangerlevel = 0
	var/phoron_dangerlevel = 0
	var/temperature_dangerlevel = 0
	var/other_dangerlevel = 0

	var/apply_danger_level = 1
	var/post_alert = 1

/obj/structure/machinery/alarm/Initialize(mapload, direction, building = 0)
	. = ..()

	set_frequency(frequency)
	if (!master_is_operating())
		elect_master()

	if(building)
		if(loc)
			forceMove(loc)

		if(direction)
			src.setDir(direction)

		buildstage = 0
		wiresexposed = 1
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0
		update_icon()

	if(!pixel_x && !pixel_y)
		switch(dir)
			if(NORTH) pixel_y = 25
			if(SOUTH) pixel_y = -25
			if(EAST) pixel_x = 25
			if(WEST) pixel_x = -25

	first_run()

/obj/structure/machinery/alarm/proc/first_run()
	alarm_area = get_area(src)
	area_uid = alarm_area.uid
	if (name == "alarm")
		name = "[alarm_area.name]空气警报器"

	// breathable air according to human/Life(delta_time)
	TLV["oxygen"] = list(16, 19, 135, 140) // Partial pressure, kpa
	TLV["carbon dioxide"] = list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
	TLV["phoron"] = list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["other"] = list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] = list(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20) /* kpa */
	TLV["temperature"] = list(T0C-26, T0C, T0C+40, T0C+66) // K

/obj/structure/machinery/alarm/Destroy()
	if(alarm_area.master_air_alarm == src)
		alarm_area.master_air_alarm = null
	alarm_area = null
	SSradio.remove_object(src, frequency)
	radio_connection = null
	return ..()

/obj/structure/machinery/alarm/proc/handle_heating_cooling()
	return

/obj/structure/machinery/alarm/proc/overall_danger_level(turf/T)
	pressure_dangerlevel = get_danger_level(T.return_pressure(), TLV["pressure"])
	temperature_dangerlevel = get_danger_level(T.return_temperature(), TLV["temperature"])

	return max(
		pressure_dangerlevel,
		temperature_dangerlevel
		)

// Returns whether this air alarm thinks there is a breach, given the sensors that are available to it.
/obj/structure/machinery/alarm/proc/breach_detected()
	var/turf/location = loc

	if(!istype(location))
		return 0

	if(breach_detection == 0)
		return 0

	var/pressure_levels = TLV["pressure"]

	if (location.return_pressure() <= pressure_levels[1]) //low pressures
		if (!(mode == AALARM_MODE_PANIC || mode == AALARM_MODE_CYCLE))
			return 1

	return 0


/obj/structure/machinery/alarm/proc/master_is_operating()
	return alarm_area && alarm_area.master_air_alarm && !(alarm_area.master_air_alarm.inoperable())


/obj/structure/machinery/alarm/proc/elect_master()
	if(!alarm_area)
		return 0
	for (var/obj/structure/machinery/alarm/AA in alarm_area)
		if (!(AA.inoperable()))
			alarm_area.master_air_alarm = AA
			return 1
	return 0

/obj/structure/machinery/alarm/proc/get_danger_level(current_value, list/danger_levels)
	if((current_value >= danger_levels[4] && danger_levels[4] > 0) || current_value <= danger_levels[1])
		return 2
	if((current_value >= danger_levels[3] && danger_levels[3] > 0) || current_value <= danger_levels[2])
		return 1
	return 0

/obj/structure/machinery/alarm/update_icon()
	if(wiresexposed)
		icon_state = "alarmx"
		return
	if((inoperable()) || shorted)
		icon_state = "alarmp"
		return

	var/icon_level = danger_level
	if (!isnull(alarm_area) && alarm_area.atmosalm)
		icon_level = max(icon_level, 1) //if there's an atmos alarm but everything is okay locally, no need to go past yellow

	switch(icon_level)
		if (0)
			icon_state = "alarm0"
		if (1)
			icon_state = "alarm2" //yes, alarm2 is yellow alarm
		if (2)
			icon_state = "alarm1"

/obj/structure/machinery/alarm/receive_signal(datum/signal/signal)
	if(inoperable())
		return
	if (alarm_area.master_air_alarm != src)
		if (master_is_operating())
			return
		elect_master()
		if (alarm_area.master_air_alarm != src)
			return
	if(!signal || signal.encryption)
		return
	var/id_tag = signal.data["tag"]
	if (!id_tag)
		return
	if (signal.data["area"] != area_uid)
		return
	if (signal.data["sigtype"] != "status")
		return

	var/dev_type = signal.data["device"]
	if(!(id_tag in alarm_area.air_scrub_names) && !(id_tag in alarm_area.air_vent_names))
		register_env_machine(id_tag, dev_type)
	if(dev_type == "AScr")
		alarm_area.air_scrub_info[id_tag] = signal.data
	else if(dev_type == "AVP")
		alarm_area.air_vent_info[id_tag] = signal.data

/obj/structure/machinery/alarm/proc/register_env_machine(m_id, device_type)
	var/new_name
	if (device_type=="AVP")
		new_name = "[alarm_area.name]通风泵 #[length(alarm_area.air_vent_names)+1]"
		alarm_area.air_vent_names[m_id] = new_name
	else if (device_type=="AScr")
		new_name = "[alarm_area.name]空气洗涤器 #[length(alarm_area.air_scrub_names)+1]"
		alarm_area.air_scrub_names[m_id] = new_name
	else
		return
	spawn (10)
		send_signal(m_id, list("init" = new_name) )

/obj/structure/machinery/alarm/proc/refresh_all()
	for(var/id_tag in alarm_area.air_vent_names)
		var/list/I = alarm_area.air_vent_info[id_tag]
		if (I && I["timestamp"]+AALARM_REPORT_TIMEOUT/2 > world.time)
			continue
		send_signal(id_tag, list("status") )
	for(var/id_tag in alarm_area.air_scrub_names)
		var/list/I = alarm_area.air_scrub_info[id_tag]
		if (I && I["timestamp"]+AALARM_REPORT_TIMEOUT/2 > world.time)
			continue
		send_signal(id_tag, list("status") )

/obj/structure/machinery/alarm/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_TO_AIRALARM)

/obj/structure/machinery/alarm/proc/send_signal(target, list/command)//sends signal 'command' to 'target'. Returns 0 if no radio connection, 1 otherwise
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = command
	signal.data["tag"] = target
	signal.data["sigtype"] = "command"

	radio_connection.post_signal(src, signal, RADIO_FROM_AIRALARM)
// world << text("Signal [] Broadcasted to []", command, target)

	return 1

/obj/structure/machinery/alarm/proc/apply_mode()
	//propagate mode to other air alarms in the area
	//TODO: make it so that players can choose between applying the new mode to the room they are in (related area) vs the entire alarm area
	for (var/obj/structure/machinery/alarm/AA in alarm_area)
		AA.mode = mode

	switch(mode)
		if(AALARM_MODE_SCRUBBING)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "co2_scrub"= 1, "scrubbing"= 1, "panic_siphon"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_PANIC, AALARM_MODE_CYCLE)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 0) )

		if(AALARM_MODE_REPLACEMENT)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_FILL)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_OFF)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 0) )

/obj/structure/machinery/alarm/proc/apply_danger_level(new_danger_level)
	if (apply_danger_level && alarm_area.atmosalert(new_danger_level))
		post_alert(new_danger_level)

	update_icon()

/obj/structure/machinery/alarm/proc/post_alert(alert_level)
	if(!post_alert)
		return

	var/datum/radio_frequency/frequency = SSradio.return_frequency(alarm_frequency)
	if(!frequency)
		return

	var/datum/signal/alert_signal = new
	alert_signal.source = src
	alert_signal.transmission_method = 1
	alert_signal.data["zone"] = alarm_area.name
	alert_signal.data["type"] = "Atmospheric"

	if(alert_level==2)
		alert_signal.data["alert"] = "severe"
	else if (alert_level==1)
		alert_signal.data["alert"] = "minor"
	else if (alert_level==0)
		alert_signal.data["alert"] = "clear"

	frequency.post_signal(src, alert_signal)


///////////
//HACKING//
///////////
/obj/structure/machinery/alarm/proc/isWireColorCut(wireColor)
	var/wireFlag = GLOB.AAlarmWireColorToFlag[wireColor]
	return ((AAlarmwires & wireFlag) == 0)

/obj/structure/machinery/alarm/proc/isWireCut(wireIndex)
	var/wireFlag = GLOB.AAlarmIndexToFlag[wireIndex]
	return ((AAlarmwires & wireFlag) == 0)

/obj/structure/machinery/alarm/proc/allWiresCut()
	var/i = 1
	while(i<=5)
		if(AAlarmwires & GLOB.AAlarmIndexToFlag[i])
			return 0
		i++
	return 1

/obj/structure/machinery/alarm/proc/cut(wireColor)
	var/wireFlag = GLOB.AAlarmWireColorToFlag[wireColor]
	var/wireIndex = GLOB.AAlarmWireColorToIndex[wireColor]
	AAlarmwires &= ~wireFlag
	switch(wireIndex)
		if(AALARM_WIRE_IDSCAN)
			locked = 1

		if(AALARM_WIRE_POWER)
			shock(usr, 50)
			shorted = 1
			update_icon()

		if (AALARM_WIRE_AI_CONTROL)
			if (aidisabled == 0)
				aidisabled = 1

		if(AALARM_WIRE_SYPHON)
			mode = AALARM_MODE_PANIC
			apply_mode()

		if(AALARM_WIRE_AALARM)

			if (alarm_area.atmosalert(2))
				apply_danger_level(2)
			addtimer(CALLBACK(src, PROC_REF(updateUsrDialog)), 1)
			update_icon()

	updateDialog()

	return

/obj/structure/machinery/alarm/proc/mend(wireColor)
	var/wireFlag = GLOB.AAlarmWireColorToFlag[wireColor]
	var/wireIndex = GLOB.AAlarmWireColorToIndex[wireColor] //not used in this function
	AAlarmwires |= wireFlag
	switch(wireIndex)
		if(AALARM_WIRE_POWER)
			shorted = 0
			shock(usr, 50)
			update_icon()

		if(AALARM_WIRE_AI_CONTROL)
			if (aidisabled == 1)
				aidisabled = 0

	updateDialog()
	return

/obj/structure/machinery/alarm/proc/pulse(wireColor)
	//var/wireFlag = AAlarmWireColorToFlag[wireColor] //not used in this function
	var/wireIndex = GLOB.AAlarmWireColorToIndex[wireColor]
	switch(wireIndex)
		if(AALARM_WIRE_IDSCAN) //unlocks for 30 seconds, if you have a better way to hack I'm all ears
			locked = 0
			spawn(30 SECONDS)
				locked = 1

		if (AALARM_WIRE_POWER)
			if(shorted == 0)
				shorted = 1
				update_icon()

			spawn(1200)
				if(shorted == 1)
					shorted = 0
					update_icon()


		if (AALARM_WIRE_AI_CONTROL)
			if (aidisabled == 0)
				aidisabled = 1
			updateDialog()
			spawn(10)
				if (aidisabled == 1)
					aidisabled = 0
				updateDialog()

		if(AALARM_WIRE_SYPHON)
			mode = AALARM_MODE_REPLACEMENT
			apply_mode()

		if(AALARM_WIRE_AALARM)
			if (alarm_area.atmosalert(0))
				apply_danger_level(0)
			addtimer(CALLBACK(src, PROC_REF(updateUsrDialog)), 1)
			update_icon()

	updateDialog()
	return

///////////////
//END HACKING//
///////////////

/obj/structure/machinery/alarm/attack_remote(mob/user)
	return interact(user)

/obj/structure/machinery/alarm/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	return interact(user)

/obj/structure/machinery/alarm/interact(mob/user)
	user.set_interaction(src)

	if(buildstage!=2)
		return

	if ( (get_dist(src, user) > 1 ))
		if (!isRemoteControlling(user))
			user.unset_interaction()
			close_browser(user, "air_alarm")
			close_browser(user, "AAlarmwires")
			return


		else if (isRemoteControlling(user) && aidisabled)
			to_chat(user, "此空气警报界面的人工智能控制已禁用。")
			close_browser(user, "air_alarm")
			return

	if(wiresexposed && (!isRemoteControlling(user)))
		var/t1 = text("<html><head><title>[alarm_area.name]空气警报器线路</title></head><body><B>检修面板</B><br>\n")
		var/list/wirecolors = list(
			"Orange" = 1,
			"Dark red" = 2,
			"White" = 3,
			"Yellow" = 4,
			"Black" = 5,
		)
		for(var/wiredesc in wirecolors)
			var/is_uncut = AAlarmwires & GLOB.AAlarmWireColorToFlag[wirecolors[wiredesc]]
			t1 += "[list("Orange" = "橙色", "Dark red" = "暗红色", "White" = "白色", "Yellow" = "黄色", "Black" = "黑色")[wiredesc]]电线："
			if(!is_uncut)
				t1 += "<a href='byond://?src=\ref[src];AAlarmwires=[wirecolors[wiredesc]]'>接线</a>"

			else
				t1 += "<a href='byond://?src=\ref[src];AAlarmwires=[wirecolors[wiredesc]]'>剪断</a> "
				t1 += "<a href='byond://?src=\ref[src];pulse=[wirecolors[wiredesc]]'>脉冲</a> "

			t1 += "<br>"
		t1 += text("<br>\n[(locked ? "空气警报器已锁定。" : "空气警报器已解锁。")]<br>\n[((shorted || (inoperable())) ? "空气警报器已离线。" : "空气警报器运行正常！")]<br>\n[(aidisabled ? "“允许人工智能控制”指示灯已熄灭。" : "“允许人工智能控制”指示灯已亮起。")]")
		t1 += text("<p><a href='byond://?src=\ref[src];close2=1'>关闭</a></p></body></html>")
		show_browser(user, t1, name, "AAlarmwires")

	if(!shorted)
		show_browser(user, return_text(user), name, "air_alarm")

	return

/obj/structure/machinery/alarm/proc/return_text(mob/user)
	if(!(isRemoteControlling(user)) && locked)
		return "<html><head><title>\The [src]</title></head><body>[return_status()]<hr>[rcon_text()]<hr><i>（刷身份卡以解锁界面）</i></body></html>"
	else
		return "<html><head><title>\The [src]</title></head><body>[return_status()]<hr>[rcon_text()]<hr>[return_controls()]</body></html>"

/obj/structure/machinery/alarm/proc/return_status()
	var/turf/location = get_turf(src)

	var/output = "<b>空气状态：</b><br>"


	output += {"
<style>
.dl0 { color: green; }
.dl1 { color: orange; }
.dl2 { color: red; font-weght: bold;}
</style>
"}


	var/list/current_settings = TLV["pressure"]
	var/environment_pressure = location.return_pressure()
	var/pressure_dangerlevel = get_danger_level(environment_pressure, current_settings)

	current_settings = TLV["temperature"]
	var/environment_temperature = location.return_temperature()
	var/temperature_dangerlevel = get_danger_level(environment_temperature, current_settings)

	output += {"
气压：<span class='dl[pressure_dangerlevel]'>[environment_pressure]</span>kPa<br>
"}

	output += "温度：<span class='dl[temperature_dangerlevel]'>[environment_temperature]</span>K ([round(environment_temperature - T0C, 0.1)]C)<br>"

	//'Local Status' should report the LOCAL status, damnit.
	output += "本地状态："
	switch(max(pressure_dangerlevel,oxygen_dangerlevel,co2_dangerlevel,phoron_dangerlevel,other_dangerlevel,temperature_dangerlevel))
		if(2)
			output += "<span class='dl2'>危险：必须使用内部供气</span><br>"
		if(1)
			output += "<span class='dl1'>注意</span><br>"
		if(0)
			output += "<span class='dl0'>正常</span><br>"

	output += "区域状态："
	if(alarm_area.atmosalm)
		output += SPAN_DL1("区域内有大气警报")
	else if (alarm_area.flags_alarm_state & ALARM_WARNING_FIRE)
		output += SPAN_DL1("区域内有火灾警报")
	else
		output += "无警报"

	return output

/obj/structure/machinery/alarm/proc/rcon_text()
	var/dat = "<table width=\"100%\"><td align=\"center\"><b>远程控制：</b><br>"
	if(rcon_setting == RCON_NO)
		dat += "<b>关闭</b>"
	else
		dat += "<a href='byond://?src=\ref[src];rcon=[RCON_NO]'>关闭</a>"
	dat += "|"
	if(rcon_setting == RCON_AUTO)
		dat += "<b>自动</b>"
	else
		dat += "<a href='byond://?src=\ref[src];rcon=[RCON_AUTO]'>自动</a>"
	dat += "|"
	if(rcon_setting == RCON_YES)
		dat += "<b>开启</b>"
	else
		dat += "<a href='byond://?src=\ref[src];rcon=[RCON_YES]'>开启</a></td>"

	//Hackish, I know.  I didn't feel like bothering to rework all of this.
	dat += "<td align=\"center\"><b>恒温器：</b><br><a href='byond://?src=\ref[src];temperature=1'>[target_temperature - T0C]C</a></td></table>"

	return dat

/obj/structure/machinery/alarm/proc/return_controls()
	var/output = ""//"<B>[alarm_zone] Air [name]</B><HR>"

	switch(screen)
		if (AALARM_SCREEN_MAIN)
			if(alarm_area.atmosalm)
				output += "<a href='byond://?src=\ref[src];atmos_reset=1'>重置区域大气警报</a><hr>"
			else
				output += "<a href='byond://?src=\ref[src];atmos_alarm=1'>启动区域大气警报</a><hr>"

			output += {"
<a href='byond://?src=\ref[src];screen=[AALARM_SCREEN_SCRUB]'>洗涤器控制</a><br>
<a href='byond://?src=\ref[src];screen=[AALARM_SCREEN_VENT]'>通风口控制</a><br>
<a href='byond://?src=\ref[src];screen=[AALARM_SCREEN_MODE]'>设置环境控制模式</a><br>
<a href='byond://?src=\ref[src];screen=[AALARM_SCREEN_SENSORS]'>传感器设置</a><br>
<HR>
"}
			if (mode==AALARM_MODE_PANIC)
				output += "[SET_CLASS("<B>紧急抽气已启用</B>", INTERFACE_RED)]<br><A href='byond://?src=\ref[src];mode=[AALARM_MODE_SCRUBBING]'>停止抽气</A>"
			else
				output += "<A href='byond://?src=\ref[src];mode=[AALARM_MODE_PANIC]'>[SET_CLASS("启用区域紧急抽气", INTERFACE_RED)]</A>"


		if (AALARM_SCREEN_VENT)
			var/sensor_data = ""
			if(length(alarm_area.air_vent_names))
				for(var/id_tag in alarm_area.air_vent_names)
					var/long_name = alarm_area.air_vent_names[id_tag]
					var/list/data = alarm_area.air_vent_info[id_tag]
					if(!data)
						continue;
					var/state = ""

					sensor_data += {"
<B>[long_name]</B>[state]<BR>
<B>运行状态：</B>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=power;val=[!data["power"]]'>[data["power"]?"开启":"关闭"]</A>
<BR>
<B>气压检查：</B>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=checks;val=[data["checks"]^1]' [(data["checks"]&1)?"style='font-weight:bold;'":""]>外部</A>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=checks;val=[data["checks"]^2]' [(data["checks"]&2)?"style='font-weight:bold;'":""]>内部</A>
<BR>
<B>外部气压限值：</B>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=-1000'>-</A>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=-100'>-</A>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=-10'>-</A>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=-1'>-</A>
[data["external"]]
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=+1'>+</A>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=+10'>+</A>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=+100'>+</A>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=+1000'>+</A>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=set_external_pressure;val=[ONE_ATMOSPHERE]'>（重置）</A>
<BR>
"}
					if (data["direction"] == "siphon")
						sensor_data += {"
<B>方向：</B>
抽气
<BR>
"}
					sensor_data += {"<HR>"}
			else
				sensor_data = "没有连接的通风口。<BR>"
			output = {"<a href='byond://?src=\ref[src];screen=[AALARM_SCREEN_MAIN]'>主菜单</a><br>[sensor_data]"}
		if (AALARM_SCREEN_SCRUB)
			var/sensor_data = ""
			if(length(alarm_area.air_scrub_names))
				for(var/id_tag in alarm_area.air_scrub_names)
					var/long_name = alarm_area.air_scrub_names[id_tag]
					var/list/data = alarm_area.air_scrub_info[id_tag]
					if(!data)
						continue;
					var/state = ""

					sensor_data += {"
<B>[long_name]</B>[state]<BR>
<B>运行状态：</B>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=power;val=[!data["power"]]'>[data["power"]?"开启":"关闭"]</A><BR>
<B>类型：</B>
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=scrubbing;val=[!data["scrubbing"]]'>[data["scrubbing"]?"过滤":"抽气"]</A><BR>
"}

					if(data["scrubbing"])
						sensor_data += {"
<B>过滤：</B>
二氧化碳
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=co2_scrub;val=[!data["filter_co2"]]'>[data["filter_co2"]?"开启":"关闭"]</A>;
毒素
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=tox_scrub;val=[!data["filter_phoron"]]'>[data["filter_phoron"]?"开启":"关闭"]</A>;
一氧化二氮
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=n2o_scrub;val=[!data["filter_n2o"]]'>[data["filter_n2o"]?"开启":"关闭"]</A>
<BR>
"}
					sensor_data += {"
<B>紧急抽气：</B> [data["panic"] ? "[SET_CLASS("<B>紧急抽气已启用</B>", INTERFACE_RED)]" : ""]
<A href='byond://?src=\ref[src];id_tag=[id_tag];command=panic_siphon;val=[!data["panic"]]'>[data["panic"] ? "[SET_CLASS("停用", INTERFACE_BLUE)]" : "[SET_CLASS("启用", INTERFACE_RED)]"]</A><BR>
<HR>
"}
			else
				sensor_data = "没有连接的空气洗涤器。<BR>"
			output = {"<a href='byond://?src=\ref[src];screen=[AALARM_SCREEN_MAIN]'>主菜单</a><br>[sensor_data]"}

		if (AALARM_SCREEN_MODE)
			output += "<a href='byond://?src=\ref[src];screen=[AALARM_SCREEN_MAIN]'>主菜单</a><br><b>区域空气处理设备模式：</b><ul>"
			for (var/m=1,m<=length(GLOB.aalarm_mode_descriptions),m++)
				if (mode==m)
					output += "<li><A href='byond://?src=\ref[src];mode=[m]'><b>[GLOB.aalarm_mode_descriptions[m]]</b></A>（已选择）</li>"
				else
					output += "<li><A href='byond://?src=\ref[src];mode=[m]'>[GLOB.aalarm_mode_descriptions[m]]</A></li>"
			output += "</ul>"

		if (AALARM_SCREEN_SENSORS)
			output += {"
<a href='byond://?src=\ref[src];screen=[AALARM_SCREEN_MAIN]'>主菜单</a><br>
<b>警报阈值：</b><br>
气体使用分压数值
<style>/* some CSS woodoo here. Does not work perfect in ie6 but who cares? */
table td { border-left: 1px solid black; border-top: 1px solid black;}
table tr:first-child th { border-left: 1px solid black;}
table th:first-child { border-top: 1px solid black; font-weight: normal;}
table tr:first-child th:first-child { border: none;}
.dl0 { color: green; }
.dl1 { color: orange; }
.dl2 { color: red; font-weght: bold;}
</style>
<table cellspacing=0>
<TR><th></th><th class=dl2>极低下限</th><th class=dl1>低值预警</th><th class=dl1>高值预警</th><th class=dl2>极高上限</th></TR>
"}
			var/list/gases = list(
				"oxygen"  = "O<sub>2</sub>",
				"carbon dioxide" = "CO<sub>2</sub>",
				"phoron"  = "弗燃素",
				"other"   = "其他气体",)

			var/list/selected
			for (var/g in gases)
				output += "<TR><th>[gases[g]]</th>"
				selected = TLV[g]
				for(var/i = 1, i <= 4, i++)
					output += "<td><A href='byond://?src=\ref[src];command=set_threshold;env=[g];var=[i]'>[selected[i] >= 0 ? selected[i] :"关闭"]</A></td>"
				output += "</TR>"

			selected = TLV["pressure"]
			output += " <TR><th>气压</th>"
			for(var/i = 1, i <= 4, i++)
				output += "<td><A href='byond://?src=\ref[src];command=set_threshold;env=pressure;var=[i]'>[selected[i] >= 0 ? selected[i] :"关闭"]</A></td>"
			output += "</TR>"

			selected = TLV["temperature"]
			output += "<TR><th>温度</th>"
			for(var/i = 1, i <= 4, i++)
				output += "<td><A href='byond://?src=\ref[src];command=set_threshold;env=temperature;var=[i]'>[selected[i] >= 0 ? selected[i] :"关闭"]</A></td>"
			output += "</TR></table>"

	return output

/obj/structure/machinery/alarm/Topic(href, href_list)
	if(..() || !( Adjacent(usr) || isRemoteControlling(usr)) ) // dont forget calling super in machine Topics -walter0o
		usr.unset_interaction()
		close_browser(usr, "air_alarm")
		close_browser(usr, "AAlarmwires")
		return

	add_fingerprint(usr)
	usr.set_interaction(src)

	// hrefs that can always be called -walter0o
	if(href_list["rcon"])
		var/attempted_rcon_setting = text2num(href_list["rcon"])

		switch(attempted_rcon_setting)
			if(RCON_NO)
				rcon_setting = RCON_NO
			if(RCON_AUTO)
				rcon_setting = RCON_AUTO
			if(RCON_YES)
				rcon_setting = RCON_YES
			else
				return

	if(href_list["temperature"])
		var/list/selected = TLV["temperature"]
		var/max_temperature = min(selected[3] - T0C, MAX_TEMPERATURE)
		var/min_temperature = max(selected[2] - T0C, MIN_TEMPERATURE)
		var/input_temperature = tgui_input_number(usr, "你希望系统维持多少摄氏度？（范围为 [min_temperature]°C 至 [max_temperature]°C）", "恒温器控制", min_temperature, max_temperature, min_temperature)
		if(!input_temperature || input_temperature > max_temperature || input_temperature < min_temperature)
			to_chat(usr, "温度必须在[min_temperature]℃至[max_temperature]℃之间。")
		else
			target_temperature = input_temperature + T0C

	// hrefs that need the AA unlocked -walter0o
	if(!locked || isRemoteControlling(usr))

		if(href_list["command"])
			var/device_id = href_list["id_tag"]
			switch(href_list["command"])
				if( "power",
					"adjust_external_pressure",
					"set_external_pressure",
					"checks",
					"co2_scrub",
					"tox_scrub",
					"n2o_scrub",
					"panic_siphon",
					"scrubbing")

					send_signal(device_id, list(href_list["command"] = text2num(href_list["val"]) ) )

				if("set_threshold")
					var/env = href_list["env"]
					var/threshold = text2num(href_list["var"])
					var/list/selected = TLV[env]
					var/list/thresholds = list("下限", "低值预警", "高值预警", "上限")
					var/newval = tgui_input_real_number(usr, "请输入[list("oxygen" = "氧气", "carbon dioxide" = "二氧化碳", "phoron" = "弗燃素", "other" = "其他气体", "pressure" = "气压", "temperature" = "温度")[env] || env]的[thresholds[threshold]]", "警报触发阈值", selected[threshold])
					if (isnull(newval) || ..() || (locked && !isRemoteControlling(usr)))
						return
					if (newval<0)
						selected[threshold] = -1
					else if (env=="temperature" && newval>5000)
						selected[threshold] = 5000
					else if (env=="pressure" && newval>50*ONE_ATMOSPHERE)
						selected[threshold] = 50*ONE_ATMOSPHERE
					else if (env!="temperature" && env!="pressure" && newval>200)
						selected[threshold] = 200
					else
						newval = round(newval,0.01)
						selected[threshold] = newval
					if(threshold == 1)
						if(selected[1] > selected[2])
							selected[2] = selected[1]
						if(selected[1] > selected[3])
							selected[3] = selected[1]
						if(selected[1] > selected[4])
							selected[4] = selected[1]
					if(threshold == 2)
						if(selected[1] > selected[2])
							selected[1] = selected[2]
						if(selected[2] > selected[3])
							selected[3] = selected[2]
						if(selected[2] > selected[4])
							selected[4] = selected[2]
					if(threshold == 3)
						if(selected[1] > selected[3])
							selected[1] = selected[3]
						if(selected[2] > selected[3])
							selected[2] = selected[3]
						if(selected[3] > selected[4])
							selected[4] = selected[3]
					if(threshold == 4)
						if(selected[1] > selected[4])
							selected[1] = selected[4]
						if(selected[2] > selected[4])
							selected[2] = selected[4]
						if(selected[3] > selected[4])
							selected[3] = selected[4]

					apply_mode()

		if(href_list["screen"])
			screen = text2num(href_list["screen"])

		if(href_list["atmos_unlock"])
			switch(href_list["atmos_unlock"])
				if("0")
					alarm_area.air_doors_close()
				if("1")
					alarm_area.air_doors_open()

		if(href_list["atmos_alarm"])
			if (alarm_area.atmosalert(2))
				apply_danger_level(2)
			update_icon()

		if(href_list["atmos_reset"])
			if (alarm_area.atmosalert(0))
				apply_danger_level(0)
			update_icon()

		if(href_list["mode"])
			mode = text2num(href_list["mode"])
			apply_mode()

	// hrefs that need the AA wires exposed, note that borgs should be in range here too -walter0o
	if(wiresexposed && Adjacent(usr))

		if (href_list["AAlarmwires"])
			var/t1 = text2num(href_list["AAlarmwires"])
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(usr, SPAN_WARNING("你需要剪线钳！"))
				return
			if (isWireColorCut(t1))
				mend(t1)
			else
				cut(t1)
				if (AAlarmwires == 0)
					to_chat(usr, SPAN_NOTICE("你剪断了[src]内部最后几根电线。"))
					update_icon()
					buildstage = 1
				return

		else if (href_list["pulse"])
			var/t1 = text2num(href_list["pulse"])
			var/obj/item/held_item = usr.get_held_item()
			if (held_item && !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
				to_chat(usr, SPAN_WARNING("你需要多功能工具！"))
				return
			if (isWireColorCut(t1))
				to_chat(usr, SPAN_WARNING("你无法向已剪断的电线发送脉冲。"))
				return
			else
				pulse(t1)

	updateUsrDialog()


/obj/structure/machinery/alarm/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	switch(buildstage)
		if(2)
			if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))  // Opening that Air Alarm up.
				//to_chat(user, "You pop the Air Alarm's maintence panel open.")
				wiresexposed = !wiresexposed
				to_chat(user, "线路已被[wiresexposed ? "暴露出来" : "遮住"]。")
				update_icon()
				return

			if(wiresexposed && (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL) || HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS)))
				return attack_hand(user)

			if(istype(W, /obj/item/card/id))// trying to unlock the interface with an ID card
				if(inoperable())
					to_chat(user, "没有任何效果。")
					return
				else
					if(allowed(usr) && !isWireCut(AALARM_WIRE_IDSCAN))
						locked = !locked
						to_chat(user, SPAN_NOTICE(" 你[locked ? "锁定" : "解锁"]了空气警报界面。"))
						updateUsrDialog()
					else
						to_chat(user, SPAN_DANGER("访问被拒绝。"))
			return

		if(1)
			if(iscoil(W))
				var/obj/item/stack/cable_coil/C = W
				if(C.use(5))
					to_chat(user, SPAN_NOTICE("你为[src]接好了线。"))
					buildstage = 2
					update_icon()
					first_run()
					return
				else
					to_chat(user, SPAN_WARNING("为[src]接线需要5段电缆。"))
					return

			else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
				user.visible_message(SPAN_NOTICE("[user]开始从[src]中撬出电路板。"),
				SPAN_NOTICE("你开始从[src]中撬出电路板。"))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				if(do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					user.visible_message(SPAN_NOTICE("[user]从[src]中撬出了电路板。"),
					SPAN_NOTICE("你从[src]中撬出了电路板。"))
					var/obj/item/circuitboard/airalarm/circuit = new()
					circuit.forceMove(user.loc)
					buildstage = 0
					update_icon()
				return
		if(0)
			if(istype(W, /obj/item/circuitboard/airalarm))
				to_chat(user, "你装入了电路板！")
				qdel(W)
				buildstage = 1
				update_icon()
				return

			else if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
				to_chat(user, "你从墙上拆下了空气警报器框架！")
				var/obj/item/frame/air_alarm/frame = new /obj/item/frame/air_alarm()
				frame.forceMove(user.loc)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				qdel(src)

	return ..()

/obj/structure/machinery/alarm/get_examine_text(mob/user)
	. = ..()
	if (buildstage < 2)
		. += "尚未接线。"
	if (buildstage < 1)
		. += "缺少电路板。"




/obj/structure/machinery/alarm/monitor
	apply_danger_level = 0
	breach_detection = 0
	post_alert = 0

/obj/structure/machinery/alarm/server/Initialize()
	. = ..()
	req_one_access = list(ACCESS_CIVILIAN_ENGINEERING)
	TLV["oxygen"] = list(-1.0, -1.0,-1.0,-1.0) // Partial pressure, kpa
	TLV["carbon dioxide"] = list(-1.0, -1.0,   5,  10) // Partial pressure, kpa
	TLV["phoron"] = list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["other"] = list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] = list(0,ONE_ATMOSPHERE*0.10,ONE_ATMOSPHERE*1.40,ONE_ATMOSPHERE*1.60) /* kpa */
	TLV["temperature"] = list(20, 40, 140, 160) // K
	target_temperature = 90


//Almayer version
/obj/structure/machinery/alarm/almayer


