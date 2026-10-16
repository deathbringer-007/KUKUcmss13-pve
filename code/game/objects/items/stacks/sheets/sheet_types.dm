/* Diffrent misc types of sheets
 * Contains:
 * Metal
 * Plasteel
 * Wood
 * Cloth
 * Cardboard
 */

/*
 * Metal
 */
GLOBAL_LIST_INIT_TYPED(metal_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("带刺铁丝", /obj/item/stack/barbed_wire, 1, 1, 20, time = 1 SECONDS, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED), \
	new/datum/stack_recipe("金属路障", /obj/structure/barricade/metal, 4, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, flags = CAN_MAKE_BARRICADE, min_time = 1 SECONDS), \
	new/datum/stack_recipe("折叠式金属路障", /obj/structure/barricade/plasteel/metal, 6, time = 3 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI, flags = CAN_MAKE_BARRICADE, min_time = 1.5 SECONDS), \
	new/datum/stack_recipe("扶手栏杆", /obj/structure/barricade/handrail, 2, time = 2 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED, min_time = 1 SECONDS), \
	null, \
	new/datum/stack_recipe("区域电力控制器框架", /obj/item/frame/apc, 2), \
	new/datum/stack_recipe("火警报警器框架", /obj/item/frame/fire_alarm, 2), \
	null, \
	new/datum/stack_recipe("灯具框架", /obj/item/frame/light_fixture, 2), \
	new/datum/stack_recipe("小型灯具框架", /obj/item/frame/light_fixture/small, 1), \
	null, \
	new/datum/stack_recipe("地砖", /obj/item/stack/tile/plasteel, 1, 4, 20), \
	new/datum/stack_recipe("金属棒", /obj/item/stack/rods, 1, 2, 60), \
	new/datum/stack_recipe("墙体框架", /obj/structure/girder, 2, time = 50, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI), \
	new/datum/stack_recipe("窗框", /obj/structure/window_frame/almayer, 5, time = 50, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI), \
	new/datum/stack_recipe("气密门组件", /obj/structure/airlock_assembly, 5, time = 50, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI), \
	new/datum/stack_recipe("大型气密门组件", /obj/structure/airlock_assembly/multi_tile, 5, time = 50, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI), \
	null, \
	new/datum/stack_recipe("床", /obj/structure/bed, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("椅子", /obj/structure/bed/chair, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe_list("软椅", list( \
		new/datum/stack_recipe("米色软椅", /obj/structure/bed/chair/comfy/beige, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("黑色软椅", /obj/structure/bed/chair/comfy/black, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("棕色软椅", /obj/structure/bed/chair/comfy/orange, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("黄绿色软椅", /obj/structure/bed/chair/comfy/lime, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("蓝绿色软椅", /obj/structure/bed/chair/comfy/teal, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		), 2), \
	new/datum/stack_recipe_list("小队座椅", list( \
		new/datum/stack_recipe("阿尔法小队座椅", /obj/structure/bed/chair/comfy/alpha, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("布拉沃小队座椅", /obj/structure/bed/chair/comfy/bravo, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("查理小队座椅", /obj/structure/bed/chair/comfy/charlie, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("德尔塔小队座椅", /obj/structure/bed/chair/comfy/delta, 2, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		), 2), \
	new/datum/stack_recipe_list("办公椅",list( \
		new/datum/stack_recipe("深色办公椅", /obj/structure/bed/chair/office/dark, 5, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		new/datum/stack_recipe("浅色办公椅", /obj/structure/bed/chair/office/light, 5, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
		), 5), \
	new/datum/stack_recipe("凳子", /obj/structure/bed/stool, one_per_turf = 1, on_floor = 1), \
	null, \
	new/datum/stack_recipe("计算机框架", /obj/structure/computerframe, 5, time = 25, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_MASTER), \
	new/datum/stack_recipe("机器框架", /obj/structure/machinery/constructable_frame, 5, time = 25, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_MASTER), \
	null, \
	new/datum/stack_recipe("金属棒球棍", /obj/item/weapon/baseballbat/metal, 10, time = 20, on_floor = 1), \
	null, \
))

/obj/item/stack/sheet/metal
	name = "金属板"
	desc = "用金属制成的板材。人们称之为金属板。"
	singular_name = "金属板"
	icon_state = "sheet-metal"
	item_state = "sheet-metal"
	matter = list("metal" = 3750)
	throwforce = 14
	flags_atom = FPRINT|CONDUCT
	amount_sprites = TRUE
	sheettype = "metal"
	stack_id = "metal"


/obj/item/stack/sheet/metal/small_stack
	amount = STACK_10

/obj/item/stack/sheet/metal/med_small_stack
	amount = STACK_20

/obj/item/stack/sheet/metal/medium_stack
	amount = STACK_30

/obj/item/stack/sheet/metal/med_large_stack
	amount = STACK_40

/obj/item/stack/sheet/metal/large_stack
	amount = STACK_50

/obj/item/stack/sheet/metal/cyborg

/obj/item/stack/sheet/metal/Initialize(mapload, amount)
	recipes = GLOB.metal_recipes
	return ..()

/*
 * Plasteel
 */
GLOBAL_LIST_INIT_TYPED(plasteel_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("折叠式塑钢路障", /obj/structure/barricade/plasteel, 8, time = 4 SECONDS, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI, flags = CAN_MAKE_BARRICADE, min_time = 2 SECONDS),
	new/datum/stack_recipe("塑钢路障", /obj/structure/barricade/metal/plasteel, 6, time = 8 SECONDS, one_per_turf = ONE_TYPE_PER_BORDER, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI, flags = CAN_MAKE_BARRICADE, min_time = 2 SECONDS),
	null, \
	new/datum/stack_recipe("强化窗框", /obj/structure/window_frame/colony/reinforced, 5, time = 40, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_ENGI),
	null, \
	new/datum/stack_recipe("塑钢棒", /obj/item/stack/rods/plasteel, 1, 1, 30),
	new/datum/stack_recipe("金属箱", /obj/structure/closet/crate, 5, time = 50, one_per_turf = ONE_TYPE_PER_TURF), \
	))

/obj/item/stack/sheet/plasteel
	name = "塑钢板"
	singular_name = "塑钢板"
	desc = "这些板材由铁与弗燃素的合金制成。"
	icon_state = "sheet-plasteel"
	item_state = "sheet-plasteel"
	matter = list("metal" = 3750)
	throwforce = 15
	flags_atom = FPRINT|CONDUCT
	amount_sprites = TRUE
	sheettype = "plasteel"
	stack_id = "plasteel"
	ground_offset_x = 4
	ground_offset_y = 5

/obj/item/stack/sheet/plasteel/New(loc, amount=null)
	recipes = GLOB.plasteel_recipes
	return ..()


/obj/item/stack/sheet/plasteel/small_stack
	amount = STACK_10

/obj/item/stack/sheet/plasteel/med_small_stack
	amount = STACK_20

/obj/item/stack/sheet/plasteel/medium_stack
	amount = STACK_30

/obj/item/stack/sheet/plasteel/med_large_stack
	amount = STACK_40

/obj/item/stack/sheet/plasteel/large_stack
	amount = STACK_50

/*
 * Wood
 */
GLOBAL_LIST_INIT_TYPED(wood_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("一双木凉鞋", /obj/item/clothing/shoes/sandal, 1), \
	new/datum/stack_recipe("木地板", /obj/item/stack/tile/wood, 1, 4, 20), \
	/*
	new/datum/stack_recipe("table parts", /obj/item/frame/table/wood, 2), \
	 */
	new/datum/stack_recipe("营火", /obj/structure/prop/brazier/frame/full/campfire, 5, time = 15, one_per_turf = ONE_TYPE_PER_TURF, on_floor = TRUE), \
	new/datum/stack_recipe("木椅", /obj/structure/bed/chair/wood/normal, 1, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("木制路障", /obj/structure/barricade/wooden, 5, time = 20, one_per_turf = ONE_TYPE_PER_BORDER, flags = CAN_MAKE_BARRICADE, on_floor = 1), \
	new/datum/stack_recipe("木箱", /obj/structure/closet/coffin/woodencrate, 5, time = 15, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("木门", /obj/structure/mineral_door/wood, 10, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("棺材", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("棒球棍", /obj/item/weapon/baseballbat, 10, time = 20, on_floor = 1), \
	new/datum/stack_recipe("木十字架", /obj/structure/prop/wooden_cross, 2, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("木杆", /obj/item/weapon/pole, 3, time = 10, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1), \
	new/datum/stack_recipe("钓鱼竿",/obj/item/fishing_pole, 25, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1) \
	))

/obj/item/stack/sheet/wood
	name = "木板"
	desc = "只能猜测这是一堆木头。"
	singular_name = "木板"
	icon_state = "sheet-wood"
	item_state = "sheet-wood"
	sheettype = "wood"
	amount_sprites = TRUE
	stack_id = "wood plank"

/obj/item/stack/sheet/wood/small_stack
	amount = STACK_10

/obj/item/stack/sheet/wood/medium_stack
	amount = STACK_25

/obj/item/stack/sheet/wood/large_stack
	amount = STACK_50

/obj/item/stack/sheet/wood/cyborg
	name = "木板"
	desc = "只能猜测这是一堆木头。"
	singular_name = "木板"
	icon_state = "sheet-wood"

/obj/item/stack/sheet/wood/New(loc, amount=null)
	recipes = GLOB.wood_recipes
	return ..()

/*
 * Cloth
 */
/obj/item/stack/sheet/cloth
	name = "布料"
	desc = "这卷布料仅由最上等的化学原料和小兔子制成。"
	singular_name = "布卷"
	icon_state = "sheet-cloth"

	stack_id = "cloth"

/*
 * Cardboard
 */
GLOBAL_LIST_INIT_TYPED(cardboard_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("盒子", /obj/item/storage/box), \
	new/datum/stack_recipe("甜甜圈盒", /obj/item/storage/donut_box/empty), \
	new/datum/stack_recipe("鸡蛋盒", /obj/item/storage/fancy/egg_box), \
	new/datum/stack_recipe("灯管盒", /obj/item/storage/box/lights/tubes), \
	new/datum/stack_recipe("灯泡盒", /obj/item/storage/box/lights/bulbs), \
	new/datum/stack_recipe("捕鼠夹盒", /obj/item/storage/box/mousetraps), \
	new/datum/stack_recipe("纸板机器人服", /obj/item/clothing/suit/cardborg, 3), \
	new/datum/stack_recipe("纸板机器人头盔", /obj/item/clothing/head/cardborg), \
	new/datum/stack_recipe("披萨盒", /obj/item/pizzabox), \
	new/datum/stack_recipe("飞镖靶", /obj/item/dartboard), \
	null, \
	new/datum/stack_recipe_list("文件夹",list( \
		new/datum/stack_recipe("蓝色文件夹", /obj/item/folder/blue), \
		new/datum/stack_recipe("灰色文件夹", /obj/item/folder), \
		new/datum/stack_recipe("红色文件夹", /obj/item/folder/red), \
		new/datum/stack_recipe("白色文件夹", /obj/item/folder/white), \
		new/datum/stack_recipe("黄色文件夹", /obj/item/folder/yellow), \
		)), \
	null, \
	new/datum/stack_recipe_list("空弹药箱",list( \
		new/datum/stack_recipe("空弹匣箱（VP70）", /obj/item/ammo_box/magazine/vp70/empty), \
		new/datum/stack_recipe("空弹匣箱（SU-6）", /obj/item/ammo_box/magazine/su6/empty), \
		new/datum/stack_recipe("空弹匣箱（VP78）", /obj/item/ammo_box/magazine/vp78/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（M4A3）", /obj/item/ammo_box/magazine/m4a3/empty), \
		new/datum/stack_recipe("空弹匣箱（M4A3 穿甲弹）", /obj/item/ammo_box/magazine/m4a3/ap/empty), \
		new/datum/stack_recipe("空弹匣箱（M4A3 空尖弹）", /obj/item/ammo_box/magazine/m4a3/hp/empty), \
		new/datum/stack_recipe("空弹匣箱（M4A3 燃烧弹）", /obj/item/ammo_box/magazine/m4a3/incen/empty), \
		null, \
		new/datum/stack_recipe("空快速装弹器箱（M44）", /obj/item/ammo_box/magazine/m44/empty), \
		new/datum/stack_recipe("空快速装弹器箱（M44 重型弹）", /obj/item/ammo_box/magazine/m44/heavy/empty), \
		new/datum/stack_recipe("空快速装弹器箱（M44 精确射手弹）", /obj/item/ammo_box/magazine/m44/marksman/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（M39）", /obj/item/ammo_box/magazine/m39/empty), \
		new/datum/stack_recipe("空弹匣箱（M39 穿甲弹）", /obj/item/ammo_box/magazine/m39/ap/empty), \
		new/datum/stack_recipe("空弹匣箱（M39 扩容）", /obj/item/ammo_box/magazine/m39/ext/empty), \
		new/datum/stack_recipe("空弹匣箱（M39 燃烧弹）", /obj/item/ammo_box/magazine/m39/incen/empty), \
		new/datum/stack_recipe("空弹匣箱（M39 轻型爆破弹）", /obj/item/ammo_box/magazine/m39/le/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（L42A）", /obj/item/ammo_box/magazine/l42a/empty), \
		new/datum/stack_recipe("空弹匣箱（L42A 穿甲弹）", /obj/item/ammo_box/magazine/l42a/ap/empty), \
		new/datum/stack_recipe("空弹匣箱（L42A 扩容）", /obj/item/ammo_box/magazine/l42a/ext/empty), \
		new/datum/stack_recipe("空弹匣箱（L42A 燃烧弹）", /obj/item/ammo_box/magazine/l42a/incen/empty), \
		new/datum/stack_recipe("空弹匣箱（L42A 轻型爆破弹）", /obj/item/ammo_box/magazine/l42a/le/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（M49A）", /obj/item/ammo_box/magazine/m49a/empty), \
		new/datum/stack_recipe("空弹匣箱（M49A 穿甲弹）", /obj/item/ammo_box/magazine/m49a/ap/empty), \
		new/datum/stack_recipe("空弹匣箱（M49A 燃烧弹）", /obj/item/ammo_box/magazine/m49a/incen/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（M41A）", /obj/item/ammo_box/magazine/empty), \
		new/datum/stack_recipe("空弹匣箱（M41A 穿甲弹）", /obj/item/ammo_box/magazine/ap/empty), \
		new/datum/stack_recipe("空弹匣箱（M41A 爆破弹）", /obj/item/ammo_box/magazine/explosive/empty), \
		new/datum/stack_recipe("空弹匣箱（M41A 扩容）", /obj/item/ammo_box/magazine/ext/empty), \
		new/datum/stack_recipe("空弹匣箱（M41A 燃烧弹）", /obj/item/ammo_box/magazine/incen/empty), \
		new/datum/stack_recipe("空弹匣箱（M41A 轻型爆破弹）", /obj/item/ammo_box/magazine/le/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（XM51）", /obj/item/ammo_box/magazine/xm51/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（M41A MK1）", /obj/item/ammo_box/magazine/mk1/empty), \
		new/datum/stack_recipe("空弹匣箱（M41A MK1 穿甲弹）", /obj/item/ammo_box/magazine/mk1/ap/empty), \
		null, \
		new/datum/stack_recipe("空弹鼓箱（M56B）", /obj/item/ammo_box/magazine/m56b/empty), \
		new/datum/stack_recipe("空弹鼓箱（M56B 放射性弹）", /obj/item/ammo_box/magazine/m56b/dirty/empty), \
		new/datum/stack_recipe("空弹鼓箱（M56D）", /obj/item/ammo_box/magazine/m56d/empty), \
		null, \
		new/datum/stack_recipe("空弹鼓箱（M2C）", /obj/item/ammo_box/magazine/m2c/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（M41AE2）", /obj/item/ammo_box/magazine/m41ae2/empty), \
		new/datum/stack_recipe("空弹匣箱（M41AE2 全息标记弹）", /obj/item/ammo_box/magazine/m41ae2/holo/empty), \
		new/datum/stack_recipe("空弹匣箱（M41AE2 高爆穿甲弹）", /obj/item/ammo_box/magazine/m41ae2/heap/empty), \
		null, \
		new/datum/stack_recipe("空喷火器燃料罐箱（UT-Napthal）", /obj/item/ammo_box/magazine/flamer/empty), \
		new/datum/stack_recipe("空喷火器燃料罐箱（B型凝固汽油）", /obj/item/ammo_box/magazine/flamer/bgel/empty), \
		null, \
		new/datum/stack_recipe("空霰弹箱（布袋弹）", /obj/item/ammo_box/magazine/shotgun/beanbag/empty), \
		new/datum/stack_recipe("空霰弹箱（鹿弹）", /obj/item/ammo_box/magazine/shotgun/buckshot/empty), \
		new/datum/stack_recipe("空霰弹箱（箭形弹）", /obj/item/ammo_box/magazine/shotgun/flechette/empty), \
		new/datum/stack_recipe("空霰弹箱（燃烧弹）", /obj/item/ammo_box/magazine/shotgun/incendiary/empty), \
		new/datum/stack_recipe("空霰弹箱（燃烧鹿弹）", /obj/item/ammo_box/magazine/shotgun/incendiarybuck/empty), \
		new/datum/stack_recipe("空霰弹箱（独头弹）", /obj/item/ammo_box/magazine/shotgun/empty), \
		new/datum/stack_recipe("空霰弹箱（16号口径破门弹）", /obj/item/ammo_box/magazine/shotgun/light/breaching/empty), \
		null, \
		new/datum/stack_recipe("空45-70弹药箱", /obj/item/ammo_box/magazine/lever_action/empty), \
		new/datum/stack_recipe("空45-70弹药箱（空包弹）", /obj/item/ammo_box/magazine/lever_action/training/empty), \
		new/datum/stack_recipe("空45-70弹药箱（追踪弹）", /obj/item/ammo_box/magazine/lever_action/tracker/empty), \
		new/datum/stack_recipe("空45-70弹药箱（精确射手弹）", /obj/item/ammo_box/magazine/lever_action/marksman/empty), \
		null, \
		new/datum/stack_recipe("空.458弹药箱", /obj/item/ammo_box/magazine/lever_action/xm88/empty), \
		null, \
		new/datum/stack_recipe("空冲锋枪弹药箱（10x20mm）", /obj/item/ammo_box/rounds/smg/empty), \
		new/datum/stack_recipe("空冲锋枪弹药箱（10x20mm 穿甲弹）", /obj/item/ammo_box/rounds/smg/ap/empty), \
		new/datum/stack_recipe("空冲锋枪弹药箱（10x20mm 燃烧弹）", /obj/item/ammo_box/rounds/smg/incen/empty), \
		new/datum/stack_recipe("空冲锋枪弹药箱（10x20mm 轻型爆破弹）", /obj/item/ammo_box/rounds/smg/le/empty), \
		null, \
		new/datum/stack_recipe("空步枪弹药箱（10x24mm）", /obj/item/ammo_box/rounds/empty), \
		new/datum/stack_recipe("空步枪弹药箱（10x24mm 穿甲弹）", /obj/item/ammo_box/rounds/ap/empty), \
		new/datum/stack_recipe("空步枪弹药箱（10x24mm 燃烧弹）", /obj/item/ammo_box/rounds/incen/empty), \
		new/datum/stack_recipe("空步枪弹药箱（10x24mm 轻型爆破弹）", /obj/item/ammo_box/rounds/le/empty), \
		null, \
		new/datum/stack_recipe("空智能机枪弹药箱（10x28mm）", /obj/item/ammo_box/rounds/smartgun/empty), \
		null, \
		new/datum/stack_recipe("空手枪弹药箱（9mm）", /obj/item/ammo_box/rounds/pistol/empty), \
		new/datum/stack_recipe("空手枪弹药箱（9mm 穿甲弹）", /obj/item/ammo_box/rounds/pistol/ap/empty), \
		new/datum/stack_recipe("空手枪弹药箱（9mm 空尖弹）", /obj/item/ammo_box/rounds/pistol/hp/empty), \
		new/datum/stack_recipe("空手枪弹药箱（9mm 燃烧弹）", /obj/item/ammo_box/rounds/pistol/incen/empty), \
		null, \
		new/datum/stack_recipe("空即食军粮箱", /obj/item/ammo_box/magazine/misc/mre/empty), \
		new/datum/stack_recipe("空M94标记照明棒包箱", /obj/item/ammo_box/magazine/misc/flares/empty), \
		new/datum/stack_recipe("空M89信号照明棒包箱", /obj/item/ammo_box/magazine/misc/flares/signal/empty), \
		new/datum/stack_recipe("空手电筒箱", /obj/item/ammo_box/magazine/misc/flashlight/empty), \
		new/datum/stack_recipe("空战术手电筒箱", /obj/item/ammo_box/magazine/misc/flashlight/combat/empty), \
		new/datum/stack_recipe("空高容量电池箱", /obj/item/ammo_box/magazine/misc/power_cell/empty), \
		null, \
		new/datum/stack_recipe("空UPP口粮箱", /obj/item/ammo_box/magazine/misc/mre/upp/empty), \
		new/datum/stack_recipe("空维兰德-汤谷口粮箱", /obj/item/ammo_box/magazine/misc/mre/wy/empty), \
		new/datum/stack_recipe("空维兰德-汤谷应急食品包箱", /obj/item/ammo_box/magazine/misc/mre/wy/empty), \
		new/datum/stack_recipe("空PMC口粮箱", /obj/item/ammo_box/magazine/misc/mre/pmc/empty), \
		new/datum/stack_recipe("空突击口粮箱", /obj/item/ammo_box/magazine/misc/mre/fsr/empty), \
		new/datum/stack_recipe("空TWE口粮箱", /obj/item/ammo_box/magazine/misc/mre/twe/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（沙漠之鹰）", /obj/item/ammo_box/magazine/deagle/empty), \
		new/datum/stack_recipe("空弹匣箱（沙漠之鹰 重型弹）", /obj/item/ammo_box/magazine/deagle/super/empty), \
		new/datum/stack_recipe("空弹匣箱（沙漠之鹰 高冲击弹）", /obj/item/ammo_box/magazine/deagle/super/highimpact/empty), \
		new/datum/stack_recipe("空弹匣箱（沙漠之鹰 穿甲弹）", /obj/item/ammo_box/magazine/deagle/super/highimpact/ap/empty), \
		null, \
		new/datum/stack_recipe("空快速装弹器箱（矛头 空尖弹）", /obj/item/ammo_box/magazine/spearhead/empty), \
		new/datum/stack_recipe("空快速装弹器箱（矛头）", /obj/item/ammo_box/magazine/spearhead/normalpoint/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（M16）", /obj/item/ammo_box/magazine/M16/empty), \
		new/datum/stack_recipe("空弹匣箱（M16 穿甲弹）", /obj/item/ammo_box/magazine/M16/ap/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（AR10）", /obj/item/ammo_box/magazine/ar10/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（MP5）", /obj/item/ammo_box/magazine/mp5/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（MAR30）", /obj/item/ammo_box/magazine/mar30/empty), \
		new/datum/stack_recipe("空弹匣箱（MAR30 扩容）", /obj/item/ammo_box/magazine/mar30/ext/empty), \
		new/datum/stack_recipe("空弹匣箱（MAR50）", /obj/item/ammo_box/magazine/mar50/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（UZI）", /obj/item/ammo_box/magazine/uzi/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（MAC-15）", /obj/item/ammo_box/magazine/mac15/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（MP27）", /obj/item/ammo_box/magazine/mp27/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（M1911）", /obj/item/ammo_box/magazine/m1911/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（MK-45）", /obj/item/ammo_box/magazine/mk45/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（KT-42）", /obj/item/ammo_box/magazine/kt42/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（伯莱塔92FS）", /obj/item/ammo_box/magazine/b92fs/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（FN FP9000）", /obj/item/ammo_box/magazine/fp9000/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（19式）", /obj/item/ammo_box/magazine/type19/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（ZhNK-72）", /obj/item/ammo_box/magazine/zhnk/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（64式野牛）", /obj/item/ammo_box/magazine/type64/empty), \
		null, \
		new/datum/stack_recipe("空快速装弹器箱（S&W .38）", /obj/item/ammo_box/magazine/snw/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（NSG L23A1）", /obj/item/ammo_box/magazine/nsg23/empty), \
		new/datum/stack_recipe("空弹匣箱（NSG L23A1 穿甲弹）", /obj/item/ammo_box/magazine/nsg23/ap/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（71式）", /obj/item/ammo_box/magazine/type71/empty), \
		new/datum/stack_recipe("空弹匣箱（71式 穿甲弹）", /obj/item/ammo_box/magazine/type71/ap/empty), \
		null, \
		new/datum/stack_recipe("空弹匣箱（73式）", /obj/item/ammo_box/magazine/type73/empty), \
		new/datum/stack_recipe("空弹匣箱（73式 高冲击弹）", /obj/item/ammo_box/magazine/type73/impact/empty), \
		null, \
		new/datum/stack_recipe("空步枪弹药箱（10x27mm）", /obj/item/ammo_box/rounds/type71/empty), \
		new/datum/stack_recipe("空步枪弹药箱（10x27mm 穿甲弹）", /obj/item/ammo_box/rounds/type71/ap/empty), \


		)) \
))

/obj/item/stack/sheet/cardboard //BubbleWrap
	name = "硬纸板"
	desc = "大块的硬纸板，看起来像压平的纸箱。"
	singular_name = "硬纸板"
	icon_state = "sheet-card"
	sheettype = "cardboard"
	stack_id = "cardboard"

/obj/item/stack/sheet/cardboard/New(loc, amount=null)
	recipes = GLOB.cardboard_recipes
	return ..()

/obj/item/stack/sheet/cardboard/small_stack
	amount = STACK_10

/obj/item/stack/sheet/cardboard/medium_stack
	amount = STACK_30

/obj/item/stack/sheet/cardboard/full_stack
	amount = STACK_50

/*
 * Aluminum
 */
GLOBAL_LIST_INIT_TYPED(aluminium_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("酒壶", /obj/item/reagent_container/food/drinks/flask, 1)
	))

/obj/item/stack/sheet/aluminum
	name = "铝"
	desc = "一种银白色的柔软金属，属于硼族元素。因其密度低，常用作飞机的结构材料。"
	singular_name = "铝板"
	icon_state = "sheet-aluminum"
	sheettype = "aluminum"
	black_market_value = 10

/*
 * Copper
 */
GLOBAL_LIST_INIT_TYPED(copper_recipes, /datum/stack_recipe, list ( \
	new/datum/stack_recipe("电缆卷", /obj/item/stack/cable_coil, 2, 1, 20, time = 10, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED)
	))

/obj/item/stack/sheet/copper
	name = "铜"
	desc = "一种柔软、延展性强的红色金属，导热和导电性能优异。"
	singular_name = "铜板"
	icon_state = "sheet-copper"
	sheettype = "copper"
	black_market_value = 10

