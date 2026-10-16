// Door open and close constants
#define FIREDOOR_MAX_PRESSURE_DIFF 25 // kPa
#define FIREDOOR_MAX_TEMP 50 // °C
#define FIREDOOR_MIN_TEMP 0

// Bitflags
#define FIREDOOR_ALERT_HOT   1
#define FIREDOOR_ALERT_COLD  2


/obj/structure/machinery/door/firedoor
	name = "\improper 应急闸门"
	desc = "能封闭破损区域的应急气密闸门。"
	icon = 'icons/obj/structures/doors/DoorHazard.dmi'
	icon_state = "door_open"
	req_one_access = list(ACCESS_CIVILIAN_ENGINEERING)
	opacity = FALSE
	density = FALSE
	layer = FIREDOOR_OPEN_LAYER
	open_layer = FIREDOOR_OPEN_LAYER // Just below doors when open
	closed_layer = FIREDOOR_CLOSED_LAYER // Just above doors when closed
	power_channel = POWER_CHANNEL_ENVIRON
	use_power = USE_POWER_IDLE
	idle_power_usage = 5

	var/blocked = 0
	var/lockdown = 0 // When the door has detected a problem, it locks.
	var/pdiff_alert = 0
	var/pdiff = 0
	var/nextstate = null
	var/net_id
	var/list/areas_added
	var/list/users_to_open = new
	var/next_process_time = 0

	var/list/tile_info[4]
	var/list/dir_alerts[4] // 4 dirs, bitflags

	// MUST be in same order as FIREDOOR_ALERT_*
	var/list/ALERT_STATES=list(
		"hot",
		"cold"
	)

/obj/structure/machinery/door/firedoor/Initialize()
	. = ..()
	for(var/obj/structure/machinery/door/firedoor/F in loc)
		if(F != src)
			QDEL_IN(src, 1)
			return .
	var/area/A = get_area(src)
	ASSERT(istype(A))

	A.all_doors.Add(src)
	areas_added = list(A)

	for(var/direction in GLOB.cardinals)
		A = get_area(get_step(src,direction))
		if(istype(A) && !(A in areas_added))
			A.all_doors.Add(src)
			areas_added += A

/obj/structure/machinery/door/firedoor/Destroy()
	for(var/area/A in areas_added)
		A.all_doors.Remove(src)
	return ..()


/obj/structure/machinery/door/firedoor/get_examine_text(mob/user)
	. = ..()
	if(get_dist(src, user) > 1 && !isRemoteControlling(user))
		return

	if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
		. += SPAN_WARNING("警告：当前压差为[pdiff] kPa！开门可能导致受伤！")

	. += "<b>传感器读数：</b>"
	for(var/index = 1; index <= length(tile_info); index++)
		var/o = "&nbsp;&nbsp;"
		switch(index)
			if(1)
				o += "北侧："
			if(2)
				o += "南侧："
			if(3)
				o += "东侧："
			if(4)
				o += "西侧："
		if(tile_info[index] == null)
			o += SPAN_WARNING("无可用数据")
			. += o
			continue
		var/celsius = convert_k2c(tile_info[index][1])
		var/pressure = tile_info[index][2]
		if(dir_alerts[index] & (FIREDOOR_ALERT_HOT|FIREDOOR_ALERT_COLD))
			o += "<span class='warning'>"
		else
			o += "<span style='color:blue'>"
		o += "[celsius]&deg;C</span> "
		o += "<span style='color:blue'>"
		o += "[pressure]kPa</span></li>"
		. += o

	if(islist(users_to_open) && length(users_to_open))
		var/users_to_open_string = users_to_open[1]
		if(length(users_to_open) >= 2)
			for(var/i = 2 to length(users_to_open))
				users_to_open_string += ", [users_to_open[i]]"
		. += "以下人员曾在警报期间打开[src]：[users_to_open_string]。"

/obj/structure/machinery/door/firedoor/Collided(atom/movable/AM)
	if(panel_open || operating)
		return
	if(!density)
		return ..()
	return 0

/obj/structure/machinery/door/firedoor/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.

	if(blocked)
		to_chat(user, SPAN_WARNING("[src]已被焊死！"))
		return

	var/alarmed = lockdown
	for(var/area/A in areas_added) //Checks if there are fire alarms in any areas associated with that firedoor
		if(A.flags_alarm_state & ALARM_WARNING_FIRE || A.air_doors_activated)
			alarmed = 1
	if(tgui_alert(user,\
	"要[density ? "打开" : "关闭"][src.name]吗？[ alarmed && density ? "\n注意：此举表示你承认打开[src.name]造成的任何损害均由你负责，并将承担相应法律责任。" : ""]",\
	"[src]", list("是", "否")) != "是")
		return
	if(user.is_mob_incapacitated() || (get_dist(src, user) > 1  && !isRemoteControlling(user)))
		to_chat(user, "使用[src]时，你必须保持行动能力并留在它附近。")
		return
	if(density && (inoperable())) //can still close without power
		to_chat(user, "[src]无法运作，你得手动强行打开。")
		return

	if(alarmed && density && lockdown && !allowed(user))
		to_chat(user, SPAN_WARNING("拒绝访问。请等待负责人员到场或警报解除。"))
		return
	else
		user.visible_message(SPAN_NOTICE("[src]为[user][density ? "打开" : "关闭"]了。"),\
		"[src][density ? "打开" : "关闭"]了。",\
		"你听见哔的一声，随后是开门声。")

	var/needs_to_close = 0
	if(density)
		if(alarmed)
			// Accountability!
			users_to_open |= user.name
			needs_to_close = 1
		INVOKE_ASYNC(src, PROC_REF(open), TRUE)
	else
		INVOKE_ASYNC(src, PROC_REF(close))

	if(needs_to_close)
		spawn(50)
			alarmed = 0
			for(var/area/A in areas_added) //Just in case a fire alarm is turned off while the firedoor is going through an autoclose cycle
				if(A.flags_alarm_state & ALARM_WARNING_FIRE || A.air_doors_activated)
					alarmed = 1
			if(alarmed)
				nextstate = CLOSED
				close()

/obj/structure/machinery/door/firedoor/attackby(obj/item/C as obj, mob/user as mob)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.
	if(iswelder(C))
		var/obj/item/tool/weldingtool/W = C
		if(W.remove_fuel(0, user))
			blocked = !blocked
			user.visible_message(SPAN_DANGER("[user]用[W][blocked ? "焊死" : "解除焊接固定"]了[src]。"),\
			"你用[W][blocked ? "焊死" : "解除焊接固定"]了[src]。",\
			"你听见焊接声。")
			update_icon()
			return

	else if(C.pry_capable)
		if(operating)
			return

		if(blocked)
			user.visible_message(SPAN_DANGER("[user]用[C]试图撬动[src]，但[src]已经被焊死！"),\
			"你试图将[src]撬[density ? "开" : "关上"]，但它已经被焊死！",\
			"你听见有人使劲撬动和金属受力的声音。")
			return

		user.visible_message(SPAN_DANGER("[user]开始用[C]强行将[src][density ? "打开" : "关上"]！"),\
				SPAN_NOTICE("你开始用[C]强行将[src][density ? "打开" : "关上"]！"),\
				"你听见金属受力的声音。")
		var/old_density = density
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			if(blocked || density != old_density) return
			user.visible_message(SPAN_DANGER("[user]用[C]强行将[blocked ? "焊死的" : "" ][name][density ? "打开" : "关上"]！"),\
				SPAN_NOTICE("你用[C]强行将[blocked ? "焊死的" : ""][name][density ? "打开" : "关上"]！"),\
				"你听见金属受力的呻吟和门[density ? "开启" : "关闭"]的声音。")
			spawn(0)
				if(density)
					open(TRUE)
				else
					close()
		return TRUE //no afterattack call
	else
		if(blocked)
			to_chat(user, SPAN_DANGER("[src]已被焊死！"))
			return
	if(istype(C, /obj/item/weapon/zombie_claws))
		if(operating)
			return
		user.visible_message(SPAN_DANGER("僵尸开始用爪子强行将[src][density ? "打开" : "关上"]！"),\
				"你开始用爪子强行将[src][density ? "打开" : "关上"]！",\
				"你听见金属受力的声音。")
		if(do_after(user, 150, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			user.visible_message(SPAN_DANGER("[user]用[C]强行将[ blocked ? "焊死的" : "" ][src][density ? "打开" : "关上"]！"),\
			"你用[C]强行将[ blocked ? "焊死的" : "" ][src][density ? "打开" : "关上"]！",\
			"你听见金属受力的呻吟和门[density ? "开启" : "关闭"]的声音。")
			if(density)
				INVOKE_ASYNC(src, PROC_REF(open), TRUE)
			else
				INVOKE_ASYNC(src, PROC_REF(close))
			return

/obj/structure/machinery/door/firedoor/try_to_activate_door(mob/user)
	return

/obj/structure/machinery/door/firedoor/proc/latetoggle()
	if(operating || !nextstate)
		return

	switch(nextstate)
		if(OPEN)
			nextstate = null
			open()
		if(CLOSED)
			nextstate = null
			close()
	return

/obj/structure/machinery/door/firedoor/close(forced = FALSE)
	latetoggle()
	return ..()

/obj/structure/machinery/door/firedoor/open(forced = FALSE)
	if(!forced)
		if(inoperable())
			return FALSE //needs power to open unless it was forced
		else
			use_power(360)
	latetoggle()
	return ..()

/obj/structure/machinery/door/firedoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("door_opening", src)
		if("closing")
			flick("door_closing", src)
	playsound(loc, 'sound/machines/emergency_shutter.ogg', 25)
	return


/obj/structure/machinery/door/firedoor/update_icon()
	overlays.Cut()
	if(density)
		icon_state = "door_closed"
		if(blocked)
			overlays += "welded"
		if(pdiff_alert)
			overlays += "palert"
		if(dir_alerts)
			for(var/d=1;d<=4;d++)
				var/cdir = GLOB.cardinals[d]
				for(var/i=1;i<=length(ALERT_STATES);i++)
					if(dir_alerts[d] & (1<<(i-1)))
						overlays += new/icon(icon,"alert_[ALERT_STATES[i]]", dir=cdir)
	else
		icon_state = "door_open"
		if(blocked)
			overlays += "welded_open"
	return


/obj/structure/machinery/door/firedoor/border_only


//ALMAYER FIRE DOOR

/obj/structure/machinery/door/firedoor/border_only/almayer
	name = "\improper 应急闸门"
	desc = "能封闭破损区域的应急气密闸门。"
	icon = 'icons/obj/structures/doors/purinadoor.dmi'
	openspeed = 4


/obj/structure/machinery/door/firedoor/multi_tile
	icon = 'icons/obj/structures/doors/DoorHazard2x1.dmi'
	width = 2

/obj/structure/machinery/door/firedoor/border_only/almayer/antag
	req_one_access = list(ACCESS_ILLEGAL_PIRATE)
