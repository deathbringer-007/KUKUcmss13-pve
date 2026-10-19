
///////////////////////////////////////////////Alchohol bottles and juice mixers! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom

//Booze bottles have two unqiue functions: They be used to smack someone in the head and turned into a molotov.

/obj/item/reagent_container/food/drinks/bottle
	amount_per_transfer_from_this = 5
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	///This excludes all the juices and dairy in cartons that are also defined in this file.
	var/isGlass = TRUE
	black_market_value = 25

/obj/item/reagent_container/food/drinks/bottle/bullet_act(obj/projectile/P)
	. = ..()
	if(isGlass)
		smash()

///Audio/visual bottle breaking effects start here
/obj/item/reagent_container/food/drinks/bottle/proc/smash(mob/living/target, mob/living/user)
	var/obj/item/weapon/broken_bottle/B
	if(user)
		user.temp_drop_inv_item(src)
		B = new /obj/item/weapon/broken_bottle(user.loc)
		user.put_in_active_hand(B)
	else
		B = new /obj/item/weapon/broken_bottle(src.loc)
	if(prob(33))
		if(target)
			new/obj/item/shard(target.loc) // Create a glass shard at the target's location!
		else
			new/obj/item/shard(src.loc)

	B.icon_state = icon_state

	var/icon/I = new('icons/obj/items/drinks.dmi', icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	playsound(src, "windowshatter", 15, 1)
	transfer_fingerprints_to(B)

	qdel(src)

/obj/item/reagent_container/food/drinks/bottle/attack(mob/living/target as mob, mob/living/user as mob)
	if(!target)
		return

	if(user.a_intent != INTENT_HARM || !isGlass)
		return ..()

	force = 15

	var/obj/limb/affecting = user.zone_selected
	var/drowsy_threshold = 0

	drowsy_threshold = CLOTHING_ARMOR_MEDIUM - target.getarmor(affecting, ARMOR_MELEE)

	target.apply_damage(force, BRUTE, affecting, sharp=0)

	if(affecting == "head" && iscarbon(target) && !isxeno(target))
		for(var/mob/O in viewers(user, null))
			if(target != user)
				O.show_message(text(SPAN_DANGER("<B>[user]用一瓶[name]砸中了[target]的头！</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[target]用一瓶[name]砸中了自己的头！</B>")), SHOW_MESSAGE_VISIBLE)
		if(drowsy_threshold > 0)
			target.apply_effect(min(drowsy_threshold, 10) , DROWSY)

	else //Regular attack text
		for(var/mob/O in viewers(user, null))
			if(target != user)
				O.show_message(text(SPAN_DANGER("<B>[user]用一瓶[name]攻击了[target]！</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[target]用一瓶[name]攻击了自己！</B>")), SHOW_MESSAGE_VISIBLE)

	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has attacked [target.name] ([target.ckey]) with a bottle!</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed with a bottle by [user.name] ([user.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) attacked [target.name] ([target.ckey]) with a bottle (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	if(reagents)
		for(var/mob/O in viewers(user, null))
			O.show_message(text(SPAN_NOTICE("<B>[src]中的液体溅了[target]一身！</B>")), SHOW_MESSAGE_VISIBLE)
		reagents.reaction(target, TOUCH)

	smash(target, user)

	return

/obj/item/reagent_container/food/drinks/bottle/attackby(obj/item/I, mob/living/user)
	if(!isGlass || !istype(I, /obj/item/paper))
		return ..()
	if(!reagents || !length(reagents.reagent_list))
		to_chat(user, SPAN_NOTICE("[src]是空的……"))
		return
	var/alcohol_potency = 0
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.intensitymod)
			alcohol_potency += R.intensitymod * R.volume
		else if(istype(R, /datum/reagent/ethanol))
			var/datum/reagent/ethanol/RA = R
			alcohol_potency += RA.boozepwr * (R.volume / 8)

	if(alcohol_potency < BURN_LEVEL_TIER_1)
		to_chat(user, SPAN_NOTICE("[src]中的易燃液体不足！"))
		return
	alcohol_potency = clamp(alcohol_potency, BURN_LEVEL_TIER_1, BURN_LEVEL_TIER_7)

	if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	var/turf/T = get_turf(src)
	var/obj/item/explosive/grenade/incendiary/molotov/M = new /obj/item/explosive/grenade/incendiary/molotov(T, alcohol_potency)
	to_chat(user, SPAN_NOTICE("你制作了[M]！"))
	user.put_in_hands(M)
	qdel(I)
	qdel(src)

///Alcohol bottles and their contents.
/obj/item/reagent_container/food/drinks/bottle/gin
	name = "添加利金酒"
	desc = "一瓶优质伦敦金酒。"
	icon_state = "ginbottle"
	center_of_mass = "x=16;y=4"

/obj/item/reagent_container/food/drinks/bottle/gin/Initialize()
	. = ..()
	reagents.add_reagent("gin", 100)

/obj/item/reagent_container/food/drinks/bottle/whiskey
	name = "老混蛋叔叔特藏威士忌"
	desc = "优质单一麦芽威士忌，由阿拉巴马偏远乡下的乡巴佬精心陈酿四年。"
	icon_state = "whiskeybottle"
	center_of_mass = "x=16;y=3"

/obj/item/reagent_container/food/drinks/bottle/whiskey/Initialize()
	. = ..()
	reagents.add_reagent("whiskey", 100)

/obj/item/reagent_container/food/drinks/bottle/sake
	name = "维兰德-汤谷清酒"
	desc = "使用传承数千年的古老工艺酿制的清酒，由维兰德-汤谷公司在艾奥瓦州发酵生产。"
	icon_state = "sakebottle"
	center_of_mass = "x=17;y=7"

/obj/item/reagent_container/food/drinks/bottle/sake/Initialize()
	. = ..()
	reagents.add_reagent("sake", 100)

/obj/item/reagent_container/food/drinks/bottle/vodka
	name = "红星伏特加"
	desc = "便宜又流行的苏维埃风格伏特加。瓶身写着：“啦啦红星人：美好事物的爱好者。”"
	icon_state = "red_star_vodka"
	center_of_mass = "x=17;y=3"

/obj/item/reagent_container/food/drinks/bottle/vodka/Initialize()
	. = ..()
	reagents.add_reagent("vodka", 100)

/obj/item/reagent_container/food/drinks/bottle/vodka/stolichnaya
	name = "\improper 首都伏特加"
	desc = "来自进步人民联盟成员国俄罗斯的优质出口酒。得益于对国家法规的一丝不苟地执行，它被公认为市面上品质最好的伏特加之一。"
	icon_state = "vodkabottle"

//chess bottles

/obj/item/reagent_container/food/drinks/bottle/vodka/chess
	name = "红星伏特加促销装酒瓶"
	desc = "红星伏特加的国际象棋主题促销酒瓶。"
	icon_state = "chess"
	black_market_value = 15

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_pawn
	name = "黑色兵瓶"
	icon_state = "b_pawn"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_pawn
	name = "白色兵瓶"
	icon_state = "w_pawn"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_bishop
	name = "黑色象瓶"
	icon_state = "b_bishop"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_bishop
	name = "白色象瓶"
	icon_state = "w_bishop"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_knight
	name = "黑色马瓶"
	icon_state = "b_knight"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_knight
	name = "白色马瓶"
	icon_state = "w_knight"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_rook
	name = "黑色车瓶"
	icon_state = "b_rook"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_rook
	name = "白色车瓶"
	icon_state = "w_rook"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_king
	name = "黑色王瓶"
	icon_state = "b_king"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_king
	name = "白色王瓶"
	icon_state = "w_king"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_queen
	name = "黑色后瓶"
	icon_state = "b_queen"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_queen
	name = "白色后瓶"
	icon_state = "w_queen"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/random/Initialize()
	. = ..()
	var/newbottle = pick(subtypesof(/obj/item/reagent_container/food/drinks/bottle/vodka/chess))
	new newbottle(loc)
	qdel(src)


/obj/item/reagent_container/food/drinks/bottle/tequila
	name = "卡卡沃品质保证龙舌兰酒"
	desc = "采用优质石油馏出物、纯沙利度胺及其他上等原料制作！"
	icon_state = "tequilabottle"
	center_of_mass = "x=16;y=3"

/obj/item/reagent_container/food/drinks/bottle/tequila/Initialize()
	. = ..()
	reagents.add_reagent("tequila", 100)

/obj/item/reagent_container/food/drinks/bottle/davenport
	name = "达文波特黑麦威士忌"
	desc = "风味独特的昂贵威士忌。酒瓶自豪地宣称它是“真正的经典”。"
	icon_state = "davenport"
	center_of_mass = "x=16;y=3"

/obj/item/reagent_container/food/drinks/bottle/davenport/Initialize()
	. = ..()
	reagents.add_reagent("specialwhiskey", 50)

/obj/item/reagent_container/food/drinks/bottle/bottleofnothing
	name = "虚无之瓶"
	desc = "一个什么也没有装的瓶子。"
	icon_state = "bottleofnothing"
	center_of_mass = "x=17;y=5"

/obj/item/reagent_container/food/drinks/bottle/bottleofnothing/Initialize()
	. = ..()
	reagents.add_reagent("nothing", 100)

/obj/item/reagent_container/food/drinks/bottle/patron
	name = "说唱艺术家培恩龙舌兰"
	desc = "掺有银箔的龙舌兰酒，遍及银河各地的太空夜总会。"
	icon_state = "patronbottle"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/patron/Initialize()
	. = ..()
	reagents.add_reagent("patron", 100)

/obj/item/reagent_container/food/drinks/bottle/rum
	name = "皮特船长古巴香料朗姆酒"
	desc = "以著名的“古巴人”皮特船长命名的朗姆酒，和他最后一次任务一样火爆。"
	icon_state = "rumbottle"
	center_of_mass = "x=16;y=8"

/obj/item/reagent_container/food/drinks/bottle/rum/Initialize()
	. = ..()
	reagents.add_reagent("rum", 100)

/obj/item/reagent_container/food/drinks/bottle/holywater
	name = "圣水瓶"
	desc = "一瓶随军牧师的圣水。"
	icon_state = "holyflask"
	center_of_mass = "x=17;y=10"

/obj/item/reagent_container/food/drinks/bottle/holywater/Initialize()
	. = ..()
	reagents.add_reagent("holywater", 100)

/obj/item/reagent_container/food/drinks/bottle/vermouth
	name = "金眼味美思"
	desc = "甜美，甜美的干爽口感～"
	icon_state = "vermouthbottle"
	center_of_mass = "x=17;y=3"

/obj/item/reagent_container/food/drinks/bottle/vermouth/Initialize()
	. = ..()
	reagents.add_reagent("vermouth", 100)

/obj/item/reagent_container/food/drinks/bottle/kahlua
	name = "罗伯特硬汉咖啡利口酒"
	desc = "知名的墨西哥咖啡味利口酒，自 1936 年起生产。叭！"
	icon_state = "kahluabottle"
	center_of_mass = "x=17;y=3"

/obj/item/reagent_container/food/drinks/bottle/kahlua/Initialize()
	. = ..()
	reagents.add_reagent("kahlua", 100)

/obj/item/reagent_container/food/drinks/bottle/goldschlager
	name = "女大学生金箔肉桂酒"
	desc = "因为只有她们才会喝这种酒精度为 50% 的肉桂烈酒。"
	icon_state = "goldschlagerbottle"
	center_of_mass = "x=15;y=3"

/obj/item/reagent_container/food/drinks/bottle/goldschlager/Initialize()
	. = ..()
	reagents.add_reagent("goldschlager", 100)

/obj/item/reagent_container/food/drinks/bottle/cognac
	name = "巴顿酒庄珍藏干邑"
	desc = "经过多次蒸馏和多年陈酿的甜烈酒。这次不妨别再嚷嚷“狗屁安保”了。"
	icon_state = "cognacbottle"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/cognac/Initialize()
	. = ..()
	reagents.add_reagent("cognac", 100)

/obj/item/reagent_container/food/drinks/bottle/wine
	name = "双胡子特酿葡萄酒"
	desc = "瓶子周围隐约散发着不安与找茬的气息。"
	icon_state = "winebottle"
	center_of_mass = "x=16;y=4"

/obj/item/reagent_container/food/drinks/bottle/wine/Initialize()
	. = ..()
	reagents.add_reagent("wine", 100)

/obj/item/reagent_container/food/drinks/bottle/absinthe
	name = "越狱者绿苦艾酒"
	desc = "喝上一口，你就知道好时光要来了。"
	icon_state = "absinthebottle"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/absinthe/Initialize()
	. = ..()
	reagents.add_reagent("absinthe", 100)

/obj/item/reagent_container/food/drinks/bottle/blackout //used for testing alcohol code
	name = "断片烈性黑啤"
	desc = "名扬时空的美酒，一瓶就足以让几乎任何人醉倒。真正考验酒鬼的佳酿。"
	icon_state = "pwineglass"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/blackout/Initialize()
	. = ..()
	reagents.add_reagent("blackout", 100)

/obj/item/reagent_container/food/drinks/bottle/melonliquor
	name = "翡翠蜜瓜利口酒"
	desc = "一瓶酒精度标为 46 proof 的翡翠蜜瓜利口酒，清甜轻盈。"
	icon_state = "alco-green" //Placeholder.
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/melonliquor/Initialize()
	. = ..()
	reagents.add_reagent("melonliquor", 100)

/obj/item/reagent_container/food/drinks/bottle/bluecuracao
	name = "蓝小姐库拉索利口酒"
	desc = "果香浓郁、蓝得出奇的饮料，并不能让饮用者施展第五魔法。"
	icon_state = "alco-blue" //Placeholder.
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/bluecuracao/Initialize()
	. = ..()
	reagents.add_reagent("bluecuracao", 100)

/obj/item/reagent_container/food/drinks/bottle/grenadine
	name = "野蔷薇石榴糖浆"
	desc = "酸甜的酒吧糖浆，用于给饮料增色调味。"
	icon_state = "grenadinebottle"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/grenadine/Initialize()
	. = ..()
	reagents.add_reagent("grenadine", 100)

/obj/item/reagent_container/food/drinks/bottle/pwine
	name = "术士天鹅绒葡萄酒"
	desc = "如此精美的包装，里面一定是上等葡萄酒！年份想必也很出色！"
	icon_state = "pwinebottle"
	center_of_mass = "x=16;y=4"

/obj/item/reagent_container/food/drinks/bottle/pwine/Initialize()
	. = ..()
	reagents.add_reagent("pwine", 100)

////////////////////////// BEERS ///////////////////////

/obj/item/reagent_container/food/drinks/bottle/beer/craft
	name = "彭德尔顿三星啤酒拉格啤酒"
	desc = "盛行于外缘殖民地的拉格啤酒品牌，在内星系却几乎无人知晓，大概是出于健康顾虑。味道完全陌生，却意外清爽并带有果香。背标写着“在科斯塔瓜纳使用异域啤酒花酿造”。你几乎肯定那是个虚构国家。"
	icon_state = "pendleton"
	center_of_mass = "x=16;y=13"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/Initialize()
	. = ..()
	reagents.add_reagent("beer", 30)

/obj/item/reagent_container/food/drinks/bottle/beer/craft/tuxedo
	name = "燕尾服精酿"
	desc = "最初在英国酿造的燕尾服精酿艾尔，广告称它是绅士之酒：应在正式晚宴上细品，而非酒吧畅饮。销量不佳，一是味道与其他啤酒没多大区别，二是价格贵三倍。但请珍惜它，这可是富人的琼浆。"
	icon_state = "tuxedo"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/ganucci
	name = "加努奇纯正淡啤啤酒"
	desc = "淡而水感十足、略带酸味的啤酒。算不上好喝，但便宜得要命，又产自意大利，自然受到大众欢迎。与流言不同，它真是啤酒，而非德鲁伊泡的泥水。"
	icon_state = "ganucci"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/bluemalt
	name = "蓝麦啤酒"
	desc = "酒精度踩在法律边缘的麦芽啤酒。之所以叫“蓝麦”，是因为喝到心脏停跳时脸就会变成蓝色。瓶背用大字印着公共卫生总监的警告。枪械算重型机械吗？"
	icon_state = "bluemalt"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/partypopper
	name = "派对礼炮艾尔啤酒"
	desc = "来自殖民地的有趣异域精酿，在清淡的果香艾尔中加了少量糖。喝下后味蕾仿佛跳起舞来，大概是因为困惑，据说一口就能让人微笑。最适合派对，最不适合葬礼。难道你要对着挚友的坟墓笑吗？"
	icon_state = "partypopper"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/tazhushka
	name = "塔祖什卡绿松石啤酒"
	desc = "来自 UPP，由同名塔祖什卡国营酒厂生产的啤酒。喝下去烧喉咙，却让你觉得无所畏惧——至少在这个品牌闻名的宿醉从里到外击垮你之前如此。"
	icon_state = "tazhushka"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/reaper
	name = "死神红啤"
	desc = "标榜“大胆”“冒险”的烈性日本啤酒。标签就是通用的“危险”标志，喝多了绝对够刺激，刺激到你得提前预约医生，看看那颗哀嚎的肝脏。"
	icon_state = "reaper"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/mono
	name = "单色拉格啤酒"
	desc = "黑白配色的酒瓶既不写产地，也不说是什么酒。你只知道这是啤酒，味道相当寡淡，仿佛在看四百年前的照片。据说把名字念快了，就会想发表一篇冗长的反派演说。"
	icon_state = "mono"

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_container/food/drinks/bottle/orangejuice
	name = "橙汁"
	desc = "满满的维生素与美味！"
	icon_state = "orangejuice"
	item_state = "carton"
	center_of_mass = "x=16;y=7"
	isGlass = 0

/obj/item/reagent_container/food/drinks/bottle/orangejuice/Initialize()
	. = ..()
	reagents.add_reagent("orangejuice", 100)
	var/probability = rand(0, 101)
	switch(probability)
		if(0 to 49)
			desc = "富含维生素，美味可口！不含果肉！"
		if(50 to 100)
			desc = "富含维生素，美味可口！含有果肉！"
		else
			desc = "富含维生素，美味可口！百分之百都是果肉！"

/obj/item/reagent_container/food/drinks/bottle/cream
	name = "奶油"
	desc = "这是奶油，用牛奶做的。你还以为里面会是什么？"
	icon_state = "cream"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	isGlass = 0

/obj/item/reagent_container/food/drinks/bottle/cream/Initialize()
	. = ..()
	reagents.add_reagent("cream", 100)

/obj/item/reagent_container/food/drinks/bottle/tomatojuice
	name = "番茄汁"
	desc = "好吧，至少看起来像番茄汁。红成这样，你也分辨不出来。"
	icon_state = "tomatojuice"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	isGlass = 0

/obj/item/reagent_container/food/drinks/bottle/tomatojuice/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 100)

/obj/item/reagent_container/food/drinks/bottle/limejuice
	name = "青柠汁"
	desc = "酸酸甜甜的美味。"
	icon_state = "limejuice"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	isGlass = 0

/obj/item/reagent_container/food/drinks/bottle/limejuice/Initialize()
	. = ..()
	reagents.add_reagent("limejuice", 100)
