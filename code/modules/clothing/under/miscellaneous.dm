/obj/item/clothing/under/pj/red
	name = "红色睡衣"
	desc = "睡觉穿的衣服。"
	icon_state = "red_pyjamas"
	item_state = "w_suit"

/obj/item/clothing/under/pj/blue
	name = "蓝色睡衣"
	desc = "睡觉穿的衣服。"
	icon_state = "blue_pyjamas"
	item_state = "w_suit"

/obj/item/clothing/under/scratch
	name = "白色西装"
	desc = "适合优秀主人的白色西装。"
	icon_state = "scratch"

/obj/item/clothing/under/sl_suit
	desc = "一套很有阿米什风格的西装。"
	name = "阿米什西装"
	icon_state = "sl_suit"

/obj/item/clothing/under/waiter
	name = "侍者制服"
	desc = "一套非常利落的制服，专门留有放小费的口袋。"
	icon_state = "waiter"

/obj/item/clothing/under/rank/mailman
	name = "邮差连体服"
	desc = "<i>“特快专递！”</i>"
	icon_state = "mailman"
	item_state = "b_suit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/centcom_officer
	desc = "中央指挥部军官穿着的连体服。"
	name = "\improper 中央指挥部军官连体服"
	icon_state = "officer"
	item_state = "g_suit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/rank/centcom_commander
	desc = "中央指挥部最高层指挥官穿着的连体服。"
	name = "\improper 中央指挥部军官连体服"
	icon_state = "centcom"
	item_state = "dg_suit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/space
	name = "\improper NASA连体服"
	desc = "带有NASA标志，使用能适应太空环境的材料制成。"
	icon_state = "black"
	item_state = "bl_suit"
	w_class = SIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROT

/obj/item/clothing/under/suit_jacket
	name = "黑色西装"
	desc = "黑色西装搭配红领带，非常正式。"
	icon_state = "black_suit"
	item_state = "bl_suit"

/obj/item/clothing/under/suit_jacket/really_black
	name = "高管西装"
	desc = "正式的黑色西装搭配红领带，专为站上精英准备。"
	icon_state = "really_black_suit"
	item_state = "bl_suit"

/obj/item/clothing/under/suit_jacket/female
	name = "高管西装"
	desc = "正式的女士裤装西服，专为站上精英准备。"
	icon_state = "black_suit_fem"

/obj/item/clothing/under/suit_jacket/red
	name = "红色西装"
	desc = "红色西装搭配蓝领带，颇为正式。"
	icon_state = "red_suit"
	item_state = "r_suit"

/obj/item/clothing/under/blackskirt
	name = "红色裙装"
	desc = "黑色开衫搭配红色裙子，相当漂亮！"
	icon_state = "blackskirt"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS

/obj/item/clothing/under/schoolgirl
	name = "女学生制服"
	desc = "简直和我看的日本动画里一模一样！"
	icon_state = "schoolgirl"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN

/obj/item/clothing/under/overalls
	name = "劳动者背带服"
	desc = "一套结实耐用、适合干活的背带服。"
	icon_state = "overalls"
	item_state = "lb_suit"

/obj/item/clothing/under/pirate
	name = "海盗服"
	desc = "呀嗬！"
	icon_state = "pirate"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS

/obj/item/clothing/under/kutjevo
	name = "库特耶沃连体服"
	desc = "库特耶沃工人穿着的耐用连体服。"
	icon_state = "kutjevo_jumper"
	item_state = "kutjevo_jumper"

/obj/item/clothing/under/kutjevo/drysuit
	name = "库特耶沃干式防水服"
	desc = "库特耶沃工人穿着的耐用干式防水服。"
	icon_state = "kutjevo_drysuit"
	item_state = "kutjevo_drysuit"


/obj/item/clothing/under/soviet
	name = "苏式制服"
	desc = "为了祖国！"
	icon_state = "soviet"

/obj/item/clothing/under/rank/veteran/soviet_uniform_01
	name = "苏式军服"
	desc = "布料结实得团结一心，足以让资本主义裁缝嫉妒。"
	icon_state = "soviet_uniform_01"
	item_state = "soviet_uniform_01_d"
	flags_jumpsuit = UNIFORM_SLEEVE_ROLLABLE

/obj/item/clothing/under/rank/miner
	desc = "一套利落的连体服，配有结实的背带裤，脏得很。"
	name = "矿工连体服"
	icon_state = "miner"

/obj/item/clothing/under/redcoat
	name = "红衫军制服"
	desc = "看起来很老旧。"
	icon_state = "redcoat"

/obj/item/clothing/under/kilt
	name = "苏格兰短裙"
	desc = "包含鞋子和格纹披肩。"
	icon_state = "kilt"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_FEET

//wedding stuff
/obj/item/clothing/under/wedding
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS

/obj/item/clothing/under/wedding/bride_orange
	name = "橙色婚纱"
	desc = "一件宽大蓬松的橙色裙子。"
	icon_state = "bride_orange"
	flags_inv_hide = HIDESHOES

/obj/item/clothing/under/wedding/bride_purple
	name = "紫色婚纱"
	desc = "一件宽大蓬松的紫色裙子。"
	icon_state = "bride_purple"
	flags_inv_hide = HIDESHOES

/obj/item/clothing/under/wedding/bride_blue
	name = "蓝色婚纱"
	desc = "一件宽大蓬松的蓝色裙子。"
	icon_state = "bride_blue"
	flags_inv_hide = HIDESHOES

/obj/item/clothing/under/wedding/bride_red
	name = "红色婚纱"
	desc = "一件宽大蓬松的红色裙子。"
	icon_state = "bride_red"
	flags_inv_hide = HIDESHOES

/obj/item/clothing/under/wedding/bride_white
	name = "丝绸婚纱"
	desc = "用上等丝绸制成的白色婚纱。"
	icon_state = "bride_white"
	flags_inv_hide = HIDESHOES
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN

/obj/item/clothing/under/assistantformal
	name = "助理礼服"
	desc = "一套助理的正式服装。至今没人知道助理为什么需要礼服。"
	icon_state = "assistant_formal"
	item_state = "gy_suit"

/obj/item/clothing/under/suit_jacket/charcoal
	name = "炭灰色西装"
	desc = "炭灰色西装搭配红领带，非常专业。"
	icon_state = "charcoal_suit"

/obj/item/clothing/under/suit_jacket/navy
	name = "海军蓝西装"
	desc = "海军蓝西装搭配红领带，专为站上精英准备。"
	icon_state = "navy_suit"

/obj/item/clothing/under/suit_jacket/burgundy
	name = "酒红色西装"
	desc = "酒红色西装搭配黑领带，颇为正式。"
	icon_state = "burgundy_suit"

/obj/item/clothing/under/suit_jacket/checkered
	name = "格纹西装"
	desc = "你这套西装真不错啊。要是出了什么意外，可就可惜了，对吧？"
	icon_state = "checkered_suit"

/obj/item/clothing/under/suit_jacket/tan
	name = "棕褐色西装"
	desc = "棕褐色西装搭配黄领带，利落而休闲。"
	icon_state = "tan_suit"

/obj/item/clothing/under/suit_jacket/stowaway
	name = "脏西装"
	desc = "脏兮兮的西装搭配黄领带，看起来饱经风霜。"
	icon_state = "stowaway_uniform"

/obj/item/clothing/under/serviceoveralls
	name = "工人服"
	desc = "标准的劳动者形象。不过你未必真在干活。"
	icon_state = "mechanic"

/obj/item/clothing/under/suit_jacket/director
	name = "主管西装"
	desc = "一套散发着权威气息的西装，属于某位大人物。"
	item_state = "director_uniform"
	icon_state = "director_uniform"

/obj/item/clothing/under/suit_jacket/manager
	desc = "由具备“公司经理”任职本领的人员穿着的西装。"
	name = "经理西装"
	icon_state = "manager_uniform"
	item_state = "manager_uniform"

/obj/item/clothing/under/suit_jacket/trainee
	name = "实习生制服"
	desc = "带有维兰德-汤谷徽章的制服，徽章下印着“实习生”。"
	icon_state = "trainee_uniform"
	item_state = "trainee_uniform"
