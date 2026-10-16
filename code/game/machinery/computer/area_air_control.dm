/obj/structure/machinery/computer/area_atmos
	name = "区域空气控制台"
	desc = "用于控制区域内固定式洗涤器和气泵的计算机。"
	icon_state = "atmos"
	circuit = /obj/item/circuitboard/computer/area_atmos

	var/list/connectedscrubbers = new()
	var/status = ""

	var/range = 25

	//Simple variable to prevent me from doing attack_hand in both this and the child computer
	var/zone = "此计算机通过无线连接工作，目前覆盖范围为 25 米。"

/obj/structure/machinery/computer/area_atmos/New()
	..()
	//So the scrubbers have time to spawn
	addtimer(CALLBACK(src, PROC_REF(scanscrubbers)), 10)

/obj/structure/machinery/computer/area_atmos/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/computer/area_atmos/attack_hand(mob/user as mob)
	if(..(user))
		return
	src.add_fingerprint(usr)
	var/dat = {"
	<html>
		<head>
			<style type="text/css">
				a.green:link
				{
					color:#00CC00;
				}
				a.green:visited
				{
					color:#00CC00;
				}
				a.green:hover
				{
					color:#00CC00;
				}
				a.green:active
				{
					color:#00CC00;
				}
				a.red:link
				{
					color:#FF0000;
				}
				a.red:visited
				{
					color:#FF0000;
				}
				a.red:hover
				{
					color:#FF0000;
				}
				a.red:active
				{
					color:#FF0000;
				}
			</style>
		</head>
		<body>
			<center><h1>区域空气控制台</h1></center>
			<font color="red">[status]</font><br>
			<a href="byond://?src=\ref[src];scan=1">扫描</a>
			<table border="1" width="90%">"}
	for(var/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in connectedscrubbers)
		dat += {"
				<tr>
					<td>
						[scrubber.name]<br>
					</td>
				</tr>"}

	dat += {"
			</table><br>
			<i>[zone]</i>
		</body>
	</html>"}
	show_browser(user, dat, name, "miningshuttle", width = 400, height = 400)
	status = ""

/obj/structure/machinery/computer/area_atmos/Topic(href, href_list)
	if(..())
		return
	usr.set_interaction(src)
	src.add_fingerprint(usr)


	if(href_list["scan"])
		scanscrubbers()
	else if(href_list["toggle"])
		var/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/scrubber = locate(href_list["scrub"])

		if(!validscrubber(scrubber))
			spawn(20)
				status = "错误：无法连接洗涤器！（超时）"
				connectedscrubbers -= scrubber
				src.updateUsrDialog()
			return

		scrubber.on = text2num(href_list["toggle"])
		scrubber.update_icon()

/obj/structure/machinery/computer/area_atmos/proc/validscrubber(obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/scrubber as obj )
	if(!isobj(scrubber) || get_dist(scrubber.loc, src.loc) > src.range || scrubber.loc.z != src.loc.z)
		return 0

	return 1

/obj/structure/machinery/computer/area_atmos/proc/scanscrubbers()
	connectedscrubbers = new()

	var/found = 0
	for(var/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in range(range, src.loc))
		if(istype(scrubber))
			found = 1
			connectedscrubbers += scrubber

	if(!found)
		status = "错误：未找到洗涤器！"

	src.updateUsrDialog()


/obj/structure/machinery/computer/area_atmos/area
	zone = "此计算机通过仅覆盖本区域的有线网络工作。"

/obj/structure/machinery/computer/area_atmos/area/validscrubber(obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/scrubber as obj )
	if(!isobj(scrubber))
		return 0

	/*
	wow this is stupid, someone help me
	*/
	var/turf/T_src = get_turf(src)
	if(!T_src.loc) return 0
	var/area/A_src = T_src.loc

	var/turf/T_scrub = get_turf(scrubber)
	if(!T_scrub.loc) return 0
	var/area/A_scrub = T_scrub.loc

	if(A_scrub != A_src)
		return 0

	return 1

/obj/structure/machinery/computer/area_atmos/area/scanscrubbers()
	connectedscrubbers = new()

	var/found = 0

	var/turf/T = get_turf(src)
	if(!T.loc) return
	for(var/obj/structure/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in GLOB.machines )
		var/turf/T2 = get_turf(scrubber)
		if(T2 && T2.loc)
			var/area/A = T2.loc
			if(istype(A) && A)
				connectedscrubbers += scrubber
				found = 1


	if(!found)
		status = "错误：未找到洗涤器！"

	src.updateUsrDialog()
