/obj/item/clothing/suit/marine/medium/rto/md
	name = "\improper XM4型情报官护甲"
	specialty = "XM4型情报"
	desc = "比钢铁更坚固，比低语更安静。XM4情报护甲将可靠的防护与实验型内置运动追踪器融为一体。研发团队花了一个周末完成设计，造价比奇努克空间站还高……大概吧。"
	desc_lore = "阿玛特，精益求精。XM4士兵态势感知系统将M4式硬质护甲与分布在胸甲上的运动传感器结合起来。连接任意抬头显示光学设备后，即可实现M314运动探测器的功能，提升使用者的环境感知能力。目前正由情报人员进行实地试用。"
	/// XM4 Integral Motion Detector Ability
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/intel/toggle_motion_detector)
	var/motion_detector = FALSE
	var/obj/item/device/motiondetector/xm4/proximity
	var/long_range_cooldown = 2
	var/recycletime = 120

/obj/item/clothing/suit/marine/medium/rto/md/Initialize(mapload, ...)
	. = ..()
	proximity = new(src)
	update_icon()

/obj/item/clothing/suit/marine/medium/rto/md/Destroy()
	QDEL_NULL(proximity)
	return ..()

/datum/action/item_action/intel/action_activate()
	. = ..()
	if(!ishuman(owner))
		return

/datum/action/item_action/intel/update_button_icon()
	return

/datum/action/item_action/intel/toggle_motion_detector/New(Target, obj/item/holder)
	. = ..()
	name = "开关运动探测器"
	action_icon_state = "motion_detector"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/intel/toggle_motion_detector/action_activate()
	. = ..()
	var/obj/item/clothing/suit/marine/medium/rto/md/recon = holder_item
	recon.toggle_motion_detector(owner)

/datum/action/item_action/intel/toggle_motion_detector/proc/update_icon()
	if(!holder_item)
		return
	var/obj/item/clothing/suit/marine/medium/rto/md/recon = holder_item
	if(recon.motion_detector)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

/obj/item/clothing/suit/marine/medium/rto/md/process()
	if(!motion_detector)
		STOP_PROCESSING(SSobj, src)
	if(motion_detector)
		recycletime--
		if(!recycletime)
			recycletime = initial(recycletime)
			proximity.refresh_blip_pool()
		long_range_cooldown--
		if(long_range_cooldown)
			return
		long_range_cooldown = initial(long_range_cooldown)
		proximity.scan()

/obj/item/clothing/suit/marine/medium/rto/md/proc/toggle_motion_detector(mob/user)
	to_chat(user,SPAN_NOTICE("你[motion_detector? "<B>关闭</b>" : "<B>开启</b>"]了[src]的运动探测器。"))
	if(!motion_detector)
		playsound(loc,'sound/items/detector_turn_on.ogg', 25, 1)
	else
		playsound(loc,'sound/items/detector_turn_off.ogg', 25, 1)
	motion_detector = !motion_detector
	var/datum/action/item_action/intel/toggle_motion_detector/TMD = locate(/datum/action/item_action/intel/toggle_motion_detector) in actions
	TMD.update_icon()
	motion_detector()

/obj/item/clothing/suit/marine/medium/rto/md/proc/motion_detector()
	if(motion_detector)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/suit/marine/medium/rto/md/army
	name = "\improper Mk2个人防弹护甲系统"
	desc = "个人防弹护甲系统的实验改进型，将可靠的防护与内置运动追踪器结合起来。"
	desc_lore = "阿玛特，精益求精。士兵态势感知计划将M4式硬质护甲与分布在胸甲上的运动传感器结合起来。连接任意抬头显示光学设备后，即可实现M314运动探测器的功能，提升使用者的环境感知能力。目前正由情报人员以及因工作职责而无法时刻留意周围环境的人员进行实地试用。"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/marine/medium/rto/md/army/Initialize(mapload, ...)
	. = ..()
	proximity = new(src)
	var/obj/item/clothing/accessory/pads/groin/crotchplate = new()
	src.attach_accessory(null, crotchplate, TRUE)
	var/obj/item/clothing/accessory/pads/greaves/shinguards = new()
	src.attach_accessory(null, shinguards, TRUE)
	var/obj/item/clothing/accessory/pads/shoulderpads = new()
	src.attach_accessory(null, shoulderpads, TRUE)
	var/obj/item/clothing/accessory/pads/bracers/armguards = new()
	src.attach_accessory(null, armguards, TRUE)
	var/obj/item/clothing/accessory/pads/kneepads/knees = new()
	src.attach_accessory(null, knees, TRUE)
	update_icon()
