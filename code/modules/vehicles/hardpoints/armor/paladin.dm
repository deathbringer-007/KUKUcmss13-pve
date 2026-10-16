/obj/item/hardpoint/armor/paladin
	name = "\improper 圣骑士装甲"
	desc = "为载具提供兼顾爆炸与弹道伤害的均衡防护。"

	icon_state = "paladin_armor"
	disp_icon = "tank"
	disp_icon_state = "paladin_armor"

	type_multipliers = list(
		"bullet" = 0.75, //Needed so SADARs still don't insta-kill them
		"explosive" = 0.5,
		"all" = 0.9
	)
