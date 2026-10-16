/obj/structure/closet/cabinet
	name = "橱柜"
	desc = "复古永不过时。"
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

/obj/structure/closet/cabinet/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/acloset
	name = "奇怪的柜子"
	desc = "看起来像外星造物！"
	icon_state = "acloset"
	icon_closed = "acloset"
	icon_opened = "aclosetopen"


/obj/structure/closet/gimmick
	name = "管理用物资柜"
	desc = "用于存放那些本不该出现在这里的东西。"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1_open"
	anchored = FALSE

/obj/structure/closet/gimmick/russian
	name = "俄制军剩物资柜"
	desc = "用于存放俄制制式军剩物资的储物柜。"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1_open"

/obj/structure/closet/gimmick/russian/Initialize()
	. = ..()
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/head/ushanka(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)
	new /obj/item/clothing/under/soviet(src)


/obj/structure/closet/gimmick/tacticool
	name = "战术酷装柜"
	desc = "用于存放战术酷装的储物柜。"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1_open"

/obj/structure/closet/gimmick/tacticool/Initialize()
	. = ..()
	new /obj/item/clothing/glasses/eyepatch(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/gloves/swat(src)
	new /obj/item/clothing/gloves/swat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/shoes/swat(src)
	new /obj/item/clothing/shoes/swat(src)
	new /obj/item/clothing/suit/armor/swat(src)
	new /obj/item/clothing/suit/armor/swat(src)


/obj/structure/closet/thunderdome
	name = "\improper 雷霆竞技场装备柜"
	desc = "你需要的一切！"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicate_open"
	anchored = TRUE
/obj/structure/closet/thunderdome/tdred
	name = "红队雷霆竞技场装备柜"

/obj/structure/closet/thunderdome/tdred/Initialize()
	. = ..()
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/clothing/suit/armor/tdome/red(src)
	new /obj/item/weapon/energy/sword(src)
	new /obj/item/weapon/energy/sword(src)
	new /obj/item/weapon/energy/sword(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdgreen
	name = "绿队雷霆竞技场装备柜"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1_open"

/obj/structure/closet/thunderdome/tdgreen/Initialize()
	. = ..()
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/clothing/suit/armor/tdome/green(src)
	new /obj/item/weapon/energy/sword(src)
	new /obj/item/weapon/energy/sword(src)
	new /obj/item/weapon/energy/sword(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/weapon/baton(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)
	new /obj/item/clothing/head/helmet/thunderdome(src)

