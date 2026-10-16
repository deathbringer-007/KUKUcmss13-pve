// the power monitoring computer
// for the moment, just report the status of all APCs in the same powernet
/obj/structure/machinery/power/monitor
	name = "电力监控计算机"
	desc = "用于监测整个空间站的电力状况。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "power"

	//computer stuff
	density = TRUE
	anchored = TRUE
	var/circuit = /obj/item/circuitboard/computer/powermonitor
	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	active_power_usage = 300

/obj/structure/machinery/power/monitor/attack_remote(mob/user)
	add_fingerprint(user)

	if(inoperable())
		return
	interact(user)

/obj/structure/machinery/power/monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(inoperable())
		return
	interact(user)

/obj/structure/machinery/power/monitor/interact(mob/user)

	if ( (get_dist(src, user) > 1 ) || (inoperable()) )
		if (!isRemoteControlling(user))
			user.unset_interaction()
			close_browser(user, "powcomp")
			return


	user.set_interaction(src)
	var/t = "<TT>"

	t += "<BR><HR><A href='byond://?src=\ref[src];update=1'>刷新</A>"
	t += "<BR><HR><A href='byond://?src=\ref[src];close=1'>关闭</A>"

	if(!powernet)
		t += SPAN_DANGER("未连接")
	else

		var/list/L = list()
		for(var/obj/structure/machinery/power/terminal/term in powernet.nodes)
			if(istype(term.master, /obj/structure/machinery/power/apc))
				var/obj/structure/machinery/power/apc/A = term.master
				L += A

		t += "<PRE>总供电：[powernet.avail] W<BR>总负载：[num2text(powernet.viewload,10)] W<BR>"

		t += "<FONT SIZE=-1>"

		if(length(L) > 0)
			var/total_demand = 0
			t += "区域    设备／照明／环境  负载   电池<HR>"

			var/list/S = list("关闭","自动关","开启", "自动开")
			var/list/chg = list("未充电","充电中","已充满")

			for(var/obj/structure/machinery/power/apc/A in L)

				t += copytext_char(add_tspace("[A.area]", 30), 1, 30)
				t += " [S[A.equipment+1]] [S[A.lighting+1]] [S[A.environ+1]] [add_lspace(A.lastused_total, 6)]  [A.cell ? "[add_lspace(floor(A.cell.percent()), 3)]% [chg[A.charging+1]]" : "未连接"]<BR>"
				total_demand += A.lastused_total

			t += "<HR>总需求：[total_demand] W</FONT>"
		t += "</PRE></TT>"

	show_browser(user, t, "电力监控", "powcomp", width = 420, height = 900)


/obj/structure/machinery/power/monitor/Topic(href, href_list)
	..()
	if( href_list["close"] )
		close_browser(usr, "powcomp")
		usr.unset_interaction()
		return
	if( href_list["update"] )
		src.updateDialog()
		return


/obj/structure/machinery/power/monitor/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "broken"
	else
		if (stat & NOPOWER)
			spawn(rand(0, 15))
				src.icon_state = "power0"
		else
			icon_state = initial(icon_state)


//copied from computer.dm
/obj/structure/machinery/power/monitor/attackby(obj/item/I, user as mob)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER) && circuit)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
		if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			var/obj/structure/computerframe/A = new( src.loc )
			var/obj/item/circuitboard/computer/M = new circuit( A )
			A.circuit = M
			A.anchored = TRUE
			for (var/obj/C in src)
				C.forceMove(src.loc)
			if (src.stat & BROKEN)
				to_chat(user, SPAN_NOTICE("碎玻璃掉了出来。"))
				new /obj/item/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				to_chat(user, SPAN_NOTICE("你断开了监视器的连接。"))
				A.state = 4
				A.icon_state = "4"
			M.deconstruct(src)
			qdel(src)
	else
		src.attack_hand(user)
	return
