/* List of Reqs Line tutorial stages */
#define TUTORIAL_REQS_LINE_STAGE_STARTING 0    //! Reqs Tutorial Stage 0: Get in position
#define TUTORIAL_REQS_LINE_STAGE_ATTACHIES 1   //! Reqs Tutorial Stage 1: Give me some attachies
#define TUTORIAL_REQS_LINE_STAGE_GEARBOX 2     //! Reqs Tutorial Stage 2: I would like an HPR
#define TUTORIAL_REQS_LINE_STAGE_MIXED 3       //! Reqs Tutorial Stage 3: Multiple items. Also toss something over..
#define TUTORIAL_REQS_LINE_STAGE_SURVIVAL 4    //! Reqs Tutorial Stage 4: SURVIVAL MODE, random requests in a loop

/// How fast to increase difficulty in survival mode (amount of items/agents)
#define TUTORIAL_REQS_LINE_SURVIVAL_DIFFICULTY (1/3)

/// Simulates the Requisitions Line experience for newcomers
/datum/tutorial/marine/reqs_line
	name = "陆战队员——军需发放"
	desc = "学习如何作为货运技师处理军需部发放队列。"
	icon_state = "cargotech"
	tutorial_id = "requisitions_line"
	tutorial_template = /datum/map_template/tutorial/reqs_line

	/// Current step of the tutorial we're at
	var/stage = TUTORIAL_REQS_LINE_STAGE_STARTING
	/// Current "remind" timer after which the agent will remind player of its request
	var/remind_timer
	/// Current "hint" timer after which we display visual cues like highlights
	var/hint_timer

	/// List of line 'agents', aka the dummies requesting items, sorted by line order
	/// During normal stages there is one per stage (except for Forgot stage),
	/// During Survival mode there would usually be two: one at the counter, and one moving.
	/// The agents are mapped to a list of item types requested.
	var/list/mob/living/carbon/human/agents = list()

	/// Active agent currently at the line
	var/mob/living/carbon/human/active_agent
	/// Specifically for [TUTORIAL_REQS_LINE_STAGE_MIXED], the agent that forgot an item
	var/mob/living/carbon/human/loser_agent

	/// Cooldown of confusion if an incorrect item is presented
	COOLDOWN_DECLARE(confused_cooldown)
	/// Crutch for confusion feedback to work with vending new()ing directly to table - only act surprised once per item type
	var/list/confused_types = list()

	/// Max amount of agents per survival wave
	var/max_survival_agents = 5
	/// Current survival wave
	var/survival_wave = 0
	/// Difficulty factor per survival wave, increasing both the amount of agents and requested items
	var/survival_difficulty = 1
	/// Max factor of additional items requested per agent in survival mode. 0.5 = 50% added maximum
	var/survival_request_random_factor = 0.5

	/*
	 * REQUESTS LISTS
	 *   Maps item types to their names, used for building the requests
	 */
	var/static/shopping_catalogue = list(
		/* ATTACHIES */
		/obj/item/attachable/extended_barrel = list("EB", "EB", "加长枪管", "加长枪管", "长枪管", "加长枪管"),
		/obj/item/attachable/magnetic_harness = list("MH", "MH", "磁力背带", "磁力背带", "磁力背带", "背带", "磁力背带"),
		/obj/item/attachable/reddot = list("RDS", "红点", "S5", "红点瞄准镜", "红点"),
		/obj/item/attachable/reflex = list("反射瞄准镜", "S6", "反射式瞄准镜", "S6"),
		/obj/item/attachable/scope = list("S8", "S8", "4倍镜", "4倍瞄准镜", "4倍瞄准镜", "S8瞄准镜"),
		/obj/item/attachable/angledgrip = list("AG", "倾斜握把", "倾斜握把", "倾斜握把", "倾斜握把"),
		/obj/item/attachable/gyro = list("陀螺稳定器"),
		/obj/item/attachable/lasersight = list("激光指示器", "激光瞄准器", "LS"),
		/obj/item/attachable/attached_gun/shotgun = list("U7", "下挂枪", "下挂霰弹枪", "迷你霰弹枪"),
		/obj/item/attachable/verticalgrip = list("VG", "垂直握把", "垂直握把"),
		/obj/item/attachable/stock/rifle = list("固定枪托", "M41枪托", "M41固定枪托"),
		/obj/item/attachable/stock/shotgun = list("M37枪托", "木制枪托"),
		/* GEAR */
		/obj/item/weapon/gun/rifle/m41a = list("M41", "M41", "M41A", "Mk2", "M4步枪"),
		/obj/item/weapon/gun/shotgun/pump = list("M37", "霰弹枪"),
		/obj/item/storage/box/guncase/mou53 = list("MOU", "MOU53", "MOU-53", "鼠式霰弹枪"),
		/obj/item/storage/box/guncase/lmg = list("HPR", "HPR套件", "重型脉冲步枪"),
		/obj/item/storage/box/guncase/m41aMK1 = list("MK1", "M41 Mk1", "MK1套件", "M41A MK1套件"),
		/obj/item/storage/box/guncase/m56d = list("M56D", "HMG", "M56"),
		/obj/item/storage/box/guncase/m2c = list("M2C"),
		/obj/item/storage/box/guncase/flamer = list("喷火器", "喷火器套件", "焚烧器"),
		/obj/item/storage/box/guncase/m79 = list("GL", "榴弹发射器", "M79", "M79榴弹发射器"),
		/obj/item/clothing/accessory/storage/black_vest = list("黑色弹挂", "黑色弹挂背心"),
		/obj/item/clothing/accessory/storage/black_vest/brown_vest = list("棕色弹挂", "棕色弹挂背心"),
		/obj/item/clothing/accessory/storage/webbing = list("弹挂", "普通弹挂", "弹挂"),
		/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit = list("燃料背包", "喷火兵背包", "G4-1背包", "喷火器背包"),
		/obj/item/storage/backpack/marine/satchel/rto = list("电话背包", "电话背包", "无线电背包"),
		/obj/item/storage/backpack/general_belt = list("G8", "G8腰带"),
		/obj/item/storage/pouch/magazine/large = list("大型弹匣袋", "大型弹匣袋"),
		/obj/item/storage/pouch/shotgun/large = list("霰弹袋", "霰弹弹药袋", "霰弹袋", "大型霰弹袋"),
		/obj/item/storage/box/flare/signal = list("信号照明弹", "一盒信号弹", "CAS信号弹"),
		/obj/item/device/motiondetector = list("MD", "运动探测器"),
		/obj/item/device/binoculars = list("望远镜", "双筒望远镜"),
		/obj/item/device/binoculars/range/designator = list("LD", "目标指示器", "激光目标指示器", "战术望远镜"),
		/obj/item/pamphlet/skill/jtac = list("JTAC训练手册"),
		/* Explosives */
		/obj/item/explosive/grenade/high_explosive = list("M40 HEDP", "HEDP"),
		/obj/item/explosive/grenade/incendiary = list("M40 HIDP", "燃烧雷", "燃烧手榴弹", "HIDP", "燃烧手榴弹"),
		/obj/item/explosive/plastic = list("C4", "C4", "塑胶炸药", "塑胶炸药"),
		/obj/item/explosive/plastic/breaching_charge = list("破门炸药", "破门装药", "破门装药"),
		/* AMMO */
		/obj/item/ammo_magazine/rifle/extended = list("加长弹匣", "MK2加长弹匣", "MK2加长弹匣"),
		/obj/item/ammo_magazine/smg/m39/ap = list("M39 AP", "M39 AP", "冲锋枪穿甲弹匣"),
		/obj/item/ammo_magazine/smartgun = list("智能枪弹鼓", "智能枪弹鼓"),
	)

/datum/tutorial/marine/reqs_line/Destroy(force)
	STOP_PROCESSING(SSfastobj, src)
	kill_timers()
	active_agent = null
	loser_agent = null
	QDEL_LIST(agents)
	var/obj/effect/landmark/tutorial/reqs_line_cleaner/line_cleaner = locate() in GLOB.landmarks_list
	qdel(line_cleaner)
	return ..()

/datum/tutorial/marine/reqs_line/init_map()
	var/obj/structure/machinery/cm_vending/sorted/attachments/blend/tutorial/attachies_vendor = new(loc_from_corner(2, 7))
	add_to_tracking_atoms(attachies_vendor)
	var/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend/tutorial/guns_vendor = new(loc_from_corner(3, 7))
	add_to_tracking_atoms(guns_vendor)
	var/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend/tutorial/ammo_vendor = new(loc_from_corner(4, 7))
	add_to_tracking_atoms(ammo_vendor)
	restock_vendors()

	var/turf/asker_turf = loc_from_corner(1, 6)
	RegisterSignal(asker_turf, COMSIG_TURF_ENTERED, PROC_REF(a_new_challenger_appears))
	var/turf/trade_turf = loc_from_corner(2, 6)
	RegisterSignal(trade_turf, COMSIG_TURF_ENTERED, PROC_REF(item_offered))
	var/turf/loser_turf = loc_from_corner(0, 6)
	RegisterSignal(loser_turf, COMSIG_TURF_ENTERED, PROC_REF(loser_got_the_item))

	// Crutch to be able to detect items that are spawned directly on the table
	RegisterSignal(attachies_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(scan_table_for_items))
	RegisterSignal(guns_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(scan_table_for_items))
	RegisterSignal(ammo_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(scan_table_for_items))

/datum/tutorial/marine/reqs_line/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/uscm_ship/cargo)
	// Remove their radio from CT preset
	var/mob/living/carbon/human/user = tutorial_mob
	var/obj/item/device/radio/headset/headset = user.wear_l_ear
	user.drop_inv_item_on_ground(headset)
	QDEL_NULL(headset)

/// Refills all the vendors on stage updates so the player shouldn't run out of stock
/datum/tutorial/marine/reqs_line/proc/restock_vendors()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/attachments/blend/tutorial, attachies_vendor)
	restock_one_vendor(attachies_vendor)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend/tutorial, cargo_vendor)
	restock_one_vendor(cargo_vendor)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend/tutorial, ammo_vendor)
	restock_one_vendor(ammo_vendor)

/// Refills a specific vendor to 99 items across the board
/datum/tutorial/marine/reqs_line/proc/restock_one_vendor(obj/structure/machinery/cm_vending/vendor)
	for(var/list/vendspec in vendor.listed_products)
		if(vendspec[2] >= 0)
			vendspec[2] = 99

/datum/tutorial/marine/reqs_line/process(delta_time)
	if(stage == TUTORIAL_REQS_LINE_STAGE_SURVIVAL && !length(agents))
		spawn_survival_wave()

	for(var/mob/living/carbon/human/agent as anything in agents)
		if(agent == loser_agent)
			continue
		if(agent == active_agent)
			agent.face_dir(EAST)
		else if(!agent_step(agent, NORTH))
			agent_step(agent, EAST)

/// Makes agents move on processing tick if they can. They check surroundings to ensure proper movement flow.
/datum/tutorial/marine/reqs_line/proc/agent_step(mob/living/carbon/human/agent, dir)
	var/turf/target_turf = get_step(agent, dir)
	if(target_turf.density)
		return FALSE
	if(locate(/mob/living) in target_turf)
		return FALSE
	// Don't try to step back through the turnstile
	if(dir == EAST && locate(/obj/structure/machinery/line_nexter) in target_turf)
		return FALSE
	. = TRUE
	agent.Move(target_turf, dir)

/// Creates a new agent with the given request list to queue in the line
/datum/tutorial/marine/reqs_line/proc/spawn_agent(list/request = list(), name_prefix)
	var/turf/target_turf = loc_from_corner(1, 2)
	var/mob/living/carbon/human/dummy/agent = new(target_turf)
	var/mob_name = "[name_prefix][random_name(agent.gender)]"
	agent.change_real_name(agent, mob_name)
	arm_equipment(agent, /datum/equipment_preset/uscm/tutorial_rifleman)
	agents[agent] = request
	RegisterSignal(agent, COMSIG_PARENT_QDELETING, PROC_REF(clean_agent))

/// Called to generate a new survival wave of agents
/datum/tutorial/marine/reqs_line/proc/spawn_survival_wave()
	survival_wave++
	message_to_player("第[survival_wave]波")
	var/agents_to_spawn = min(max_survival_agents, 1 + survival_wave * TUTORIAL_REQS_LINE_SURVIVAL_DIFFICULTY * survival_difficulty)
	for(var/agent_i in 1 to agents_to_spawn)
		var/items_requested = 1 + survival_wave * survival_difficulty * 0.5
		items_requested *= (1 + survival_request_random_factor * rand())
		spawn_survival_agent(round(items_requested))

/// Called to generate a single agent and request
/datum/tutorial/marine/reqs_line/proc/spawn_survival_agent(items_to_request)
	var/list/request = list()
	var/list/catalogue = list()
	// We make a custom catalogue copy to increase weighting of already requested items;
	// this avoids getting huge lists too quickly
	for(var/typepath in shopping_catalogue)
		catalogue += typepath
	for(var/i in 1 to items_to_request)
		request += pick(catalogue)
		if(i < 6) // Only telescope catalogues the first 5 times as the chances compound
			catalogue += request
	spawn_agent(request, "等级[survival_wave]·")

/// Called when an agent presents at the line window and needs to make a request
/datum/tutorial/marine/reqs_line/proc/a_new_challenger_appears(turf/source, mob/living/carbon/human/challenger)
	SIGNAL_HANDLER
	if(!(challenger in agents)) // Bob Vancelave NOT allowed
		return
	active_agent = challenger
	confused_types.Cut()
	var/list/request = agents[challenger]
	if(!length(request))
		make_agent_leave()
		return
	restock_vendors()
	var/speech = verbalize_request(request)
	var/greeting = pick("你好！", "嗨，", "嘿，", "你好。", "我需要", "请给我", "", "") // Yes, no greeting is a greeting option for real world accuracy
	var/trailing = pick("", "", "，麻烦了。", "，拜托啦，谢谢", "，谢谢。", "，快一点")
	challenger.say("[greeting][speech][trailing]") // Pleasantries for the first exchange only
	remind_timer = addtimer(CALLBACK(src, PROC_REF(remind_request)), 15 SECONDS, TIMER_STOPPABLE)
	hint_timer = addtimer(CALLBACK(src, PROC_REF(send_hints)), 3 SECONDS, TIMER_STOPPABLE)

/// Called when we need to remind the user of what we want served
/datum/tutorial/marine/reqs_line/proc/remind_request()
	var/list/request = agents[active_agent]
	var/speech = verbalize_request(request)
	active_agent.say(speech)
	remind_timer = addtimer(CALLBACK(src, PROC_REF(remind_request)), 15 SECONDS, TIMER_STOPPABLE)

/// Transforms the list of required items by the agent into a string request for the user
/datum/tutorial/marine/reqs_line/proc/verbalize_request(list/original_request)
	var/list/request = shuffle(original_request)
	var/output_string = ""
	var/counts = list() // Assoc list of how many are needed of each item
	for(var/item in request)
		if(item in counts)
			counts[item]++
		else
			counts[item] = 1
	var/first = TRUE
	for(var/item in counts)
		var/list/info = shopping_catalogue[item]
		var/word = pick(info) // Pick one of the coded in designations for the item
		if(!first) // Join list with commas
			output_string += "、"
		first = FALSE
		if(counts[item] > 1)
			output_string += "[counts[item]] "
		output_string += word
	return output_string

/// Triggered when an object is put on the table. The agent evaluates if that's something they want and reacts appropriately.
/datum/tutorial/marine/reqs_line/proc/item_offered(turf/source, obj/item/item)
	SIGNAL_HANDLER
	if(!active_agent)
		return
	var/list/request = agents[active_agent]

	var/item_type = item.type
	if(istype(item, /obj/item/prop/replacer))
		var/obj/item/prop/replacer/prop = item
		item_type = prop.original_type

	if(!(item_type in request)) // Wrong item
		if(item_type in confused_types)
			return
		confused_types |= item_type
		if(COOLDOWN_FINISHED(src, confused_cooldown))
			COOLDOWN_START(src, confused_cooldown, 5 SECONDS)
			active_agent.say("啊？")
		QDEL_IN(item, 30 SECONDS)
		return

	request -= item_type
	agent_pick_up(active_agent, item)

	// If there's nothing left to pick up, we leave
	if(loser_agent)
		return // Still blocking the way. Wait here.
	if(!length(request))
		make_agent_leave(success = TRUE)

/// Re-scan the table/trade turf for any present items. We have to do this because items vended to the table do not move onto it.
/datum/tutorial/marine/reqs_line/proc/scan_table_for_items(datum/source)
	SIGNAL_HANDLER
	var/turf/trade_turf = loc_from_corner(2, 6)
	for(var/obj/item/item in trade_turf)
		item_offered(source, item)

/datum/tutorial/marine/reqs_line/proc/agent_pick_up(mob/agent, obj/item/item)
	// Actually pick the item up for the animation
	agent.put_in_hands(item, drop_on_fail = FALSE)
	playsound(agent, "rustle", 30)
	// Now delete it
	agent.temp_drop_inv_item(item)
	qdel(item)

/datum/tutorial/marine/reqs_line/proc/make_agent_leave(success = FALSE)
	switch(stage)
		if(TUTORIAL_REQS_LINE_STAGE_ATTACHIES)
			INVOKE_ASYNC(src, PROC_REF(continue_stage_gearbox))
		if(TUTORIAL_REQS_LINE_STAGE_GEARBOX)
			INVOKE_ASYNC(src, PROC_REF(continue_stage_mixed))
		if(TUTORIAL_REQS_LINE_STAGE_MIXED)
			INVOKE_ASYNC(src, PROC_REF(continue_stage_survival))
		// Wave handling for Survival is in process
	clean_items()
	kill_timers()

	if(!active_agent)
		return // Nani?

	if(success && prob(80))
		var/speech = pick("谢谢！", "谢谢", "谢了，兄弟", "谢谢你。", "再见", "太好了。")
		active_agent.say(speech)

	// Immediately step the agent through the turnstile and towards exit
	var/turf/target_turf = get_step(active_agent, WEST)
	active_agent.Move(target_turf, WEST)
	active_agent = null

/// Cleanup when an agent reaches the exit
/datum/tutorial/marine/reqs_line/proc/clean_agent(datum/source)
	SIGNAL_HANDLER
	agents -= source
	if(active_agent == source)
		active_agent = null

/// Cleanup the table and ground contents when an agent leaves the line
/datum/tutorial/marine/reqs_line/proc/clean_items()
	var/turf/trade_turf = loc_from_corner(2, 6)
	for(var/obj/item/item in trade_turf)
		qdel(item)
	var/turf/forgot_turf = loc_from_corner(0, 6)
	for(var/obj/item/item in forgot_turf)
		qdel(item)

/// Kills active timers to reset state
/datum/tutorial/marine/reqs_line/proc/kill_timers()
	if(remind_timer)
		deltimer(remind_timer)
		remind_timer = null
	if(hint_timer) // User was just that fast
		deltimer(hint_timer)
		hint_timer = null

/// Displays appropriate hints for the user based on tutorial stage
/datum/tutorial/marine/reqs_line/proc/send_hints()
	switch(stage)
		if(TUTORIAL_REQS_LINE_STAGE_ATTACHIES)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/attachments/blend/tutorial, attachies_vendor)
			add_highlight(attachies_vendor)
			message_to_player("这名陆战队员想要一些武器配件。你可以在最左侧的售货机里找到。")
			update_objective("使用售货机满足陆战队员的需求。")
		if(TUTORIAL_REQS_LINE_STAGE_GEARBOX)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend/tutorial, gear_vendor)
			add_highlight(gear_vendor)
			message_to_player("这名陆战队员想要中间装备售货机里的物品。使用右上角的搜索栏可以更快找到物品。")
			update_objective("使用中间的装备售货机满足陆战队员的需求。物品种类很多，建议使用搜索栏。")
		if(TUTORIAL_REQS_LINE_STAGE_MIXED)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend/tutorial, ammo_vendor)
			add_highlight(ammo_vendor)
			add_highlight(loser_agent)
			loser_agent.say("等等！我还需要一个MK2加长弹匣。扔一个给我！")
			message_to_player("看来这名陆战队员还想要弹药。拿一个弹匣，按<b>[retrieve_bind("toggle_high_throw_mode")]</b>切换高抛模式，再扔给他。")
			update_objective("拿起M41A加长弹匣，用高抛将其扔给这名忘领弹药的陆战队员。")

/datum/tutorial/marine/reqs_line/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	START_PROCESSING(SSfastobj, src)

	message_to_player("欢迎来到军需发放教程。请进，找个位置坐下。")
	update_objective("前往发放窗口，开始教程！")
	var/turf/target_turf = loc_from_corner(3, 6)
	RegisterSignal(target_turf, COMSIG_TURF_ENTERED, PROC_REF(user_in_position))


/// Called when the player is in position to start handling the line
/datum/tutorial/marine/reqs_line/proc/user_in_position(turf/source, atom/movable/mover)
	SIGNAL_HANDLER
	if(mover != tutorial_mob)
		return
	UnregisterSignal(source, COMSIG_TURF_ENTERED)
	stage = TUTORIAL_REQS_LINE_STAGE_ATTACHIES
	var/list/request = list(/obj/item/attachable/magnetic_harness, /obj/item/attachable/extended_barrel)
	INVOKE_ASYNC(src, PROC_REF(spawn_agent), request)

/datum/tutorial/marine/reqs_line/proc/continue_stage_gearbox()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/attachments/blend/tutorial, attachies_vendor)
	remove_highlight(attachies_vendor)
	message_to_player("成功！")
	stage = TUTORIAL_REQS_LINE_STAGE_GEARBOX
	var/list/request = list(/obj/item/storage/box/guncase/lmg, /obj/item/explosive/grenade/high_explosive)
	spawn_agent(request)

/datum/tutorial/marine/reqs_line/proc/continue_stage_mixed()
	loser_agent = active_agent
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend/tutorial, gear_vendor)
	remove_highlight(gear_vendor)
	message_to_player("成功！")
	stage = TUTORIAL_REQS_LINE_STAGE_MIXED
	var/list/request = list(/obj/item/attachable/gyro, /obj/item/storage/box/guncase/m41aMK1, /obj/item/explosive/grenade/high_explosive)
	spawn_agent(request)

/datum/tutorial/marine/reqs_line/proc/loser_got_the_item(turf/source, atom/movable/passer)
	SIGNAL_HANDLER
	var/obj/item/prop/replacer/prop = passer
	if(!istype(prop))
		return
	if(prop.original_type != /obj/item/ammo_magazine/rifle/extended)
		return
	qdel(prop)
	loser_agent.say("太好了。")
	remove_highlight(loser_agent)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend/tutorial, ammo_vendor)
	remove_highlight(ammo_vendor)

	loser_agent = null // Resumes moving
	// Unstucks the guy at line to move on too if he's already been served
	if(active_agent)
		var/list/request = agents[active_agent]
		if(!length(request))
			make_agent_leave(TRUE)

/datum/tutorial/marine/reqs_line/proc/continue_stage_survival()
	mark_completed()
	message_to_player("成功！你已完成教程！")
	update_objective("教程已完成！如果想继续练习，还可以留在这里。")
	addtimer(CALLBACK(src, PROC_REF(message_to_player), "你可以留下来练习处理随机订单，或点击左上角按钮退出。"), 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(engage_survival_mode)), 12 SECONDS)

/datum/tutorial/marine/reqs_line/proc/engage_survival_mode()
	update_objective("继续处理越来越复杂的订单，或随时点击左上角按钮离开。")
	stage = TUTORIAL_REQS_LINE_STAGE_SURVIVAL

/datum/map_template/tutorial/reqs_line
	name = "Reqs Line Tutorial (8x11)"
	mappath = "maps/tutorial/tutorial_reqs_line.dmm"
	width = 8
	height = 11

/* === ITEMS USED IN THE TUTORIAL === */

/// Deletes dummies coming onto it, purely and simply
/obj/effect/landmark/tutorial/reqs_line_cleaner/Crossed(atom/movable/passer)
	if(istype(passer, /mob/living/carbon/human))
		qdel(passer)

/* === VENDORS USED IN THE TUTORIAL === */

/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/blend/tutorial
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_LOAD_AMMO_BOXES | VEND_PROPS

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/blend/tutorial
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_LOAD_AMMO_BOXES | VEND_PROPS

/obj/structure/machinery/cm_vending/sorted/attachments/blend/tutorial
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_LOAD_AMMO_BOXES | VEND_PROPS


#undef TUTORIAL_REQS_LINE_STAGE_STARTING
#undef TUTORIAL_REQS_LINE_STAGE_ATTACHIES
#undef TUTORIAL_REQS_LINE_STAGE_GEARBOX
#undef TUTORIAL_REQS_LINE_STAGE_MIXED
#undef TUTORIAL_REQS_LINE_STAGE_SURVIVAL

#undef TUTORIAL_REQS_LINE_SURVIVAL_DIFFICULTY
