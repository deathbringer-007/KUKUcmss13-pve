/*
 * Vending machine types
 */

/*

/obj/structure/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 1.5 SECONDS
	products = list()
	contraband = list()
	premium = list()

*/

/obj/structure/machinery/vending/coffee
	name = "热饮售货机"
	desc = "供应热饮的售货机。"
	//product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 3.4 SECONDS
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(
		/obj/item/reagent_container/food/drinks/coffee/marine = 25,
		/obj/item/reagent_container/food/drinks/tea = 25,
		/obj/item/reagent_container/food/drinks/h_chocolate = 25,
	)
	contraband = list(/obj/item/reagent_container/food/drinks/ice = 10)
	prices = list(
		/obj/item/reagent_container/food/drinks/coffee/marine = 1.5,
		/obj/item/reagent_container/food/drinks/tea = 3,
		/obj/item/reagent_container/food/drinks/h_chocolate = 15,
		)
	product_type = VENDOR_PRODUCT_TYPE_BEVERAGES

/obj/structure/machinery/vending/coffee/simple
	name = "热咖啡机"
	product_ads = ""
	products = list(/obj/item/reagent_container/food/drinks/coffee = 40)
	contraband = list(/obj/item/reagent_container/food/drinks/h_chocolate = 25)

/obj/structure/machinery/vending/snack
	name = "热食售货机"
	desc = "装满即热餐食的售货机，嗯——尝尝这营养美味！"
	product_slogans = "开普勒薯片！来尝尝这超凡脱俗的零食！;来一根 EAT 能量棒！;来吃维兰德-汤谷牌包装汉堡。;来吃维兰德-汤谷牌包装热狗。;来吃维兰德-汤谷牌包装卷饼。;"
	product_ads = "开普勒薯片！来尝尝这超凡脱俗的零食！;来一根 EAT 能量棒！"
	icon_state = "snack"
	products = list(
		/obj/item/reagent_container/food/snacks/microwavable/donkpocket = 12,
		/obj/item/reagent_container/food/snacks/microwavable/packaged_burger = 12,
		/obj/item/reagent_container/food/snacks/microwavable/packaged_burrito = 12,
		/obj/item/reagent_container/food/snacks/microwavable/packaged_hdogs =12,
		/obj/item/reagent_container/food/snacks/kepler_crisps = 12,
		/obj/item/reagent_container/food/snacks/kepler_crisps/flamehot = 12,
		/obj/item/reagent_container/food/snacks/wy_chips/pepper = 12,
		/obj/item/reagent_container/food/snacks/eat_bar = 12,
		/obj/item/reagent_container/food/snacks/wrapped/booniebars = 6,
		/obj/item/reagent_container/food/snacks/wrapped/chunk = 6,
		/obj/item/reagent_container/food/snacks/wrapped/barcardine = 6,
	)

	prices = list(
		/obj/item/reagent_container/food/snacks/microwavable/donkpocket = 5,
		/obj/item/reagent_container/food/snacks/microwavable/packaged_burger = 5,
		/obj/item/reagent_container/food/snacks/microwavable/packaged_burrito = 5,
		/obj/item/reagent_container/food/snacks/microwavable/packaged_hdogs = 5,
		/obj/item/reagent_container/food/snacks/kepler_crisps = 3,
		/obj/item/reagent_container/food/snacks/kepler_crisps/flamehot = 5,
		/obj/item/reagent_container/food/snacks/wy_chips/pepper = 3,
		/obj/item/reagent_container/food/snacks/eat_bar = 4,
		/obj/item/reagent_container/food/snacks/wrapped/booniebars = 4,
		/obj/item/reagent_container/food/snacks/wrapped/chunk = 4,
		/obj/item/reagent_container/food/snacks/wrapped/barcardine = 4,
	)
	product_type = VENDOR_PRODUCT_TYPE_FOOD

/obj/structure/machinery/vending/snack/packaged
	product_slogans = ""
	product_ads = ""
	products = list(
		/obj/item/reagent_container/food/snacks/microwavable/donkpocket = 40,
		/obj/item/reagent_container/food/snacks/microwavable/packaged_burrito = 40,
		/obj/item/reagent_container/food/snacks/microwavable/packaged_burger = 40,
		/obj/item/reagent_container/food/snacks/microwavable/packaged_hdogs = 40,
	)

/obj/structure/machinery/vending/cola
	name = "索托汽水售货机"
	desc = "由哈瓦那索托汽水公司提供的汽水售货机。"
	icon_state = "Cola_Machine"
	product_slogans = "索托汽水：喝一罐索托，畅游热带天堂！;索托经典，柑橘美味无可比拟！;索托樱桃，冬日清晨的清甜滋味！;索托青柠，你熟悉又喜爱的酸甜口感！;索托葡萄，没有比葡萄汽水更棒的饮料了。;维兰德-汤谷果啤，那场官司什么也没告成！"
	product_ads = "索托经典，柑橘美味无可比拟！;索托樱桃，冬日清晨的清甜滋味！;索托青柠，你熟悉又喜爱的酸甜口感！;索托葡萄，没有比葡萄汽水更棒的饮料了。;维兰德-汤谷果啤，那场官司什么也没告成！"
	products = list(
		/obj/item/reagent_container/food/drinks/cans/souto/classic = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/cherry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/lime = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/grape = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/blue = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/peach = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/cranberry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/vanilla = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/pineapple = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/classic = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/cherry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/lime = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/grape = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/blue = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/peach = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/vanilla = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/pineapple = 10,
		/obj/item/reagent_container/food/drinks/cans/cola = 10,
	)

	prices = list(
		/obj/item/reagent_container/food/drinks/cans/souto/classic = 8,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/classic = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/cherry = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/cherry = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/lime = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/lime = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/grape = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/grape = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/blue = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/blue = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/peach = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/peach = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/cranberry = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/vanilla = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/vanilla = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/pineapple = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/pineapple = 12,
		/obj/item/reagent_container/food/drinks/cans/cola = 20,
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_type = VENDOR_PRODUCT_TYPE_SOUTO

/obj/structure/machinery/vending/cola/research
	desc = "由哈瓦那索托汽水公司提供的汽水售货机。此机已绑定科研预算卡，无需刷卡。"
	products = list(
		/obj/item/reagent_container/food/drinks/cans/souto/classic = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/cherry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/lime = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/grape = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/blue = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/peach = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/cranberry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/vanilla = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/pineapple = 10,
	)

	prices = list()


/obj/structure/machinery/vending/generic
	name = "售货机"
	desc = "普通的零食汽水售货机，背面的小铭牌上写着：“我来，我卖，我征服。”"
	icon_state = "snackvend"
	product_slogans = ""
	product_ads = ""
	products = list(
		/obj/item/reagent_container/food/snacks/wrapped/barcardine = 10,
		/obj/item/reagent_container/food/snacks/wrapped/booniebars = 10,
		/obj/item/reagent_container/food/snacks/wrapped/chunk = 10,
		/obj/item/reagent_container/food/snacks/wrapped/chunk/hunk = 10,
		/obj/item/reagent_container/food/snacks/eat_bar = 10,
		/obj/item/reagent_container/food/snacks/chips = 10,
		/obj/item/reagent_container/food/snacks/wy_chips/pepper = 10,
		/obj/item/reagent_container/food/drinks/cans/classcola = 10,
		/obj/item/reagent_container/food/drinks/cans/dr_gibb = 10,
		/obj/item/reagent_container/food/drinks/cans/space_mountain_wind = 10,
		/obj/item/reagent_container/food/drinks/cans/iced_tea = 10,
	)

	prices = list(
		/obj/item/reagent_container/food/snacks/wrapped/barcardine = 4,
		/obj/item/reagent_container/food/snacks/wrapped/booniebars = 4,
		/obj/item/reagent_container/food/snacks/wrapped/chunk = 4,
		/obj/item/reagent_container/food/snacks/wrapped/chunk/hunk = 4,
		/obj/item/reagent_container/food/snacks/eat_bar = 4,
		/obj/item/reagent_container/food/snacks/chips = 5,
		/obj/item/reagent_container/food/snacks/wy_chips/pepper = 5,
		/obj/item/reagent_container/food/drinks/cans/classcola = 2,
		/obj/item/reagent_container/food/drinks/cans/dr_gibb = 2,
		/obj/item/reagent_container/food/drinks/cans/space_mountain_wind = 2,
		/obj/item/reagent_container/food/drinks/cans/iced_tea = 2,
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_type = VENDOR_PRODUCT_TYPE_FOOD

/obj/structure/machinery/vending/cigarette
	name = "香烟售货机" //Template
	desc = "既然想得癌症，那也得有点格调！"
	product_slogans = "L.S./M.F.T.！好彩意味着好烟草。;经典格调，一点即燃，尽在芝宝！;食品药品监督管理局提醒您：烟草制品会致癌并加重疲劳。;真男人抽好彩！;为美国武装部队服务逾两百年！;人生苦短，抽根好彩！;L.S./M.F.T.！;好彩再度领先！;好彩香烟，无可比拟！;卡洛斯·海斯科克的首选香烟！;烟草行家的首选，再次领先！"
	product_ads = "真男人抽好彩！;为美国武装部队服务逾两百年！;人生苦短，抽根好彩！;L.S./M.F.T.！;好彩再度领先！;好彩香烟，无可比拟！;卡洛斯·海斯科克的首选香烟！;烟草行家的首选，再次领先！"
	vend_delay = 1.4 SECONDS
	icon_state = "cigs"
	products = list(
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 50,
		/obj/item/storage/fancy/cigar/tarbacktube = 20,
		/obj/item/storage/box/matches = 15,
		/obj/item/tool/lighter/random = 25,
		/obj/item/tool/lighter/zippo = 10,
	)

	premium = list(/obj/item/storage/fancy/cigar = 25)
	prices = list(
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 35,
		/obj/item/storage/fancy/cigar/tarbacktube = 35,
		/obj/item/storage/box/matches = 1,
		/obj/item/tool/lighter/random = 10,
		/obj/item/tool/lighter/zippo = 25,
	)
	product_type = VENDOR_PRODUCT_TYPE_NICOTINE

/obj/structure/machinery/vending/cigarette/free
	product_slogans = ""
	product_ads = ""
	products = list(
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 50,
		/obj/item/storage/fancy/cigar/tarbacktube = 20,
		/obj/item/storage/box/matches = 15,
		/obj/item/tool/lighter/random = 25,
		/obj/item/tool/lighter/zippo = 10,
	)
	premium = list()
	prices = list()
	product_type = VENDOR_PRODUCT_TYPE_NICOTINE

/obj/structure/machinery/vending/cigarette/colony
	product_slogans = "库尔兰德金装，献给品味不凡的您。;淑女纤指，献给优雅烟客。;淑女纤指，用粉红宠爱您的味蕾！;大大的蓝色 K，带来清凉一整天！;想要清爽好心情，就认准大蓝 K！;讲究的烟客都选金装！;淑女纤指，钟爱清凉烟草的女士之选。;淑女纤指，门户站这一带的头号香烟！;烟草鉴赏家首选库尔兰德金装。;淑女纤指香烟，过滤清凉，口感顺滑冠绝市场。;库尔兰德金装，向世界宣告您的巅峰地位，无人能够否认。;殖民地管理局提醒您：吸烟致死。"
	product_ads = "想要清爽好心情，就认准大蓝 K！;讲究的烟客都选金装！;淑女纤指，钟爱清凉烟草的女士之选。;淑女纤指，门户站这一带的头号香烟！;烟草鉴赏家首选库尔兰德金装。;淑女纤指香烟，过滤清凉，口感顺滑冠绝市场。;库尔兰德金装，向世界宣告您的巅峰地位，无人能够否认。;殖民地管理局提醒您：吸烟致死。"
	products = list(
		/obj/item/storage/fancy/cigarettes/kpack = 20,
		/obj/item/storage/fancy/cigarettes/spirit = 20,
		/obj/item/storage/fancy/cigarettes/spirit/yellow = 20,
		/obj/item/storage/fancy/cigarettes/arcturian_ace = 15,
		/obj/item/storage/fancy/cigarettes/emeraldgreen = 15,
		/obj/item/storage/fancy/cigarettes/wypacket = 15,
		/obj/item/storage/fancy/cigarettes/trading_card = 15,
		/obj/item/storage/fancy/cigarettes/lady_finger = 15,
		/obj/item/storage/fancy/cigarettes/blackpack = 10,
		/obj/item/storage/fancy/cigar/tarbacks = 5,

		/obj/item/storage/box/matches = 10,
		/obj/item/tool/lighter/random = 20,
		/obj/item/tool/lighter/zippo = 5,

	)

	prices = list(
		/obj/item/storage/fancy/cigarettes/kpack = 40,
		/obj/item/storage/fancy/cigarettes/spirit = 40,
		/obj/item/storage/fancy/cigarettes/spirit/yellow = 40,
		/obj/item/storage/fancy/cigarettes/arcturian_ace = 25,
		/obj/item/storage/fancy/cigarettes/emeraldgreen = 35,
		/obj/item/storage/fancy/cigarettes/wypacket = 30,
		/obj/item/storage/fancy/cigarettes/trading_card = 35,
		/obj/item/storage/fancy/cigarettes/lady_finger = 30,
		/obj/item/storage/fancy/cigarettes/blackpack = 75,
		/obj/item/storage/fancy/cigar/tarbacks = 35,
		/obj/item/storage/box/matches = 1,
		/obj/item/tool/lighter/random = 10,
		/obj/item/tool/lighter/zippo = 25,

	)

/obj/structure/machinery/vending/cigarette/koorlander //koorlander machine, contains luckies since they either bought Lucky Strikes as a company, or are working together to survive.
	name = "库尔兰德牌香烟售货机"
	desc = "库尔兰德牌香烟售货机。供应好彩、淑女纤指，当然还有库尔兰德金装，以及几种你几乎没听过的小品牌。"
	icon_state = "koorcigs"
	product_slogans = list(
		"库尔兰德金装，献给品味不凡的您。",
		"淑女纤指，献给优雅烟客。",
		"淑女纤指，用粉红宠爱您的味蕾！",
		"大大的蓝色 K，带来清凉一整天！",
		"想要清爽好心情，就认准大蓝 K！",
		"讲究的烟客都选金装！",
		"淑女纤指，钟爱清凉烟草的女士之选。",
		"淑女纤指，门户站这一带的头号香烟！",
		"烟草鉴赏家首选库尔兰德金装。",
		"淑女纤指香烟，过滤清凉，口感顺滑冠绝市场。",
		"库尔兰德金装，向世界宣告您的巅峰地位，无人能够否认。",
		"L.S./M.F.T.！好彩意味着好烟草。",
		"经典格调，一点即燃，尽在芝宝！",
		"预算有限？买比克吧。",
		"比克，自 1945 年起制造文具。",
		"真男人抽好彩！",
		"为美国武装部队服务逾两百年！",
		"人生苦短，抽根好彩！",
		"好彩再度领先！",
		"好彩香烟，无可比拟！",
		"卡洛斯·海斯科克的首选香烟！",
		"烟草行家的首选，再次领先！",
		"真实。简单。与众不同。美国精神。",
		"烟草成分：烟草与水。美国精神。",
		"星际商务委员会提醒您：吸烟致死。",
		"食品药品监督管理局提醒您：烟草制品会致癌并加重疲劳。",
	)

	product_ads = list(
		"想要清爽好心情，就认准大蓝 K！",
		"讲究的烟客都选金装！",
		"淑女纤指，钟爱清凉烟草的女士之选。",
		"淑女纤指，门户站这一带的头号香烟！",
		"烟草鉴赏家首选库尔兰德金装。",
		"淑女纤指香烟，过滤清凉，口感顺滑冠绝市场。",
		"库尔兰德金装，向世界宣告您的巅峰地位，无人能够否认。",
		"真男人抽好彩！;为美国武装部队服务逾两百年！",
		"人生苦短，抽根好彩！",
		"L.S./M.F.T.!,",
		"好彩再度领先！",
		"好彩香烟，无可比拟！",
		"卡洛斯·海斯科克的首选香烟！",
		"烟草行家的首选，再次领先！",
		"真实。简单。与众不同。美国精神。",
		"烟草成分：烟草与水。美国精神。",
		"星际商务委员会提醒您：吸烟致死。",
		"食品药品监督管理局提醒您：烟草制品会致癌并加重疲劳。",
	)

	products = list(
		/obj/item/storage/fancy/cigarettes/kpack = 20,
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 20,
		/obj/item/storage/fancy/cigarettes/lady_finger = 20,
		/obj/item/storage/fancy/cigarettes/spirit = 10,
		/obj/item/storage/fancy/cigarettes/spirit/yellow = 10,
		/obj/item/storage/fancy/cigar/tarbacktube = 10,

		/obj/item/storage/box/matches = 5,
		/obj/item/storage/fancy/cigar/matchbook/koorlander = 5,
		/obj/item/storage/fancy/cigar/matchbook/brown = 10,
		/obj/item/tool/lighter/random = 20,
		/obj/item/tool/lighter/zippo = 10,
		/obj/item/tool/lighter/zippo/blue = 5,
	)

	prices = list(
		/obj/item/storage/fancy/cigarettes/kpack = 14,
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 8,
		/obj/item/storage/fancy/cigarettes/lady_finger = 11,
		/obj/item/storage/fancy/cigarettes/spirit/yellow = 12,
		/obj/item/storage/fancy/cigarettes/spirit = 12,
		/obj/item/storage/fancy/cigar/tarbacktube = 20,
		/obj/item/storage/box/matches = 3,
		/obj/item/storage/fancy/cigar/matchbook/koorlander = 2,
		/obj/item/storage/fancy/cigar/matchbook/brown = 1,
		/obj/item/tool/lighter/random = 5,
		/obj/item/tool/lighter/zippo = 20,
		/obj/item/tool/lighter/zippo/blue = 30,
	)

/obj/structure/machinery/vending/cigarette/koorlander/free
		prices = list(
		/obj/item/storage/fancy/cigarettes/kpack = 0,
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 0,
		/obj/item/storage/fancy/cigarettes/lady_finger = 0,
		/obj/item/storage/fancy/cigarettes/spirit/yellow = 0,
		/obj/item/storage/fancy/cigarettes/spirit = 0,
		/obj/item/storage/fancy/cigar/tarbacktube = 0,
		/obj/item/storage/box/matches = 0,
		/obj/item/storage/fancy/cigar/matchbook/koorlander = 0,
		/obj/item/storage/fancy/cigar/matchbook/brown = 0,
		/obj/item/tool/lighter/random = 0,
		/obj/item/tool/lighter/zippo = 0,
		/obj/item/tool/lighter/zippo/blue = 0,
	)

/obj/structure/machinery/vending/cigarette/wy //WY machine
	name = "维兰德-汤谷牌香烟售货机"
	desc = "维兰德-汤谷牌香烟售货机，外形像一盒维兰德-汤谷金装香烟。供应翡翠绿、当然少不了的维兰德-汤谷金装、大角星王牌，以及某个你几乎没听过的三世界帝国品牌。高管精选仍因运输问题缺货……"
	icon_state = "wycigs"
	product_slogans = list(
		"维兰德-汤谷金装，献给身居高位的您。",
		"大角星王牌，献给无法忍受糟糕口味的您！",
		"大角星王牌，有益肺部！多亏大角星的异域植物。", //it's cocaine
		"香烟就该是这个味，来抽维兰德-汤谷金装！",
		"讲究的烟客都选金装！",
		"大角星王牌，薄荷清新。",
		"王牌，让口气像大角星瀑布一样清新！",
		"翡翠绿，新伊甸这一带的头号香烟！",
		"烟草鉴赏家首选高管精选。",
		"想体验异世界的薄荷清新？试试大角星王牌！",
		"立于世界之巅的高管，就抽高管精选。",
		"大角星王牌，初次吸烟者的好选择！",
		"经典格调，一点即燃，尽在芝宝！",
		"预算有限？买比克吧。",
		"比克，自 1945 年起制造文具。",
		"翡翠绿，绿如新伊甸的原野。",
		"翡翠绿，医生的最爱！",
		"这份绿意，无可比拟！",
		"理查德·尼克松的首选品牌！", //:smug:
		"医生首选，再度领先！",
		"巴拉吉帝国，为了国王与祖国！",
		"人生苦短，抽根巴拉吉！",
		"星际商务委员会提醒您：吸烟致死。",
		"食品药品监督管理局提醒您：烟草制品会致癌并加重疲劳。",
	)

	product_ads = list(
		"维兰德-汤谷金装，献给身居高位的您。",
		"大角星王牌，献给讨厌糟糕口味的您。",
		"大角星王牌，有益肺部！多亏大角星当地的植物。",
		"香烟就该是这个味，维兰德-汤谷金装！",
		"讲究的烟客都选金装！",
		"大角星王牌，薄荷清新。",
		"翡翠绿，新伊甸这一带的头号香烟！",
		"烟草鉴赏家首选高管精选。",
		"想体验异世界的薄荷清新？试试大角星王牌！",
		"立于世界之巅的高管，就抽高管精选。",
		"大角星王牌，初次吸烟者的好选择！",
		"翡翠绿，医生的最爱！",
		"这份绿意，无可比拟！",
		"理查德·尼克松的首选香烟！",
		"医生首选，再度领先！",
		"巴拉吉帝国，为了国王与祖国！",
		"人生苦短，抽根巴拉吉！",
		"星际商务委员会提醒您：吸烟致死。",
		"食品药品监督管理局提醒您：烟草制品会致癌并加重疲劳。",
	)

	premium = list(/obj/item/storage/fancy/cigar = 5)
	products = list(
		/obj/item/storage/fancy/cigarettes/wypacket = 15,
		/obj/item/storage/fancy/cigarettes/emeraldgreen = 30,
		/obj/item/storage/fancy/cigarettes/arcturian_ace = 10,
		/obj/item/storage/fancy/cigarettes/balaji = 10,
		/obj/item/storage/fancy/cigarettes/blackpack = 0,

		/obj/item/storage/box/matches = 5,
		/obj/item/storage/fancy/cigar/matchbook/exec_select = 10,
		/obj/item/storage/fancy/cigar/matchbook/balaji_imperial = 10,
		/obj/item/storage/fancy/cigar/matchbook/wy_gold = 10,
		/obj/item/tool/lighter/random = 20,
		/obj/item/tool/lighter/zippo/black = 5,
		/obj/item/tool/lighter/zippo/executive = 1,

	)

	prices = list(
		/obj/item/storage/fancy/cigarettes/wypacket = 15,
		/obj/item/storage/fancy/cigarettes/emeraldgreen = 5,
		/obj/item/storage/fancy/cigarettes/arcturian_ace = 8,
		/obj/item/storage/fancy/cigarettes/balaji = 15,
		/obj/item/storage/fancy/cigarettes/blackpack = 40,

		/obj/item/storage/box/matches = 2,
		/obj/item/storage/fancy/cigar/matchbook/exec_select = 7,
		/obj/item/storage/fancy/cigar/matchbook/balaji_imperial = 6,
		/obj/item/storage/fancy/cigar/matchbook/wy_gold = 5,
		/obj/item/tool/lighter/random = 3,
		/obj/item/tool/lighter/zippo/black = 15,
		/obj/item/tool/lighter/zippo/executive = 50,
	)

/obj/structure/machinery/vending/cigarette/wy/Initialize(mapload, ...)
	var/exec_number = rand(0, 2)
	products[/obj/item/storage/fancy/cigarettes/blackpack] = exec_number
	return ..()

/obj/structure/machinery/vending/cigarette/wy/free
	prices = list(
		/obj/item/storage/fancy/cigarettes/wypacket = 0,
		/obj/item/storage/fancy/cigarettes/emeraldgreen = 0,
		/obj/item/storage/fancy/cigarettes/arcturian_ace = 0,
		/obj/item/storage/fancy/cigarettes/balaji = 0,
		/obj/item/storage/fancy/cigarettes/blackpack = 0,

		/obj/item/storage/box/matches = 5,
		/obj/item/storage/fancy/cigar/matchbook/exec_select = 0,
		/obj/item/storage/fancy/cigar/matchbook/wy_gold = 0,
		/obj/item/tool/lighter/random = 0,
		/obj/item/tool/lighter/zippo/black = 0,
		/obj/item/tool/lighter/zippo/executive = 0,
	)


/obj/structure/machinery/vending/cigarette/upp
	desc = "一台国营香烟售货机。刻意采用沉闷的配色以劝退买家，但它的存在本身就承认了这类机器的必要性。"
	product_slogans = ""
	product_ads = ""
	icon_state = "china_cig_vending"
	products = list(
		/obj/item/storage/fancy/cigarettes/laika = 10,
		/obj/item/clothing/mask/cigarette/cigar/cohiba = 3,
		/obj/item/storage/box/matches = 15,
		/obj/item/tool/lighter/random = 10,
	)
	prices = list(
		/obj/item/storage/fancy/cigarettes/laika = 10,
		/obj/item/clothing/mask/cigarette/cigar/cohiba = 20,
		/obj/item/storage/box/matches = 1,
		/obj/item/tool/lighter/random = 5,
	)

/obj/structure/machinery/vending/security
	name = "ColMarTech宪兵售货机"
	desc = "一台 USCM 宪兵售货机。"
	product_ads = "敲碎资本家的脑袋！;给那些脑袋开开瓢！;别忘了——伤害是好事！;你的武器就在这里。;手铐！;不许动，人渣！;兄弟，别电我！;兄弟，电他们。;何不来个甜甜圈？"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access = list(ACCESS_MARINE_BRIG)
	products = list(
		/obj/item/restraint/handcuffs = 8,
		/obj/item/restraint/handcuffs/zip = 10,
		/obj/item/restraint/legcuffs = 3,
		/obj/item/weapon/gun/energy/taser = 4,
		/obj/item/reagent_container/spray/pepper = 4,
		/obj/item/weapon/baton = 4,
		/obj/item/device/flashlight = 4,
		/obj/item/storage/belt/security/MP = 4,
		/obj/item/device/flash = 5,
		/obj/item/storage/box/evidence = 6,
		/obj/item/clothing/head/helmet/marine/MP = 2,
		/obj/item/clothing/under/marine/mp = 2,
		/obj/item/tape/regulation = 5,
	)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,/obj/item/storage/donut_box = 2)

/obj/structure/machinery/vending/security/riot
	name = "防暴科技售货机"
	desc = "安保防暴装备售货机。"
	hacking_safety = TRUE
	wrenchable = FALSE
	products = list(
		/obj/item/restraint/handcuffs/zip = 40,
		/obj/item/explosive/grenade/flashbang = 20,
		/obj/item/explosive/grenade/tear/marine = 40,
		/obj/item/ammo_magazine/smg/m39/rubber = 40,
		/obj/item/ammo_magazine/pistol/rubber = 40,
		/obj/item/ammo_magazine/pistol/vp70/rubber = 40,
		/obj/item/ammo_magazine/rifle/rubber = 40,
		/obj/item/ammo_magazine/rifle/m49a/rubber = 40,
		/obj/item/clothing/head/helmet/marine/MP = 8,
		/obj/item/explosive/plastic/breaching_charge/rubber = 6,
	)

/obj/structure/machinery/vending/security/colony
	name = "安保科技警用售货机"
	desc = "普通的警用售货机。"
	req_access = list(ACCESS_CIVILIAN_BRIG)
	products = list(
		/obj/item/restraint/handcuffs = 8,
		/obj/item/reagent_container/spray/pepper = 4,
		/obj/item/device/flashlight = 4,
		/obj/item/storage/belt/security/MP/CMB = 4,
		/obj/item/device/flash = 5,
		/obj/item/storage/box/evidence = 6,
		/obj/item/tape/regulation = 5,
	)

/obj/structure/machinery/vending/security/upp
	name = "人民警察装备售货机"
	desc = "UPP 安全部队使用的标准安保装备售货机。"
	req_access = list(ACCESS_CIVILIAN_BRIG)
	products = list(
		/obj/item/restraint/handcuffs = 8,
		/obj/item/reagent_container/spray/pepper = 4,
		/obj/item/device/flashlight = 4,
		/obj/item/storage/belt/security/MP/UPP = 4,
		/obj/item/device/flash = 5,
		/obj/item/storage/box/evidence = 6,
		/obj/item/tape/regulation = 5,
	)

/obj/structure/machinery/vending/sea
	name = "海事科技售货机"
	desc = "专为救生而设计的装备售货机。"
	product_ads = "永远忠诚！;率先迎战！;乌拉！;皮革脖子！;精锐之师，骄傲之师。;军团精神！;罐头脑袋。;恶魔犬。"
	icon_state = "sec"
	icon_deny = "sec-deny"
	hacking_safety = TRUE
	wrenchable = FALSE
	req_access = list(ACCESS_MARINE_SEA)
	products = list(
		/obj/item/ammo_magazine/smg/m39/rubber = 20,
		/obj/item/ammo_magazine/pistol/rubber = 20,
		/obj/item/ammo_magazine/pistol/vp70/rubber = 20,
		/obj/item/ammo_magazine/rifle/rubber = 20,
		/obj/item/ammo_magazine/rifle/m49a/rubber = 20,
		/obj/item/ammo_magazine/shotgun/beanbag = 20,
		/obj/item/storage/firstaid/regular = 2,
		/obj/item/storage/firstaid/fire = 2,
		/obj/item/storage/firstaid/rad = 1,
		/obj/item/device/radio/headset = 6,
		/obj/item/tool/crew_monitor = 1,
	)
	contraband = list(/obj/item/storage/fancy/cigar = 2,/obj/item/tool/lighter/zippo = 2)

/obj/structure/machinery/vending/hydronutrients
	name = "营养满分售货机"
	desc = "植物营养品售货机。"
	//product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	//product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	products = list(/obj/item/reagent_container/glass/fertilizer/ez = 35,/obj/item/reagent_container/glass/fertilizer/l4z = 25,/obj/item/reagent_container/glass/fertilizer/rh = 15,/obj/item/tool/plantspray/pests = 20,
					/obj/item/reagent_container/syringe = 5,/obj/item/storage/bag/plants = 5)
	premium = list(/obj/item/reagent_container/glass/bottle/ammonia = 10,/obj/item/reagent_container/glass/bottle/diethylamine = 5)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/structure/machinery/vending/hydroseeds
	name = "超级种子供应机"
	desc = "急需种子时的好帮手！"
	//product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	//product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = "seeds"
	delay_product_spawn = 1

	products = list(/obj/item/seeds/bananaseed = 3,/obj/item/seeds/berryseed = 3,/obj/item/seeds/carrotseed = 3,/obj/item/seeds/chantermycelium = 2,/obj/item/seeds/chiliseed = 3,
					/obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/potatoseed = 3,/obj/item/seeds/soyaseed = 3,
					/obj/item/seeds/sunflowerseed = 2,/obj/item/seeds/tomatoseed = 3,/obj/item/seeds/wheatseed = 3,/obj/item/seeds/appleseed = 3,
					/obj/item/seeds/poppyseed = 3,/obj/item/seeds/sugarcaneseed = 3,/obj/item/seeds/peanutseed = 3,/obj/item/seeds/whitebeetseed = 3,/obj/item/seeds/watermelonseed = 3,/obj/item/seeds/limeseed = 3,
					/obj/item/seeds/lemonseed = 3,/obj/item/seeds/orangeseed = 3,/obj/item/seeds/grassseed = 3,/obj/item/seeds/cocoapodseed = 3,/obj/item/seeds/plumpmycelium = 2,
					/obj/item/seeds/cabbageseed = 3,/obj/item/seeds/grapeseed = 3,/obj/item/seeds/pumpkinseed = 3,/obj/item/seeds/cherryseed = 3,/obj/item/seeds/riceseed = 3)
	contraband = list(
		/obj/item/seeds/libertymycelium = 1,
		/obj/item/seeds/mtearseed = 1,
		/obj/item/seeds/ambrosiavulgarisseed = 1,
		/obj/item/seeds/nettleseed = 1,
		/obj/item/seeds/reishimycelium = 1,
	)
	premium = list(/obj/item/toy/waterflower = 1)

/obj/structure/machinery/vending/dinnerware
	name = "餐具售货机"
	desc = "厨房与餐厅用品售货机。"
	product_ads = "嗯，食材！;食品和配套用品。;来拿盘子！;你喜欢叉子吗？;我喜欢叉子。;哇，餐具。;其实你并不需要这些……"
	icon_state = "dinnerware"
	products = list(
		/obj/item/tool/kitchen/tray = 8,
		/obj/item/tool/kitchen/utensil/fork = 6,
		/obj/item/tool/kitchen/knife = 3,
		/obj/item/reagent_container/food/drinks/drinkingglass = 8,
		/obj/item/clothing/suit/chef/classic = 2,
		/obj/item/reagent_container/food/condiment/saltshaker = 4,
		/obj/item/reagent_container/food/condiment/peppermill = 4,
		/obj/item/reagent_container/food/condiment = 8,
	)
	contraband = list(
		/obj/item/tool/kitchen/utensil/spoon = 2,
		/obj/item/tool/kitchen/utensil/knife = 2,
		/obj/item/tool/kitchen/rollingpin = 2,
		/obj/item/tool/kitchen/knife/butcher = 2,
		/obj/item/reagent_container/food/condiment/enzyme = 1,
	)

/obj/structure/machinery/vending/sovietsoda
	name = "波达汽水机"
	desc = "一台老旧的糖水售货机，怎么会出现在这里？"
	icon_state = "sovietsoda"
	product_ads = "为了沙皇与祖国。;你今天完成营养配额了吗？;真不错！;我们朴实无华，因为我们就吃这些。;有人就有问题，没人就没问题。"
	products = list(/obj/item/reagent_container/food/drinks/cans/boda = 30)
	contraband = list(/obj/item/reagent_container/food/drinks/cans/bodaplus = 20)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

// All instances of this vendor will share a single inventory for items in the shared list.
// Meaning, if an item is taken from one vendor, it will not be available in any others as well.
/obj/structure/machinery/vending/shared_vending
	var/list/shared = list()
	var/static/list/shared_products = list()

/obj/structure/machinery/vending/shared_vending/New()
	..()

	build_shared_inventory(shared,0,1)

/obj/structure/machinery/vending/shared_vending/proc/build_shared_inventory(list/productlist,hidden=0,req_coin=0)

	if(delay_product_spawn)
		sleep(15) //Make ABSOLUTELY SURE the seed datum is properly populated.

	var/i = 1

	for(var/typepath in productlist)
		var/amount = productlist[typepath]
		var/price = prices[typepath]
		if(isnull(amount)) amount = 1

		var/obj/item/temp_path = typepath
		var/datum/data/vending_product/R = shared_products[i]

		if(!R.product_path)
			R.product_path = typepath
			R.amount = amount
			R.price = price

			if(ispath(typepath,/obj/item/weapon/gun) || ispath(typepath,/obj/item/ammo_magazine) || ispath(typepath,/obj/item/explosive/grenade) || ispath(typepath,/obj/item/weapon/gun/flamer) || ispath(typepath,/obj/item/storage) )
				R.display_color = "black"
// else if(ispath(typepath,/obj/item/clothing) || ispath(typepath,/obj/item/storage))
// R.display_color = "green"
// else if(ispath(typepath,/obj/item/reagent_container) || ispath(typepath,/obj/item/stack/medical))
// R.display_color = "blue"
			else
				R.display_color = "white"

		if(hidden)
			R.category=CAT_HIDDEN
			hidden_records += R
		else if(req_coin)
			R.category=CAT_COIN
			coin_records += R
		else
			product_records += R
			R.category = CAT_NORMAL

		if(delay_product_spawn)
			sleep(5) //sleep(1) did not seem to cut it, so here we are.

		R.product_name = initial(temp_path.name)

		i++;
	return

/obj/structure/machinery/vending/walkman
	name = "休闲用品售货机"
	desc = "提供维兰德-汤谷批准的休闲用品，如随身听和纸牌。"
	icon_state = "walkman"
	product_ads = "整个陆战队里唯一能找乐子的地方！;从这里到大角星，你都找不到更棒的音乐！;纸牌不附带说明书！;没有音量控制——你不需要！;所有产品都由和你一样快乐的人负责任地制造！;全新维兰德-汤谷军用集换卡金装香烟，向好彩的军用烟草垄断说再见！"
	vend_delay = 0.5 SECONDS
	idle_power_usage = 200

	products = list(
		/obj/item/device/cassette_tape/pop1 = 10,
		/obj/item/device/cassette_tape/hiphop = 10,
		/obj/item/device/cassette_tape/nam = 10,
		/obj/item/device/cassette_tape/ocean = 10,
		/obj/item/device/cassette_tape/pop3 = 10,
		/obj/item/device/cassette_tape/pop4 = 10,
		/obj/item/device/cassette_tape/pop2 = 10,
		/obj/item/device/cassette_tape/heavymetal = 10,
		/obj/item/device/cassette_tape/hairmetal = 10,
		/obj/item/device/cassette_tape/indie = 10,
		/obj/item/device/walkman = 50,
		/obj/item/storage/pouch/cassette = 15,
		/obj/item/toy/deck = 5,
		/obj/item/toy/deck/uno = 5,
		/obj/item/device/camera = 5,
		/obj/item/device/camera_film = 10,
		/obj/item/notepad = 5,
		/obj/item/device/toner = 5,
		/obj/item/paper/colonial_grunts = 15,
		/obj/item/toy/dice/d20 = 10,
		/obj/item/tool/pen = 10,
		/obj/item/tool/pen/blue = 10,
		/obj/item/tool/pen/red = 10,
		/obj/item/tool/pen/fountain = 3,
		/obj/item/storage/fancy/cigarettes/trading_card = 20,
		/obj/item/storage/fancy/trading_card = 20,
		/obj/item/toy/trading_card = 50,

	)

	contraband = list(/obj/item/toy/sword = 2)

	prices = list(
		/obj/item/device/cassette_tape/pop1 = 5,
		/obj/item/device/cassette_tape/hiphop = 5,
		/obj/item/device/cassette_tape/nam = 5,
		/obj/item/device/cassette_tape/ocean = 6,
		/obj/item/device/cassette_tape/pop3 = 5,
		/obj/item/device/cassette_tape/pop4 = 5,
		/obj/item/device/cassette_tape/pop2 = 5,
		/obj/item/device/cassette_tape/heavymetal = 5,
		/obj/item/device/cassette_tape/hairmetal = 5,
		/obj/item/device/cassette_tape/indie = 5,
		/obj/item/device/walkman = 15,
		/obj/item/storage/pouch/cassette = 10,
		/obj/item/toy/deck = 20,
		/obj/item/toy/deck/uno = 15,
		/obj/item/device/camera = 30,
		/obj/item/device/toner = 15,
		/obj/item/paper/colonial_grunts = 5,
		/obj/item/toy/dice/d20 = 1,
		/obj/item/tool/pen = 2,
		/obj/item/tool/pen/blue = 2,
		/obj/item/tool/pen/red = 2,
		/obj/item/tool/pen/fountain = 30,
		/obj/item/storage/fancy/cigarettes/trading_card = 30,
		/obj/item/storage/fancy/trading_card = 20,
		/obj/item/toy/trading_card = 5,

	)
	product_type = VENDOR_PRODUCT_TYPE_RECREATIONAL

//vendor of ingredients for kitchen
/obj/structure/machinery/vending/ingredients
	name = "厨房辅助仓储领用系统"
	desc = "供厨师使用的售货机。"
	product_ads = "食材不够？有我在呢！;我的有机食材全都新鲜！;别让土豆放坏了，快去炸点薯条吧！"
	icon_state = "snack"
	hacking_safety = TRUE
	products = list(
		/obj/item/storage/fancy/egg_box = 12,
		/obj/item/storage/box/fish = 12,
		/obj/item/storage/box/meat = 12,
		/obj/item/storage/box/milk = 12,
		/obj/item/storage/box/soymilk = 12,
		/obj/item/storage/box/enzyme = 12,
		/obj/item/storage/box/flour = 12,
		/obj/item/storage/box/sugar = 12,
		/obj/item/storage/box/saltshaker = 12,
		/obj/item/storage/box/peppermill = 12,
		/obj/item/storage/box/mint = 12,
		/obj/item/storage/box/apple = 12,
		/obj/item/storage/box/banana = 12,
		/obj/item/storage/box/chanterelle = 12,
		/obj/item/storage/box/cherries = 12,
		/obj/item/storage/box/chili = 12,
		/obj/item/storage/box/cabbage = 12,
		/obj/item/storage/box/carrot = 12,
		/obj/item/storage/box/corn = 12,
		/obj/item/storage/box/eggplant = 12,
		/obj/item/storage/box/lemon = 12,
		/obj/item/storage/box/lime = 12,
		/obj/item/storage/box/orange = 12,
		/obj/item/storage/box/potato = 12,
		/obj/item/storage/box/tomato = 12,
		/obj/item/storage/box/whitebeet = 12,
	)

	prices = list(
		/obj/item/storage/fancy/egg_box = 1,
		/obj/item/storage/box/fish = 1,
		/obj/item/storage/box/meat = 1,
		/obj/item/storage/box/milk =1,
		/obj/item/storage/box/soymilk = 1,
		/obj/item/storage/box/enzyme = 1,
		/obj/item/storage/box/flour = 1,
		/obj/item/storage/box/sugar = 1,
		/obj/item/storage/box/saltshaker = 1,
		/obj/item/storage/box/peppermill = 1,
		/obj/item/storage/box/mint = 1,
		/obj/item/storage/box/apple = 1,
		/obj/item/storage/box/banana = 2,
		/obj/item/storage/box/chanterelle = 2,
		/obj/item/storage/box/cherries = 2,
		/obj/item/storage/box/chili = 2,
		/obj/item/storage/box/cabbage = 2,
		/obj/item/storage/box/carrot = 2,
		/obj/item/storage/box/corn = 2,
		/obj/item/storage/box/eggplant = 2,
		/obj/item/storage/box/lemon = 2,
		/obj/item/storage/box/lime = 2,
		/obj/item/storage/box/orange = 2,
		/obj/item/storage/box/potato = 2,
		/obj/item/storage/box/tomato = 2,
		/obj/item/storage/box/whitebeet = 2,
	)
	product_type = VENDOR_PRODUCT_TYPE_FOOD
