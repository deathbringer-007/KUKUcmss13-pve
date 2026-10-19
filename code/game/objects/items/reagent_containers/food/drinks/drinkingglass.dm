

/obj/item/reagent_container/food/drinks/drinkingglass
	name = "玻璃杯"
	desc = "普通的饮水玻璃杯。"
	icon_state = "glass_empty"
	matter = list("glass" = 500)
	amount_per_transfer_from_this = 5
	volume = 50
	center_of_mass = "x=16;y=10"

/obj/item/reagent_container/food/drinks/drinkingglass/on_reagent_change()
	/*if(length(reagents.reagent_list) > 1 )
		icon_state = "glass_brown"
		name = "Glass of Hooch"
		desc = "Two or more drinks, mixed together."*/
	/*else if(length(reagents.reagent_list) == 1)
		for(var/datum/reagent/R in reagents.reagent_list)
			switch(R.id)*/
	if (length(reagents.reagent_list) > 0)
		//mrid = R.get_master_reagent_id()
		var/datum/reagent/R = reagents.get_master_reagent()
		switch(R.id)
			if("beer")
				icon_state = "beerglass"
				name = "一杯啤酒"
				desc = "一品脱冰凉的啤酒。"
				center_of_mass = "x=16;y=8"
			if("beer2")
				icon_state = "beerglass"
				name = "一杯啤酒"
				desc = "一品脱冰凉的啤酒。"
				center_of_mass = "x=16;y=8"
			if("ale")
				icon_state = "aleglass"
				name = "一杯艾尔啤酒"
				desc = "一品脱冰凉美味的艾尔啤酒。"
				center_of_mass = "x=16;y=8"
			if("milk")
				icon_state = "glass_white"
				name = "一杯牛奶"
				desc = "洁白又营养的好东西！"
				center_of_mass = "x=16;y=10"
			if("cream")
				icon_state  = "glass_white"
				name = "一杯奶油"
				desc = "呃……"
				center_of_mass = "x=16;y=10"
			if("chocolate")
				icon_state  = "chocolateglass"
				name = "一杯巧克力饮"
				desc = "美味。"
				center_of_mass = "x=16;y=10"
			if("lemonjuice")
				icon_state  = "lemonglass"
				name = "一杯柠檬汁"
				desc = "真酸……"
				center_of_mass = "x=16;y=10"
			if("cola")
				icon_state  = "glass_brown"
				name = "一杯可口可乐"
				desc = "一杯清爽的可口可乐。"
				center_of_mass = "x=16;y=10"
			if("pepsi")
				icon_state  = "glass_brown"
				name = "一杯百事可乐"
				desc = "一杯清爽的百事可乐。"
				center_of_mass = "x=16;y=10"
			if("nuka_cola")
				icon_state = "nuka_colaglass"
				name = "核子可乐"
				desc = "别哭，也别抬头看，这不过是核子废土。"
				center_of_mass = "x=16;y=6"
			if("orangejuice")
				icon_state = "glass_orange"
				name = "一杯橙汁"
				desc = "维生素！好耶！"
				center_of_mass = "x=16;y=10"
			if("tomatojuice")
				icon_state = "glass_red"
				name = "一杯番茄汁"
				desc = "你确定这是番茄汁吗？"
				center_of_mass = "x=16;y=10"
			if("blood")
				icon_state = "glass_red"
				name = "一杯番茄汁"
				desc = "你确定这是番茄汁吗？"
				center_of_mass = "x=16;y=10"
			if("limejuice")
				icon_state = "glass_green"
				name = "一杯青柠汁"
				desc = "一杯酸甜的青柠汁。"
				center_of_mass = "x=16;y=10"
			if("whiskey")
				icon_state = "whiskeyglass"
				name = "一杯威士忌"
				desc = "杯中顺滑且带有烟熏风味的威士忌，让这杯酒显得格外高雅。"
				center_of_mass = "x=16;y=12"
			if("gin")
				icon_state = "ginvodkaglass"
				name = "一杯金酒"
				desc = "一杯清澈透明的噬狮鹫金酒。"
				center_of_mass = "x=16;y=12"
			if("sake")
				icon_state = "ginvodkaglass"
				name = "一杯清酒"
				desc = "一杯温热的维兰德-汤谷牌清酒。"
				center_of_mass = "x=16;y=12"
			if("vodka")
				icon_state = "ginvodkaglass"
				name = "一杯伏特加"
				desc = "杯里装着伏特加。真他妈的。"
				center_of_mass = "x=16;y=12"
			if("sake")
				icon_state = "ginvodkaglass"
				name = "一杯清酒"
				desc = "一杯清酒。"
				center_of_mass = "x=16;y=12"
			if("goldschlager")
				icon_state = "ginvodkaglass"
				name = "一杯金箔肉桂酒"
				desc = "五十度的铁证：只要里面有金子，少女们什么都肯喝。"
				center_of_mass = "x=16;y=12"
			if("wine")
				icon_state = "wineglass"
				name = "一杯葡萄酒"
				desc = "一杯看起来非常高雅的饮品。"
				center_of_mass = "x=15;y=7"
			if("cognac")
				icon_state = "cognacglass"
				name = "一杯干邑"
				desc = "该死，光是拿着它，你就觉得自己像个法国贵族。"
				center_of_mass = "x=16;y=6"
			if ("kahlua")
				icon_state = "kahluaglass"
				name = "一杯强劲咖啡利口酒"
				desc = "见鬼，这玩意看起来够劲！"
				center_of_mass = "x=15;y=7"
			if("vermouth")
				icon_state = "vermouthglass"
				name = "一杯味美思"
				desc = "你不禁怀疑，自己为什么要直接喝这东西。"
				center_of_mass = "x=16;y=12"
			if("tequila")
				icon_state = "tequilaglass"
				name = "一杯龙舌兰酒"
				desc = "现在只差一副颜色古怪的墨镜了！"
				center_of_mass = "x=16;y=12"
			if("patron")
				icon_state = "patronglass"
				name = "一杯培恩龙舌兰酒"
				desc = "在酒吧喝着培恩龙舌兰，陪着那些平庸的女士。"
				center_of_mass = "x=7;y=8"
			if("rum")
				icon_state = "rumglass"
				name = "一杯朗姆酒"
				desc = "现在你想祈求一套海盗服了，是吧？"
				center_of_mass = "x=16;y=12"
			if("gintonic")
				icon_state = "gintonicglass"
				name = "金汤力"
				desc = "温和却依然出色的鸡尾酒。像个真正的英国人一样喝吧。"
				center_of_mass = "x=16;y=7"
			if("whiskeycola")
				icon_state = "whiskeycolaglass"
				name = "威士忌可乐"
				desc = "看起来人畜无害的可乐与威士忌混合酒。美味。"
				center_of_mass = "x=16;y=9"
			if("whiterussian")
				icon_state = "whiterussianglass"
				name = "白俄罗斯"
				desc = "一杯卖相很棒的酒。不过，老兄，那只是你的看法。"
				center_of_mass = "x=16;y=9"
			if("screwdrivercocktail")
				icon_state = "screwdriverglass"
				name = "螺丝刀"
				desc = "伏特加和橙汁的简单却绝妙的组合，正适合疲惫的工程师。"
				center_of_mass = "x=15;y=10"
			if("bloodymary")
				icon_state = "bloodymaryglass"
				name = "血腥玛丽"
				desc = "番茄汁混合伏特加，再加一点青柠。喝起来像液态谋杀。"
				center_of_mass = "x=16;y=10"
			if("martini")
				icon_state = "martiniglass"
				name = "经典马天尼"
				desc = "见鬼，调酒师居然是搅拌的，而不是摇匀的。"
				center_of_mass = "x=17;y=8"
			if("vodkamartini")
				icon_state = "martiniglass"
				name = "伏特加马天尼"
				desc ="经典马天尼的不正统变体，依然很棒。"
				center_of_mass = "x=17;y=8"
			if("gargleblaster")
				icon_state = "gargleblasterglass"
				name = "泛银河漱口爆破酒"
				desc = "这……难道意味着亚瑟和福特也在空间站上？真让人高兴。"
				center_of_mass = "x=17;y=6"
			if("bravebull")
				icon_state = "bravebullglass"
				name = "勇猛公牛"
				desc = "龙舌兰酒与咖啡利口酒交融，令人垂涎。喝吧。"
				center_of_mass = "x=15;y=8"
			if("tequilasunrise")
				icon_state = "tequilasunriseglass"
				name = "龙舌兰日出"
				desc = "哦，好极了，现在你开始怀念地球上的日出了……"
				center_of_mass = "x=16;y=10"
			if("phoronspecial")
				icon_state = "toxinsspecialglass"
				name = "毒素特调"
				desc = "哇，这玩意着火了！"
			if("doctorsdelight")
				icon_state = "doctorsdelightglass"
				name = "医生之乐"
				desc = "健康的果汁混合饮料，保证在你下次挨工具箱之前都能保持健康。"
				center_of_mass = "x=16;y=8"
			if("manlydorf")
				icon_state = "manlydorfglass"
				name = "硬汉矮人"
				desc = "艾尔啤酒和普通啤酒调制的硬汉饮品，专为真男人准备。"
				center_of_mass = "x=16;y=10"
			if("irishcream")
				icon_state = "irishcreamglass"
				name = "爱尔兰奶油酒"
				desc = "奶油混合威士忌。你还能指望爱尔兰人调出什么？"
				center_of_mass = "x=16;y=9"
			if("cubalibre")
				icon_state = "cubalibreglass"
				name = "自由古巴"
				desc = "朗姆酒和可乐的经典组合。"
				center_of_mass = "x=16;y=8"
			if("b52")
				icon_state = "b52glass"
				name = "B-52"
				desc = "甘露咖啡利口酒、爱尔兰奶油酒和干邑。你会被灌趴下。"
				center_of_mass = "x=16;y=10"
			if("atomicbomb")
				icon_state = "atomicbombglass"
				name = "原子弹"
				desc = "维兰德-汤谷不对你饮用后的行为承担法律责任。"
				center_of_mass = "x=15;y=7"
			if("longislandicedtea")
				icon_state = "longislandicedteaglass"
				name = "长岛冰茶"
				desc = "把酒柜里的酒汇成一杯美味佳酿，专为嗜酒的中年女士准备。"
				center_of_mass = "x=16;y=8"
			if("threemileisland")
				icon_state = "threemileislandglass"
				name = "三里岛冰茶"
				desc = "来一杯，保证不会发生堆芯熔毁。"
				center_of_mass = "x=16;y=2"
			if("margarita")
				icon_state = "margaritaglass"
				name = "玛格丽特"
				desc = "加冰，杯沿抹盐。干杯！"
				center_of_mass = "x=16;y=8"
			if("blackrussian")
				icon_state = "blackrussianglass"
				name = "黑俄罗斯"
				desc = "乳糖不耐受者的选择，和白俄罗斯一样高雅。"
				center_of_mass = "x=16;y=9"
			if("vodkatonic")
				icon_state = "vodkatonicglass"
				name = "伏特加汤力"
				desc = "适合觉得金汤力还不够俄罗斯的人。"
				center_of_mass = "x=16;y=7"
			if("manhattan")
				icon_state = "manhattanglass"
				name = "曼哈顿"
				desc = "侦探执行卧底任务时的首选饮品。他一直喝不惯金酒……"
				center_of_mass = "x=17;y=8"
			if("manhattan_proj")
				icon_state = "proj_manhattanglass"
				name = "曼哈顿计划"
				desc = "科学家思考如何炸掉空间站时的首选饮品。"
				center_of_mass = "x=17;y=8"
			if("ginfizz")
				icon_state = "ginfizzglass"
				name = "金菲士"
				desc = "清新的柠檬风味，爽口而干冽。"
				center_of_mass = "x=16;y=7"
			if("irishcoffee")
				icon_state = "irishcoffeeglass"
				name = "爱尔兰咖啡"
				desc = "咖啡与酒精。早晨喝起来比含羞草鸡尾酒更有意思。"
				center_of_mass = "x=15;y=10"
			if("hooch")
				icon_state = "glass_brown2"
				name = "劣质私酿酒"
				desc = "你真是堕落到底了……你的肝脏昨晚已经收拾行李走人了。"
				center_of_mass = "x=16;y=10"
			if("whiskeysoda")
				icon_state = "whiskeysodaglass2"
				name = "威士忌苏打"
				desc = "极致清爽。"
				center_of_mass = "x=16;y=9"
			if("tonic")
				icon_state = "glass_clear"
				name = "一杯汤力水"
				desc = "奎宁的味道很奇怪，但至少能防住太空疟疾。"
				center_of_mass = "x=16;y=10"
			if("sodawater")
				icon_state = "glass_clear"
				name = "一杯苏打水"
				desc = "苏打水。为什么不来杯苏格兰威士忌苏打？"
				center_of_mass = "x=16;y=10"
			if("water")
				icon_state = "glass_clear"
				name = "一杯水"
				desc = "所有清凉饮料的祖师爷。"
				center_of_mass = "x=16;y=10"
			if("spacemountainwind")
				icon_state = "Space_mountain_wind_glass"
				name = "一杯山风汽水"
				desc = "山风汽水。众所周知，太空里没有山，只有风。"
				center_of_mass = "x=16;y=10"
			if("thirteenloko")
				icon_state = "thirteen_loko_glass"
				name = "一杯十三狂饮"
				desc = "一杯十三狂饮，看起来品质上乘。说的是酒，不是杯子。"
				center_of_mass = "x=16;y=10"
			if("dr_gibb")
				icon_state = "dr_gibb_glass"
				name = "一杯吉布博士汽水"
				desc = "吉布博士汽水。没有名字听起来那么危险。"
				center_of_mass = "x=16;y=10"
			if("space_up")
				icon_state = "space-up_glass"
				name = "一杯太空七喜"
				desc = "太空七喜，让你保持清凉。"
				center_of_mass = "x=16;y=10"
			if("moonshine")
				icon_state = "glass_clear"
				name = "私酿烈酒"
				desc = "你真是堕落到底了……你的肝脏昨晚已经收拾行李走人了。"
				center_of_mass = "x=16;y=10"
			if("soymilk")
				icon_state = "glass_white"
				name = "一杯豆奶"
				desc = "洁白又营养的大豆精华！"
				center_of_mass = "x=16;y=10"
			if("berryjuice")
				icon_state = "berryjuice"
				name = "一杯混合莓果汁"
				desc = "混合莓果汁。也可能是果酱。谁在乎呢？"
				center_of_mass = "x=16;y=10"
			if("poisonberryjuice")
				icon_state = "poisonberryjuice"
				name = "一杯毒莓汁"
				desc = "一杯致命的果汁。"
				center_of_mass = "x=16;y=10"
			if("carrotjuice")
				icon_state = "carrotjuice"
				name = "一杯胡萝卜汁"
				desc = "就像胡萝卜，只是不用嚼。"
				center_of_mass = "x=16;y=10"
			if("banana")
				icon_state = "banana"
				name = "一杯香蕉汁"
				desc = "香蕉的原始精华。叭！"
				center_of_mass = "x=16;y=10"
			if("bahama_mama")
				icon_state = "bahama_mama"
				name = "巴哈马妈妈"
				desc = "热带鸡尾酒。"
				center_of_mass = "x=16;y=5"
			if("singulo")
				icon_state = "singulo"
				name = "奇点"
				desc = "一杯蓝空间饮品。"
				center_of_mass = "x=17;y=4"
			if("alliescocktail")
				icon_state = "alliescocktail"
				name = "盟友鸡尾酒"
				desc = "用你的盟友调制的饮品。"
				center_of_mass = "x=17;y=8"
			if("antifreeze")
				icon_state = "antifreeze"
				name = "防冻液"
				desc = "极致清爽。"
				center_of_mass = "x=16;y=8"
			if("barefoot")
				icon_state = "b&p"
				name = "赤足"
				desc = "赤着脚，还怀着孕。"
				center_of_mass = "x=17;y=8"
			if("demonsblood")
				icon_state = "demonsblood"
				name = "恶魔之血"
				desc = "光是看着这东西，你后颈的汗毛就竖起来了。"
				center_of_mass = "x=16;y=2"
			if("booger")
				icon_state = "booger"
				name = "鼻屎"
				desc = "呃……"
				center_of_mass = "x=16;y=10"
			if("snowwhite")
				icon_state = "snowwhite"
				name = "白雪公主"
				desc = "冰凉的饮品。"
				center_of_mass = "x=16;y=8"
			if("aloe")
				icon_state = "aloe"
				name = "芦荟"
				desc = "非常、非常、非常棒。"
				center_of_mass = "x=17;y=8"
			if("andalusia")
				icon_state = "andalusia"
				name = "安达卢西亚"
				desc = "名字奇怪的好饮品。"
				center_of_mass = "x=16;y=9"
			if("sbiten")
				icon_state = "sbitenglass"
				name = "斯比滕"
				desc = "伏特加与香料调制的辛辣饮品，火辣十足。"
				center_of_mass = "x=17;y=8"
			if("red_mead")
				icon_state = "red_meadglass"
				name = "红蜜酒"
				desc = "真正的维京饮品，虽然颜色有些奇怪。"
				center_of_mass = "x=17;y=10"
			if("mead")
				icon_state = "meadglass"
				name = "蜜酒"
				desc = "维京饮品，虽然是廉价货。"
				center_of_mass = "x=17;y=10"
			if("iced_beer")
				icon_state = "iced_beerglass"
				name = "冰镇啤酒"
				desc = "一杯冰冷到让周围空气都冻结的啤酒。"
				center_of_mass = "x=16;y=7"
			if("grog")
				icon_state = "grogglass"
				name = "格罗格"
				desc = "太空里的优质廉价饮品。"
				center_of_mass = "x=16;y=10"
			if("soy_latte")
				icon_state = "soy_latte"
				name = "豆奶拿铁"
				desc = "适合阅读时饮用的清爽饮品。"
				center_of_mass = "x=15;y=9"
			if("cafe_latte")
				icon_state = "cafe_latte"
				name = "咖啡拿铁"
				desc = "适合阅读时饮用的浓郁清爽饮品。"
				center_of_mass = "x=15;y=9"
			if("acidspit")
				icon_state = "acidspitglass"
				name = "酸液喷吐"
				desc = "维兰德-汤谷出品，用活异形制成。"
				center_of_mass = "x=16;y=7"
			if("amasec")
				icon_state = "amasecglass"
				name = "阿玛赛克"
				desc = "战斗前总能派上用场！"
				center_of_mass = "x=16;y=9"
			if("neurotoxin")
				icon_state = "neurotoxinglass"
				name = "神经毒素"
				desc = "保证把你灌得神志不清。"
				center_of_mass = "x=16;y=8"
			if("hippiesdelight")
				icon_state = "hippiesdelightglass"
				name = "嬉皮士之乐"
				desc = "二十世纪六十年代嬉皮士喜爱的饮品。"
				center_of_mass = "x=16;y=8"
			if("bananahonk")
				icon_state = "bananahonkglass"
				name = "香蕉喇叭"
				desc = "来自香蕉天堂的饮品。"
				center_of_mass = "x=16;y=8"
			if("silencer")
				icon_state = "silencerglass"
				name = "消音器"
				desc = "来自默剧演员天堂的饮品。"
				center_of_mass = "x=16;y=9"
			if("nothing")
				icon_state = "nothing"
				name = "虚无"
				desc = "绝对的虚无。"
				center_of_mass = "x=16;y=10"
			if("devilskiss")
				icon_state = "devilskiss"
				name = "魔鬼之吻"
				desc = "恐怖时刻！"
				center_of_mass = "x=16;y=8"
			if("changelingsting")
				icon_state = "changelingsting"
				name = "变形怪之刺"
				desc = "一杯刺人的酒。"
				center_of_mass = "x=16;y=10"
			if("irishcarbomb")
				icon_state = "irishcarbomb"
				name = "爱尔兰汽车炸弹"
				desc = "一杯爱尔兰汽车炸弹。"
				center_of_mass = "x=16;y=8"
			if("syndicatebomb")
				icon_state = "syndicatebomb"
				name = "辛迪加炸弹"
				desc = "一杯辛迪加炸弹。"
				center_of_mass = "x=16;y=4"
			if("erikasurprise")
				icon_state = "erikasurprise"
				name = "艾丽卡惊喜"
				desc = "惊喜在于，它是绿色的！"
				center_of_mass = "x=16;y=9"
			if("driestmartini")
				icon_state = "driestmartiniglass"
				name = "极干马天尼"
				desc = "仅适合老手。你仿佛看见杯中漂着沙子。"
				center_of_mass = "x=17;y=8"
			if("ice")
				icon_state = "iceglass"
				name = "一杯冰块"
				desc = "通常来说，你还应该往里面加点别的东西……"
				center_of_mass = "x=16;y=10"
			if("icecoffee")
				icon_state = "icedcoffeeglass"
				name = "冰咖啡"
				desc = "让你精神振奋、清爽舒畅的饮品！"
				center_of_mass = "x=16;y=10"
			if("coffee")
				icon_state = "glass_brown"
				name = "一杯咖啡"
				desc = "别摔了，否则滚烫的液体和玻璃碎片会溅得到处都是。"
				center_of_mass = "x=16;y=10"
			if("bilk")
				icon_state = "glass_brown"
				name = "一杯奶啤"
				desc = "牛奶和啤酒的混合物，适合担心骨质疏松的酒鬼。"
				center_of_mass = "x=16;y=10"
			if("fuel")
				icon_state = "dr_gibb_glass"
				name = "一杯焊接燃料"
				desc = "除非你是工业工具，否则这东西恐怕不适合饮用。"
				center_of_mass = "x=16;y=10"
			if("brownstar")
				icon_state = "brownstar"
				name = "棕星"
				desc = "并不是你想的那个意思……"
				center_of_mass = "x=16;y=10"
			if("grapejuice")
				icon_state = "grapejuice"
				name = "一杯葡萄汁"
				desc = "葡萄味，好极了！"
				center_of_mass = "x=16;y=10"
			if("grapesoda")
				icon_state = "grapesoda"
				name = "一罐葡萄汽水"
				desc = "看起来是很美味的饮料！"
				center_of_mass = "x=16;y=10"
			if("icetea")
				icon_state = "icedteaglass"
				name = "冰茶"
				desc = "与某位说唱歌手兼演员没有关系。"
				center_of_mass = "x=15;y=10"
			if("grenadine")
				icon_state = "grenadineglass"
				name = "一杯红石榴糖浆"
				desc = "酸甜的酒吧用糖浆，可为饮品增添色彩或风味。"
				center_of_mass = "x=17;y=6"
			if("milkshake")
				icon_state = "milkshake"
				name = "奶昔"
				desc = "令人赞叹、冰得脑仁疼的混合饮品。"
				center_of_mass = "x=16;y=7"
			if("lemonade")
				icon_state = "lemonadeglass"
				name = "柠檬水"
				desc = "真让人怀念……"
				center_of_mass = "x=16;y=10"
			if("kiraspecial")
				icon_state = "kiraspecial"
				name = "基拉特调"
				desc = "愿那个总被误认成女孩的家伙万岁。笨蛋！"
				center_of_mass = "x=16;y=12"
			if("rewriter")
				icon_state = "rewriter"
				name = "改写者"
				desc = "图书馆员圣所的秘密……"
				center_of_mass = "x=16;y=9"
			if("suidream")
				icon_state = "sdreamglass"
				name = "翠梦"
				desc = "花哨、香甜且果香浓郁的混合饮品。懂这个名字的人只会感到羞耻。"
				center_of_mass = "x=16;y=5"
			if("melonliquor")
				icon_state = "emeraldglass"
				name = "一杯蜜瓜利口酒"
				desc = "甜味较重、果香浓郁的二十三度利口酒。"
				center_of_mass = "x=16;y=5"
			if("bluecuracao")
				icon_state = "curacaoglass"
				name = "一杯蓝橙酒"
				desc = "从橙子蒸馏而成的蓝色果味饮品，颇有异国情调。"
				center_of_mass = "x=16;y=5"
			if("absinthe")
				icon_state = "absintheglass"
				name = "一杯苦艾酒"
				desc = "苦艾、茴香，天哪。"
				center_of_mass = "x=16;y=5"
			if("pwine")
				icon_state = "pwineglass"
				name = "一杯不明液体"
				desc = "黑色的浓液表面泛着油亮的紫光。你确定该喝它吗？"
				center_of_mass = "x=16;y=5"
			if("eggnog")
				icon_state = "glass_white"
				name = "一杯蛋奶饮"
				desc = "浓郁的无酒精乳制饮品，传统上在圣诞节前后饮用。"
				center_of_mass = "x=16;y=10"
			if("spikedeggnog")
				icon_state = "goldschlagerglass"
				name = "一杯加酒蛋奶饮"
				desc = "光是看着它，就会想起拥抱、家人和拆礼物的时光。"
				center_of_mass = "x=16;y=5"
			if("mojito")
				icon_state = "mojitoglass"
				name = "一杯莫吉托"
				desc = "古巴经典，永远不会让你失望。"
				center_of_mass = "x=16;y=5"
			else
				//a common drinking reagent that makes more than half of the total volume
				if(istype(R, /datum/reagent/drink) && R.volume >= 0.5*reagents.total_volume)
					icon_state ="glass_brown"
					if(R.volume >= 0.75*reagents.total_volume)
						name = "一杯[R.name]"
					else
						name = "一杯……[R.name]？"
						desc = "看起来主要是[R.name]混着别的东西。"
					center_of_mass = "x=16;y=10"
				else
					icon_state ="glass_brown"
					name = "一杯……什么？"
					desc = "你实在分辨不出这是什么。"
					center_of_mass = "x=16;y=10"
	else
		icon_state = "glass_empty"
		name = "玻璃杯"
		desc = "普通的饮用玻璃杯。"
		center_of_mass = "x=16;y=10"
		return

/obj/item/reagent_container/food/drinks/drinkingglass/attack(mob/living/target as mob, mob/living/user as mob)
	if(!target)
		return

	if(user.a_intent != INTENT_HARM)
		return ..()

	force = 15

	var/obj/limb/affecting = user.zone_selected
	var/drowsy_threshold = 0

	drowsy_threshold = CLOTHING_ARMOR_MEDIUM - target.getarmor(affecting, ARMOR_MELEE)

	target.apply_damage(force, BRUTE, affecting, sharp=0)

	if(affecting == "head" && iscarbon(target) && !isxeno(target))
		for(var/mob/O in viewers(user, null))
			if(target != user)
				O.show_message(text(SPAN_DANGER("<B>[user]用一杯[name]砸中了[target]的头！</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[target]用一杯[name]砸中了自己的头！</B>")), SHOW_MESSAGE_VISIBLE)
		if(drowsy_threshold > 0)
			target.apply_effect(min(drowsy_threshold, 10) , DROWSY)

	else //Regular attack text
		for(var/mob/O in viewers(user, null))
			if(target != user)
				O.show_message(text(SPAN_DANGER("<B>[user]用一杯[name]攻击了[target]！</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[target]用一杯[name]攻击了自己！</B>")), SHOW_MESSAGE_VISIBLE)

	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has attacked [target.name] ([target.ckey]) with a glass!</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed with a glass by [user.name] ([user.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) attacked [target.name] ([target.ckey]) with a glass (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	if(reagents)
		for(var/mob/O in viewers(user, null))
			O.show_message(text(SPAN_NOTICE("<B>[src]里的液体泼了[target]一身！</B>")), SHOW_MESSAGE_VISIBLE)
		reagents.reaction(target, TOUCH)

	smash(target, user)

	return

/obj/item/reagent_container/food/drinks/drinkingglass/bullet_act(obj/projectile/P)
	. = ..()
	smash()

/obj/item/reagent_container/food/drinks/drinkingglass/proc/smash(mob/living/target, mob/living/user)
	var/obj/item/weapon/broken_glass/B
	if(user)
		user.temp_drop_inv_item(src)
		B = new /obj/item/weapon/broken_glass(user.loc)
		user.put_in_active_hand(B)
	else
		B = new /obj/item/weapon/broken_glass(src.loc)
	if(prob(33))
		if(target)
			new/obj/item/shard(target.loc) // Create a glass shard at the target's location!
		else
			new/obj/item/shard(src.loc)

	playsound(src, "shatter", 25, 1)
	transfer_fingerprints_to(B)

	qdel(src)

// for /obj/structure/machinery/vending/sovietsoda
/obj/item/reagent_container/food/drinks/drinkingglass/soda
	name = "汽水杯"
	desc = "用于盛放汽水的玻璃杯。"

/obj/item/reagent_container/food/drinks/drinkingglass/soda/Initialize()
	. = ..()
	reagents.add_reagent("sodawater", 50)
	on_reagent_change()

/obj/item/reagent_container/food/drinks/drinkingglass/cola
	name = "可乐杯"
	desc = "用于盛放可乐的玻璃杯。"

/obj/item/reagent_container/food/drinks/drinkingglass/cola/Initialize()
	. = ..()
	reagents.add_reagent("cola", 50)
	on_reagent_change()
