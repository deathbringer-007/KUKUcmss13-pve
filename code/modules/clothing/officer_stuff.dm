// Reference: http://www.teuse.net/personal/harrington/hh_bible.htm
// http://www.trmn.org/portal/images/uniforms/rmn/rmn_officer_srv_dress_lrg.png

/obj/item/clothing/head/beret/centcom/officer
	name = "军官贝雷帽"
	desc = "一顶黑色贝雷帽，饰有维兰德-汤谷安保部队的银色鸢形盾和刻剑徽记，向世人宣告佩戴者是公司的守卫者。"
	icon_state = "centcomofficerberet"

/obj/item/clothing/head/beret/centcom/captain
	name = "舰长贝雷帽"
	desc = "一顶白色贝雷帽，饰有维兰德-汤谷安保部队的钴蓝色鸢形盾和刻剑徽记，只有公司海军舰长才有资格佩戴。"
	icon_state = "centcomcaptain"

/obj/item/clothing/shoes/centcom
	name = "礼服皮鞋"
	desc = "擦得一尘不染、锃亮如新。"
	icon_state = "laceups"

/obj/item/clothing/under/rank/centcom/representative
	desc = "太空黑色布料配金色镶边，军服上标有“海军少尉”军衔，左肩印着“N.C.V. 无畏号 CV-286”。"
	name = "\improper 维兰德-汤谷海军制服"
	icon_state = "officer"
	item_state = "g_suit"
	displays_id = 0

/obj/item/clothing/under/rank/centcom/officer
	desc = "太空黑色布料配金色镶边，军服上标有“海军少校”军衔，左肩印着“N.C.V. 无畏号 CV-286”。"
	name = "\improper 维兰德-汤谷军官制服"
	icon_state = "officer"
	item_state = "g_suit"
	displays_id = 0
	item_state_slots = list(WEAR_BODY = "officer")

/obj/item/clothing/under/rank/centcom/captain
	desc = "太空黑色布料配金色镶边，军服上标有“海军上将”军衔，左肩印着“N.C.V. 无畏号 CV-286”。"
	name = "\improper 维兰德-汤谷海军上将制服"
	icon_state = "centcom"
	item_state = "dg_suit"
	displays_id = 0
