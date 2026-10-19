/datum/autolathe/recipe
	var/name = "object"
	var/localized_name
	var/path
	var/list/resources
	var/hidden = FALSE
	var/category
	var/power_use = 0
	var/is_stack

/datum/autolathe/recipe/bucket
	name = "bucket"
	localized_name = "水桶"
	path = /obj/item/reagent_container/glass/bucket
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/mopbucket
	name = "mop bucket"
	localized_name = "拖把桶"
	path = /obj/item/reagent_container/glass/bucket/mopbucket
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/mopbucket
	name = "janitorial bucket"
	localized_name = "清洁水桶"
	path = /obj/item/reagent_container/glass/bucket/janibucket
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/flashlight
	name = "flashlight"
	localized_name = "手电筒"
	path = /obj/item/device/flashlight
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/extinguisher
	name = "extinguisher"
	localized_name = "灭火器"
	path = /obj/item/tool/extinguisher
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/crowbar
	name = "crowbar"
	localized_name = "撬棍"
	path = /obj/item/tool/crowbar
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/multitool
	name = "multitool"
	localized_name = "多用工具"
	path = /obj/item/device/multitool
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/t_scanner
	name = "T-ray scanner"
	localized_name = "太赫兹扫描仪"
	path = /obj/item/device/t_scanner
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/weldertool
	name = "blowtorch"
	localized_name = "焊炬"
	path = /obj/item/tool/weldingtool
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/screwdriver
	name = "screwdriver"
	localized_name = "螺丝刀"
	path = /obj/item/tool/screwdriver
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/wirecutters
	name = "wirecutters"
	localized_name = "剪线钳"
	path = /obj/item/tool/wirecutters
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/wrench
	name = "wrench"
	localized_name = "扳手"
	path = /obj/item/tool/wrench
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/mop
	name = "mop"
	localized_name = "拖把"
	path = /obj/item/tool/mop
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/radio_headset
	name = "radio headset"
	localized_name = "无线电耳机"
	path = /obj/item/device/radio/headset
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/radio_bounced
	name = "shortwave radio"
	localized_name = "短波无线电"
	path = /obj/item/device/radio/off
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/weldermask
	name = "welding mask"
	localized_name = "焊接面罩"
	path = /obj/item/clothing/head/welding
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/metal
	name = "steel sheets"
	localized_name = "钢板"
	path = /obj/item/stack/sheet/metal
	category = AUTOLATHE_CATEGORY_GENERAL
	is_stack = 1

/datum/autolathe/recipe/glass
	name = "glass sheets"
	localized_name = "玻璃板"
	path = /obj/item/stack/sheet/glass
	category = AUTOLATHE_CATEGORY_GENERAL
	is_stack = 1

/datum/autolathe/recipe/rglass
	name = "reinforced glass sheets"
	localized_name = "强化玻璃板"
	path = /obj/item/stack/sheet/glass/reinforced
	category = AUTOLATHE_CATEGORY_GENERAL
	is_stack = 1

/datum/autolathe/recipe/rods
	name = "metal rods"
	localized_name = "金属棒"
	path = /obj/item/stack/rods
	category = AUTOLATHE_CATEGORY_GENERAL
	is_stack = 1

/datum/autolathe/recipe/knife
	name = "kitchen knife"
	localized_name = "厨刀"
	path = /obj/item/tool/kitchen/knife
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/taperecorder
	name = "tape recorder"
	localized_name = "录音机"
	path = /obj/item/device/taperecorder
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/airlockmodule
	name = "airlock electronics"
	localized_name = "气闸门电路板"
	path = /obj/item/circuitboard/airlock
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/firealarm
	name = "fire alarm electronics"
	localized_name = "火灾警报器电路板"
	path = /obj/item/circuitboard/firealarm
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/powermodule
	name = "power control module"
	localized_name = "电力控制模块"
	path = /obj/item/circuitboard/apc
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/table_parts
	name = "table parts"
	localized_name = "桌子组件"
	path = /obj/item/frame/table
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/table_parts_reinforced
	name = "reinforced table parts"
	localized_name = "加固桌子组件"
	path = /obj/item/frame/table/reinforced
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/rack_parts
	name = "rack parts"
	localized_name = "置物架组件"
	path = /obj/item/frame/rack
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/scalpel
	name = "scalpel"
	localized_name = "手术刀"
	path = /obj/item/tool/surgery/scalpel
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/circularsaw
	name = "circular saw"
	localized_name = "圆锯"
	path = /obj/item/tool/surgery/circular_saw
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/surgicaldrill
	name = "surgical drill"
	localized_name = "手术钻"
	path = /obj/item/tool/surgery/surgicaldrill
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/retractor
	name = "retractor"
	localized_name = "牵开器"
	path = /obj/item/tool/surgery/retractor
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/cautery
	name = "cautery"
	localized_name = "烧灼器"
	path = /obj/item/tool/surgery/cautery
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/hemostat
	name = "hemostat"
	localized_name = "止血钳"
	path = /obj/item/tool/surgery/hemostat
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/beaker
	name = "glass beaker"
	localized_name = "玻璃烧杯"
	path = /obj/item/reagent_container/glass/beaker
	category = AUTOLATHE_CATEGORY_GLASSWARE

/datum/autolathe/recipe/beaker_large
	name = "large glass beaker"
	localized_name = "大型玻璃烧杯"
	path = /obj/item/reagent_container/glass/beaker/large
	category = AUTOLATHE_CATEGORY_GLASSWARE

/datum/autolathe/recipe/drinkingglass
	name = "drinking glass"
	localized_name = "玻璃杯"
	path = /obj/item/reagent_container/food/drinks/drinkingglass
	category = AUTOLATHE_CATEGORY_GLASSWARE

/datum/autolathe/recipe/consolescreen
	name = "console screen"
	localized_name = "控制台显示屏"
	path = /obj/item/stock_parts/console_screen
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/igniter
	name = "igniter"
	localized_name = "点火器"
	path = /obj/item/device/assembly/igniter
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/signaller
	name = "signaller"
	localized_name = "信号器"
	path = /obj/item/device/assembly/signaller
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/sensor_infra
	name = "infrared sensor"
	localized_name = "红外传感器"
	path = /obj/item/device/assembly/infra
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/timer
	name = "timer"
	localized_name = "定时器"
	path = /obj/item/device/assembly/timer
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/sensor_prox
	name = "proximity sensor"
	localized_name = "接近传感器"
	path = /obj/item/device/assembly/prox_sensor
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/tube
	name = "light tube"
	localized_name = "灯管"
	path = /obj/item/light_bulb/tube
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/bulb
	name = "light bulb"
	localized_name = "灯泡"
	path = /obj/item/light_bulb/bulb
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/ashtray_glass
	name = "glass ashtray"
	localized_name = "玻璃烟灰缸"
	path = /obj/item/ashtray/glass
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/hand_labeler
	name = "hand labeler"
	localized_name = "手持标签机"
	path = /obj/item/tool/hand_labeler
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/camera_assembly
	name = "camera assembly"
	localized_name = "摄像机组件"
	path = /obj/item/frame/camera
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/matrix_frame
	name = "matrix assembly"
	localized_name = "矩阵组件"
	path = /obj/item/frame/matrix_frame
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/electropack
	name = "electropack"
	localized_name = "电击背包"
	path = /obj/item/device/radio/electropack
	hidden = TRUE
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/handcuffs
	name = "handcuffs"
	localized_name = "手铐"
	path = /obj/item/restraint/handcuffs
	hidden = TRUE
	category = AUTOLATHE_CATEGORY_GENERAL

//Armylathe recipes
/datum/autolathe/recipe/armylathe

/datum/autolathe/recipe/armylathe/m40
	name = "M40 Grenade Casing"
	localized_name = "M40手榴弹壳体"
	path = /obj/item/explosive/grenade/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/m15
	name = "M15 Grenade Casing"
	localized_name = "M15手榴弹壳体"
	path = /obj/item/explosive/grenade/custom/large
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/m20
	name = "M20 Mine Casing"
	localized_name = "M20地雷壳体"
	path = /obj/item/explosive/mine/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/c4
	name = "C4 Plastic Casing"
	localized_name = "C4塑性炸药壳体"
	path = /obj/item/explosive/plastic/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/rocket_tube
	name = "88mm Rocket Tube"
	localized_name = "88毫米火箭弹筒"
	path = /obj/item/ammo_magazine/rocket/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/rocket_warhead
	name = "88mm Rocket Warhead"
	localized_name = "88毫米火箭弹战斗部"
	path = /obj/item/explosive/warhead/rocket
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/mortar_shell
	name = "80mm Mortar Shell"
	localized_name = "80毫米迫击炮弹壳体"
	path = /obj/item/mortar_shell/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/mortar_warhead
	name = "80mm Mortar Warhead"
	localized_name = "80毫米迫击炮弹战斗部"
	path = /obj/item/explosive/warhead/mortar
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/mortar_camera_warhead
	name = "80mm Mortar Camera Warhead"
	localized_name = "80毫米迫击炮摄像弹头"
	path = /obj/item/explosive/warhead/mortar/camera
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/flamer_tank
	name = "Custom M240A1 Fuel Tank"
	localized_name = "自制M240A1燃料罐"
	path = /obj/item/ammo_magazine/flamer_tank/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/large_flamer_tank
	name = "Custom M240-T Fuel Tank"
	localized_name = "自制M240-T燃料罐"
	path = /obj/item/ammo_magazine/flamer_tank/custom/large
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/smoke_tank
	name = "Custom M240A1 Smoke Tank"
	localized_name = "自制M240A1烟雾罐"
	path = /obj/item/ammo_magazine/flamer_tank/smoke
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

//Medilathe recipes
/datum/autolathe/recipe/medilathe
	category = AUTOLATHE_CATEGORY_MEDICAL

/datum/autolathe/recipe/medilathe/syringe
	name = "syringe"
	localized_name = "注射器"
	path = /obj/item/reagent_container/syringe

/datum/autolathe/recipe/medilathe/dropper
	name = "dropper"
	localized_name = "滴管"
	path = /obj/item/reagent_container/dropper

/datum/autolathe/recipe/medilathe/spray
	name = "spray bottle"
	localized_name = "喷雾瓶"
	path = /obj/item/reagent_container/spray

/datum/autolathe/recipe/medilathe/autoinjector
	name = "autoinjector (C-T) (5x3)"
	localized_name = "自动注射器 (C-T) (5x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty
	category = AUTOLATHE_CATEGORY_INJECTORS

/datum/autolathe/recipe/medilathe/autoinjector/s15x3
	name = "autoinjector (C-S) (15x3)"
	localized_name = "自动注射器 (C-S) (15x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/small

/datum/autolathe/recipe/medilathe/autoinjector/s30x3
	name = "autoinjector (C-M) (30x3)"
	localized_name = "自动注射器 (C-M) (30x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/medium

/datum/autolathe/recipe/medilathe/autoinjector/s60x3
	name = "autoinjector (C-L) (60x3)"
	localized_name = "自动注射器 (C-L) (60x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/large

/datum/autolathe/recipe/medilathe/autoinjector/s1x1
	name = "EZ autoinjector (E-U) (1x1)"
	localized_name = "EZ 自动注射器 (E-U) (1x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/unit

/datum/autolathe/recipe/medilathe/autoinjector/s5x1
	name = "EZ autoinjector (E-VS) (5x1)"
	localized_name = "EZ 自动注射器 (E-VS) (5x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/verysmall

/datum/autolathe/recipe/medilathe/autoinjector/s10x1
	name = "EZ autoinjector (E-S) (10x1)"
	localized_name = "EZ 自动注射器 (E-S) (10x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/small

/datum/autolathe/recipe/medilathe/autoinjector/s15x1
	name = "EZ autoinjector (E-T) (15x1)"
	localized_name = "EZ 自动注射器 (E-T) (15x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless

/datum/autolathe/recipe/medilathe/autoinjector/s30x1
	name = "EZ autoinjector (E-M) (30x1)"
	localized_name = "EZ 自动注射器 (E-M) (30x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/medium

/datum/autolathe/recipe/medilathe/autoinjector/s45x1
	name = "EZ autoinjector (E-L) (45x1)"
	localized_name = "EZ 自动注射器 (E-L) (45x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/large

/datum/autolathe/recipe/medilathe/autoinjector/s60x1
	name = "EZ autoinjector (E-XL) (60x1)"
	localized_name = "EZ 自动注射器 (E-XL) (60x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/extralarge

/datum/autolathe/recipe/medilathe/autoinjector/s15x6
	name = "Medic autoinjector (M-M) (15x6)"
	localized_name = "医用自动注射器 (M-M) (15x6)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/medic

/datum/autolathe/recipe/medilathe/autoinjector/s30x6
	name = "Medic Autoinjector (M-L) (30x6)"
	localized_name = "医用自动注射器 (M-L) (30x6)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/medic/large

/datum/autolathe/recipe/medilathe/hypospray
	name = "hypospray"
	localized_name = "无针注射器"
	path = /obj/item/reagent_container/hypospray

/datum/autolathe/recipe/medilathe/bloodpack
	name = "bloodpack"
	localized_name = "血袋"
	path = /obj/item/reagent_container/blood

/datum/autolathe/recipe/medilathe/bluespace
	name = "bluespace beaker"
	localized_name = "蓝空间烧杯"
	path = /obj/item/reagent_container/glass/beaker/bluespace

/datum/autolathe/recipe/medilathe/bonesetter
	name = "bonesetter"
	localized_name = "正骨器"
	path = /obj/item/tool/surgery/bonesetter

/datum/autolathe/recipe/medilathe/fixovein
	name = "FixOVein"
	localized_name = "血管修复器"
	path = /obj/item/tool/surgery/FixOVein

/datum/autolathe/recipe/medilathe/cryobag
	name = "stasis bag"
	localized_name = "静滞袋"
	path = /obj/item/bodybag/cryobag

/datum/autolathe/recipe/medilathe/rollerbed
	name = "rollerbed"
	localized_name = "滚轮床"
	path = /obj/item/roller

/datum/autolathe/recipe/medilathe/pill_bottle
	name = "pill bottle"
	localized_name = "药瓶"
	path = /obj/item/storage/pill_bottle
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_regular
	name = "first aid kit (reg)"
	localized_name = "急救套件（常规）"
	path = /obj/item/storage/firstaid/regular/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_fire
	name = "first aid kit (fire)"
	localized_name = "急救套件（烧伤）"
	path = /obj/item/storage/firstaid/fire/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_toxin
	name = "first aid kit (tox)"
	localized_name = "急救箱（中毒）"
	path = /obj/item/storage/firstaid/toxin/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_oxy
	name = "first aid kit (oxy)"
	localized_name = "急救箱（缺氧）"
	path = /obj/item/storage/firstaid/o2/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_adv
	name = "first aid kit (adv)"
	localized_name = "急救套件（高级）"
	path = /obj/item/storage/firstaid/adv/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_rad
	name = "first aid kit (rad)"
	localized_name = "急救套件（辐射）"
	path = /obj/item/storage/firstaid/rad/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/syringe_case
	name = "syringe case"
	localized_name = "注射器箱"
	path = /obj/item/storage/syringe_case
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/surgical_case
	name = "surgical case"
	localized_name = "手术器械箱"
	path = /obj/item/storage/surgical_case
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/vial_box
	name = "vial box"
	localized_name = "小瓶盒"
	path = /obj/item/storage/fancy/vials/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/surgical_tray
	name = "surgical tray"
	localized_name = "手术器械托盘"
	path = /obj/item/storage/surgical_tray/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/pressurized_reagent_container
	name = "Pressurized Reagent Canister Pouch"
	localized_name = "加压药剂罐袋"
	path = /obj/item/storage/pouch/pressurized_reagent_canister
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/pressurized_canister
	name = "Pressurized Canister"
	localized_name = "加压药剂罐"
	path = /obj/item/reagent_container/glass/pressurized_canister
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS
