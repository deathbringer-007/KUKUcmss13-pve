/obj/structure/machinery/pipedispenser
	name = "管道分配机"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	desc = "用于提供管道的大型机器，由螺栓固定在地面上，拧松螺栓后便可移动。"
	icon_state = "pipe_d"
	density = TRUE
	anchored = TRUE
	var/unwrenched = 0
	var/wait = 0

/obj/structure/machinery/pipedispenser/attack_hand(user as mob)
	if(..())
		return
///// Z-Level stuff
	var/dat = {"
<b>普通管道：</b><BR>
<A href='byond://?src=\ref[src];make=0;dir=1'>直管</A><BR>
<A href='byond://?src=\ref[src];make=1;dir=5'>弯管</A><BR>
<A href='byond://?src=\ref[src];make=5;dir=1'>三通管</A><BR>
<A href='byond://?src=\ref[src];make=8;dir=1'>手动阀</A><BR>
<A href='byond://?src=\ref[src];make=20;dir=1'>管帽</A><BR>
<A href='byond://?src=\ref[src];make=19;dir=1'>四通管</A><BR>
<A href='byond://?src=\ref[src];make=18;dir=1'>手动三通阀</A><BR>
<A href='byond://?src=\ref[src];make=21;dir=1'>向上管道</A><BR>
<A href='byond://?src=\ref[src];make=22;dir=1'>向下管道</A><BR>
<b>供气管道：</b><BR>
<A href='byond://?src=\ref[src];make=29;dir=1'>直管</A><BR>
<A href='byond://?src=\ref[src];make=30;dir=5'>弯管</A><BR>
<A href='byond://?src=\ref[src];make=33;dir=1'>三通管</A><BR>
<A href='byond://?src=\ref[src];make=41;dir=1'>管帽</A><BR>
<A href='byond://?src=\ref[src];make=35;dir=1'>四通管</A><BR>
<A href='byond://?src=\ref[src];make=37;dir=1'>向上管道</A><BR>
<A href='byond://?src=\ref[src];make=39;dir=1'>向下管道</A><BR>
<b>排气管道：</b><BR>
<A href='byond://?src=\ref[src];make=31;dir=1'>直管</A><BR>
<A href='byond://?src=\ref[src];make=32;dir=5'>弯管</A><BR>
<A href='byond://?src=\ref[src];make=34;dir=1'>三通管</A><BR>
<A href='byond://?src=\ref[src];make=42;dir=1'>管帽</A><BR>
<A href='byond://?src=\ref[src];make=36;dir=1'>四通管</A><BR>
<A href='byond://?src=\ref[src];make=38;dir=1'>向上管道</A><BR>
<A href='byond://?src=\ref[src];make=40;dir=1'>向下管道</A><BR>
<b>设备：</b><BR>
<A href='byond://?src=\ref[src];make=28;dir=1'>通用管道转接器</A><BR>
<A href='byond://?src=\ref[src];make=4;dir=1'>连接接口</A><BR>
<A href='byond://?src=\ref[src];make=7;dir=1'>单口通风口</A><BR>
<A href='byond://?src=\ref[src];make=9;dir=1'>气泵</A><BR>
<A href='byond://?src=\ref[src];make=15;dir=1'>压力调节器</A><BR>
<A href='byond://?src=\ref[src];make=16;dir=1'>高功率气泵</A><BR>
<A href='byond://?src=\ref[src];make=10;dir=1'>排气口</A><BR>
<A href='byond://?src=\ref[src];makemeter=1'>压力表</A><BR>
<A href='byond://?src=\ref[src];make=13;dir=1'>气体过滤器</A><BR>
<A href='byond://?src=\ref[src];make=23;dir=1'>气体过滤器（镜像）</A><BR>
<A href='byond://?src=\ref[src];make=14;dir=1'>气体混合器</A><BR>
<A href='byond://?src=\ref[src];make=25;dir=1'>气体混合器（镜像）</A><BR>
<A href='byond://?src=\ref[src];make=24;dir=1'>气体混合器（三通）</A><BR>
<A href='byond://?src=\ref[src];make=26;dir=1'>全向气体混合器</A><BR>
<A href='byond://?src=\ref[src];make=27;dir=1'>全向气体过滤器</A><BR>
<b>热交换：</b><BR>
<A href='byond://?src=\ref[src];make=2;dir=1'>直管</A><BR>
<A href='byond://?src=\ref[src];make=3;dir=5'>弯管</A><BR>
<A href='byond://?src=\ref[src];make=6;dir=1'>三通接头</A><BR>
<A href='byond://?src=\ref[src];make=17;dir=1'>热交换器</A><BR>
<b>隔热管道：</b><BR>
<A href='byond://?src=\ref[src];make=11;dir=1'>直管</A><BR>
<A href='byond://?src=\ref[src];make=12;dir=5'>弯管</A><BR>

"}
///// Z-Level stuff
//What number the make points to is in the define # at the top of construction.dm in same folder

	show_browser(user, dat, name, "pipedispenser")
	onclose(user, "pipedispenser")
	return

/obj/structure/machinery/pipedispenser/Topic(href, href_list)
	if(..())
		return
	if(unwrenched || usr.is_mob_incapacitated() || !in_range(loc, usr))
		close_browser(usr, "pipedispenser")
		return
	usr.set_interaction(src)
	src.add_fingerprint(usr)
	if(href_list["make"])
		if(!wait)
			var/p_type = text2num(href_list["make"])
			var/p_dir = text2num(href_list["dir"])
			var/obj/item/pipe/P = new (/*usr.loc*/ src.loc, p_type, p_dir)
			P.update()
			P.add_fingerprint(usr)
			wait = 1
			addtimer(VARSET_CALLBACK(src, wait, FALSE), 1 SECONDS)
	if(href_list["makemeter"])
		if(!wait)
			new /obj/item/pipe_meter(/*usr.loc*/ src.loc)
			wait = 1
			addtimer(VARSET_CALLBACK(src, wait, FALSE), 1.5 SECONDS)
	return

/obj/structure/machinery/pipedispenser/attackby(obj/item/W as obj, mob/user)
	src.add_fingerprint(usr)
	if (istype(W, /obj/item/pipe) || istype(W, /obj/item/pipe_meter))
		to_chat(usr, SPAN_NOTICE("你将[W]放回了[src]。"))
		user.drop_held_item()
		qdel(W)
		return
	else if (HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		if (unwrenched==0)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("你开始解除[src]与地面的固定……"))
			if (do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(
					"[user]解除了[src]的固定。",
					SPAN_NOTICE("你解除了[src]的固定，现在可以将它拖到其他地方。"),
					"你听见棘轮扳手的响声。")
				src.anchored = FALSE
				src.stat |= MAINT
				src.unwrenched = 1
				if (usr.interactee==src)
					close_browser(usr, "pipedispenser")
		else /*if (unwrenched==1)*/
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("你开始将[src]固定到地面上……"))
			if (do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				user.visible_message(
					"[user]固定了[src]。",
					SPAN_NOTICE("你固定了[src]，现在可以取用管道了。"),
					"你听见棘轮扳手的响声。")
				src.anchored = TRUE
				src.stat &= ~MAINT
				src.unwrenched = 0
				power_change()
	else
		return ..()

/obj/structure/machinery/pipedispenser/disposal
	name = "废物管道分配机"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	anchored = TRUE

/*
//Allow you to push disposal pipes into it (for those with density 1)
/obj/structure/machinery/pipedispenser/disposal/Crossed(obj/structure/disposalconstruct/pipe as obj)
	if(istype(pipe) && !pipe.anchored)
		qdel(pipe)

Nah
*/

//Allow you to drag-drop disposal pipes into it
/obj/structure/machinery/pipedispenser/disposal/MouseDrop_T(obj/structure/disposalconstruct/pipe as obj, mob/user)
	if(user.is_mob_incapacitated())
		return

	if (!istype(pipe) || get_dist(user, src) > 1 || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)

/obj/structure/machinery/pipedispenser/disposal/attack_hand(user as mob)
	if(..())
		return

///// Z-Level stuff
	var/dat = {"<b>废物管道</b><br><br>
<A href='byond://?src=\ref[src];dmake=0'>直管</A><BR>
<A href='byond://?src=\ref[src];dmake=1'>弯管</A><BR>
<A href='byond://?src=\ref[src];dmake=2'>三通接头</A><BR>
<A href='byond://?src=\ref[src];dmake=3'>Y形接头</A><BR>
<A href='byond://?src=\ref[src];dmake=4'>立管</A><BR>
<A href='byond://?src=\ref[src];dmake=5'>废物处理机</A><BR>
<A href='byond://?src=\ref[src];dmake=6'>排出口</A><BR>
<A href='byond://?src=\ref[src];dmake=7'>投放口</A><BR>
<A href='byond://?src=\ref[src];dmake=21'>向上管道</A><BR>
<A href='byond://?src=\ref[src];dmake=22'>向下管道</A><BR>
"}
///// Z-Level stuff

	show_browser(user, dat, name, "pipedispenser")
	return

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/structure/machinery/pipedispenser/disposal/Topic(href, href_list)
	if(..())
		return
	usr.set_interaction(src)
	src.add_fingerprint(usr)
	if(href_list["dmake"])
		if(unwrenched || usr.is_mob_incapacitated() || !in_range(loc, usr))
			close_browser(usr, "pipedispenser")
			return
		if(!wait)
			var/p_type = text2num(href_list["dmake"])
			var/obj/structure/disposalconstruct/C = new (src.loc)
			switch(p_type)
				if(0)
					C.ptype = 0
				if(1)
					C.ptype = 1
				if(2)
					C.ptype = 2
				if(3)
					C.ptype = 4
				if(4)
					C.ptype = 5
				if(5)
					C.ptype = 6
					C.density = TRUE
				if(6)
					C.ptype = 7
					C.density = TRUE
				if(7)
					C.ptype = 8
					C.density = TRUE
///// Z-Level stuff
				if(21)
					C.ptype = 11
				if(22)
					C.ptype = 12
///// Z-Level stuff
			C.add_fingerprint(usr)
			C.update()
			wait = 1
			addtimer(VARSET_CALLBACK(src, wait, FALSE), 1.5 SECONDS)
	return

// adding a pipe dispensers that spawn unhooked from the ground
/obj/structure/machinery/pipedispenser/orderable
	anchored = FALSE
	unwrenched = 1

/obj/structure/machinery/pipedispenser/disposal/orderable
	anchored = FALSE
	unwrenched = 1
