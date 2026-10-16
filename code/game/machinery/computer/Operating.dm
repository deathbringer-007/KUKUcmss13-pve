//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/operating
	name = "手术计算机"
	density = TRUE
	anchored = TRUE
	icon_state = "operating"
	circuit = /obj/item/circuitboard/computer/operating
	var/mob/living/carbon/human/victim = null
	var/obj/structure/machinery/optable/table = null
	processing = TRUE

/obj/structure/machinery/computer/operating/New()
	..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/structure/machinery/optable, get_step(src, dir))
		if (table)
			table.computer = src
			break

/obj/structure/machinery/computer/operating/attack_remote(mob/user)
	add_fingerprint(user)
	if(inoperable())
		return
	interact(user)


/obj/structure/machinery/computer/operating/attack_hand(mob/user)
	add_fingerprint(user)
	if(inoperable())
		return
	interact(user)


/obj/structure/machinery/computer/operating/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (inoperable()) )
		if (!isRemoteControlling(user))
			user.unset_interaction()
			close_browser(user, "op")
			return

	user.set_interaction(src)
	var/dat = "<HEAD><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A href='byond://?src=\ref[user];mach_close=op'>关闭</A><br><br>" //| <A href='byond://?src=\ref[user];update=1'>Update</A>"
	if(src.table && src.table.buckled_mob)
		src.victim = src.table.buckled_mob
		dat += {"
<B>病人信息：</B><BR>
<BR>
<B>姓名：</B> [src.victim.real_name]<BR>
<B>年龄：</B> [src.victim.age]<BR>
<B>血型：</B> [src.victim.b_type]<BR>
<BR>
<B>生命值：</B> [src.victim.health]<BR>
<B>物理损伤：</B> [src.victim.getBruteLoss()]<BR>
<B>毒素损伤：</B> [src.victim.getToxLoss()]<BR>
<B>烧伤：</B> [src.victim.getFireLoss()]<BR>
<B>缺氧损伤：</B> [src.victim.getOxyLoss()]<BR>
<B>病人状态：</B> [src.victim.stat ? "无反应" : "稳定"]<BR>
<B>心率：</B> [victim.get_pulse(GETPULSE_TOOL)]<BR>
"}
	else
		src.victim = null
		dat += {"
<B>病人信息：</B><BR>
<BR>
<B>未检测到病人</B>
"}
	show_browser(user, dat, "手术计算机", "op")


/obj/structure/machinery/computer/operating/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (isRemoteControlling(usr)))
		usr.set_interaction(src)
	return


/obj/structure/machinery/computer/operating/process()
	if(..())
		src.updateDialog()
