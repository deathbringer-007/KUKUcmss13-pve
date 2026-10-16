/obj/structure/gun_rack
	name = "枪架"
	desc = "阿玛特生产的长枪枪架。最初的型号原本支持大量改装，陆战队订购的版本却采用固定槽位，只能容纳M41A步枪。有人说是因为便宜，也有人说，主要原因是陆战队员总能轻易弄坏任何比钨球复杂的东西。"
	icon = 'icons/obj/structures/gun_racks.dmi'
	icon_state = "m41a"
	density = TRUE
	var/allowed_type
	var/populate_type
	var/max_stored = 5
	var/initial_stored = 5

/obj/structure/gun_rack/Initialize()
	. = ..()
	if(!allowed_type)
		icon_state = "m41a_0"
		return

	if(initial_stored)
		var/i = 0
		while(i < initial_stored)
			contents += new populate_type(src)
			i++
	update_icon()

/obj/structure/gun_rack/attackby(obj/item/O, mob/user)
	if(istype(O, allowed_type) && contents.len < max_stored)
		user.drop_inv_item_to_loc(O, src)
		contents += O
		update_icon()

/obj/structure/gun_rack/attack_hand(mob/living/user)
	if(!contents.len)
		to_chat(user, SPAN_WARNING("[src]是空的。"))
		return

	var/obj/stored_obj = contents[contents.len]
	contents -= stored_obj
	user.put_in_hands(stored_obj)
	to_chat(user, SPAN_NOTICE("你从[src]取出[stored_obj]。"))
	playsound(src, "gunequip", 25, TRUE)
	update_icon()

/obj/structure/gun_rack/update_icon()
	if(contents.len)
		icon_state = "[initial(icon_state)]_[contents.len]"
	else
		icon_state = "[initial(icon_state)]_0"

/obj/structure/gun_rack/m41
	allowed_type = /obj/item/weapon/gun/rifle/m41aMK1
	populate_type = /obj/item/weapon/gun/rifle/m41aMK1

/obj/structure/gun_rack/m41/unloaded
	populate_type = /obj/item/weapon/gun/rifle/m41aMK1/unloaded

/obj/structure/gun_rack/m41/empty
	initial_stored = 0

/obj/structure/gun_rack/type71
	icon_state = "type71"
	desc = "某种杂牌枪架。按特种部队和联盟军规定，武器应存放在保险柜中，仅在必要时发放。当然，大多数（并非全部！）单位都无视这条规定，只有检查时才把枪械放进保险柜。"
	max_stored = 6
	initial_stored = 6
	allowed_type = /obj/item/weapon/gun/rifle/type71
	populate_type = /obj/item/weapon/gun/rifle/type71

/obj/structure/gun_rack/type71/unloaded
	populate_type = /obj/item/weapon/gun/rifle/type71/unloaded

/obj/structure/gun_rack/type71/empty
	initial_stored = 0

/obj/structure/gun_rack/apc
	name = "APC ammo compartment"
	icon_state = "frontal"
	desc = "Uhoh. You shouldn't be seeing this."

/obj/structure/gun_rack/apc/frontal
	name = "前置炮弹药储存舱"
	icon_state = "frontal"
	desc = "用于存放装甲运兵车“铅雨RE-RE700前置炮”弹药的小型舱室。"
	max_stored = 2
	initial_stored = 0
	allowed_type = /obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon

/obj/structure/gun_rack/apc/boyars
	name = "双联炮弹药储存舱"
	icon_state = "boyars"
	desc = "用于存放装甲运兵车“PARS-159博雅尔双联炮”弹药的小型舱室。"
	max_stored = 2
	initial_stored = 0
	allowed_type = /obj/item/ammo_magazine/hardpoint/boyars_dualcannon

/obj/structure/gun_rack/apc/frontal/aa
	name = "垂直发射系统弹药储存舱"
	icon_state = "boyars"
	desc = "用于存放载具垂直发射阵列弹药的小型舱室。"
	max_stored = 2
	initial_stored = 0
	allowed_type = /obj/item/ammo_magazine/hardpoint/towlauncher/aa

/obj/structure/gun_rack/apc/boyars/aa
	name = "防空炮弹药储存舱"
	icon_state = "frontal"
	desc = "用于存放载具“铅雨RE-RE965防空系统”弹药的小型舱室。"
	max_stored = 2
	initial_stored = 0
	allowed_type = /obj/item/ammo_magazine/hardpoint/m56_cupola/quad_cannon

/obj/structure/gun_rack/m41/recon
	icon_state = "m41arecon"
	populate_type = /obj/item/weapon/gun/rifle/m41aMK1/forecon

/obj/structure/gun_rack/m41/recon/unloaded
	populate_type = /obj/item/weapon/gun/rifle/m41aMK1/forecon/unloaded

/obj/structure/gun_rack/flamer
	name = "M240A1焚烧器枪架"
	icon_state = "m240"
	desc = "阿玛特生产的长枪枪架。最初的型号原本支持大量改装，陆战队订购的版本却采用固定槽位，只能容纳M240A1焚烧器。有人说是因为便宜，也有人说，主要原因是陆战队员总能轻易弄坏任何比钨球复杂的东西。"
	max_stored = 2
	initial_stored = 2
	allowed_type = /obj/item/weapon/gun/flamer
	populate_type = /obj/item/weapon/gun/flamer

/obj/structure/gun_rack/flamer/unloaded
	populate_type = /obj/item/weapon/gun/flamer/unloaded

/obj/structure/gun_rack/flamer/empty
	initial_stored = 0

/obj/structure/gun_rack/uppflamer
	name = "LPO80焚烧器枪架"
	icon_state = "lpo80"
	desc = "可存放两具LPO80焚烧器的枪架。"
	max_stored = 2
	initial_stored = 2
	allowed_type = /obj/item/weapon/gun/flamer/upp
	populate_type = /obj/item/weapon/gun/flamer/upp

/obj/structure/gun_rack/uppflamer/unloaded
	populate_type = /obj/item/weapon/gun/flamer/upp/unloaded

/obj/structure/gun_rack/flamer/empty
	initial_stored = 0

/obj/structure/gun_rack/mk221
	name = "M120霰弹枪架"
	icon_state = "mk221"
	desc = "阿玛特生产的长枪枪架。最初的型号原本支持大量改装，陆战队订购的版本却采用固定槽位，只能容纳M120战术霰弹枪。有人说是因为便宜，也有人说，主要原因是陆战队员总能轻易弄坏任何比钨球复杂的东西。"
	max_stored = 2
	initial_stored = 2
	allowed_type = /obj/item/weapon/gun/shotgun/combat
	populate_type = /obj/item/weapon/gun/shotgun/combat

/obj/structure/gun_rack/mk221/empty
	initial_stored = 0

/obj/structure/gun_rack/m20a
	name = "M20A脉冲步枪架"
	icon_state = "m20a"
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/rifle/m20a
	populate_type = /obj/item/weapon/gun/rifle/m20a

/obj/structure/gun_rack/m20a/empty
	initial_stored = 0

/obj/structure/gun_rack/m20a/unloaded
	initial_stored = 5
	populate_type = /obj/item/weapon/gun/rifle/m20a/unloaded

/obj/structure/gun_rack/m41/elite
	name = "M41A2脉冲步枪架"
	icon_state = "m41a_elite"
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/rifle/m41aMK1/elite
	populate_type = /obj/item/weapon/gun/rifle/m41aMK1/elite

/obj/structure/gun_rack/m41/elite/empty
	initial_stored = 0

/obj/structure/gun_rack/m41/elite/unloaded
	initial_stored = 5
	populate_type = /obj/item/weapon/gun/rifle/m41aMK1/elite/unloaded

/obj/structure/gun_rack/m41/elite/unloaded/platoon
	populate_type = /obj/item/weapon/gun/rifle/m41aMK1/elite/unloaded/platoon

/obj/structure/gun_rack/ag80
	icon_state = "ag80"
	desc = "某种杂牌枪架。按特种部队和联盟军规定，武器应存放在保险柜中，仅在必要时发放。当然，大多数（并非全部！）单位都无视这条规定，只有检查时才把枪械放进保险柜。"
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/rifle/ag80
	populate_type = /obj/item/weapon/gun/rifle/ag80

/obj/structure/gun_rack/ag80/unloaded
	populate_type = /obj/item/weapon/gun/rifle/ag80/unloaded

/obj/structure/gun_rack/ag80/empty
	initial_stored = 0

/obj/structure/gun_rack/nsg
	name = "NSG L23A1脉冲步枪架"
	icon_state = "nsg"
	desc = "阿玛特生产的长枪枪架。这一款最多可存放五支L23A1脉冲步枪。"
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/rifle/nsg23/rmc
	populate_type = /obj/item/weapon/gun/rifle/nsg23/rmc

/obj/structure/gun_rack/nsg/unloaded
	populate_type = /obj/item/weapon/gun/rifle/nsg23/rmc/unloaded

/obj/structure/gun_rack/nsg/Empty
	initial_stored = 0
