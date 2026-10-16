// STANDARD Sentry
/obj/item/ammo_magazine/sentry
	name = "M30 弹鼓（10x28mm 无壳弹）"
	desc = "UA 571-C 哨戒机枪使用的弹鼓，装有 500 发 10x28mm 无壳弹。机枪弹药耗尽时，将其装入供弹口即可。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "ua571c"
	w_class = SIZE_MEDIUM
	flags_magazine = NO_FLAGS //can't be refilled or emptied by hand
	caliber = "10x28mm"
	max_rounds = 500
	default_ammo = /datum/ammo/bullet/rifle/heavy
	gun_type = null

/obj/item/ammo_magazine/sentry/dropped
	max_rounds = 100
	max_inherent_rounds = 500

/obj/item/ammo_magazine/sentry/premade
	max_rounds = 99999
	current_rounds = 99999

/obj/item/ammo_magazine/sentry/upp
	name = "AK-500 弹鼓（10x31mm 无壳弹）"
	desc = "UPPA 32-H 哨戒机枪使用的 10x31mm 无壳弹弹鼓。机枪弹药耗尽时，将其装入供弹口即可。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "sentry"
	caliber = "10x31mm"
	max_rounds = 350
	default_ammo = /datum/ammo/bullet/rifle/heavy/upp

/obj/item/ammo_magazine/sentry/shotgun
	name = "12 号鹿弹弹鼓"
	desc = "UA 12-G 霰弹哨戒炮使用的弹鼓，装有 50 发 12 号鹿弹。弹药耗尽时，将其装入供弹口即可。"
	caliber = "12g"
	max_rounds = 50
	default_ammo = /datum/ammo/bullet/shotgun/buckshot

/obj/item/ammo_magazine/sentry/wy
	name = "H20 弹鼓（10x42mm 无壳弹）"
	desc = "WY 202-GMA1 智能哨戒炮使用的弹鼓，装有 200 发 10x42mm 无壳弹。弹药耗尽时，将其装入供弹口即可。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/wy.dmi'
	icon_state = "wy22e5"
	caliber = "10x42mm"
	max_rounds = 200

/obj/item/ammo_magazine/sentry/wy/mini
	name = "H16 弹鼓（10x12mm 无壳弹）"
	desc = "WY 14-GRA2 迷你哨戒炮使用的弹鼓，装有 1000 发 10x12mm 无壳弹。弹药耗尽时，将其装入供弹口即可。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/wy.dmi'
	icon_state = "wy22e5"
	caliber = "10x12mm"
	max_rounds = 1000

/obj/item/ammo_magazine/sentry/upp/dropped
	max_rounds = 100

// FLAMER Sentry
/obj/item/ammo_magazine/sentry_flamer
	name = "喷火哨戒炮燃料罐"
	desc = "供 UA 42-F 使用的燃料罐，通常装有 UT-Napthal 燃料，一种黏稠的易燃液态化学品。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "ua571c"
	w_class = SIZE_MEDIUM
	flags_magazine = NO_FLAGS
	caliber = "Napalm B"
	max_rounds = 100
	default_ammo = /datum/ammo/flamethrower/sentry_flamer
	gun_type = null

/obj/item/ammo_magazine/sentry_flamer/glob
	name = "等离子喷火哨戒炮燃料罐"
	desc = "供 UA 60-FP 使用的压缩 UT-Napthal 燃料罐。"
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/glob

/obj/item/ammo_magazine/sentry_flamer/mini
	name = "迷你喷火哨戒炮燃料罐"
	desc = "供 UA 45-FM 使用的 UT-Napthal 燃料罐。"
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/mini

/obj/item/ammo_magazine/sentry_flamer/wy
	name = "维兰德-汤谷喷火哨戒炮燃料罐"
	desc = "供 WY 406-FE2 使用的超稠高黏 Napthal 燃料罐。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/wy.dmi'
	icon_state = "wy22e5"
	caliber = "Sticky Napalm"
	max_rounds = 200
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/wy

/obj/item/ammo_magazine/sentry_flamer/upp
	name = "UPP 喷火哨戒炮燃料罐"
	desc = "供 UPP SDS-R5 喷火哨戒炮使用的超稠凝胶 Napthal 燃料罐。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "uppsds4"
	caliber = "Sticky Napalm"
	max_rounds = 200
	default_ammo = /datum/ammo/flamethrower/sentry_flamer/upp
