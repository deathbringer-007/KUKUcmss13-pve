
//----------------------MEDVENDORS--------------------

//Vehicle version of NanoMed
/obj/structure/machinery/cm_vending/sorted/medical/wall_med/vehicle
	name = "车载纳米医疗柜"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "nanomed"
	desc = "壁挂式售货机，内含生存必需的医疗用品。"

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE
	hackable = FALSE

	chem_refill = list(
		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol,
	)

//MED APC version of WY Med, provides resupply for basic stuff. Tailored for syringe application of meds, rather than pills or autoinjector
/obj/structure/machinery/cm_vending/sorted/medical/vehicle
	name = "维兰医疗补给站"
	desc = "广受欢迎的维兰医疗加强型医药分配机的紧凑车载版，专为医疗人员的战地补给而设计。由维兰德-汤谷制药部门(TM)提供。"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "med"

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE
	wrenchable = FALSE
	hackable = FALSE
	density = FALSE

	req_access = list()

	healthscan = TRUE
	chem_refill = list(
		/obj/item/reagent_container/hypospray/autoinjector/bicaridine,
		/obj/item/reagent_container/hypospray/autoinjector/dexalinp,
		/obj/item/reagent_container/hypospray/autoinjector/adrenaline,
		/obj/item/reagent_container/hypospray/autoinjector/inaprovaline,
		/obj/item/reagent_container/hypospray/autoinjector/kelotane,
		/obj/item/reagent_container/hypospray/autoinjector/oxycodone,
		/obj/item/reagent_container/hypospray/autoinjector/tramadol,
		/obj/item/reagent_container/hypospray/autoinjector/tricord,

		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol,

		/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/tricord/skillless,
		)

/obj/structure/machinery/cm_vending/sorted/medical/vehicle/populate_product_list(scale)
	listed_products = list(
		list("战地用品", -1, null, null),
		list("烧伤治疗包", floor(scale * 4), /obj/item/stack/medical/advanced/ointment, VENDOR_ITEM_REGULAR),
		list("创伤治疗包", floor(scale * 4), /obj/item/stack/medical/advanced/bruise_pack, VENDOR_ITEM_REGULAR),
		list("烧伤药膏", floor(scale * 5), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("医用纱布卷", floor(scale * 5), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("夹板", floor(scale * 5), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),
		list("生理盐水输液袋", floor(scale * 2), /obj/item/reagent_container/blood/saline, VENDOR_ITEM_REGULAR),

		list("药液瓶", -1, null, null),
		list("瓶 (比卡定)", floor(scale * 3), /obj/item/reagent_container/glass/bottle/bicaridine, VENDOR_ITEM_REGULAR),
		list("瓶 (右氧林)", floor(scale * 2), /obj/item/reagent_container/glass/bottle/dexalin, VENDOR_ITEM_REGULAR),
		list("瓶 (迪洛文)", floor(scale * 3), /obj/item/reagent_container/glass/bottle/antitoxin, VENDOR_ITEM_REGULAR),
		list("瓶 (因纳普罗伐林)", floor(scale * 3), /obj/item/reagent_container/glass/bottle/inaprovaline, VENDOR_ITEM_REGULAR),
		list("瓶 (克洛坦)", floor(scale * 3), /obj/item/reagent_container/glass/bottle/kelotane, VENDOR_ITEM_REGULAR),
		list("瓶 (羟考酮)", floor(scale * 2), /obj/item/reagent_container/glass/bottle/oxycodone, VENDOR_ITEM_REGULAR),
		list("瓶 (佩里达酮)", floor(scale * 2), /obj/item/reagent_container/glass/bottle/peridaxon, VENDOR_ITEM_REGULAR),
		list("瓶 (曲马多)", floor(scale * 3), /obj/item/reagent_container/glass/bottle/tramadol, VENDOR_ITEM_REGULAR),
		list("瓶 (广效康复嗪)", floor(scale * 3), /obj/item/reagent_container/glass/bottle/tricordrazine, VENDOR_ITEM_REGULAR),

		list("医疗器具", -1, null, null),
		list("手术缝合线", floor(scale * 2), /obj/item/tool/surgery/surgical_line, VENDOR_ITEM_REGULAR),
		list("合成皮肤移植剂", floor(scale * 2), /obj/item/tool/surgery/synthgraft, VENDOR_ITEM_REGULAR),
		list("健康诊断设备", floor(scale * 2), /obj/item/device/healthanalyzer/soul, VENDOR_ITEM_REGULAR),
		list("无针注射器", floor(scale * 3), /obj/item/reagent_container/hypospray, VENDOR_ITEM_REGULAR),
		list("注射器", floor(scale * 3), /obj/item/reagent_container/syringe, VENDOR_ITEM_REGULAR)
	)

//MED APC version of Blood Dispenser, much more limited stock than the baseline vendor. Encourages matching blood types rather than using universal all the time
/obj/structure/machinery/cm_vending/sorted/medical/blood/vehicle
	name = "陆战医疗血袋分配机"
	desc = "供载具使用的陆战医疗牌血袋分配机。"
	icon = 'icons/obj/vehicles/interiors/general.dmi'

	req_access = list()

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE
	wrenchable = FALSE
	hackable = FALSE
	density = FALSE

/obj/structure/machinery/cm_vending/sorted/medical/blood/vehicle/populate_product_list(scale)
	listed_products = list(
		list("血袋", -1, null, null),
		list("A+ 血袋", floor(scale * 2), /obj/item/reagent_container/blood/APlus, VENDOR_ITEM_REGULAR),
		list("A- 血袋", floor(scale * 2), /obj/item/reagent_container/blood/AMinus, VENDOR_ITEM_REGULAR),
		list("B+ 血袋", floor(scale * 2), /obj/item/reagent_container/blood/BPlus, VENDOR_ITEM_REGULAR),
		list("B- 血袋", floor(scale * 2), /obj/item/reagent_container/blood/BMinus, VENDOR_ITEM_REGULAR),
		list("O+ 血袋", floor(scale * 1), /obj/item/reagent_container/blood/OPlus, VENDOR_ITEM_REGULAR),
		list("O- 血袋", floor(scale * 3), /obj/item/reagent_container/blood/OMinus, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("空血袋", floor(scale * 2), /obj/item/reagent_container/blood, VENDOR_ITEM_REGULAR)
	)

//----------------------SUPPLY VENDORS--------------------

//Combined vehicle version of req guns and ammo vendors. Starts, basically, empty, but can become a resupply point if marines bother to stock it with ammo and weapons.
/obj/structure/machinery/cm_vending/sorted/vehicle_supply
	name = "ColMarTech自动补给售货机"
	desc = "连接着载具内枪械、爆炸物和弹药仓库的自动补给架，用于在前沿作战基地与前线之间储运物资。"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "supply"
	vendor_theme = VENDOR_THEME_USCM

	req_access = list()

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE
	wrenchable = FALSE
	hackable = FALSE
	density = FALSE

	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_LOAD_AMMO_BOXES

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/get_examine_text(mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_INFO("[SPAN_HELPFUL("按住 CTRL 点击")][src]，即可使用附近物资进行补货。")

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/clicked(mob/user, list/mods)
	if(mods[CTRL_CLICK])
		if(!CAN_PICKUP(user, src))
			return ..()
		initiate_autorestock(user)
		return TRUE
	. = ..()

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/proc/initiate_autorestock(mob/living/carbon/human/user)
	if(!ishuman(user))
		return

	if(being_restocked)
		to_chat(user, SPAN_WARNING("[src]正在补货，你会妨碍操作！"))
		return

	being_restocked = TRUE

	user.visible_message(SPAN_NOTICE("[user]开始向[src]补充一批物资。"),
	SPAN_NOTICE("你开始向[src]补充一批物资。"))

	//done this way because for obj in range creates a list and goes through list even if items themselves being picked up or moved.
	while(being_restocked)
		if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, src))
			user.visible_message(SPAN_NOTICE("[user]停止向[src]补充物资。"),
			SPAN_NOTICE("你停止向[src]补充物资。"))
			being_restocked = FALSE
			return

		being_restocked = FALSE
		for(var/obj/item/I in range(1, src))
			if(stock(I))
				being_restocked = TRUE
				break

	user.visible_message(SPAN_NOTICE("[user]完成了[src]的物资补充。"),
	SPAN_NOTICE("你完成了[src]的物资补充。"))
	return

//combined from req guns and ammo vendors
/obj/structure/machinery/cm_vending/sorted/vehicle_supply/populate_product_list(scale)
	listed_products = list(
		list("主武器枪械", -1, null, null),
		list("M37A2 泵动霰弹枪", floor(scale * 3), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 冲锋枪", floor(scale * 2.5), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A 脉冲步枪 MK2", floor(scale * 4), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),
		list("M49A 战斗步枪", floor(scale * 2), /obj/item/weapon/gun/rifle/m49a, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", floor(scale * 2), /obj/item/weapon/gun/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("M44 战斗左轮手枪", floor(scale * 1.5), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 制式手枪", floor(scale * 2.5), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),

		list("爆炸物", -1, null, null),
		list("M15 破片手榴弹", 0, /obj/item/explosive/grenade/high_explosive/m15, VENDOR_ITEM_REGULAR),
		list("M20A2 阔剑反步兵地雷", 0, /obj/item/explosive/mine/strong, VENDOR_ITEM_REGULAR),
		list("M40 HEDP 手榴弹", 0, /obj/item/explosive/grenade/high_explosive, VENDOR_ITEM_REGULAR),
		list("M40 HIDP 燃烧手榴弹", 0, /obj/item/explosive/grenade/incendiary, VENDOR_ITEM_REGULAR),
		list("M40 CCDP 化合物烟幕手榴弹", 0, /obj/item/explosive/grenade/phosphorus, VENDOR_ITEM_REGULAR),
		list("M40 HSDP 烟幕手榴弹", floor(scale * 1), /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag 空爆榴弹", 0, /obj/item/explosive/grenade/high_explosive/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-燃烧弹空爆榴弹", 0, /obj/item/explosive/grenade/incendiary/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-烟幕空爆榴弹", 0, /obj/item/explosive/grenade/smokebomb/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-照明弹", 2, /obj/item/explosive/grenade/high_explosive/airburst/starshell, VENDOR_ITEM_REGULAR),
		list("M74 AGM-蜂群弹", 0, /obj/item/explosive/grenade/high_explosive/airburst/hornet_shell, VENDOR_ITEM_REGULAR),
		list("M40 HIRR 警棍弹", floor(scale * 2), /obj/item/explosive/grenade/slug/baton, VENDOR_ITEM_REGULAR),
		list("M40 MFHS 金属泡沫手榴弹", 0, /obj/item/explosive/grenade/metal_foam, VENDOR_ITEM_REGULAR),
		list("破障炸药", 0, /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),
		list("塑性炸药", 2, /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),

		list("普通弹药", -1, null, null),
		list("整箱鹿弹", floor(scale * 3), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("整箱箭形弹", floor(scale * 2), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("整箱霰弹枪独头弹", floor(scale * 4), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M49A 弹匣 (10x24mm)", floor(scale * 5), /obj/item/ammo_magazine/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M41A MK2 弹匣 (10x24mm)", floor(scale * 10), /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),
		list("M39 高速弹匣 (10x20mm)", floor(scale * 6), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M44 快速装弹器 (.44)", floor(scale * 4), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 弹匣 (9mm)", floor(scale * 10), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("VP70 弹匣 (9mm)", floor(scale * 8), /obj/item/ammo_magazine/pistol/vp70, VENDOR_ITEM_REGULAR),

		list("穿甲弹药", -1, null, null),
		list("M49A 穿甲弹匣 (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m49a/ap, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", 0, /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_REGULAR),
		list("M41A MK2 穿甲弹匣 (10x24mm)", 0, /obj/item/ammo_magazine/rifle/ap, VENDOR_ITEM_REGULAR),
		list("M4A3 穿甲弹匣 (9mm)", 0, /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),

		list("扩容弹药", -1, null, null),
		list("M39 扩容弹匣 (10x20mm)", 0, /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("M41A MK2 扩容弹匣 (10x24mm)", 0, /obj/item/ammo_magazine/rifle/extended, VENDOR_ITEM_REGULAR),

		list("专家弹药", -1, null, null),
		list("A19 高速高冲击弹匣 (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m49a/custom/explosive, VENDOR_ITEM_REGULAR),
		list("A19 高速燃烧弹匣 (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m49a/custom/incendiary, VENDOR_ITEM_REGULAR),
		list("A19 高速弹匣 (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m49a/custom, VENDOR_ITEM_REGULAR),
		list("M42A 防空弹匣 (10x28mm)", 0, /obj/item/ammo_magazine/sniper/flak, VENDOR_ITEM_REGULAR),
		list("M42A 燃烧弹匣 (10x28mm)", 0, /obj/item/ammo_magazine/sniper/incendiary, VENDOR_ITEM_REGULAR),
		list("M42A 精确射击弹匣 (10x28mm 无壳弹)", 0, /obj/item/ammo_magazine/sniper, VENDOR_ITEM_REGULAR),
		list("84mm 反装甲火箭弹", 0, /obj/item/ammo_magazine/rocket/ap, VENDOR_ITEM_REGULAR),
		list("84mm 高爆火箭弹", 0, /obj/item/ammo_magazine/rocket, VENDOR_ITEM_REGULAR),
		list("84mm 白磷火箭弹", 0, /obj/item/ammo_magazine/rocket/wp, VENDOR_ITEM_REGULAR),
		list("大型喷火器燃料罐", 0, /obj/item/ammo_magazine/flamer_tank/large, VENDOR_ITEM_REGULAR),
		list("大型喷火器燃料罐 (B) (绿色火焰)", 0, /obj/item/ammo_magazine/flamer_tank/large/B, VENDOR_ITEM_REGULAR),
		list("大型喷火器燃料罐 (X) (蓝色火焰)", 0, /obj/item/ammo_magazine/flamer_tank/large/X, VENDOR_ITEM_REGULAR),

		list("限配枪械弹药", -1, null, null),
		list("M2C 弹箱", 0, /obj/item/ammo_magazine/m2c, VENDOR_ITEM_REGULAR),
		list("M240 喷火器燃料罐", 1, /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		list("M41A MK1 弹匣 (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M41AE2 弹箱 (10x24mm)", 0, /obj/item/ammo_magazine/hpr_box, VENDOR_ITEM_REGULAR),
		list("M41AE2 全息标记弹 (10x24mm)", 0, /obj/item/ammo_magazine/hpr_box/holo_target, VENDOR_ITEM_REGULAR),
		list("M44 重型快速装弹器 (.44)", 0, /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 精确射手快速装弹器 (.44)", 0, /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),
		list("M4A3 空尖弹匣 (9mm)", 0, /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("M56 电池", 0, /obj/item/smartgun_battery, VENDOR_ITEM_REGULAR),
		list("M56 智能机枪弹鼓", 0, /obj/item/ammo_magazine/smartgun, VENDOR_ITEM_REGULAR),
		list("M56D 弹鼓",0, /obj/item/ammo_magazine/m56d, VENDOR_ITEM_REGULAR),
		list("SU-6 智能手枪弹匣 (.45)", floor(scale * 2), /obj/item/ammo_magazine/pistol/smart, VENDOR_ITEM_REGULAR),
		list("VP78 弹匣", floor(scale * 1.5), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),

		list("建筑材料", -1, null, null),
		list("纸板 x10", 1, /obj/item/stack/sheet/cardboard/small_stack, VENDOR_ITEM_REGULAR),
		list("带刺铁丝 x10", 0, /obj/item/stack/barbed_wire/small_stack, VENDOR_ITEM_REGULAR),
		list("金属 x10", 0, /obj/item/stack/sheet/metal/small_stack, VENDOR_ITEM_REGULAR),
		list("塑钢 x10", 0, /obj/item/stack/sheet/plasteel/small_stack, VENDOR_ITEM_REGULAR),
		list("沙袋 (空) x10", 1, /obj/item/stack/sandbags_empty/small_stack, VENDOR_ITEM_REGULAR),
		list("沙袋 (满装) x5", 0, /obj/item/stack/sandbags/small_stack, VENDOR_ITEM_REGULAR),

		list("弹药箱", -1, null, null),
		list("霰弹枪弹药箱 (鹿弹 x 100)", 0, /obj/item/ammo_box/magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("霰弹枪弹药箱 (箭形弹 x 100)", 0, /obj/item/ammo_box/magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("霰弹枪弹药箱 (独头弹 x 100)", 0, /obj/item/ammo_box/magazine/shotgun, VENDOR_ITEM_REGULAR),
		list("步枪弹药箱 (10x24mm)", 0, /obj/item/ammo_box/rounds, VENDOR_ITEM_REGULAR),
		list("步枪弹药箱 (10x24mm AP)", 0, /obj/item/ammo_box/rounds/ap, VENDOR_ITEM_REGULAR),
		list("冲锋枪弹药箱 (10x20mm HV)", 0, /obj/item/ammo_box/rounds/smg, VENDOR_ITEM_REGULAR),
		list("冲锋枪弹药箱 (10x20mm AP)", 0, /obj/item/ammo_box/rounds/smg/ap, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("整箱即食军粮", floor(scale * 1.5), /obj/item/ammo_box/magazine/misc/mre, VENDOR_ITEM_REGULAR),
		list("整箱 M94 标记照明弹包", floor(scale * 2), /obj/item/ammo_box/magazine/misc/flares, VENDOR_ITEM_REGULAR),
		list("工兵铲", floor(scale * 2), /obj/item/tool/shovel/etool, VENDOR_ITEM_REGULAR),
		list("M5 刺刀", floor(scale * 5), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M89-S 信号照明弹包", 0, /obj/item/storage/box/flare/signal, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", floor(scale * 1), /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
		list("砍刀鞘 (满装)", floor(scale * 1), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("MB-6 折叠路障 (x3)", 0, /obj/item/stack/folding_barricade/three, VENDOR_ITEM_REGULAR),
		list("运动探测器", 0, /obj/item/device/motiondetector, VENDOR_ITEM_REGULAR),
		list("轮式担架床", 2, /obj/item/roller, VENDOR_ITEM_REGULAR),

		list("护甲与服装", -1, null, null),
		list("吸热头套", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),
		list("M10 式陆战队头盔", floor(scale * 3), /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),
		list("M3 式陆战队护甲", floor(scale * 1), /obj/item/clothing/suit/storage/marine, VENDOR_ITEM_REGULAR),
		list("M3-EOD 式重型护甲", floor(scale * 1), /obj/item/clothing/suit/storage/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L 式轻型护甲", floor(scale * 1), /obj/item/clothing/suit/storage/marine/light, VENDOR_ITEM_REGULAR),
		)

//combined from req guns and ammo vendors
/obj/structure/machinery/cm_vending/sorted/vehicle_supply/stock(obj/item/item_to_stock, mob/user)
	if(being_restocked && user)
		to_chat(user, SPAN_WARNING("[src]正在补货，你会妨碍操作！"))
		return FALSE

	//storage items except few are exempted because checks would be huge and not worth it
	if(istype(item_to_stock, /obj/item/storage) && !istype(item_to_stock, /obj/item/storage/box/flare) && !istype(item_to_stock, /obj/item/storage/large_holster/machete))
		if(user)
			to_chat(user, SPAN_WARNING("无法回存[item_to_stock]。"))
		return FALSE
	var/list/R

	//this below is in case we have subtype of an object, that SHOULD be treated as parent object (like /empty ammo box)
	var/corrected_path = return_corresponding_type(item_to_stock.type)
	var/stack_restock = 0 //used for making restocking stacked stuff much better.

	for(R in (listed_products))
		if(item_to_stock.type == R[3] || corrected_path && corrected_path == R[3])
			if(!check_if_item_is_good_to_restock(item_to_stock, user))
				return

			//various stacks handling
			if(istype(item_to_stock, /obj/item/stack))
				var/obj/item/stack/S = item_to_stock
				if(istype(item_to_stock, /obj/item/stack/folding_barricade))
					if(S.amount != 3)
						if(user)
							to_chat(user, SPAN_WARNING("为方便存放，[S]按[SPAN_HELPFUL("每组 3 个")]储存。请将[S]补足 3 个后再回存。"))
						return FALSE
				else if(istype(item_to_stock, /obj/item/stack/sandbags))
					if(S.amount < 5)
						if(user)
							to_chat(user, SPAN_WARNING("为方便存放，[S]按[SPAN_HELPFUL("每组 5 个")]储存。至少需要 5 个[S]才能回存。"))
						return FALSE
					else
						stack_restock = floor(S.amount / 5)
				//for the ease of finding enough materials to stack, it will be stored in stacks of 10 sheets just like they come in engie vendor
				else
					if(S.amount < 10)
						if(user)
							to_chat(user, SPAN_WARNING("为方便存放，[S]按[SPAN_HELPFUL("每组 10 个")]储存。至少需要 10 个[S]才能回存。"))
						return FALSE
					else
						stack_restock = floor(S.amount / 10)

			//item we are restocking is a stack and we need to conveniently restock it
			//instead of demanding user to split it into stacks of appropriate amount
			//if there are any left overs in stack after we restock, we do not move it anywhere nor delete
			if(stack_restock)
				var/modifier = 10
				var/obj/item/stack/ST = item_to_stock
				if(istype(item_to_stock, /obj/item/stack/sandbags))
					modifier = 5
				if(ST.amount > stack_restock * modifier)
					ST.amount -= stack_restock * modifier
					ST.update_icon()
					item_to_stock = null //we have left overs, so we don't delete stack

				R[2] += stack_restock
				if(vend_flags & VEND_LOAD_AMMO_BOXES)
					update_derived_ammo_and_boxes_on_add(R)
			else
				R[2]++
				if(vend_flags & VEND_LOAD_AMMO_BOXES)
					update_derived_ammo_and_boxes_on_add(R)

			if(item_to_stock)
				if(user)
					if(item_to_stock.loc == user) //Inside the mob's inventory
						if(item_to_stock.flags_item & WIELDED)
							item_to_stock.unwield(user)
						user.temp_drop_inv_item(item_to_stock)

				if(isstorage(item_to_stock.loc)) //inside a storage item
					var/obj/item/storage/S = item_to_stock.loc
					S.remove_from_storage(item_to_stock, user.loc)

				qdel(item_to_stock)

			if(user)
				user.visible_message(SPAN_NOTICE("[user]向[src]补充了[R[1]]。"),
				SPAN_NOTICE("你向[src]补充了[R[1]]。"))

			updateUsrDialog()
			return TRUE//We found our item, no reason to go on.


/// Modified Restockable APC-based vendor for use by Req in the deployable tent
/obj/structure/machinery/cm_vending/sorted/vehicle_supply/tent
	desc = "可补货的自动储存售货机，用于整理前沿作战基地的物资。"
	req_access = list(ACCESS_MARINE_CARGO)
	density = TRUE
	indestructible = TRUE // Deleted with the tent instead
	needs_power = FALSE

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/tent/Initialize()
	. = ..()
	var/obj/structure/tent/located_tent = locate(/obj/structure/tent) in loc
	if(!located_tent)
		return INITIALIZE_HINT_QDEL
	RegisterSignal(located_tent, COMSIG_PARENT_QDELETING, PROC_REF(begin_unloading))

//combined from req guns and ammo vendors
/obj/structure/machinery/cm_vending/sorted/vehicle_supply/tent/populate_product_list(scale)
	listed_products = list(
		list("建筑材料", -1, null, null),
		list("纸板 x10", 1, /obj/item/stack/sheet/cardboard/small_stack, VENDOR_ITEM_REGULAR),
		list("带刺铁丝 x10", 0, /obj/item/stack/barbed_wire/small_stack, VENDOR_ITEM_REGULAR),
		list("金属 x10", 0, /obj/item/stack/sheet/metal/small_stack, VENDOR_ITEM_REGULAR),
		list("塑钢 x10", 0, /obj/item/stack/sheet/plasteel/small_stack, VENDOR_ITEM_REGULAR),
		list("沙袋 (空) x10", 0, /obj/item/stack/sandbags_empty/small_stack, VENDOR_ITEM_REGULAR),
		list("沙袋 (满装) x5", 0, /obj/item/stack/sandbags/small_stack, VENDOR_ITEM_REGULAR),

		list("弹药", -1, null, null),
		list("整箱鹿弹", 0, /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("整箱箭形弹", 0, /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("整箱霰弹枪独头弹", 0, /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M49A 弹匣 (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m49a, VENDOR_ITEM_REGULAR),
		list("M41A MK2 弹匣 (10x24mm)", 0, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),
		list("M39 高速弹匣 (10x20mm)", 0, /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M44 快速装弹器 (.44)", 0, /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 弹匣 (9mm)", 0, /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("M56D 弹鼓", 0, /obj/item/ammo_magazine/m56d, VENDOR_ITEM_REGULAR),
		list("M2C 弹箱", 0, /obj/item/ammo_magazine/m2c, VENDOR_ITEM_REGULAR),

		list("护甲", -1, null, null),
		list("M10 式陆战队头盔", 0, /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),
		list("M3 式陆战队护甲", 0, /obj/item/clothing/suit/marine, VENDOR_ITEM_REGULAR),
		list("M3 式棱纹陆战队护甲", 0, /obj/item/clothing/suit/marine/lines, VENDOR_ITEM_REGULAR),
		list("M3-EOD 式重型护甲", 0, /obj/item/clothing/suit/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L 式轻型护甲", 0, /obj/item/clothing/suit/marine/light, VENDOR_ITEM_REGULAR),

		list("杂项", -1, null, null),
		list("整箱即食军粮", 0, /obj/item/ammo_box/magazine/misc/mre, VENDOR_ITEM_REGULAR),
		list("整箱 M94 标记照明弹包", 0, /obj/item/ammo_box/magazine/misc/flares, VENDOR_ITEM_REGULAR),
		list("M89-S 信号照明弹包", 0, /obj/item/storage/box/flare/signal, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", 0, /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
		list("手电筒", 1, /obj/item/device/flashlight, VENDOR_ITEM_REGULAR),
		list("MB-6 折叠路障 (x3)", 0, /obj/item/stack/folding_barricade/three, VENDOR_ITEM_REGULAR),
		list("工兵铲", 0, /obj/item/tool/shovel/etool, VENDOR_ITEM_REGULAR),
		list("轮式担架床", 0, /obj/item/roller, VENDOR_ITEM_REGULAR),
		list("桌子", 3, /obj/item/frame/table, VENDOR_ITEM_REGULAR),
		list("置物架", 3, /obj/item/frame/rack, VENDOR_ITEM_REGULAR),
		list("写字夹板", 4, /obj/item/clipboard, VENDOR_ITEM_REGULAR),
		list("钢笔", 4, /obj/item/tool/pen, VENDOR_ITEM_REGULAR),
		list("椅子", 2, /obj/item/weapon/twohanded/folded_metal_chair, VENDOR_ITEM_REGULAR),

		list("弹药箱", -1, null, null),
		list("霰弹枪弹药箱 (鹿弹 x 100)", 0, /obj/item/ammo_box/magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("霰弹枪弹药箱 (箭形弹 x 100)", 0, /obj/item/ammo_box/magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("霰弹枪弹药箱 (独头弹 x 100)", 0, /obj/item/ammo_box/magazine/shotgun, VENDOR_ITEM_REGULAR),
		list("步枪弹药箱 (10x24mm)", 0, /obj/item/ammo_box/rounds, VENDOR_ITEM_REGULAR),
		list("冲锋枪弹药箱 (10x20mm HV)", 0, /obj/item/ammo_box/rounds/smg, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/tent/proc/begin_unloading()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(catastrophic_failure), TRUE, TRUE)
