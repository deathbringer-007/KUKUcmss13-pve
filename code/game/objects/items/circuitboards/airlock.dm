
/obj/item/circuitboard/airlock
	name = "气闸门电子组件"
	gender = PLURAL
	icon_state = "door_electronics"
	w_class = SIZE_SMALL
	matter = list("metal" = 50,"glass" = 50)
	req_access = list(ACCESS_CIVILIAN_ENGINEERING)
	var/list/conf_access = null
	/// if set to 1, door would receive req_one_access instead of req_access
	var/one_access = 0
	var/last_configurator = null
	var/locked = 1
	var/fried = FALSE

/obj/item/circuitboard/airlock/update_icon()
	. = ..()
	if(fried)
		icon_state = "door_electronics_smoked"

/obj/item/circuitboard/airlock/attack_self(mob/user as mob)
	if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	var/mob/living/carbon/human/H = user
	if(H.getBrainLoss() >= 60)
		return

	var/t1


	if (last_configurator)
		t1 += "操作员：[last_configurator]<br>"

	if (locked)
		t1 += "<a href='byond://?src=\ref[src];login=1'>刷身份卡</a><hr>"
	else
		t1 += "<a href='byond://?src=\ref[src];logout=1'>锁定</a><hr>"

		t1 += "权限要求设为："
		t1 += one_access ? "<a style='color: green' href='byond://?src=\ref[src];one_access=1'>任意一项</a><hr>" : "<a style='color: red' href='byond://?src=\ref[src];one_access=1'>全部满足</a><hr>"

		t1 += conf_access == null ? "<font color=red>全部</font><br>" : "<a href='byond://?src=\ref[src];access=all'>全部</a><br>"

		t1 += "<br>"

		var/list/accesses = get_access(ACCESS_LIST_MARINE_ALL)
		for (var/acc in accesses)
			var/aname = get_access_desc(acc)

			if (!LAZYLEN(conf_access) || !(acc in conf_access))
				t1 += "<a href='byond://?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else if(one_access)
				t1 += "<a style='color: green' href='byond://?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else
				t1 += "<a style='color: red' href='byond://?src=\ref[src];access=[acc]'>[aname]</a><br>"

	t1 += text("<p><a href='byond://?src=\ref[];close=1'>关闭</a></p>\n", src)

	show_browser(user, t1, "门禁控制", "airlock_electronics")
	onclose(user, "airlock_electronics")


/obj/item/circuitboard/airlock/Topic(href, href_list)
	..()
	if (usr.stat || usr.is_mob_restrained() || (!ishuman(usr) && !istype(usr,/mob/living/silicon)))
		return
	if (href_list["close"])
		close_browser(usr, "airlock")
		return

	if (href_list["login"])
		if(istype(usr,/mob/living/silicon))
			src.locked = 0
			src.last_configurator = usr.name
		else
			var/obj/item/I = usr.get_active_hand()
			if (I && src.check_access(I))
				src.locked = 0
				src.last_configurator = I:registered_name

	if (locked)
		return

	if (href_list["logout"])
		locked = 1

	if (href_list["one_access"])
		one_access = !one_access

	if (href_list["access"])
		toggle_access(href_list["access"])

	attack_self(usr)


/obj/item/circuitboard/airlock/proc/toggle_access(acc)
	if (acc == "all")
		conf_access = null
	else
		var/req = text2num(acc)

		if (conf_access == null)
			conf_access = list()

		if (!(req in conf_access))
			conf_access += req
		else
			conf_access -= req
			if (!length(conf_access))
				conf_access = null


/obj/item/circuitboard/airlock/secure
	name = "安全型气闸门电子组件"
	desc = "经过特殊设计，比标准电子组件更能抵抗入侵。"
