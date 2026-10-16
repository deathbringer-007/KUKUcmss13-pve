//------------VEHICLE MODULES VENDOR---------------

/obj/structure/machinery/cm_vending/gear/vehicle_crew
	name = "ColMarTech载具零件配送系统"
	desc = "连接舰船底部的自动配送系统。乘员可以在行动开始时为载具免费选择一套装备；若指挥部追加预算，还可以订购更多备用零件。仅限载具乘员使用。"
	icon = 'icons/obj/structures/machinery/vending_64x32.dmi'
	icon_state = "vehicle_gear"

	req_access = list(ACCESS_MARINE_CREWMAN)
	vendor_role = list(JOB_TANK_CREW)
	bound_width = 64

	unslashable = TRUE

	vend_delay = 4 SECONDS
	vend_sound = 'sound/machines/medevac_extend.ogg'

	var/selected_vehicle
	var/budget_points = 0
	var/available_categories = VEHICLE_ALL_AVAILABLE

	available_points_to_display = 0

	vend_flags = VEND_CLUTTER_PROTECTION|VEND_CATEGORY_CHECK|VEND_TO_HAND|VEND_USE_VENDOR_FLAGS

/obj/structure/machinery/cm_vending/gear/vehicle_crew/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_VEHICLE_ORDERED, PROC_REF(populate_products))
	if(!GLOB.VehicleGearConsole)
		GLOB.VehicleGearConsole = src

/obj/structure/machinery/cm_vending/gear/vehicle_crew/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_VEHICLE_ORDERED)
	GLOB.VehicleGearConsole = null
	return ..()

/obj/structure/machinery/cm_vending/gear/vehicle_crew/get_appropriate_vend_turf(mob/living/carbon/human/H)
	var/turf/target = get_turf(src)
	target = get_step(target, SOUTH)
	return target

/obj/structure/machinery/cm_vending/gear/vehicle_crew/tip_over() //we don't do this here
	return

/obj/structure/machinery/cm_vending/gear/vehicle_crew/flip_back()
	return

/obj/structure/machinery/cm_vending/gear/vehicle_crew/ex_act(severity)
	if(severity > EXPLOSION_THRESHOLD_LOW)
		if(prob(25))
			malfunction()
			return

/obj/structure/machinery/cm_vending/gear/vehicle_crew/proc/populate_products(datum/source, obj/vehicle/multitile/V)
	SIGNAL_HANDLER
	UnregisterSignal(SSdcs, COMSIG_GLOB_VEHICLE_ORDERED)

	if(!selected_vehicle)
		selected_vehicle = "TANK" // The whole thing seems to be based upon the assumption you unlock tank as an override, defaulting to APC
	if(selected_vehicle == "TANK")
		available_categories &= ~(VEHICLE_INTEGRAL_AVAILABLE) //APC lacks these, so we need to remove these flags to be able to access spare parts section
		marine_announcement("一辆坦克正被调来支援本次行动。")

/obj/structure/machinery/cm_vending/gear/vehicle_crew/get_listed_products(mob/user)
	var/list/display_list = list()

	if(!user)
		display_list += GLOB.cm_vending_vehicle_crew_tank
		display_list += GLOB.cm_vending_vehicle_crew_apc
		return display_list

	if(selected_vehicle == "TANK")
		if(available_categories)
			display_list = GLOB.cm_vending_vehicle_crew_tank

	else if(selected_vehicle == "ARC")
		display_list = GLOB.cm_vending_vehicle_crew_arc

	else if(selected_vehicle == "TANK")
		if(available_categories)
			display_list = GLOB.cm_vending_vehicle_crew_apc
		else //APC stuff costs more to prevent 4000 points spent on shitton of ammunition
			display_list = GLOB.cm_vending_vehicle_crew_apc_spare
	return display_list

/obj/structure/machinery/cm_vending/gear/vehicle_crew/ui_data(mob/user)
	. = list()
	. += ui_static_data(user)

	if(GLOB.supply_controller.tank_points) //we steal points from GLOB.supply_controller, meh-he-he. Solely to be able to modify amount of points in vendor if needed by just changing one var.
		available_points_to_display = GLOB.supply_controller.tank_points
		GLOB.supply_controller.tank_points = 0
	.["current_m_points"] = available_points_to_display

	var/list/ui_listed_products = get_listed_products(user)
	var/list/stock_values = list()
	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i] //we take one list from listed_products
		var/prod_available = FALSE
		var/p_cost = myprod[2]
		var/avail_flag = myprod[4]
		if(budget_points >= p_cost && (!avail_flag || available_categories & avail_flag))
			prod_available = TRUE
		stock_values += list(prod_available)

	.["stock_listing"] = stock_values

/obj/structure/machinery/cm_vending/gear/vehicle_crew/handle_points(mob/living/carbon/human/H, list/L)
	. = TRUE
	if(available_categories)
		if(!(available_categories & L[4]))
			to_chat(usr, SPAN_WARNING("该类别的模块已经领取。"))
			vend_fail()
			return FALSE
		available_categories &= ~L[4]
	else
		if(available_points_to_display < L[2])
			to_chat(H, SPAN_WARNING("点数不足。"))
			vend_fail()
			return FALSE
		budget_points -= L[2]

GLOBAL_LIST_INIT(cm_vending_vehicle_crew_tank, list(
	list("初始套件选择：", 0, null, null, null),

	list("主要部件", 0, null, null, null),
	list("M34A2-A 多用途炮塔", 0, /obj/effect/essentials_set/tank/turret, VEHICLE_INTEGRAL_AVAILABLE, VENDOR_ITEM_MANDATORY),

	list("主武器", 0, null, null, null),
	list("AC3-E 自动炮", 0, /obj/effect/essentials_set/tank/autocannon, VEHICLE_PRIMARY_AVAILABLE, VENDOR_ITEM_RECOMMENDED),
	list("DRG-N 进攻型喷火装置", 0, /obj/effect/essentials_set/tank/dragonflamer, VEHICLE_PRIMARY_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("LTAA-AP 转管机枪", 0, /obj/effect/essentials_set/tank/gatling, VEHICLE_PRIMARY_AVAILABLE, VENDOR_ITEM_REGULAR),

	list("次要武器", 0, null, null, null),
	list("M92T 榴弹发射器", 0, /obj/effect/essentials_set/tank/tankgl, VEHICLE_SECONDARY_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("M56 车长炮塔", 0, /obj/effect/essentials_set/tank/m56cupola, VEHICLE_SECONDARY_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("LZR-N 喷火装置", 0, /obj/effect/essentials_set/tank/tankflamer, VEHICLE_SECONDARY_AVAILABLE, VENDOR_ITEM_RECOMMENDED),

	list("支援模块", 0, null, null, null),
	list("炮兵模块", 0, /obj/item/hardpoint/support/artillery_module, VEHICLE_SUPPORT_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("综合武器传感器阵列", 0, /obj/item/hardpoint/support/weapons_sensor, VEHICLE_SUPPORT_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("超速增强器", 0, /obj/item/hardpoint/support/overdrive_enhancer, VEHICLE_SUPPORT_AVAILABLE, VENDOR_ITEM_RECOMMENDED),

	list("护甲", 0, null, null, null),
	list("除雪铲", 0, /obj/item/hardpoint/armor/snowplow, VEHICLE_ARMOR_AVAILABLE, VENDOR_ITEM_REGULAR),

	list("履带", 0, null, null, null),
	list("强化履带", 0, /obj/item/hardpoint/locomotion/treads/robust, VEHICLE_TREADS_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("履带", 0, /obj/item/hardpoint/locomotion/treads, VEHICLE_TREADS_AVAILABLE, VENDOR_ITEM_REGULAR)))

GLOBAL_LIST_INIT(cm_vending_vehicle_crew_apc, list(
	list("初始套件选择：", 0, null, null, null),

	list("主武器", 0, null, null, null),
	list("PARS-159 博雅尔双联装机炮", 0, /obj/effect/essentials_set/apc/dualcannon, VEHICLE_PRIMARY_AVAILABLE, VENDOR_ITEM_MANDATORY),

	list("次要武器", 0, null, null, null),
	list("RE-RE700 前置机炮", 0, /obj/effect/essentials_set/apc/frontalcannon, VEHICLE_SECONDARY_AVAILABLE, VENDOR_ITEM_MANDATORY),

	list("支援模块", 0, null, null, null),
	list("M-97F 照明弹发射器", 0, /obj/effect/essentials_set/apc/flarelauncher, VEHICLE_SUPPORT_AVAILABLE, VENDOR_ITEM_MANDATORY),

	list("车轮", 0, null, null, null),
	list("装甲运兵车车轮", 0, /obj/item/hardpoint/locomotion/apc_wheels, VEHICLE_TREADS_AVAILABLE, VENDOR_ITEM_MANDATORY)))

GLOBAL_LIST_INIT(cm_vending_vehicle_crew_apc_spare, list(
	list("备用零件选择：", 0, null, null, null),

	list("主武器", 0, null, null, null),
	list("PARS-159 博雅尔双联装机炮", 500, /obj/item/hardpoint/primary/dualcannon, null, VENDOR_ITEM_REGULAR),

	list("主武器弹药", 0, null, null, null),
	list("PARS-159 双联装机炮弹匣", 150, /obj/item/ammo_magazine/hardpoint/ace_autocannon, null, VENDOR_ITEM_REGULAR),

	list("次要武器", 0, null, null, null),
	list("RE-RE700 前置机炮", 400, /obj/item/hardpoint/secondary/frontalcannon, null, VENDOR_ITEM_REGULAR),

	list("次要武器弹药", 0, null, null, null),
	list("RE-RE700 前置机炮弹匣", 150, /obj/item/ammo_magazine/hardpoint/tank_glauncher, null, VENDOR_ITEM_REGULAR),

	list("支援模块", 0, null, null, null),
	list("M-97F 照明弹发射器", 300, /obj/item/hardpoint/support/flare_launcher, null, VENDOR_ITEM_REGULAR),

	list("支援弹药", 0, null, null, null),
	list("M-97F 照明弹发射器弹匣", 50, /obj/item/ammo_magazine/hardpoint/flare_launcher, null, VENDOR_ITEM_REGULAR),

	list("车轮", 0, null, null, null),
	list("装甲运兵车车轮", 200, /obj/item/hardpoint/locomotion/apc_wheels, null, VENDOR_ITEM_REGULAR)))

GLOBAL_LIST_INIT(cm_vending_vehicle_crew_arc, list(
	list("初始套件选择：", 0, null, null, null),

	list("车轮", 0, null, null, null),
	list("ARC 替换车轮", 0, /obj/item/hardpoint/locomotion/arc_wheels, VEHICLE_TREADS_AVAILABLE, VENDOR_ITEM_MANDATORY)))

//------------WEAPONS RACK---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/vehicle_crew
	name = "ColMarTech载具乘员武器架"
	desc = "连接着小型制式武器仓库的自动武器架。仅限载具乘员使用。"
	icon_state = "guns"
	req_access = list(ACCESS_MARINE_CREWMAN)
	vendor_role = list(JOB_TANK_CREW)
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

	listed_products = list(
		list("主武器枪械", -1, null, null),
		list("M49A 战斗步枪", 2, /obj/item/weapon/gun/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M37A2 泵动霰弹枪", 2, /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 冲锋枪", 2, /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK2", 2, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),

		list("主武器弹药", -1, null, null),
		list("整箱鹿弹 (12g)", 6, /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("整箱箭形弹 (12g)", 6, /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("整箱霰弹枪独头弹 (12g)", 6, /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M49A 弹匣 (10x24mm)", 12, /obj/item/ammo_magazine/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M39 高速弹匣 (10x20mm)", 12, /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A 弹匣 (10x24mm)", 12, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", 2, /obj/item/weapon/gun/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 战斗左轮手枪", 2, /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 制式手枪", 2, /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F 信号枪", 2, /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("副武器弹药", -1, null, null),
		list("VP70 弹匣 (9mm)", 10, /obj/item/ammo_magazine/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 快速装弹器 (.44)", 10, /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 弹匣 (9mm)", 10, /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("M4A3 穿甲弹匣 (9mm)", 6, /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),
		list("M4A3 空尖弹匣 (9mm)", 6, /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("VP78 弹匣 (9mm)", 8, /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),

		list("配件", -1, null, null),
		list("磁力枪背带", 2, /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", 4, /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("下挂手电握把", 4, /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),

		list("勤务服", -1, null, null),
		list("战斗手电筒", 2, /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("M5 刺刀", 2, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M89-S 信号照明弹包", 1, /obj/item/storage/box/flare/signal, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", 10, /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", 2, /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/vehicle_crew/populate_product_list(scale)
	return

//------------CLOTHING RACK---------------

GLOBAL_LIST_INIT(cm_vending_clothing_vehicle_crew, list(
		list("标准装备 (全部领取)", 0, null, null, null),
		list("手套", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("坦克乘员护甲", 0, /obj/item/clothing/suit/storage/marine/tanker, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("M50 坦克乘员头盔", 0, /obj/item/clothing/head/helmet/marine/tech/tanker, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("头盔医疗镜片", 0, /obj/item/device/helmet_visor/medical, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("焊接套件", 0, /obj/item/tool/weldpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("即食军粮", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("个人副武器 (任选一件)", 0, null, null, null),
		list("VP70 战斗手枪", 0, /obj/item/weapon/gun/pistol/vp70, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("VP78 手枪", 0, /obj/item/weapon/gun/pistol/vp78, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M103 车载弹药携行挂具", 0, /obj/item/storage/belt/tank, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 弹药携行挂具", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 通用手枪枪套挂具", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 枪套挂具", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用左轮手枪枪套挂具", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F 枪套挂具", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 霰弹装填挂具", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 工具携行腰带 (满装)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("照明弹袋 (满装)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型弹匣袋", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型霰弹袋", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("副武器袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工具袋 (满装)", 0, /obj/item/storage/pouch/tools/tank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),

		list("饰品 (任选一件)", 0, null, null, null),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("面罩 (任选一件)", 0, null, null, null),
		list("防毒面具", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("吸热头套", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("配件", 0, null, null, null),
		list("倾斜握把", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("加长枪管", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("陀螺稳定器", 10, /obj/item/attachable/gyro, null, VENDOR_ITEM_REGULAR),
		list("激光瞄准器", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("万能钥匙下挂霰弹枪", 10, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M37 木制枪托", 10, /obj/item/attachable/stock/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M39 枪托", 10, /obj/item/attachable/stock/smg, null, VENDOR_ITEM_REGULAR),
		list("M41A 固定枪托", 10, /obj/item/attachable/stock/rifle, null, VENDOR_ITEM_REGULAR),
		list("后坐补偿器", 10, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("红点瞄准镜", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("反射式瞄准镜", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("消音器", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("垂直握把", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("弹药", 0, null, null, null),
		list("M49A 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/m49a/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap , null, VENDOR_ITEM_REGULAR),
		list("M39 扩容弹匣 (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/extended , null, VENDOR_ITEM_REGULAR),
		list("M40 HEDP 手榴弹", 10, /obj/item/explosive/grenade/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M41A 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap , null, VENDOR_ITEM_REGULAR),
		list("M41A 扩容弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/extended , null, VENDOR_ITEM_REGULAR),
		list("M44 重型快速装弹器 (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("双筒望远镜", 10, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("燃料罐绑带袋", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("富尔顿回收装置组", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("大型霰弹袋", 10, /obj/item/storage/pouch/shotgun/large, null, VENDOR_ITEM_REGULAR),
		list("运动探测器", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("塑性炸药", 10, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("轮式担架床", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("哨子", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
	))

//MARINE_CAN_BUY_SHOES MARINE_CAN_BUY_UNIFORM currently not used
/obj/structure/machinery/cm_vending/clothing/vehicle_crew
	name = "ColMarTech载具乘员装备架"
	desc = "连接着巨型载具乘员制式装备仓库的自动装备架。"
	req_access = list(ACCESS_MARINE_CREWMAN)
	vendor_role = list(JOB_TANK_CREW)

/obj/structure/machinery/cm_vending/clothing/vehicle_crew/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_vehicle_crew

//------------ESSENTIAL SETS---------------

//Not essentials sets but fuck it the code's here
/obj/effect/essentials_set/tank/ltb
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
	)

/obj/effect/essentials_set/tank/gatling
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
	)

/obj/effect/essentials_set/tank/dragonflamer
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
	)

/obj/effect/essentials_set/tank/autocannon
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
	)

/obj/effect/essentials_set/tank/tankflamer
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/small_flamer,
		/obj/item/ammo_magazine/hardpoint/secondary_flamer,
	)

/obj/effect/essentials_set/tank/tow
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/towlauncher,
		/obj/item/ammo_magazine/hardpoint/towlauncher,
		/obj/item/ammo_magazine/hardpoint/towlauncher,
	)

/obj/effect/essentials_set/tank/m56cupola
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/m56cupola,
		/obj/item/ammo_magazine/hardpoint/m56_cupola,
	)

/obj/effect/essentials_set/tank/tankgl
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/grenade_launcher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
	)

/obj/effect/essentials_set/tank/turret
	spawned_gear_list = list(
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/ammo_magazine/hardpoint/turret_smoke,
		/obj/item/ammo_magazine/hardpoint/turret_smoke,
	)

/obj/effect/essentials_set/apc/dualcannon
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
	)

/obj/effect/essentials_set/apc/frontalcannon
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/frontalcannon,
		/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon,
	)

/obj/effect/essentials_set/apc/flarelauncher
	spawned_gear_list = list(
		/obj/item/hardpoint/support/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
	)
