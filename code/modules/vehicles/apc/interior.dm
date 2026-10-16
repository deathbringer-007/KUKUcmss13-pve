// APC interior stuff

//wall

/obj/structure/interior_wall/Initialize()
	. = ..()

	if(loc.opacity)
		loc.opacity = FALSE

/obj/structure/interior_wall/apc
	name = "\improper 装甲输送车内壁"
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "apc_right_1"

/obj/structure/interior_exit/vehicle/apc
	name = "装甲输送车侧门"
	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "exit_door"

/obj/structure/interior_exit/vehicle/apc/rear
	name = "装甲输送车后舱门"
	icon_state = "door_rear_center"

/obj/structure/interior_exit/vehicle/apc/rear/left
	icon_state = "door_rear_left"

/obj/structure/interior_exit/vehicle/apc/rear/right
	icon_state = "door_rear_right"

/obj/structure/interior_exit/vehicle/arc
	name = "装甲侦察车侧门"
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "exit_door"

/obj/structure/prop/vehicle
	name = "Generic vehicle prop"
	desc = "Adds more flavour to vehicle interior."

	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = ""

	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE
	indestructible = TRUE

/obj/structure/prop/vehicle/arc
	name = "装甲侦察车底盘"

	icon = 'icons/obj/vehicles/interiors/arc_chassis.dmi'
	icon_state = "arc_chassis"


/obj/structure/prop/vehicle/firing_port_weapon
	name = "M56射击孔武器握把"
	desc = "改装M56B智能机枪的控制握把。这种机枪安装在M577装甲输送车两侧，作为射击孔武器，\
	供支援机枪手掩护从侧门进出车辆的友军步兵。\
	为便于使用，右侧射击孔采用绿色标记，左侧采用红色标记。\
	别误会，这并非真正武器的一部分，而是做成陆战队员熟悉外形的操纵杆。"

	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "m56_FPW"

	density = FALSE

	var/obj/structure/bed/chair/comfy/vehicle/support_gunner/SG_seat

/obj/structure/prop/vehicle/firing_port_weapon/get_examine_text(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	if(!SG_seat)
		SG_seat = locate() in get_turf(src)
		if(!SG_seat)
			. += SPAN_WARNING("发生错误！找不到座椅，请向开发者报告！")
			return
	for(var/obj/item/hardpoint/special/firing_port_weapon/FPW in SG_seat.vehicle.hardpoints)
		if(FPW.allowed_seat == SG_seat.seat)
			if(FPW.ammo)
				. += SPAN_NOTICE("[FPW.name]的弹药量为：[SPAN_HELPFUL(FPW.ammo.current_rounds)]/[SPAN_WARNING(FPW.ammo.max_rounds)]。")
				break
	. += SPAN_HELPFUL("站在支援机枪手座椅旁点击[name]，即可入座并操控M56射击孔武器。")

/obj/structure/prop/vehicle/firing_port_weapon/attack_hand(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(!SG_seat)
		SG_seat = locate() in get_turf(src)
		if(!SG_seat)
			to_chat(H, SPAN_WARNING("发生错误！找不到座椅，请向开发者报告！"))
			return
	if(!SG_seat.buckled_mob && !H.buckled)
		SG_seat.do_buckle(H, H)
		for(var/obj/item/hardpoint/special/firing_port_weapon/FPW in SG_seat.vehicle.hardpoints)
			if(FPW.allowed_seat == SG_seat.seat)
				if(FPW.ammo)
					to_chat(H, SPAN_NOTICE("[FPW.name]的弹药量为：[SPAN_HELPFUL(FPW.ammo.current_rounds)]/[SPAN_WARNING(FPW.ammo.max_rounds)]。"))
					break
		return

/obj/structure/prop/vehicle/sensor_equipment
	name = "数据分析枢纽"
	desc = "这台设备收集并分析M577指挥装甲输送车传感器组的数据，再将结果传送至阿尔迈耶号的战术地图显示网络。最好别碰。"

	icon = 'icons/obj/vehicles/interiors/apc.dmi'
	icon_state = "sensors_equipment"
