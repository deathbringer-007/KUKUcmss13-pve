//------------ENGINEERING VENDORS---------------

/obj/structure/machinery/cm_vending/sorted/tech
	name = "工程售货机"
	desc = "你不该生成这一台。"
	icon_state = "tool"
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE
	hackable = TRUE
	req_one_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING)
	vendor_theme = VENDOR_THEME_COMPANY

/obj/structure/machinery/cm_vending/sorted/tech/tool_storage
	name = "工具储存机"
	desc = "储存各种通用维修工具与设备的大型机器。"
	icon_state = "tool"

/obj/structure/machinery/cm_vending/sorted/tech/tool_storage/populate_product_list(scale)
	listed_products = list(
		list("装备", -1, null, null),
		list("战斗手电筒", floor(scale * 2), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("安全帽", floor(scale * 2), /obj/item/clothing/head/hardhat, VENDOR_ITEM_REGULAR),
		list("绝缘手套", floor(scale * 2), /obj/item/clothing/gloves/yellow, VENDOR_ITEM_REGULAR),
		list("多用途工具腰带", floor(scale * 2), /obj/item/storage/belt/utility, VENDOR_ITEM_REGULAR),
		list("焊接护目镜", floor(scale * 2), /obj/item/clothing/glasses/welding, VENDOR_ITEM_REGULAR),
		list("焊接头盔", floor(scale * 2), /obj/item/clothing/head/welding, VENDOR_ITEM_REGULAR),
		list("工兵工具包", floor(scale * 2), /obj/item/storage/toolkit/empty, VENDOR_ITEM_REGULAR),

		list("扫描仪", -1, null, null),
		list("大气扫描仪", floor(scale * 2), /obj/item/device/analyzer, VENDOR_ITEM_REGULAR),
		list("爆破扫描仪", floor(scale * 1), /obj/item/device/demo_scanner, VENDOR_ITEM_REGULAR),
		list("介子扫描镜", floor(scale * 2), /obj/item/clothing/glasses/meson, VENDOR_ITEM_REGULAR),
		list("试剂扫描仪", floor(scale * 2), /obj/item/device/reagent_scanner, VENDOR_ITEM_REGULAR),
		list("太赫兹扫描仪", floor(scale * 2), /obj/item/device/t_scanner, VENDOR_ITEM_REGULAR),

		list("工具", -1, null, null),
		list("焊炬", floor(scale * 4), /obj/item/tool/weldingtool, VENDOR_ITEM_REGULAR),
		list("撬棍", floor(scale * 4), /obj/item/tool/crowbar, VENDOR_ITEM_REGULAR),
		list("ME3 手持焊炬", floor(scale * 2), /obj/item/tool/weldingtool/simple, VENDOR_ITEM_REGULAR),
		list("螺丝刀", floor(scale * 4), /obj/item/tool/screwdriver, VENDOR_ITEM_REGULAR),
		list("剪线钳", floor(scale * 4), /obj/item/tool/wirecutters, VENDOR_ITEM_REGULAR),
		list("扳手", floor(scale * 4), /obj/item/tool/wrench, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/tech/comtech_tools
	name = "ColMarTech小队战斗技术员工具售货机"
	desc = "储存各种战场实用备用工具的售货机。"
	icon_state = "tool"
	req_access = list(ACCESS_MARINE_ENGPREP)

/obj/structure/machinery/cm_vending/sorted/tech/comtech_tools/populate_product_list(scale)
	listed_products = list(
		list("装备", -1, null, null),
		list("多用途工具腰带", floor(scale * 4), /obj/item/storage/belt/utility, VENDOR_ITEM_REGULAR),
		list("电缆卷", floor(scale * 4), /obj/item/stack/cable_coil/random, VENDOR_ITEM_REGULAR),
		list("焊接护目镜", floor(scale * 2), /obj/item/clothing/glasses/welding, VENDOR_ITEM_REGULAR),
		list("工兵工具包", floor(scale * 2), /obj/item/storage/toolkit/empty, VENDOR_ITEM_REGULAR),

		list("工具", -1, null, null),
		list("焊炬", floor(scale * 4), /obj/item/tool/weldingtool, VENDOR_ITEM_REGULAR),
		list("撬棍", floor(scale * 4), /obj/item/tool/crowbar, VENDOR_ITEM_REGULAR),
		list("螺丝刀", floor(scale * 4), /obj/item/tool/screwdriver, VENDOR_ITEM_REGULAR),
		list("剪线钳", floor(scale * 4), /obj/item/tool/wirecutters, VENDOR_ITEM_REGULAR),
		list("扳手", floor(scale * 4), /obj/item/tool/wrench, VENDOR_ITEM_REGULAR),
		list("多功能工具", floor(scale * 4), /obj/item/device/multitool, VENDOR_ITEM_REGULAR),
		list("ME3 手持焊炬", floor(scale * 2), /obj/item/tool/weldingtool/simple, VENDOR_ITEM_REGULAR),

		list("多用途", -1, null, null),
		list("哨戒机枪网络笔记本电脑", 4, /obj/item/device/sentry_computer, VENDOR_ITEM_REGULAR),
		list("哨戒机枪网络加密密钥", 4, /obj/item/device/encryptionkey/sentry_laptop, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/tech/circuits
	name = "电路板售货机"
	desc = "安全储存预编程电路板的设备。内置陀螺仪可防止外力使电路板位移，配有厚实绝缘层，以及为各种 W-Y 专用设备充电的定制 2.1mm UPS 接口（设备另售）。"
	icon_state = "robotics"

/obj/structure/machinery/cm_vending/sorted/tech/circuits/populate_product_list(scale)
	listed_products = list(
		list("电路板", -1, null, null),
		list("火灾警报器", 5, /obj/item/circuitboard/firealarm, VENDOR_ITEM_REGULAR),
		list("APC", 6, /obj/item/circuitboard/apc, VENDOR_ITEM_REGULAR),
		list("自动车床", 2, /obj/item/circuitboard/machine/autolathe, VENDOR_ITEM_REGULAR),
		list("TC-4T 通讯", 1, /obj/item/circuitboard/machine/telecomms/relay/tower, VENDOR_ITEM_REGULAR),
		list("人员监测计算机", 2, /obj/item/circuitboard/computer/crew, VENDOR_ITEM_REGULAR),
		list("身份卡计算机", 2, /obj/item/circuitboard/computer/card, VENDOR_ITEM_REGULAR),
		list("安保档案", 2, /obj/item/circuitboard/computer/secure_data, VENDOR_ITEM_REGULAR),
		list("补给订购控制台", 2, /obj/item/circuitboard/computer/ordercomp, VENDOR_ITEM_REGULAR),
		list("科研数据终端", 2, /obj/item/circuitboard/computer/research_terminal, VENDOR_ITEM_REGULAR),
		list("P.A.C.M.A.N 发电机", 1, /obj/item/circuitboard/machine/pacman, VENDOR_ITEM_REGULAR),
		list("辅助储能装置", 2, /obj/item/circuitboard/machine/ghettosmes, VENDOR_ITEM_REGULAR),
		list("空气警报器电路", 2, /obj/item/circuitboard/airalarm, VENDOR_ITEM_REGULAR),
		list("安保摄像监视器", 2, /obj/item/circuitboard/computer/cameras, VENDOR_ITEM_REGULAR),
		list("电视机", 4, /obj/item/circuitboard/computer/cameras/tv, VENDOR_ITEM_REGULAR),
		list("空间站警报", 2, /obj/item/circuitboard/computer/stationalert, VENDOR_ITEM_REGULAR),
		list("街机", 2, /obj/item/circuitboard/computer/arcade, VENDOR_ITEM_REGULAR),
		list("大气监测仪", 2, /obj/item/circuitboard/computer/air_management, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/tech/tool_storage/antag
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	req_access = null

/obj/structure/machinery/cm_vending/sorted/tech/electronics_storage
	name = "电子器材售货机"
	desc = "备用工具售货机。怎么，你还指望这说明能妙语连珠？"
	icon_state = "engivend"

/obj/structure/machinery/cm_vending/sorted/tech/electronics_storage/populate_product_list(scale)
	listed_products = list(
		list("工具", -1, null, null),
		list("电缆卷", floor(scale * 3), /obj/item/stack/cable_coil/random, VENDOR_ITEM_REGULAR),
		list("多功能工具", floor(scale * 2), /obj/item/device/multitool, VENDOR_ITEM_REGULAR),

		list("电路板", -1, null, null),
		list("气闸门电路板", floor(scale * 4), /obj/item/circuitboard/airlock, VENDOR_ITEM_REGULAR),
		list("区域电力控制器电路板", floor(scale * 4), /obj/item/circuitboard/apc, VENDOR_ITEM_REGULAR),

		list("电池", -1, null, null),
		list("高容量电池", floor(scale * 3), /obj/item/cell/high, VENDOR_ITEM_REGULAR),
		list("低容量电池", floor(scale * 7), /obj/item/cell, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/tech/electronics_storage/antag
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	req_access = null

/obj/structure/machinery/cm_vending/sorted/tech/comp_storage
	name = "零件储存机"
	desc = "储存各种零件的大型机器。"
	icon_state = "engi"

/obj/structure/machinery/cm_vending/sorted/tech/comp_storage/populate_product_list(scale)
	listed_products = list(
		list("组装组件", -1, null, null),
		list("点火器", floor(scale * 8), /obj/item/device/assembly/igniter, VENDOR_ITEM_REGULAR),
		list("定时器", floor(scale * 4), /obj/item/device/assembly/timer, VENDOR_ITEM_REGULAR),
		list("接近传感器", floor(scale * 4), /obj/item/device/assembly/prox_sensor, VENDOR_ITEM_REGULAR),
		list("信号器", floor(scale * 4), /obj/item/device/assembly/signaller, VENDOR_ITEM_REGULAR),

		list("容器", -1, null, null),
		list("水桶", floor(scale * 6), /obj/item/reagent_container/glass/bucket, VENDOR_ITEM_REGULAR),
		list("拖把桶", floor(scale * 2), /obj/item/reagent_container/glass/bucket/mopbucket, VENDOR_ITEM_REGULAR),

		list("机器零件", -1, null, null),
		list("控制台屏幕", floor(scale * 4), /obj/item/stock_parts/console_screen, VENDOR_ITEM_REGULAR),
		list("物料仓", floor(scale * 4), /obj/item/stock_parts/matter_bin, VENDOR_ITEM_REGULAR),
		list("微型激光器", floor(scale * 4), /obj/item/stock_parts/micro_laser , VENDOR_ITEM_REGULAR),
		list("微型机械臂", floor(scale * 4), /obj/item/stock_parts/manipulator, VENDOR_ITEM_REGULAR),
		list("扫描模块", floor(scale * 4), /obj/item/stock_parts/scanning_module, VENDOR_ITEM_REGULAR),
		list("电容器", floor(scale * 3), /obj/item/stock_parts/capacitor, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/tech/comp_storage/antag
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	req_access = null

//------COLONY-SPECIFIC VENDORS-------

/obj/structure/machinery/cm_vending/sorted/tech/science
	name = "维兰德-汤谷科研售货机"
	desc = "提供实验所需基础设备的售货机。"
	icon_state = "robotics"
	req_access = list(ACCESS_MARINE_RESEARCH)

/obj/structure/machinery/cm_vending/sorted/tech/science/populate_product_list(scale)
	listed_products = list(
		list("装备", -1, null, null),
		list("生化防护头罩", 2, /obj/item/clothing/head/bio_hood, VENDOR_ITEM_REGULAR),
		list("生化防护服", 2, /obj/item/clothing/suit/bio_suit, VENDOR_ITEM_REGULAR),
		list("科学家连体服", 2, /obj/item/clothing/under/rank/scientist, VENDOR_ITEM_REGULAR),

		list("组装组件", -1, null, null),
		list("点火器", floor(scale * 8), /obj/item/device/assembly/igniter, VENDOR_ITEM_REGULAR),
		list("接近传感器", floor(scale * 4), /obj/item/device/assembly/prox_sensor, VENDOR_ITEM_REGULAR),
		list("信号器", floor(scale * 4), /obj/item/device/assembly/signaller, VENDOR_ITEM_REGULAR),
		list("储罐传输阀", floor(scale * 4), /obj/item/device/transfer_valve, VENDOR_ITEM_REGULAR),
		list("定时器", floor(scale * 4), /obj/item/device/assembly/timer, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/tech/robotics
	name = "机器人科技豪华售货机"
	desc = "打造自己的机器人大军所需的工具一应俱全。"
	icon_state = "robotics"
	req_access = list(ACCESS_MARINE_RESEARCH)

/obj/structure/machinery/cm_vending/sorted/tech/robotics/populate_product_list(scale)
	listed_products = list(
		list("装备", -1, null, null),
		list("白大褂", 2, /obj/item/clothing/suit/storage/labcoat, VENDOR_ITEM_REGULAR),
		list("医用口罩", 2, /obj/item/clothing/mask/breath/medical, VENDOR_ITEM_REGULAR),
		list("机器人工程师连体服", 2, /obj/item/clothing/under/rank/roboticist, VENDOR_ITEM_REGULAR),

		list("工具", -1, null, null),
		list("电缆卷", 4, /obj/item/stack/cable_coil/random, VENDOR_ITEM_REGULAR),
		list("圆锯", 2, /obj/item/tool/surgery/circular_saw, VENDOR_ITEM_REGULAR),
		list("撬棍", 2, /obj/item/tool/crowbar, VENDOR_ITEM_REGULAR),
		list("手术刀", 2, /obj/item/tool/surgery/scalpel, VENDOR_ITEM_REGULAR),
		list("螺丝刀", 2, /obj/item/tool/screwdriver, VENDOR_ITEM_REGULAR),

		list("组装组件", -1, null, null),
		list("闪光器", 4, /obj/item/device/flash, VENDOR_ITEM_REGULAR),
		list("高容量电池", 4, /obj/item/cell/high, VENDOR_ITEM_REGULAR),
		list("接近传感器", 4, /obj/item/device/assembly/prox_sensor, VENDOR_ITEM_REGULAR),
		list("信号器", 4, /obj/item/device/assembly/signaller, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("麻醉气罐", 2, /obj/item/tank/anesthetic, VENDOR_ITEM_REGULAR),
		list("健康诊断设备", 2, /obj/item/device/healthanalyzer/soul, VENDOR_ITEM_REGULAR)
	)

