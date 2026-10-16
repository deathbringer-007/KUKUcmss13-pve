/obj/structure/machinery/r_n_d
	name = "研发设备"
	icon = 'icons/obj/structures/machinery/research.dmi'
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	var/list/parts_to_build

/obj/structure/machinery/r_n_d/Initialize(mapload, ...)
	. = ..()
	QDEL_NULL_LIST(component_parts)
	for(var/typepath in parts_to_build)
		LAZYADD(component_parts, new typepath(src))
	RefreshParts()

/obj/structure/machinery/r_n_d/circuit_imprinter
	name = "电路印制机"
	icon_state = "circuit_imprinter"
	flags_atom = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 2500
	parts_to_build = list(
		/obj/item/circuitboard/machine/circuit_imprinter,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/beaker,
	)

/obj/structure/machinery/r_n_d/server
	name = "研发服务器"
	icon = 'icons/obj/structures/machinery/research.dmi'
	icon_state = "server"
	health = 100
	idle_power_usage = 800
	req_access = list(ACCESS_MARINE_CMO) //Only the R&D can change server settings.
	parts_to_build = list(
		/obj/item/circuitboard/machine/rdserver,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stack/cable_coil,
		/obj/item/stack/cable_coil,
	)

/obj/structure/machinery/r_n_d/server/centcom
	name = "中央指挥部研发总数据库"

/obj/structure/machinery/computer/rdservercontrol
	name = "研发服务器控制器"
	icon_state = "rdcomp"
	circuit = /obj/item/circuitboard/computer/rdservercontrol

/obj/structure/machinery/r_n_d/server/robotics
	name = "机器人学研发服务器"

/obj/structure/machinery/r_n_d/server/core
	name = "核心研发服务器"


/obj/structure/machinery/r_n_d/destructive_analyzer
	name = "破坏性分析仪"
	icon_state = "d_analyzer"
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 2500
	parts_to_build = list(
		/obj/item/circuitboard/machine/destructive_analyzer,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
	)

/obj/structure/machinery/r_n_d/protolathe
	name = "原型制造机"
	icon_state = "protolathe"
	flags_atom = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000
	parts_to_build = list(
		/obj/item/circuitboard/machine/protolathe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/beaker,
	)

/obj/structure/machinery/r_n_d/server
	name = "研发服务器"
	icon = 'icons/obj/structures/machinery/research.dmi'
	icon_state = "server"
	health = 100
	idle_power_usage = 800
	req_access = list(ACCESS_MARINE_CMO) //Only the R&D can change server settings.
	parts_to_build = list(
		/obj/item/circuitboard/machine/rdserver,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stack/cable_coil,
		/obj/item/stack/cable_coil,
	)

/obj/structure/machinery/r_n_d/server/centcom
	name = "中央指挥部研发总数据库"

/obj/structure/machinery/r_n_d/server/robotics
	name = "机器人学研发服务器"

/obj/structure/machinery/r_n_d/server/core
	name = "核心研发服务器"


/obj/structure/machinery/computer/rdservercontrol
	name = "研发服务器控制器"
	icon_state = "rdcomp"
	circuit = /obj/item/circuitboard/computer/rdservercontrol

/obj/structure/machinery/computer/rdconsole
	name = "研发控制台"
	icon_state = "rdcomp"
	circuit = /obj/item/circuitboard/computer/rdconsole
	req_access = list(ACCESS_MARINE_RESEARCH)

/obj/structure/machinery/computer/rdconsole/robotics
	name = "机器人学研发控制台"
	req_access = null

/obj/structure/machinery/computer/rdconsole/core
	name = "核心研发控制台"


/obj/structure/machinery/computer/WYresearch
	name = "研发控制台"
	icon = 'icons/obj/structures/machinery/mainframe.dmi'
	icon_state = "aimainframe"
	circuit = /obj/item/circuitboard/computer/rdconsole  //It will eventually need it's own circuit.
	req_access = list(ACCESS_MARINE_RESEARCH) //Data and setting manipulation requires scientist access.


/obj/structure/machinery/r_n_d/organic_analyzer
	name = "维兰德-汤谷牌有机物分析仪™"
	icon_state = "d_analyzer"
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 2500
	parts_to_build = list(
		/obj/item/circuitboard/machine/destructive_analyzer,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
	)

/obj/structure/machinery/r_n_d/bioprinter
	name = "维兰德-汤谷牌生物有机打印机™"
	icon_state = "protolathe"
	flags_atom = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000
	parts_to_build = list(
		/obj/item/circuitboard/machine/protolathe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/beaker,
	)


/obj/structure/machinery/blackbox_recorder
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "blackbox"
	name = "黑匣子记录器"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100


/obj/structure/machinery/message_server
	icon = 'icons/obj/structures/machinery/research.dmi'
	icon_state = "server"
	name = "消息服务器"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
