//USCM

/obj/item/mre_food_packet/uscm
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/uscm
	name = "\improper MRE即食军粮主菜"
	desc = "即食军粮的主菜，提供主要的营养。"
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	icon_state = "entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pizzasquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pepperonisquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chiliconcarne,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/noodlesoup,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/feijoada,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs
	name = "去骨猪肋排"
	icon_state = "boneless pork ribs"
	desc = "调料放得这么多，你甚至尝不出加工肉的味道！"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 4)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken
	name = "烤鸡"
	icon_state = "grilled chicken"
	desc = "吃起来其实不像烤的，但在这里还指望什么奢侈享受呢？"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pizzasquare
	name = "方形披萨"
	icon_state = "pizza square"
	desc = "美式经典，至今大概已经在菜单上增删了27次。虽然只是正宗披萨的廉价仿品，依然广受喜爱。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pizzasquare/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("meatprotein", 3)
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("vegetable", 2)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pepperonisquare
	name = "意式辣香肠方形披萨"
	icon_state = "pepperoni square"
	desc = "即食军粮经典菜式的新版本，吃起来差不太多。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pepperonisquare/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)
	reagents.add_reagent("meatprotein", 5)
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender
	name = "鸡柳"
	icon_state = "chicken tender"
	desc = "非常美味，面包糠的口感也不错，但还是让你想吃几只好鸡翅……"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast
	name = "烤鸡胸"
	icon_state = "grilled chicken breast"
	desc = "非常朴素的烤鸡肉，简单却经典。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks
	name = "肉酱意面"
	icon_state = "spaghetti chunks"
	desc = "拌有熟肉块的意大利面，全部裹着番茄酱。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 8)
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chiliconcarne
	name = "辣味炖肉"
	icon_state = "chili con carne"
	desc = "辛辣的肉末菜式，辣椒仿佛不要钱，建议在手边备点牛奶。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chiliconcarne/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("hotsauce", 6)
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/noodlesoup
	name = "面条汤"
	icon_state = "noodle soup"
	desc = "营养丰富的鸡味蔬菜面条汤，加热后能让你暖和好一阵。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/noodlesoup/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 9)
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("meatprotein", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/feijoada
	name = "巴西黑豆炖肉"
	icon_state = "brazilian-style feijoada"
	desc = "巴西菜式，内有黑豆、各式肉类、蔬菜和香料，营养丰富，风味浓郁。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/feijoada/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 7)
	reagents.add_reagent("meatprotein", 5)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("plantmatter", 2)

///SIDE

/obj/item/mre_food_packet/uscm/side
	name = "\improper MRE即食军粮配菜"
	desc = "即食军粮的配餐部分，内含搭配主菜食用的配菜。"
	icon_state = "side"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/mashedpotatoes,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cornbread,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/kale,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/tortillas,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cinnamonappleslices,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/boiledrice,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/biscuits,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker
	name = "薄脆饼干"
	icon_state = "cracker"
	desc = "很容易掉渣，但掉渣正是最过瘾的部分。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/mashedpotatoes
	name = "土豆泥"
	icon_state = "mashed potatoes"
	desc = "口感非常细腻柔软，适合搭配主菜。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/mashedpotatoes/Initialize()
	. = ..()
	reagents.add_reagent("potato", 6)
	reagents.add_reagent("vegetable", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto
	name = "意式烩饭"
	icon_state = "risotto"
	desc = "稍显异国风味，但意大利菜从不令人失望。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("rice", 4)
	reagents.add_reagent("cornoil", 1)
	reagents.add_reagent("vegetable", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri
	name = "三角饭团"
	icon_state = "rice onigiri"
	desc = "熟米饭捏成三角形，底部包着海苔，居然没有散开。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri/Initialize()
	. = ..()
	reagents.add_reagent("rice", 5)
	reagents.add_reagent("plantmatter", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cornbread
	name = "玉米面包"
	icon_state = "cornbread"
	desc = "几乎人人嫌弃，又干又寡淡，很快就吃腻了。军需处后面大概还囤着一大堆，根本没人吃这破玩意儿。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cornbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("cornoil", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/kale
	name = "腌羽衣甘蓝"
	icon_state = "kale"
	desc = "用香料腌制的一种甘蓝，依然多汁爽脆。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/kale/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 6)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/tortillas
	name = "墨西哥薄饼"
	icon_state = "tortillas"
	desc = "一种扁平面饼，适合搭配其他食物。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/tortillas/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/biscuits
	name = "美式松饼"
	icon_state = "biscuits"
	desc = "各式松饼，适合搭配其他食物。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/biscuits/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)


/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cinnamonappleslices
	name = "肉桂苹果片"
	icon_state = "cinnamon apple slices"
	desc = "浸在肉桂酱中的软糯苹果块，有些黏，但很好吃。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cinnamonappleslices/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 3)
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/boiledrice
	name = "白米饭"
	icon_state = "rice"
	desc = "一包普通的熟米饭，虽然有些乏味，配点东西就不错了。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/boiledrice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 6)

///SNACK

/obj/item/mre_food_packet/uscm/snack
	name = "\improper MRE即食军粮零食"
	desc = "即食军粮中的轻食零食，适合不太饿的时候吃。"
	icon_state = "snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/biscuit,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/meatballs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/sushi,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/biscuit
	name = "杂粮饼干"
	icon_state = "biscuit"
	desc = "像是薄脆饼干，但多种谷物带来了更独特的口感和风味。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/biscuit/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/meatballs
	name = "肉丸"
	icon_state = "meatballs"
	desc = "虽然是煮熟的肉末，你甚至还能尝到肌肉纤维。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/meatballs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels
	name = "椒盐脆饼"
	icon_state = "pretzels"
	desc = "又咸又脆，让人口渴。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/sushi
	name = "寿司"
	icon_state = "sushi"
	desc = "你实在怀疑生鱼在这里能不能保持新鲜。闻起来几乎没有鱼味……这真的是鱼吗……"

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/sushi/Initialize()
	. = ..()
	reagents.add_reagent("fish", 2)
	reagents.add_reagent("plantmatter", 2)
	reagents.add_reagent("soysauce", 2)
	reagents.add_reagent("soymilk", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts
	name = "花生"
	icon_state = "peanuts"
	desc = "酥脆的咸花生，很容易吃上瘾。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts/Initialize()
	. = ..()
	reagents.add_reagent("nuts", 4)
	reagents.add_reagent("sodiumchloride", 1)

///DESSERT

/obj/item/mre_food_packet/uscm/dessert
	name = "\improper MRE即食军粮甜点"
	desc = "即食军粮的配餐部分，内含餐后甜点；如果你够叛逆，也可以餐前吃。"
	icon_state = "dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/spicedapples,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/chocolatebrownie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/sugarcookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/cocobar,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/flan,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/honeyflan,
		/obj/item/reagent_container/food/snacks/cookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/lemonpie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/limepie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/brigadeiro,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/strawberrytoaster,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/spicedapples
	name = "香料苹果"
	icon_state = "spiced apples"
	desc = "有些干的肉桂苹果块，令人垂涎欲滴，依然好吃。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/spicedapples/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 2)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/chocolatebrownie
	name = "巧克力布朗尼"
	icon_state = "chocolate brownie"
	desc = "可可蛋糕底上覆着巧克力糖霜，巧克力风味浓郁。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/chocolatebrownie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("coco", 2)
	reagents.add_reagent("sprinkles", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/sugarcookie
	name = "糖霜饼干"
	icon_state = "sugar cookie"
	desc = "覆着焦糖糖霜的烤饼干。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/sugarcookie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("bread", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/cocobar
	name = "可可巧克力条"
	icon_state = "coco bar"
	desc = "经典的牛奶巧克力条，适合搭配热饮。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/cocobar/Initialize()
	. = ..()
	reagents.add_reagent("coco", 5)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/flan
	name = "奶香蛋糕派"
	icon_state = "flan"
	desc = "松软的奶香海绵蛋糕派。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/flan/Initialize()
	. = ..()
	reagents.add_reagent("milk", 1)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("egg", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/honeyflan
	name = "蜂蜜奶香蛋糕派"
	icon_state = "honey flan"
	desc = "淋有蜂蜜的松软奶香海绵蛋糕派。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/honeyflan/Initialize()
	. = ..()
	reagents.add_reagent("honey", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("egg", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/lemonpie
	name = "柠檬派"
	icon_state = "lemon pie"
	desc = "奶油派，内有奶香柠檬馅，外皮厚实。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/lemonpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("lemonjuice", 5)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/limepie
	name = "青柠派"
	icon_state = "key lime pie"
	desc = "奶油派，内有奶香青柠馅，外皮厚实。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/limepie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("limejuice", 5)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/brigadeiro
	name = "巴西巧克力软糖球"
	icon_state = "brigadeiro balls"
	desc = "巴西传统甜点，由炼乳、可可和黄油制成，口感非常柔软香甜。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/brigadeiro/Initialize()
	. = ..()
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 3)
	reagents.add_reagent("coco", 4)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/strawberrytoaster
	name = "草莓烤馅饼"
	icon_state = "strawberry toaster pastry"
	desc = "外皮酥脆的饼干糕点，内有草莓酱，顶部覆着糖霜。"

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/strawberrytoaster/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("berryjuice", 3)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sprinkles", 2)
	reagents.add_reagent("egg", 1)

///SPREAD

/obj/item/reagent_container/food/drinks/cans/spread
	name = "抹酱包（奶酪）"
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	icon_state = "spread"
	desc = "用加工奶酪制成的绵密抹酱，奶酪风味浓郁，适合搭配墨西哥薄饼等零食。"
	open_sound = "rip"
	open_message = "你撕开了抹酱的包装！"
	volume = 6
	var/flavor = "cheese spread"
	food_interactable = TRUE
	possible_transfer_amounts = list(1, 2, 3, 5)
	crushable = FALSE
	gulp_size = 5
	object_fluff = "包装袋"

/obj/item/reagent_container/food/drinks/cans/spread/update_icon()
	overlays.Cut()
	if(open)
		icon_state = "[initial(icon_state)]_open"
		if(reagents.total_volume)
			overlays += mutable_appearance(icon, flavor)

/obj/item/reagent_container/food/drinks/cans/spread/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/reagent_container/food/drinks/cans/spread/cheese/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/spread/jalapeno
	name = "抹酱包（墨西哥辣椒奶酪）"
	desc = "用加工奶酪制成的绵密抹酱，带有墨西哥辣椒的辛辣风味，适合搭配墨西哥薄饼等零食。"
	flavor = "jalapeno cheese spread"

/obj/item/reagent_container/food/drinks/cans/spread/jalapeno/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("capsaicin", 2)

/obj/item/reagent_container/food/drinks/cans/spread/peanut_butter
	name = "抹酱包（花生酱）"
	desc = "用加工花生制成的绵密抹酱，带有坚果香，适合搭配墨西哥薄饼等零食。"
	flavor = "peanut butter"

/obj/item/reagent_container/food/drinks/cans/spread/peanut_butter/Initialize()
	. = ..()
	reagents.add_reagent("nuts", 4)
	reagents.add_reagent("sodiumchloride", 2)

///BEVERAGE DRINKS

/obj/item/reagent_container/food/drinks/beverage_drink
	name = "饮料粉包"
	desc = "一包兑水即可冲成野外饮品的饮料粉。"
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	icon_state = "beverage"
	volume = 20

/obj/item/reagent_container/food/drinks/beverage_drink/grape
	name = "电解质饮料粉包（葡萄）"
	desc = "一包兑水即可冲成野外饮品的电解质饮料粉，带有葡萄风味。"

/obj/item/reagent_container/food/drinks/beverage_drink/grape/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_grape_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/orange
	name = "电解质饮料粉包（橙子）"
	desc = "一包兑水即可冲成野外饮品的电解质饮料粉，带有清新的橙子风味。"

/obj/item/reagent_container/food/drinks/beverage_drink/orange/Initialize()
	. = ..()
	reagents.add_reagent("electrolyte_orange_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/lemonlime
	name = "电解质饮料粉包（柠檬青柠）"
	desc = "一包兑水即可冲成野外饮品的电解质饮料粉，带有清新的柠檬青柠风味。"

/obj/item/reagent_container/food/drinks/beverage_drink/lemonlime/Initialize()
	. = ..()
	reagents.add_reagent("electrolyte_lemonlime_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate
	name = "蛋白饮料粉包（牛奶巧克力）"
	desc = "一包兑水即可冲成野外饮品的蛋白饮料粉，带有巧克力风味。"

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate/Initialize()
	. = ..()
	reagents.add_reagent("chocolate_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate_hazelnut
	name = "蛋白饮料粉包（巧克力榛子）"
	desc = "一包兑水即可冲成野外饮品的蛋白饮料粉，带有巧克力榛子风味。"

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate_hazelnut/Initialize()
	. = ..()
	reagents.add_reagent("hazelnut_beverage", 4)
