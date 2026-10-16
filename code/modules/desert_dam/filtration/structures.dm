/turf/open/floor/filtrationside
	name = "过滤设施"
	icon = 'icons/turf/floors/filtration.dmi'
	icon_state = "filtrationside"

/turf/open/floor/filtrationside/is_plasteel_floor()
	return FALSE

/turf/open/floor/filtrationside/southwest
	dir = SOUTHWEST

/turf/open/floor/filtrationside/north
	dir = NORTH

/turf/open/floor/filtrationside/east
	dir = EAST

/turf/open/floor/filtrationside/northeast
	dir = NORTHEAST

/turf/open/floor/filtrationside/southeast
	dir = SOUTHEAST

/turf/open/floor/filtrationside/west
	dir = WEST

/turf/open/floor/filtrationside/northwest
	dir = NORTHWEST

/turf/open/floor/plating/catwalk/rusted
	icon = 'icons/turf/floors/filtration.dmi'
	icon_state = "grate"

/turf/open/floor/plating/catwalk/rusted/ex_act()
	return

/turf/open/floor/coagulation
	name = "混凝设施"
	icon = 'icons/turf/floors/coagulation.dmi'

/turf/open/floor/coagulation/is_plasteel_floor()
	return FALSE

/turf/open/floor/coagulation/icon0_0
	icon_state = "0,0"

/turf/open/floor/coagulation/icon0_4
	icon_state = "0,4"

/turf/open/floor/coagulation/icon0_5
	icon_state = "0,5"

/turf/open/floor/coagulation/icon0_8
	icon_state = "0,8"

/turf/open/floor/coagulation/icon1_1
	icon_state = "1,1"

/turf/open/floor/coagulation/icon1_7
	icon_state = "1,7"

/turf/open/floor/coagulation/icon2_0
	icon_state = "2,0"

/turf/open/floor/coagulation/icon4_8
	icon_state = "4,8"

/turf/open/floor/coagulation/icon5_8
	icon_state = "5,8"

/turf/open/floor/coagulation/icon6_8
	icon_state = "6,8"

/turf/open/floor/coagulation/icon6_8_2
	icon_state = "6,8-2"

/turf/open/floor/coagulation/icon7_0
	icon_state = "7,0"

/turf/open/floor/coagulation/icon7_1
	icon_state = "7,1"

/turf/open/floor/coagulation/icon7_7
	icon_state = "7,7"

/turf/open/floor/coagulation/icon7_7_2
	icon_state = "7,7-2"

/turf/open/floor/coagulation/icon7_8
	icon_state = "7,8"

/turf/open/floor/coagulation/icon7_8_2
	icon_state = "7,8-2"

/turf/open/floor/coagulation/icon8_0
	icon_state = "8,0"

/turf/open/floor/coagulation/icon8_3
	icon_state = "8,3"

/turf/open/floor/coagulation/icon8_4
	icon_state = "8,4"

/turf/open/floor/coagulation/icon8_6
	icon_state = "8,6"

/turf/open/floor/coagulation/icon8_7
	icon_state = "8,7"

/turf/open/floor/coagulation/icon8_7_2
	icon_state = "8,7-2"

/turf/open/floor/coagulation/icon8_8
	icon_state = "8,8"

/obj/structure/filtration/coagulation
	name = "混凝设施"
	icon = 'icons/turf/floors/coagulation.dmi'



/obj/structure/filtration
	unslashable = TRUE
	unacidable = TRUE
/*
/obj/structure/filtration
	icon = 'icons/obj/filtration/96x96.dmi'
	bound_x = 96
	bound_y = 96
	density = TRUE


/obj/structure/prop/almayer/anti_air_cannon
	name = "\improper Anti-air Cannon"
	desc = "An anti-air cannon for shooting spaceships. It looks broken."
	icon = 'icons/effects/128x128.dmi'
	icon_state = "anti_air_cannon"
	density = TRUE
	anchored = TRUE
	layer = LADDER_LAYER
	bound_width = 128
	bound_height = 64
	bound_y = 64
*/
/obj/structure/filtration
	name = "过滤设备"

/obj/structure/filtration/machine_32x32
	icon = 'icons/turf/floors/32x32.dmi'
	name = "过滤设备检修走道"
	//bound_x = 96
	//bound_y = 96
	density = FALSE
	anchored = TRUE
	bound_width = 32
	bound_height = 32

/obj/structure/filtration/machine_32x32/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_32x32/indestructible/ex_act(severity)
	return

/obj/structure/filtration/machine_32x64
	icon = 'icons/obj/structures/props/32x64.dmi'
	density = TRUE
	anchored = TRUE
	bound_width = 32
	bound_height = 64

/obj/structure/filtration/machine_32x64/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_32x64/indestructible/ex_act(severity)
	return

/obj/structure/filtration/machine_96x96
	icon = 'icons/obj/structures/props/96x96.dmi'
	//bound_x = 96
	//bound_y = 96
	density = TRUE
	anchored = TRUE
	bound_width = 96
	bound_height = 96

/obj/structure/filtration/machine_96x96/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_96x96/indestructible/ex_act(severity)
	return

/obj/structure/filtration/machine_64x96
	icon = 'icons/obj/structures/props/64x96.dmi'
	//bound_x = 96
	//bound_y = 96
	density = TRUE
	anchored = TRUE
	bound_width = 64
	bound_height = 96

/obj/structure/filtration/machine_64x96/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_64x96/indestructible/ex_act(severity)
	return

/obj/structure/filtration/machine_64x128
	icon = 'icons/obj/structures/props/64x128.dmi'
	//bound_x = 96
	//bound_y = 96
	density = TRUE
	anchored = TRUE
	bound_width = 64
	bound_height = 128

/obj/structure/filtration/machine_64x128/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_64x128/indestructible/ex_act(severity)
	return

/obj/structure/filtration/coagulation_arm
	name = "混凝搅拌臂"
	desc = "一根带四面搅拌臂的转轴，旋转时可辅助净化水体。"
	density = TRUE
	icon = 'icons/obj/structures/props/coagulation_arm.dmi'
	icon_state = "arm"
	layer = ABOVE_MOB_LAYER + 0.1
	bound_width = 96
	bound_height = 96

/obj/structure/filtration/flacculation_arm
	name = "絮凝搅拌臂"
	desc = "装在转轴上的长金属过滤杆，通过旋转促进絮凝。"
	density = TRUE
	icon = 'icons/obj/structures/props/flacculation_arm.dmi'
	icon_state = "flacculation_arm"
	bound_height = 32
	bound_width = 128
	layer = ABOVE_MOB_LAYER + 0.1

/obj/structure/filtration/collector_pipes
	name = "集水管道"
	desc = "一组从河流取水并将其送至净水厂过滤的管道。"
	icon = 'icons/obj/structures/props/pipes.dmi'
	icon_state = "upper_1" //use instances to set the types.
	bound_height = 32
	bound_width = 64

/obj/structure/filtration/machine_96x96
	icon = 'icons/obj/structures/props/96x96.dmi'

/obj/structure/filtration/machine_96x96/distribution
	name = "废物分配系统"
	desc = "这台设备将净化过程中产生的残余废物分类，以便丢弃到太空、回收成物资或用于研究。"
	icon_state = "distribution"

/obj/structure/filtration/machine_96x96/sedimentation
	name = "沉积物过滤器"
	desc = "专门滤除水中沙粒、淤泥、污垢和铁锈等沉积物的净水器，同时保留有益矿物质，让每一口水都清冽纯净。"
	icon_state = "sedimentation"

/obj/structure/filtration/machine_96x96/filtration
	name = "水体过滤系统"
	desc = "从水中分离有机物、无机物、有害废物及腐蚀性酸液的过滤设备，以便进一步处理。"
	icon_state = "filtration"

/obj/structure/filtration/machine_96x96/disinfection
	name = "消毒过滤器"
	desc = "专门滤除水中病毒、细菌等微生物的净水器。"
	icon_state = "disinfection"
