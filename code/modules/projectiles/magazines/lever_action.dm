/*
Lever-action bullet handfuls!
Similar to shotguns.dm but not exactly.
*/

/obj/item/ammo_magazine/lever_action
	name = "45-70 子弹盒"
	desc = "装有散装 45-70 Govt. 子弹的盒子，专为怀旧人士准备。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "45-70-box"
	item_state = "45-70-box"
	default_ammo = /datum/ammo/bullet/lever_action
	caliber = "45-70"
	gun_type = /obj/item/weapon/gun/lever_action
	max_rounds = 90
	w_class = SIZE_LARGE
	flags_magazine = AMMUNITION_REFILLABLE|AMMUNITION_HANDFUL_BOX
	handful_state = "lever_action_bullet"
	transfer_handful_amount = 9


/obj/item/ammo_magazine/lever_action/training
	name = "45-70 空包弹盒"
	desc = "装有杠杆步枪训练用 45-70 子弹的盒子，伤害不大……除非贴着目标开火之类的。"
	icon_state = "45-70-training-box"
	item_state = "45-70-training-box"
	default_ammo = /datum/ammo/bullet/lever_action/training
	handful_state = "training_lever_action_bullet"

//unused
/obj/item/ammo_magazine/lever_action/marksman
	name = "45-70 精确弹盒"
	desc = "装有杠杆步枪用 45-70 精确弹的盒子，弹头密度更低，精度更高。"
	icon_state = "45-70-marksman-box"
	item_state = "45-70-marksman-box"
	default_ammo = /datum/ammo/bullet/lever_action/marksman
	handful_state = "marksman_lever_action_bullet"

//unused
/obj/item/ammo_magazine/lever_action/tracker
	name = "45-70 追踪弹盒"
	desc = "装有杠杆步枪用 45-70 追踪弹的盒子，弹头的部分材料被电子追踪芯片取代。"
	icon_state = "45-70-tracker-box"
	item_state = "45-70-tracker-box"
	default_ammo = /datum/ammo/bullet/lever_action/tracker
	handful_state = "tracking_lever_action_bullet"

/obj/item/ammo_magazine/lever_action/xm88
	name = ".458 SOCOM 子弹盒"
	desc = "装有散装 .458 SOCOM 子弹的盒子，专为 XM88 重型步枪设计。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "458-box"
	item_state = "458-box"
	default_ammo = /datum/ammo/bullet/lever_action/xm88
	max_rounds = 100
	caliber = ".458"
	gun_type = /obj/item/weapon/gun/lever_action/xm88
	handful_state = "boomslang_bullet"

//-------------------------------------------------------

/obj/item/ammo_magazine/internal/lever_action
	name = "lever action tube"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	default_ammo = /datum/ammo/bullet/lever_action
	caliber = "45-70"
	max_rounds = 9
	chamber_closed = 0

/obj/item/ammo_magazine/internal/lever_action/xm88
	name = "\improper XM88 heavy rifle tube"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	default_ammo = /datum/ammo/bullet/lever_action/xm88
	caliber = ".458"
	max_rounds = 9
	chamber_closed = 0

//-------------------------------------------------------

/*
Handfuls of lever_action rounds. For spawning directly on mobs in roundstart, ERTs, etc
*/

/obj/item/ammo_magazine/handful/lever_action
	name = "一把子弹（45-70）"
	desc = "一把标准 45-70 Govt. 子弹。"
	icon_state = "lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action
	caliber = "45-70"
	max_rounds = 9
	current_rounds = 9
	gun_type = /obj/item/weapon/gun/lever_action
	handful_state = "lever_action_bullet"
	transfer_handful_amount = 9
	flags_human_ai = AMMUNITION_ITEM

/obj/item/ammo_magazine/handful/lever_action/training
	name = "一把空包弹（45-70）"
	desc = "一把 45-70 Govt. 空包弹。这些空包弹大多无害……只要别贴着目标开火。"
	icon_state = "training_lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action/training
	handful_state = "training_lever_action_bullet"

//unused
/obj/item/ammo_magazine/handful/lever_action/tracker
	name = "一把追踪弹（45-70）"
	desc = "一把 45-70 Govt. 追踪弹。弹头的部分材料被芯片取代，发射后可以被运动探测器追踪。"
	icon_state = "tracking_lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action/tracker
	handful_state = "tracking_lever_action_bullet"

//unused
/obj/item/ammo_magazine/handful/lever_action/marksman
	name = "一把精确弹（45-70）"
	desc = "一把 45-70 Govt. 精确弹。较小的弹头降低了伤害，但提高了穿透力和弹速。"
	icon_state = "marksman_lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action/marksman
	handful_state = "marksman_lever_action_bullet"

/obj/item/ammo_magazine/handful/lever_action/xm88
	name = "一把 .458 SOCOM 子弹（.458）"
	desc = "一把供 XM88 重型步枪使用的 .458 SOCOM 子弹。"
	caliber = ".458"
	icon_state = "marksman_lever_action_bullet_9"
	default_ammo = /datum/ammo/bullet/lever_action/xm88
	handful_state = "boomslang_bullet"
