//------------CANTEEN MRE VENDOR---------------
/obj/structure/machinery/cm_vending/sorted/marine_food
	name = "雀巢公司自动大厨"
	desc = "自动烹饪食品分配机，能提供含有人体所需全部维生素和营养的食物。看起来无法入口的糊状物经过加热、重塑和凝固，再加入人工调味料，变成外观和味道都勉强能吃的东西。"
	icon = 'icons/obj/structures/machinery/vending_32x64.dmi'
	icon_state = "food"
	hackable = FALSE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

/obj/structure/machinery/cm_vending/sorted/marine_food/populate_product_list(scale)
	listed_products = list(
		list("机器烹制餐食", -1, null, null),
		list("菜单1：辣炖肉与玉米面包", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal1, VENDOR_ITEM_REGULAR),
		list("菜单2：火腿与土豆", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal2, VENDOR_ITEM_REGULAR),
		list("菜单3：意大利面", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal3, VENDOR_ITEM_REGULAR),
		list("菜单4：披萨", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal4, VENDOR_ITEM_REGULAR),
		list("菜单5：鸡肉", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal5, VENDOR_ITEM_REGULAR),
		list("菜单6：素食豆腐", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal6, VENDOR_ITEM_REGULAR),
		list("菜单7：素食芝士通心粉", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal7, VENDOR_ITEM_REGULAR),
		// these spaces are purely for readability. Preemptive Action is an unsubtle reference to First Strike Bars.
		list("先发制人能量棒", -1, null, null),
		list("巧克力味", 50, /obj/item/reagent_container/food/snacks/protein_pack, VENDOR_ITEM_REGULAR),
		list("草莓味", 50, /obj/item/reagent_container/food/snacks/protein_pack2, VENDOR_ITEM_REGULAR),
		list("香草味", 50, /obj/item/reagent_container/food/snacks/protein_pack3, VENDOR_ITEM_REGULAR),
		// I kind of wish there was just a generic sweet mix.
		list("冲调饮品", -1, null, null),
		list("橙色冲调饮料包", 15, /obj/item/reagent_container/food/condiment/juice/orange, VENDOR_ITEM_REGULAR),
		list("苹果冲调饮料包", 15, /obj/item/reagent_container/food/condiment/juice/apple, VENDOR_ITEM_REGULAR),
		list("西瓜冲调饮料包", 15, /obj/item/reagent_container/food/condiment/juice/watermelon, VENDOR_ITEM_REGULAR),
		list("葡萄冲调饮料包", 15, /obj/item/reagent_container/food/condiment/juice/grape, VENDOR_ITEM_REGULAR),
		list("菠萝冲调饮料包", 15, /obj/item/reagent_container/food/condiment/juice/pineapple, VENDOR_ITEM_REGULAR),
		//weird to have these here but I guess I'll toss in cups.
		list("容器", -1, null, null),
		list("军用水壶", 10, /obj/item/reagent_container/food/drinks/flask/canteen, VENDOR_ITEM_REGULAR),
		list("金属随身水壶", 10, /obj/item/reagent_container/food/drinks/flask, VENDOR_ITEM_REGULAR),
		list("USCM 随身水壶", 5, /obj/item/reagent_container/food/drinks/flask/marine, VENDOR_ITEM_REGULAR),
		list("W-Y 随身水壶", 5, /obj/item/reagent_container/food/drinks/flask/weylandyutani, VENDOR_ITEM_REGULAR),
		list("塑料杯", 20, /obj/item/reagent_container/food/drinks/cup, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/marine_food/upp
	name = "食品分配机"
	desc = "能够供应含有人体所需全部维生素和营养的食物的食品分配机。"
	icon_state = "uppfood"

/obj/structure/machinery/cm_vending/sorted/marine_food/upp/populate_product_list(scale)
	listed_products = list(
		list("预制餐", -1, null, null),
		list("UPP 预制餐 (午餐肉)", 15, /obj/item/reagent_container/food/snacks/mre_pack/upp/meal6, VENDOR_ITEM_REGULAR),
		list("UPP 预制餐 (虾)", 15, /obj/item/reagent_container/food/snacks/mre_pack/upp/meal7, VENDOR_ITEM_REGULAR),
		list("UPP 预制餐 (古巴米饭)", 15, /obj/item/reagent_container/food/snacks/mre_pack/upp/meal8, VENDOR_ITEM_REGULAR),
		list("UPP 预制餐 (肉丸)", 0, /obj/item/reagent_container/food/snacks/mre_pack/upp/meal9, VENDOR_ITEM_REGULAR),
		list("UPP 生存口粮", 50, /obj/item/storage/box/mre/upp, VENDOR_ITEM_REGULAR),
		list("饮料", -1, null, null),
		list("水", 10, /obj/item/reagent_container/food/drinks/water, VENDOR_ITEM_REGULAR),
		list("茶", 10, /obj/item/reagent_container/food/drinks/tea/upp, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial
	hackable = FALSE
	wrenchable = FALSE
	req_access = list(ACCESS_TUTORIAL_LOCKED)

/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial/populate_product_list(scale)
	listed_products = list(
		list("预制餐", -1, null, null),
		list("USCM 预制餐 (鸡肉)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal5, VENDOR_ITEM_REGULAR),
		list("USCM 预制餐 (玉米面包)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal1, VENDOR_ITEM_REGULAR),
		list("USCM 预制餐 (意面)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal3, VENDOR_ITEM_REGULAR),
		list("USCM 预制餐 (披萨)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal4, VENDOR_ITEM_REGULAR),
		list("USCM 预制餐 (猪肉)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal2, VENDOR_ITEM_REGULAR),
		list("USCM 预制餐 (豆腐)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal6, VENDOR_ITEM_REGULAR),
		list("USCM 蛋白能量棒", 1, /obj/item/reagent_container/food/snacks/protein_pack, VENDOR_ITEM_RECOMMENDED),
		list("随身水壶", -1, null, null),
		list("军用水壶", 0, /obj/item/reagent_container/food/drinks/flask/canteen, VENDOR_ITEM_REGULAR),
		list("金属随身水壶", 0, /obj/item/reagent_container/food/drinks/flask, VENDOR_ITEM_REGULAR),
		list("USCM 随身水壶", 0, /obj/item/reagent_container/food/drinks/flask/marine, VENDOR_ITEM_REGULAR),
		list("W-Y 随身水壶", 0, /obj/item/reagent_container/food/drinks/flask/weylandyutani, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/marine_food/rmc

/obj/structure/machinery/cm_vending/sorted/marine_food/rmc/populate_product_list(scale)
	listed_products = list(
		list("预制餐", -1, null, null),
		list("预制餐 (烤牛肉)", 15, /obj/item/reagent_container/food/snacks/mre_pack/rmc/meal1, VENDOR_ITEM_REGULAR),
		list("预制餐 (蒂卡咖喱)", 15, /obj/item/reagent_container/food/snacks/mre_pack/rmc/meal2, VENDOR_ITEM_REGULAR),
		list("预制餐 (炸猪排咖喱)", 15, /obj/item/reagent_container/food/snacks/mre_pack/rmc/meal3, VENDOR_ITEM_REGULAR),
		list("预制餐 (香肠与鸡蛋)", 15, /obj/item/reagent_container/food/snacks/mre_pack/rmc/meal4, VENDOR_ITEM_REGULAR),
		list("预制餐 (海鲜拼盘)", 15, /obj/item/reagent_container/food/snacks/mre_pack/rmc/meal5, VENDOR_ITEM_REGULAR),
		list("棕饼干能量棒", 50, /obj/item/reagent_container/food/snacks/protein_pack/rmc, VENDOR_ITEM_REGULAR),
		list("饮料容器", -1, null, null),
		list("军用水壶", 10, /obj/item/reagent_container/food/drinks/flask/canteen, VENDOR_ITEM_REGULAR),
		list("金属随身水壶", 10, /obj/item/reagent_container/food/drinks/flask, VENDOR_ITEM_REGULAR),
		list("W-Y 随身水壶", 5, /obj/item/reagent_container/food/drinks/flask/weylandyutani, VENDOR_ITEM_REGULAR),
		list("塑料杯", 20, /obj/item/reagent_container/food/drinks/cup, VENDOR_ITEM_REGULAR)
	)

//------------BOOZE-O-MAT VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/boozeomat
	name = "自动调酒机"
	desc = "一项科技奇迹，据说只要开口，就能立刻调出你想喝的酒。"
	icon_state = "boozeomat"
	vendor_theme = VENDOR_THEME_COMPANY
	vend_delay = 1.5 SECONDS
	hackable = TRUE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

/obj/structure/machinery/cm_vending/sorted/boozeomat/populate_product_list(scale)
	listed_products = list(
		list("酒精饮料", -1, null, null),
		list("艾尔啤酒", 6, /obj/item/reagent_container/food/drinks/cans/ale, VENDOR_ITEM_REGULAR),
		list("啤酒", 6, /obj/item/reagent_container/food/drinks/cans/beer, VENDOR_ITEM_REGULAR),
		list("野蔷薇石榴糖浆", 5, /obj/item/reagent_container/food/drinks/bottle/grenadine, VENDOR_ITEM_REGULAR),
		list("卡卡沃品质保证龙舌兰酒", 5, /obj/item/reagent_container/food/drinks/bottle/tequila, VENDOR_ITEM_REGULAR),
		list("皮特船长古巴香料朗姆酒", 5, /obj/item/reagent_container/food/drinks/bottle/rum, VENDOR_ITEM_REGULAR),
		list("巴顿酒庄珍藏干邑", 5, /obj/item/reagent_container/food/drinks/bottle/cognac, VENDOR_ITEM_REGULAR),
		list("达文波特黑麦威士忌", 3, /obj/item/reagent_container/food/drinks/bottle/davenport, VENDOR_ITEM_REGULAR),
		list("双胡子特酿葡萄酒", 5, /obj/item/reagent_container/food/drinks/bottle/wine, VENDOR_ITEM_REGULAR),
		list("翡翠蜜瓜利口酒", 2, /obj/item/reagent_container/food/drinks/bottle/melonliquor, VENDOR_ITEM_REGULAR),
		list("金眼味美思", 5, /obj/item/reagent_container/food/drinks/bottle/vermouth, VENDOR_ITEM_REGULAR),
		list("噬狮鹫金酒", 5, /obj/item/reagent_container/food/drinks/bottle/gin, VENDOR_ITEM_REGULAR),
		list("越狱者绿苦艾酒", 2, /obj/item/reagent_container/food/drinks/bottle/absinthe, VENDOR_ITEM_REGULAR),
		list("蓝小姐库拉索利口酒", 2, /obj/item/reagent_container/food/drinks/bottle/bluecuracao, VENDOR_ITEM_REGULAR),
		list("红星伏特加", 5, /obj/item/reagent_container/food/drinks/bottle/vodka, VENDOR_ITEM_REGULAR),
		list("罗伯特硬汉咖啡利口酒", 5, /obj/item/reagent_container/food/drinks/bottle/kahlua, VENDOR_ITEM_REGULAR),
		list("老混蛋叔叔特藏威士忌", 5, /obj/item/reagent_container/food/drinks/bottle/whiskey, VENDOR_ITEM_REGULAR),
		list("维兰德-汤谷阿斯彭啤酒", 20, /obj/item/reagent_container/food/drinks/cans/aspen, VENDOR_ITEM_REGULAR),

		list("精酿啤酒", -1, null, null),
		list("彭德尔顿三星啤酒", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft, VENDOR_ITEM_REGULAR),
		list("燕尾服精酿", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/tuxedo, VENDOR_ITEM_REGULAR),
		list("加努奇纯正淡啤", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/ganucci, VENDOR_ITEM_REGULAR),
		list("蓝麦啤酒", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/bluemalt, VENDOR_ITEM_REGULAR),
		list("派对礼炮艾尔啤酒", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/partypopper, VENDOR_ITEM_REGULAR),
		list("塔祖什卡绿松石啤酒", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/tazhushka, VENDOR_ITEM_REGULAR),
		list("死神红啤", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/reaper, VENDOR_ITEM_REGULAR),
		list("单色拉格啤酒", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/mono, VENDOR_ITEM_REGULAR),

		list("无酒精饮料", -1, null, null),
		list("紫公爵茶", 10, /obj/item/reagent_container/food/drinks/tea, VENDOR_ITEM_REGULAR),
		list("果啤", 8, /obj/item/reagent_container/food/drinks/cans/cola, VENDOR_ITEM_REGULAR),
		list("青柠汁", 4, /obj/item/reagent_container/food/drinks/bottle/limejuice, VENDOR_ITEM_REGULAR),
		list("奶油", 4, /obj/item/reagent_container/food/drinks/bottle/cream, VENDOR_ITEM_REGULAR),
		list("橙汁", 4, /obj/item/reagent_container/food/drinks/bottle/orangejuice, VENDOR_ITEM_REGULAR),
		list("苏打水", 15, /obj/item/reagent_container/food/drinks/cans/sodawater, VENDOR_ITEM_REGULAR),
		list("番茄汁", 4, /obj/item/reagent_container/food/drinks/bottle/tomatojuice, VENDOR_ITEM_REGULAR),
		list("汤力水", 8, /obj/item/reagent_container/food/drinks/cans/tonic, VENDOR_ITEM_REGULAR),

		list("容器", -1, null, null),
		list("随身水壶", 5, /obj/item/reagent_container/food/drinks/flask/barflask, VENDOR_ITEM_REGULAR),
		list("玻璃杯", 30, /obj/item/reagent_container/food/drinks/drinkingglass, VENDOR_ITEM_REGULAR),
		list("冰杯", 30, /obj/item/reagent_container/food/drinks/ice, VENDOR_ITEM_REGULAR),
		list("保温壶", 5, /obj/item/reagent_container/food/drinks/flask/vacuumflask, VENDOR_ITEM_REGULAR)
	)


/obj/structure/machinery/cm_vending/sorted/boozeomat/chess
	name = "棋酒售货机"
	desc = "2143 年，隶属 UPP-CA（殖民地管理局）的红星饮料公司举办促销抽奖：在限量红星伏特加瓶盖内找到特殊代码的顾客，会获赠一台可无限续杯的棋酒售货机。"
	vendor_theme = VENDOR_THEME_COMPANY
	icon_state = "chessomat"
	hackable = TRUE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

/obj/structure/machinery/cm_vending/sorted/boozeomat/chess/populate_product_list(scale)
	listed_products = list(
		list("白棋", -1, null, null),
		list("兵", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_pawn, VENDOR_ITEM_REGULAR),
		list("象", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_bishop, VENDOR_ITEM_REGULAR),
		list("马", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_knight, VENDOR_ITEM_REGULAR),
		list("车", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_rook, VENDOR_ITEM_REGULAR),
		list("王", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_king, VENDOR_ITEM_REGULAR),
		list("后", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_queen, VENDOR_ITEM_REGULAR),

		list("黑棋", -1, null, null),
		list("兵", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_pawn, VENDOR_ITEM_REGULAR),
		list("象", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_bishop, VENDOR_ITEM_REGULAR),
		list("马", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_knight, VENDOR_ITEM_REGULAR),
		list("车", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_rook, VENDOR_ITEM_REGULAR),
		list("王", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_king, VENDOR_ITEM_REGULAR),
		list("后", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_queen, VENDOR_ITEM_REGULAR)
	)
