//**********************Marine Gear**************************/

//MARINE COMBAT LIGHT

/obj/item/device/flashlight/combat
	name = "战斗手电筒"
	desc = "可手持或安装在步枪上的手电筒，灯泡性能优于普通手电筒。"
	icon_state = "combat_flashlight"
	item_state = "flashlight"
	light_range = 5 //Pretty luminous, but still a flashlight that fits in a pocket

//MARINE SNIPER TARPS

/obj/item/bodybag/tarp
	name = "V1 隔热伪装布（已折叠）"
	desc = "USCM 狙击手携带的伪装布。正确使用并伏卧其下时，狙击手几乎与地貌融为一体。采用抑热织层、光学伪装和气味抑制技术，隐藏使用者的热信号与踪迹。"
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "jungletarp_folded"
	w_class = SIZE_MEDIUM
	unfolded_path = /obj/structure/closet/bodybag/tarp
	unacidable = TRUE

/obj/item/bodybag/tarp/snow
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "snowtarp_folded"
	unfolded_path = /obj/structure/closet/bodybag/tarp/snow

/obj/item/bodybag/tarp/reactive
	name = "V2 自适应热学伪装布（已折叠）"
	desc = "部分 USCM 步兵携带的伪装布。升级型号部署后若能充分收集环境数据，就能近乎完美地融入周围，也能隐藏使用者的热信号。"
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "reactivetarp_folded"
	unfolded_path = /obj/structure/closet/bodybag/tarp/reactive

/obj/item/bodybag/tarp/reactive/scout
	name = "V3 自适应热学伪装布（已折叠）"
	desc = "V2 热伪装布的紧凑改进版，主要用于运输阵亡或受伤的陆战队员。隐蔽技术优于早期型号，隐形更快、效果更好。"
	icon_state = "scouttarp_folded"
	w_class = SIZE_SMALL
	unfolded_path = /obj/structure/closet/bodybag/tarp/reactive/scout

/obj/structure/closet/bodybag/tarp
	name = "\improper V1 隔热伪装布"
	bag_name = "\improper V1 隔热伪装布"
	desc = "USCM 狙击手携带的伪装布。正确使用并伏卧其下时，狙击手几乎与地貌融为一体。采用抑热织层、光学伪装和气味抑制技术，隐藏使用者的热信号与踪迹。"
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "jungletarp_closed"
	icon_closed = "jungletarp_closed"
	icon_opened = "jungletarp_open"
	open_sound = 'sound/effects/vegetation_walk_1.ogg'
	close_sound = 'sound/effects/vegetation_walk_2.ogg'
	item_path = /obj/item/bodybag/tarp
	anchored = FALSE
	var/uncloak_time = 3 //in SECONDS, this is how long it takes for the tarp to become fully visible again once it's opened from an invisible state
	var/cloak_time = 15 //ditto for cloaking
	var/closed_alpha = 60 //how much ALPHA the tarp has once it's fully cloaked.
	var/can_store_dead = FALSE
	var/is_animating = FALSE
	var/first_open = TRUE
	exit_stun = 0
	/// used to implement a delay before tarp can be entered again after opened (anti-exploit)
	COOLDOWN_DECLARE(toggle_delay)

/obj/structure/closet/bodybag/tarp/snow
	icon_state = "snowtarp_closed"
	icon_closed = "snowtarp_closed"
	icon_opened = "snowtarp_open"
	item_path = /obj/item/bodybag/tarp/snow

/obj/structure/closet/bodybag/tarp/reactive
	name = "\improper V2 自适应热学伪装布"
	bag_name = "\improper V2 自适应热学伪装布"
	desc = "部分 USCM 步兵携带的伪装布。升级型号部署后若能充分收集环境数据，就能近乎完美地融入周围，也能隐藏使用者的热信号。"
	icon_state = "reactivetarp_closed"
	icon_closed = "reactivetarp_closed"
	icon_opened = "reactivetarp_open"
	open_sound = 'sound/effects/vegetation_walk_1.ogg'
	close_sound = 'sound/effects/vegetation_walk_2.ogg'

	item_path = /obj/item/bodybag/tarp/reactive
	anchored = FALSE

/obj/structure/closet/bodybag/tarp/reactive/scout
	name = "V3 自适应热学伪装布（已折叠）"
	bag_name = "\improper V3 自适应热学伪装布"
	desc = "更小巧的改进型 V2 热隐蔽篷布，主要用于运送阵亡或受伤的陆战队员。其隐形技术优于早期型号，隐蔽程度更高，启动也更快。\n在手中使用，或点击相邻地面即可展开；再次点击关闭，会自动使袋子隐形。再点一次即可打开并解除隐形。如果找不到它，可右键检查周围地格的内容物。"
	icon_state = "scouttarp_closed"
	icon_closed = "scouttarp_closed"
	icon_opened = "scouttarp_open"
	item_path = /obj/item/bodybag/tarp/reactive/scout
	cloak_time = 5
	closed_alpha = 10 //Between scout & ghillie camo alphas
	exit_stun = 1
	can_store_dead = TRUE

/obj/structure/closet/bodybag/tarp/store_mobs(stored_units)//same as stasis bag proc
	var/list/mobs_can_store = list()
	for(var/mob/living/carbon/human/H in loc)
		if(H.buckled)
			continue
		if(H.stat == DEAD && !can_store_dead) // dead, nope
			continue
		mobs_can_store += H
	var/mob/living/carbon/human/mob_to_store
	if(length(mobs_can_store))
		mob_to_store = pick(mobs_can_store)
		mob_to_store.forceMove(src)
		mob_to_store.unset_interaction()
		stored_units += mob_size
	return stored_units

/obj/structure/closet/bodybag/tarp/proc/handle_cloaking()
	if(opened) //if we are OPENING the bag. It checks for opened because the handle_cloaking proc triggers AFTER the parent open() is called
		if(first_open) //if this is the first time we are opening it (ie not animated because the open proc is being triggered by putting it on the ground)
			alpha = 255
			first_open = FALSE
			return
		if(is_animating) //if it's not fully cloaked we don't want to do the whole animation from a fully cloaked state.
			alpha = 255
			is_animating = FALSE
			return
		else //not animating and not the first time we're opening it, therefore play the full animation from a fully cloaked state
			is_animating = TRUE
			animate(src, alpha = 255, time = uncloak_time SECONDS, easing = QUAD_EASING)
			spawn(uncloak_time SECONDS)
				is_animating = FALSE
				return
	else //if we are CLOSING the bag, animate as usual.
		is_animating = TRUE
		animate(src, alpha = closed_alpha, time = cloak_time SECONDS, easing = QUAD_EASING)
		spawn(cloak_time SECONDS)
			is_animating = FALSE //animation finished
			return

/obj/structure/closet/bodybag/tarp/open()
	COOLDOWN_START(src, toggle_delay, 3 SECONDS) //3 seconds must pass before tarp can be closed
	. = ..()
	handle_cloaking()

/obj/structure/closet/bodybag/tarp/close(mob/user)
	if(!COOLDOWN_FINISHED(src, toggle_delay))
		to_chat(user, SPAN_WARNING("现在还不能关闭[src]！"))
		return FALSE
	. = ..()
	handle_cloaking()

/obj/structure/broken_apc
	name = "\improper M577 装甲运兵车"
	desc = "能运送陆战队员的巨大装甲载具。\n这辆目前无法运行。"
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	unslashable = TRUE
	icon = 'icons/obj/apc.dmi'
	icon_state = "apc"


/obj/item/reagent_container/food/snacks/protein_pack
	name = "巧克力先发制人营养棒"
	desc = "酥脆易碎的军用营养棒。无论好坏，它都是美国武装部队的经典食品。巧克力略带人工味，甜菊糖也几乎盖不住维生素味。"
	icon_state = "yummers"
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	filling_color = "#ED1169"
	w_class = SIZE_TINY

/obj/item/reagent_container/food/snacks/protein_pack/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)
	reagents.add_reagent("coco", 8)
	bitesize = 4

/obj/item/reagent_container/food/snacks/protein_pack2
	name = "草莓先发制人营养棒"
	desc = "酥脆易碎的军用营养棒。无论好坏，它都是美国武装部队的经典食品。草莓涂层显然甜过头了。"
	//TODO: ACTUAL SPRITES
	icon_state = "yummers2"
	filling_color = "#ff00cc"
	w_class = SIZE_TINY

/obj/item/reagent_container/food/snacks/protein_pack2/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)
	reagents.add_reagent("strawberrypowder", 8)
	bitesize = 4

/obj/item/reagent_container/food/snacks/protein_pack3
	name = "香草先发制人营养棒"
	desc = "酥脆易碎的军用营养棒。无论好坏，它都是美国武装部队的经典食品。香草味浓得呛人，甜味却不足以掩盖夹心的苦涩余味。"
	//TODO: ACTUAL SPRITES
	icon_state = "yummers3"
	filling_color = "#e6e6e6"
	w_class = SIZE_TINY

/obj/item/reagent_container/food/snacks/protein_pack3/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)
	reagents.add_reagent("vanilla", 8)
	bitesize = 4

/obj/item/reagent_container/food/snacks/mre_pack
	name = "通用即食军粮包"
	icon = 'icons/obj/items/food_canteen.dmi'
	icon_state = "mar_tray_empty"
	trash = /obj/item/trash/USCMtray
	w_class = SIZE_SMALL

/obj/item/reagent_container/food/snacks/mre_pack/meal1
	name = "机器烹制餐食 (辣炖肉与玉米面包)"
	desc = "自动大厨模仿所谓“南方菜”制作的餐食。内含调味过重、掺有复水豆子的辣炖肉，干燥易碎的玉米面包，以及某种曾经可能是西班牙冷汤的东西。"
	icon_state = "mar_tray_menu1"
	filling_color = "#ED1169"

/obj/item/reagent_container/food/snacks/mre_pack/meal1/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal2
	name = "机器烹制餐食 (火腿与土豆)"
	desc = "自动大厨制作的餐食：略欠火候的火腿、用真土豆粉制成且意外好吃的复水薯角、人工果泥和不新鲜的饼干。"
	icon_state = "mar_tray_menu2"

/obj/item/reagent_container/food/snacks/mre_pack/meal2/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 2

/obj/item/reagent_container/food/snacks/mre_pack/meal3
	name = "机器烹制餐食 (意大利面)"
	desc = "自动大厨制作的餐食：咸过头的酱汁意面配方形“牛肉丸”。配菜有烤得恰到好处的面包棒、受热不均的热狗和寡淡的苹果酱。"
	icon_state = "mar_tray_menu3"

/obj/item/reagent_container/food/snacks/mre_pack/meal3/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal4
	name = "机器烹制餐食 (披萨)"
	desc = "自动大厨制作的餐食：撒着少量香肠碎、调味不足的芝士披萨。配菜是湿得令人担忧的复水炒蛋，以及略有冻伤的炒西兰花。"
	icon_state = "mar_tray_menu4"

/obj/item/reagent_container/food/snacks/mre_pack/meal4/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal5
	name = "机器烹制餐食 (鸡肉)"
	desc = "自动大厨制作的餐食：似乎符合清真要求、但可能没熟透的烤鸡片，不明可疑酱汁，混合坚果，煮过头的糙米，以及一管维生素味很重的樱桃味清真果冻。"
	icon_state = "mar_tray_menu5"

/obj/item/reagent_container/food/snacks/mre_pack/meal5/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal6
	name = "机器烹制餐食 (素食豆腐)"
	desc = "自动大厨制作的餐食：煎得意外不错的豆腐、不新鲜的饼干和调味不足的面包棒。另配一根草莓味平平的蛋白棒。"
	icon_state = "mar_tray_menu6"

/obj/item/reagent_container/food/snacks/mre_pack/meal6/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal7
	name = "机器烹制餐食 (芝士通心粉)"
	desc = "自动大厨制作的餐食：黏稠得令人担忧的芝士通心粉。配菜有略带冻伤的炒西兰花、一管樱桃兼维生素味果冻和一包混合坚果。"
	icon_state = "mar_tray_menu7"

/obj/item/reagent_container/food/snacks/mre_pack/meal7/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/xmas1
	name = "\improper 自动配餐（糖霜饼干）"
	desc = "自动厨师制作的餐点：烤得过火的糖霜饼干、一包号称樱桃酥饼的东西，以及一种是否适合蘸饼干颇有争议的香料蘸酱。配菜是湿润的果酱旋纹面包卷。"
	icon_state = "mar_tray_menuSC"
	black_market_value = 10

/obj/item/reagent_container/food/snacks/mre_pack/xmas1/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	reagents.add_reagent("sugar", 9)
	bitesize = 8

/obj/item/reagent_container/food/snacks/mre_pack/xmas2
	name = "\improper 自动配餐（姜饼和香草蛋糕）"
	desc = "自动厨师制作的餐点：软得奇怪的姜饼和甜味明显不足的香草蛋糕。附有一根蛋白棒和一管富含维生素的樱桃味果冻。"
	icon_state = "mar_tray_menuGV"
	black_market_value = 10

/obj/item/reagent_container/food/snacks/mre_pack/xmas2/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	reagents.add_reagent("sugar", 9)
	bitesize = 8

/obj/item/reagent_container/food/snacks/mre_pack/xmas3
	name = "\improper 自动配餐（水果蛋糕）"
	desc = "自动厨师制作的水果蛋糕和苹果酱。蛋糕吃起来一股维生素味，却出乎意料地还算可口。至于苹果酱……至少它在那儿？"
	icon_state = "mar_tray_menuFC"
	black_market_value = 10

/obj/item/reagent_container/food/snacks/mre_pack/xmas3/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	reagents.add_reagent("sugar", 9)
	bitesize = 8

/obj/item/reagent_container/food/snacks/mre_pack/thanksgiving
	name = "\improper 自动配餐（火鸡配土豆）"
	desc = "自动厨师制作的烤火鸡片，配上用真正土豆粉复水制成的土豆角。另有一管樱桃酥饼和一杯密封包装的寡淡苹果酱。"
	icon_state = "mar_tray_menuTP"

/obj/item/reagent_container/food/snacks/mre_pack/thanksgiving/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/thanksgiving2
	name = "\improper 自动配餐（牛排配土豆）"
	desc = "自动厨师制作的半生牛排片，配上用真正土豆粉复水制成的土豆角。另有一管樱桃酥饼和一杯密封包装的寡淡苹果酱。"
	icon_state = "mar_tray_menuSP"

/obj/item/reagent_container/food/snacks/mre_pack/thanksgiving2/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/thanksgiving3
	name = "\improper 自动配餐（虾仁配米饭）"
	desc = "自动厨师制作的炒仿虾仁和煮过头的糙米饭。配有混合坚果和不明酱料。"
	icon_state = "mar_tray_menuSR"

/obj/item/reagent_container/food/snacks/mre_pack/thanksgiving3/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	bitesize = 3

//UPP Tray Food

/obj/item/reagent_container/food/snacks/mre_pack/upp
	name = "通用即食军粮包"
	icon = 'icons/obj/items/food.dmi'
	icon_state = "upp_lid"
	trash = /obj/item/trash/UPPtray
	w_class = SIZE_SMALL
	bitesize = 5

/obj/item/reagent_container/food/snacks/mre_pack/upp/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)

/obj/item/reagent_container/food/snacks/mre_pack/upp/meal1
	name = "\improper 进步人民联盟预制餐（炒面）"
	desc = "仿虾仁炒面、两个略微炸过头的春卷、某种粥，以及一小块豆腐。"
	icon_state = "upp_chowmein"

/obj/item/reagent_container/food/snacks/mre_pack/upp/meal2
	name = "\improper 进步人民联盟预制餐（巴努什玉米粥）"
	desc = "乌克兰风味巴努什玉米炖粥、杏干和两根维也纳香肠。"
	icon_state = "upp_banush"

/obj/item/reagent_container/food/snacks/mre_pack/upp/meal3
	name = "\improper 进步人民联盟预制餐（法兰克福香肠）"
	desc = "一根硕大多汁的法兰克福香肠，配土豆泥、酥脆土豆饼和酸菜。"
	icon_state = "upp_frankfurter"

/obj/item/reagent_container/food/snacks/mre_pack/upp/meal4
	name = "\improper 进步人民联盟预制餐（饺子）"
	desc = "四个水饺、酱油醋蘸料、腌红黄瓜和两块黑麦饼干。"
	icon_state = "upp_jiaozi"

/obj/item/reagent_container/food/snacks/mre_pack/upp/meal5
	name = "\improper 进步人民联盟预制餐（香肠拼盘）"
	desc = "餐盘里装着两勺米饭、两根维也纳香肠、一张淋有番茄酱的玉米饼，以及一小碗绿豆汤。"
	icon_state = "upp_wursts"

/obj/item/reagent_container/food/snacks/mre_pack/upp/meal6
	name = "UPP 预制餐 (午餐肉)"
	desc = "UPP 部队的预包装餐，内含两勺略干的米饭、一块不明午餐肉、两根胡萝卜条和一条“水果”棒。"
	icon_state = "upp_luncheon"

/obj/item/reagent_container/food/snacks/mre_pack/upp/meal7
	name = "UPP 预制餐 (虾)"
	desc = "UPP 部队的预包装餐，内含油腻的米饼，混有仿制虾仁碎与鸡蛋调味料。气味很不对劲，另配一根略湿软的春卷。"
	icon_state = "upp_shrimp"

/obj/item/reagent_container/food/snacks/mre_pack/upp/meal8
	name = "UPP 预制餐 (古巴米饭)"
	desc = "UPP 部队的预包装餐，内含古巴米饭、寡淡的鸡蛋块、番茄酱、土豆沙拉和一块干饼干。"
	icon_state = "upp_cuban"

/obj/item/reagent_container/food/snacks/mre_pack/upp/meal9
	name = "UPP 预制餐 (肉丸)"
	desc = "UPP 部队的预包装餐，内含腌制柯尼斯堡肉丸、奶油酱、菠菜和一勺米饭。算是预包装餐中较好的选择，因此几乎总是缺货。"
	icon_state = "upp_meatballs"

//RMC Tray Food

/obj/item/reagent_container/food/snacks/protein_pack/rmc
	name = "棕饼干能量棒"
	desc = "披着美味外衣的魔鬼。吃起来快，味道和口感都不错，但短时间吃超过一根，至少两周都不用在野外挖厕所坑了。"
	icon_state = "muesli"
	filling_color = "#ED1169"

/obj/item/reagent_container/food/snacks/mre_pack/rmc
	name = "通用即食军粮包"
	icon = 'icons/obj/items/food_canteen.dmi'
	icon_state = "rmc_tray_empty"
	trash = /obj/item/trash/RMCtray
	w_class = SIZE_SMALL
	bitesize = 5

/obj/item/reagent_container/food/snacks/mre_pack/rmc/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)

/obj/item/reagent_container/food/snacks/mre_pack/rmc/meal1
	name = "RMC 预制餐 (烤牛肉)"
	desc = "一块浸在过咸肉汁里的仿制牛肉，配有没熟透的豌豆、湿软胡萝卜和干得奇怪的土豆泥。"
	icon_state = "rmc_meat"

/obj/item/reagent_container/food/snacks/mre_pack/rmc/meal2
	name = "RMC 预制餐 (蒂卡咖喱)"
	desc = "猪肉块与土豆浸在温和的印度咖喱酱中，配有松软米饭和一小块温吞的印度烤饼。"
	icon_state = "rmc_tikka"

/obj/item/reagent_container/food/snacks/mre_pack/rmc/meal3
	name = "RMC 预制餐 (炸猪排咖喱)"
	desc = "裹面包糠的鸡肉条浇上日式咖喱酱，配有松软米饭和一堆认不出是什么的过熟蔬菜。"
	icon_state = "rmc_katsu"

/obj/item/reagent_container/food/snacks/mre_pack/rmc/meal4
	name = "RMC 预制餐 (香肠与鸡蛋)"
	desc = "餐盘里装着几根烤过头的香肠、一团炒蛋、大量红薯条和四季豆。"
	icon_state = "rmc_sausage"

/obj/item/reagent_container/food/snacks/mre_pack/rmc/meal5
	name = "RMC 预制餐 (海鲜拼盘)"
	desc = "餐盘配菜格里放着多种寿司，主菜则是冷白米饭上的几片三文鱼刺身。"
	icon_state = "rmc_fish"

/obj/item/storage/box/pizza
	name = "外卖盒"
	desc = "一种太空时代的食物储存装置，能让食物格外新鲜。其实就是个盒子。"

/obj/item/storage/box/pizza/Initialize()
	. = ..()
	pixel_y = rand(-3,3)
	pixel_x = rand(-3,3)
	new /obj/item/reagent_container/food/snacks/microwavable/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/microwavable/donkpocket(src)
	var/randsnack
	for(var/i = 1 to 3)
		randsnack = rand(0,5)
		switch(randsnack)
			if(0)
				new /obj/item/reagent_container/food/snacks/fries(src)
			if(1)
				new /obj/item/reagent_container/food/snacks/cheesyfries(src)
			if(2)
				new /obj/item/reagent_container/food/snacks/bigbiteburger(src)
			if(4)
				new /obj/item/reagent_container/food/snacks/taco(src)
			if(5)
				new /obj/item/reagent_container/food/snacks/hotdog(src)

/obj/item/paper/janitor
	name = "揉皱的纸"
	icon_state = "pamphlet"
	info = "深切缅怀卡布·约翰逊。"


/obj/item/device/overwatch_camera
	name = "M5 摄像装备"
	desc = "摄像机及配套头戴装备，让部队指挥官能够看到士兵的视野，也让士兵通过抬头显示器查看小队信息。美洲联盟部队使用的标准战斗头盔均集成了更坚固的版本。"
	icon = 'icons/obj/items/clothing/glasses.dmi'
	icon_state = "overwatch_gear"
	item_state = "overwatch_gear"
	item_icons = list(
		WEAR_L_EAR = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_R_EAR = 'icons/mob/humans/onmob/ears.dmi',
		)
	flags_equip_slot = SLOT_EAR
	var/obj/structure/machinery/camera/camera
	has_hud = TRUE
	hud_type = list(MOB_HUD_FACTION_MARINE, MOB_HUD_FACTION_ARMY, MOB_HUD_FACTION_NAVY)

/obj/item/device/overwatch_camera/Initialize(mapload, ...)
	. = ..()
	camera = new /obj/structure/machinery/camera/overwatch(src)

/obj/item/device/overwatch_camera/Destroy()
	QDEL_NULL(camera)
	return ..()

/obj/item/device/overwatch_camera/equipped(mob/living/carbon/human/mob, slot)
	if(mob.has_item_in_ears(src))
		camera.c_tag = mob.name
		for(var/type in hud_type)
			var/datum/mob_hud/MH = GLOB.huds[type]
			MH.add_hud_to(mob, src)
	..()

/obj/item/device/overwatch_camera/dropped(mob/user)
	if(camera)
		camera.c_tag = "Unknown"
	if(hud_type)
		for(var/type in hud_type)
			var/datum/mob_hud/MH = GLOB.huds[type]
			MH.remove_hud_from(user, src)
	..()

/obj/item/device/overwatch_camera/twe
	name = "OOCUHM 摄像装备"
	desc = "头戴式作战监督摄像单元。佩戴它的陆战突击队员通常昵称它为“小眼睛”或“老大哥”。这套由三世界帝国制造的摄像单元与目镜，既能让指挥部监督行动，也能向佩戴者显示增强现实抬头界面。"
	hud_type = list(MOB_HUD_FACTION_TWE, MOB_HUD_FACTION_WY)
	icon_state = "rmc_overwatch_gear"
	item_state = "rmc_overwatch_gear"

/obj/item/device/overwatch_camera/pmc
	name = "Mk3 TOCU 头戴摄像机"
	desc = "战术监控摄像装置是 RMC 摄像装备的改进加固版，供不戴常规防护头具的维兰德-汤谷 PMC 部队使用，使其主管始终掌握作战人员的状态。"
	hud_type = list(MOB_HUD_FACTION_PMC, MOB_HUD_FACTION_WY, MOB_HUD_FACTION_TWE)
	icon_state = "rmc_overwatch_gear"
	item_state = "rmc_overwatch_gear"

/obj/item/device/overwatch_camera/upp
	name = "1PN77M \"潜望镜\" 摄像装置"
	desc = "用于替代上一代头戴瞄具的“潜望镜”，在人体工学与技术上都有改进。先进摄像系统与重新设计的光学组件同时提高了军官监控与个人战斗能力，因此在 UPP 各军种中广泛采用。"
	hud_type = list(MOB_HUD_FACTION_UPP)
	icon_state = "upp_overwatch_gear"
	item_state = "upp_overwatch_gear"
