/obj/item/hardpoint/armor/reactive
	name = "\improper 反应装甲"
	desc = "安装在坦克车体上的一组爆炸反应装甲板，可增强对聚能装药和动能穿甲弹的防护。"

	icon = 'icons/obj/vehicles/hardpoints/upptank.dmi'
	icon_state = "reactive_armor"
	disp_icon = "upptank"
	disp_icon_state = "reactive_armor"

	health = 2000

	type_multipliers = list(
		"explosive" = 0.7,
		"bullet" = 0.8,
		"blunt" = 0.8,
		"all" = 0.9
	)
