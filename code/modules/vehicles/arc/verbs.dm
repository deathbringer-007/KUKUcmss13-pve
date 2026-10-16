/obj/vehicle/multitile/arc/proc/toggle_antenna(mob/toggler)
	set name = "升降传感器天线"
	set desc = "升起或降下外部传感器天线。天线升起时，装甲侦察车无法移动。"
	set category = "载具"

	var/mob/user = toggler || usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/arc/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	if(vehicle.health < initial(vehicle.health) * 0.5)
		to_chat(user, SPAN_WARNING("[vehicle]的车体损坏过于严重，无法操作！"))
		return

	var/obj/item/hardpoint/support/arc_antenna/antenna = locate() in vehicle.hardpoints
	if(!antenna)
		to_chat(user, SPAN_WARNING("[vehicle]没有安装天线！"))
		return

	if(antenna.deploying)
		return

	if(antenna.health <= 0)
		to_chat(user, SPAN_WARNING("[antenna]已经损坏！"))
		return

	if(vehicle.antenna_deployed)
		to_chat(user, SPAN_NOTICE("你开始收回[antenna]……"))
		antenna.deploying = TRUE
		if(!do_after(user, max(vehicle.antenna_toggle_time - antenna.deploy_animation_time, 1 SECONDS), target = vehicle))
			to_chat(user, SPAN_NOTICE("你停止了收回[antenna]。"))
			antenna.deploying = FALSE
			return

		antenna.retract_antenna()
		addtimer(CALLBACK(vehicle, PROC_REF(finish_antenna_retract), user), antenna.deploy_animation_time)

	else
		to_chat(user, SPAN_NOTICE("你开始展开[antenna]……"))
		antenna.deploying = TRUE
		if(!do_after(user, max(vehicle.antenna_toggle_time - antenna.deploy_animation_time, 1 SECONDS), target = vehicle))
			to_chat(user, SPAN_NOTICE("你停止了展开[antenna]。"))
			antenna.deploying = FALSE
			return

		antenna.deploy_antenna()
		addtimer(CALLBACK(vehicle, PROC_REF(finish_antenna_deploy), user), antenna.deploy_animation_time)

/obj/vehicle/multitile/arc/proc/finish_antenna_retract(mob/user)
	var/obj/item/hardpoint/support/arc_antenna/antenna = locate() in hardpoints
	if(!antenna)
		antenna.deploying = FALSE
		return

	if(user)
		to_chat(user, SPAN_NOTICE("你收回了[antenna]，装甲侦察车可以再次移动了。"))
		playsound(user, 'sound/machines/hydraulics_2.ogg', 80, TRUE)
	antenna_deployed = !antenna_deployed
	antenna.deploying = FALSE
	update_icon()
	SEND_SIGNAL(src, COMSIG_ARC_ANTENNA_TOGGLED)

/obj/vehicle/multitile/arc/proc/finish_antenna_deploy(mob/user)
	var/obj/item/hardpoint/support/arc_antenna/antenna = locate() in hardpoints
	if(!antenna)
		antenna.deploying = FALSE
		return

	if(user)
		to_chat(user, SPAN_NOTICE("你展开了[antenna]，装甲侦察车被固定在原地。"))
		playsound(user, 'sound/machines/hydraulics_2.ogg', 80, TRUE)
	antenna_deployed = !antenna_deployed
	antenna.deploying = FALSE
	update_icon()
	SEND_SIGNAL(src, COMSIG_ARC_ANTENNA_TOGGLED)

/obj/vehicle/multitile/arc/proc/open_arc_controls_guide()
	set name = "车辆操作指南"
	set desc = "首次扮演车组成员或版本更新后必读。"
	set category = "载具"

	var/mob/user = usr
	if(!istype(user))
		return

	var/obj/vehicle/multitile/arc/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	var/dat = "<b><i>通用操作：</i></b><br>\
	1. <b>“G：命名载具”</b>——为载具添加自定义名称。只能使用一次，最多26个字符。<br> \
	2. <b>“I：查看状态信息”</b>——打开“载具状态信息”窗口，查看载具的全部可用信息。<br> \
	3. <b>“G：升降传感器天线”</b>——展开或收回装甲侦察车的传感器天线。展开时，所有人都能在战术地图上看到大范围内的未知生命体，但车辆无法移动。还会启用RE700自动炮。<br> \
	<font color='#cd6500'><b><i>驾驶员操作：</i></b></font><br> 1. <b>“G：鸣笛”</b>——启动载具喇叭。请注意，喇叭非常响，远处的敌我双方都能听到。<br> \
	2. <b>“G：切换车门锁”</b>——切换载具的出入权限限制。车组、禁闭室及指挥权限可绕过限制。<br> \
	<font color='#cd6500'><b><i>驾驶员快捷键：</i></b></font><br> 1. <b>“CTRL + 单击”</b>——鸣笛。<br>"

	show_browser(user, dat, "车辆操作指南", "vehicle_help", width = 900, height = 500)
	onclose(user, "vehicle_help")
	return
