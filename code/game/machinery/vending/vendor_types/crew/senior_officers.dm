/obj/structure/machinery/cm_vending/clothing/senior_officer
	name = "ColMarTech高级军官装备架"
	desc = "供高级军官使用的自动装备售货机。"
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_CHIEF_POLICE, JOB_CMO, JOB_XO, JOB_CHIEF_ENGINEER, JOB_CHIEF_REQUISITION, JOB_AUXILIARY_OFFICER)

/obj/structure/machinery/cm_vending/clothing/senior_officer/get_listed_products(mob/user)
	if(!user)
		var/list/combined = list()
		combined += GLOB.cm_vending_clothing_xo
		combined += GLOB.cm_vending_clothing_chief_engineer
		combined += GLOB.cm_vending_clothing_req_officer
		combined += GLOB.cm_vending_clothing_cmo
		combined += GLOB.cm_vending_clothing_military_police_chief
		return combined
	if(user.job == JOB_XO)
		return GLOB.cm_vending_clothing_xo
	else if(user.job == JOB_CHIEF_ENGINEER)
		return GLOB.cm_vending_clothing_chief_engineer
	else if(user.job == JOB_CHIEF_REQUISITION)
		return GLOB.cm_vending_clothing_req_officer
	else if(user.job == JOB_CMO)
		return GLOB.cm_vending_clothing_cmo
	else if(user.job == JOB_CHIEF_POLICE)
		return GLOB.cm_vending_clothing_military_police_chief
	else if(user.job == JOB_AUXILIARY_OFFICER)
		return GLOB.cm_vending_clothing_auxiliary_officer
	return ..()


//------------ CHIEF MP ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_military_police_chief, list(
		list("警务套装 (必选)", 0, null, null, null),
		list("必备警务套装", 0, /obj/effect/essentials_set/chiefmilitarypolice, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("标准装备 (全部领取)", 0, null, null, null),
		list("手套", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("CMP 制服", 0, /obj/item/clothing/under/marine/officer/warrant, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("耳机", 0, /obj/item/device/radio/headset/almayer/cmpcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("陆战队战斗靴", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("护甲 (全部领取)", 0, null, null, null),
		list("宪兵长 M3 护甲", 0, /obj/item/clothing/suit/storage/marine/MP/WO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("宪兵长 M10 头盔", 0, /obj/item/clothing/head/helmet/marine/MP/WO, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("CMP 贝雷帽", 0, /obj/item/clothing/head/beret/marine/mp/cmp, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("手枪箱 (任选一件)", 0, null, null, null),
		list("VP70 战斗手枪箱", 0, /obj/item/storage/box/guncase/vp70, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M44 战斗左轮手枪箱", 0, /obj/item/storage/box/guncase/m44, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M4A3 制式手枪箱", 0, /obj/item/storage/box/guncase/m4a3, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("背包 (任选一件)", 0, null, null, null),
		list("宪兵挎包", 0, /obj/item/storage/backpack/satchel/sec, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("腰带 (任选一件)", 0, null, null, null),
		list("M276 通用手枪枪套挂具", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用左轮手枪枪套挂具", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("中型杂物袋", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("手枪袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("面罩 (任选一件)", 0, null, null, null),
		list("防毒面具", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("吸热头套", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("呼吸调温器", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))


//------------ CHIEF ENGINEER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_chief_engineer, list(

		list("舰内装备", 0, null, null, null),

		list("标准装备 (全部领取)", 0, null, null, null),
		list("绝缘手套", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("耳机", 0, /obj/item/device/radio/headset/almayer/ce, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("工具腰带", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("陆战队战斗靴", 0, /obj/item/clothing/shoes/marine, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("焊接护目镜", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

		list("制服 (任选一件)", 0, null, null, null),
		list("总工程师制服", 0, /obj/item/clothing/under/marine/officer/ce, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("常服", 0, /obj/item/clothing/under/marine/officer/bridge, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("头盔 (任选一件)", 0, null, null, null),
		list("贝雷帽, 工程", 0, /obj/item/clothing/head/beret/eng, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("安全帽", 0, /obj/item/clothing/head/hardhat/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("巡逻帽", 0, /obj/item/clothing/head/cmcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("焊接头盔", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("外套 (任选一件)", 0, null, null, null),
		list("黑色反光背心", 0, /obj/item/clothing/suit/storage/hazardvest/black, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("蓝色反光背心", 0, /obj/item/clothing/suit/storage/hazardvest/blue, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("橙色反光背心", 0, /obj/item/clothing/suit/storage/hazardvest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("黄色反光背心", 0, /obj/item/clothing/suit/storage/hazardvest/yellow, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("USCM 常服外套", 0, /obj/item/clothing/suit/storage/jacket/marine/service, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("背包 (任选一件)", 0, null, null, null),
		list("皮革挎包", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("技术员胸挂", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("技术员焊接挎包", 0, /obj/item/storage/backpack/marine/engineerpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("技术员焊接背包", 0, /obj/item/storage/backpack/marine/engineerpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("焊接套件", 0, /obj/item/tool/weldpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工具袋 (满装)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("建材袋", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("电子器材袋 (满装)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("弹匣袋", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("霰弹袋", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("副武器袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("燃料罐绑带袋", 0, /obj/item/storage/pouch/flamertank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),


		list("个人副武器 (任选一件)", 0, null, null, null),
		list("M4A3 制式手枪", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("VP70 手枪", 0, /obj/item/storage/belt/gun/m4a3/vp70, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M44 左轮手枪", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("饰品 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("出勤装备", 0, null, null, null),

		list("战斗装备 (全部领取)", 0, null, null, null),
		list("军官 M3 护甲", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_REGULAR),
		list("陆战队战斗靴", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_REGULAR),
		list("激光目标指示器", 0, /obj/item/device/binoculars/range/designator, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("战斗头盔 (任选一件)", 0, null, null, null),
		list("军官 M10 头盔", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),
		list("M10 技术员头盔", 0, /obj/item/clothing/head/helmet/marine/tech, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),

		list("面罩 (任选一件)", 0, null, null, null),
		list("防毒面具", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("吸热头套", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("主武器枪械 (任选一件)", 0, null, null, null),
		list("M120 战术霰弹枪", 0, /obj/item/storage/box/guncase/shotguncombat, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK2", 0, /obj/item/storage/box/guncase/m41a, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("M240 火焰喷射器", 0, /obj/item/storage/box/guncase/flamer, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),

		list("备用装备", 0, null, null, null),
		list("技术员耳机", 15, /obj/item/device/radio/headset/almayer/mt, null, VENDOR_ITEM_REGULAR),

	))


//------------ CHIEF REQ ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_req_officer, list(

		list("标准装备 (全部领取)", 0, null, null, null),
		list("绝缘手套", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("军需官制服", 0, /obj/item/clothing/under/marine/officer/qm_suit, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("耳机", 0, /obj/item/device/radio/headset/almayer/qm, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("挎包", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("军需官夹克", 0, /obj/item/clothing/suit/storage/jacket/marine/RO, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("头部装备 (任选一件)", 0, null, null, null),
		list("军需官帽", 0, /obj/item/clothing/head/cmcap/khaki, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("军需官贝雷帽", 0, /obj/item/clothing/head/beret/marine/ro, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("军需帽", 0, /obj/item/clothing/head/cmcap/khaki, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("个人副武器 (任选一件)", 0, null, null, null),
		list("M4A3 制式手枪", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("VP70 手枪", 0, /obj/item/storage/belt/gun/m4a3/vp70, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M44 定制左轮手枪", 0, /obj/item/storage/belt/gun/m44/custom, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("战斗装备 (全部领取)", 0, null, null, null),
		list("军官 M3 护甲", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("军官 M10 头盔", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("陆战队战斗靴", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工具袋 (空)", 0, /obj/item/storage/pouch/tools, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("建材袋", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("备用装备", 0, null, null, null),
		list("橡皮印章", 10, /obj/item/tool/stamp/ro, null, VENDOR_ITEM_REGULAR),
	))


//------------ CHIEF MEDICAL OFFICER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_cmo, list(

		list("医疗套装 (必选)", 0, null, null, null),
		list("必备医疗套装", 0, /obj/effect/essentials_set/medical/doctor/cmo, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("标准装备", 0, null, null, null),
		list("手套", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("耳机", 0, /obj/item/device/radio/headset/almayer/cmo, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),

		list("眼部装备 (任选一件)", 0, null, null, null),
		list("医疗抬头显示眼镜", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("矫视型医疗抬头显示眼镜", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("试剂扫描抬头显示护目镜", 0, /obj/item/clothing/glasses/science, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("矫视型试剂扫描抬头显示护目镜", 0, /obj/item/clothing/glasses/science/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),

		list("制服 (任选一件)", 0, null, null, null),
		list("首席医疗官制服", 0, /obj/item/clothing/under/rank/chief_medical_officer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("医生制服", 0, /obj/item/clothing/under/rank/medical, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("绿色医用刷手服", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("蓝色医用刷手服", 0, /obj/item/clothing/under/rank/medical/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("浅蓝色医用刷手服", 0, /obj/item/clothing/under/rank/medical/lightblue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("紫色医用刷手服", 0, /obj/item/clothing/under/rank/medical/purple, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("橄榄绿医用刷手服", 0, /obj/item/clothing/under/rank/medical/olive, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("灰色医用刷手服", 0, /obj/item/clothing/under/rank/medical/grey, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("外套 (任选一件)", 0, null, null, null),
		list("白大褂", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_MRE, VENDOR_ITEM_RECOMMENDED),
		list("医疗围裙", 0, /obj/item/clothing/suit/chef/classic/medical, MARINE_CAN_BUY_MRE, VENDOR_ITEM_REGULAR),

		list("雪地装备 (仅供雪地使用)", 0, null, null, null),
		list("防寒外套", 0, /obj/item/clothing/suit/storage/snow_suit/doctor, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("巴拉克拉法帽", 0, /obj/item/clothing/mask/balaclava, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
		list("雪地围巾", 0, /obj/item/clothing/mask/tornscarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

		list("头部装备 (任选一件)", 0, null, null, null),
		list("首席医疗官大檐帽", 0, /obj/item/clothing/head/cmo, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("手术帽, 橙色", 0, /obj/item/clothing/head/surgery/orange, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("手术帽, 蓝色", 0, /obj/item/clothing/head/surgery/blue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("手术帽, 紫色", 0, /obj/item/clothing/head/surgery/purple, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("手术帽, 绿色", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("包 (任选一件)", 0, null, null, null),

		list("标准挎包", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("标准背包", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("医疗挎包", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("医疗背包", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("腰带 (任选一件)", 0, null, null, null),
		list("M276 救生医疗包 (满装)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 医疗携行挂具 (满装)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("个人副武器 (任选一件)", 0, null, null, null),
		list("M4A3 制式手枪", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("VP70 手枪", 0, /obj/item/storage/belt/gun/m4a3/vp70, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("M44 左轮手枪", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("战斗装备 (仅供战斗使用)", 0, null, null, null),
		list("军官 M3 护甲", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
		list("军官 M10 头盔", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_MANDATORY),
		list("陆战队战斗靴", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_MANDATORY),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救响应袋", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗收纳袋", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (比卡定)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/bicaridine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (克洛坦)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/kelotane, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (复苏混合剂 - 广效康复嗪)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (复苏混合剂 - 佩里达酮)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/revival_peri, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (广效康复嗪)", 0, /obj/item/storage/pouch/pressurized_reagent_canister/tricordrazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("加压药剂罐袋 (空)", 0, /obj/item/storage/pouch/pressurized_reagent_canister, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("备用装备", 0, null, null, null),
		list("医生耳机", 15, /obj/item/device/radio/headset/almayer/doc, null, VENDOR_ITEM_REGULAR),
		list("研究员耳机", 15, /obj/item/device/radio/headset/almayer/research, null, VENDOR_ITEM_REGULAR),
	))


/obj/effect/essentials_set/medical/doctor/cmo
	spawned_gear_list = list(
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer/soul,
		/obj/item/tool/surgery/surgical_line,
		/obj/item/tool/surgery/synthgraft,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/storage/syringe_case,
	)



//------------ EXECUTIVE OFFFICER ---------------

//------------WEAPON VENDOR---------------
GLOBAL_LIST_INIT(cm_vending_gear_xo, list(
		list("舰长 PRIMARY (任选一件)", 0, null, null, null),
		list("M41A MK1 脉冲步枪", 0, /obj/item/storage/box/guncase/m41aMK1AP, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),
		list("MK221 战术霰弹枪", 0, /obj/effect/essentials_set/xo/shotgunpreset, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

		list("主武器弹药", 0, null, null, null),
		list("M41A MK1 弹匣", 40, /obj/item/ammo_magazine/rifle/m41aMK1, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK1 穿甲弹匣", 60, /obj/item/ammo_magazine/rifle/m41aMK1/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("鹿弹", 20, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
		list("霰弹枪独头弹", 20, /obj/item/ammo_magazine/shotgun/slugs, null, VENDOR_ITEM_REGULAR),
		list("箭形弹", 20, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),

		list("专业套件 (任选一件)", 0, null, null, null),
		list("必备工兵套装", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),
		list("必备医疗套装", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),

		list("爆炸物", 0, null, null, null),
		list("HEDP 手榴弹包", 15, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("HEFA 手榴弹包", 15, /obj/item/storage/box/packet/hefa, null, VENDOR_ITEM_REGULAR),
		list("WP 手榴弹包", 15, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),

		list("导轨配件", 0, null, null, null),
		list("磁力枪背带", 12, /obj/item/attachable/magnetic_harness, null, VENDOR_ITEM_RECOMMENDED),
		list("红点瞄准镜", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("反射式瞄准镜", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("S4 2x 小型望远瞄准镜", 15, /obj/item/attachable/scope/mini, null, VENDOR_ITEM_REGULAR),

		list("下挂配件", 0, null, null, null),
		list("激光瞄准器", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("倾斜握把", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("垂直握把", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),
		list("下挂霰弹枪", 15, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("下挂灭火器", 15, /obj/item/attachable/attached_gun/extinguisher, null, VENDOR_ITEM_REGULAR),
		list("下挂火焰喷射器", 15, /obj/item/attachable/attached_gun/flamer, null, VENDOR_ITEM_REGULAR),
		list("下挂榴弹发射器", 5, /obj/item/attachable/attached_gun/grenade, null, VENDOR_ITEM_REGULAR),

		list("枪管配件", 0, null, null, null),
		list("加长枪管", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("后坐补偿器", 15, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("消音器", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),

		list("其他用品", 0, null, null, null),
		list("焊接面罩", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),
		list("绝缘手套", 3, /obj/item/clothing/gloves/yellow, null, VENDOR_ITEM_REGULAR),
		list("工兵铲", 1, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("磁力枪背带", 12, /obj/item/attachable/magnetic_harness, null, VENDOR_ITEM_RECOMMENDED),
		list("无线电话背包", 15, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_RECOMMENDED),
		list("运动探测器", 5, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED),
		list("砍刀鞘 (满装)", 5, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("双筒望远镜", 5,/obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("测距仪", 8, /obj/item/device/binoculars/range, null,  VENDOR_ITEM_REGULAR),
		list("激光目标指示器", 12, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_RECOMMENDED),
		list("富尔顿回收装置", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("太空清洁剂", 2, /obj/item/reagent_container/spray/cleaner, null, VENDOR_ITEM_REGULAR),
		list("哨子", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("手电筒", 1, /obj/item/device/flashlight, null, VENDOR_ITEM_REGULAR),
	))

/obj/effect/essentials_set/xo/shotgunpreset
	spawned_gear_list = list(
		/obj/item/weapon/gun/shotgun/combat,
		/obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/ammo_magazine/shotgun/slugs,
	)

/obj/structure/machinery/cm_vending/gear/executive_officer
	name = "ColMarTech副指挥官武器架"
	desc = "供副指挥官使用的自动武器架。提供一系列仅供舰船二号指挥官使用的武器。"
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_XO)
	icon_state = "guns"
	use_snowflake_points = TRUE

/obj/structure/machinery/cm_vending/gear/executive_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_xo

//------------UNIFORM/GEAR VENDOR---------------
GLOBAL_LIST_INIT(cm_vending_clothing_xo, list(
		list("战斗装备 (全部领取)", 0, null, null, null),
		list("军官 M3 护甲", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
		list("军官 M10 头盔", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_MANDATORY),
		list("陆战队战斗靴", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_MANDATORY),
		list("陆战队战斗手套", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),

		list("标准装备 (全部领取)", 0, null, null, null),
		list("耳机", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("挎包", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("即食军粮", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("制服 (任选一件)", 0, null, null, null),
		list("常服", 0, /obj/item/clothing/under/marine/officer/bridge, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("作战制服", 0, /obj/item/clothing/under/marine/officer/boiler, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("礼服", 0, /obj/effect/essentials_set/xoformal, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),

		list("个人武器 (任选一件)", 0, null, null, null),
		list("VP78 手枪", 0, /obj/item/storage/belt/gun/m4a3/vp78, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M4A3 制式手枪", 0, /obj/item/storage/belt/gun/m4a3/commander, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("VP70 手枪", 0, /obj/item/storage/belt/gun/m4a3/vp70, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),
		list("M44 左轮手枪", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),

		list("眼部装备 (任选一件)", 0, null, null, null),
		list("医疗抬头显示眼镜", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("安保抬头显示眼镜", 0, /obj/item/clothing/glasses/sunglasses/sechud, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("百美克斯个人太阳镜", 0, /obj/item/clothing/glasses/sunglasses/big, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("飞行员太阳镜", 0, /obj/item/clothing/glasses/sunglasses/aviator, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("帽子 (任选一件)", 0, null, null, null),
		list("军官贝雷帽", 0, /obj/item/clothing/head/beret/marine/chiefofficer, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("常服大檐帽", 0, /obj/item/clothing/head/marine/peaked/service, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("巡逻帽", 0, /obj/item/clothing/head/cmcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("军官帽", 0, /obj/item/clothing/head/cmcap/bridge, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("臂章", 0, null, null, null),
		list("太阳恶魔肩章", 1, /obj/item/clothing/accessory/patch/devils, null, VENDOR_ITEM_REGULAR),
		list("USCM 肩章", 1, /obj/item/clothing/accessory/patch, null, VENDOR_ITEM_REGULAR),


		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 弹药携行挂具", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 霰弹装填挂具", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 工具携行腰带 (满装)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 枪套式工具挂具 (满装)", 0, /obj/item/storage/belt/gun/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 救生医疗包 (满装)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 医疗携行挂具 (满装)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 枪套挂具", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F 枪套挂具", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 手榴弹携行挂具", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("宪兵腰带", 0, /obj/item/storage/belt/security/MP/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("自动注射器收纳袋", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("大型弹匣袋", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("大型霰弹袋", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("大型手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗收纳袋", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("医疗套件袋", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("手枪袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工具袋 (满装)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("建材袋", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("电子器材袋 (满装)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("照明弹袋 (满装)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("燃料罐绑带袋", 0, /obj/item/storage/pouch/flamertank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))



//------------ AUXILIARY SUPPORT OFFICER ---------------
GLOBAL_LIST_INIT(cm_vending_clothing_auxiliary_officer, list(

		list("标准装备 (全部领取)", 0, null, null, null),
		list("绝缘手套", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("军官制服", 0, /obj/item/clothing/under/marine/officer/bridge, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("耳机", 0, /obj/item/device/radio/headset/almayer/qm, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("辅助支援军官夹克", 0, /obj/item/clothing/suit/storage/jacket/marine/service/aso, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("包 (任选一件)", 0, null, null, null),
		list("USCM 技术员胸挂", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("皮革挎包", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("个人副武器 (任选一件)", 0, null, null, null),
		list("M4A3 制式手枪", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("VP70 手枪", 0, /obj/item/storage/belt/gun/m4a3/vp70, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M44 定制左轮手枪", 0, /obj/item/storage/belt/gun/m44/custom, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("帽子 (任选一件)", 0, null, null, null),
		list("贝雷帽, 绿色", 0, /obj/item/clothing/head/beret/cm, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("贝雷帽, 棕褐色", 0, /obj/item/clothing/head/beret/cm/tan, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("巡逻帽", 0, /obj/item/clothing/head/cmcap, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("军官帽", 0, /obj/item/clothing/head/cmcap/bridge, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
		list("常服大檐帽", 0, /obj/item/clothing/head/marine/peaked/service, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),

		list("战斗装备 (全部领取)", 0, null, null, null),
		list("军官 M3 护甲", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("军官 M10 头盔", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("陆战队战斗靴", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("大型杂物袋", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("工具袋 (空)", 0, /obj/item/storage/pouch/tools, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("建材袋", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/effect/essentials_set/chiefmilitarypolice
	spawned_gear_list = list(
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/storage/belt/security/MP/full,
		/obj/item/clothing/head/helmet/marine/MP/WO,
	)

/obj/effect/essentials_set/xoformal
	spawned_gear_list = list(
		/obj/item/clothing/suit/storage/jacket/marine/dress,
		/obj/item/clothing/head/marine/peaked,
		/obj/item/clothing/under/marine/dress,
	)
