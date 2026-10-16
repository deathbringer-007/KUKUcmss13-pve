/obj/structure/closet/athletic_mixed
	name = "运动服柜"
	desc = "用于存放运动服装的储物柜。"
	icon_state = "purple"
	icon_closed = "purple"
	icon_opened = "purple_open"

/obj/structure/closet/athletic_mixed/Initialize()
	. = ..()
	new /obj/item/clothing/under/shorts/grey(src)
	new /obj/item/clothing/under/shorts/black(src)
	new /obj/item/clothing/under/shorts/red(src)
	new /obj/item/clothing/under/shorts/blue(src)
	new /obj/item/clothing/under/shorts/green(src)
	new /obj/item/clothing/under/swimsuit/red(src)
	new /obj/item/clothing/under/swimsuit/black(src)
	new /obj/item/clothing/under/swimsuit/blue(src)
	new /obj/item/clothing/under/swimsuit/green(src)
	new /obj/item/clothing/under/swimsuit/purple(src)
	new /obj/item/clothing/mask/snorkel(src)
	new /obj/item/clothing/mask/snorkel(src)
	new /obj/item/clothing/shoes/swimmingfins(src)
	new /obj/item/clothing/shoes/swimmingfins(src)



/obj/structure/closet/boxinggloves
	name = "拳击手套柜"
	desc = "用于存放拳击比赛手套的储物柜。"

/obj/structure/closet/boxinggloves/Initialize()
	. = ..()
	new /obj/item/clothing/gloves/boxing/blue(src)
	new /obj/item/clothing/gloves/boxing/green(src)
	new /obj/item/clothing/gloves/boxing/yellow(src)
	new /obj/item/clothing/gloves/boxing(src)


/obj/structure/closet/masks
	name = "面具柜"
	desc = "这是存放摔跤手面具的柜子，欧嘞！"

/obj/structure/closet/masks/Initialize()
	. = ..()
	new /obj/item/clothing/mask/luchador(src)
	new /obj/item/clothing/mask/luchador/rudos(src)
	new /obj/item/clothing/mask/luchador/tecnicos(src)


/obj/structure/closet/lasertag/red
	name = "红队激光对战装备柜"
	desc = "用于存放激光对战装备的储物柜。"
	icon_state = "red"
	icon_closed = "red"
	icon_opened = "red_open"

/obj/structure/closet/lasertag/red/Initialize()
	. = ..()
// new /obj/item/weapon/gun/energy/laser/redtag(src)
// new /obj/item/weapon/gun/energy/laser/redtag(src)
	new /obj/item/clothing/suit/redtag(src)
	new /obj/item/clothing/suit/redtag(src)


/obj/structure/closet/lasertag/blue
	name = "蓝队激光对战装备柜"
	desc = "用于存放激光对战装备的储物柜。"
	icon_state = "blue"
	icon_closed = "blue"
	icon_opened = "blue_open"

/obj/structure/closet/lasertag/blue/Initialize()
	. = ..()
// new /obj/item/weapon/gun/energy/laser/bluetag(src)
// new /obj/item/weapon/gun/energy/laser/bluetag(src)
	new /obj/item/clothing/suit/bluetag(src)
	new /obj/item/clothing/suit/bluetag(src)
