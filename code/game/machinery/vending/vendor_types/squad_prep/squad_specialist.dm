//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_spec, list(
		list("武器专家套装 (任选一件)", 0, null, null, null),
		list("火箭筒手套装", 0, /obj/item/storage/box/spec/rocketeer, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("重型榴弹兵套装", 0, /obj/item/storage/box/spec/heavy_grenadier, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("火焰兵套装", 0, /obj/item/storage/box/spec/pyro, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("侦察狙击手（观测手）套装", 0, /obj/item/storage/box/spec/spotter, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("侦察狙击手（射手）套装", 0, /obj/item/storage/box/spec/sniper, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),
		list("侦察狙击手（反器材步枪射手）套装", 0, /obj/item/storage/box/spec/sniper/anti_materiel, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),

		list("额外侦察兵弹药", 0, null, null, null),
		list("A19 高速爆破弹匣 (10x24mm)", 40, /obj/item/ammo_magazine/rifle/m49a/custom/explosive, null, VENDOR_ITEM_REGULAR),
		list("A19 高速燃烧弹匣 (10x24mm)", 40, /obj/item/ammo_magazine/rifle/m49a/custom/incendiary, null, VENDOR_ITEM_REGULAR),
		list("A19 高速弹匣 (10x24mm)", 40, /obj/item/ammo_magazine/rifle/m49a/custom, null, VENDOR_ITEM_REGULAR),

		list("额外狙击手弹药", 0, null, null, null),
		list("M42A 防空弹匣 (10x28mm)", 40, /obj/item/ammo_magazine/sniper/flak, null, VENDOR_ITEM_REGULAR),
		list("M42A 燃烧弹匣 (10x28mm)", 40, /obj/item/ammo_magazine/sniper/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M42A 精确射击弹匣 (10x28mm 无壳弹)", 40, /obj/item/ammo_magazine/sniper, null, VENDOR_ITEM_REGULAR),
		list("XM43E1 精确射击弹匣 (10x99mm 无壳弹)", 40, /obj/item/ammo_magazine/sniper/anti_materiel, null, VENDOR_ITEM_REGULAR),

		list("额外火箭筒手弹药", 0, null, null, null),
		list("84mm 反装甲火箭弹", 40, /obj/item/ammo_magazine/rocket/ap, null, VENDOR_ITEM_REGULAR),
		list("84mm 高爆火箭弹", 40, /obj/item/ammo_magazine/rocket, null, VENDOR_ITEM_REGULAR),
		list("84mm 白磷火箭弹", 40, /obj/item/ammo_magazine/rocket/wp, null, VENDOR_ITEM_REGULAR),

		list("额外手榴弹", 0, null, null, null),
		list("M40 HEDP 手榴弹 x6", 40, /obj/effect/essentials_set/hedp_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP 燃烧弹手榴弹 x6", 40, /obj/effect/essentials_set/hidp_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M40 CCDP 化合物手榴弹 x6", 40, /obj/effect/essentials_set/ccdp_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-F 破片弹手榴弹 x6", 40, /obj/effect/essentials_set/agmf_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-I 燃烧弹手榴弹 x6", 40, /obj/effect/essentials_set/agmi_6_pack, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S 烟幕手榴弹 x6", 20, /obj/effect/essentials_set/agms_6_pack, null, VENDOR_ITEM_REGULAR),
		list("G2 电击手榴弹包 x6", 40, /obj/effect/essentials_set/sebb_6_pack, null, VENDOR_ITEM_REGULAR),

		list("额外喷火器燃料罐", 0, null, null, null),
		list("大型喷火器燃料罐", 40, /obj/item/ammo_magazine/flamer_tank/large, null, VENDOR_ITEM_REGULAR),
		list("大型喷火器燃料罐 (B) (绿色火焰)", 40, /obj/item/ammo_magazine/flamer_tank/large/B, null, VENDOR_ITEM_REGULAR),
		list("大型喷火器燃料罐 (X) (蓝色火焰)", 40, /obj/item/ammo_magazine/flamer_tank/large/X, null, VENDOR_ITEM_REGULAR),

	))

/obj/structure/machinery/cm_vending/gear/spec
	name = "ColMarTech小队武器专家用品架"
	desc = "供小队武器专家使用的自动装备架。"
	icon_state = "spec_gear"
	show_points = TRUE
	use_points = FALSE
	use_snowflake_points = TRUE
	vendor_role = list(JOB_SQUAD_SPECIALIST)
	req_access = list(ACCESS_MARINE_SPECPREP)

/obj/structure/machinery/cm_vending/gear/spec/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_spec


//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_specialist, list(
		list("标准装备 (全部领取)", 0, null, null, null),
		list("陆战队标准服装", 0, list(/obj/item/clothing/under/marine, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine, /obj/item/device/radio/headset/almayer/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("即食军粮", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("地图", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

		list("背包 (任选一件)", 0, null, null, null),
		list("背包", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("挎包", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("腰带 (任选一件)", 0, null, null, null),
		list("G8-A 通用杂物袋", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 弹药携行挂具", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用手枪枪套挂具", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 枪套挂具", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 通用左轮手枪枪套挂具", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F 枪套挂具", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 霰弹装填挂具", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("收纳袋 (任选两件)", 0, null, null, null),
		list("急救袋 (可补充注射器)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (夹板, 医用纱布, 烧伤药膏)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("急救袋 (药片包)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("照明弹袋 (满装)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("弹匣袋", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("霰弹袋", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("大型手枪弹匣袋", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("中型杂物袋", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("手枪袋", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("枪带袋", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("棕色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("黑色携行背心", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("肩部枪套", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("携行带", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("面罩 (任选一件)", 0, null, null, null),
		list("防毒面具", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("吸热头套", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("限配枪械", 0, null, null, null),
		list("VP78 手枪", 15, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪", 15, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", 0, null, null, null),
		list("M44 重型快速装弹器 (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),
		list("M44 精确射手快速装弹器 (.44)", 10, /obj/item/ammo_magazine/revolver/marksman, null, VENDOR_ITEM_REGULAR),
		list("M4A3 空尖弹匣", 5, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 穿甲弹匣", 5, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_REGULAR),
		list("VP78 弹匣", 5, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪弹匣 (.45)", 10, /obj/item/ammo_magazine/pistol/smart, null, VENDOR_ITEM_REGULAR),

		list("服装", 0, null, null, null),
		list("砍刀鞘 (满装)", 6, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("砍刀袋 (满装)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("USCM 无线电话背包", 15, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_REGULAR),
		list("燃料罐绑带袋", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("焊接护目镜", 3, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("大型杂物袋", 10, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("M276 式战斗工具携行腰带", 15, /obj/item/storage/belt/gun/utility, null, VENDOR_ITEM_REGULAR),
		list("自动注射器收纳袋 (满装)", 15, /obj/item/storage/pouch/autoinjector/full, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("轮式担架床", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("富尔顿回收装置组", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("灭火器 (便携式)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("运动探测器", 10, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("情报探测器", 10, /obj/item/device/motiondetector/intel, null, VENDOR_ITEM_REGULAR),
		list("哨子", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),

		list("双筒望远镜", 0, null, null, null),
		list("双筒望远镜", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("测距仪", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("激光目标指示器", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("头盔光学设备", 0, null, null, null),
		list("头盔医疗镜片", 15, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("焊接面罩", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("技能指导手册", 0, null, null, null),
		list("JTAC 技能指导手册", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("工程技能指导手册", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),

		list("无线电密钥", 0, null, null, null),
		list("工程无线电加密密钥", 5, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("情报无线电加密密钥", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC 无线电加密密钥", 5, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("补给无线电加密密钥", 5, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/specialist
	name = "ColMarTech小队武器专家装备架"
	desc = "连接着巨型小队武器专家制式装备仓库的自动装备架。"
	show_points = TRUE
	req_access = list(ACCESS_MARINE_SPECPREP)
	vendor_role = list(JOB_SQUAD_SPECIALIST)

/obj/structure/machinery/cm_vending/clothing/specialist/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_specialist

/obj/structure/machinery/cm_vending/clothing/specialist/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha

/obj/structure/machinery/cm_vending/clothing/specialist/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_BRAVO)
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo

/obj/structure/machinery/cm_vending/clothing/specialist/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_CHARLIE)
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie

/obj/structure/machinery/cm_vending/clothing/specialist/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_DELTA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta

//------------ESSENTIAL SETS---------------

/obj/effect/essentials_set/hedp_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
	)

/obj/effect/essentials_set/hefa_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
		/obj/item/explosive/grenade/high_explosive/frag,
	)

/obj/effect/essentials_set/hidp_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
	)

/obj/effect/essentials_set/ccdp_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
		/obj/item/explosive/grenade/phosphorus,
	)

/obj/effect/essentials_set/agmf_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
		/obj/item/explosive/grenade/high_explosive/airburst,
	)

/obj/effect/essentials_set/agmi_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
		/obj/item/explosive/grenade/incendiary/airburst,
	)

/obj/effect/essentials_set/agms_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
		/obj/item/explosive/grenade/smokebomb/airburst,
	)

/obj/effect/essentials_set/sebb_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
		/obj/item/explosive/grenade/sebb,
	)

/obj/effect/essentials_set/m15_4_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/high_explosive/m15,
		/obj/item/explosive/grenade/high_explosive/m15,
		/obj/item/explosive/grenade/high_explosive/m15,
		/obj/item/explosive/grenade/high_explosive/m15,
	)

// RMC sniper-vendor

/obj/effect/essentials_set/rmcdmr
	spawned_gear_list = list(
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/ammo_magazine/sniper/rmc,
		/obj/item/weapon/gun/rifle/sniper/rmc,
		/obj/item/clothing/glasses/night/m42_hms/rmc,
		/obj/item/attachable/bipod,
	)

/obj/effect/essentials_set/rmcsniper
	spawned_gear_list = list(
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/sniper,
		/obj/item/ammo_magazine/sniper,
		/obj/item/weapon/gun/rifle/sniper/M42A/silenced,
		/obj/item/clothing/glasses/night/m42_hms/rmc,
		/obj/item/attachable/bipod,
	)

GLOBAL_LIST_INIT(cm_vending_clothing_rmc_sniper, list(
		list("精准武器套装 (必选)", 0, null, null, null),
		list("必备狙击手套装", 0, /obj/effect/essentials_set/rmcsniper, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("必备精确射手套装", 0, /obj/effect/essentials_set/rmcdmr, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("头盔 (任选一件)", 0, null, null, null),
		list("Mk12 精确射手头盔", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/sniper/rmc, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),

		list("背包 (任选一件)", 0, null, null, null),
		list("重型背包", 0, /obj/item/storage/backpack/rmc/heavy, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("标准背包", 0, /obj/item/storage/backpack/rmc/medium, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("轻型背包", 0, /obj/item/storage/backpack/rmc/light, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("腰带 (任选一件)", 0, null, null, null),
		list("L70 式弹药携行挂具", 0, /obj/item/storage/belt/marine/rmc, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("L26 式通用杂物腰带", 0, /obj/item/storage/backpack/general_belt/rmc, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("L165 枪械腰带", 0, /obj/item/storage/belt/gun/l905, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("饰品 (任选一件)", 0, null, null, null),
		list("挂袋", 0, /obj/item/clothing/accessory/storage/droppouch/rmc, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("小型收纳袋", 0, /obj/item/clothing/accessory/storage/smallpouch/rmc, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("腰部枪套", 0, /obj/item/clothing/accessory/storage/holster/waist, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/specialist/rmc
	name = "维兰科技班组精确射手装备架"
	desc = "连接着巨型皇家陆战队侦察狙击手制式装备仓库的自动装备架。"
	icon_state = "spec_gear"
	req_access = list(ACCESS_TWE_SNIPERPREP)
	vendor_role = list(JOB_TWE_RMC_MARKSMAN)
	vendor_theme = VENDOR_THEME_COMPANY

/obj/structure/machinery/cm_vending/clothing/specialist/rmc/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_rmc_sniper
