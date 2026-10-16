//------------ CL CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_dress_corporate_liaison, list(
	list("外套与内衣", 0, null, null, null),
	list("黑色西装裤", 0, /obj/item/clothing/under/liaison_suit/black, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
	list("蓝色西装裤", 0, /obj/item/clothing/under/liaison_suit/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("棕色西装裤", 0, /obj/item/clothing/under/liaison_suit/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("白色西装裤", 0, /obj/item/clothing/under/liaison_suit/corporate_formal, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("联络员棕褐色外套", 0, /obj/item/clothing/under/liaison_suit, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("联络员炭灰色外套", 0, /obj/item/clothing/under/liaison_suit/charcoal, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("联络员白色外套", 0, /obj/item/clothing/under/liaison_suit/formal, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("联络员蓝色西装上衣", 0, /obj/item/clothing/under/liaison_suit/blazer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("联络员背带装", 0, /obj/item/clothing/under/liaison_suit/suspenders, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("联络员裙子", 0, /obj/item/clothing/under/blackskirt, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("学员制服", 0, /obj/item/clothing/under/suit_jacket/trainee, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("乡村俱乐部服装", 0, /obj/item/clothing/under/liaison_suit/ivy, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("橙色套装", 0, /obj/item/clothing/under/liaison_suit/orange, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("商务便装", 0, /obj/item/clothing/under/liaison_suit/field, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("灰色工作服", 0, /obj/item/clothing/under/colonist/workwear, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("卡其色工作服", 0, /obj/item/clothing/under/colonist/workwear/khaki, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("粉红色工作服", 0, /obj/item/clothing/under/colonist/workwear/pink, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("绿色工作服", 0, /obj/item/clothing/under/colonist/workwear/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

	list("外套", 0, null, null, null),
	list("黑色西装外套", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/black, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
	list("卡其色西装外套", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("棕色西装外套", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/brown, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("蓝色西装外套", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/blue, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("正式西装外套", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/formal, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("灰色飞行夹克", 0, /obj/item/clothing/suit/storage/jacket/marine/bomber/grey, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("红色飞行夹克", 0, /obj/item/clothing/suit/storage/jacket/marine/bomber/red, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("卡其色飞行夹克", 0, /obj/item/clothing/suit/storage/jacket/marine/bomber, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("棕色飞行夹克", 0, /obj/item/clothing/suit/storage/bomber, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("黑色飞行夹克", 0, /obj/item/clothing/suit/storage/bomber/alt, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("联络员冬季外套", 0, /obj/item/clothing/suit/storage/snow_suit/liaison, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("白大褂", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("灰色背心", 0, /obj/item/clothing/suit/storage/jacket/marine/vest/grey, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("棕色背心", 0, /obj/item/clothing/suit/storage/jacket/marine/vest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("棕褐色背心", 0, /obj/item/clothing/suit/storage/jacket/marine/vest/tan, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

	list("领带", 0, null, null, null),
	list("黑色领带", 0, /obj/item/clothing/accessory/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
	list("红色领带", 0, /obj/item/clothing/accessory/red, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("紫色领带", 0, /obj/item/clothing/accessory/purple, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("蓝色领带", 0, /obj/item/clothing/accessory/blue, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("绿色领带", 0, /obj/item/clothing/accessory/green, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("金色领带", 0, /obj/item/clothing/accessory/gold, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("特制领带", 0, /obj/item/clothing/accessory/horrible, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	list("眼镜", 0, null, null, null),
	list("百美克斯太阳镜", 0, /obj/item/clothing/glasses/sunglasses/big, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
	list("飞行员太阳镜", 0, /obj/item/clothing/glasses/sunglasses/aviator, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("太阳镜", 0, /obj/item/clothing/glasses/sunglasses, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("矫视型太阳镜", 0, /obj/item/clothing/glasses/sunglasses/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("矫视眼镜", 0, /obj/item/clothing/glasses/regular/hipster, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

	list("手套", 0, null, null, null),
	list("黑色手套", 0, /obj/item/clothing/gloves/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
	list("礼服手套", 0, /obj/item/clothing/gloves/marine/dress, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

	list("鞋子", 0, null, null, null),
	list("系带皮鞋, 黑色", 0, /obj/item/clothing/shoes/laceup, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_RECOMMENDED),
	list("系带皮鞋, 棕色", 0, /obj/item/clothing/shoes/laceup/brown, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
	list("运动鞋, 黑色", 0, /obj/item/clothing/shoes/black, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
	list("公司配发靴", 0, /obj/item/clothing/shoes/marine/civilian, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),

	list("帽子", 0, null, null, null),
	list("黑色贝雷帽", 0, /obj/item/clothing/head/beret/cm/black/civilian, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
	list("白色贝雷帽", 0, /obj/item/clothing/head/beret/cm/white/civilian, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
	list("软呢帽", 0, /obj/item/clothing/head/fedora, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

))

/obj/structure/machinery/cm_vending/clothing/dress/corporate_liaison
	name = "公司联络员个人衣柜"
	desc = "装有高管可能需要的全部衣物的衣柜。"
	icon_state = "wardrobe_vendor"
	vendor_theme = VENDOR_THEME_USCM
	show_points = FALSE
	req_access = list()
	vendor_role = list(JOB_CORPORATE_LIAISON, JOB_SURVIVOR, JOB_TRAINEE, JOB_JUNIOR_EXECUTIVE, JOB_EXECUTIVE, JOB_SENIOR_EXECUTIVE, JOB_EXECUTIVE_SPECIALIST, JOB_EXECUTIVE_SUPERVISOR, JOB_ASSISTANT_MANAGER, JOB_DIVISION_MANAGER, JOB_CHIEF_EXECUTIVE, JOB_DIRECTOR, JOB_WY_GOON_RESEARCHER)

/obj/structure/machinery/cm_vending/clothing/dress/corporate_liaison/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_dress_corporate_liaison
