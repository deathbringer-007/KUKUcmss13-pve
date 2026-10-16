/datum/round_event_control/economy_inflation
	name = "Economy Inflation"
	typepath = /datum/round_event/economy_inflation
	weight = 10 // probably could use some defines in the future - EVENT_UNLIKELY, EVENT_COMMON, etc.
	earliest_start = 5 MINUTES
	min_players = 1
	max_occurrences = 1 // we can increase the number once there's more random events around - 3 is a good number
	alert_observers = FALSE
	gamemode_blacklist = list(GAMEMODE_WHISKEY_OUTPOST, GAMEMODE_HIVE_WARS)

/datum/round_event/economy_inflation
	announce_when = 1
	startWhen = 10
	endWhen = 15
	/// The event will modify all vendors of this specific product type.
	var/product_type = VENDOR_PRODUCT_TYPE_FOOD
	/// The multiplier for increasing prices of the above.
	var/inflation_mult
	/// Used in the announcement and in setup to indicate when it will start.
	var/time_to_update

/datum/round_event/economy_inflation/setup()
	. = ..()
	product_type = pick(ALL_VENDOR_PRODUCT_TYPES)
	var/inflation_decimal = (rand(0, 9) * 0.1)
	inflation_mult = rand(1, 3) + inflation_decimal // example result: 3.5
	time_to_update = rand(2, 4) // minutes
	startWhen = time_to_update * 60 // MINUTES - these already are seconds so it'd multiply by 600
	endWhen = time_to_update * 60 + 10 // SECONDS

/datum/round_event/economy_inflation/announce()
	/* You may be thinking 'Why the fuck would W-Y directly send a broadcast to a in-operation vessel and reveal their location to any hostiles nearby?'
	The answer is they don't, it's a signal sent across entire sectors for every UA-affiliated vessel and colony to take note of when it passes by.
	Colony vendors aren't updated because the colony's network has collapsed. */
	var/list/product_labels = list(VENDOR_PRODUCT_TYPE_FOOD = "食品", VENDOR_PRODUCT_TYPE_BEVERAGES = "饮料", VENDOR_PRODUCT_TYPE_SOUTO = "索托饮料", VENDOR_PRODUCT_TYPE_NICOTINE = "烟草", VENDOR_PRODUCT_TYPE_RECREATIONAL = "娱乐用品")
	shipwide_ai_announcement("收到维兰德-汤谷的加密宽频信号，向本星区通告：在低温休眠期间，由于[get_random_story()]，美洲联盟经济发生突变。公司要求美洲联盟舰船将[product_labels[product_type]]类商品价格上调[get_percentage()]%。此调整将在[time_to_update]分钟后生效。")

/datum/round_event/economy_inflation/start()
	for(var/obj/structure/machinery/vending/vending_machine as anything in GLOB.total_vending_machines)
		if(!is_mainship_level(vending_machine.z) || vending_machine.product_type != product_type)
			continue
		vending_machine.speak("价格已更新！")
		playsound(vending_machine, 'sound/machines/twobeep.ogg', 25, TRUE)
		var/display_records = vending_machine.product_records + vending_machine.hidden_records + vending_machine.coin_records
		for(var/datum/data/vending_product/product in display_records)
			product.price *= inflation_mult

/**
 *  Returns a random backstory 'incident' as the cause for the sudden price hike.
 */
/datum/round_event/economy_inflation/proc/get_random_story()
	var/list/backstories = list(,
		"接连发生工厂爆炸事故",
		"企业机密遭公开泄露",
		"发生备受关注的暗杀事件",
		"殖民地解放阵线占领重要工业殖民地",
		"检测出高浓度有害化学物质",
		"涉及企业董事长与农场动物的丑闻曝光",
		"殖民地发生大规模暴乱",
		"工人因镇暴措施引发的工厂暴乱遭到镇压",
		"殖民地解放阵线轰炸关键工业殖民地",
		"数座采矿站与联盟叛乱分子陷入紧张对峙",
		"异形侵袭事件被公开报道",
		"大型企业接连实施恶意收购",
		"大量企业破产",
		"海盗劫持重要货运船队",
		"大片殖民星域因不明原因失联", //XX-121,
		"政府撤回相关领域的资金支持",
		"西格森工业的一座重要空间站失联", // A:I,
		"多个采矿殖民地倒向进步人民联盟",
		"陆战队在泰肯裂隙星区被殖民地解放阵线叛乱分子重创",
		"企业调查引发新制裁",
		"与大角星的关系骤然紧张",
		"太阳耀斑导致整个太阳系的技术设备瘫痪",
		"【已删节】",
		"竞争对手推出新产品",
	)
	return pick(backstories)

/datum/round_event/economy_inflation/proc/get_percentage()
	return (inflation_mult - 1) * 100 // example result: 3.5 -> 250%
