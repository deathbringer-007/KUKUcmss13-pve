/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */

//Used for logging people entering cryosleep and important items they are carrying.
GLOBAL_LIST_EMPTY(frozen_crew)
GLOBAL_LIST_INIT(frozen_items, list(SQUAD_MARINE_1 = list(), SQUAD_MARINE_2 = list(), SQUAD_MARINE_3 = list(), SQUAD_MARINE_4 = list(), "MP" = list(), "REQ" = list(), "Eng" = list(), "Med" = list(), "Yautja" = list()))

//Main cryopod console.

/obj/structure/machinery/computer/cryopod
	name = "深度休眠区控制台"
	desc = "控制舰船深度休眠区的大型控制台。大多数选项已禁用并锁定，但仍可取回长期休眠人员的物品。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "cellconsole"
	circuit = /obj/item/circuitboard/computer/cryopodcontrol
	exproof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	var/cryotype = "REQ"
	var/mode = null
	var/z_restricted = TRUE

/obj/structure/machinery/computer/cryopod/medical
	cryotype = "Med"

/obj/structure/machinery/computer/cryopod/brig
	cryotype = "MP"

/obj/structure/machinery/computer/cryopod/eng
	cryotype = "Eng"

/obj/structure/machinery/computer/cryopod/alpha
	cryotype = SQUAD_MARINE_1

/obj/structure/machinery/computer/cryopod/alpha/Initialize()
	. = ..()

	RegisterSignal(SSdcs, COMSIG_GLOB_PLATOON_NAME_CHANGE, PROC_REF(rename_platoon))

/obj/structure/machinery/computer/cryopod/alpha/proc/rename_platoon(datum/source, new_name, old_name)
	SIGNAL_HANDLER

	cryotype = new_name

/obj/structure/machinery/computer/cryopod/bravo
	cryotype = SQUAD_MARINE_2

/obj/structure/machinery/computer/cryopod/charlie
	cryotype = SQUAD_MARINE_3

/obj/structure/machinery/computer/cryopod/delta
	cryotype = SQUAD_MARINE_4

/obj/structure/machinery/computer/cryopod/yautja
	cryotype = "Yautja"
	z_restricted = FALSE

/obj/structure/machinery/computer/cryopod/attack_remote()
	src.attack_hand()

/obj/structure/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(inoperable())
		return

	if(z_restricted && !is_mainship_level(z))
		to_chat(user, SPAN_WARNING("离开[MAIN_SHIP_NAME]后，[src]无法连接休眠区系统！"))
		return

	user.set_interaction(src)
	src.add_fingerprint(usr)

	var/dat

	dat += "<i>欢迎，[user.real_name]。</i><br/><br/><hr/>"
	dat += "<a href='byond://?src=\ref[src];log=1'>查看存放记录</a>。<br>"
	dat += "<a href='byond://?src=\ref[src];view=1'>查看物品</a>。<br>"
	dat += "<a href='byond://?src=\ref[src];item=1'>取回物品</a>。<br>"
	dat += "<a href='byond://?src=\ref[src];allitems=1'>取回全部物品</a>。<br>"

	show_browser(user, dat, "[cryotype]休眠监管控制", "cryopod_console")

/obj/structure/machinery/computer/cryopod/Topic(href, href_list)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	var/list/frozen_items_for_type = GLOB.frozen_items[cryotype]

	src.add_fingerprint(user)

	if(href_list["log"])

		var/dat = "<b>近期进入长期休眠的人员</b><br/><hr/><br/>"
		for(var/person in GLOB.frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"

		show_browser(user, dat, "休眠监管记录", "cryolog")

	if(href_list["view"])

		var/dat = "<b>近期存放的物品</b><br/><hr/><br/>"
		for(var/obj/item/I in frozen_items_for_type)
			dat += "[I.name]<br/>"
		dat += "<hr/>"

		show_browser(user, dat, "休眠监管记录", "cryoitems")

	else if(href_list["item"])

		if(length(frozen_items_for_type) == 0)
			to_chat(user, SPAN_WARNING("储存区没有可取回的物品。"))
			return

		var/obj/item/I = tgui_input_list(usr, "请选择要取回的物品。", "取回物品", frozen_items_for_type)
		if(!I)
			return

		if(!(I in frozen_items_for_type))
			to_chat(user, SPAN_WARNING("[I]已不在储存区内。"))
			return

		visible_message(SPAN_NOTICE("[src]欢快地响了一声，送出了[I]。"))

		I.forceMove(get_turf(src))
		frozen_items_for_type -= I

	else if(href_list["allitems"])

		if(length(frozen_items_for_type) == 0)
			to_chat(user, SPAN_WARNING("储存区没有可取回的物品。"))
			return

		visible_message(SPAN_NOTICE("[src]欢快地响了一声，送出了所需物品。"))

		for(var/obj/item/I in frozen_items_for_type)
			I.forceMove(get_turf(src))
			frozen_items_for_type -= I

	src.updateUsrDialog()
	return


//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "深度休眠舱管路"
	desc = "令人眼花缭乱的机械与管道，将深度休眠舱连接至休眠区。"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "cryo_rear"
	anchored = TRUE
	density = TRUE
	unslashable = TRUE

	var/orient_right = null //Flips the sprite.

/obj/structure/cryofeed/right
	orient_right = 1
	icon_state = "cryo_rear-r"

/obj/structure/cryofeed/Initialize()
	. = ..()
	if(orient_right)
		icon_state = "cryo_rear-r"
	else
		icon_state = "cryo_rear"


//Cryopods themselves.
/obj/structure/machinery/cryopod
	name = "深度休眠舱"
	desc = "带LED显示屏的大型自动舱体，用于让舱内人员进入深度休眠——大多数舰船采用的一种非低温停滞状态。"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "hypersleep_open"
	density = TRUE
	anchored = TRUE

	var/mob/living/occupant = null //Person waiting to be despawned.
	var/orient_right = null // Flips the sprite.
	var/time_till_despawn = 10 MINUTES //10 minutes-ish safe period before being despawned.
	var/time_entered = 0 //Used to keep track of the safe period.
	var/silent_exit = FALSE
	var/obj/item/device/radio/intercom/announce //Intercom for cryo announcements


/obj/structure/machinery/cryopod/right
	dir = WEST

/obj/structure/machinery/cryopod/Initialize()
	. = ..()
	announce = new /obj/item/device/radio/intercom(src)
	flags_atom |= USES_HEARING

/obj/structure/machinery/cryopod/Destroy()
	QDEL_NULL(occupant)
	QDEL_NULL(announce)
	. = ..()

/obj/structure/machinery/cryopod/update_icon()
	if(occupant)
		icon_state = "hypersleep_closed"
	else
		icon_state = "hypersleep_open"

//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/structure/machinery/cryopod/process()
	if(occupant && !(occupant in GLOB.freed_mob_list)) //ignore freed mobs
		//if occupant ghosted, time till despawn is severely shorter
		if(!occupant.key && time_till_despawn == 10 MINUTES)
			time_till_despawn -= 8 MINUTES
		//Allow a ten minute gap between entering the pod and actually despawning.
		if(world.time - time_entered < time_till_despawn)
			return

		if(!occupant.client && occupant.stat < DEAD) //Occupant is living and has no client.
			despawn_occupant()
	else
		stop_processing()

/obj/structure/machinery/cryopod/proc/despawn_occupant()
	time_till_despawn = initial(time_till_despawn)

	//Drop all items into the pod.
	for(var/obj/item/W in occupant)
		occupant.drop_inv_item_to_loc(W, src)

	//Delete all items not on the preservation list.

	var/list/items = contents.Copy()
	items -= occupant //Don't delete the occupant
	items -= announce //or the autosay radio.

	SSminimaps.remove_marker(src)

	var/list/dept_console = GLOB.frozen_items["REQ"]
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		switch(H.job)
			if(JOB_POLICE, JOB_WARDEN, JOB_CHIEF_POLICE)
				dept_console = GLOB.frozen_items["MP"]
			if("Nurse", "Doctor","Researcher","Chief Medical Officer")
				dept_console = GLOB.frozen_items["Med"]
			if("Maintenance Technician", "Ordnance Technician","Chief Engineer")
				dept_console = GLOB.frozen_items["Eng"]
			if("Predator")
				dept_console = GLOB.frozen_items["Yautja"]
		H.species.handle_cryo(H)

	var/list/deleteempty = list(/obj/item/storage/backpack/marine/satchel)

	var/list/deleteall = list(/obj/item/clothing/mask/cigarette, \
	/obj/item/clothing/glasses/sunglasses, \
	/obj/item/clothing/glasses/mgoggles, \
	/obj/item/clothing/head/beret/marine/mp, \
	/obj/item/clothing/gloves/black, \
	/obj/item/weapon/baton, \
	/obj/item/weapon/gun/energy/taser, \
	/obj/item/clothing/glasses/sunglasses/sechud, \
	/obj/item/device/radio/headset/almayer, \
	/obj/item/card/id, \
	/obj/item/clothing/under/marine, \
	/obj/item/clothing/shoes/marine, \
	/obj/item/clothing/head/cmcap)

	var/list/strippeditems = list()

	item_loop:
		for(var/obj/item/W in items)
			if(((W.flags_inventory & CANTSTRIP) || (W.flags_item & NODROP) || (W.flags_item & NO_CRYO_STORE)) && !isyautja(occupant)) //We don't keep donor items, undroppable/unremovable items, and specifically filtered items
				if(istype(W, /obj/item/clothing/suit/storage))
					var/obj/item/clothing/suit/storage/SS = W
					for(var/obj/item/I in SS.pockets) //But we keep stuff inside them
						SS.pockets.remove_from_storage(I, loc)
						strippeditems += I
						I.moveToNullspace()
				if(isstorage(W))
					var/obj/item/storage/S = W
					for(var/obj/item/I in S)
						S.remove_from_storage(I, loc)
						strippeditems += I
						I.moveToNullspace()
				qdel(W)
				continue


			//special items that store stuff in a nonstandard way, we properly remove those items

			if(istype(W, /obj/item/clothing/suit/storage))
				var/obj/item/clothing/suit/storage/SS = W
				for(var/obj/item/I in SS.pockets)
					SS.pockets.remove_from_storage(I, loc)
					strippeditems += I
					I.moveToNullspace()

			if(istype(W, /obj/item/clothing/under))
				var/obj/item/clothing/under/UN = W
				for(var/obj/item/I in UN.accessories)
					UN.remove_accessory(occupant, I)
					strippeditems += I
					I.moveToNullspace()

			if(istype(W, /obj/item/clothing/shoes/marine))
				var/obj/item/clothing/shoes/marine/MS = W
				if(MS.stored_item)
					strippeditems += MS.stored_item
					MS.stored_item.moveToNullspace()
					MS.stored_item = null



			for(var/TT in deleteempty)
				if(istype(W, TT))
					if(length(W.contents) == 0)
						qdel(W) // delete all the empty satchels
						continue item_loop
					break // not empty, don't delete

			for(var/DA in deleteall)
				if(istype(W, DA))
					qdel(W)
					continue item_loop

			dept_console += W
			W.moveToNullspace()

	stripped_items:
		for(var/obj/item/A in strippeditems)
			for(var/DAA in deleteall)
				if(istype(A, DAA))
					qdel(A)
					continue stripped_items

			dept_console += A
			A.moveToNullspace()

	var/datum/job/job = GET_MAPPED_ROLE(occupant.job)
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		job.on_cryo(H)
		if(H.assigned_squad)
			var/datum/squad/S = H.assigned_squad
			S.forget_marine_in_squad(H)

	//Cryoing someone out removes someone from the Marines, blocking further larva spawns until accounted for
	SSticker.mode.latejoin_update(job, -1)

	//Handle job slot/tater cleanup.
	GLOB.RoleAuthority.free_role(GET_MAPPED_ROLE(occupant.job), TRUE)

	var/occupant_ref = WEAKREF(occupant)
	//Delete them from datacore.
	for(var/datum/data/record/R as anything in GLOB.data_core.medical)
		if((R.fields["ref"] == occupant_ref))
			GLOB.data_core.medical -= R
			qdel(R)
	for(var/datum/data/record/T in GLOB.data_core.security)
		if((T.fields["ref"] == occupant_ref))
			GLOB.data_core.security -= T
			qdel(T)
	for(var/datum/data/record/G in GLOB.data_core.general)
		if((G.fields["ref"] == occupant_ref))
			GLOB.data_core.general -= G
			qdel(G)

	set_light(0)

	if(occupant.key)
		occupant.ghostize(0)

	//Make an announcement and log the person entering storage.
	GLOB.frozen_crew += "[occupant.real_name] ([occupant.job])"

	if(!isyautja(occupant))
		ai_silent_announcement("[occupant.real_name]，[occupant.job]，已进入长期深度休眠，随身物品已转移至休眠储物区。")
	visible_message(SPAN_NOTICE("[src]嗡嗡作响，伴随着嘶嘶声，将[occupant.real_name]送入深度休眠区。"))

	//Delete the mob.

	QDEL_NULL(occupant)
	stop_processing()
	update_icon()

/obj/structure/machinery/cryopod/attackby(obj/item/W, mob/living/user)
	if(isxeno(user))
		return FALSE
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(occupant)
			to_chat(user, SPAN_WARNING("[src]已经有人了。"))
			return FALSE

		if(!isliving(G.grabbed_thing))
			return FALSE

		var/willing = FALSE //We don't want to allow people to be forced into despawning.
		var/mob/living/M = G.grabbed_thing

		if(isxeno(M))
			to_chat(user, SPAN_WARNING("[src]不可能接收[M]！"))
			return FALSE

		if(M.client)
			if(alert(M,"你想进入休眠吗？", , "是", "否") == "是")
				if(!M || !G || !G.grabbed_thing)
					return FALSE
				willing = TRUE
		else
			willing = TRUE

		if(willing)

			visible_message(SPAN_NOTICE("[user]开始将[M]放入[src]。"),
			SPAN_NOTICE("你开始将[M]放入[src]。"))

			if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC)) return
			if(!M || !G || !G.grabbed_thing) return
			if(occupant)
				to_chat(user, SPAN_WARNING("[src]已经有人了。"))
				return FALSE

			go_in_cryopod(M)

			//Book keeping!
			var/area/location = get_area(src)
			message_admins("[key_name_admin(user)] put [key_name_admin(M)], [M.job] into [src] at [location].")

			//Despawning occurs when process() is called with an occupant without a client.
			add_fingerprint(user)
			return TRUE

/obj/structure/machinery/cryopod/relaymove(mob/user)
	if(user.is_mob_incapacitated(TRUE))
		return
	eject()

/obj/structure/machinery/cryopod/verb/eject()
	set name = "弹出舱内人员"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return

	if(occupant != usr)
		to_chat(usr, SPAN_WARNING("你不能将处于深度休眠中的人员拖出来！"))
		return

	if(!silent_exit && alert(usr, "你想从深度休眠舱中出来吗？", "确认", "是", "否") != "是")
		return

	go_out() //Not adding a delay for this because for some reason it refuses to work. Not a big deal imo
	add_fingerprint(usr)

	to_chat(usr, SPAN_NOTICE("你从[src]中出来了。"))
	if(!silent_exit)
		visible_message(SPAN_WARNING("[src]的舱体开始移动！"))
		var/mob/living/M = usr
		var/area/location = get_area(src) //Logs the exit
		message_admins("[key_name_admin(M)], [M.job], has left [src] at [location].")

	var/list/items = src.contents //-Removes items from the chamber
	if(occupant) items -= occupant
	if(announce) items -= announce

	for(var/obj/item/W in items)
		W.forceMove(get_turf(src))

/obj/structure/machinery/cryopod/verb/move_inside()
	set name = "进入休眠舱"
	set category = "Object"
	set src in oview(1)

	if(usr.is_mob_incapacitated() || !(ishuman(usr)))
		return

	if(occupant)
		to_chat(usr, SPAN_WARNING("[src]已经有人了。"))
		return

	if(isxeno(usr))
		to_chat(usr, SPAN_WARNING("[src]不可能接收你！"))
		return

	usr.visible_message(SPAN_NOTICE("[usr]开始爬入[src]。"),
	SPAN_NOTICE("你开始爬入[src]。"))

	if(do_after(usr, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))

		if(!usr || !usr.client)
			return

		if(occupant)
			to_chat(usr, SPAN_WARNING("[src]已经有人了。"))
			return

		go_in_cryopod(usr)
		add_fingerprint(usr)


/obj/structure/machinery/cryopod/proc/go_in_cryopod(mob/living/mob, silent = FALSE)
	if(occupant)
		return
	mob.forceMove(src)
	occupant = mob
	update_icon()
	set_light(2)
	time_entered = world.time
	start_processing()

	if(!silent)
		if(mob.client)
			to_chat(mob, SPAN_NOTICE("凉气包围了你。身体逐渐麻木，意识沉入内心。"))
			to_chat(mob, SPAN_BOLDNOTICE("如果你现在退出登录或关闭客户端，角色将在10分钟后永久退出本轮。如果你转为幽灵，倒计时将缩短为2分钟。"))
			if(!should_block_game_interaction(src)) // Set their queue time now because the client has to actually leave to despawn and at that point the client is lost
				mob.client.player_details.larva_queue_time = max(mob.client.player_details.larva_queue_time, world.time)
		var/area/location = get_area(src)
		if(mob.job != GET_MAPPED_ROLE(JOB_SQUAD_MARINE))
			message_admins("[key_name_admin(mob)], [mob.job], has entered \a [src] at [location] after playing for [duration2text(world.time - mob.life_time_start)].")
		playsound(src, 'sound/machines/hydraulics_3.ogg', 30)
	silent_exit = silent

/obj/structure/machinery/cryopod/proc/go_out()
	if(!occupant)
		return
	occupant.forceMove(get_turf(src))
	occupant = null
	stop_processing()
	update_icon()
	set_light(0)
	playsound(src, 'sound/machines/pod_open.ogg', 30)
	SEND_SIGNAL(src, COMSIG_CRYOPOD_GO_OUT)

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/cryopod/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant))
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH

//clickdrag code - "resist to get out" code is in living_verbs.dm
/obj/structure/machinery/cryopod/MouseDrop_T(mob/target, mob/user)
	. = ..()
	var/mob/living/H = user
	if(!istype(H) || target != user) //cant make others get in. they need to be willing so this is superflous to enable
		return

	move_inside(target)

/obj/structure/machinery/cryopod/big
	icon = 'icons/obj/structures/machinery/hypersleep.dmi'
	icon_state = "hypersleep_base"
	dir = EAST
	var/image/occupant_image
	var/occupant_angle = 270
	var/occupant_dir = 4
	var/occupant_x = 6
	var/occupant_y = 0

/obj/structure/machinery/cryopod/big/Initialize()
	. = ..()
	var/cover_image = image(icon, icon_state = "cover_fog", layer = 3.22)
	overlays += cover_image

/obj/structure/machinery/cryopod/big/update_icon()
	return

/obj/structure/machinery/cryopod/big/go_in_cryopod(mob/living/mob, silent = FALSE)
	..()
	overlays.Cut()
	occupant_image = image(mob.appearance, loc, layer = 3.21)
	occupant_image.pixel_x = occupant_x
	occupant_image.pixel_y = occupant_y
	occupant_image.dir = occupant_dir
	if(mob.body_position == STANDING_UP)
		occupant_image.transform = occupant.transform.Turn(occupant_angle)
	overlays += occupant_image
	var/cover_image = image(icon, icon_state = "cover", layer = 3.22)
	overlays += cover_image

/obj/structure/machinery/cryopod/big/go_out()
	..()
	overlays -= occupant_image
	occupant_image = null

/obj/structure/machinery/cryopod/big/despawn_occupant()
	..()
	overlays.Cut()
	occupant_image = null
	var/cover_image = image(icon, icon_state = "cover_fog", layer = 3.22)
	overlays += cover_image

/obj/structure/machinery/cryopod/big/flipped
	dir = WEST
	occupant_angle = 90
	occupant_dir = 8
	occupant_x = 10

/obj/structure/machinery/cryopod/tutorial
	silent_exit = TRUE

/obj/structure/machinery/cryopod/tutorial/process()
	return

/obj/structure/machinery/cryopod/tutorial/go_in_cryopod(mob/mob, silent = FALSE, del_them = TRUE)
	if(occupant)
		return
	mob.forceMove(src)
	occupant = mob
	icon_state = "hypersleep_closed"
	set_light(2)
	time_entered = world.time
	if(del_them)
		despawn_occupant()

/obj/structure/machinery/cryopod/tutorial/despawn_occupant()
	SSminimaps.remove_marker(occupant)

	if(ishuman(occupant))
		var/mob/living/carbon/human/man = occupant
		man.species.handle_cryo(man)

	icon_state = "hypersleep_open"
	set_light(0)


	var/mob/new_player/new_player = new

	if(!occupant.mind)
		occupant.mind_initialize()

	occupant.mind.transfer_to(new_player)
	SEND_SIGNAL(occupant, COMSIG_MOB_END_TUTORIAL)
