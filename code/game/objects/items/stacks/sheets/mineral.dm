/*
Mineral Sheets
	Contains:
		- Sandstone
		- Runed Sandstone
		- Diamond
		- Uranium
		- Phoron
		- Gold
		- Silver
		- Enriched Uranium
		- Platinum
		- Metallic Hydrogen
		- Tritium
		- Osmium
*/

GLOBAL_LIST_INIT(sandstone_recipes, list ( \
	new/datum/stack_recipe("土堆", /obj/structure/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("砂岩门", /obj/structure/mineral_door/sandstone, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("砂岩墙", /turf/closed/wall/mineral/sandstone, 5, time = 50, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("砂岩地板", /turf/open/floor/sandstone/runed, 1, on_floor = 1), \
	new/datum/stack_recipe("砂岩护栏（垛口式）", /obj/structure/barricade/handrail/sandstone, 2, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, min_time = 1 SECONDS), \
	new/datum/stack_recipe("砂岩护栏（平顶式）", /obj/structure/barricade/handrail/sandstone/b, 2, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, min_time = 1 SECONDS),
	))

GLOBAL_LIST_INIT(runedsandstone_recipes, list ( \
	new/datum/stack_recipe("神殿门", /obj/structure/machinery/door/airlock/sandstone/runed, 15, time = 10, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("神殿墙", /turf/closed/wall/mineral/sandstone/runed, 5, time = 50, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("符文神殿墙", /turf/closed/wall/mineral/sandstone/runed/decor, 5, time = 50, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("神殿地板", /turf/open/floor/sandstone/runed, 1, on_floor = 1), \
	new/datum/stack_recipe("火盆框架", /obj/structure/prop/brazier/frame, 5, time = 5 SECONDS, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("壁挂火炬支架", /obj/item/prop/torch_frame, 2, time = 2 SECONDS, skill_req = SKILL_ANTAG, skill_lvl = SKILL_ANTAG_HUNTER, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(silver_recipes, list ( \
	new/datum/stack_recipe("银门", /obj/structure/mineral_door/silver, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("银制烧杯", /obj/item/reagent_container/glass/beaker/silver, 3, time = 30, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED), \
	))

GLOBAL_LIST_INIT(diamond_recipes, list ( \
	new/datum/stack_recipe("钻石门", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(uranium_recipes, list ( \
	new/datum/stack_recipe("铀门", /obj/structure/mineral_door/uranium, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(gold_recipes, list ( \
	new/datum/stack_recipe("金门", /obj/structure/mineral_door/gold, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(phoron_recipes, list ( \
	new/datum/stack_recipe("弗燃素门", /obj/structure/mineral_door/transparent/phoron, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	))

GLOBAL_LIST_INIT(plastic_recipes, list ( \
	new/datum/stack_recipe("塑料箱", /obj/structure/closet/crate/plastic, 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("塑料烟灰缸", /obj/item/ashtray/plastic, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("塑料餐叉", /obj/item/tool/kitchen/utensil/pfork, 1, on_floor = 1), \
	new/datum/stack_recipe("塑料勺子", /obj/item/tool/kitchen/utensil/pspoon, 1, on_floor = 1), \
	new/datum/stack_recipe("塑料餐刀", /obj/item/tool/kitchen/utensil/pknife, 1, on_floor = 1), \
	))

GLOBAL_LIST_INIT(iron_recipes, list ( \
	new/datum/stack_recipe("铁门", /obj/structure/mineral_door/iron, 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	null, \
))

/obj/item/stack/sheet/mineral
	force = 5
	throwforce = 5
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_VERY_FAST
	throw_range = 3
	black_market_value = 5

/obj/item/stack/sheet/mineral/Initialize()
	. = ..()
	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4

/obj/item/stack/sheet/mineral/iron
	name = "铁"
	desc = "铁是一种过渡金属，也是太空中最基础的建筑材料。它在室温下呈固态，易于塑形，储量极为丰富。"
	singular_name = "铁板"
	icon_state = "sheet-silver"

	sheettype = "iron"
	color = "#333333"
	perunit = 3750
	stack_id = "iron"

/obj/item/stack/sheet/mineral/iron/Initialize()
	. = ..()
	recipes = GLOB.iron_recipes

/obj/item/stack/sheet/mineral/sandstone
	name = "砂岩砖"
	desc = "砂岩是由沙粒胶结而成的岩石。虽然是原始文明常用的建筑材料，但用它砌墙仍然相当不错。"
	singular_name = "砂岩砖"
	icon_state = "sheet-sandstone"
	throw_speed = SPEED_VERY_FAST
	throw_range = 5

	sheettype = "sandstone"
	stack_id = "sandstone"

/obj/item/stack/sheet/mineral/sandstone/Initialize()
	. = ..()
	recipes = GLOB.sandstone_recipes

/obj/item/stack/sheet/mineral/sandstone/large_stack
	amount = STACK_50

/obj/item/stack/sheet/mineral/sandstone/runed
	name = "符文砂岩砖"
	desc = "砂岩是由沙粒胶结而成的岩石。虽然是原始文明常用的建筑材料，但用它砌墙仍然相当不错。这块砖中还嵌着奇异的符文。"
	singular_name = "符文砂岩砖"
	icon_state = "sheet-runedsandstone"
	black_market_value = 15

/obj/item/stack/sheet/mineral/sandstone/runed/large_stack
	amount = STACK_50

/obj/item/stack/sheet/mineral/sandstone/runed/Initialize()
	. = ..()
	recipes = GLOB.runedsandstone_recipes

/obj/item/stack/sheet/mineral/sandstone/runed/attack_self(mob/user)
	..()

	if(isyautja(user))
		list_recipes(user)

/obj/item/stack/sheet/mineral/diamond
	name = "钻石"
	desc = "钻石是碳在高温高压下形成的金刚石型立方晶体。虽然如今已能人工制造，但它的外观和硬度仍使其备受珍视。"
	singular_name = "钻石晶体"
	icon_state = "sheet-diamond"

	perunit = 3750
	sheettype = "diamond"
	stack_id = "diamond"
	black_market_value = 30


/obj/item/stack/sheet/mineral/diamond/Initialize()
	. = ..()
	recipes = GLOB.diamond_recipes

/obj/item/stack/sheet/mineral/uranium
	name = "铀"
	desc = "铀是一种锕系放射性金属，可用作裂变发电机的反应堆燃料，也可用于聚变炸弹的起爆装置。"
	singular_name = "铀棒"
	icon_state = "sheet-uranium"

	perunit = 2000
	sheettype = "uranium"
	stack_id = "uranium"
	black_market_value = 30

/obj/item/stack/sheet/mineral/uranium/Initialize()
	. = ..()
	recipes = GLOB.uranium_recipes

/obj/item/stack/sheet/mineral/uranium/small_stack
	amount = STACK_10

/obj/item/stack/sheet/mineral/phoron
	name = "固态弗燃素"
	desc = "弗燃素是一种极其稀有、具有奇特性质的矿物，常用于前沿研究。由于它有毒且易燃，仅仅将其制成稳定的固态就已经十分困难。"
	singular_name = "弗燃素锭"
	icon_state = "sheet-phoron"

	perunit = 2000
	sheettype = "phoron"
	stack_id = "phoron"
	black_market_value = 10

/obj/item/stack/sheet/mineral/phoron/small_stack
	amount = STACK_10

/obj/item/stack/sheet/mineral/phoron/medium_stack
	amount = STACK_30

/obj/item/stack/sheet/mineral/plastic
	name = "塑料"
	desc = "塑料是由有机与无机成分合成的聚合物，质地轻盈、易于塑形，可用于制造各种物品。"
	singular_name = "塑料板"
	icon_state = "sheet-plastic"
	matter = list("plastic" = 2000)

	perunit = 2000
	stack_id = "plastic"
	black_market_value = 0

/obj/item/stack/sheet/mineral/plastic/Initialize()
	. = ..()
	recipes = GLOB.plastic_recipes

/obj/item/stack/sheet/mineral/plastic/small_stack
	amount = STACK_10

/obj/item/stack/sheet/mineral/plastic/cyborg
	name = "塑料板"
	desc = "塑料是由有机与无机成分合成的聚合物，质地轻盈、易于塑形，可用于制造各种物品。"
	singular_name = "塑料板"
	icon_state = "sheet-plastic"
	perunit = 2000

/obj/item/stack/sheet/mineral/gold
	name = "金"
	desc = "金是一种相对稀有的过渡金属，以其色泽、光亮、化学性质和电学性质著称，在装饰、工程与科研领域都有广泛需求。"
	singular_name = "金锭"
	icon_state = "sheet-gold"

	perunit = 2000
	sheettype = "gold"
	stack_id = "gold"
	black_market_value = 30

/obj/item/stack/sheet/mineral/gold/Initialize()
	. = ..()
	recipes = GLOB.gold_recipes

/obj/item/stack/sheet/mineral/gold/small_stack
	amount = STACK_5

/obj/item/stack/sheet/mineral/silver
	name = "银"
	desc = "银是一种以银灰色光泽著称的过渡金属。它既可作为比黄金更便宜的装饰材料，也凭借出色的导电性、导热性和反射率用于工程领域。"
	singular_name = "银锭"
	icon_state = "sheet-silver"

	perunit = 2000
	sheettype = "silver"
	stack_id = "silver"
	black_market_value = 25

/obj/item/stack/sheet/mineral/silver/Initialize()
	. = ..()
	recipes = GLOB.silver_recipes

/obj/item/stack/sheet/mineral/silver/small_stack
	amount = STACK_10

/obj/item/stack/sheet/mineral/enruranium
	name = "浓缩铀"
	desc = "浓缩铀棒由约3%至5%的铀-235与普通铀-238混合制成。虽然远未达到武器级，但足以用于裂变引擎。"
	singular_name = "浓缩铀棒"
	icon_state = "sheet-enruranium"

	perunit = 1000
	stack_id = "enuranium"

//Valuable resource, cargo can now actually sell it.
/obj/item/stack/sheet/mineral/platinum
	name = "铂"
	desc = "铂是一种相对稀有且美观的过渡金属，既可用于装饰，也因其化学性质被用作催化剂，还可用于制造电极。"
	singular_name = "铂锭"
	icon_state = "sheet-platinum"

	sheettype = "platinum"
	perunit = 2000
	stack_id = "platinum"
	black_market_value = 35


/obj/item/stack/sheet/mineral/lead
	name = "铅"
	desc = "铅是一种重金属，密度很高，但在固态下柔软且易于塑形。虽然摄入有毒，铅板却常作为墙体屏蔽材料，用来防护辐射、吸收声音和振动。"
	singular_name = "铅砖"
	icon_state = "sheet-lead"

	sheettype = "lead"
	perunit = 2000
	stack_id = "lead"
	black_market_value = 35

//Extremely valuable to Research.
/obj/item/stack/sheet/mineral/mhydrogen
	name = "金属氢"
	desc = "金属氢是普通氢在极高压力下形成的近固态材料，可制成锭块。制造并稳定这种锭块的具体工艺仍是商业机密。"
	singular_name = "金属氢锭"
	icon_state = "sheet-mythril"

	sheettype = "mhydrogen"
	perunit = 2000
	stack_id = "mhydrogen"

//Fuel for MRSPACMAN generator.
/obj/item/stack/sheet/mineral/tritium
	name = "氚"
	desc = "氚是氢的同位素氢-3，在极高压力下可制成锭块。制造并稳定这种锭块的具体工艺仍是商业机密。"
	singular_name = "氚锭"
	icon_state = "sheet-silver"
	sheettype = "tritium"

	color = "#777777"
	perunit = 2000
	stack_id = "tritium"
	black_market_value = 35

/obj/item/stack/sheet/mineral/osmium
	name = "锇"
	desc = "锇是一种过渡金属，是人类已知密度最高的天然元素，以极高的硬度和耐久性著称，也因此受到应用。"
	singular_name = "锇锭"
	icon_state = "sheet-silver"
	sheettype = "osmium"

	color = "#9999FF"
	perunit = 2000
	stack_id = "osmium"
	black_market_value = 35

/obj/item/stack/sheet/mineral/chitin
	name = "几丁质"
	desc = "几丁质是昆虫、甲壳类等节肢动物外骨骼的构成材料。这一块则来自异形。"
	singular_name = "几丁质砖"
	icon_state = "sheet-chitin"

	sheettype = "chitin"
	perunit = 2000
	stack_id = "chitin"
	black_market_value = 35
