

//*****************************************************************************************************/
//****************************************Food Reagents************************************************/
//*****************************************************************************************************/
// Part of the food code. Nutriment is used instead of the old "heal_amt" code. Also is where all the food
// condiments, additives, and such go.

/datum/reagent/nutriment
	name = "Nutriment"
	localized_name = "营养物质"
	id = "nutriment"
	description = "以纯净形式提供身体所需的全部维生素、矿物质和碳水化合物。"
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_NEOGENETIC = 1, PROPERTY_NUTRITIOUS = 2, PROPERTY_HEMOGENIC = 1)
	flags = REAGENT_SCANNABLE

/datum/reagent/nutriment/egg
	name = "Egg"
	localized_name = "蛋液"
	id = "egg"
	description = "鸡蛋里的东西，不含沙门氏菌。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/tofu
	name = "Tofu"
	localized_name = "豆腐"
	id = "tofu"
	description = "肉类替代品。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/cheese
	name = "Cheese"
	localized_name = "奶酪"
	id = "cheese"
	description = "这东西以前是牛奶。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/meat
	name = "Meat Protein"
	localized_name = "肉类蛋白质"
	id = "meatprotein"
	description = "存在于各种肉类中的蛋白质。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/meat/fish
	name = "Fish Meat"
	localized_name = "鱼肉"
	id = "fish"
	description = "这东西以前会游泳。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/grown
	name = "Plant Matter"
	localized_name = "植物质"
	id = "plantmatter"
	description = "某种植物。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/grown/vegetable
	name = "Vegetables"
	localized_name = "蔬菜"
	id = "vegetable"
	description = "某种蔬菜。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/grown/fruit
	name = "Fruit"
	localized_name = "水果"
	id = "fruit"
	description = "某种水果。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/grown/mushroom
	name = "Mushroom"
	localized_name = "蘑菇"
	id = "mushroom"
	description = "某种真菌。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/dough
	name = "Dough"
	localized_name = "面团"
	id = "dough"
	description = "湿面粉。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/dough/bread
	name = "Bread"
	localized_name = "面包"
	id = "bread"
	description = "烤熟的面包。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/dough/noodles
	name = "Noodles"
	localized_name = "面条"
	id = "noodles"
	description = "煮熟的面条。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/nuts
	name = "Nuts"
	localized_name = "坚果碎"
	id = "nuts"
	description = "某种磨碎的坚果，闻起来像杏仁。"
	flags = REAGENT_NO_GENERATION

/datum/reagent/lipozine
	name = "Lipozine" // The anti-nutriment.
	localized_name = "燃脂嗪"
	id = "lipozine"
	description = "通过增强酮体生成、加快脂肪代谢来降低饱腹感并减轻体重，用于治疗肥胖。大剂量可能导致体重极度下降。"
	reagent_state = LIQUID
	nutriment_factor = 10 * REAGENTS_METABOLISM
	color = "#BBEDA4" // rgb: 187, 237, 164
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_KETOGENIC = 4)

/datum/reagent/soysauce
	name = "Soysauce"
	localized_name = "酱油"
	id = "soysauce"
	description = "用大豆制成的咸味调味汁。"
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300" // rgb: 121, 35, 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/ketchup
	name = "Ketchup"
	localized_name = "番茄沙司"
	id = "ketchup"
	description = "一种酸甜酱汁，通常由番茄、糖、醋及各种调味料和香料制成。"
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#731008" // rgb: 115, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/vegemite
	name = "Vegemite"
	localized_name = "维吉麦酵母酱"
	id = "vegemite"
	description = "浓稠的酵母提取物涂抹酱，咸而微苦，带麦芽香和类似牛肉清汤的鲜味，还有一丝辐射味。"
	reagent_state = LIQUID
	nutriment_factor = 7 * REAGENTS_METABOLISM
	color = "#312007" // rgb: 115, 16, 8
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_NUTRITIOUS = 3)
	flags = REAGENT_NO_GENERATION

/datum/reagent/vegemite/reaction_mob(mob/target_mob, method=TOUCH, volume, permeable)
	if(target_mob.faction != FACTION_TWE)
		to_chat(target_mob, (SPAN_ALERTWARNING("天啊……真恶心……吃这东西可不是个好主意。")))

/datum/reagent/vegemite/on_mob_life(mob/living/carbon/target_mob, potency = 1, delta_time)
	. = ..()
	if(!.)
		return
	if(prob(4) && ishuman(target_mob) && target_mob.faction != FACTION_TWE)
		var/mob/living/carbon/human/target_human = target_mob
		target_mob.make_dizzy(10)
		target_human.vomit()

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	localized_name = "辣椒素油"
	id = "capsaicin"
	description = "辣椒素是具有镇痛作用的辣椒提取物，能选择性地促进初级感觉外周神经元释放神经肽。"
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPERTHERMIC = 1)

/datum/reagent/condensedcapsaicin
	name = "Condensed Capsaicin"
	localized_name = "浓缩辣椒素"
	id = "condensedcapsaicin"
	description = "用于自卫和警务的化学制剂。"
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPERTHERMIC = 4)
	spray_warning = TRUE

/datum/reagent/hotsauce
	name = "Hot Sauce"
	localized_name = "辣椒酱"
	id = "hotsauce"
	description = "用辣椒制成的辛辣调味酱。"
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPERTHERMIC = 1)

/datum/reagent/condensedcapsaicin/reaction_mob(mob/living/M, method=TOUCH, volume, permeable)
	if(!istype(M, /mob/living) || has_species(M,"Horror"))
		return

	if(method == TOUCH)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/victim = M
			if(skillcheck(victim, SKILL_POLICE, SKILL_POLICE_SKILLED))
				victim.AdjustEyeBlur(5)
				to_chat(victim, SPAN_WARNING("你受过的训练减轻了辣椒喷雾的影响！"))
				return

			if(victim.pain.feels_pain)
				victim.emote("scream")
				to_chat(victim, SPAN_WARNING("辣椒喷雾直接喷进了你的眼睛！"))
				victim.AdjustEyeBlur(25)
				victim.AdjustEyeBlind(10)
				victim.apply_effect(3, STUN)
				victim.apply_effect(3, WEAKEN)

/datum/reagent/frostoil
	name = "Frost Oil"
	localized_name = "寒霜油"
	id = "frostoil"
	description = "从冰椒中提取的特殊油脂，能使身体明显降温。"
	reagent_state = LIQUID
	color = "#B31008" // rgb: 139, 166, 233
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPOTHERMIC = 6)

/datum/reagent/sodiumchloride
	name = "Table Salt"
	localized_name = "食盐"
	id = "sodiumchloride"
	description = "由氯化钠构成的盐，常用于食物调味。"
	reagent_state = SOLID
	color = COLOR_WHITE
	chemfiresupp = TRUE
	intensitymod = 0.1
	burncolor = "#ffff00"
	burncolormod = 2
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON

/datum/reagent/blackpepper
	name = "Black Pepper"
	localized_name = "黑胡椒"
	id = "blackpepper"
	description = "世界上贸易量最大的香料，也是各地菜肴中最常见的香料之一。辣味来自胡椒碱，与辣椒素产生的辣味有所不同。"
	reagent_state = SOLID
	chemclass = CHEM_CLASS_RARE
	// no color (ie, black)

/datum/reagent/coco
	name = "Coco Powder"
	localized_name = "可可粉"
	id = "coco"
	description = "可可豆是可可树的种子，经充分发酵并干燥后，可从中提取可可固形物和可可脂。"
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/coco_drink_hazelnut
	name = "Chocolate Hazelnut Drink"
	localized_name = "榛子巧克力饮"
	id = "coco_drink_hazelnut"
	description = "丝滑浓醇的巧克力饮料，带有淡淡的榛子风味。"
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#865e2a" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/coco_drink
	name = "Chocolate Drink"
	localized_name = "巧克力饮"
	id = "coco_drink"
	description = "丝滑浓醇的巧克力饮料。"
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#61450e" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/vanilla
	name = "Vanilla Powder"
	localized_name = "香草粉"
	id = "vanilla"
	description = "从香草荚中提取的香草，如今成了粉末。"
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#ffecc6"
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/strawberry
	name = "Strawberry Powder"
	localized_name = "草莓粉"
	id = "strawberrypowder"
	description = "草莓经速冻后磨成的粉末。大概吧。"
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#fc0065"
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/psilocybin
	name = "Psilocybin"
	localized_name = "裸盖菇素"
	id = "psilocybin"
	description = "一种天然致幻前体化合物，由两百多种蘑菇产生。这些蘑菇统称为裸盖菇素蘑菇或魔幻蘑菇。"
	color = "#E700E7" // rgb: 231, 0, 231
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HALLUCINOGENIC = 3)

/datum/reagent/sprinkles
	name = "Sprinkles"
	localized_name = "彩糖粒"
	id = "sprinkles"
	description = "多彩的小糖粒，常撒在甜甜圈上，警察们的最爱。"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = COLOR_MAGENTA
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/cornoil
	name = "Corn Oil"
	localized_name = "玉米油"
	id = "cornoil"
	description = "从各种玉米中提取的油。"
	reagent_state = LIQUID
	nutriment_factor = 20 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/enzyme
	name = "Universal Enzyme"
	localized_name = "通用酶"
	id = "enzyme"
	description = "用于制备某些化学品和食物的通用酶。"
	reagent_state = LIQUID
	color = "#365E30" // rgb: 54, 94, 48
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_UNKNOWN = 2)

/datum/reagent/dry_ramen
	name = "Dry Ramen"
	localized_name = "干方便面"
	id = "dry_ramen"
	description = "自 1958 年 8 月 25 日起供应的太空时代食品。含干面条、蔬菜，以及遇水便会沸腾的化学物质。"
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/hot_ramen
	name = "Hot Ramen"
	localized_name = "热方便面"
	id = "hot_ramen"
	description = "煮熟的面条，人工调出的味道，仿佛又回到了学生时代。"
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	properties = list(PROPERTY_NUTRITIOUS = 2, PROPERTY_HYPERTHERMIC = 1)
	flags = REAGENT_NO_GENERATION

/datum/reagent/hell_ramen
	name = "Hell Ramen"
	localized_name = "地狱方便面"
	id = "hell_ramen"
	description = "煮熟的面条，人工调出的味道，仿佛又回到了学生时代。"
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	properties = list(PROPERTY_NUTRITIOUS = 2, PROPERTY_HYPERTHERMIC = 4)
	flags = REAGENT_NO_GENERATION

/datum/reagent/rice
	name = "Rice"
	localized_name = "大米"
	id = "rice"
	description = "地球上食用最广泛的主食。就人类的营养与热量摄入而言，大米是最重要的谷物。"
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = COLOR_WHITE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/buckwheat
	name = "Buckwheat"
	localized_name = "荞麦"
	id = "buckwheat"
	description = "用荞麦制成的谷物粥。"
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = COLOR_BROWN
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/cherryjelly
	name = "Cherry Jelly"
	localized_name = "樱桃果冻"
	id = "cherryjelly"
	description = "用樱桃制成的甜果冻。"
	reagent_state = LIQUID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#801E28" // rgb: 128, 30, 40
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/strawberryjam
	name = "Strawberry Jam"
	localized_name = "草莓果酱"
	id = "strawberryjam"
	description = "用草莓制成的甜果酱。"
	reagent_state = LIQUID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#801E28" // rgb: 128, 30, 40
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/honey
	name = "Honey"
	localized_name = "蜂蜜"
	id = "honey"
	description = "天然的甜味黏稠食物，主要由果糖和葡萄糖构成。"
	color = COLOR_YELLOW
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/dehydrated_juice
	name = "Mystery Juice Powder"
	localized_name = "神秘果汁粉"
	id = "dehydrated_juice"
	description = "等待兑水冲调的果汁粉，闻起来有人工香蕉香精的味道。"
	reagent_state = SOLID
	color = "#863333" // rgb: 175, 175, 0
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/dehydrated_orange_juice
	name = "Orange Juice Powder"
	localized_name = "橙汁粉"
	id = "dehydrated_orange_juice"
	description = "等待兑水冲调的橙汁粉。闻起来是——真意外啊——橙子味。"
	reagent_state = SOLID
	color = "#E78108" // rgb: 231, 129, 8
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/dehydrated_apple_juice
	name = "Apple Juice Powder"
	localized_name = "苹果汁粉"
	id = "dehydrated_apple_juice"
	description = "等待兑水冲调的苹果汁粉。闻起来是——真意外啊——苹果味。"
	reagent_state = SOLID
	color = "#365E30" // rgb: 54, 94, 48
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/dehydrated_watermelon_juice
	name = "Watermelon Juice Powder"
	localized_name = "西瓜汁粉"
	id = "dehydrated_watermelon_juice"
	description = "等待兑水冲调的西瓜汁粉。闻起来是——真意外啊——西瓜味。"
	reagent_state = SOLID
	color = "#863333" // rgb: 134, 51, 51
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/dehydrated_grape_juice
	name = "Grape Juice Powder"
	localized_name = "葡萄汁粉"
	id = "dehydrated_grape_juice"
	description = "等待兑水冲调的葡萄汁粉。闻起来是——真意外啊——葡萄味。"
	reagent_state = SOLID
	color = "#863333" // rgb: 134, 51, 51
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/dehydrated_pineapple_juice
	name = "Pineapple Juice Powder"
	localized_name = "菠萝汁粉"
	id = "dehydrated_pineapple_juice"
	description = "等待兑水冲调的菠萝汁粉。闻起来是——真意外啊——菠萝味。"
	reagent_state = SOLID
	color = "#FFC000" // rgb: 255, 192, 0
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/dehydrated_egg_powder
	name = "Powdered Egg"
	localized_name = "全蛋粉"
	id = "dehydrated_egg_powder"
	description = "将蛋白和蛋黄制成的粉末，等待兑水冲调。"
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/dehydrated_milk_powder
	name = "Dehydrated Milk Powder"
	localized_name = "脱水奶粉"
	id = "dehydrated_milk_powder"
	description = "等待兑水冲调的脱水乳制品粉末。"
	reagent_state = SOLID
	color = "#DFDFDF" // rgb: 223, 223, 223
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/electrolyte_grape_beverage
	name = "Grape Beverage"
	localized_name = "葡萄味饮料"
	id = "dehydrated_grape_beverage"
	description = "葡萄味电解质饮料粉，等待兑水冲调。"
	reagent_state = SOLID
	color = "#74206f" // rgb: 116, 32, 111
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/electrolyte_orange_beverage
	name = "Orange Beverage"
	localized_name = "橙味饮料"
	id = "electrolyte_orange_beverage"
	description = "橙味电解质饮料粉，等待兑水冲调。闻起来是——真意外啊——橙子味。"
	reagent_state = SOLID
	color = "#FFA500" // rgb: 255, 165, 0
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/electrolyte_lemonlime_beverage
	name = "Lemon-Lime Beverage"
	localized_name = "柠檬青柠味饮料"
	id = "electrolyte_lemonlime_beverage"
	description = "柠檬青柠味电解质饮料粉，等待兑水冲调。闻起来是——真意外啊——柠檬和青柠味。"
	reagent_state = SOLID
	color = "#35b435" // rgb: 53, 180, 53
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/hazelnut_beverage
	name = "Chocolate Hazelnut Protein Beverage"
	localized_name = "榛子巧克力蛋白饮"
	id = "hazelnut_beverage"
	description = "榛子巧克力味蛋白饮料粉，等待兑水冲调。"
	reagent_state = SOLID
	color = "#ac4729" // rgb: 172, 71, 41
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/coco_beverage
	name = "Chocolate Protein Beverage"
	localized_name = "巧克力蛋白饮"
	id = "chocolate_beverage"
	description = "巧克力饮料粉，等待兑水冲调。"
	reagent_state = SOLID
	color = "#46271e" // rgb: 70, 39, 30
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION
