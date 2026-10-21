/datum/faction/royal_marines_commando
	name = "皇家陆战突击队"
	faction_tag = FACTION_TWE

/datum/faction/royal_marines_commando/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	var/hud_icon_state
	var/obj/item/card/id/dogtag/ID = H.get_idcard()
	var/_role
	if(H.mind)
		_role = H.job
	else if(ID)
		_role = ID.rank
	switch(_role)
		if(JOB_TWE_RMC_COMMANDER)
			hud_icon_state = "commander"
		if(JOB_TWE_RMC_LIEUTENANT)
			hud_icon_state = "lieutenant"
		if(JOB_TWE_RMC_TROOPLEADER)
			hud_icon_state = "troopleader"
		if(JOB_TWE_RMC_SECTIONLEADER)
			hud_icon_state = "sectionleader"
		if(JOB_TWE_RMC_TEAMLEADER)
			hud_icon_state = "teamleader"
		if(JOB_TWE_RMC_MARKSMAN)
			hud_icon_state = "marksman"
		if(JOB_TWE_RMC_RIFLEMAN)
			hud_icon_state = "rifleman"
		if(JOB_TWE_RMC_SMARTGUNNER)
			hud_icon_state = "smartgunner"
		if(JOB_TWE_RMC_BREACHER)
			hud_icon_state = "breacher"
		if(JOB_TWE_RMC_MEDIC)
			hud_icon_state = "medic"
		if(JOB_TWE_RMC_ENGI)
			hud_icon_state = "engi"
	if(hud_icon_state)
		holder.overlays += image('icons/mob/hud/marine_hud.dmi', H, "rmc_[hud_icon_state]")

	var/datum/squad/squad = H.assigned_squad
	if(istype(squad, /datum/squad/marine/rmc))
		var/squad_clr = H.assigned_squad.equipment_color
		switch(GET_DEFAULT_ROLE(_role))
			if(JOB_TWE_RMC_RIFLEMAN) hud_icon_state = "rifleman"
			if(JOB_TWE_RMC_MEDIC) hud_icon_state = "medic"
			if(JOB_TWE_RMC_ENGI) hud_icon_state = "engi"
			if(JOB_TWE_RMC_BREACHER) hud_icon_state = "breacher"
			if(JOB_TWE_RMC_MARKSMAN) hud_icon_state = "marksman"
			if(JOB_TWE_RMC_SMARTGUNNER) hud_icon_state = "smartgunner"
			if(JOB_TWE_RMC_TEAMLEADER) hud_icon_state = "teamleader"
			if(JOB_TWE_RMC_SECTIONLEADER) hud_icon_state = "sectionleader"
			if(JOB_TWE_RMC_TROOPLEADER) hud_icon_state = "troopleader"
			if(JOB_TWE_RMC_LIEUTENANT) hud_icon_state = "lieutenant"
		if(squad.fireteam_leaders["SQ1"] == H || squad.fireteam_leaders["SQ2"] == H || squad.fireteam_leaders["SQ3"] == H || squad.fireteam_leaders["SQ4"] == H)
			H.langchat_styles = "langchat_smaller_bolded"
		else
			H.langchat_styles = initial(H.langchat_styles)
		H.langchat_color = H.assigned_squad.chat_color

		if(!hud_icon_state) hud_icon_state = H.rank_fallback
		if(hud_icon_state)
			var/image/IMG = image('icons/mob/hud/marine_hud.dmi', H, "rmc_[hud_icon_state]")
			holder.overlays += IMG
		if(H.assigned_squad && H.assigned_fireteam)
			var/image/IMG2 = image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_rmc_[H.assigned_fireteam]")
			IMG2.color = squad_clr
			holder.overlays += IMG2
			if(H.assigned_squad.fireteam_leaders[H.assigned_fireteam] == H)
				var/image/IMG3 = image('icons/mob/hud/marine_hud.dmi', H, "hudsquad_rmc_sl")
				IMG3.color = squad_clr
				holder.overlays += IMG3

/datum/faction/royal_marines_commando/get_antag_guns_snowflake_equipment()
	return list(
		list("主武器枪械", 0, null, null, null),
		list("F903A1 步枪", 20, /obj/item/weapon/gun/rifle/rmc_f90, null, VENDOR_ITEM_REGULAR),
		list("F903A2 步枪", 30, /obj/item/weapon/gun/rifle/rmc_f90/a_grip, null, VENDOR_ITEM_REGULAR),
		list("F903A1 精确射手步枪", 30, /obj/item/weapon/gun/rifle/rmc_f90/scope, null, VENDOR_ITEM_REGULAR),
		list("F903A1/B“破门者”步枪", 30, /obj/item/weapon/gun/rifle/rmc_f90/shotgun, null, VENDOR_ITEM_REGULAR),

		list("主武器弹药", 0, null, null, null),
		list("F903 弹匣 (10x24mm)", 5, /obj/item/ammo_magazine/rifle/rmc_f90, null, VENDOR_ITEM_REGULAR),
		list("F903A1 精确射击弹匣 (10x24mm)", 15, /obj/item/ammo_magazine/rifle/rmc_f90/marksman, null, VENDOR_ITEM_REGULAR),

		list("副武器", 0, null, null, null),
		list("L165A1 手枪", 20, /obj/item/weapon/gun/pistol/vp78/rmc, null, VENDOR_ITEM_REGULAR),
		list("VP70 战斗手枪", 15, /obj/item/weapon/gun/pistol/vp70, null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", 0, null, null, null),
		list("L165A1 弹匣 (9mm)", 5, /obj/item/ammo_magazine/pistol/vp78/rmc, null, VENDOR_ITEM_REGULAR),
		list("VP70 弹匣 (9mm)", 5, /obj/item/ammo_magazine/pistol/vp70, null, VENDOR_ITEM_REGULAR),

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
		list("R2175/B HIDP 手榴弹包", 7, /obj/item/storage/box/packet/rmc/incin, null, VENDOR_ITEM_REGULAR),
		list("R2175/A HEDP 手榴弹包", 7, /obj/item/storage/box/packet/rmc, null, VENDOR_ITEM_REGULAR),
		list("L5 刺刀", 3, /obj/item/attachable/bayonet/rmc, null, VENDOR_ITEM_REGULAR),
	)

/datum/faction/royal_marines_commando/get_antag_guns_sorted_equipment()
	return list(
		list("主武器枪械", -1, null, null),
		list("F903A1 步枪", 20, /obj/item/weapon/gun/rifle/rmc_f90, null, VENDOR_ITEM_REGULAR),
		list("F903A2 步枪", 30, /obj/item/weapon/gun/rifle/rmc_f90/a_grip, null, VENDOR_ITEM_REGULAR),
		list("F903A1 精确射手步枪", 30, /obj/item/weapon/gun/rifle/rmc_f90/scope, null, VENDOR_ITEM_REGULAR),
		list("F903A1/B“破门者”步枪", 30, /obj/item/weapon/gun/rifle/rmc_f90/shotgun, null, VENDOR_ITEM_REGULAR),

		list("主武器弹药", -1, null, null),
		list("F903 弹匣 (10x24mm)", 5, /obj/item/ammo_magazine/rifle/rmc_f90, null, VENDOR_ITEM_REGULAR),
		list("F903A1 精确射击弹匣 (10x24mm)", 15, /obj/item/ammo_magazine/rifle/rmc_f90/marksman, null, VENDOR_ITEM_REGULAR),

		list("副武器", -1, null, null),
		list("L165A1 手枪", 20, /obj/item/weapon/gun/pistol/vp78/rmc, null, VENDOR_ITEM_REGULAR),
		list("VP70 战斗手枪", 15, /obj/item/weapon/gun/pistol/vp70, null, VENDOR_ITEM_REGULAR),

		list("副武器弹药", -1, null, null),
		list("L165A1 弹匣 (9mm)", 5, /obj/item/ammo_magazine/pistol/vp78/rmc, null, VENDOR_ITEM_REGULAR),
		list("VP70 弹匣 (9mm)", 5, /obj/item/ammo_magazine/pistol/vp70, null, VENDOR_ITEM_REGULAR),

		list("勤务服", -1, null, null),
		list("M94 标记照明弹包", 3, /obj/item/storage/box/flare, null, VENDOR_ITEM_RECOMMENDED),
		list("烟幕手榴弹", 7, /obj/item/explosive/grenade/smokebomb, null, VENDOR_ITEM_REGULAR),
		list("R2175/B HIDP 手榴弹包", 7, /obj/item/storage/box/packet/rmc/incin, null, VENDOR_ITEM_REGULAR),
		list("R2175/A HEDP 手榴弹包", 7, /obj/item/storage/box/packet/rmc, null, VENDOR_ITEM_REGULAR),
		list("L5 刺刀", 3, /obj/item/attachable/bayonet/rmc, null, VENDOR_ITEM_REGULAR),
	)
