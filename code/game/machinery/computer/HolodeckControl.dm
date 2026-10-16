/obj/structure/machinery/computer/HolodeckControl
	name = "全息甲板控制计算机"
	desc = "用于控制附近全息甲板的计算机。"
	icon_state = "holocontrol"
	var/area/linkedholodeck = null
	var/area/target = null
	var/active = 0
	var/list/holographic_items = list()
	var/damaged = 0
	var/last_change = 0

// Holographic Items!

/turf/open/floor/holofloor/attackby(obj/item/W as obj, mob/user as mob)
	return

/turf/open/floor/holofloor/cult
	icon_state = "cult"

/turf/open/floor/holofloor/cult/south
	dir = SOUTH

/turf/open/floor/holofloor/grass
	name = "茂盛草地"
	icon_state = "grass1"

/turf/open/floor/holofloor/grass/Initialize(mapload, ...)
	. = ..()
	icon_state = "grass[pick("1","2","3","4")]"
	update_icon()
	for(var/direction in GLOB.cardinals)
		if(istype(get_step(src, direction), /turf/open/floor))
			var/turf/open/floor/FF = get_step(src,direction)
			FF.update_icon() //so siding get updated properly

/turf/open/floor/holofloor/grass/update_icon()
	. = ..()
	if(!broken && !burnt)
		if(!(icon_state in list("grass1", "grass2", "grass3", "grass4")))
			icon_state = "grass[pick("1", "2", "3", "4")]"

/turf/open/floor/holofloor/grass/make_plating()
	return










/obj/structure/surface/table/holotable
	name = "桌子"
	desc = "四条金属腿支撑着一块方形金属桌面，无法移动。"
	icon_state = "table"
	density = TRUE
	anchored = TRUE
	throwpass = 1 //You can throw objects over this, despite it's density.

/obj/structure/surface/table/holotable/attack_animal(mob/living/user as mob) //Removed code for larva since it doesn't work. Previous code is now a larva ability. /N
	return attack_hand(user)

/obj/structure/surface/table/holotable/attack_hand(mob/user as mob)
	return // HOLOTABLE DOES NOT GIVE A FUCK


/obj/structure/surface/table/holotable/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/grab) && get_dist(src,user)<=1)
		var/obj/item/grab/G = W
		if(ismob(G.grabbed_thing))
			var/mob/M = G.grabbed_thing
			if(user.grab_level < GRAB_AGGRESSIVE)
				to_chat(user, SPAN_WARNING("你得抓得更牢才能这样做！"))
				return
			M.forceMove(loc)
			M.apply_effect(5, WEAKEN)
			user.visible_message(SPAN_DANGER("[user]将[M]放到了桌子上。"))
		return

	if (HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		to_chat(user, "这是全息桌子，根本没有螺栓！")
		return

	..()

/obj/structure/surface/table/holotable/wood
	name = "桌子"
	desc = "四条木腿支撑着一块方形木桌面，无法移动。"
	icon_state = "woodtable"
	table_prefix = "wood"

/obj/structure/holostool
	name = "凳子"
	desc = "请将屁股放在此处。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	anchored = TRUE
	unslashable = TRUE
	flags_atom = FPRINT


/obj/item/clothing/gloves/boxing/hologlove
	name = "拳击手套"
	desc = "因为你确实还需要一个揍舰员的借口。"
	icon_state = "boxing"
	item_state = "boxing"

/obj/structure/holowindow
	name = "加固窗户"
	icon = 'icons/turf/walls/windows.dmi'
	icon_state = "rwindow"
	desc = "一扇窗户。"
	density = TRUE
	layer = WINDOW_LAYER
	anchored = TRUE
	unslashable = TRUE
	flags_atom = ON_BORDER

/obj/structure/holowindow/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_GLASS

//BASKETBALL OBJECTS

/obj/item/toy/beach_ball/holoball
	name = "篮球"
	icon_state = "basketball"
	item_state = "basketball"
	desc = "机会来了，在太空大灌篮里尽情表演吧。"
	w_class = SIZE_LARGE //Stops people from hiding it in their bags/pockets

/obj/structure/holohoop
	name = "篮球架"
	desc = "砰，沙卡拉卡！"
	icon = 'icons/obj/structures/props/misc.dmi'
	icon_state = "hoop"
	anchored = TRUE
	density = TRUE
	unslashable = TRUE
	throwpass = 1
	var/side = ""
	var/id = ""

/obj/structure/holohoop/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/grab) && get_dist(src,user)<=1)
		var/obj/item/grab/G = W
		if(ismob(G.grabbed_thing))
			var/mob/M = G.grabbed_thing
			if(user.grab_level < GRAB_AGGRESSIVE)
				to_chat(user, SPAN_WARNING("你得抓得更牢才能这样做！"))
				return
			M.forceMove(loc)
			M.apply_effect(5, WEAKEN)
			for(var/obj/structure/machinery/scoreboard/X in GLOB.machines)
				if(X.id == id)
					X.score(side, 3)// 3 points for dunking a mob
					// no break, to update multiple scoreboards
			visible_message(SPAN_DANGER("[user]将[M]扣进了[src]！"))
		return
	else if (istype(W, /obj/item) && get_dist(src,user)<2)
		user.drop_inv_item_to_loc(W, loc)
		for(var/obj/structure/machinery/scoreboard/X in GLOB.machines)
			if(X.id == id)
				X.score(side)
				// no break, to update multiple scoreboards
		visible_message(SPAN_NOTICE("[user]将[W]扣进了[src]！"))
		return

/obj/structure/holohoop/BlockedPassDirs(atom/movable/mover, target_dir)
	if(istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/projectile))
			return BLOCKED_MOVEMENT
		if(prob(50))
			I.forceMove(src.loc)
			for(var/obj/structure/machinery/scoreboard/X in GLOB.machines)
				if(X.id == id)
					X.score(side)
					// no break, to update multiple scoreboards
			visible_message(SPAN_NOTICE("唰！[I]落进了[src]。"), null, null, 3)
		else
			visible_message(SPAN_DANGER("[I]撞在[src]的边框上弹开了！"), null, null, 3)
		return NO_BLOCKED_MOVEMENT

	return ..()


/obj/structure/machinery/readybutton
	name = "准备确认装置"
	desc = "用于确认准备就绪。当区域内的所有装置都准备好后，活动就会开始！"
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = POWER_CHANNEL_ENVIRON

/obj/structure/machinery/readybutton/attack_remote(mob/user as mob)
	to_chat(user, "空间站AI不得操作这些设备！")
	return

/obj/structure/machinery/readybutton/attackby(obj/item/W as obj, mob/user as mob)
	to_chat(user, "这设备就是个结实的按钮，没什么可拆弄的！")

/obj/structure/machinery/readybutton/attack_hand(mob/user as mob)
	if(user.stat || inoperable())
		to_chat(user, "这台设备没有供电。")
		return

	currentarea = get_area(src.loc)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		to_chat(usr, "活动已经开始了！")
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/structure/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/structure/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/structure/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/holowindow/W in currentarea)
		currentarea -= W
		qdel(W)

	for(var/mob/M in currentarea)
		to_chat(M, "开战！")

//Holorack

/obj/structure/surface/rack/holorack
	name = "置物架"
	desc = "和中世纪那种刑架不一样。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"

/obj/structure/surface/rack/holorack/attack_hand(mob/user as mob)
	return

/obj/structure/surface/rack/holorack/attackby(obj/item/W as obj, mob/user as mob)
	if (HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		to_chat(user, "这是全息置物架，你无法用扳手拆掉它！")
		return
