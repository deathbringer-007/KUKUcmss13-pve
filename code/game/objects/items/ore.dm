/obj/item/ore
	name = "岩石"
	icon = 'icons/obj/structures/props/mining.dmi'
	icon_state = "ore2"
	black_market_value = 5
	var/oretag

/obj/item/ore/uranium
	name = "沥青铀矿"
	icon_state = "Uranium ore"

	oretag = "uranium"
	black_market_value = 35

/obj/item/ore/iron
	name = "赤铁矿"
	icon_state = "Iron ore"

	oretag = "hematite"
	black_market_value = 25

/obj/item/ore/coal
	name = "含碳岩石"
	icon_state = "Coal ore"

	oretag = "coal"
	black_market_value = 15

/obj/item/ore/glass
	name = "含杂质硅酸盐"
	icon_state = "Glass ore"
	gender = PLURAL
	oretag = "sand"
	black_market_value = 15

/obj/item/ore/phoron
	name = "弗燃素晶体"
	icon_state = "Phoron ore"
	gender = PLURAL
	oretag = "phoron"
	black_market_value = 25

/obj/item/ore/silver
	name = "天然银矿石"
	icon_state = "Silver ore"

	oretag = "silver"
	black_market_value = 25

/obj/item/ore/gold
	name = "天然金矿石"
	icon_state = "Gold ore"

	oretag = "gold"
	black_market_value = 30

/obj/item/ore/diamond
	name = "钻石"
	icon_state = "Diamond ore"
	gender = PLURAL
	oretag = "diamond"
	black_market_value = 30

/obj/item/ore/osmium
	name = "铂原矿"
	icon_state = "Platinum ore"
	oretag = "platinum"
	black_market_value = 30

/obj/item/ore/hydrogen
	name = "氢原料"
	icon_state = "Phazon"
	oretag = "hydrogen"
	black_market_value = 20

/obj/item/ore/slag
	name = "矿渣"
	desc = "完全没用。"
	icon_state = "slag"
	oretag = "slag"
	black_market_value = 0

/obj/item/ore/Initialize()
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/ore/pearl
	name = "珍珠"
	desc = "攒够五十颗就能串成一条项链！"
	icon = 'icons/obj/items/fishing_atoms.dmi'
	icon_state = "pearl"
	oretag = "pearl"
	black_market_value = 60
