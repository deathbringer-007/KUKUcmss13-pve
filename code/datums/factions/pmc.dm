/datum/faction/pmc
	name = "Private Military Company"
	faction_tag = FACTION_PMC

/datum/faction/pmc/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_PMC_DIRECTOR, JOB_SO)
			hud_icon_state = "sd"
		if(JOB_PMC_LEADER, JOB_PMC_LEAD_INVEST)
			hud_icon_state = "ld"
		if(JOB_PMC_DOCTOR)
			hud_icon_state = "td"
		if(JOB_PMC_ENGINEER)
			hud_icon_state = "ct"
		if(JOB_PMC_MEDIC, JOB_PMC_INVESTIGATOR)
			hud_icon_state = "md"
		if(JOB_PMC_SYNTH)
			hud_icon_state = "syn"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "pmc_[hud_icon_state]")


	var/datum/squad/squad = H.assigned_squad
	if(istype(squad, /datum/squad/marine/pmc))
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

/datum/faction/pmc/get_antag_guns_snowflake_equipment()
	return list(
		list("主武器枪械", 0, null, null, null),
		list("M41A/2 脉冲步枪", 30, /obj/item/weapon/gun/rifle/m41aMK1/elite, null, VENDOR_ITEM_REGULAR),
		list("M39B/2 冲锋枪", 30, /obj/item/weapon/gun/smg/m39/elite, null, VENDOR_ITEM_REGULAR),
		list("NSG23 突击步枪", 20, /obj/item/weapon/gun/rifle/nsg23, null, VENDOR_ITEM_REGULAR),

		list("主武器弹药", 0, null, null, null),
		list("M41A 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M41A 扩容弹匣 (10x24mm)", 5, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 高速弹扩容弹匣 (10x20mm)", 5, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),
		list("NSG L23A1 穿甲弹匣 (10x24mm)", 10, /obj/item/ammo_magazine/rifle/nsg23/ap, null, VENDOR_ITEM_REGULAR),

		list("副武器", 0, null, null, null),
		list("VP78 手枪", 20, /obj/item/weapon/gun/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("VP70 战斗手枪", 15, /obj/item/weapon/gun/pistol/vp70, null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", 0, null, null, null),
		list("VP78 弹匣 (9mm)", 5, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("VP70 弹匣 (9mm)", 5, /obj/item/ammo_magazine/pistol/vp70, null, VENDOR_ITEM_REGULAR),

		list("配件", 0, null, null, null),
		list("倾斜握把", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("点射组件", 15, /obj/item/attachable/burstfire_assembly, null, VENDOR_ITEM_REGULAR),
		list("加长枪管", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("高级下挂式火焰喷射器", 15, /obj/item/attachable/attached_gun/flamer/advanced, null, VENDOR_ITEM_REGULAR),
		list("激光瞄准器", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("导轨手电筒", 5, /obj/item/attachable/flashlight, null, VENDOR_ITEM_REGULAR),
		list("红点瞄准镜", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("反射式瞄准镜", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("消音器", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("垂直握把", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("M94 标记照明弹包", 3, /obj/item/storage/box/flare, null, VENDOR_ITEM_RECOMMENDED),
		list("烟幕手榴弹", 7, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR)
	)

/datum/faction/pmc/get_antag_guns_sorted_equipment()
	return list(
		list("主武器枪械", 0, null, null, null),
		list("M41A/2 脉冲步枪", 30, /obj/item/weapon/gun/rifle/m41aMK1/elite, null, VENDOR_ITEM_REGULAR),
		list("M39B/2 冲锋枪", 30, /obj/item/weapon/gun/smg/m39/elite, null, VENDOR_ITEM_REGULAR),
		list("NSG23 突击步枪", 30, /obj/item/weapon/gun/rifle/nsg23, null, VENDOR_ITEM_REGULAR),

		list("主武器弹药", 0, null, null, null),
		list("M41A 穿甲弹匣 (10x24mm)", 30, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M41A 扩容弹匣 (10x24mm)", 50, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M39 穿甲弹匣 (10x20mm)", 30, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 高速弹扩容弹匣 (10x20mm)", 50, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),
		list("NSG L23A1 穿甲弹匣 (10x24mm)", 30, /obj/item/ammo_magazine/rifle/nsg23/ap, null, VENDOR_ITEM_REGULAR),

		list("副武器", 0, null, null, null),
		list("VP78 手枪", 20, /obj/item/weapon/gun/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("VP70 战斗手枪", 30, /obj/item/weapon/gun/pistol/vp70, null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", 0, null, null, null),
		list("VP78 弹匣 (9mm)", 50, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("VP70 弹匣 (9mm)", 50, /obj/item/ammo_magazine/pistol/vp70, null, VENDOR_ITEM_REGULAR),

		list("勤务服", 0, null, null, null),
		list("M94 标记照明弹包", 30, /obj/item/storage/box/flare, null, VENDOR_ITEM_RECOMMENDED),
		list("烟幕手榴弹", 30, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR)
	)
