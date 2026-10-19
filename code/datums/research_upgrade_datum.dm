/datum/research_upgrades
	///unique to every upgrade. not the name of the item. name of the upgrade
	var/name = "Upgrade."
	///name of upgrades, not items. Items are at research_upgrades.dm somewhere in item folder.
	var/desc = "something is broken. yippee!!"
	///which behavior should this type follow. Should this be completely excluded from the buy menu? should it be one of the dropdown options? or a normal item?
	var/behavior = RESEARCH_UPGRADE_EXCLUDE_BUY // should this be on the list?
	/// the price of the upgrade, refer to this: 500 is a runner, 8k is queen. T3 is usually 3k, woyer is 2k.
	var/value_upgrade = 1000
	///In which tab the upgrade should be.
	var/upgrade_type
	///Path to the item, upgrade, if any.
	var/item_reference
	///Clearance requirment to buy this upgrade. 5x is level 6. Why is it not that way? no one knows.
	var/clearance_req = 5
	///The change of price for item per purchase, recommended for mass producing stuff or limited upgrade.
	var/change_purchase = 0
	///the minimum price which we cant go any cheaper usually dont need to set this if change price is 0 or positive
	var/minimum_price = 0
	///the maximum price which we cant go any more expensive, usually dont need to set this if change price is 0 or negative
	var/maximum_price = INFINITY

///gets called once the product is purchased, override if you need to pass any special arguments or have special behavior on purchase.
/datum/research_upgrades/proc/on_purchase(turf/machine_loc)
	if(isnull(item_reference))
		return
	new item_reference(machine_loc)

/datum/research_upgrades/machinery
	name = "Machinery"
	behavior = RESEARCH_UPGRADE_CATEGORY // one on the dropdown choices you get

/datum/research_upgrades/machinery/autodoc
	name = "自动手术舱升级"
	behavior = RESEARCH_UPGRADE_EXCLUDE_BUY
	upgrade_type = ITEM_MACHINERY_UPGRADE

/datum/research_upgrades/machinery/autodoc/internal_bleed
	name = "自动手术舱内出血修复"
	desc = "一套供自动手术舱使用的数据与指令，可使其快速修复内出血。"
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 200
	clearance_req = 1

/datum/research_upgrades/machinery/autodoc/internal_bleed/on_purchase(turf/machine_loc)
	new /obj/item/research_upgrades/autodoc(machine_loc)

/datum/research_upgrades/machinery/autodoc/broken_bone
	name = "自动手术舱骨折修复"
	desc = "一套供自动手术舱使用的数据与指令，可使其复位骨折并涂抹接骨胶。"
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 2000
	clearance_req = 3

/datum/research_upgrades/machinery/autodoc/broken_bone/on_purchase(turf/machine_loc)
	new /obj/item/research_upgrades/autodoc/tier2(machine_loc)

/datum/research_upgrades/machinery/autodoc/organ_damage
	name = "自动手术舱器官损伤修复"
	desc = "一套供自动手术舱使用的数据与指令，可使其修复器官损伤。"
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 1500
	clearance_req = 2

/datum/research_upgrades/machinery/autodoc/organ_damage/on_purchase(turf/machine_loc)
	new /obj/item/research_upgrades/autodoc/tier3(machine_loc)

/datum/research_upgrades/machinery/autodoc/larva_removal
	name = "自动手术舱胚胎移除"
	desc = "一套供自动手术舱使用的数据与指令，可使其初步掌握移除未知生物留下的寄生虫的技术。"
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 4000
	clearance_req = 6

/datum/research_upgrades/machinery/autodoc/larva_removal/on_purchase(turf/machine_loc)
	new /obj/item/research_upgrades/autodoc/tier4(machine_loc)


/datum/research_upgrades/machinery/sleeper
	name = "医疗休眠舱升级"
	desc = "医疗休眠舱系统的研究升级模块。磁盘中的技术可让医疗休眠舱使用更多种类的药物，并升级透析软件。"
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 500
	item_reference = /obj/item/research_upgrades/sleeper
	upgrade_type = ITEM_MACHINERY_UPGRADE
	clearance_req = 1

/datum/research_upgrades/item
	name = "Items"
	behavior = RESEARCH_UPGRADE_CATEGORY

/datum/research_upgrades/item/research_credits
	name = "科研点数"
	desc = "将获得的数据出售给最近的维兰德-汤谷科研部门小组，换取8或9点科研点数。"
	value_upgrade = 2000
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	item_reference = /obj/item/research_upgrades/credits
	change_purchase = 500
	maximum_price = 5000
	clearance_req = 5

/datum/research_upgrades/item/laser_scalpel
	name = "激光手术刀"
	desc = "普通手术刀的先进耐用版本，能够轻松刺穿厚实的皮肤和几丁质。"
	value_upgrade = 3000
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	item_reference = /obj/item/tool/surgery/scalpel/laser/advanced
	clearance_req = 3

/datum/research_upgrades/item/incision_management
	name = "切口处理系统"
	desc = "这件神奇的器械宛如外科医生身体的延伸，能瞬间完成切口准备，让治疗步骤立即开始。"
	value_upgrade = 3000
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	clearance_req = 4
	item_reference = /obj/item/tool/surgery/scalpel/manager


/datum/research_upgrades/item/nanosplints
	name = "强化纤维夹板"
	desc = "一组由耐用碳纤维板制成、以柔性钛网格加固的夹板，每叠五块。"
	value_upgrade = 800
	clearance_req = 3
	change_purchase = -200
	minimum_price = 200
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE

/datum/research_upgrades/item/nanosplints/on_purchase(turf/machine_loc)
	new /obj/item/stack/medical/splint/nano/research(machine_loc, 5)//adjust this to change amount of nanosplints in a stack, cant be higher than five, go change max_amount in the nanosplint itself, then change it.

/datum/research_upgrades/item/flamer_tank
	name = "升级型焚烧器燃料罐"
	desc = "升级后的焚烧器燃料罐，容量更大，并能使用更强力的燃料。"
	value_upgrade = 300
	clearance_req = 1
	change_purchase = 100
	minimum_price = 100
	maximum_price = 1000
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	item_reference = /obj/item/ammo_magazine/flamer_tank/custom/upgraded

/datum/research_upgrades/item/flamer_tank/smoke
	name = "升级型焚烧器烟雾罐"
	desc = "升级后的焚烧器烟雾罐，容量更大。"
	value_upgrade = 100 //not useful enough to be expensive
	clearance_req = 1
	change_purchase = 50
	minimum_price = 100
	maximum_price = 500
	item_reference = /obj/item/ammo_magazine/flamer_tank/smoke/upgraded

/datum/research_upgrades/armor
	name = "Armor"
	behavior = RESEARCH_UPGRADE_CATEGORY

/datum/research_upgrades/armor/translator
	name = "通用翻译插板"
	desc = "可安装在制服上的插板，能够翻译穿戴者听到的任何未知语言。"
	value_upgrade = 2000
	behavior = RESEARCH_UPGRADE_ITEM
	clearance_req = 6
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/translator

/datum/research_upgrades/armor/coagulator
	name = "主动凝血插板"
	desc = "可安装在制服上的插板，能够使使用者身上出血的伤口凝血。"
	value_upgrade = 1200
	behavior = RESEARCH_UPGRADE_ITEM
	clearance_req = 2
	change_purchase = -200
	minimum_price = 200
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/coagulator


/datum/research_upgrades/armor/emergency_injector
	name = "医疗应急注射器"
	desc = "一块两侧各有一个按钮、配有大容量药剂罐的医疗插板。安装在制服上，同时按下两个按钮，即可注入远大于普通应急自动注射器剂量的急救药物。仅能使用一次，可在生物质打印机中回收。配有过量用药保护。"
	value_upgrade = 250
	clearance_req = 1
	behavior = RESEARCH_UPGRADE_ITEM
	change_purchase = -100
	minimum_price = 100
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/emergency_injector

/datum/research_upgrades/armor/ceramic
	name = "陶瓷护甲插板"
	desc = "一块坚固的防弹插板，可抵御大量子弹。对尖锐物体完全无效。"
	value_upgrade = 500
	clearance_req = 4
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ARMOR_UPGRADE
	change_purchase = -50
	minimum_price = 200
	item_reference = /obj/item/clothing/accessory/health/ceramic_plate

/datum/research_upgrades/armor/preservation
	name = "遗体保存插板"
	desc = "使用者死亡后启动的保存插板，利用多种物质和传感器减缓腐败，延长彻底死亡前的时间。防腐剂罐容量有限，每次死亡后都需要更换。可将彻底死亡的时限延长约四分钟。"
	value_upgrade = 500
	clearance_req = 4
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ARMOR_UPGRADE
	change_purchase = -100
	minimum_price = 100
	item_reference = /obj/item/clothing/accessory/health/research_plate/anti_decay
