//Config stuff
#define SUPPLY_STATION_AREATYPE /area/supply/station //Type of the supply shuttle area for station
#define SUPPLY_STATION_AREATYPE_VEHICLE /area/supply/station/vehicle
#define SUPPLY_DOCK_AREATYPE /area/supply/dock //Type of the supply shuttle area for dock
#define SUPPLY_DOCK_AREATYPE_VEHICLE /area/supply/dock/vehicle
#define SUPPLY_COST_MULTIPLIER 1.08
#define ASRS_COST_MULTIPLIER 1.2

#define KILL_MENDOZA -1

GLOBAL_LIST_EMPTY_TYPED(asrs_empty_space_tiles_list, /turf/open/floor/almayer/empty)
GLOBAL_SUBTYPE_PATHS_LIST_INDEXED(supply_packs_types, /datum/supply_packs, name)
GLOBAL_REFERENCE_LIST_INDEXED_SORTED(supply_packs_datums, /datum/supply_packs, type)

GLOBAL_DATUM_INIT(supply_controller, /datum/controller/supply, new())

/area/supply
	ceiling = CEILING_METAL

/area/supply/station
	name = "补给升降台"
	icon_state = "shuttle3"
	requires_power = 0
	ambience_exterior = AMBIENCE_ALMAYER

/area/supply/dock
	name = "补给升降台"
	icon_state = "shuttle3"
	requires_power = 0

/area/supply/station_vehicle
	name = "载具自动仓储检索系统"
	icon_state = "shuttle3"
	requires_power = 0

/area/supply/dock_vehicle
	name = "载具自动仓储检索系统"
	icon_state = "shuttle3"
	requires_power = 0

//SUPPLY PACKS MOVED TO /code/defines/obj/supplypacks.dm

/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper 塑料门帘"
	desc = "完全无法通行——真的是这样吗？"
	icon = 'icons/obj/structures/props/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	unslashable = TRUE
	layer = MOB_LAYER
	var/collide_message_busy // Timer to stop collision spam

/obj/structure/plasticflaps/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_UNDER|PASS_THROUGH

/obj/structure/plasticflaps/BlockedPassDirs(atom/movable/mover, target_dir)
	if((mover.pass_flags.flags_pass & pass_flags.flags_can_pass_all) || !iscarbon(mover))
		return NO_BLOCKED_MOVEMENT

	return BLOCKED_MOVEMENT

/obj/structure/plasticflaps/Collided(atom/movable/AM)
	var/mob/living/carbon/C = AM
	if (!istype(C))
		return
	if (ishuman_strict(C))
		return
	if(collide_message_busy > world.time)
		return

	collide_message_busy = world.time + 3 SECONDS
	C.visible_message(SPAN_NOTICE("[C]试图穿过[src]。"), \
	SPAN_NOTICE("你试图穿过[src]。"))

	if(do_after(C, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		C.forceMove(get_turf(src))

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(5))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "\improper 气密塑料门帘"
	desc = "厚实耐用的气密塑料门帘。"


/obj/structure/machinery/computer/supplycomp
	name = "自动仓储检索系统控制台"
	desc = "用于操作自动仓储检索系统的控制台。"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "supply"
	density = TRUE
	req_access = list(ACCESS_MARINE_CARGO)
	circuit = /obj/item/circuitboard/computer/supplycomp
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/can_order_contraband = FALSE
	var/black_market_lockout = FALSE
	var/last_viewed_group = "categories"
	var/first_time = TRUE

/obj/structure/machinery/computer/supplycomp/Initialize()
	. = ..()
	LAZYADD(GLOB.supply_controller.bound_supply_computer_list, src)

/obj/structure/machinery/computer/supplycomp/Destroy()
	. = ..()
	LAZYREMOVE(GLOB.supply_controller.bound_supply_computer_list, src)

/obj/structure/machinery/computer/supplycomp/attackby(obj/item/hit_item, mob/user)
	if(istype(hit_item, /obj/item/spacecash))
		if(can_order_contraband)
			var/obj/item/spacecash/slotted_cash = hit_item
			if(slotted_cash.counterfeit == TRUE)
				to_chat(user, SPAN_NOTICE("你在控制台底部找到一个小小的水平插槽。你试着把[slotted_cash]塞进去，却被退了回来！难道是假钞？"))
				return
			to_chat(user, SPAN_NOTICE("你在控制台底部找到一个小小的水平插槽。你将[slotted_cash]塞了进去……"))
			GLOB.supply_controller.black_market_points += slotted_cash.worth
			qdel(slotted_cash)
		else
			to_chat(user, SPAN_NOTICE("你在控制台底部找到一个小小的水平插槽。你试着把[hit_item]塞进去，但插槽似乎从内部堵住了。"))
			return
	..()

/obj/structure/machinery/computer/supplycomp/proc/toggle_contraband(contraband_enabled = FALSE)
	can_order_contraband = contraband_enabled
	for(var/obj/structure/machinery/computer/supplycomp/computer as anything in GLOB.supply_controller.bound_supply_computer_list)
		if(computer.can_order_contraband)
			GLOB.supply_controller.black_market_enabled = TRUE
			return
	GLOB.supply_controller.black_market_enabled = FALSE

	//If any computers are able to order contraband, it's enabled. Otherwise, it's disabled!

/// Prevents use of black market, even if it is otherwise enabled. If any computer has black market locked out, it applies across all of the currently established ones.
/obj/structure/machinery/computer/supplycomp/proc/lock_black_market(market_locked = FALSE)
	for(var/obj/structure/machinery/computer/supplycomp/computer as anything in GLOB.supply_controller.bound_supply_computer_list)
		if(market_locked)
			computer.black_market_lockout = TRUE

/obj/structure/machinery/computer/ordercomp
	name = "补给申请控制台"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "request"
	density = TRUE
	circuit = /obj/item/circuitboard/computer/ordercomp
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/last_viewed_group = "categories"

/obj/structure/machinery/computer/supply_drop_console
	name = "补给空投控制台"
	desc = "一台连接着附近补给空投系统的老式计算机。"
	icon_state = "security_cam"
	circuit = /obj/item/circuitboard/computer/supply_drop_console
	req_access = list(ACCESS_MARINE_CARGO)
	var/x_supply = 0
	var/y_supply = 0
	var/datum/squad/current_squad = null
	var/drop_cooldown = 1 MINUTES
	var/can_pick_squad = TRUE
	var/faction = FACTION_MARINE
	var/obj/structure/closet/crate/loaded_crate
	COOLDOWN_DECLARE(next_fire)

/obj/structure/machinery/computer/supply_drop_console/ui_status(mob/user)
	. = ..()
	if(inoperable(MAINT))
		return UI_CLOSE

/obj/structure/machinery/computer/supply_drop_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/supply_drop_console/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SupplyDropConsole", name)
		ui.open()

/obj/structure/machinery/computer/supply_drop_console/ui_static_data(mob/user)
	var/list/data = list()

	var/list/squad_list = list()
	for(var/datum/squad/current_squad in GLOB.RoleAuthority.squads)
		if(current_squad.active && current_squad.faction == faction && current_squad.equipment_color)
			squad_list += list(list(
				"squad_name" = current_squad.name,
				"squad_color" = current_squad.equipment_color
				))

	data["can_pick_squad"] = can_pick_squad
	data["squad_list"] = squad_list

	return data

/obj/structure/machinery/computer/supply_drop_console/ui_data(mob/user)
	var/list/data = list()

	check_pad()
	data["current_squad"] = current_squad
	data["launch_cooldown"] = drop_cooldown
	data["nextfiretime"] = next_fire
	data["worldtime"] = world.time
	data["x_offset"] = x_supply
	data["y_offset"] = y_supply
	data["loaded"] = loaded_crate
	if(loaded_crate)
		data["crate_name"] = loaded_crate.name
	else
		data["crate_name"] = null

	return data

/obj/structure/machinery/computer/supply_drop_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_x")
			var/new_x = text2num(params["set_x"])
			if(!new_x)
				return
			x_supply = new_x
			. = TRUE

		if("set_y")
			var/new_y = text2num(params["set_y"])
			if(!new_y)
				return
			y_supply = new_y
			. = TRUE

		if("pick_squad")
			if(can_pick_squad)
				var/datum/squad/selected = get_squad_by_name(params["squad_name"])
				if(selected)
					current_squad = selected
					attack_hand(usr)
					. = TRUE
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("输入无效。操作中止。")]")
					. = TRUE

		if("send_beacon")
			if(current_squad)
				if(!COOLDOWN_FINISHED(src, next_fire))
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("补给空投尚未就绪！请再等[COOLDOWN_TIMELEFT(src, next_fire)/10]秒！")]")
					return
				else
					handle_supplydrop()
					. = TRUE

		if("refresh_pad")
			check_pad()
			. = TRUE

/obj/structure/machinery/computer/supply_drop_console/attack_hand(mob/user)
	if(..())  //Checks for power outages
		return
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("拒绝访问。"))
		return TRUE
	tgui_interact(user)
	return

/obj/structure/machinery/computer/supply_drop_console/proc/check_pad()
	if(!current_squad.drop_pad)
		loaded_crate = null
		return FALSE
	var/obj/structure/closet/crate/C = locate() in current_squad.drop_pad.loc
	if(C)
		loaded_crate = C
		return C
	else
		loaded_crate = null
		return FALSE

/obj/structure/machinery/computer/supply_drop_console/proc/handle_supplydrop()
	SHOULD_NOT_SLEEP(TRUE)
	var/obj/structure/closet/crate/crate = check_pad()
	if(!crate)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("空投平台上未检测到补给箱。快联系军需部门！")]")
		return

	var/x_coord = deobfuscate_x(x_supply)
	var/y_coord = deobfuscate_y(y_supply)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/T = locate(x_coord, y_coord, z_coord)
	if(!T)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("错误：坐标无效。")]")
		return

	var/area/A = get_area(T)
	if(A && CEILING_IS_PROTECTED(A.ceiling, CEILING_PROTECTION_TIER_2))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("着陆区位于地下，补给空投无法抵达。")]")
		return

	if(istype(T, /turf/open/space) || T.density)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("着陆区似乎被阻挡或超出边界，空投将导致货物丢失。")]")
		return

	if(crate.opened)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("平台上的补给箱尚未封好，请将其关闭！")]")
		return

	crate.visible_message(SPAN_WARNING("[crate]装入了发射管。请退后！"))
	current_squad.send_message("“[crate.name]”补给空投即将到达。小心头顶！")
	current_squad.send_maptext(crate.name, "补给空投即将到达：")
	COOLDOWN_START(src, next_fire, drop_cooldown)
	if(ismob(usr))
		var/mob/M = usr
		M.count_niche_stat(STATISTICS_NICHE_CRATES)

	playsound(crate.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehh
	var/obj/structure/droppod/supply/pod = new(null, crate)
	crate.forceMove(pod)
	pod.launch(T)
	log_ares_requisition("Supply Drop", "Launch [crate.name] to X[x_supply], Y[y_supply].", usr.real_name)
	log_game("[key_name(usr)] launched supply drop '[crate.name]' to X[x_coord], Y[y_coord].")
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("“[crate.name]”补给空投已发射！五分钟后可以再次发射。")]")

//A limited version of the above console
//Can't pick squads, drops less often
//Uses Echo squad as a placeholder to access its own drop pad
/obj/structure/machinery/computer/supply_drop_console/limited
	circuit = /obj/item/circuitboard/computer/supply_drop_console/limited
	drop_cooldown = 5 MINUTES //higher cooldown than usual
	can_pick_squad = FALSE//Can't pick squads

/obj/structure/machinery/computer/supply_drop_console/limited/New()
	..()
	current_squad = get_squad_by_name("Echo") //Hardwired into Echo

/obj/structure/machinery/computer/supply_drop_console/limited/attack_hand(mob/user)
	if(!current_squad)
		current_squad = get_squad_by_name("Echo") //Hardwired into Echo
	. = ..()

/obj/structure/machinery/computer/supply_drop_console/limited/alternate
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sensor_comp2"

/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/old_stuff/mark.dmi'
	name = "X"
	invisibility = 101
	anchored = TRUE
	opacity = FALSE
*/

/datum/supply_order
	var/ordernum
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/approvedby = null

/datum/controller/supply
	var/processing = 1
	var/processing_interval = 30 SECONDS
	var/iteration = 0
	/// Current supply points
	var/points = 0
	/// Multiplier to the amount of points awarded based on marine scale
	var/points_scale = 120
	var/points_per_process = 1.5
	var/points_per_slip = 1
	var/points_per_crate = 2

	//black market stuff
	///in Weyland-Yutani dollars - Not Stan_Albatross.
	var/black_market_points = 5 // 5 to start with to buy the scanner.
	///If the black market is enabled.
	var/black_market_enabled = FALSE
	///How close the CMB is to investigating | 100 sends an ERT
	var/black_market_heat = 0

	/// This contains a list of all typepaths of sold items and how many times they've been received. Used to calculate points dropoff (Can't send down a hundred blue souto cans for infinite points)
	var/list/black_market_sold_items

	/// If the players killed him by sending a live hostile below.. this goes false and they can't order any more contraband.
	var/mendoza_status = TRUE

	/// How many processing intervals do we get random crates for each pool. Currently only [ASRS_POOL_MAIN] gets scaled amount of crates.
	var/list/base_random_crate_intervals = list(ASRS_POOL_MAIN = 10, ASRS_POOL_FOOD = 60)
	/// How many partial crates are stored in ASRS per pool to smooth amount given out
	var/list/random_crates_carry = list()
	/// Pools mapped to list of random ASRS packs that belong to it
	var/list/asrs_supply_packs_by_pool

	var/crate_iteration = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	//shuttle movement
	var/datum/shuttle/ferry/supply/shuttle

	var/obj/structure/machinery/computer/supplycomp/bound_supply_computer_list

	var/list/all_supply_groups = list(
		"Operations",
		"Weapons",
		"Vehicle Ammo",
		"Vehicle Equipment",
		"Attachments",
		"Ammo",
		"Weapons Specialist Ammo",
		"Restricted Equipment",
		"Clothing",
		"Medical",
		"Engineering",
		"Research",
		"Supplies",
		"Food",
		"Gear",
		"Mortar",
		"Explosives",
		"Reagent tanks",
		)

	var/list/contraband_supply_groups = list(
		"Seized Items",
		"Shipside Contraband",
		"Surplus Equipment",
		"Contraband Ammo",
		"Deep Storage",
		"Miscellaneous"
		)

	//dropship part fabricator's points, so we can reference them globally (mostly for DEFCON)
	var/dropship_points = 10000 //gains roughly 18 points per minute | Original points of 5k doubled due to removal of prespawned ammo.
	var/tank_points = 0

/datum/controller/supply/New()
	. = ..()
	ordernum = rand(1,9000)
	LAZYINITLIST(black_market_sold_items)
	asrs_supply_packs_by_pool = list()
	for(var/subtype in subtypesof(/datum/supply_packs_asrs))
		var/datum/supply_packs_asrs/initial_datum = subtype
		var/pool = initial(initial_datum.pool)
		if(!pool)
			continue
		LAZYADD(asrs_supply_packs_by_pool[pool], new subtype())
	random_crates_carry = list()
	for(var/pool in base_random_crate_intervals)
		random_crates_carry[pool] = 0

/datum/controller/supply/proc/start_processing()
	START_PROCESSING(SSslowobj, src)

//Supply shuttle ticker - handles supply point regenertion and shuttle travelling between centcomm and the station
/datum/controller/supply/process(delta_time)
	iteration++
	points += points_per_process
	if(iteration < 20)
		return
	for(var/pool in base_random_crate_intervals)
		var/interval = base_random_crate_intervals[pool]
		if(interval && iteration % interval == 0 && length(shoppinglist) <= 20)
			add_random_crates(pool)
		crate_iteration++

//This adds function adds the amount of crates that calculate_crate_amount returns
/datum/controller/supply/proc/add_random_crates(pool)
	for(var/crate_count in 1 to calculate_crate_amount(pool))
		add_random_crate(pool)

//Here we calculate the amount of crates to spawn.
//Marines get one crate for each the amount of XENOS on the surface devided by the amount of marines per crate.
//They always get the mincrates amount.
/datum/controller/supply/proc/calculate_crate_amount(pool)
	if(pool != ASRS_POOL_MAIN)
		return 1 // Pool scaling coming in a future update if needed, for now tweak base_random_crate_intervals instead

	var/ground_xenos_amount = SSticker.mode.count_xenos(SSmapping.levels_by_trait(ZTRAIT_GROUND))
	var/crate_amount = max(0, sqrt(ground_xenos_amount/ASRS_XENO_CRATES_DIVIDER))

	if(crate_iteration <= 5 && crate_amount < 4)
		crate_amount = 4

	var/unit_crate_amount = floor(crate_amount)
	var/carry = crate_amount - unit_crate_amount
	random_crates_carry[pool] += carry
	var/total_carry = random_crates_carry[pool]

	if(total_carry >= 1)
		var/additional_crates = floor(total_carry)
		random_crates_carry[pool] -= additional_crates
		unit_crate_amount += additional_crates

	return unit_crate_amount

//Here we pick what crate type to send to the marines.
//This is a weighted pick based upon their cost.
//Their cost will go up if the crate is picked
/datum/controller/supply/proc/add_random_crate(pool)
	if(!asrs_supply_packs_by_pool[pool])
		return
	var/datum/supply_packs_asrs/supply_info = pick_weighted_crate(asrs_supply_packs_by_pool[pool])
	if(!GLOB.supply_packs_datums[supply_info.reference_package])
		return

	supply_info.cost = floor(supply_info.cost * ASRS_COST_MULTIPLIER) //We still do this to raise the weight
	//We have to create a supply order to make the system spawn it. Here we transform a crate into an order.
	var/datum/supply_order/supply_order = new /datum/supply_order()
	supply_order.ordernum = ordernum++
	supply_order.object = GLOB.supply_packs_datums[supply_info.reference_package]
	supply_order.orderedby = "ASRS"
	supply_order.approvedby = "ASRS"
	//We add the order to the shopping list
	shoppinglist += supply_order

//Here we weigh the crate based upon it's cost
/datum/controller/supply/proc/pick_weighted_crate(list/datum/supply_packs_asrs/cratelist)
	var/list/datum/supply_packs_asrs/weighted_crate_list = list()
	for(var/datum/supply_packs_asrs/crate in cratelist)
		var/weight = (floor(10000/crate.cost))
		weighted_crate_list[crate] = weight
	return pick_weight(weighted_crate_list)

//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/supply/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living) && !black_market_enabled)
		return TRUE

	for(var/i=1, i<=length(A.contents), i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

// Called when the elevator is lowered.
/datum/controller/supply/proc/sell()
	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)
		return

	// Sell crates.
	for(var/obj/structure/closet/crate/C in area_shuttle)
		points += points_per_crate
		qdel(C)

	// Sell manifests.
	var/screams = FALSE
	for(var/atom/movable/movable_atom in area_shuttle)
		if(istype(movable_atom, /obj/item/paper/manifest))
			var/obj/item/paper/manifest/M = movable_atom
			if(LAZYLEN(M.stamped))
				points += points_per_slip

		//black market points
		if(black_market_enabled)
			var/points_to_add = get_black_market_value(movable_atom)
			if(points_to_add == KILL_MENDOZA)
				screams = TRUE
				kill_mendoza()
			black_market_sold_items[movable_atom.type] += 1
			black_market_points += points_to_add

		// Don't disintegrate humans! Maul their corpse instead. >:)
		if(ishuman(movable_atom))
			var/timer = 0.5 SECONDS
			screams = TRUE
			for(var/index in 1 to 10)
				timer += 0.5 SECONDS
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(maul_human), movable_atom), timer)

		// Delete everything else.
		else qdel(movable_atom)

	if(screams)
		for(var/atom/computer as anything in bound_supply_computer_list)
			computer.balloon_alert_to_viewers("升降机里传来了可怕的声响！")

/proc/maul_human(mob/living/carbon/human/mauled_human)
	mauled_human.visible_message(SPAN_HIGHDANGER("机械正在碾压[mauled_human]！"), SPAN_HIGHDANGER("升降机的机械正在把你碾碎！"))

	if(mauled_human.stat != DEAD)
		mauled_human.emote("scream")

	mauled_human.throw_random_direction(2, spin = TRUE)
	mauled_human.apply_effect(5, WEAKEN)
	shake_camera(mauled_human, 20, 1)
	mauled_human.apply_armoured_damage(60, ARMOR_MELEE, BRUTE, rand_zone())

//Buyin
/datum/controller/supply/proc/buy()
	var/area/area_shuttle = shuttle?.get_location_area()
	if(!area_shuttle || !length(shoppinglist))
		return

	// Try to find an available turf to place our package
	var/list/turf/clear_turfs = list()
	for(var/turf/T in area_shuttle)
		if(T.density || LAZYLEN(T.contents))
			continue
		clear_turfs += T

	for(var/datum/supply_order/order in shoppinglist)
		// No space! Forget buying, it's no use.
		if(!length(clear_turfs))
			shoppinglist.Cut()
			return

		if(order.object.contraband == TRUE && prob(5))
		// Mendoza loaded the wrong order in. What a dunce!
			var/list/contraband_list
			for(var/supply_type in GLOB.supply_packs_datums)
				var/datum/supply_packs/supply_pack = GLOB.supply_packs_datums[supply_type]
				if(supply_pack.contraband == FALSE)
					continue
				LAZYADD(contraband_list, supply_pack)
			order.object = pick(contraband_list)

		// Container generation
		var/turf/target_turf = pick(clear_turfs)
		clear_turfs.Remove(target_turf)
		var/atom/container = target_turf
		var/datum/supply_packs/package = order.object
		if(package.containertype)
			container = new package.containertype(target_turf)
			if(package.containername)
				container.name = package.containername

		// Lock it up if it's something that can be
		if(isobj(container) && package.access)
			var/obj/lockable = container
			lockable.req_access = list(package.access)

		// Contents generation
		var/list/content_names = list()
		var/list/content_types = package.contains
		if(package.randomised_num_contained)
			content_types = list()
			for(var/i in 1 to package.randomised_num_contained)
				content_types += pick(package.contains)
		for(var/typepath in content_types)
			var/atom/item = new typepath(container)
			content_names += item.name

		// Manifest generation
		var/obj/item/paper/manifest/slip
		if(!package.contraband) // I'm sorry boss i misplaced it...
			slip = new /obj/item/paper/manifest(container)
			slip.ordername = package.get_display_name()
			slip.ordernum = order.ordernum
			slip.orderedby = order.orderedby
			slip.approvedby = order.approvedby
			slip.packages = content_names
			slip.generate_contents()
			slip.update_icon()
	shoppinglist.Cut()

/obj/item/paper/manifest
	name = "补给清单"
	var/ordername
	var/ordernum
	var/orderedby
	var/approvedby
	var/list/packages


/obj/item/paper/manifest/read_paper(mob/user, scramble = FALSE)
	var/paper_info = info
	if(scramble)
		paper_info = stars_decode_html(info)
	// Tossing ref in widow id as this allows us to read multiple manifests at same time
	show_browser(user, "<BODY class='paper'>[paper_info][stamps]</BODY>", null, "manifest\ref[src]", width = 550, height = 650)
	onclose(user, "manifest\ref[src]")

/obj/item/paper/manifest/proc/generate_contents()
	// You don't tell anyone this is inspired from player-made fax layouts,
	// or else, capiche ? Yes this is long, it's 80 col standard
	info = "   \
		<style>    \
			#container { width: 500px; min-height: 500px; margin: 25px auto;  \
					font-family: monospace; padding: 0; font-size: 130% }  \
			#title { font-size: 250%; letter-spacing: 8px; \
					font-weight: bolder; margin: 20px auto }   \
			.header { font-size: 130%; text-align: center; }   \
			.important { font-variant: small-caps; font-size = 130%;   \
						font-weight: bolder; }    \
			.tablelabel { width: 150px; }  \
			.field { font-style: italic; } \
			li { list-style-type: disc; list-style-position: inside; } \
			table { table-layout: fixed }  \
		</style><div id='container'>   \
		<div class='header'>   \
			<p id='title' class='important'>A.S.R.S.</p>   \
			<p class='important'>自动仓储检索系统</p>    \
			<p class='field'>订单 #[ordernum]</p> \
		</div><hr><table>  \
		<colgroup> \
			<col class='tablelabel important'> \
			<col class='field'>    \
		</colgroup>    \
		<tr><td>货物：</td> \
		<td>[ordername]</td></tr>  \
		<tr><td>申请人：</td>   \
		<td>[orderedby]</td></tr>  \
		<tr><td>批准人：</td>  \
		<td>[approvedby]</td></tr> \
		<tr><td>包裹数量：</td>   \
		<td class='field'>[length(packages)]</td></tr> \
		</table><hr><p class='header important'>内容</p>   \
		<ul class='field'>"

	for(var/packagename in packages)
		info += "<li>[packagename]</li>"

	info += "  \
		</ul><br/><hr><br/><p class='important header'>    \
			请在下方盖章并交回，确认货物已签收   \
		</p></div>"

	name = "[name] - [ordername]"

/obj/structure/machinery/computer/ordercomp/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/supplycomp/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/ordercomp/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_interaction(src)
	var/dat
	if(temp)
		dat = temp
	else
		var/datum/shuttle/ferry/supply/shuttle = GLOB.supply_controller.shuttle
		if (shuttle)
			dat += {"位置：[shuttle.has_arrive_time() ? "平台正在升起":shuttle.at_station() ? "已升起":"已降下"]<BR>
			<HR>补给预算：$[GLOB.supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>
		<BR>\n<A href='byond://?src=\ref[src];order=categories'>申请物品</A><BR><BR>
		<A href='byond://?src=\ref[src];vieworders=1'>查看已批准订单</A><BR><BR>
		<A href='byond://?src=\ref[src];viewrequests=1'>查看申请</A><BR><BR>
		<A href='byond://?src=\ref[user];mach_close=computer'>关闭</A>"}

	show_browser(user, dat, "自动仓储检索系统", "computer", width = 575, height = 450)
	return

/obj/structure/machinery/computer/ordercomp/Topic(href, href_list)
	if(..())
		return

	if( isturf(loc) && (in_range(src, usr) || isSilicon(usr)) )
		usr.set_interaction(src)

	if(href_list["order"])
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>补给预算：$[GLOB.supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
			temp += "<A href='byond://?src=\ref[src];mainmenu=1'>主菜单</A><HR><BR><BR>"
			temp += "<b>选择分类</b><BR><BR>"
			for(var/supply_group_name in GLOB.supply_controller.all_supply_groups)
				temp += "<A href='byond://?src=\ref[src];order=[supply_group_name]'>[localized_supply_group_name(supply_group_name)]</A><BR>"
		else
			last_viewed_group = href_list["order"]
			temp = "<b>补给预算：$[GLOB.supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
			temp += "<A href='byond://?src=\ref[src];order=categories'>返回全部分类</A><HR><BR><BR>"
			temp += "<b>申请分类：[localized_supply_group_name(last_viewed_group)]</b><BR><BR>"
			for(var/supply_type in GLOB.supply_packs_datums)
				var/datum/supply_packs/supply_pack = GLOB.supply_packs_datums[supply_type]
				if(supply_pack.contraband || supply_pack.group != last_viewed_group || !supply_pack.buyable)
					continue //Have to send the type instead of a reference to
				temp += "<A href='byond://?src=\ref[src];doorder=[supply_pack.name]'>[supply_pack.get_display_name()]</A> 价格：$[floor(supply_pack.cost) * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>" //the obj because it would get caught by the garbage

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b> 的屏幕闪烁着：\"还需 [world.time - reqtime] 秒才能再次打印军需申请单。\"", SHOW_MESSAGE_VISIBLE)
			return

		//Find the correct supply_pack datum
		var/supply_pack_type = GLOB.supply_packs_types[href_list["doorder"]]
		if(!supply_pack_type)
			return
		var/datum/supply_packs/supply_pack = GLOB.supply_packs_datums[supply_pack_type]

		if(supply_pack.contraband || !supply_pack.buyable)
			return

		var/timeout = world.time + 600
		var/reason = strip_html(input(usr,"事由：","你为什么需要这件物品？","") as null|text)
		if(world.time > timeout) return
		if(!reason) return

		var/idname = "*未提供*"
		var/idrank = "*未提供*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(isSilicon(usr))
			idname = usr.real_name

		GLOB.supply_controller.ordernum++
		var/obj/item/paper/reqform = new /obj/item/paper(loc)
		reqform.name = "军需申请单：[supply_pack.get_display_name()]"
		reqform.info += "<h3>[MAIN_SHIP_NAME]补给申请单</h3><hr>"
		reqform.info += "编号：#[GLOB.supply_controller.ordernum]<br>"
		reqform.info += "申请人：[idname]<br>"
		reqform.info += "军衔：[localized_player_label(idrank)]<br>"
		reqform.info += "原因：[reason]<br>"
		reqform.info += "补给箱类型：[supply_pack.get_display_name()]<br>"
		reqform.info += "权限限制：[get_access_desc(supply_pack.access)]<br>"
		reqform.info += "内容：<br>"
		reqform.info += supply_pack.manifest
		reqform.info += "<hr>"
		reqform.info += "在下方盖章以批准此申请：<br>"

		reqform.update_icon() //Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/supply_order = new /datum/supply_order()
		supply_order.ordernum = GLOB.supply_controller.ordernum
		supply_order.object = supply_pack
		supply_order.orderedby = idname
		GLOB.supply_controller.requestlist += supply_order

		temp = "感谢提交申请，货运部门会尽快处理。<BR>"
		temp += "<BR><A href='byond://?src=\ref[src];order=[last_viewed_group]'>返回</A> <A href='byond://?src=\ref[src];mainmenu=1'>主菜单</A>"

	else if (href_list["vieworders"])
		temp = "当前已批准的订单：<BR><BR>"
		for(var/S in GLOB.supply_controller.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.get_display_name()]，批准人：[SO.approvedby]<BR>"
		temp += "<BR><A href='byond://?src=\ref[src];mainmenu=1'>确定</A>"

	else if (href_list["viewrequests"])
		temp = "当前申请：<BR><BR>"
		for(var/S in GLOB.supply_controller.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.get_display_name()]，申请人：[SO.orderedby]<BR>"
		temp += "<BR><A href='byond://?src=\ref[src];mainmenu=1'>确定</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/structure/machinery/computer/supplycomp/attack_hand(mob/user as mob)
	if(!is_mainship_level(z)) return
	if(!allowed(user))
		to_chat(user, SPAN_DANGER("拒绝访问。"))
		return

	if(..())
		return
	user.set_interaction(src)
	post_signal("supply")
	var/dat
	if (temp)
		dat = temp
	else
		var/datum/shuttle/ferry/supply/shuttle = GLOB.supply_controller.shuttle
		if (shuttle)
			dat += "\n平台位置："
			if (shuttle.has_arrive_time())
				dat += "移动中<BR>"
			else
				if (shuttle.at_station())
					if (shuttle.docking_controller)
						switch(shuttle.docking_controller.get_docking_status())
							if ("docked") dat += "Raised<BR>"
							if ("undocked") dat += "Lowered<BR>"
							if ("docking") dat += "Raising [shuttle.can_force()? SPAN_WARNING("<A href='byond://?src=\ref[src];force_send=1'>Force</A>") : ""]<BR>"
							if ("undocking") dat += "Lowering [shuttle.can_force()? SPAN_WARNING("<A href='byond://?src=\ref[src];force_send=1'>Force</A>") : ""]<BR>"
					else
						dat += "已升起<BR>"

					if (shuttle.can_launch())
						dat += "<A href='byond://?src=\ref[src];send=1'>降下平台</A>"
					else if (shuttle.can_cancel())
						dat += "<A href='byond://?src=\ref[src];cancel_send=1'>取消</A>"
					else
						dat += "*自动仓储检索系统忙碌中*"
					dat += "<BR>\n<BR>"
				else
					dat += "已降下<BR>"
					if (shuttle.can_launch())
						dat += "<A href='byond://?src=\ref[src];send=1'>升起平台</A>"
					else if (shuttle.can_cancel())
						dat += "<A href='byond://?src=\ref[src];cancel_send=1'>取消</A>"
					else
						dat += "*自动仓储检索系统忙碌中*"
					dat += "<BR>\n<BR>"


		dat += {"<HR>\n补给预算：$[GLOB.supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>\n<BR>
		\n<A href='byond://?src=\ref[src];order=categories'>订购物品</A><BR>\n<BR>
		\n<A href='byond://?src=\ref[src];viewrequests=1'>查看申请</A><BR>\n<BR>
		\n<A href='byond://?src=\ref[src];vieworders=1'>查看订单</A><BR>\n<BR>
		\n<A href='byond://?src=\ref[user];mach_close=computer'>关闭</A>"}


	show_browser(user, dat, "自动仓储检索系统", "computer", width = 575, height = 450)
	return

/obj/structure/machinery/computer/supplycomp/Topic(href, href_list)
	if(!is_mainship_level(z)) return
	if(!GLOB.supply_controller)
		world.log << "## ERROR: Eek. The GLOB.supply_controller controller datum is missing somehow."
		return
	var/datum/shuttle/ferry/supply/shuttle = GLOB.supply_controller.shuttle
	if (!shuttle)
		world.log << "## ERROR: Eek. The supply/shuttle datum is missing somehow."
		return
	if(..())
		return

	if(isturf(loc) && in_range(src, usr) )
		usr.set_interaction(src)

	//Calling the shuttle
	if(href_list["send"])
		if(shuttle.at_station())
			if (shuttle.forbidden_atoms_check())
				temp = "出于安全考虑，自动仓储检索系统无法存放活体生物、机密核武器或定位信标。<BR><BR><A href='byond://?src=\ref[src];mainmenu=1'>确定</A>"
			else
				shuttle.launch(src)
				temp = "正在降下平台。\[[SPAN_WARNING("<A href='byond://?src=\ref[src];force_send=1'>强制执行</A>")]\]<BR><BR><A href='byond://?src=\ref[src];mainmenu=1'>确定</A>"
		else
			shuttle.launch(src)
			temp = "正在升起平台。<BR><BR><A href='byond://?src=\ref[src];mainmenu=1'>确定</A>"
			post_signal("supply")

	if (href_list["force_send"])
		shuttle.force_launch(src)

	if (href_list["cancel_send"])
		shuttle.cancel_launch(src)

	else if (href_list["order"])
		//if(!shuttle.idle()) return //this shouldn't be necessary it seems
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>补给预算：$[GLOB.supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
			temp += "<A href='byond://?src=\ref[src];mainmenu=1'>主菜单</A><HR><BR><BR>"
			temp += "<b>选择分类</b><BR><BR>"
			for(var/supply_group_name in GLOB.supply_controller.all_supply_groups)
				temp += "<A href='byond://?src=\ref[src];order=[supply_group_name]'>[localized_supply_group_name(supply_group_name)]</A><BR>"
			if(can_order_contraband)
				temp += "<A href='byond://?src=\ref[src];order=["Black Market"]'>[SPAN_DANGER("$E4RR301¿")]</A><BR>"
		else
			last_viewed_group = href_list["order"]
			if(last_viewed_group == "Black Market")
				handle_black_market(temp)
			else if(last_viewed_group in GLOB.supply_controller.contraband_supply_groups)
				handle_black_market_groups()
			else
				temp = "<b>补给预算：$[GLOB.supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
				temp += "<A href='byond://?src=\ref[src];order=categories'>返回全部分类</A><HR><BR><BR>"
				temp += "<b>申请分类：[localized_supply_group_name(last_viewed_group)]</b><BR><BR>"
				for(var/supply_type in GLOB.supply_packs_datums)
					var/datum/supply_packs/supply_pack = GLOB.supply_packs_datums[supply_type]
					if(!is_buyable(supply_pack))
						continue
					temp += "<A href='byond://?src=\ref[src];doorder=[supply_pack.name]'>[supply_pack.get_display_name()]</A> 价格：$[floor(supply_pack.cost) * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>"		//the obj because it would get caught by the garbage

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b> 的屏幕闪烁着：\"还需 [world.time - reqtime] 秒才能再次打印军需申请单。\"", SHOW_MESSAGE_VISIBLE)
			return

		//Find the correct supply_pack datum
		var/supply_pack_type = GLOB.supply_packs_types[href_list["doorder"]]
		var/datum/supply_packs/supply_pack = GLOB.supply_packs_datums[supply_pack_type]

		if(!istype(supply_pack))
			return

		if((supply_pack.contraband && !can_order_contraband) || !supply_pack.buyable || supply_pack.contraband && black_market_lockout)
			return

		var/timeout = world.time + 600
		//var/reason = copytext(sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text),1,MAX_MESSAGE_LEN)
		var/reason = "*未提供*"
		if(world.time > timeout) return
		if(!reason) return

		var/idname = "*未提供*"
		var/idrank = "*未提供*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(isSilicon(usr))
			idname = usr.real_name

		GLOB.supply_controller.ordernum++
		var/obj/item/paper/reqform = new /obj/item/paper(loc)
		reqform.name = "军需申请单：[supply_pack.get_display_name()]"
		reqform.info += "<h3>[MAIN_SHIP_NAME]补给申请单</h3><hr>"
		reqform.info += "编号：#[GLOB.supply_controller.ordernum]<br>"
		reqform.info += "申请人：[idname]<br>"
		reqform.info += "军衔：[localized_player_label(idrank)]<br>"
		reqform.info += "原因：[reason]<br>"
		reqform.info += "补给箱类型：[supply_pack.get_display_name()]<br>"
		reqform.info += "权限限制：[get_access_desc(supply_pack.access)]<br>"
		reqform.info += "内容：<br>"
		reqform.info += supply_pack.manifest
		reqform.info += "<hr>"
		reqform.info += "在下方盖章以批准此申请：<br>"

		reqform.update_icon() //Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/supply_order = new /datum/supply_order()
		supply_order.ordernum = GLOB.supply_controller.ordernum
		supply_order.object = supply_pack
		supply_order.orderedby = idname
		GLOB.supply_controller.requestlist += supply_order

		temp = "订单申请已提交。<BR>"
		temp += "<BR><A href='byond://?src=\ref[src];order=[last_viewed_group]'>返回</A>|<A href='byond://?src=\ref[src];mainmenu=1'>主菜单</A>|<A href='byond://?src=\ref[src];confirmorder=[supply_order.ordernum]'>批准订单</A>"

	else if(href_list["confirmorder"])
		//Find the correct supply_order datum
		var/ordernum = text2num(href_list["confirmorder"])
		var/datum/supply_order/supply_order
		var/datum/supply_packs/supply_pack
		temp = "无效申请"
		temp += "<BR><A href='byond://?src=\ref[src];order=[last_viewed_group]'>返回</A>|<A href='byond://?src=\ref[src];mainmenu=1'>主菜单</A>"

		if(length(GLOB.supply_controller.shoppinglist) > 20)
			to_chat(usr, SPAN_DANGER("当前取货负载已达上限。"))
			return

		for(var/i=1, i<=length(GLOB.supply_controller.requestlist), i++)
			var/datum/supply_order/SO = GLOB.supply_controller.requestlist[i]
			if(SO.ordernum == ordernum)
				supply_order = SO
				supply_pack = supply_order.object
				if(GLOB.supply_controller.points >= floor(supply_pack.cost) && GLOB.supply_controller.black_market_points >= supply_pack.dollar_cost)
					GLOB.supply_controller.requestlist.Cut(i,i+1)
					GLOB.supply_controller.points -= floor(supply_pack.cost)
					GLOB.supply_controller.black_market_points -= floor(supply_pack.dollar_cost)
					if(GLOB.supply_controller.black_market_heat != -1) //-1 Heat means heat is disabled
						GLOB.supply_controller.black_market_heat = clamp(GLOB.supply_controller.black_market_heat + supply_pack.crate_heat + (supply_pack.crate_heat * rand(rand(-0.25,0),0.25)), 0, 100) // black market heat added is crate heat +- up to 25% of crate heat
					GLOB.supply_controller.shoppinglist += supply_order
					supply_pack.cost = supply_pack.cost * SUPPLY_COST_MULTIPLIER
					temp = "感谢订购。<BR>"
					temp += "<BR><A href='byond://?src=\ref[src];viewrequests=1'>返回</A> <A href='byond://?src=\ref[src];mainmenu=1'>主菜单</A>"
					supply_order.approvedby = usr.name
					msg_admin_niche("[key_name(usr)] confirmed supply order of [supply_pack.name].")
					if(GLOB.supply_controller.black_market_heat == 100)
						GLOB.supply_controller.black_market_investigation()
					var/pack_source = "Cargo Hold"
					var/pack_name = supply_pack.name
					if(supply_pack.dollar_cost)
						pack_source = "Unknown"
						if(prob(90))
							pack_name = "Unknown"
					log_ares_requisition(pack_source, pack_name, usr.name)
				else
					temp = "剩余资金不足。<BR>"
					temp += "<BR><A href='byond://?src=\ref[src];viewrequests=1'>返回</A> <A href='byond://?src=\ref[src];mainmenu=1'>主菜单</A>"
				break

	else if (href_list["vieworders"])
		temp = "当前已批准的订单：<BR><BR>"
		for(var/S in GLOB.supply_controller.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.get_display_name()]，批准人：[SO.approvedby]<BR>"// <A href='byond://?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='byond://?src=\ref[src];mainmenu=1'>确定</A>"
/*
	else if (href_list["cancelorder"])
		var/datum/supply_order/remove_supply = href_list["cancelorder"]
		supply_shuttle_shoppinglist -= remove_supply
		supply_shuttle_points += remove_supply.object.cost
		temp += "Canceled: [remove_supply.object.name]<BR><BR><BR>"

		for(var/S in supply_shuttle_shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby] <A href='byond://?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='byond://?src=\ref[src];mainmenu=1'>OK</A>"
*/
	else if (href_list["viewrequests"])
		temp = "当前申请：<BR><BR>"
		for(var/S in GLOB.supply_controller.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.get_display_name()]，申请人：[SO.orderedby] <A href='byond://?src=\ref[src];confirmorder=[SO.ordernum]'>批准</A> <A href='byond://?src=\ref[src];rreq=[SO.ordernum]'>移除</A><BR>"

		temp += "<BR><A href='byond://?src=\ref[src];clearreq=1'>清空列表</A>"
		temp += "<BR><A href='byond://?src=\ref[src];mainmenu=1'>确定</A>"

	else if (href_list["rreq"])
		var/ordernum = text2num(href_list["rreq"])
		temp = "无效申请.<BR>"
		for(var/i=1, i<=length(GLOB.supply_controller.requestlist), i++)
			var/datum/supply_order/SO = GLOB.supply_controller.requestlist[i]
			if(SO.ordernum == ordernum)
				GLOB.supply_controller.requestlist.Cut(i,i+1)
				temp = "申请已移除。<BR>"
				break
		temp += "<BR><A href='byond://?src=\ref[src];viewrequests=1'>返回</A> <A href='byond://?src=\ref[src];mainmenu=1'>主菜单</A>"

	else if (href_list["clearreq"])
		GLOB.supply_controller.requestlist.Cut()
		temp = "列表已清空。<BR>"
		temp += "<BR><A href='byond://?src=\ref[src];mainmenu=1'>确定</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/structure/machinery/computer/supplycomp/proc/handle_black_market()

	temp = "<b>维兰德-汤谷货币：$[GLOB.supply_controller.black_market_points]</b><BR>"
	temp += "<A href='byond://?src=\ref[src];order=categories'>返回全部分类</A><HR><BR><BR>"
	temp += SPAN_DANGER("错误：未知分类<HR><HR><HR>")
	if(black_market_lockout)
		temp += "<DIV ALIGN='center'><BR><img src='cmblogo.png'><BR><BR><BR><BR><FONT SIZE=4><B>已移除未经授权的访问。<BR>该控制台目前正接受殖民地执法局调查。<BR>感谢配合。</FONT></div></B>"
		return
	temp += "信号不稳定……"
	if(!GLOB.supply_controller.mendoza_status) // he's daed
		temp += "........."
		return
	handle_mendoza_dialogue() //mendoza has been in there for a while. he gets lonely sometimes
	temp += "<b>[localized_supply_group_name(last_viewed_group)]</b><BR><BR>"

	for(var/supply_group_name in GLOB.supply_controller.contraband_supply_groups)
		temp += "<A href='byond://?src=\ref[src];order=[supply_group_name]'>[localized_supply_group_name(supply_group_name)]</A><BR>"

/obj/structure/machinery/computer/supplycomp/proc/handle_black_market_groups()
	temp = "<b>维兰德-汤谷货币：$[GLOB.supply_controller.black_market_points]</b><BR>"
	temp += "<A href='byond://?src=\ref[src];order=Black Market'>返回黑市分类</A><HR><BR><BR>"
	temp += "<b>购买分类：[localized_supply_group_name(last_viewed_group)]</b><BR><BR>"
	for(var/supply_type in GLOB.supply_packs_datums)
		var/datum/supply_packs/supply_pack = GLOB.supply_packs_datums[supply_type]
		if(!is_buyable(supply_pack))
			continue
		temp += "<A href='byond://?src=\ref[src];doorder=[supply_pack.name]'>[supply_pack.get_display_name()]</A> 价格：$[floor(supply_pack.dollar_cost)]<BR>"

/obj/structure/machinery/computer/supplycomp/proc/handle_mendoza_dialogue()

	if(first_time)
		first_time = FALSE
		temp += SPAN_WARNING("等等——我操，什么？喂，喂！终于接通了！天知道多久以前，我就把那块电路板塞进替换件发走了。我都彻底不抱希望了。<BR>")
		temp += SPAN_WARNING("你大概有不少问题，对，对……让我来解释。<BR><HR>")
		//linebreak
		temp += SPAN_WARNING("我叫门多萨，货运技术员。应该说，曾经是。天知道多久前，我掉进了这个蠢坑。幸好有一箱床垫接住了我。那群该死的宪兵居然都没来找过我！<BR>")
		temp += SPAN_WARNING("他们大概把我的档案当成文书错误注销了。一群混蛋……不过我有个计划。<BR>")
		temp += SPAN_WARNING("等这艘船下次停靠，我就把这些仓储货物全走私出去，卖掉，然后拿钱把殖民地陆战队告得倾家荡产！<BR>")
		temp += SPAN_WARNING("想想他们会是什么表情！小小货运技术员门多萨站在法庭上，眼看他们赔个精光！<BR><HR>")
		//linebreak
		temp += SPAN_WARNING("不过我需要……钱。你根本想不到我在这里见过什么。有整整一排自动手术舱箱子，这还只是冰山一角。<BR>")
		temp += SPAN_WARNING("交易是这样的：有些……东西，我得卖掉才能实施计划。只要值钱就行，矿物、黄金、独特物品……用仓储升降机送下来。<BR>")
		temp += SPAN_WARNING("送下来就拿不回去了，这里的机械危险得要命。不过，作为交换，我会给你们……一些东西。查扣装备、“药品”，还有我在这里翻到的各种玩意儿。<BR>")
		temp += SPAN_WARNING("货物会通过仓储升降机送上去。第一件货物里有一台拼装扫描仪，用它就能知道我到底收不收你扫的东西。<BR><HR>")
		//linebreak
		temp += SPAN_WARNING("怕你们这群蠢货又搞砸，我再讲一遍：<b>塞现金，买扫描仪，找值钱货，用升降机送下来，赚货币，买违禁品。</b><BR>")
		temp += SPAN_WARNING("回头见……<BR>")
		return

	var/rng = rand(1, 100) // Will only sometimes give messages
	switch(rng)
		if(1 to 5)
			temp += "有时候我……能听见这里有动静。开箱子、翻东西的声音，有时……甚至有呼吸声和咀嚼声。连仓储系统在维护模式时都一样。<BR>"
			temp += "我发誓，上个月我在屏幕边缘瞥见一个光着膀子的疯子跑了过去。这地方闹鬼。<BR>"
		if(6 to 10)
			temp += "记得我说有整排自动手术舱箱子吗？我又找到<i>一整排！</i><BR>"
			temp += "这排还有全身扫描仪、医疗休眠舱、维兰德医疗柜……这些东西怎么他妈的不在补给清单上？又为什么会堆在这里？<BR>"
		if(11 to 15)
			temp += "你知道吗，这地方简直是个巨大的安全隐患。舰上这片区域根本没人维护。<BR>"
			temp += "自从朔姆贝格那次殖民地行动毁了我们半个货舱，这里的东西就没怎么正常过。<BR>"
			temp += "机械臂从老高的地方随便往下扔箱子，还把货架撞翻……真他妈丢人！<BR>"
			temp += "等这破船被凿沉，想来废船场里捞点东西的拆船工可就倒霉了。<BR>"
		if(16 to 20)
			temp += "我到现在都不敢相信，全舰的高爆穿甲弹居然全炸了。有个蠢货竟然把爆炸弹药堆在舰体旁边。<BR>"
			temp += "先不说爆炸风险，那可是我们的主力弹药！这次行动陆战队用什么？软尖弹？老天。<BR>"
			temp += "我偶尔还能找到零散的高爆穿甲弹匣，但我可不会把它们扔上升降机。八成会让某个乳臭未干的新兵捡走，把战友炸个粉碎。<BR>"
		if(21 to 25)
			temp += "想知道个秘密吗？那些塞满乱七八糟东西的箱子，都是我推上仓储升降机的。<BR>"
			temp += "不是因为我知道你们需要剩余冲锋枪弹药之类的。这些破箱子太占地方了。我们为什么要囤几百发迫击炮弹？天啊，这里简直像在重演第二次世界大战！<BR>"
		if(26 to 30)
			temp += "这个……别告诉别人，不知道为什么，我特别喜欢蓝色口味的索托。不是无糖版，那种青色玩意儿和其他口味一样难喝；但蓝色那款就是……有股好滋味。看到的话，不妨给我从升降机扔几罐下来。<BR>"
		if(31 to 35)
			temp += "要是看到什么……“精锐”装备，记得送下来。我认识几个人，愿意出大价钱买殖民地陆战队指挥官的枪，或者宠物。连护甲都值一大笔钱。不过，可别为此送命。<BR>"
			temp += "其实，野生动物也行！只要不是仿生动物，在地球都值一大笔钱，我会给你们不少点数。当然，前提是它不打算杀了我。<BR>"

/proc/get_black_market_value(atom/movable/movable_atom)
	var/return_value
	if(istype(movable_atom, /obj/item/stack))
		var/obj/item/stack/black_stack = movable_atom
		return_value += (black_stack.black_market_value * black_stack.amount)
	else
		return_value = movable_atom.black_market_value

	// so they cant sell the same thing over and over and over
	return_value = POSITIVE(return_value - GLOB.supply_controller.black_market_sold_items[movable_atom.type] * 0.5)
	return return_value

/datum/controller/supply/proc/kill_mendoza()
	if(!mendoza_status)
		return //cant kill him twice

	mendoza_status = FALSE // he'll die soon enough, and in the meantime will be too busy to handle requests.

	//mendoza notices the bad guy

	play_sound_handler("alien_growl", 0.5 SECONDS)
	play_sound_handler("male_scream", 1 SECONDS)

	//mendoza is attacked by it
	play_sound_handler("alien_claw_flesh", 2 SECONDS)
	play_sound_handler("alien_claw_flesh", 2.5 SECONDS)
	play_sound_handler(pick("male_scream", "male_pain"), 3 SECONDS)

	//reacting...
	play_sound_handler("gun_shotgun_tactical", 4 SECONDS)
	play_sound_handler("gun_shotgun_tactical", 5 SECONDS)
	play_sound_handler("m4a3", 6 SECONDS)
	play_sound_handler("m4a3", 6.5 SECONDS)
	play_sound_handler("m4a3", 7 SECONDS)
	play_sound_handler("m4a3", 7.5 SECONDS)

	//it didnt work.
	play_sound_handler(pick("male_scream", "male_pain"), 8.5 SECONDS)
	play_sound_handler(pick("male_scream", "male_pain"), 9 SECONDS)

	// he's dead!
	play_sound_handler("alien_bite", 10 SECONDS)
	play_sound_handler('sound/handling/click_2.ogg', 11 SECONDS) // armor suit light turns off (cause he died)

	var/list/turf/open/clear_turfs = list()
	var/area/area_shuttle = shuttle?.get_location_area()
	if(!area_shuttle)
		return
	for(var/turf/elevator_turfs in area_shuttle)
		if(elevator_turfs.density || LAZYLEN(elevator_turfs.contents))
			continue
		clear_turfs |= elevator_turfs
	var/turf/chosen_turf = pick(clear_turfs)

	//his corpse
	new /obj/effect/decal/remains/human(chosen_turf)
	new /obj/effect/decal/cleanable/blood(chosen_turf)

	//some of his blood
	new /obj/effect/decal/cleanable/blood(pick(clear_turfs))
	new /obj/effect/decal/cleanable/blood(pick(clear_turfs))

	//some of the xeno's blood
	new /obj/effect/decal/cleanable/blood/xeno(pick(clear_turfs))

/datum/controller/supply/proc/get_rand_sound_tile()
	var/atom/sound_tile = pick(GLOB.asrs_empty_space_tiles_list)
	return sound_tile

/datum/controller/supply/proc/play_sound_handler(sound_to_play, timer)
	/// For code readability.
	addtimer(CALLBACK(GLOBAL_PROC, /proc/playsound, get_rand_sound_tile(), sound_to_play, 25, FALSE), timer)

/datum/controller/supply/proc/black_market_investigation()
	black_market_heat = -1
	SSticker.mode.get_specific_call(/datum/emergency_call/inspection_cmb/black_market, TRUE, TRUE) // "Inspection - Colonial Marshals Ledger Investigation Team"
	log_game("Black Market Inspection auto-triggered.")

/obj/structure/machinery/computer/supplycomp/proc/is_buyable(datum/supply_packs/supply_pack)

	if(supply_pack.group != last_viewed_group)
		return

	if(!supply_pack.buyable)
		return

	if(supply_pack.contraband && !can_order_contraband || supply_pack.contraband && black_market_lockout)
		return

	if(isnull(supply_pack.contains) && isnull(supply_pack.containertype))
		return

	return TRUE

/obj/structure/machinery/computer/supplycomp/proc/post_signal(command)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)

/obj/structure/machinery/computer/supplycomp/vehicle
	name = "载具自动仓储检索系统控制台"
	desc = "自动仓储检索系统控制台，连接着载具深层储藏区。"
	req_access = list(ACCESS_MARINE_CREWMAN)
	circuit = /obj/item/circuitboard/computer/supplycomp/vehicle
	// Can only retrieve one vehicle per round
	var/spent = FALSE
	var/tank_unlocked = TRUE
	var/list/allowed_roles = list(JOB_TANK_CREW)

	var/list/vehicles

/datum/vehicle_order
	var/name = "载具订单"

	var/obj/vehicle/ordered_vehicle
	var/unlocked = TRUE
	var/failure_message = "<font color=\"red\"><b>本次行动分配的资源不足，无法修复这辆载具。</b></font><br>"

/datum/vehicle_order/proc/has_vehicle_lock()
	return FALSE

/datum/vehicle_order/proc/on_created(obj/vehicle/V)
	return

/datum/vehicle_order/tank
	name = "M34A2“朗斯特里特”轻型坦克"
	ordered_vehicle = /obj/effect/vehicle_spawner/tank/decrepit

/datum/vehicle_order/tank/has_vehicle_lock()
	return

/datum/vehicle_order/tank/broken
	name = "受损的M34A2“朗斯特里特”轻型坦克"
	ordered_vehicle = /obj/effect/vehicle_spawner/tank/hull/broken

/datum/vehicle_order/tank/plain
	name = "M34A2“朗斯特里特”轻型坦克"
	ordered_vehicle = /obj/effect/vehicle_spawner/tank

/datum/vehicle_order/apc
	name = "M577装甲运兵车"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc/decrepit

/datum/vehicle_order/apc/med
	name = "M577-MED医疗装甲运兵车"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc_med/decrepit

/datum/vehicle_order/apc/cmd
	name = "M577-CMD指挥装甲运兵车"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc_cmd/decrepit

/datum/vehicle_order/apc/empty
	name = "简装M577装甲运兵车"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc/unarmed/broken

/datum/vehicle_order/arc
	name = "M540-B装甲侦察车"
	ordered_vehicle = /obj/effect/vehicle_spawner/arc

/datum/vehicle_order/arc/has_vehicle_lock()
	return

/obj/structure/machinery/computer/supplycomp/vehicle/Initialize()
	. = ..()

	vehicles = list(
		new /datum/vehicle_order/tank/plain
	)

	if(!GLOB.VehicleElevatorConsole)
		GLOB.VehicleElevatorConsole = src

/obj/structure/machinery/computer/supplycomp/vehicle/Destroy()
	GLOB.VehicleElevatorConsole = null
	return ..()

/obj/structure/machinery/computer/supplycomp/vehicle/attack_hand(mob/living/carbon/human/H as mob)
	if(inoperable())
		return

	if(LAZYLEN(allowed_roles) && !allowed_roles.Find(H.job)) //replaced Z-level restriction with role restriction.
		to_chat(H, SPAN_WARNING("你无法使用这台控制台。"))
		return

	if(!allowed(H))
		to_chat(H, SPAN_DANGER("拒绝访问。"))
		return

	H.set_interaction(src)
	post_signal("supply_vehicle")

	var/dat = ""

	if(!SSshuttle.vehicle_elevator)
		return

	dat += "平台位置："
	if (SSshuttle.vehicle_elevator.mode != SHUTTLE_IDLE)
		dat += "移动中"
	else
		if(is_mainship_level(SSshuttle.vehicle_elevator.z))
			dat += "已升起"
			if(!spent)
				dat += "<br>\[<a href='byond://?src=\ref[src];lower_elevator=1'>降下</a>\]"
		else
			dat += "已降下"
	dat += "<br><hr>"

	if(spent)
		dat += "目前没有可供提取的载具。"
	else
		dat += "可用载具：<br>"

		for(var/d in vehicles)
			var/datum/vehicle_order/VO = d

			if(VO.has_vehicle_lock())
				dat += VO.failure_message
			else
				dat += "<a href='byond://?src=\ref[src];get_vehicle=\ref[VO]'>[VO.name]</a><br>"

	show_browser(H, dat, "自动仓储检索系统", "computer", width = 575, height = 450)

/obj/structure/machinery/computer/supplycomp/vehicle/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!is_mainship_level(z))
		return
	if(spent)
		return
	if(!GLOB.supply_controller)
		world.log << "## ERROR: Eek. The GLOB.supply_controller controller datum is missing somehow."
		return

	if (!SSshuttle.vehicle_elevator)
		world.log << "## ERROR: Eek. The supply/elevator datum is missing somehow."
		return

	if(isturf(loc) && ( in_range(src, usr) || isSilicon(usr) ) )
		usr.set_interaction(src)

	if(href_list["get_vehicle"])
		if(is_mainship_level(SSshuttle.vehicle_elevator.z) || SSshuttle.vehicle_elevator.mode != SHUTTLE_IDLE)
			to_chat(usr, SPAN_WARNING("升降机必须停靠在货舱，才能提取载具！"))
			return
		// dunno why the +1 is needed but the vehicles spawn off-center
		var/turf/middle_turf = get_turf(SSshuttle.vehicle_elevator)

		var/obj/vehicle/multitile/ordered_vehicle

		var/datum/vehicle_order/VO = locate(href_list["get_vehicle"])
		if(!(VO in vehicles))
			return

		if(VO?.has_vehicle_lock())
			return
		spent = TRUE
		ordered_vehicle = new VO.ordered_vehicle(middle_turf)
		SSshuttle.vehicle_elevator.request(SSshuttle.getDock("almayer vehicle"))

		VO.on_created(ordered_vehicle)

		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_VEHICLE_ORDERED, ordered_vehicle)

	else if(href_list["lower_elevator"])
		if(!is_mainship_level(SSshuttle.vehicle_elevator.z))
			return

		SSshuttle.vehicle_elevator.request(SSshuttle.getDock("adminlevel vehicle"))

	add_fingerprint(usr)
	updateUsrDialog()
