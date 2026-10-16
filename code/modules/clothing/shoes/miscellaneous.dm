/obj/item/clothing/shoes/syndigaloshes
	desc = "一双棕鞋，看起来抓地力格外强。"
	name = "棕鞋"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	flags_inventory = NOSLIPPING

	var/list/clothing_choices = list()
	siemens_coefficient = 0.8

/obj/item/clothing/shoes/mime
	name = "默剧演员鞋"
	icon_state = "mime"

/obj/item/clothing/shoes/swat
	name = "\improper SWAT 战术靴"
	desc = "适合你想让局面升温的时候。"
	icon_state = "swat"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_inventory = NOSLIPPING
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "作战靴"
	desc = "适合你真的想让局面升温的时候。"
	icon_state = "swat"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_inventory = NOSLIPPING
	siemens_coefficient = 0.6

	flags_cold_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT

/obj/item/clothing/shoes/space_ninja
	name = "忍者鞋"
	desc = "一双跑鞋。跑步很出色，踢碎脑袋更拿手。"
	icon_state = "s-ninja"
	permeability_coefficient = 0.01
	flags_inventory = NOSLIPPING
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	siemens_coefficient = 0.2

	flags_cold_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT

/obj/item/clothing/shoes/sandal
	desc = "一双相当朴素的木凉鞋。"
	name = "凉鞋"
	icon_state = "sandals"
	flags_armor_protection = 0

/obj/item/clothing/shoes/sandal/marisa
	desc = "一双有魔力的黑鞋。"
	name = "魔法鞋"
	icon_state = "black"
	flags_armor_protection = BODY_FLAG_FEET

/obj/item/clothing/shoes/galoshes
	desc = "橡胶靴。"
	name = "橡胶雨靴"
	icon_state = "galoshes"
	permeability_coefficient = 0.05
	flags_inventory = NOSLIPPING

/obj/item/clothing/shoes/clown_shoes
	desc = "恶作剧者的制式小丑鞋。天哪，真够大的！"
	name = "小丑鞋"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1
	black_market_value = 25
	var/footstep = 1 //used for squeeks whilst walking

/obj/item/clothing/shoes/jackboots
	name = "高筒军靴"
	desc = "用于战斗场合的安保作战靴。时时刻刻，战斗到底。"
	icon_state = "jackboots"
	item_state = "jackboots"
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/cult
	name = "长靴"
	desc = "纳尔-西信徒穿的长靴。"
	icon_state = "cult"
	item_state = "cult"
	siemens_coefficient = 0.7

	flags_cold_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT

/obj/item/clothing/shoes/cyborg
	name = "赛博格靴"
	desc = "赛博格装扮配套的鞋。"
	icon_state = "boots"

/obj/item/clothing/shoes/slippers
	name = "兔兔拖鞋"
	desc = "毛茸茸的！"
	icon_state = "slippers"
	item_state = "slippers"
	w_class = SIZE_SMALL

/obj/item/clothing/shoes/slippers_worn
	name = "破旧的兔兔拖鞋"
	desc = "毛茸茸的……"
	icon_state = "slippers_worn"
	item_state = "slippers_worn"
	w_class = SIZE_SMALL

/obj/item/clothing/shoes/laceup
	name = "系带皮鞋"
	desc = "时尚之巅，而且已经擦亮了！"
	icon_state = "laceups"

/obj/item/clothing/shoes/laceup/brown
	name = "棕色系带皮鞋"
	icon_state = "laceups_brown"

/obj/item/clothing/shoes/swimmingfins
	desc = "帮助你游得更好。"
	name = "游泳脚蹼"
	icon_state = "flippers"
	flags_inventory = NOSLIPPING
	slowdown = SHOES_SLOWDOWN+1


/obj/item/clothing/shoes/snow
	name = "雪地靴"
	desc = "适合你的脚和你的心一样冰冷的时候。"
	icon_state = "swat"
	siemens_coefficient = 0.6
	flags_cold_protection = BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT

/obj/item/clothing/shoes/souto
	name = "索托侠长靴"
	desc = "\improper 索托侠的长靴，比红色索托的冲劲还猛。"
	icon_state = "souto_man"
	item_state = "souto_man"
	flags_inventory = CANTSTRIP|NOSLIPPING
	armor_melee = CLOTHING_ARMOR_HARDCORE
	armor_bullet = CLOTHING_ARMOR_HARDCORE
	armor_laser = CLOTHING_ARMOR_HARDCORE
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_bomb = CLOTHING_ARMOR_HARDCORE
	armor_bio = CLOTHING_ARMOR_HARDCORE
	armor_rad = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_HARDCORE
	flags_inventory = CANTSTRIP|NOSLIPPING
	unacidable = TRUE
