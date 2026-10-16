

/obj/item/clothing/head/centhat
	name = "\improper 中央指挥部帽"
	icon_state = "centcom"
	desc = "当皇帝的感觉真不错。"
	item_state = "centhat"
	siemens_coefficient = 0.9
	flags_armor_protection = 0

/obj/item/clothing/head/hairflower
	name = "鲜花发夹"
	icon_state = "hairflower"
	desc = "闻起来很香。"
	item_state = "hairflower"
	flags_armor_protection = 0

/obj/item/clothing/head/powdered_wig
	name = "扑粉假发"
	desc = "一顶扑了粉的假发。"
	icon_state = "pwig"
	item_state = "pwig"

/obj/item/clothing/head/that
	name = "高顶礼帽"
	desc = "看起来像阿米什人的帽子。"
	icon_state = "tophat"
	item_state = "that"
	siemens_coefficient = 0.9
	flags_armor_protection = 0

/obj/item/clothing/head/redcoat
	name = "红衣军帽"
	icon_state = "redcoat"
	desc = "<i>“这大概就是红头兵吧。”</i>"
	flags_armor_protection = 0

/obj/item/clothing/head/mailman
	name = "站务帽"
	icon_state = "mailman"
	desc = "<i>呜——哐当哐当</i>！"
	flags_armor_protection = 0

/obj/item/clothing/head/plaguedoctorhat
	name = "瘟疫医生帽"
	desc = "瘟疫医生曾经使用的帽子，基本没什么用。"
	icon_state = "plaguedoctor"
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	flags_armor_protection = 0

/obj/item/clothing/head/hasturhood
	name = "哈斯塔兜帽"
	desc = "时髦得难以名状。"
	icon_state = "hasturhood"
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEARS|HIDEALLHAIR
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/head/nursehat
	name = "护士帽"
	desc = "能让人迅速认出受过训练的医务人员。"
	icon_state = "nursehat"
	siemens_coefficient = 0.9
	flags_armor_protection = 0

/obj/item/clothing/head/syndicatefake
	name = "红色太空头盔仿制品"
	icon_state = "syndicate"
	item_state = "syndicate"
	desc = "辛迪加特工太空头盔的塑料仿制品。戴上它，你就像个真正的嗜杀辛迪加特工！这是玩具，不能在太空中使用！"
	flags_inventory = COVEREYES|COVERMOUTH
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	anti_hug = 1

/obj/item/clothing/head/cueball
	name = "白球头盔"
	desc = "一颗戴在头上的巨大纯白圆球。戴着这东西到底怎么看路？"
	icon_state = "cueball"
	flags_inventory = COVEREYES|COVERMOUTH
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	item_state="cueball"
	flags_inventory = 0
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/head/greenbandana
	name = "绿色头巾"
	desc = "带有精密纳米科技内衬的绿色头巾。"
	icon_state = "greenbandana"
	item_state = "greenbandana"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_armor_protection = 0

/obj/item/clothing/head/cardborg
	name = "纸箱机器人头盔"
	desc = "用纸箱做的头盔。"
	icon_state = "cardborg_h"
	item_state = "cardborg_h"
	flags_inventory = COVERMOUTH|COVEREYES
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/head/justice
	name = "正义帽"
	desc = "为正义而战！"
	icon_state = "justicered"
	item_state = "justicered"
	flags_inventory = COVERMOUTH|COVEREYES
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR

/obj/item/clothing/head/justice/blue
	icon_state = "justiceblue"
	item_state = "justiceblue"

/obj/item/clothing/head/justice/yellow
	icon_state = "justiceyellow"
	item_state = "justiceyellow"

/obj/item/clothing/head/justice/green
	icon_state = "justicegreen"
	item_state = "justicegreen"

/obj/item/clothing/head/justice/pink
	icon_state = "justicepink"
	item_state = "justicepink"

/obj/item/clothing/head/flatcap
	name = "鸭舌帽"
	desc = "劳动者的帽子。"
	icon_state = "flat_cap"
	item_state = "detective"
	siemens_coefficient = 0.9

/obj/item/clothing/head/pirate
	name = "海盗帽"
	desc = "哟吼！"
	icon_state = "pirate"
	item_state = "pirate"
	flags_armor_protection = 0

/obj/item/clothing/head/hgpiratecap
	name = "海盗帽"
	desc = "哟吼！"
	icon_state = "hgpiratecap"
	item_state = "hgpiratecap"
	flags_armor_protection = 0
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/head/bandana
	name = "海盗头巾"
	desc = "哟吼！"
	icon_state = "bandana"
	item_state = "bandana"

/obj/item/clothing/head/bowler
	name = "圆顶礼帽"
	desc = "绅士们，精英登舰！"
	icon_state = "bowler"
	item_state = "bowler"
	flags_armor_protection = 0

//stylish bs12 hats

/obj/item/clothing/head/bowlerhat
	name = "圆顶礼帽"
	icon_state = "bowler_hat"
	item_state = "bowler_hat"
	desc = "适合身份不凡的绅士。"
	flags_armor_protection = 0

/obj/item/clothing/head/director
	name = "主管帽"
	icon_state = "director_hat"
	item_state = "director_hat"
	desc = "属于某位要人，对各种伤害提供少量防护。"
	flags_armor_protection = BODY_FLAG_HEAD

	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/head/manager
	name = "经理帽"
	icon_state = "manager_hat"
	item_state = "manager_hat"
	desc = "属于某位重要人物，对各种伤害提供少量防护。"
	flags_armor_protection = BODY_FLAG_HEAD

	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/head/beaverhat
	name = "海狸皮礼帽"
	icon_state = "beaver_hat"
	item_state = "beaver_hat"
	desc = "柔软的毡料让这顶帽子既舒适又优雅。"

/obj/item/clothing/head/boaterhat
	name = "平顶草帽"
	icon_state = "boater_hat"
	item_state = "boater_hat"
	desc = "夏日时尚的极致。"

/obj/item/clothing/head/fedora
	name = "\improper 软呢礼帽"
	desc = "大多数人觉得这种职业帽已经过时了。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "fedora_dark"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/fedora/light
	icon_state = "fedora_light"

/obj/item/clothing/head/cowboy

	name = "\improper 牛仔帽"
	desc = "标志性的美国牛仔帽。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "cowboy_dark"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	desc = "做工精细的牛仔帽。"

/obj/item/clothing/head/cowboy/light
	icon_state = "cowboy_light"

/obj/item/clothing/head/feathertrilby
	name = "\improper 羽饰窄檐礼帽"
	icon_state = "feather_trilby"
	item_state = "feather_trilby"
	desc = "插着羽毛，利落又时髦。"

/obj/item/clothing/head/fez
	name = "\improper 土耳其毡帽"
	icon_state = "fez"
	item_state = "fez"
	desc = "你应该戴顶土耳其毡帽。这种帽子很酷。"

//end bs12 hats

/obj/item/clothing/head/witchwig
	name = "女巫装扮假发"
	desc = "咿——嘿嘿嘿嘿嘿！"
	icon_state = "witch"
	item_state = "witch"
	flags_inventory = NO_FLAGS
	flags_inv_hide = HIDEALLHAIR
	siemens_coefficient = 2

/obj/item/clothing/head/chicken
	name = "公鸡装头套"
	desc = "咯咯哒！"
	icon_state = "chickenhead"
	item_state = "chickensuit"
	flags_inventory = NO_FLAGS
	flags_inv_hide = HIDEALLHAIR
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/head/xenos
	name = "异形头盔"
	icon_state = "xenos"
	item_state = "xenos_helm"
	desc = "用异形的几丁质外皮制成的头盔。"
	flags_inventory = COVERMOUTH|COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEALLHAIR
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	anti_hug = 10 //Lel

/obj/item/clothing/head/santa
	name = "\improper 圣诞帽"
	icon_state = "santa_hat_red"
	item_state = "santa_hat_red"
	desc = "嚯嚯嚯，圣诞快乐！"

/obj/item/clothing/head/santa/green
	icon_state = "santa_hat_green"
	item_state = "santa_hat_green"
