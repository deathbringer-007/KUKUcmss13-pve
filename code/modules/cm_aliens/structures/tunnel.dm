/*
 * Tunnels
 */

#define TUNNEL_COLLAPSING_TIME (60 SECONDS)

/obj/structure/tunnel
	name = "隧道"
	desc = "隧道入口，看起来像是某种长着利爪的野兽挖出来的。"
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "hole"

	density = FALSE
	opacity = FALSE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = RESIN_STRUCTURE_LAYER
	plane = FLOOR_PLANE

	var/tunnel_desc = "" //description added by the hivelord.

	var/hivenumber = XENO_HIVE_NORMAL
	var/datum/hive_status/hive

	health = 140
	var/id = null //For mapping

/obj/structure/tunnel/Initialize(mapload, h_number)
	. = ..()
	var/turf/L = get_turf(src)
	tunnel_desc = L.loc.name + " ([loc.x], [loc.y]) [pick(GLOB.greek_letters)]"//Default tunnel desc is the <area name> (x, y) <Greek letter>

	if(h_number && GLOB.hive_datum[h_number])
		hivenumber = h_number
		hive = GLOB.hive_datum[h_number]

		set_hive_data(src, h_number)

		hive.tunnels += src

	if(!hive)
		hive = GLOB.hive_datum[hivenumber]

		hive.tunnels += src

	var/obj/effect/alien/resin/trap/resin_trap = locate() in L
	if(resin_trap)
		qdel(resin_trap)

	if(hivenumber == XENO_HIVE_NORMAL)
		RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(forsaken_handling))

	SSminimaps.add_marker(src, z, get_minimap_flag_for_faction(hivenumber), "xenotunnel")

/obj/structure/tunnel/proc/forsaken_handling()
	SIGNAL_HANDLER
	if(is_ground_level(z))
		hive.tunnels -= src
		hivenumber = XENO_HIVE_FORSAKEN
		set_hive_data(src, XENO_HIVE_FORSAKEN)
		hive = GLOB.hive_datum[XENO_HIVE_FORSAKEN]
		hive.tunnels += src

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/obj/structure/tunnel/Destroy()
	if(hive)
		hive.tunnels -= src

	for(var/mob/living/carbon/xenomorph/X in contents)
		X.forceMove(loc)
		to_chat(X, SPAN_DANGER("[src]突然坍塌，将你挤了出去！"))
	. = ..()

/obj/structure/tunnel/proc/isfriendly(mob/target)
	var/mob/living/carbon/C = target
	if(istype(C) && C.ally_of_hivenumber(hivenumber))
		return TRUE

	return FALSE

/obj/structure/tunnel/get_examine_text(mob/user)
	. = ..()
	if(tunnel_desc && (isfriendly(user) || isobserver(user)))
		. += SPAN_INFO("信息素气味传达着：\'[tunnel_desc]\'")

/obj/structure/tunnel/proc/healthcheck()
	if(health <= 0)
		visible_message(SPAN_DANGER("[src]突然坍塌了！"))
		qdel(src)

/obj/structure/tunnel/bullet_act(obj/projectile/Proj)
	return FALSE

/obj/structure/tunnel/ex_act(severity)
	health -= severity/2
	healthcheck()

/obj/structure/tunnel/attackby(obj/item/W as obj, mob/user as mob)
	if(!isxeno(user))
		if(istype(W, /obj/item/tool/shovel))
			var/obj/item/tool/shovel/destroying_shovel = W

			if(destroying_shovel.folded)
				return

			playsound(user.loc, 'sound/effects/thud.ogg', 40, 1, 6)

			user.visible_message(SPAN_NOTICE("[user]开始毁塌[src]！"), SPAN_NOTICE("你开始毁塌[src]！"))

			if(user.action_busy || !do_after(user, TUNNEL_COLLAPSING_TIME * ((100 - destroying_shovel.shovelspeed) * 0.01), INTERRUPT_ALL, BUSY_ICON_BUILD))
				return

			playsound(loc, 'sound/effects/tunnel_collapse.ogg', 50)

			visible_message(SPAN_NOTICE("[src]向内坍塌了。"))

			qdel(src)

		return ..()
	return attack_alien(user)

/obj/structure/tunnel/verb/use_tunnel()
	set name = "使用隧道"
	set category = "Object"
	set src in view(1)

	if(isxeno(usr) && isfriendly(usr) && (usr.loc == src))
		pick_tunnel(usr)
	else
		to_chat(usr, "你凝视着漆黑的深处" + "[length(contents) ? "，依稀辨认出两点微光……仿佛有什么东西正注视着你。" : "。"]")

/obj/structure/tunnel/verb/exit_tunnel_verb()
	set name = "离开隧道"
	set category = "Object"
	set src in view(0)

	if(isxeno(usr) && (usr.loc == src))
		exit_tunnel(usr)

/obj/structure/tunnel/proc/pick_tunnel(mob/living/carbon/xenomorph/X)
	. = FALSE //For peace of mind when it comes to dealing with unintended proc failures
	if(!istype(X) || X.is_mob_incapacitated(TRUE) || !isfriendly(X) || !hive)
		return FALSE
	if(X in contents)
		var/list/input_tunnels = list()

		var/list/sorted_tunnels = sort_list_dist(hive.tunnels, get_turf(X))
		for(var/obj/structure/tunnel/T in sorted_tunnels)
			if(T == src)
				continue
			if(!is_ground_level(T.z))
				continue

			input_tunnels += list(T.tunnel_desc = T)
		var/pick = tgui_input_list(usr, "你想前往哪条隧道？", "隧道", input_tunnels, theme="hive_status")
		if(!pick)
			return FALSE

		if(!(X in contents))
			//Xeno moved out of the tunnel before they picked a destination
			//No teleporting!
			return FALSE

		to_chat(X, SPAN_XENONOTICE("我们开始前往目的地。"))

		var/tunnel_time = TUNNEL_MOVEMENT_XENO_DELAY

		if(X.mob_size >= MOB_SIZE_BIG) //Big xenos take WAY longer
			tunnel_time = TUNNEL_MOVEMENT_BIG_XENO_DELAY
		else if(islarva(X)) //Larva can zip through near-instantly, they are wormlike after all
			tunnel_time = TUNNEL_MOVEMENT_LARVA_DELAY

		if(!do_after(X, tunnel_time, INTERRUPT_NO_NEEDHAND, 0))
			return FALSE

		var/obj/structure/tunnel/T = input_tunnels[pick]

		if(length(T.contents) > 2)// max 3 xenos in a tunnel
			to_chat(X, SPAN_WARNING("隧道太拥挤了，先等其他姐妹出去！"))
			return FALSE
		if(!T.loc)
			to_chat(X, SPAN_WARNING("我们尚未抵达出口，隧道就已经坍塌了！"))
			return FALSE

		X.forceMove(T)
		to_chat(X, SPAN_XENONOTICE("我们抵达了目的地。"))
		return TRUE

/obj/structure/tunnel/proc/exit_tunnel(mob/living/carbon/xenomorph/X)
	. = FALSE //For peace of mind when it comes to dealing with unintended proc failures
	if(X in contents)
		X.forceMove(loc)
		visible_message(SPAN_XENONOTICE("[X]从隧道里钻了出来！"), \
		SPAN_XENONOTICE("我们从另一端钻了出来！"))
		return TRUE

//Used for controling tunnel exiting and returning
/obj/structure/tunnel/clicked(mob/user, list/mods)
	if(!isxeno(user) || !isfriendly(user))
		return ..()
	var/mob/living/carbon/xenomorph/X = user
	if(mods[CTRL_CLICK] && pick_tunnel(X))//Returning to original tunnel
		return TRUE
	else if(mods[ALT_CLICK] && exit_tunnel(X))//Exiting the tunnel
		return TRUE
	. = ..()

/obj/structure/tunnel/attack_larva(mob/living/carbon/xenomorph/M)
	. = attack_alien(M)

/obj/structure/tunnel/attack_alien(mob/living/carbon/xenomorph/M)
	if(!istype(M) || M.is_mob_incapacitated(TRUE))
		return XENO_NO_DELAY_ACTION

	if(!isfriendly(M))
		if(M.mob_size < MOB_SIZE_BIG)
			to_chat(M, SPAN_XENOWARNING("我们的体型还不足以毁塌这条隧道！"))
			return XENO_NO_DELAY_ACTION

		M.visible_message(SPAN_XENODANGER("[M]开始用泥土填埋[src]。"),\
		SPAN_XENONOTICE("我们开始用巨爪将泥土填入[src]。"), max_distance = 3)
		xeno_attack_delay(M)

		if(!do_after(M, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL_OUT_OF_RANGE, max_dist = 1))
			to_chat(M, SPAN_XENOWARNING("我们决定不再毁塌隧道。"))
			return XENO_NO_DELAY_ACTION

		src.visible_message(SPAN_XENODANGER("[src]塌陷了！"), max_distance = 3)
		qdel(src)

		return XENO_NO_DELAY_ACTION

	if(M.anchored)
		to_chat(M, SPAN_XENOWARNING("无法移动时，我们不能穿越隧道。"))
		return XENO_NO_DELAY_ACTION

	if(!length(hive.tunnels))
		to_chat(M, SPAN_WARNING("[src]似乎没有通往任何地方。"))
		return XENO_NO_DELAY_ACTION

	if(length(contents) > 2)
		to_chat(M, SPAN_WARNING("隧道太拥挤了，先等其他姐妹出去！"))
		return XENO_NO_DELAY_ACTION

	var/tunnel_time = TUNNEL_ENTER_XENO_DELAY

	if(M.mob_size >= MOB_SIZE_BIG) //Big xenos take WAY longer
		tunnel_time = TUNNEL_ENTER_BIG_XENO_DELAY
	else if(islarva(M)) //Larva can zip through near-instantly, they are wormlike after all
		tunnel_time = TUNNEL_ENTER_LARVA_DELAY

	if(M.mob_size >= MOB_SIZE_BIG)
		M.visible_message(SPAN_XENONOTICE("[M]开始将庞大的身躯挤入[src]。"),
			SPAN_XENONOTICE("我们开始将巨大的身躯挤入[src]（<i>[tunnel_desc]</i>）。"))
	else
		M.visible_message(SPAN_XENONOTICE("[M]开始向下爬入[src]。"),
			SPAN_XENONOTICE("我们开始向下爬入[src]（<i>[tunnel_desc]</i>）。"))

	xeno_attack_delay(M)
	if(!do_after(M, tunnel_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("我们的爬行被打断了！"))
		return XENO_NO_DELAY_ACTION

	if(length(hive.tunnels)) //Make sure other tunnels exist
		M.forceMove(src) //become one with the tunnel
		to_chat(M, SPAN_HIGHDANGER("按住Alt点击隧道即可离开，按住Ctrl点击可选择目的地。"))
		pick_tunnel(M)
	else
		to_chat(M, SPAN_WARNING("[src]意外中断，我们只好返回地面。"))
	return XENO_NO_DELAY_ACTION

/obj/structure/tunnel/proc/animate_crawl(speed = 3, loop_amount = -1, sections = 4)
	animate(src, pixel_x = rand(-2,2), pixel_y = rand(-2,2), time = speed, loop = loop_amount, easing = JUMP_EASING)
	for(var/i in 1 to sections)
		animate(pixel_x = rand(-2,2), pixel_y = rand(-2,2), time = speed, easing = JUMP_EASING)

/obj/structure/tunnel/proc/animate_crawl_reset()
	animate(src, pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), easing = JUMP_EASING)

/obj/structure/tunnel/maint_tunnel
	name = "\improper 维护舱口"
	desc = "维护隧道的入口，里面能看到些许黏液和树脂。碎屑挡住了视线，让你无法看得更仔细。"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "hatchclosed"

/obj/structure/tunnel/maint_tunnel/no_xeno_desc
	desc = "维护隧道的入口。碎屑挡住了视线，让你无法看得更仔细。"
