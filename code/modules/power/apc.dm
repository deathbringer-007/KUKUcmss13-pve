#define APC_WIRE_MAIN_POWER 1
#define APC_WIRE_IDSCAN 2

GLOBAL_LIST_INIT(apc_wire_descriptions, flatten_numeric_alist(alist(
		APC_WIRE_MAIN_POWER = "主电源",
		APC_WIRE_IDSCAN = "身份卡扫描器",
	)))

#define APC_COVER_CLOSED 0
#define APC_COVER_OPEN 1
#define APC_COVER_REMOVED 2

// APC charging status:
/// The APC is not charging.
#define APC_NOT_CHARGING 0
/// The APC is charging.
#define APC_CHARGING 1
/// The APC is fully charged.
#define APC_FULLY_CHARGED 2

//update_state
#define UPSTATE_CELL_IN 1
#define UPSTATE_OPENED1 2
#define UPSTATE_OPENED2 4
#define UPSTATE_MAINT 8
#define UPSTATE_BROKE 16
#define UPSTATE_BLUESCREEN 32
#define UPSTATE_WIREEXP 64
#define UPSTATE_ALLGOOD 128

//update_overlay
#define APC_UPOVERLAY_CHARGEING0 1
#define APC_UPOVERLAY_CHARGEING1 2
#define APC_UPOVERLAY_CHARGEING2 4
#define APC_UPOVERLAY_EQUIPMENT0 8
#define APC_UPOVERLAY_EQUIPMENT1 16
#define APC_UPOVERLAY_EQUIPMENT2 32
#define APC_UPOVERLAY_LIGHTING0 64
#define APC_UPOVERLAY_LIGHTING1 128
#define APC_UPOVERLAY_LIGHTING2 256
#define APC_UPOVERLAY_ENVIRON0 512
#define APC_UPOVERLAY_ENVIRON1 1024
#define APC_UPOVERLAY_ENVIRON2 2048
#define APC_UPOVERLAY_LOCKED 4096
#define APC_UPOVERLAY_OPERATING 8192

#define APC_UPDATE_ICON_COOLDOWN 100 //10 seconds


//The Area Power Controller (APC), formerly Power Distribution Unit (PDU)
//One per area, needs wire conection to power network

//Controls power to devices in that area
//May be opened to change power cell
//Three different channels (lighting/equipment/environ) - may each be set to on, off, or auto


//NOTE: STUFF STOLEN FROM AIRLOCK.DM thx
/obj/structure/machinery/power/apc
	name = "区域电力控制器"
	desc = "区域电力系统的控制终端。"
	icon = 'icons/obj/structures/machinery/apc.dmi'
	icon_state = "apc_mapicon"
	anchored = TRUE
	use_power = USE_POWER_NONE
	req_one_access = list(ACCESS_CIVILIAN_ENGINEERING, ACCESS_MARINE_ENGINEERING)
	unslashable = TRUE
	unacidable = TRUE

	var/area/area
	var/areastring = null

	var/obj/item/cell/cell
	var/start_charge = 90 //Initial cell charge %
	var/cell_type = /obj/item/cell/apc/empty //0 = no cell, 1 = regular, 2 = high-cap (x5) <- old, now it's just 0 = no cell, otherwise dictate cellcapacity by changing this value. 1 used to be 1000, 2 was 2500

	var/opened = APC_COVER_CLOSED
	var/shorted = 0
	var/lighting = 3
	var/equipment = 3
	var/environ = 3
	var/operating = 1
	var/charging = APC_NOT_CHARGING
	var/chargemode = 1
	var/chargecount = 0
	var/locked = 1
	var/coverlocked = 1
	var/aidisabled = 0
	var/obj/structure/machinery/power/terminal/terminal = null
	var/lastused_light = 0
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_oneoff = 0
	var/lastused_total = 0
	var/main_status = 0

	var/wiresexposed = 0
	var/apcwires = 3

	powernet = 0 //Set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(
	var/debug = 0
	var/autoflag = 0 // 0 = off, 1 = eqp and lights off, 2 = eqp off, 3 = all on.
	var/has_electronics = 0 // 0 - none, 1 - plugged in, 2 - secured by screwdriver
	var/overload = 1 //Used for the Blackout malf module
	var/beenhit = 0 //Used for counting how many times it has been hit, used for Aliens at the moment
	var/longtermpower = 10
	var/update_state = -1
	var/update_overlay = -1
	var/global/status_overlays = 0
	var/updating_icon = 0
	var/crash_break_probability = 85 //Probability of APC being broken by a shuttle crash on the same z-level

	var/global/list/status_overlays_lock
	var/global/list/status_overlays_charging
	var/global/list/status_overlays_equipment
	var/global/list/status_overlays_lighting
	var/global/list/status_overlays_environ

	var/printout = FALSE
	power_machine = TRUE
	light_range = 1
	light_power = 0.5

	appearance_flags = TILE_BOUND

/obj/structure/machinery/power/apc/Initialize(mapload, ndir, building=0)
	. = ..()

	//Offset apc depending on the dir
	//This allows the APC to be embedded in a wall, yet still inside an area

	if(building)
		setDir(ndir)

	switch(dir)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -26
		if(EAST)
			pixel_x = 30
			pixel_y = 6
		if(WEST)
			pixel_x = -30
			pixel_y = 6

	if(building == 0)
		init()
	else
		area = get_area(src)
		opened = APC_COVER_OPEN
		operating = 0
		name = "\improper [area.name]区域电力控制器"
		stat |= MAINT
		update_icon()
		addtimer(CALLBACK(src, PROC_REF(update)), 5)

	start_processing()

	if(!start_charge && is_ground_level(z) && prob(10))
		set_broken()

/obj/structure/machinery/power/apc/Destroy()
	area.power_light = 0
	area.power_equip = 0
	area.power_environ = 0
	area.power_change()

	if(terminal)
		terminal.master = null
		terminal = null
	QDEL_NULL(cell)
	area = null
	return ..()


// TGUI SHIT \\

/obj/structure/machinery/power/apc/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		if(!opened && wiresexposed)
			ui = new(user, src, "Wires", "[name]线路")
			ui.open()
		else
			ui = new(user, src, "Apc", name)
			ui.open()

/obj/structure/machinery/power/apc/ui_status(mob/user)
	. = ..()
	if(opened || !can_use(user, TRUE))
		return UI_DISABLED

/obj/structure/machinery/power/apc/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/power/apc/ui_static_data(mob/user)
	. = list()
	.["wire_descs"] = GLOB.apc_wire_descriptions

/obj/structure/machinery/power/apc/ui_data(mob/user)
	var/list/data = list(
		"locked" = locked,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = display_power(lastused_total),
		"coverLocked" = coverlocked,
		"siliconUser" = FALSE,

		"powerChannels" = list(
			list(
				"title" = "Equipment",
				"powerLoad" = display_power(lastused_equip),
				"status" = equipment,
				"topicParams" = list(
					"auto" = list("eqp" = 3),
					"on" = list("eqp" = 2),
					"off" = list("eqp" = 1),
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = display_power(lastused_light),
				"status" = lighting,
				"topicParams" = list(
					"auto" = list("lgt" = 3),
					"on" = list("lgt" = 2),
					"off" = list("lgt" = 1),
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = display_power(lastused_environ),
				"status" = environ,
				"topicParams" = list(
					"auto" = list("env" = 3),
					"on" = list("env" = 2),
					"off" = list("env" = 1),
				)
			)
		)
	)

	var/list/payload = list()

	for(var/wire in 1 to length(GLOB.apc_wire_descriptions))
		payload.Add(list(list(
			"number" = wire,
			"cut" = isWireCut(wire),
		)))
	data["wires"] = payload
	data["proper_name"] = name

	return data

/obj/structure/machinery/power/apc/ui_act(action, params)
	. = ..()

	if(. || !can_use(usr, 1))
		return
	var/target_wire = params["wire"]
	if(locked && !target_wire) //wire cutting etc does not require the apc to be unlocked
		to_chat(usr, SPAN_WARNING("[src]锁着！刷身份卡或狗牌即可解锁。"))
		return
	add_fingerprint(usr)
	switch(action)
		if("lock")
			locked = !locked
			update_icon()
			. = TRUE
		if("cover")
			coverlocked = !coverlocked
			. = TRUE
		if("breaker")
			toggle_breaker(usr)
			. = TRUE
		if("charge")
			chargemode = !chargemode
			if(!chargemode)
				charging = APC_NOT_CHARGING
				update_icon()
			. = TRUE
		if("channel")
			if(params["eqp"])
				var/val = text2num(params["eqp"])
				equipment = (val == 1) ? 0 : val
				update_icon()
				update()
			else if(params["lgt"])
				var/val = text2num(params["lgt"])
				lighting = (val == 1) ? 0 : val
				update_icon()
				update()
			else if(params["env"])
				var/val = text2num(params["env"])
				environ = (val == 1) ? 0 :val
				update_icon()
				update()
			. = TRUE
			CHECK_TICK
		if("overload")
			if(isRemoteControlling(usr) && !aidisabled)
				overload_lighting()
				. = TRUE
		if("cut")
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
				to_chat(usr, SPAN_WARNING("你需要剪线钳！"))
				return TRUE

			if(isWireCut(target_wire))
				mend(target_wire, usr)
			else
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				cut(target_wire, usr)
			. = TRUE
		if("pulse")
			var/obj/item/held_item = usr.get_held_item()
			if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
				to_chat(usr, SPAN_WARNING("你需要多功能工具！"))
				return TRUE
			playsound(src.loc, 'sound/effects/zzzt.ogg', 25, 1)
			pulse(target_wire, usr)
			. = TRUE
	return TRUE

/obj/structure/machinery/power/apc/proc/toggle_breaker(mob/user)
	operating = !operating
	update()
	msg_admin_niche("[user] turned [operating ? "on" : "off"] \the [src] in [AREACOORD(src)] [ADMIN_JMP(loc)].")
	update_icon()

// the very fact that i have to override this screams to me that apcs shouldnt be under machinery - spookydonut
/obj/structure/machinery/power/apc/power_change()
	update_icon()
	return

/obj/structure/machinery/power/apc/proc/make_terminal()
	//Create a terminal object at the same position as original turf loc
	//Wires will attach to this
	terminal = new/obj/structure/machinery/power/terminal(src.loc)
	terminal.setDir(dir)
	terminal.master = src

/obj/structure/machinery/power/apc/proc/init()
	has_electronics = 2 //Installed and secured
	//Is starting with a power cell installed, create it and set its charge level
	if(cell_type)
		cell = new cell_type(src)
		cell.charge = start_charge * cell.maxcharge / 100 //Convert percentage to actual value

	var/area/A = loc.loc

	//If area isn't specified use current
	if(isarea(A) && src.areastring == null)
		area = A
		name = "\improper [area.name]区域电力控制器"
	else
		area = get_area_name(areastring)
		name = "\improper [area.name]区域电力控制器"

	update_icon()
	make_terminal()

	addtimer(CALLBACK(src, PROC_REF(update)), 5)

/obj/structure/machinery/power/apc/get_examine_text(mob/user)
	. = list(desc)

	if(stat & BROKEN)
		. += SPAN_INFO("它似乎已经彻底损坏，用任何工具都能敲开。")
		return
	if(opened)
		if(has_electronics && terminal)
			. += SPAN_INFO("盖板[opened == APC_COVER_REMOVED ? "已拆除":"已打开"]，电池[cell ? "已安装":"缺失"]。")
		else if (!has_electronics && terminal)
			. += SPAN_INFO("里面有一些电线，但没有电子组件。")
		else if (has_electronics && !terminal)
			. += SPAN_INFO("已安装电子组件，但尚未接线。")
		else
			. += SPAN_INFO("既没有电子组件，也没有接好的电线。")

	else
		if(stat & MAINT)
			. += SPAN_INFO("盖板关着，但它出了故障，无法工作。")
		else
			. += SPAN_INFO("盖板关着。")

//Update the APC icon to show the three base states
//Also add overlays for indicator lights
/obj/structure/machinery/power/apc/update_icon()

	if(!status_overlays)
		status_overlays = 1
		status_overlays_lock = new
		status_overlays_charging = new
		status_overlays_equipment = new
		status_overlays_lighting = new
		status_overlays_environ = new

		status_overlays_lock.len = 2
		status_overlays_charging.len = 3
		status_overlays_equipment.len = 4
		status_overlays_lighting.len = 4
		status_overlays_environ.len = 4

		status_overlays_lock[1] = image(icon, "apcox-0") //0 = blue, 1 = red
		status_overlays_lock[2] = image(icon, "apcox-1")

		status_overlays_charging[1] = image(icon, "apco3-0")
		status_overlays_charging[2] = image(icon, "apco3-1")
		status_overlays_charging[3] = image(icon, "apco3-2")

		status_overlays_equipment[1] = image(icon, "apco0-0") //0 = red, 1 = green, 2 = blue
		status_overlays_equipment[2] = image(icon, "apco0-1")
		status_overlays_equipment[3] = image(icon, "apco0-2")
		status_overlays_equipment[4] = image(icon, "apco0-3")

		status_overlays_lighting[1] = image(icon, "apco1-0")
		status_overlays_lighting[2] = image(icon, "apco1-1")
		status_overlays_lighting[3] = image(icon, "apco1-2")
		status_overlays_lighting[4] = image(icon, "apco1-3")

		status_overlays_environ[1] = image(icon, "apco2-0")
		status_overlays_environ[2] = image(icon, "apco2-1")
		status_overlays_environ[3] = image(icon, "apco2-2")
		status_overlays_environ[4] = image(icon, "apco2-3")

	var/update = check_updates() //Returns 0 if no need to update icons.
									//1 if we need to update the icon_state
									//2 if we need to update the overlays
	if(!update)
		return

	set_light(0)

	if(update & 1) //Updating the icon state
		if(update_state & UPSTATE_ALLGOOD)
			icon_state = "apc0"
		else if(update_state & (UPSTATE_OPENED1|UPSTATE_OPENED2))
			var/basestate = "apc[cell ? "2" : "1"]"
			if(update_state & UPSTATE_OPENED1)
				if(update_state & (UPSTATE_MAINT|UPSTATE_BROKE))
					icon_state = "apcmaint" //Disabled APC cannot hold cell
				else
					icon_state = basestate
			else if(update_state & UPSTATE_OPENED2)
				icon_state = "[basestate]-nocover"
		else if(update_state & UPSTATE_BROKE)
			icon_state = "apc-b"
		else if(update_state & UPSTATE_BLUESCREEN)
			icon_state = "apcemag"
		else if(update_state & UPSTATE_WIREEXP)
			icon_state = "apcewires"

	if(!(update_state & UPSTATE_ALLGOOD))
		if(length(overlays))
			overlays = 0
			return

	if(update & 2)

		if(length(overlays))
			overlays = 0

		if(!(stat & (BROKEN|MAINT)) && update_state & UPSTATE_ALLGOOD)
			var/image/_lock = status_overlays_lock[locked + 1]
			var/image/_charging = status_overlays_charging[charging + 1]
			var/image/_equipment = status_overlays_equipment[equipment + 1]
			var/image/_lighting = status_overlays_lighting[lighting + 1]
			var/image/_environ = status_overlays_environ[environ + 1]

			overlays += emissive_appearance(_lock.icon, _lock.icon_state)
			overlays += mutable_appearance(_lock.icon, _lock.icon_state)
			overlays += emissive_appearance(_charging.icon, _charging.icon_state)
			overlays += mutable_appearance(_charging.icon, _charging.icon_state)
			if(operating)
				overlays += emissive_appearance(_equipment.icon, _equipment.icon_state)
				overlays += mutable_appearance(_equipment.icon, _equipment.icon_state)
				overlays += emissive_appearance(_lighting.icon, _lighting.icon_state)
				overlays += mutable_appearance(_lighting.icon, _lighting.icon_state)
				overlays += emissive_appearance(_environ.icon, _environ.icon_state)
				overlays += mutable_appearance(_environ.icon, _environ.icon_state)

			switch(charging)
				if(APC_NOT_CHARGING)
					set_light_color(LIGHT_COLOR_RED)
				if(APC_CHARGING)
					set_light_color(LIGHT_COLOR_BLUE)
				if(APC_FULLY_CHARGED)
					set_light_color(LIGHT_COLOR_GREEN)
			set_light(initial(light_range))

/obj/structure/machinery/power/apc/proc/check_updates()

	var/last_update_state = update_state
	var/last_update_overlay = update_overlay
	update_state = 0
	update_overlay = 0

	if(cell)
		update_state |= UPSTATE_CELL_IN
	if(stat & BROKEN)
		update_state |= UPSTATE_BROKE
	if(stat & MAINT)
		update_state |= UPSTATE_MAINT
	if(opened)
		if(opened == 1)
			update_state |= UPSTATE_OPENED1
		if(opened == 2)
			update_state |= UPSTATE_OPENED2
	else if(wiresexposed)
		update_state |= UPSTATE_WIREEXP
	if(update_state <= 1)
		update_state |= UPSTATE_ALLGOOD

	if(operating)
		update_overlay |= APC_UPOVERLAY_OPERATING

	if(update_state & UPSTATE_ALLGOOD)
		if(locked)
			update_overlay |= APC_UPOVERLAY_LOCKED

		if(!charging)
			update_overlay |= APC_UPOVERLAY_CHARGEING0
		else if(charging == APC_CHARGING)
			update_overlay |= APC_UPOVERLAY_CHARGEING1
		else if(charging == APC_FULLY_CHARGED)
			update_overlay |= APC_UPOVERLAY_CHARGEING2

		if (!equipment)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT0
		else if(equipment == 1)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT1
		else if(equipment == 2)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT2

		if(!lighting)
			update_overlay |= APC_UPOVERLAY_LIGHTING0
		else if(lighting == 1)
			update_overlay |= APC_UPOVERLAY_LIGHTING1
		else if(lighting == 2)
			update_overlay |= APC_UPOVERLAY_LIGHTING2

		if(!environ)
			update_overlay |= APC_UPOVERLAY_ENVIRON0
		else if(environ == 1)
			update_overlay |= APC_UPOVERLAY_ENVIRON1
		else if(environ == 2)
			update_overlay |= APC_UPOVERLAY_ENVIRON2

	var/results = 0
	if(last_update_state == update_state && last_update_overlay == update_overlay)
		return 0
	if(last_update_state != update_state)
		results++
	if(last_update_overlay != update_overlay && update_overlay != 0)
		results += 2
	return results

/obj/structure/machinery/power/apc/proc/queue_icon_update()

	if(!updating_icon)
		updating_icon = 1
		//Start the update
		spawn(APC_UPDATE_ICON_COOLDOWN)
			update_icon()
			updating_icon = 0

//Attack with an item - open/close cover, insert cell, or (un)lock interface
/obj/structure/machinery/power/apc/attackby(obj/item/W, mob/user)

	if(isRemoteControlling(user) && get_dist(src, user) > 1)
		return attack_hand(user)
	add_fingerprint(user)
	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR) && opened)
		if(has_electronics == 1)
			if(user.action_busy) return
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该如何拆卸[src]。"))
				return
			if(terminal)
				to_chat(user, SPAN_WARNING("先断开接线端子。"))
				return
			playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user]开始拆卸[src]的电力控制板。"),
			SPAN_NOTICE("你开始拆卸[src]的电力控制板。")) //lpeters - fixed grammar issues
			if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && has_electronics == 1)
				has_electronics = 0
				if((stat & BROKEN))
					user.visible_message(SPAN_NOTICE("[user]敲碎了[src]烧焦的电力控制板，清除了残骸。"),
					SPAN_NOTICE("你敲碎了[src]烧焦的电力控制板，清除了残骸。"))
				else
					user.visible_message(SPAN_NOTICE("[user]拆下了[src]的电力控制板。"),
					SPAN_NOTICE("你拆下了[src]的电力控制板。"))
					new /obj/item/circuitboard/apc(loc)
				SSclues.create_print(get_turf(user), user, "指纹中含有电子元件碎屑。")
				SEND_SIGNAL(user, COMSIG_MOB_APC_REMOVE_BOARD, src)

		else if(opened != APC_COVER_REMOVED) //Cover isn't removed
			opened = APC_COVER_CLOSED
			update_icon()
	else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR) && !(stat & BROKEN))
		if(coverlocked && !(stat & MAINT))
			to_chat(user, SPAN_WARNING("盖板锁住了，无法打开。"))
			return
		else
			opened = APC_COVER_OPEN
			update_icon()
	else if(istype(W, /obj/item/cell) && opened) //Trying to put a cell inside
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你完全不知道该如何将[W]装入[src]。"))
			return
		if(cell)
			to_chat(user, SPAN_WARNING("里面已经装有一块电池。"))
			return
		else
			if(stat & MAINT)
				to_chat(user, SPAN_WARNING("没有可连接电池的接口。"))
				return
			if(user.drop_inv_item_to_loc(W, src))
				cell = W
				user.visible_message(SPAN_NOTICE("[user]将[W]装入了[src]！"), \
					SPAN_NOTICE("你将[W]装入了[src]！"))
				chargecount = 0
				update_icon()
	else if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER)) //Haxing
		if(opened)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("[src]的线路让你摸不着头脑。"))
				return
			if(cell)
				to_chat(user, SPAN_WARNING("先关上区域电力控制器。")) //Less hints more mystery!
				return
			else
				if(has_electronics == 1 && terminal)
					has_electronics = 2
					stat &= ~MAINT
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					user.visible_message(SPAN_NOTICE("[user]拧紧了[src]内的电路组件。"),
					SPAN_NOTICE("你拧紧了[src]内的电路组件。"))
				else if(has_electronics == 2)
					has_electronics = 1
					stat |= MAINT
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					user.visible_message(SPAN_NOTICE("[user]松开了[src]内的电路组件。"),
					SPAN_NOTICE("你松开了[src]内的电路组件。"))
				else
					to_chat(user, SPAN_WARNING("没有需要固定的东西。"))
					return
				update_icon()
		else
			wiresexposed = !wiresexposed
			beenhit = wiresexposed ? XENO_HITS_TO_EXPOSE_WIRES_MIN : 0
			user.visible_message(SPAN_NOTICE("[user][wiresexposed ? "打开了盖板，露出" : "合上了盖板，遮住"][src]的线路。"),
			SPAN_NOTICE("你[wiresexposed ? "打开了盖板，露出" : "合上了盖板，遮住"][src]的线路。"))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
			update_icon()
			if(SStgui.close_uis(src)) //if you had UIs open before from this APC...
				tgui_interact(user) //then close them and open up the new ones (wires/panel)

	else if(istype(W, /obj/item/card/id)) //Trying to unlock the interface with an ID card
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你不确定该在[src]的哪里刷[W]。"))
			return
		if(opened)
			to_chat(user, SPAN_WARNING("你必须先关上盖板才能刷身份卡。"))
		else if(wiresexposed)
			to_chat(user, SPAN_WARNING("你必须关上面板。"))
		else if(stat & (BROKEN|MAINT))
			to_chat(user, SPAN_WARNING("什么也没发生。"))
		else
			if(allowed(usr))
				locked = !locked
				user.visible_message(SPAN_NOTICE("[user][locked ? "锁定" : "解锁"]了[src]的界面。"),
				SPAN_NOTICE("你[locked ? "锁定" : "解锁"]了[src]的界面。"))
				update_icon()
			else
				to_chat(user, SPAN_WARNING("拒绝访问。"))
	else if(iswire(W) && !terminal && opened && has_electronics != 2)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你完全不知道该如何操作[src]。"))
			return
		if(loc:intact_tile)
			to_chat(user, SPAN_WARNING("你必须先移除区域电力控制器前方的地板铺板。"))
			return
		var/obj/item/stack/cable_coil/C = W
		if(C.get_amount() < 10)
			to_chat(user, SPAN_WARNING("你需要更多电线。"))
			return
		user.visible_message(SPAN_NOTICE("[user]开始为[src]的框架接线。"),
		SPAN_NOTICE("你开始为[src]的框架接线。"))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && !terminal && opened && has_electronics != 2)
			var/turf/T = get_turf(src)
			var/obj/structure/cable/N = T.get_cable_node()
			if(prob(50) && electrocute_mob(usr, N, N))
				var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
				spark.set_up(5, 1, src)
				spark.start()
				return
			if(C.use(10))
				user.visible_message(SPAN_NOTICE("[user]给[src]的框架接好了线。"),
				SPAN_NOTICE("你给[src]的框架接好了线。"))
				make_terminal()
				terminal.connect_to_network()
	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && terminal && opened && has_electronics != 2)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你完全不知道该如何使用[W]。"))
			return
		if(loc:intact_tile)
			to_chat(user, SPAN_WARNING("你必须先移除区域电力控制器前方的地板铺板。"))
			return
		user.visible_message(SPAN_NOTICE("[user]开始拆除[src]的线路和接线端子。"),
		SPAN_NOTICE("你开始拆除[src]的线路和接线端子。"))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!terminal)
				to_chat(user, SPAN_WARNING("[src]没有可拆除的接线端子。"))
				return
			if (prob(50) && electrocute_mob(user, terminal.powernet, terminal))
				var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
				spark.set_up(5, 1, src)
				spark.start()
				return
			new /obj/item/stack/cable_coil(loc,10)
			user.visible_message(SPAN_NOTICE("[user]拆除了[src]的线路和接线端子。"),
			SPAN_NOTICE("你拆除了[src]的线路和接线端子。"))
			qdel(terminal)
			terminal = null
	else if(istype(W, /obj/item/circuitboard/apc) && opened && has_electronics == 0 && !(stat & BROKEN))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你完全不知道该如何使用[W]。"))
			return
		user.visible_message(SPAN_NOTICE("[user]开始将电力控制板装入[src]。"),
		SPAN_NOTICE("你开始将电力控制板装入[src]。"))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 15, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			has_electronics = 1
			user.visible_message(SPAN_NOTICE("[user]将电力控制板装入了[src]。"),
			SPAN_NOTICE("你将电力控制板装入了[src]。"))
			qdel(W)
	else if(istype(W, /obj/item/circuitboard/apc) && opened && has_electronics == 0 && (stat & BROKEN))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你完全不知道该如何使用[W]。"))
			return
		to_chat(user, SPAN_WARNING("框架损坏，无法装入电路板。"))
		return
	else if(iswelder(W) && opened && has_electronics == 0 && !terminal)
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要功率更大的喷灯！"))
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你完全不知道该如何使用[W]。"))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(WT.get_fuel() < 3)
			to_chat(user, SPAN_WARNING("你需要更多焊接燃料才能完成这项工作。"))
			return
		user.visible_message(SPAN_NOTICE("[user]开始焊接[src]的框架。"),
		SPAN_NOTICE("你开始焊接[src]的框架。"))
		playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!src || !WT.remove_fuel(3, user))
				return
			user.visible_message(SPAN_NOTICE("[user]用焊枪切开了[src]的框架。"), SPAN_NOTICE("你用焊枪切开了[src]的框架。"))
			deconstruct()
			return
	else if(istype(W, /obj/item/frame/apc) && opened && (stat & BROKEN))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("你完全不知道该如何使用[W]。"))
			return
		if(has_electronics)
			to_chat(user, SPAN_WARNING("必须先取出里面的电子组件，才能修复这台区域电力控制器。"))
			return
		user.visible_message(SPAN_NOTICE("[user]开始更换[src]损坏的前面板。"),
		SPAN_NOTICE("你开始更换[src]损坏的前面板。"))
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user]更换了[src]损坏的前面板。"),
			SPAN_NOTICE("你更换了[src]损坏的前面板。"))
			user.count_niche_stat(STATISTICS_NICHE_REPAIR_APC)
			qdel(W)
			beenhit = 0
			stat &= ~BROKEN
			if(opened == 2)
				opened = APC_COVER_OPEN
			update_icon()
	else
		if(((stat & BROKEN)) && !opened && W.force >= 5)
			opened = APC_COVER_REMOVED
			user.visible_message(SPAN_WARNING("[user]用[W]砸开了[src]的盖板！"), \
				SPAN_WARNING("你用[W]砸开了[src]的盖板！"))
			update_icon()
		else
			if(isRemoteControlling(user))
				return attack_hand(user)
			if(!opened && wiresexposed && (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL) || HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS)))
				return attack_hand(user)
			user.visible_message(SPAN_DANGER("[user]用[W]击打[src]！"), \
			SPAN_DANGER("你用[W]击打[src]！"))

/obj/structure/machinery/power/apc/deconstruct(disassembled = TRUE)
	if(disassembled)
		if((stat & BROKEN) || opened == 2)
			new /obj/item/stack/sheet/metal(loc)
		else
			new /obj/item/frame/apc(loc)
	return ..()

//Attack with hand - remove cell (if cover open) or interact with the APC
/obj/structure/machinery/power/apc/attack_hand(mob/user)

	if(!user)
		return

	add_fingerprint(user)

	//Human mob special interaction goes here.
	if(ishuman(user))
		var/mob/living/carbon/human/grabber = user

		if(grabber.a_intent == INTENT_GRAB)

			//Synthpack recharge
			if((grabber.species.flags & IS_SYNTHETIC) && istype(grabber.back, /obj/item/storage/backpack/marine/smartpack))
				var/obj/item/storage/backpack/marine/smartpack/s_pack = grabber.back
				if(grabber.action_busy)
					return

				if(!do_after(grabber, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
					return

				playsound(src.loc, 'sound/effects/sparks2.ogg', 25, 1)

				if(stat & BROKEN)
					var/datum/effect_system/spark_spread/spark = new()
					spark.set_up(3, 1, src)
					spark.start()
					to_chat(grabber, SPAN_DANGER("区域电力控制器的电流剧烈波动，损伤了你的机体！"))
					grabber.apply_damage(10,0, BURN)
				else if(cell && cell.charge > 0)
					if(!istype(s_pack))
						return

					if(s_pack.battery_charge < SMARTPACK_MAX_POWER_STORED)
						var/charge_to_use = min(cell.charge, SMARTPACK_MAX_POWER_STORED - s_pack.battery_charge)
						if(!(cell.use(charge_to_use)))
							return
						s_pack.battery_charge += charge_to_use
						to_chat(user, SPAN_NOTICE("你将手指插入区域电力控制器接口，抽取其中的部分电能。[s_pack.name]现有电量为[s_pack.battery_charge]/[SMARTPACK_MAX_POWER_STORED]。"))
						charging = APC_CHARGING
					else
						to_chat(user, SPAN_WARNING("[s_pack.name]已经充满电了。"))
				else
					to_chat(user, SPAN_WARNING("这台区域电力控制器没有可抽取的电量。"))
				return

			// Yautja Bracer Recharge
			var/obj/item/clothing/gloves/yautja/bracer = grabber.gloves
			if(istype(bracer))
				if(grabber.action_busy)
					return FALSE
				if(!COOLDOWN_FINISHED(bracer, bracer_recharge))
					to_chat(user, SPAN_WARNING("[bracer.name]暂时还不能再次抽取电能，请等待[COOLDOWN_SECONDSLEFT(bracer, bracer_recharge)]秒。"))
					return FALSE
				to_chat(user, SPAN_NOTICE("你将护腕贴在区域电力控制器接口上，开始抽取部分储存的电能。"))
				if(!do_after(grabber, 20, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
					return FALSE

				if(stat & BROKEN)
					var/datum/effect_system/spark_spread/spark = new()
					spark.set_up(3, 1, src)
					spark.start()
					to_chat(grabber, SPAN_DANGER("区域电力控制器的电流剧烈波动，让你的护腕变得滚烫！"))
					playsound(src.loc, 'sound/effects/sparks2.ogg', 25, 1)
					grabber.apply_damage(10,0, BURN)
					return FALSE
				if(!cell || cell.charge <= 0)
					to_chat(user, SPAN_WARNING("这台区域电力控制器没有可抽取的电量。"))
					return FALSE

				if(bracer.charge_max <= bracer.charge)
					to_chat(user, SPAN_WARNING("[bracer.name]已经充满电了。"))
					return FALSE

				var/charge_to_use = min(cell.charge, bracer.charge_max - bracer.charge)
				if(!(cell.use(charge_to_use)))
					return FALSE
				playsound(src.loc, 'sound/effects/sparks2.ogg', 25, 1)
				bracer.charge += charge_to_use
				COOLDOWN_START(bracer, bracer_recharge, bracer.charge_cooldown)
				to_chat(grabber, SPAN_YAUTJABOLD("[icon2html(bracer)] <b>[bracer]</b>发出提示音：电能抽取完成，电量为[bracer.charge]/[bracer.charge_max]。"))
				if(bracer.notification_sound)
					playsound(bracer.loc, 'sound/items/pred_bracer.ogg', 75, 1)
				charging = APC_CHARGING
				set_broken() // Breaks the APC

				return TRUE

		else if(grabber.species.can_shred(grabber))
			var/allcut = TRUE
			for(var/wire = 1; wire < length(GLOB.apc_wire_descriptions); wire++)
				if(!isWireCut(wire))
					allcut = FALSE
					break
			if(allcut)
				to_chat(user, SPAN_NOTICE("[src]已经坏了！"))
				return
			user.visible_message(SPAN_WARNING("[user.name]挥爪撕抓[src]！"),
			SPAN_WARNING("你挥爪撕抓[src]！"))
			playsound(src.loc, 'sound/weapons/slash.ogg', 25, 1)
			if(wiresexposed)
				for(var/wire = 1; wire < length(GLOB.apc_wire_descriptions); wire++)
					cut(wire, user)
				update_icon()
				visible_message(SPAN_WARNING("[src]的电线被扯碎了！"))
			else if(beenhit >= pick(3, 4))
				wiresexposed = TRUE
				update_icon()
				visible_message(SPAN_WARNING("[src]的盖板猛地打开，露出了电线！"))
			else
				beenhit++
			return


	if(usr == user && opened && (!isRemoteControlling(user)))
		if(cell)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道该如何从[src]中取出电池。"))
				return
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell.update_icon()

			src.cell = null
			user.visible_message(SPAN_NOTICE("[user]从[src]中取出了电池！"),
			SPAN_NOTICE("你从[src]中取出了电池。"))
			charging = APC_NOT_CHARGING
			update_icon()
			SSclues.create_print(get_turf(user), user, "指纹中含有少量电池酸液。")
			SEND_SIGNAL(user, COMSIG_MOB_APC_REMOVE_CELL, src)
		return
	if(stat & (BROKEN|MAINT))
		return

	tgui_interact(user)

/obj/structure/machinery/power/apc/proc/report()
	return "[area.name] : [equipment]/[lighting]/[environ] ([lastused_total]) : [cell? cell.percent() : "N/C"] ([charging])"

/obj/structure/machinery/power/apc/proc/update()
	if(operating && !shorted)
		area.update_power_channels((equipment > 1), (lighting > 1), (environ > 1))
	else
		area.update_power_channels(FALSE, FALSE, FALSE)

/obj/structure/machinery/power/apc/proc/isWireCut(wire)
	var/wireFlag = getWireFlag(wire)
	return !(apcwires & wireFlag)

/obj/structure/machinery/power/apc/proc/cut(wire, mob/user, with_message = TRUE)
	apcwires ^= getWireFlag(wire)

	switch(wire)
		if(APC_WIRE_MAIN_POWER)
			if(user)
				shock(usr, 50)
				visible_message(SPAN_WARNING("[src]开始疯狂闪烁错误信息！"))
				SSclues.create_print(get_turf(user), user, "指纹中含有电线碎屑。")
				SEND_SIGNAL(user, COMSIG_MOB_APC_CUT_WIRE, src)
			shorted = 1
			if(with_message)
				visible_message(SPAN_WARNING("[src]开始疯狂闪烁错误信息！"))

		if(APC_WIRE_IDSCAN)
			locked = 0
			if(with_message)
				visible_message(SPAN_NOTICE("[src]发出一声咔哒声。"))

/obj/structure/machinery/power/apc/proc/mend(wire)
	apcwires |= getWireFlag(wire)

	switch(wire)
		if(APC_WIRE_MAIN_POWER)
			if(!isWireCut(APC_WIRE_MAIN_POWER))
				beenhit = 0
				shorted = 0
				shock(usr, 50)

		if(APC_WIRE_IDSCAN)
			locked = 1
			visible_message(SPAN_NOTICE("[src]发出轻微的闷响。"))

/obj/structure/machinery/power/apc/proc/pulse(wire, mob/user)
	if(isWireCut(wire))
		if(user)
			to_chat(user, SPAN_WARNING("你不能向剪断的电线发送脉冲！"))
		return
	switch(wire)
		if(APC_WIRE_IDSCAN) //Unlocks the APC for 30 seconds, if you have a better way to hack an APC I'm all ears
			locked = 0
			visible_message(SPAN_NOTICE("[src]发出一声咔哒声。"))
			spawn(30 SECONDS)
				locked = 1
				visible_message(SPAN_NOTICE("[src]发出轻微的闷响。"))

		if(APC_WIRE_MAIN_POWER)
			if(shorted == 0)
				shorted = 1
				visible_message(SPAN_WARNING("[src]开始疯狂闪烁错误信息！"))
				if(user)
					SSclues.create_print(get_turf(user), user, "从指纹看来，这只手似乎握过多用工具？")
				SEND_SIGNAL(user, COMSIG_MOB_APC_POWER_PULSE, src)
			addtimer(VARSET_CALLBACK(src, shorted, FALSE), 2 MINUTES)

/obj/structure/machinery/power/apc/proc/can_use(mob/living/user as mob, loud = 0) //used by attack_hand() and Topic()
	if(user.client && user.client.remote_control)
		return TRUE

	if(user.stat)
		to_chat(user, SPAN_WARNING("你必须保持清醒才能使用[src]！"))
		return 0
	if(!user.client)
		return 0
	if(!(ishuman(user) || isRemoteControlling(user)))
		to_chat(user, SPAN_WARNING("你的动作不够灵巧，无法使用[src]！"))
		SSnano.nanomanager.close_user_uis(user, src)
		return 0
	if(user.is_mob_restrained())
		to_chat(user, SPAN_WARNING("你必须空出双手才能使用[src]。"))
		return 0
	if(user.body_position == LYING_DOWN)
		to_chat(user, SPAN_WARNING("你够不到[src]！"))
		return 0
	autoflag = 5
	if(isRemoteControlling(user))
		if(aidisabled)
			if(!loud)
				to_chat(user, SPAN_WARNING("[src]的AI控制已禁用！"))
				SSnano.nanomanager.close_user_uis(user, src)
			return 0
	else
		if((!in_range(src, user) || !istype(src.loc, /turf)))
			SSnano.nanomanager.close_user_uis(user, src)
			return 0

	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H.getBrainLoss() >= 60)
			for(var/mob/M as anything in viewers(src, null))
				H.visible_message(SPAN_WARNING("[H]茫然地盯着[src]，流着口水。"),
				SPAN_WARNING("你茫然地盯着[src]，流着口水。"))
			return 0
		else if(prob(H.getBrainLoss()))
			to_chat(user, SPAN_WARNING("你一时间忘了如何使用[src]。"))
			return 0
		if(!skillcheck(H, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(H, SPAN_WARNING("你不知道该如何使用[src]的界面。"))
			return
	return 1

/obj/structure/machinery/power/apc/proc/ion_act()
	//intended to be a bit like an emag
	if(prob(3))
		locked = 0
		if(cell.charge > 0)
			cell.charge = 0
			update_icon()
			var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread()
			smoke.set_up(1, 0, loc)
			smoke.attach(src)
			smoke.start()
			var/datum/effect_system/spark_spread/spark = new()
			spark.set_up(1, 1, src)
			spark.start()
			visible_message(SPAN_WARNING("[src]突然喷出一股浓烟和些许火花！"))

/obj/structure/machinery/power/apc/surplus()
	if(terminal)
		return terminal.surplus()
	else
		return 0

/obj/structure/machinery/power/apc/proc/last_surplus()
	if(terminal && terminal.powernet)
		return terminal.powernet.last_surplus()
	else
		return 0

//Returns 1 if the APC should attempt to charge
/obj/structure/machinery/power/apc/proc/attempt_charging()
	return (chargemode && charging == APC_CHARGING && operating)

/obj/structure/machinery/power/apc/add_load(amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0

/obj/structure/machinery/power/apc/avail()
	if(terminal)
		return terminal.avail()
	else
		return 0

/obj/structure/machinery/power/apc/process()
	if(stat & (BROKEN|MAINT))
		return
	if(!area.requires_power)
		return

	lastused_light = area.usage(POWER_CHANNEL_LIGHT)
	lastused_equip = area.usage(POWER_CHANNEL_EQUIP)
	lastused_environ = area.usage(POWER_CHANNEL_ENVIRON)
	lastused_oneoff = area.usage(POWER_CHANNEL_ONEOFF, TRUE) //getting the one-off power usage and resetting it to 0 for the next processing tick
	lastused_total = lastused_light + lastused_equip + lastused_environ + lastused_oneoff

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()
	var/power_excess = 0

	var/perapc = 0
	if(terminal && terminal.powernet)
		perapc = terminal.powernet.perapc

	if(debug)
		log_debug( "Status: [main_status] - Excess: [excess] - Last Equip: [lastused_equip] - Last Light: [lastused_light]")

	if(cell && !shorted)
		var/cell_maxcharge = cell.maxcharge

		//Calculate how much power the APC will try to get from the grid.
		var/target_draw = lastused_total
		if(attempt_charging())
			target_draw += min((cell_maxcharge - cell.charge), (cell_maxcharge * CHARGELEVEL))/CELLRATE
		target_draw = min(target_draw, perapc) //Limit power draw by perapc

		//Try to draw power from the grid
		var/power_drawn = 0
		if(avail())
			power_drawn = add_load(target_draw) //Get some power from the powernet

		//Figure out how much power is left over after meeting demand
		power_excess = power_drawn - lastused_total

		if(power_excess < 0) //Couldn't get enough power from the grid, we will need to take from the power cell.

			charging = APC_NOT_CHARGING

			var/required_power = -power_excess
			if(cell.charge >= required_power * CELLRATE) //Can we draw enough from cell to cover what's left over?
				cell.use(required_power * CELLRATE)

			else if (autoflag != 0) //Not enough power available to run the last tick!
				chargecount = 0
				//This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				autoflag = 0

		//Set external power status
		if(!power_drawn)
			main_status = 0
		else if(power_excess < 0)
			main_status = 1
		else
			main_status = 2

		//Set channels depending on how much charge we have left
		// Allow the APC to operate as normal if the cell can charge
		if(charging && longtermpower < 10)
			longtermpower++
		else if(longtermpower > -10)
			longtermpower -= 2


		if(cell.charge >= 1250 || longtermpower > 0) //Put most likely at the top so we don't check it last, effeciency 101
			if(autoflag != 3)
				equipment = autoset(equipment, 1)
				lighting = autoset(lighting, 1)
				environ = autoset(environ, 1)
				autoflag = 3
				area.poweralert(1, src)
				if(cell.charge >= 4000)
					area.poweralert(1, src)
		else if(cell.charge < 1250 && cell.charge > 750 && longtermpower < 0) //<30%, turn off equipment
			if(autoflag != 2)
				equipment = autoset(equipment, 2)
				lighting = autoset(lighting, 1)
				environ = autoset(environ, 1)
				area.poweralert(0, src)
				autoflag = 2
		else if(cell.charge < 750 && cell.charge > 10) //<15%, turn off lighting & equipment
			if((autoflag > 1 && longtermpower < 0) || (autoflag > 1 && longtermpower >= 0))
				equipment = autoset(equipment, 2)
				lighting = autoset(lighting, 2)
				environ = autoset(environ, 1)
				area.poweralert(0, src)
				autoflag = 1
		else if(cell.charge <= 0) //Zero charge, turn all off
			if(autoflag != 0)
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				area.poweralert(0, src)
				autoflag = 0

		//Now trickle-charge the cell
		if(attempt_charging())
			if(power_excess > 0) //Check to make sure we have enough to charge
				cell.give(power_excess * CELLRATE) //Actually recharge the cell
			else
				charging = APC_NOT_CHARGING //Stop charging
				chargecount = 0

		//Show cell as fully charged if so
		if(cell.charge >= cell_maxcharge)
			charging = APC_FULLY_CHARGED

		//If we have excess power for long enough, think about re-enable charging.
		if(chargemode)
			if(!charging)
				//last_surplus() overestimates the amount of power available for charging, but it's equivalent to what APCs were doing before.
				if(last_surplus() * CELLRATE >= cell_maxcharge * CHARGELEVEL)
					chargecount++
				else
					chargecount = 0
					charging = APC_NOT_CHARGING

				if(chargecount >= 10)
					chargecount = 0
					charging = 1

		else //Chargemode off
			charging = APC_NOT_CHARGING
			chargecount = 0

	else //No cell, switch everything off
		charging = APC_NOT_CHARGING
		chargecount = 0
		equipment = autoset(equipment, 0)
		lighting = autoset(lighting, 0)
		environ = autoset(environ, 0)
		area.poweralert(0, src)
		autoflag = 0

	//Update icon & area power if anything changed

	if(last_lt != lighting || last_eq != equipment || last_en != environ)
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

//val 0 = off, 1 = off(auto) 2 = on, 3 = on(auto)
//on 0 = off, 1 = auto-on, 2 = auto-off

/proc/autoset(val, on)

	if(on == 0) //Turn things off
		if(val == 2) //If on, return off
			return 0
		else if(val == 3) //If auto-on, return auto-off
			return 1

	else if(on == 1) //Turn things auto-on
		if(val == 1) //If auto-off, return auto-on
			return 3

	else if(on == 2) //Turn things auto-off
		if(val == 3) //If auto-on, return auto-off
			return 1
	return val

//Damage and destruction acts
/obj/structure/machinery/power/apc/emp_act(severity)
	. = ..()
	if(cell)
		cell.emp_act(severity)
	lighting = 0
	equipment = 0
	environ = 0
	spawn(1 MINUTES)
		equipment = 3
		environ = 3

/obj/structure/machinery/power/apc/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				set_broken()
				if(cell && prob(25))
					cell.ex_act(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				set_broken()
				if(cell && prob(50))
					cell.ex_act(severity)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if(cell)
				cell.ex_act(severity) //More lags woohoo
			deconstruct(FALSE)
			return

/obj/structure/machinery/power/apc/proc/set_broken()

	//Aesthetically much better!
	visible_message(SPAN_WARNING("[src]的屏幕短暂闪烁着警告！"))
	addtimer(CALLBACK(src, PROC_REF(do_set_broken)), rand(2, 5))

/obj/structure/machinery/power/apc/proc/do_set_broken()
	visible_message(SPAN_DANGER("[src]的屏幕突然炸开，火花和碎屑四处飞溅！"))
	stat |= BROKEN
	operating = 0
	update_icon()
	update()

//Overload all the lights in this APC area
/obj/structure/machinery/power/apc/proc/overload_lighting()
	if(!operating || shorted)
		return
	if(cell && cell.charge >= 20)
		cell.use(20)
		spawn(0)
			for(var/obj/structure/machinery/light/L in area)
				L.on = 1
				L.broken()
				sleep(1)

/obj/structure/machinery/power/apc/wires_cut
	icon_state = "apcewires_mapicon"

/obj/structure/machinery/power/apc/wires_cut/Initialize(mapload, ndir, building)
	. = ..()
	wiresexposed = TRUE
	for(var/wire = 1; wire < length(GLOB.apc_wire_descriptions); wire++)
		cut(wire)
	update_icon()
	beenhit = 4

/obj/structure/machinery/power/apc/fully_broken
	icon_state = "apc2_mapicon"

/obj/structure/machinery/power/apc/fully_broken/Initialize(mapload, ndir, building)
	. = ..()
	wiresexposed = TRUE
	for(var/wire = 1; wire < length(GLOB.apc_wire_descriptions); wire++)
		cut(wire)
	beenhit = 4
	set_broken()

/obj/structure/machinery/power/apc/fully_broken/no_cell
	icon_state = "apc1_mapicon"

/obj/structure/machinery/power/apc/fully_broken/no_cell/Initialize(mapload, ndir, building)
	. = ..()
	QDEL_NULL(cell)
	update_icon()

/obj/structure/machinery/power/apc/antag
	cell_type = /obj/item/cell/apc
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)

//------Almayer APCs ------//

/obj/structure/machinery/power/apc/almayer
	cell_type = /obj/item/cell/high

/obj/structure/machinery/power/apc/almayer/north
	pixel_y = 32
	dir = 1

/obj/structure/machinery/power/apc/almayer/south
	pixel_y = -26
	dir = 2

/obj/structure/machinery/power/apc/almayer/east
	pixel_x = 30
	dir = 4

/obj/structure/machinery/power/apc/almayer/west
	pixel_x = -30
	dir = 8

/obj/structure/machinery/power/apc/almayer/hardened
	name = "加固型区域电力控制器"
	desc = "区域电力系统的控制终端，经过加固，可抵御电网受损引发的突然电力波动。"
	crash_break_probability = 0

/obj/structure/machinery/power/apc/almayer/hardened/north
	pixel_y = 32
	dir = 1

/obj/structure/machinery/power/apc/almayer/hardened/south
	pixel_y = -26
	dir = 2

/obj/structure/machinery/power/apc/almayer/hardened/east
	pixel_x = 30
	dir = 4

/obj/structure/machinery/power/apc/almayer/hardened/west
	pixel_x = -30
	dir = 8

//------ Directional APCs ------//

/obj/structure/machinery/power/apc/no_power
	start_charge = 0

/obj/structure/machinery/power/apc/no_power/north
	pixel_y = 32
	dir = 1

/obj/structure/machinery/power/apc/no_power/south
	pixel_y = -26
	dir = 2

/obj/structure/machinery/power/apc/no_power/east
	pixel_x = 30
	dir = 4

/obj/structure/machinery/power/apc/no_power/west
	pixel_x = -30
	dir = 8

// Powered APCs with directions
/obj/structure/machinery/power/apc/power/north
	pixel_y = 32
	dir = 1

/obj/structure/machinery/power/apc/power/south
	pixel_y = -26
	dir = 2

/obj/structure/machinery/power/apc/power/east
	pixel_x = 30
	dir = 4

/obj/structure/machinery/power/apc/power/west
	pixel_x = -30
	dir = 8

// Upgraded APC's with directions
/obj/structure/machinery/power/apc/upgraded/power
	desc = "区域电力系统的控制终端，升级了更好的电池，可维持更高的用电需求。"
	cell_type = /obj/item/cell/high


/obj/structure/machinery/power/apc/upgraded/power/north
	pixel_y = 32
	dir = 1

/obj/structure/machinery/power/apc/upgraded/power/south
	pixel_y = -26
	dir = 2

/obj/structure/machinery/power/apc/upgraded/power/east
	pixel_x = 30
	dir = 4

/obj/structure/machinery/power/apc/upgraded/power/west
	pixel_x = -30
	dir = 8

// apc that start at zero charge.

/obj/structure/machinery/power/apc/upgraded/no_power
	start_charge = 0

/obj/structure/machinery/power/apc/upgraded/no_power/north
	pixel_y = 32
	dir = 1

/obj/structure/machinery/power/apc/upgraded/no_power/south
	pixel_y = -26
	dir = 2

/obj/structure/machinery/power/apc/upgraded/no_power/east
	pixel_x = 30
	dir = 4

/obj/structure/machinery/power/apc/upgraded/no_power/west
	pixel_x = -30
	dir = 8

#undef APC_UPDATE_ICON_COOLDOWN
