/obj/structure/interior_viewport
	name = "外部摄像头终端"
	desc = "连接载具外部摄像头的小型终端，可以全方位观察载具周围的情况。"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "viewport"
	layer = INTERIOR_DOOR_LAYER

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	// The vehicle this seat is tied to
	var/obj/vehicle/multitile/vehicle = null

/obj/structure/interior_viewport/ex_act()
	return

/obj/structure/interior_viewport/attack_hand(mob/M)
	if(!vehicle)
		return

	M.reset_view(vehicle)
	give_action(M, /datum/action/human_action/vehicle_unbuckle)

/obj/structure/interior_viewport/simple
	name = "观察窗"
	desc = "嘿，从这里能看到我的基地！"
	icon_state = "viewport_simple"

//van's frontal window viewport
/obj/structure/interior_viewport/simple/windshield
	name = "挡风玻璃"
	desc = "上次擦洗是什么时候了？角落里还粘着一只压扁的虫子。"
	icon = 'icons/obj/vehicles/interiors/van.dmi'
	icon_state = "windshield_viewport_top"
	alpha = 80

//anti-air APC's interior console
/obj/structure/interior_viewport/terminal
	name = "外部摄像头终端"
	desc = "连接 M579 ADS-C 各类传感器的终端，配有大量闪烁的按钮和鸣响的警报器，以及一套较为简陋的外部观测系统。"
	icon_state = "viewport_terminal"

/obj/structure/interior_viewport/terminal/tank
	name = "指挥控制终端"
	desc = "连接 M579 ADS-C 各类传感器的终端，配有大量闪烁的按钮和鸣响的警报器，以及一套较为简陋的外部观测系统。"
