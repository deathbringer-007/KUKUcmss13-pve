

/obj/item/circuitboard/computer

/obj/item/circuitboard/computer/generic // To be used in machine refactor
	name = "电子元件"

/obj/item/circuitboard/computer/generic/New(obj/structure/machinery/M)
	..()
	name = "电路板（[M.name]）"
	build_path = M.type

//TODO: Move these into computer/camera.dm
/obj/item/circuitboard/computer/cameras
	name = "电路板 (安保摄像监视器)"
	build_path = /obj/structure/machinery/computer/cameras
	var/network = list(CAMERA_NET_MILITARY)
	req_access = list(ACCESS_MARINE_BRIG)
	var/locked = 1

/obj/item/circuitboard/computer/cameras/construct(obj/structure/machinery/computer/cameras/C)
	if (..(C))
		C.network = network

/obj/item/circuitboard/computer/cameras/disassemble(obj/structure/machinery/computer/cameras/C)
	if (..(C))
		network = C.network

/obj/item/circuitboard/computer/cameras/tv
	name = "电路板 (电视机)"
	build_path = /obj/structure/machinery/computer/cameras/wooden_tv/broadcast
	network = list(CAMERA_NET_CORRESPONDENT)
	req_access = list()

/obj/item/circuitboard/computer/cameras/engineering
	name = "电路板（工程摄像监视器）"
	build_path = /obj/structure/machinery/computer/cameras/engineering
	network = list("Engineering","Power Alarms","Atmosphere Alarms","Fire Alarms")
	req_access = list()
/obj/item/circuitboard/computer/cameras/mining
	name = "电路板（采矿摄像监视器）"
	build_path = /obj/structure/machinery/computer/cameras/mining
	network = list("MINE")
	req_access = list()

/obj/item/circuitboard/computer/cryopodcontrol
	name = "电路板（冷冻休眠监管控制台）"
	build_path = /obj/structure/machinery/computer/cryopod

/obj/item/circuitboard/computer/med_data
	name = "电路板（医疗档案）"
	build_path = /obj/structure/machinery/computer/med_data

/obj/item/circuitboard/computer/pandemic
	name = "电路板（PanD.E.M.I.C. 2200）"
	build_path = /obj/structure/machinery/computer/pandemic

/obj/item/circuitboard/computer/scan_consolenew
	name = "电路板（DNA 设备）"
	// build_path = /obj/structure/machinery/computer/scan_consolenew

/obj/item/circuitboard/computer/communications
	name = "电路板（通信）"
	build_path = /obj/structure/machinery/computer/communications

/obj/item/circuitboard/computer/card
	name = "电路板 (身份卡计算机)"
	build_path = /obj/structure/machinery/computer/card

/obj/item/circuitboard/computer/teleporter
	name = "电路板（传送器）"
	build_path = /obj/structure/machinery/computer/teleporter

/obj/item/circuitboard/computer/secure_data
	name = "电路板 (安保档案)"
	build_path = /obj/structure/machinery/computer/secure_data

/obj/item/circuitboard/computer/skills
	name = "电路板（人事档案）"
	build_path = /obj/structure/machinery/computer/skills

/obj/item/circuitboard/computer/stationalert
	name = "电路板 (空间站警报)"
	build_path = /obj/structure/machinery/computer/station_alert



/obj/item/circuitboard/computer/air_management
	name = "电路板 (大气监测仪)"
	build_path = /obj/structure/machinery/computer/general_air_control

/obj/item/circuitboard/computer/air_management/tank_control
	name = "电路板（储气罐控制）"
	build_path = /obj/structure/machinery/computer/general_air_control/large_tank_control

/obj/item/circuitboard/computer/air_management/injector_control
	name = "电路板（注气器控制）"
	build_path = /obj/structure/machinery/computer/general_air_control/fuel_injection



/obj/item/circuitboard/computer/atmos_alert
	name = "电路板（大气警报）"
	build_path = /obj/structure/machinery/computer/atmos_alert
/obj/item/circuitboard/computer/pod/old
	name = "电路板（DoorMex 门控系统）"
	build_path = /obj/structure/machinery/computer/pod/old
/obj/item/circuitboard/computer/robotics
	name = "电路板（机器人控制）"
	build_path = /obj/structure/machinery/computer/robotics

/obj/item/circuitboard/computer/drone_control
	name = "电路板（无人机控制）"
	build_path = /obj/structure/machinery/computer/drone_control

/obj/item/circuitboard/computer/arcade
	name = "电路板 (街机)"
	build_path = /obj/structure/machinery/computer/arcade

/obj/item/circuitboard/computer/turbine_control
	name = "电路板（涡轮控制）"
	build_path = /obj/structure/machinery/computer/turbine_computer
/obj/item/circuitboard/computer/powermonitor
	name = "电路板（电力监控）"
	build_path = /obj/structure/machinery/power/monitor
/obj/item/circuitboard/computer/prisoner
	name = "电路板（囚犯管理）"
	build_path = /obj/structure/machinery/computer/prisoner
/obj/item/circuitboard/computer/rdconsole
	name = "电路板（研发主管控制台）"
	build_path = /obj/structure/machinery/computer/rdconsole/core
/obj/item/circuitboard/computer/mecha_control
	name = "电路板（外骨骼控制台）"
	build_path = /obj/structure/machinery/computer/mecha
/obj/item/circuitboard/computer/rdservercontrol
	name = "电路板（研发服务器控制）"
	build_path = /obj/structure/machinery/computer/rdservercontrol
/obj/item/circuitboard/computer/crew
	name = "电路板 (人员监测计算机)"
	build_path = /obj/structure/machinery/computer/crew

/obj/item/circuitboard/computer/ordercomp
	name = "电路板 (补给订购控制台)"
	build_path = /obj/structure/machinery/computer/ordercomp

/obj/item/circuitboard/computer/supply_drop_console
	name = "电路板（空投补给控制台）"
	build_path = /obj/structure/machinery/computer/supply_drop_console

/obj/item/circuitboard/computer/supply_drop_console/limited
	name = "电路板（空投补给控制台）"
	build_path = /obj/structure/machinery/computer/supply_drop_console/limited

/obj/item/circuitboard/computer/supplycomp
	name = "电路板（自动储存与检索系统控制台）"
	build_path = /obj/structure/machinery/computer/supplycomp

	var/contraband_enabled = FALSE
	var/black_market_lock = FALSE

/obj/item/circuitboard/computer/supplycomp/construct(obj/structure/machinery/computer/supplycomp/SC)
	if (..(SC))
		SC.toggle_contraband(contraband_enabled)
		SC.lock_black_market(black_market_lock)

/obj/item/circuitboard/computer/supplycomp/disassemble(obj/structure/machinery/computer/supplycomp/SC)
	if(SC.can_order_contraband)
		contraband_enabled = TRUE
	if(SC.black_market_lockout)
		black_market_lock = TRUE
	if (..(SC))
		SC.toggle_contraband(contraband_enabled)
		SC.lock_black_market(black_market_lock)

/obj/item/circuitboard/computer/supplycomp/attackby(obj/item/tool, mob/user)
	if(HAS_TRAIT(tool, TRAIT_TOOL_MULTITOOL))
		to_chat(user, SPAN_WARNING("你试着向电路板发出脉冲，却没有任何反应。也许需要更专门的工具？"))
		return

	else if(HAS_TRAIT(tool, TRAIT_TOOL_BLACKMARKET_HACKER))
		to_chat(user, SPAN_WARNING("你开始摆弄[src]的电子元件……"))
		if(do_after(user, 8 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("你完全不知道自己在做什么。"))
				return
			to_chat(user, SPAN_WARNING("咦？你找到了一条处理器总线，上面用白色蜡笔写着“B.M.”。你开始摆弄它。"))
			if(do_after(user, 8 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				if(!contraband_enabled)
					to_chat(user, SPAN_WARNING("你用[tool]增强了广播功能，电路板上的红灯开始闪烁。要把它装回去吗？"))
					contraband_enabled = TRUE
				else
					to_chat(user, SPAN_WARNING("你用[tool]削弱了广播功能，红灯停止闪烁并熄灭。现在应该没问题了。"))
					contraband_enabled = FALSE

	else if(HAS_TRAIT(tool, TRAIT_TOOL_TRADEBAND))
		if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
			to_chat(user, SPAN_NOTICE("你不知道如何使用[tool]。"))
			return

		if(black_market_lock)
			to_chat(user, SPAN_NOTICE("[src]已经重置。"))
			return

		if(user.action_busy)
			to_chat(user, "你正忙于其他操作，无法修复被篡改的电路。")
			return

		playsound(tool, 'sound/machines/lockenable.ogg', 25)
		user.visible_message(SPAN_NOTICE("[user]将[tool]连接到[src]。"),\
		SPAN_NOTICE("你开始修复[src]上被篡改的电路。"))
		tool.icon_state = "[tool.icon_state]_on"

		if(!do_after(user, 15 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, tool, INTERRUPT_ALL))
			tool.icon_state = initial(tool.icon_state)
			return

		playsound(tool, 'sound/machines/ping.ogg', 25)
		black_market_lock = TRUE
		contraband_enabled = FALSE
		tool.icon_state = initial(tool.icon_state)

	else ..()

/obj/item/circuitboard/computer/supplycomp/vehicle
	name = "电路板（载具自动储存与检索系统控制台）"
	build_path = /obj/structure/machinery/computer/supplycomp/vehicle
	var/spent = FALSE //so that they can't just reconstruct the console to get another APC
	var/tank_unlocked = FALSE

/obj/item/circuitboard/computer/supplycomp/vehicle/construct(obj/structure/machinery/computer/supplycomp/vehicle/SCV)
	if (..(SCV))
		SCV.spent = spent
		SCV.tank_unlocked = tank_unlocked

/obj/item/circuitboard/computer/supplycomp/vehicle/disassemble(obj/structure/machinery/computer/supplycomp/vehicle/SCV)
	if (..(SCV))
		spent = SCV.spent
		tank_unlocked = SCV.tank_unlocked

/obj/item/circuitboard/computer/operating
	name = "电路板（手术计算机）"
	build_path = /obj/structure/machinery/computer/operating

/obj/item/circuitboard/computer/comm_monitor
	name = "电路板（电信监视器）"
	build_path = /obj/structure/machinery/computer/telecomms/monitor

/obj/item/circuitboard/computer/comm_server
	name = "电路板（电信服务器监视器）"
	build_path = /obj/structure/machinery/computer/telecomms/server

/obj/item/circuitboard/computer/comm_traffic
	name = "电路板（电信流量控制）"
	build_path = /obj/structure/machinery/computer/telecomms/traffic


/obj/item/circuitboard/computer/aifixer
	name = "电路板（人工智能完整性修复器）"
	build_path = /obj/structure/machinery/computer/aifixer

/obj/item/circuitboard/computer/area_atmos
	name = "电路板（区域空气控制）"
	build_path = /obj/structure/machinery/computer/area_atmos

/obj/item/circuitboard/computer/research_terminal
	name = "电路板 (科研数据终端)"
	build_path = /obj/structure/machinery/computer/research/main_terminal


/obj/item/circuitboard/computer/cameras/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/card/id))
		if(check_access(I))
			locked = !locked
			to_chat(user, SPAN_NOTICE("你[locked ? "锁定" : "解锁"]了电路控制。"))
		else
			to_chat(user, SPAN_DANGER("访问被拒绝。"))
	else if(HAS_TRAIT(I, TRAIT_TOOL_MULTITOOL))
		if(locked)
			to_chat(user, SPAN_DANGER("电路控制已锁定。"))
			return
		var/existing_networks = jointext(network,",")
		var/input = strip_html(input(usr, "要将这个摄像控制台电路连接到哪些网络？请用英文逗号分隔，不要加空格！\n例如：military,Security,Secret", "多功能工具－电路板接口", existing_networks))
		if(!input)
			to_chat(usr, "未找到输入，请挂断后重新拨打。")
			return
		var/list/tempnetwork = splittext(input, ",")
		tempnetwork = difflist(tempnetwork,GLOB.RESTRICTED_CAMERA_NETWORKS,1)
		if(length(tempnetwork) < 1)
			to_chat(usr, "未找到网络，请挂断后重新拨打。")
			return
		network = tempnetwork
	return

/obj/item/circuitboard/computer/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		user.visible_message(SPAN_NOTICE("[user]调整了[src]访问协议针脚上的跳线。"), SPAN_NOTICE("你调整了访问协议针脚上的跳线。"))
		if(src.build_path == /obj/structure/machinery/computer/rdconsole/core)
			src.name = "电路板（研发控制台－机器人系统）"
			src.build_path = /obj/structure/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_NOTICE("访问协议已设为机器人系统。"))
		else
			src.name = "电路板（研发控制台）"
			src.build_path = /obj/structure/machinery/computer/rdconsole/core
			to_chat(user, SPAN_NOTICE("访问协议已恢复默认。"))
