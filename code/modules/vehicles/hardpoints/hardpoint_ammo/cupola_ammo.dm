/obj/item/ammo_magazine/hardpoint/m56_cupola
	name = "M56车顶机枪弹箱"
	desc = "供M56重机枪系统使用的弹箱，装有500发10×28毫米无壳弹。"
	caliber = "10x28mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "cupola_1"
	w_class = SIZE_LARGE
	default_ammo = /datum/ammo/bullet/rifle/heavy/tracer
	max_rounds = 500
	gun_type = /obj/item/hardpoint/secondary/m56cupola

/obj/item/ammo_magazine/hardpoint/m56_cupola/update_icon()
	icon_state = "cupola_[current_rounds <= 0 ? "0" : "1"]"

/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon
	name = "RE-RE700前置炮弹箱"
	desc = "一箱供RE-RE700转管炮系统使用的弹链式无壳弹药。因采用双组分自燃推进原理，弹药本身不含发射药。"
	caliber = "20mm"
	max_rounds = 1700 //lore-compliant belt quantity
	gun_type = /obj/item/hardpoint/secondary/frontalcannon
	icon_state = "frontal_1"

/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon/update_icon()
	icon_state = "frontal_[current_rounds <= 0 ? "0" : "1"]"

/obj/item/ammo_magazine/hardpoint/m56_cupola/quad_cannon
	name = "RE-RE965防空系统弹箱"
	desc = "一箱供弹药消耗惊人的RE-RE965防空系统使用的弹链式无壳弹药。混装高爆燃烧曳光弹和穿甲弹，用于应对各种空中威胁。因采用双组分自燃推进原理，弹药本身不含发射药。"
	caliber = "20mm"
	default_ammo = /datum/ammo/bullet/smartgun/aa
	gun_type = /obj/item/hardpoint/primary/aa_quadcannon
	max_rounds = 3400
	icon_state = "quad_1"

/obj/item/ammo_magazine/hardpoint/m56_cupola/quad_cannon/update_icon()
	icon_state = "quad_[current_rounds <= 0 ? "0" : "1"]"

/obj/item/ammo_magazine/hardpoint/m56_cupola/aev
	name = "M56遥控武器站弹鼓"
	desc = "供M56重机枪系统使用的扩容弹鼓，装有700发10×28毫米无壳弹。"
	icon_state = "m56d_drum"
	max_rounds = 700
	gun_type = /obj/item/hardpoint/secondary/m56cupola/aev

/obj/item/ammo_magazine/hardpoint/m56_cupola/aev/update_icon()
	if(current_rounds > 0)
		icon_state = "m56d_drum"
	else
		icon_state = "m56d_drum_empty"
