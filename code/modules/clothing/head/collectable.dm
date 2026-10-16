
//Hat Station 13

/obj/item/clothing/head/collectable
	name = "收藏款帽子"
	desc = "一顶稀有的收藏款帽子。"

/obj/item/clothing/head/collectable/xenom
	name = "收藏款异形头盔！"
	desc = "嘶嘶嘶！"
	icon_state = "xenom"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/head/collectable/tophat
	name = "收藏款高顶礼帽"
	desc = "只有最负盛名的帽子收藏家才会戴的高顶礼帽。"
	icon_state = "tophat"
	item_state = "that"
	flags_armor_protection = 0

/obj/item/clothing/head/collectable/tophat/super
	name = "收藏款超级高顶礼帽"
	desc = "只有最顶尖的帽子收藏家才会戴的超级高顶礼帽。"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_64.dmi'
	)
	icon_state = "super_top_hat"
	item_state = "super_top_hat"
	worn_x_dimension = 64
	worn_y_dimension = 64
	w_class = SIZE_LARGE

/obj/item/clothing/head/collectable/petehat
	icon_state = "petehat"
	item_state = "petehat"
