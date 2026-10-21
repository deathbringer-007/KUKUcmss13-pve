/datum/faction/upp
	name = "进步人民联盟"
	faction_tag = FACTION_UPP

/datum/faction/upp/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_UPP_MEDIC)
			hud_icon_state = "med"
		if(JOB_UPP_ENGI)
			hud_icon_state = "sapper"
		if(JOB_UPP_SPECIALIST)
			hud_icon_state = "spec"
		if(JOB_UPP_LEADER)
			hud_icon_state = "sl"
		if(JOB_UPP_POLICE)
			hud_icon_state = "mp"
		if(JOB_UPP_LT_OFFICER, JOB_SO)
			hud_icon_state = "lt"
		if(JOB_UPP_SRLT_OFFICER)
			hud_icon_state = "slt"
		if(JOB_UPP_KPT_OFFICER)
			hud_icon_state = "xo"
		if(JOB_UPP_MAY_OFFICER)
			hud_icon_state = "co"
		if(JOB_UPP_LTKOL_OFFICER)
			hud_icon_state = "co"
		if(JOB_UPP_KOL_OFFICER)
			hud_icon_state = "co"
		if(JOB_UPP_MAY_GENERAL)
			hud_icon_state = "co"
		if(JOB_UPP_LT_GENERAL)
			hud_icon_state = "co"
		if(JOB_UPP_GENERAL)
			hud_icon_state = "co"
		if(JOB_UPP_COMBAT_SYNTH)
			hud_icon_state = "synth"
		if(JOB_UPP_SUPPORT_SYNTH)
			hud_icon_state = "synth"
		if(JOB_UPP_COMMANDO)
			hud_icon_state = "com"
		if(JOB_UPP_COMMANDO_MEDIC)
			hud_icon_state = "commed"
		if(JOB_UPP_COMMANDO_LEADER)
			hud_icon_state = "comsl"
		if(JOB_UPP_CREWMAN)
			hud_icon_state = "vc"
		if(JOB_UPP_LT_DOKTOR)
			hud_icon_state = "doc"
		if(JOB_UPP_SUPPLY)
			hud_icon_state = "log"
		if(JOB_UPP_COMMISSAR)
			hud_icon_state = "commi"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "upp_[hud_icon_state]")

//UPP PVE PLATOON
	var/datum/squad/squad = H.assigned_squad
	if(istype(squad, /datum/squad/marine/upp))
		var/squad_clr = H.assigned_squad.equipment_color
		switch(GET_DEFAULT_ROLE(_role))
			if(JOB_SQUAD_MEDIC) hud_icon_state = "med"
			if(JOB_SQUAD_SMARTGUN) hud_icon_state = "gun"
			if(JOB_SQUAD_TEAM_LEADER) hud_icon_state = "tl"
			if(JOB_SQUAD_LEADER) hud_icon_state = "leader_a"
		if(squad.fireteam_leaders["SQ1"] == H || squad.fireteam_leaders["SQ2"] == H)
			H.langchat_styles = "langchat_smaller_bolded"
		else
			H.langchat_styles = initial(H.langchat_styles)
		H.langchat_color = H.assigned_squad.chat_color

		if(!hud_icon_state) hud_icon_state = H.rank_fallback
		if(hud_icon_state)
			var/image/IMG = image('icons/mob/hud/marine_hud.dmi', H, "hudsquad")
			if(squad_clr)
				IMG.color = squad_clr
			else
				IMG.color = "#5A934A"
			holder.overlays += IMG
			holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_[hud_icon_state]")
		if(H.assigned_squad && H.assigned_fireteam)
			var/image/IMG2 = image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_[H.assigned_fireteam]")
			IMG2.color = squad_clr
			holder.overlays += IMG2
			if(H.assigned_squad.fireteam_leaders[H.assigned_fireteam] == H)
				var/image/IMG3 = image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_ftl")
				IMG3.color = squad_clr
				holder.overlays += IMG3

/datum/faction/upp/get_antag_guns_snowflake_equipment()
	return list(
		list("主武器枪械", 0, null, null, null),
		list("AG80 冲锋枪", 20, /obj/item/weapon/gun/rifle/ag80, null, VENDOR_ITEM_REGULAR),
		list("71 式脉冲步枪", 30, /obj/item/weapon/gun/rifle/type71, null, VENDOR_ITEM_REGULAR),

		list("主武器弹药", 0, null, null, null),
		list("AG80 弹匣 (7.62x19mm)", 5, /obj/item/ammo_magazine/rifle/ag80, null, VENDOR_ITEM_REGULAR),
		list("71 式穿甲弹匣 (10x27mm)", 15, /obj/item/ammo_magazine/rifle/type71/ap, null, VENDOR_ITEM_REGULAR),
		list("71 式弹匣 (10x27mm)", 5, /obj/item/ammo_magazine/rifle/type71, null, VENDOR_ITEM_REGULAR),

		list("副武器", 0, null, null, null),
		list("73 式手枪", 25, /obj/item/weapon/gun/pistol/t73, null, VENDOR_ITEM_REGULAR),
		list("NP92 手枪", 15, /obj/item/weapon/gun/pistol/np92, null, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 左轮手枪", 15, /obj/item/weapon/gun/revolver/upp, null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", 0, null, null, null),
		list("73 式弹匣 (7.62x25mm 托卡列夫弹)", 5, /obj/item/ammo_magazine/pistol/t73, null, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 快速装弹器 (7.62x38mmR)", 5, /obj/item/ammo_magazine/revolver/upp, null, VENDOR_ITEM_REGULAR),
		list("NP92 弹匣 (9x18mm 马卡洛夫弹)", 40, /obj/item/ammo_magazine/pistol/np92, null, VENDOR_ITEM_REGULAR),

		list("配件", 0, null, null, null),
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
		list("M94 标记照明弹包", 3, /obj/item/storage/box/flare, null, VENDOR_ITEM_RECOMMENDED),
		list("烟幕手榴弹", 7, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("80 式刺刀", 3, /obj/item/attachable/bayonet/upp, null, VENDOR_ITEM_REGULAR),
	)

/datum/faction/upp/get_antag_guns_sorted_equipment()
	return list(
		list("主武器枪械", -1, null, null),
		list("AG80 冲锋枪", 20, /obj/item/weapon/gun/rifle/ag80, null, VENDOR_ITEM_REGULAR),
		list("71 式脉冲步枪", 20, /obj/item/weapon/gun/rifle/type71, VENDOR_ITEM_REGULAR),

		list("主武器弹药", -1, null, null),
		list("AG80 弹匣 (7.62x19mm)", 5, /obj/item/ammo_magazine/rifle/ag80, null, VENDOR_ITEM_REGULAR),
		list("71 式穿甲弹匣 (10x27mm)", 60, /obj/item/ammo_magazine/rifle/type71/ap, VENDOR_ITEM_REGULAR),
		list("71 式弹匣 (10x27mm)", 60, /obj/item/ammo_magazine/rifle/type71, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("73 式手枪", 20, /obj/item/weapon/gun/pistol/t73, VENDOR_ITEM_REGULAR),
		list("NP02 手枪", 20, /obj/item/weapon/gun/pistol/np92, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 左轮手枪", 20, /obj/item/weapon/gun/revolver/upp, VENDOR_ITEM_REGULAR),

		list("副武器弹药", -1, null, null),
		list("73 式弹匣 (7.62x25mm 托卡列夫弹)", 40, /obj/item/ammo_magazine/pistol/t73, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 快速装弹器 (7.62x38mmR)", 40, /obj/item/ammo_magazine/revolver/upp, VENDOR_ITEM_REGULAR),
		list("NP92 弹匣 (9x18mm 马卡洛夫弹)", 40, /obj/item/ammo_magazine/pistol/np92, VENDOR_ITEM_REGULAR),

		list("勤务服", -1, null, null),
		list("M94 标记照明弹包", 20, /obj/item/storage/box/flare, VENDOR_ITEM_RECOMMENDED),
		list("烟幕手榴弹", 5, /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("80 式刺刀", 40, /obj/item/attachable/bayonet/upp, VENDOR_ITEM_REGULAR),
	)
