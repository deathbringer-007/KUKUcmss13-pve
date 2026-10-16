/obj/structure/weapons_loader
	name = "弹药装填机"
	desc = "一台笨重的机械，负责分拣、搬运各类弹药，并将其装填至对应的武器中。"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "weapons_loader"

	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	var/obj/vehicle/multitile/vehicle = null

// Loading new magazines
/obj/structure/weapons_loader/attackby(obj/item/I, mob/user)
	if(!istype(I, /obj/item/ammo_magazine/hardpoint))
		return ..()

	if(!skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_LARGE))
		to_chat(user, SPAN_NOTICE("你完全不知道该怎么操作这东西！"))
		return

	// Check if any of the hardpoints accept the magazine
	var/obj/item/hardpoint/reloading_hardpoint = null
	for(var/obj/item/hardpoint/H in vehicle.get_hardpoints_with_ammo())
		if(QDELETED(H) || QDELETED(H.ammo))
			continue

		if(istype(I, H.ammo.type))
			reloading_hardpoint = H
			break

	if(isnull(reloading_hardpoint))
		return ..()

	// Reload the hardpoint
	reloading_hardpoint.try_add_clip(I, user)

// Hardpoint reloading
/obj/structure/weapons_loader/attack_hand(mob/living/carbon/human/user)

	if(!user || !istype(user))
		return

	handle_reload(user)

/obj/structure/weapons_loader/proc/reload_ammo()
	set name = "装填弹药"
	set category = "物品"
	set src in range(1)

	var/mob/living/carbon/human/H = usr
	if(!H || !istype(H))
		return

	handle_reload(H)

/obj/structure/weapons_loader/proc/handle_reload(mob/living/carbon/human/user)

	//something went bad, try to reconnect to vehicle if user is currently buckled in and connected to vehicle
	if(!vehicle)
		if(isVehicle(user.interactee))
			vehicle = user.interactee
		if(!istype(vehicle))
			to_chat(user, SPAN_WARNING("严重错误！请通过管理员求助报告此问题！错误代码：T_VMIS"))
			return

	var/list/hps = vehicle.get_hardpoints_with_ammo()

	if(!skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_LARGE))
		to_chat(user, SPAN_NOTICE("你完全不知道该怎么操作这东西！"))
		return

	if(!LAZYLEN(hps))
		to_chat(user, SPAN_WARNING("没有可以装填弹药的挂载模块！"))
		return

	var/chosen_hp = tgui_input_list(usr, "选择挂载模块", "挂载模块菜单", (hps + "取消"))
	if(chosen_hp == "取消")
		return

	var/obj/item/hardpoint/HP = chosen_hp

	// If someone removed the hardpoint while their dialogue was open or something
	if(QDELETED(HP))
		to_chat(user, SPAN_WARNING("错误！未找到模块！"))
		return

	if(!LAZYLEN(HP.backup_clips))
		to_chat(user, SPAN_WARNING("[HP]没有剩余备用弹匣！"))
		return

	var/obj/item/ammo_magazine/M = LAZYACCESS(HP.backup_clips, 1)
	if(!M)
		to_chat(user, SPAN_DANGER("发生错误！请通过管理员求助报告此问题！错误代码：T_BMIS"))
		return

	to_chat(user, SPAN_NOTICE("你开始为[HP]装填弹药。"))

	if(!do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		to_chat(user, SPAN_WARNING("你为[HP]装填弹药的动作被打断了。"))
		return

	HP.ammo.forceMove(get_turf(src))
	HP.ammo.update_icon()
	HP.ammo = M
	LAZYREMOVE(HP.backup_clips, M)

	playsound(loc, 'sound/machines/hydraulics_3.ogg', 50)
	to_chat(user, SPAN_NOTICE("你为[HP]装填了弹药。弹药：<b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)]</b> | 弹匣：<b>[SPAN_HELPFUL(LAZYLEN(HP.backup_clips))]/[SPAN_HELPFUL(HP.max_clips)]</b>"))
