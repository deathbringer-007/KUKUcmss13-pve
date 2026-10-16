/obj/structure/machinery/compressor
	name = "压气机"
	desc = "燃气轮机发电机的压气机段。"
	icon = 'icons/obj/pipes/pipes3.dmi'
	icon_state = "compressor"
	anchored = TRUE
	density = TRUE
	var/obj/structure/machinery/power/turbine/turbine
	var/turf/inturf
	var/starter = 0
	var/rpm = 0
	var/rpmtarget = 0
	var/capacity = 1e6
	var/comp_id = 0

/obj/structure/machinery/power/turbine
	name = "燃气轮机发电机"
	desc = "用于备用发电的燃气轮机。"
	icon = 'icons/obj/pipes/pipes3.dmi'
	icon_state = "turbine"
	anchored = TRUE
	density = TRUE
	var/obj/structure/machinery/compressor/compressor
	directwired = 1
	var/turf/outturf
	var/lastgen

/obj/structure/machinery/computer/turbine_computer
	name = "燃气轮机控制计算机"
	desc = "用于远程控制燃气轮机的计算机。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "turbinecomp"
	circuit = /obj/item/circuitboard/computer/turbine_control
	anchored = TRUE
	density = TRUE
