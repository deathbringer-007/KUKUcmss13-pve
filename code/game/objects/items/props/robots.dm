/obj/item/broken_device
	name = "损坏的组件"
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "broken"

/obj/item/robot_parts/robot_component
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "working"

/obj/item/robot_parts/robot_component/binary_communication_device
	name = "二进制通讯装置"
	icon_state = "binradio"

/obj/item/robot_parts/robot_component/actuator
	name = "执行器"
	icon_state = "motor"

/obj/item/robot_parts/robot_component/armour
	name = "装甲板"
	icon_state = "armor"

/obj/item/robot_parts/robot_component/camera
	name = "摄像头"
	icon_state = "camera"

/obj/item/robot_parts/robot_component/diagnosis_unit
	name = "诊断单元"
	icon_state = "analyser"

/obj/item/robot_parts/robot_component/radio
	name = "无线电"
	icon_state = "radio"

/obj/item/device/robotanalyzer
	name = "赛博格分析仪"
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "能够诊断机器人损伤的手持扫描仪。看起来坏了。"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	throwforce = 3
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	matter = list("metal" = 200)
