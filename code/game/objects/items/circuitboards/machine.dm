//Machine Frame Circuit Boards
/*Common Parts: Parts List: Ignitor, Timer, Infra-red laser, Infra-red sensor, t_scanner, Capacitor, Valve, sensor unit,
micro-manipulator, console screen, beaker, Microlaser, matter bin, power cells.
Note: Once everything is added to the public areas, will add materials to circuit boards since autolathe won't be able
to destroy them and players will be able to make replacements.
*/

/obj/item/circuitboard/machine
	var/list/req_components = null
	var/frame_desc = null

/obj/item/circuitboard/machine/destructive_analyzer
	name = "电路板（破坏性分析仪）"
	build_path = /obj/structure/machinery/r_n_d/destructive_analyzer

	frame_desc = "需要 1 个扫描模块、1 个微型机械臂和 1 个微型激光器。"
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
	)

/obj/item/circuitboard/machine/autolathe
	name = "电路板 (自动车床)"
	build_path = /obj/structure/machinery/autolathe

	frame_desc = "需要 2 个物料仓、1 个微型机械臂和 1 个控制台屏幕。"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/console_screen = 1,
	)

/obj/item/circuitboard/machine/autolathe/armylathe
	name = "电路板（军用车床）"
	build_path = /obj/structure/machinery/autolathe/armylathe

	frame_desc = "需要 4 个物料仓、1 个微型机械臂和 1 个控制台屏幕。"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 4,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/console_screen = 1,
	)

/obj/item/circuitboard/machine/protolathe
	name = "电路板（原型车床）"
	build_path = /obj/structure/machinery/r_n_d/protolathe

	frame_desc = "需要 2 个物料仓、2 个微型机械臂和 2 个烧杯。"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/reagent_container/glass/beaker = 2,
	)


/obj/item/circuitboard/machine/circuit_imprinter
	name = "电路板（电路印制机）"
	build_path = /obj/structure/machinery/r_n_d/circuit_imprinter

	frame_desc = "需要 1 个物料仓、1 个微型机械臂和 2 个烧杯。"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/reagent_container/glass/beaker = 2,
	)

/obj/item/circuitboard/machine/pacman
	name = "电路板 (PACMAN-式发电机)"
	build_path = /obj/structure/machinery/power/port_gen/pacman

	frame_desc = "需要 1 个物料仓、1 个微型激光器、2 段电缆和 1 个电容器。"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor = 1,
	)

/obj/item/circuitboard/machine/pacman/super
	name = "电路板（SUPERPACMAN 型发电机）"
	build_path = /obj/structure/machinery/power/port_gen/pacman/super


/obj/item/circuitboard/machine/pacman/mrs
	name = "电路板（MRSPACMAN 型发电机）"
	build_path = /obj/structure/machinery/power/port_gen/pacman/mrs


/obj/item/circuitboard/machine/rdserver
	name = "电路板（研发服务器）"
	build_path = /obj/structure/machinery/r_n_d/server

	frame_desc = "需要 2 段电缆和 1 个扫描模块。"
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/scanning_module = 1,
	)

/obj/item/circuitboard/machine/mechfab
	name = "电路板（外骨骼制造机）"
	build_path = /obj/structure/machinery/mecha_part_fabricator

	frame_desc = "需要 2 个物料仓、1 个微型机械臂、1 个微型激光器和 1 个控制台屏幕。"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/console_screen = 1,
	)

/obj/item/circuitboard/machine/clonepod
	name = "电路板（克隆舱）"

	frame_desc = "需要 2 个机械臂、2 个扫描模块、2 段电缆和 1 个控制台屏幕。"
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/console_screen = 1,
	)

/obj/item/circuitboard/machine/clonescanner
	name = "电路板（克隆扫描仪）"

	frame_desc = "需要 1 个扫描模块、1 个微型机械臂、1 个微型激光器、2 段电缆和 1 个控制台屏幕。"
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 2,
	)

/obj/item/circuitboard/machine/unary_atmos

	var/machine_dir = SOUTH
	var/init_dirs = SOUTH

/obj/item/circuitboard/machine/unary_atmos/attackby(obj/item/I as obj, mob/user as mob)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		machine_dir = turn(machine_dir, 90)
		init_dirs = machine_dir
		user.visible_message(SPAN_NOTICE("[user]调整了[src]端口配置针脚上的跳线。"), SPAN_NOTICE("你调整了端口配置针脚上的跳线。当前设为[localized_player_label(dir2text(machine_dir))]。"))
	return

/obj/item/circuitboard/machine/unary_atmos/get_examine_text(mob/user)
	. = ..()
	. += "跳线连接着[localized_player_label(dir2text(machine_dir))]侧的针脚。"

/obj/item/circuitboard/machine/unary_atmos/construct(obj/structure/pipes/unary/U)
	//TODO: Move this stuff into the relevant constructor when pipe/construction.dm is cleaned up.
	U.setDir(src.machine_dir)
	U.valid_directions = list(init_dirs)

/obj/item/circuitboard/machine/unary_atmos/heater
	name = "电路板（气体加热系统）"
	build_path = /obj/structure/pipes/unary/heater

	frame_desc = "需要 5 段电缆、1 个物料仓和 2 个电容器。"
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 2,
	)

/obj/item/circuitboard/machine/unary_atmos/cooler
	name = "电路板（气体冷却系统）"
	build_path = /obj/structure/pipes/unary/freezer

	frame_desc = "需要 2 段电缆、1 个物料仓、1 个微型机械臂和 2 个电容器。"
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/manipulator = 1,
	)

// Telecomms circuit boards:

/obj/item/circuitboard/machine/telecomms/receiver
	name = "电路板（子空间接收器）"
	build_path = /obj/structure/machinery/telecomms/receiver

	frame_desc = "需要 1 个子空间通信器、1 个超波滤波器、2 个微型机械臂和 1 个微型激光器。"
	req_components = list(
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 1,
	)

/obj/item/circuitboard/machine/telecomms/hub
	name = "电路板（枢纽主机）"
	build_path = /obj/structure/machinery/telecomms/hub

	frame_desc = "需要 2 个微型机械臂、2 卷电缆和 2 个超波滤波器。"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 2,
	)

/obj/item/circuitboard/machine/telecomms/relay
	name = "电路板 (中继主机)"
	build_path = /obj/structure/machinery/telecomms/relay

	frame_desc = "需要 2 个微型机械臂、2 卷电缆和 2 个超波滤波器。"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/filter = 2,
	)

/obj/item/circuitboard/machine/telecomms/relay/tower
	name = "TC-4T 通讯电路板"
	build_path = /obj/structure/machinery/telecomms/relay/preset/tower

	frame_desc = "TC-4T 电信电路板。需要 2 个电池、2 卷电缆和 1 个子空间通信碟。"
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/cell = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/subspace/filter = 2,
	)

/obj/item/circuitboard/machine/telecomms/bus
	name = "电路板（总线主机）"
	build_path = /obj/structure/machinery/telecomms/bus

	frame_desc = "需要 2 个微型机械臂、1 卷电缆和 1 个超波滤波器。"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1,
	)

/obj/item/circuitboard/machine/telecomms/processor
	name = "电路板（处理单元）"
	build_path = /obj/structure/machinery/telecomms/processor

	frame_desc = "需要 3 个微型机械臂、1 个超波滤波器、2 个处理磁盘、1 个波长分析仪、2 卷电缆和 1 个子空间放大器。"
	req_components = list(
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/treatment = 2,
		/obj/item/stock_parts/subspace/analyzer = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/subspace/amplifier = 1,
	)

/obj/item/circuitboard/machine/telecomms/server
	name = "电路板（电信服务器）"
	build_path = /obj/structure/machinery/telecomms/server

	frame_desc = "需要 2 个微型机械臂、1 卷电缆和 1 个超波滤波器。"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1,
	)

/obj/item/circuitboard/machine/telecomms/broadcaster
	name = "电路板（子空间广播器）"
	build_path = /obj/structure/machinery/telecomms/broadcaster

	frame_desc = "需要 2 个微型机械臂、1 卷电缆、1 个超波滤波器、1 个通信晶体和 2 个高功率微型激光器。"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/micro_laser/high = 2,
	)




/obj/item/circuitboard/machine/batteryrack
	name = "电路板（电池架电源）"
	build_path = /obj/structure/machinery/power/smes/batteryrack

	frame_desc = "需要 3 个电池。"
	req_components = list(/obj/item/cell = 3)


/obj/item/circuitboard/machine/ghettosmes
	name = "电路板 (简易电源组)"
	desc = "由区域电力控制器电路改造而成的储能设备控制器。"
	build_path = /obj/structure/machinery/power/smes/batteryrack/makeshift
	frame_desc = "需要 3 个电池。"
	req_components = list(/obj/item/cell = 3)



	//Board
/obj/item/circuitboard/machine/smes
	name = "电路板（超导储能单元）"
	build_path = /obj/structure/machinery/power/smes/buildable
	// Board itself is high tech. Coils have to be ordered from cargo or salvaged from existing SMESs.
	frame_desc = "需要 1 个超导磁线圈和 30 段电线。"
	req_components = list(/obj/item/stock_parts/smes_coil = 1, /obj/item/stack/cable_coil = 30)
