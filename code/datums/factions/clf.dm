/datum/faction/clf
	name = "殖民地解放阵线"
	faction_tag = FACTION_CLF

/datum/faction/clf/modify_hud_holder(image/holder, mob/living/carbon/human/human)
	var/hud_icon_state
	var/obj/item/card/id/ID = human.get_idcard()
	var/_role
	if(human.mind)
		_role = human.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_CLF_ENGI)
			hud_icon_state = "engi"
		if(JOB_CLF_MEDIC)
			hud_icon_state = "med"
		if(JOB_CLF_SPECIALIST)
			hud_icon_state = "spec"
		if(JOB_CLF_LEADER)
			hud_icon_state = "sl"
		if(JOB_CLF_SYNTH)
			hud_icon_state = "synth"
		if(JOB_CLF_COMMANDER)
			hud_icon_state = "cellcom"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', human, "clf_[hud_icon_state]")

/datum/faction/clf/get_antag_guns_snowflake_equipment()
	return list(
		list("主武器枪械", 0, null, null, null),
		list("ABR-40 猎枪", 30, /obj/item/weapon/gun/rifle/l42a/abr40, null, VENDOR_ITEM_REGULAR),
		list("巴西拉-阿姆斯特朗栓动步枪", 15, /obj/item/weapon/gun/boltaction, null, VENDOR_ITEM_REGULAR),
		list("双管霰弹枪", 30, /obj/item/weapon/gun/shotgun/double, null, VENDOR_ITEM_REGULAR),
		list("HG 37-12 泵动霰弹枪", 30, /obj/item/weapon/gun/shotgun/double/sawn, null, VENDOR_ITEM_REGULAR),
		list("M16 步枪", 30, /obj/item/weapon/gun/rifle/m16, null, VENDOR_ITEM_REGULAR),
		list("MAR-30 战斗卡宾枪", 30, /obj/item/weapon/gun/rifle/mar40/carbine, null, VENDOR_ITEM_REGULAR),
		list("MAR-40 战斗步枪", 30, /obj/item/weapon/gun/rifle/mar40, null, VENDOR_ITEM_REGULAR),
		list("64 式 冲锋枪", 20, /obj/item/weapon/gun/smg/bizon, null, VENDOR_ITEM_REGULAR),
		list("MAC-15 冲锋枪", 20, /obj/item/weapon/gun/smg/mac15, null, VENDOR_ITEM_REGULAR),
		list("MP27 冲锋枪", 20, /obj/item/weapon/gun/smg/mp27, null, VENDOR_ITEM_REGULAR),
		list("MP5 冲锋枪", 20, /obj/item/weapon/gun/smg/mp5, null, VENDOR_ITEM_REGULAR),
		list("短管霰弹枪", 30, /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, null, VENDOR_ITEM_REGULAR),

		list("主武器弹药", 0, null, null, null),
		list("ABR-40 弹匣 (10x24mm)", 20, /obj/item/ammo_magazine/rifle/l42a/abr40, null, VENDOR_ITEM_REGULAR),
		list("巴西拉-阿姆斯特朗弹匣 (6.5mm)", 5, /obj/item/ammo_magazine/rifle/boltaction, null, VENDOR_ITEM_REGULAR),
		list("整箱鹿弹", 10, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
		list("整箱箭形弹", 10, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),
		list("整箱霰弹枪独头弹", 10, /obj/item/ammo_magazine/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M16 穿甲弹匣 (5.56x45mm)", 15, /obj/item/ammo_magazine/rifle/m16/ap, null, VENDOR_ITEM_REGULAR),
		list("M16 弹匣 (5.56x45mm)", 5, /obj/item/ammo_magazine/rifle/m16, null, VENDOR_ITEM_REGULAR),
		list("MAC-15 弹匣 (9mm)", 5, /obj/item/ammo_magazine/smg/mac15, null, VENDOR_ITEM_REGULAR),
		list("MAR 弹匣 (7.62x39mm)", 5, /obj/item/ammo_magazine/rifle/mar40, null, VENDOR_ITEM_REGULAR),
		list("MAR 扩容弹匣 (7.62x39mm)", 15, /obj/item/ammo_magazine/rifle/mar40/extended, null, VENDOR_ITEM_REGULAR),
		list("64 式螺旋弹匣 (.7.62x19mm)", 5, /obj/item/ammo_magazine/smg/bizon, null, VENDOR_ITEM_REGULAR),
		list("MP27 弹匣 (4.6x30mm)", 5, /obj/item/ammo_magazine/smg/mp27, null, VENDOR_ITEM_REGULAR),
		list("MP5 弹匣 (9mm)", 5, /obj/item/ammo_magazine/smg/mp5, null, VENDOR_ITEM_REGULAR),

		list("副武器", 0, null, null, null),
		list("VP70 战斗手枪", 15, /obj/item/weapon/gun/pistol/vp70, null, VENDOR_ITEM_REGULAR),
		list("伯莱塔 92FS 手枪", 15, /obj/item/weapon/gun/pistol/b92fs, null, VENDOR_ITEM_REGULAR),
		list("CMB 矛头左轮手枪", 15, /obj/item/weapon/gun/revolver/spearhead, null, VENDOR_ITEM_REGULAR),
		list("袖珍手枪", 10, /obj/item/weapon/gun/pistol/holdout, null, VENDOR_ITEM_REGULAR),
		list("KT-42 自动马格南手枪", 15, /obj/item/weapon/gun/pistol/kt42, null, VENDOR_ITEM_REGULAR),
		list("S&W .357 左轮手枪", 15, /obj/item/weapon/gun/revolver/small, null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", 0, null, null, null),
		list("VP70 弹匣 (9mm)", 5, /obj/item/ammo_magazine/pistol/vp70, null, VENDOR_ITEM_REGULAR),
		list("伯莱塔 92FS 弹匣 (9mm)", 5, /obj/item/ammo_magazine/pistol/b92fs, null, VENDOR_ITEM_REGULAR),
		list("KT-42 弹匣 (.44)", 5, /obj/item/ammo_magazine/pistol/kt42, null, VENDOR_ITEM_REGULAR),
		list("矛头快速装弹器 (.357)", 10, /obj/item/ammo_magazine/revolver/spearhead, VENDOR_ITEM_REGULAR),
		list("矛头空尖弹快速装弹器 (.357)", 5, /obj/item/ammo_magazine/revolver/spearhead, VENDOR_ITEM_REGULAR),
		list("S&W 快速装弹器 (.357)", 5, /obj/item/ammo_magazine/revolver/small, null, VENDOR_ITEM_REGULAR),
		list("袖珍手枪弹匣 (.22)", 5, /obj/item/ammo_magazine/pistol/holdout, null, VENDOR_ITEM_REGULAR),

		list("配件", 0, null, null, null),
		list("2 倍狩猎小型瞄准镜", 20, /obj/item/attachable/scope/mini/hunting, null, VENDOR_ITEM_REGULAR),
		list("倾斜握把", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("点射组件", 15, /obj/item/attachable/burstfire_assembly, null, VENDOR_ITEM_REGULAR),
		list("加长枪管", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("激光瞄准器", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", 5, /obj/item/attachable/flashlight, null, VENDOR_ITEM_REGULAR),
		list("红点瞄准镜", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("反射式瞄准镜", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("消音器", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("垂直握把", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("80 式刺刀", 3, /obj/item/attachable/bayonet/upp, null, VENDOR_ITEM_REGULAR),
		list("刺突地雷", 120, /obj/item/weapon/twohanded/lungemine, null, VENDOR_ITEM_REGULAR),
		list("近战武器（随机）", 7, /obj/effect/essentials_set/random/clf_melee, null, VENDOR_ITEM_REGULAR),
		list("M94 标记照明弹包", 3, /obj/item/storage/box/flare, null, VENDOR_ITEM_RECOMMENDED),
		list("烟幕手榴弹", 7, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR)
	)

/datum/faction/clf/get_antag_guns_sorted_equipment()
	return list(
		list("主武器枪械", -1, null, null),
		list("ABR-40 猎枪", 30, /obj/item/weapon/gun/rifle/l42a/abr40, null, VENDOR_ITEM_REGULAR),
		list("巴西拉-阿姆斯特朗栓动步枪", 15, /obj/item/weapon/gun/boltaction, null, VENDOR_ITEM_REGULAR),
		list("双管霰弹枪", 20, /obj/item/weapon/gun/shotgun/double, VENDOR_ITEM_REGULAR),
		list("HG 37-12 泵动霰弹枪", 20, /obj/item/weapon/gun/shotgun/double/sawn, VENDOR_ITEM_REGULAR),
		list("M16 步枪", 20, /obj/item/weapon/gun/rifle/m16, VENDOR_ITEM_REGULAR),
		list("MAC-15 冲锋枪", 20, /obj/item/weapon/gun/smg/mac15, VENDOR_ITEM_REGULAR),
		list("MAR-30 战斗卡宾枪", 20, /obj/item/weapon/gun/rifle/mar40/carbine, VENDOR_ITEM_REGULAR),
		list("MAR-40 战斗步枪", 20, /obj/item/weapon/gun/rifle/mar40, VENDOR_ITEM_REGULAR),
		list("64 式冲锋枪", 20, /obj/item/weapon/gun/smg/bizon, VENDOR_ITEM_REGULAR),
		list("MP27 冲锋枪", 20, /obj/item/weapon/gun/smg/mp27, VENDOR_ITEM_REGULAR),
		list("MP5 冲锋枪", 20, /obj/item/weapon/gun/smg/mp5, VENDOR_ITEM_REGULAR),
		list("短管霰弹枪", 20, /obj/item/weapon/gun/shotgun/pump/dual_tube/cmb, VENDOR_ITEM_REGULAR),

		list("主武器弹药", -1, null, null),
		list("ABR-40 弹匣 (10x24mm)", 20, /obj/item/ammo_magazine/rifle/l42a/abr40, null, VENDOR_ITEM_REGULAR),
		list("巴西拉-阿姆斯特朗弹匣 (6.5mm)", 5, /obj/item/ammo_magazine/rifle/boltaction, null, VENDOR_ITEM_REGULAR),
		list("整箱鹿弹", 15, /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("整箱箭形弹", 15, /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("整箱霰弹枪独头弹", 15, /obj/item/ammo_magazine/shotgun, VENDOR_ITEM_REGULAR),
		list("M16 穿甲弹匣 (5.56x45mm)", 10, /obj/item/ammo_magazine/rifle/m16/ap, VENDOR_ITEM_REGULAR),
		list("M16 弹匣 (5.56x45mm)", 60, /obj/item/ammo_magazine/rifle/m16, VENDOR_ITEM_REGULAR),
		list("MAC-15 弹匣 (9mm)", 60, /obj/item/ammo_magazine/smg/mac15, VENDOR_ITEM_REGULAR),
		list("MAR 弹匣 (7.62x39mm)", 60, /obj/item/ammo_magazine/rifle/mar40, VENDOR_ITEM_REGULAR),
		list("MAR 扩容弹匣 (7.62x39mm)", 10, /obj/item/ammo_magazine/rifle/mar40/extended, VENDOR_ITEM_REGULAR),
		list("64 式螺旋弹匣 (7.62x19mm)", 60, /obj/item/ammo_magazine/smg/bizon, VENDOR_ITEM_REGULAR),
		list("MP27 弹匣 (4.6x30mm)", 60, /obj/item/ammo_magazine/smg/mp27, VENDOR_ITEM_REGULAR),
		list("MP5 弹匣 (9mm)", 60, /obj/item/ammo_magazine/smg/mp5, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("VP70 战斗手枪", 20, /obj/item/weapon/gun/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("伯莱塔 92FS 手枪", 20, /obj/item/weapon/gun/pistol/b92fs, VENDOR_ITEM_REGULAR),
		list("CMB 矛头左轮手枪", 20, /obj/item/weapon/gun/revolver/spearhead, VENDOR_ITEM_REGULAR),
		list("袖珍手枪", 20, /obj/item/weapon/gun/pistol/holdout, VENDOR_ITEM_REGULAR),
		list("KT-42 自动马格南手枪", 20, /obj/item/weapon/gun/pistol/kt42, VENDOR_ITEM_REGULAR),
		list("S&W .357 左轮手枪", 20, /obj/item/weapon/gun/revolver/small, VENDOR_ITEM_REGULAR),

		list("副武器弹药", -1, null, null),
		list("VP70 弹匣 (9mm)", 40, /obj/item/ammo_magazine/pistol/vp70, VENDOR_ITEM_REGULAR),
		list("伯莱塔 92FS 弹匣 (9mm)", 40, /obj/item/ammo_magazine/pistol/b92fs, VENDOR_ITEM_REGULAR),
		list("KT-42 弹匣 (.44)", 40, /obj/item/ammo_magazine/pistol/kt42, VENDOR_ITEM_REGULAR),
		list("矛头快速装弹器 (.357)", 40, /obj/item/ammo_magazine/revolver/spearhead, VENDOR_ITEM_REGULAR),
		list("矛头空尖弹快速装弹器 (.357)", 40, /obj/item/ammo_magazine/revolver/spearhead, VENDOR_ITEM_REGULAR),
		list("S&W 快速装弹器 (.357)", 40, /obj/item/ammo_magazine/revolver/small, VENDOR_ITEM_REGULAR),
		list("袖珍手枪弹匣 (.22)", 40, /obj/item/ammo_magazine/pistol/holdout, VENDOR_ITEM_REGULAR),

		list("近战武器", -1, null, null),
		list("棒球棍", 10, /obj/item/weapon/baseballbat, VENDOR_ITEM_REGULAR),
		list("棒球棍（金属）", 5, /obj/item/weapon/baseballbat/metal, VENDOR_ITEM_REGULAR),
		list("消防斧", 5, /obj/item/weapon/twohanded/fireaxe, VENDOR_ITEM_REGULAR),
		list("手斧", 15, /obj/item/tool/hatchet, VENDOR_ITEM_REGULAR),
		list("长矛", 10, /obj/item/weapon/twohanded/spear, VENDOR_ITEM_REGULAR),

		list("勤务服", -1, null, null),
		list("M94 标记照明弹包", 20, /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
		list("烟幕手榴弹", 5, /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("80 式刺刀", 40, /obj/item/attachable/bayonet/upp, VENDOR_ITEM_REGULAR),
	)
