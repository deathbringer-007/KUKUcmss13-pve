/obj/structure/closet/coffin
	name = "棺材"
	desc = "用来安葬逝者的容器。"
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"
	material = MATERIAL_WOOD
	anchored = FALSE
	layer = BETWEEN_OBJECT_ITEM_LAYER

/obj/structure/closet/coffin/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/coffin/predator
	name = "奇怪的棺材"
	desc = "用来安葬逝者的容器。侧面似乎刻着奇怪的符号……？"
	icon_state = "pred_coffin"
	icon_closed = "pred_coffin"
	icon_opened = "pred_coffin_open"

	open_sound = 'sound/effects/stonedoor_openclose.ogg'
	close_sound = 'sound/effects/stonedoor_openclose.ogg'


/obj/structure/closet/coffin/woodencrate //Subtyped here so Req doesn't sell them
	name = "木箱"
	desc = "一个做工粗糙、空间宽敞的木箱，在自动仓储检索系统中一文不值。"
	icon_state = "closed_woodcrate"
	icon_opened = "open_woodcrate"
	icon_closed = "closed_woodcrate"
	material = MATERIAL_WOOD
	store_mobs = FALSE
	climbable = TRUE
	throwpass = 1
