


//-------------------------------------------------------
//M41A (MK2) PULSE RIFLE AMMUNITION

/obj/item/ammo_magazine/rifle
	name = "\improper M41A弹匣（10x24mm）"
	desc = "10mm突击步枪弹匣。"
	caliber = "10x24mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "m41a"
	item_state = "generic_mag"
	w_class = SIZE_MEDIUM
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/m41a
	ammo_band_icon = "+m41a_band"
	ammo_band_icon_empty = "+m41a_band_e"

/obj/item/ammo_magazine/rifle/extended
	name = "\improper M41A扩容弹匣（10x24mm）"
	desc = "10mm突击步枪扩容弹匣。"
	icon_state = "m41a_extended"
	max_rounds = 60
	bonus_overlay = "m41a_ex"

/obj/item/ammo_magazine/rifle/incendiary
	name = "\improper M41A燃烧弹匣（10x24mm）"
	desc = "10mm突击步枪弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/explosive
	name = "\improper M41A爆破弹匣（10x24mm）"
	desc = "10mm突击步枪弹匣。老天……千万别打中友军。"
	default_ammo = /datum/ammo/bullet/rifle/explosive
	ammo_band_color = AMMO_BAND_COLOR_EXPLOSIVE

/obj/item/ammo_magazine/rifle/heap
	name = "\improper M41A高爆穿甲弹匣（10x24mm）"
	desc = "10mm高爆穿甲弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/ap
	name = "\improper M41A穿甲弹匣（10x24mm）"
	desc = "10mm穿甲弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/le
	name = "\improper M41A轻型爆破弹匣（10x24mm）"
	desc = "10mm削甲弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/le
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/penetrating
	name = "\improper M41A穿墙弹匣（10x24mm）"
	desc = "10mm穿墙弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/toxin
	name = "\improper M41A毒素弹匣（10x24mm）"
	desc = "10mm毒素弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN


/obj/item/ammo_magazine/rifle/rubber
	name = "M41A橡胶弹匣（10x24mm）"
	desc = "装有橡胶弹的10mm弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/tracer
	name = "\improper M41A曳光弹匣（10x24mm）"
	desc = "装有曳光弹的10mm突击步枪弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/tracer

//-------------------------------------------------------
//M41A (MK1) TRUE AND ORIGINAL

/obj/item/ammo_magazine/rifle/m41aMK1
	name = "\improper M41A弹匣（10x24mm）"
	desc = "M41A使用的长方形盒式弹匣，可装99发10x24mm无壳弹。"
	icon_state = "m41a_mk1"
	max_rounds = 99
	gun_type = /obj/item/weapon/gun/rifle/m41aMK1
	default_ammo = /datum/ammo/bullet/rifle
	ammo_band_icon = "+m41a_mk1_band"
	ammo_band_icon_empty = "+m41a_mk1_band_e"
	bonus_overlay = "m41a_mk1_overlay"

/obj/item/ammo_magazine/rifle/m41aMK1/rubber
	name = "\improper M41A橡胶弹匣"
	desc = "M41A使用的长方形盒式弹匣，可装99发10x24mm低致命性无壳橡胶弹。注意，是低致命性，不是非致命。"
	default_ammo = /datum/ammo/bullet/rifle/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/m41aMK1/ap
	name = "\improper M41A穿甲弹匣（10x24mm）"
	desc = "M41A使用的长方形盒式弹匣，可装99发10x24mm钢芯无壳穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/m41aMK1/heap
	name = "\improper M41A高爆穿甲弹匣（10x24mm）"
	desc = "M41A使用的长方形盒式弹匣，可装99发10x24mm M309无壳高爆穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/m41aMK1/incendiary
	name = "\improper M41A MK1燃烧弹匣（10x24mm）"
	desc = "M41A使用的长方形盒式弹匣，可装99发10x24mm无壳燃烧弹。"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/m41aMK1/toxin
	name = "\improper M41A MK1毒素弹匣（10x24mm）"
	desc = "仅适配旧款M41A MK1的长方形盒式弹匣，最多可装99发弹药。这个弹匣装有毒素弹。"
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/rifle/m41aMK1/penetrating
	name = "\improper M41A MK1穿墙弹匣（10x24mm）"
	desc = "仅适配旧款M41A MK1的长方形盒式弹匣，最多可装99发弹药。这个弹匣装有穿墙弹。"
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/m41aMK1/recon
	icon_state = "m41a_mk1_recon"
	current_rounds = 95
	bonus_overlay = "m41a_mk1_recon_overlay"

/obj/item/ammo_magazine/rifle/m41aMK1/tracer
	name = "\improper M41A MK1曳光弹匣（10x24mm）"
	desc = "装有曳光弹的10mm突击步枪弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/tracer

//-------------------------------------------------------
//M49A, l42 reskin, same stats as before but different, lore friendly, shell.

/obj/item/ammo_magazine/rifle/m49a
	name = "\improper M49A弹匣（10x28mm）"
	desc = "装有M49A战斗步枪使用的标准10x28mm弹药。"
	icon_state = "m49a"
	caliber = "10x28mm"
	default_ammo = /datum/ammo/bullet/rifle/heavy
	max_rounds = 30
	gun_type = /obj/item/weapon/gun/rifle/m49a
	ammo_band_icon = "+m49a_band"
	ammo_band_icon_empty = "+m49a_band_e"

/obj/item/ammo_magazine/rifle/m49a/ap
	name = "\improper M49A穿甲弹匣（10x28mm）"
	desc = "装有M49A战斗步枪使用的10x28mm穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/ap
	max_rounds = 30
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/m49a/ext
	name = "\improper M49A扩容弹匣（10x28mm）"
	desc = "装有M49A战斗步枪使用的10x28mm穿甲弹。额外增加10发容量，总容量40发。"
	icon_state = "m49a_extended"
	bonus_overlay = "m49a_ex"
	max_rounds = 40

/obj/item/ammo_magazine/rifle/m49a/rubber
	name = "M49A橡胶弹匣（10x28mm）"
	desc = "装有M49A战斗步枪使用的低致命性10x28mm橡胶弹。"
	default_ammo = /datum/ammo/bullet/rifle/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/m49a/heap
	name = "\improper M49A高爆穿甲弹匣（10x28mm）"
	desc = "装有M49A战斗步枪使用的10x28mm高爆穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/m49a/penetrating
	name = "\improper M49A穿墙弹匣（10x28mm）"
	desc = "装有M49A战斗步枪使用的10x28mm穿墙弹。"
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/m49a/incendiary
	name = "\improper M49A燃烧弹匣（10x28mm）"
	desc = "装有M49A战斗步枪使用的10x28mm燃烧弹。"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

//-------------------------------------------------------
//XM40 AKA SOF RIFLE FROM HELL (It's an EM-2, a prototype of the real world L85A1 way back from the 1940s. We've given it a blue plastic shell and an integral suppressor)
/obj/item/ammo_magazine/rifle/xm40
	name = "\improper XM40弹匣（10x24mm）"
	desc = "XM40脉冲步枪使用的短宽型大容量双排弹匣，装填10x24mm穿甲弹。最多容纳60发，另可在膛内装1发。"
	icon_state = "m40_sd"
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/m41aMK1/xm40
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_magazine/rifle/xm40/heap
	name = "\improper XM40高爆穿甲弹匣（10x24mm）"
	desc = "XM40脉冲步枪使用的短宽型大容量双排弹匣，装填10x24mm高爆穿甲弹。最多容纳60发，另可在膛内装1发。"
	icon_state = "m40_sd_heap"
	max_rounds = 60
	default_ammo = /datum/ammo/bullet/rifle/heap

//-------------------------------------------------------
//MAR-40 AK CLONE //AK47 and FN FAL together as one.

/obj/item/ammo_magazine/rifle/mar40
	name = "\improper MAR弹匣（8.8x29mm）"
	desc = "MAR系列枪械使用的8.8x29mm弹匣。"
	caliber = "8.8x29mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "mar40"
	default_ammo = /datum/ammo/bullet/rifle/mar40
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/mar40
	w_class = SIZE_MEDIUM

/obj/item/ammo_magazine/rifle/mar40/extended
	name = "\improper MAR扩容弹匣（8.8x29mm）"
	desc = "8.8x29mm弹匣，弹药容量高于普通弹匣。"
	max_rounds = 60
	bonus_overlay = "mar40_ex"
	icon_state = "mar40_extended"

/obj/item/ammo_magazine/rifle/mar40/lmg
	name = "\improper MAR弹鼓（8.8x29mm）"
	desc = "MAR-50轻机枪使用的8.8x29mm弹鼓。"
	caliber = "8.8x29mm"
	icon_state = "mar50"
	max_rounds = 100
	gun_type = /obj/item/weapon/gun/rifle/mar40/lmg

//-------------------------------------------------------
//M16 RIFLE

/obj/item/ammo_magazine/rifle/m16
	name = "\improper M16弹匣"
	desc = "M16突击步枪及其仿制型号使用的5.56x45mm全金属被甲弹匣，容量20发。"
	caliber = "5.56x45mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "m16"
	default_ammo = /datum/ammo/bullet/rifle/m16
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/m16
	w_class = SIZE_MEDIUM
	ammo_band_icon = "+m16_band"
	ammo_band_icon_empty = "+m16_band_e"

/obj/item/ammo_magazine/rifle/m16/extended
	name = "\improper M16扩容弹匣"
	desc = "M16突击步枪及其仿制型号使用的5.56x45mm全金属被甲弹匣，容量30发。"
	caliber = "5.56x45mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "m16"
	max_rounds = 30
	gun_type = /obj/item/weapon/gun/rifle/m16
	w_class = SIZE_MEDIUM
	ammo_band_icon = "+m16_band"
	ammo_band_icon_empty = "+m16_band_e"

/obj/item/ammo_magazine/rifle/m16/ap
	name = "\improper M16穿甲弹匣"
	desc = "M16突击步枪及其仿制型号使用的5.56x45mm穿甲弹匣，容量20发。"
	caliber = "5.56x45mm"
	default_ammo = /datum/ammo/bullet/rifle/m16/ap
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/m16
	w_class = SIZE_MEDIUM
	ammo_band_color = AMMO_BAND_COLOR_AP

//-------------------------------------------------------
//AR10 RIFLE

/obj/item/ammo_magazine/rifle/ar10
	name = "\improper AR10弹匣（7.62x51mm）"
	desc = "AR10突击步枪使用的7.62x51mm弹匣。"
	caliber = "7.62x51mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "ar10"
	default_ammo = /datum/ammo/bullet/rifle/ar10
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/ar10
	w_class = SIZE_MEDIUM

//-------------------------------------------------------
//UPP TYPE 71 RIFLE

/obj/item/ammo_magazine/rifle/type71
	name = "\improper 71式弹匣（10x27mm）"
	desc = "71式步枪使用的10x27mm大容量四排弹匣。"
	caliber = "10x27mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "type71"
	ammo_band_icon = "+type71_band"
	ammo_band_icon_empty = "+type71_band_e"
	default_ammo = /datum/ammo/bullet/rifle/upp
	max_rounds = 60
	gun_type = /obj/item/weapon/gun/rifle/type71

/obj/item/ammo_magazine/rifle/type71/rubber
	name = "\improper 71式橡胶弹匣（10x27mm）"
	desc = "71式步枪使用的10x27mm大容量四排弹匣，装有低致命性橡胶弹。"
	default_ammo = /datum/ammo/bullet/rifle/upp/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/type71/ap
	name = "\improper 71式穿甲弹匣（10x27mm）"
	desc = "71式步枪使用的10x27mm大容量四排弹匣，装有穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/upp/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/type71/ap/penetrating
	name = "\improper 71式穿甲弹匣（10x27mm）"
	desc = "71式步枪使用的10x27mm大容量四排弹匣，装有穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/upp/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/type71/heap
	name = "\improper 71式高爆穿甲弹匣（10x27mm）"
	desc = "71式步枪使用的10x27mm大容量四排弹匣，装有标准高爆穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/upp/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

//-------------------------------------------------------
//UPP AG80 RIFLE

/obj/item/ammo_magazine/rifle/ag80
	name = "\improper AG80弹匣（9.7x16mm）"
	desc = "AG80步枪使用的9.7x16mm大容量弹匣。"
	caliber = "9.7x16mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "ag80"
	ammo_band_icon = "+ag80_band"
	ammo_band_icon_empty = "+ag80_band_e"
	default_ammo = /datum/ammo/bullet/rifle/ag80 //need to reference the actual ammo designed for the carbine
	max_rounds = 99
	gun_type = /obj/item/weapon/gun/rifle/ag80

/obj/item/ammo_magazine/rifle/ag80/ap
	name = "\improper AG80穿甲弹匣（9.7x16mm）"
	desc = "AG80步枪使用的9.7x16mm大容量弹匣，装有钢芯穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/ag80/ap //need to reference the actual ammo designed for the carbine
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/ag80/heap
	name = "\improper AG80高爆穿甲弹匣（9.7x16mm）"
	desc = "AG80步枪使用的9.7x16mm大容量弹匣，装有高爆穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/ag80/heap //need to reference the actual ammo designed for the carbine
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/ag80/rubber
	name = "\improper AG80橡胶弹匣（9.7x16mm）"
	desc = "AG80步枪使用的9.7x16mm大容量弹匣，装有低致命性橡胶弹。"
	default_ammo = /datum/ammo/bullet/rifle/ag80/rubber //need to reference the actual ammo designed for the carbine
	ammo_band_color = AMMO_BAND_COLOR_RUBBER
//-------------------------------------------------------
//CANC LW-317 RIFLE

/obj/item/ammo_magazine/rifle/lw317
	name = "\improper LW-317弹匣（6x38mm）"
	desc = "LW-317卡宾枪使用的6x38mm大容量顶部装填弹匣。"
	caliber = "6x38mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "lw317"
	ammo_band_icon = "+lw317_band"
	ammo_band_icon_empty = "+lw317_band_e"
	default_ammo = /datum/ammo/bullet/rifle/lw317
	max_rounds = 55
	gun_type = /obj/item/weapon/gun/rifle/lw317

/obj/item/ammo_magazine/rifle/lw317/ap
	name = "\improper LW-317穿甲弹匣（6x38mm）"
	desc = "LW-317卡宾枪使用的6x38mm大容量顶部装填穿甲弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/lw317/ap
	ammo_band_color = AMMO_BAND_COLOR_AP
	bonus_overlay = "lw317apoverlay"
//-------------------------------------------------------
//L42A Battle Rifle

/obj/item/ammo_magazine/rifle/l42a
	name = "\improper L42A弹匣（10x24mm）"
	desc = "10mm战斗步枪弹匣。"
	caliber = "10x24mm"
	icon_state = "l42mk1"
	bonus_overlay = "l42_mag_overlay"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 25
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM
	ammo_band_icon = "+l42mk1_band"
	ammo_band_icon_empty = "+l42mk1_band_e"

/obj/item/ammo_magazine/rifle/l42a/ap
	name = "\improper L42A穿甲弹匣（10x24mm）"
	desc = "10mm战斗步枪穿甲弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/l42a/le
	name = "\improper L42A轻型爆破弹匣（10x24mm）"
	desc = "10mm战斗步枪削甲弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/le
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/rifle/l42a/rubber
	name = "L42A橡胶弹匣（10x24mm）"
	default_ammo = /datum/ammo/bullet/rifle/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/rifle/l42a/heap
	name = "\improper L42A高爆穿甲弹匣（10x24mm）"
	desc = "10mm战斗步枪高爆穿甲弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/l42a/penetrating
	name = "\improper L42A穿墙弹匣（10x24mm）"
	default_ammo = /datum/ammo/bullet/rifle/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/rifle/l42a/toxin
	name = "\improper L42A毒素弹匣（10x24mm）"
	desc = "10mm战斗步枪毒素弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/rifle/l42a/extended
	name = "\improper L42A扩容弹匣（10x24mm）"
	desc = "10mm战斗步枪扩容弹匣。"
	caliber = "10x24mm"
	icon_state = "l42mk1_extended"
	bonus_overlay = "l42_ex_overlay"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 35
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM

/obj/item/ammo_magazine/rifle/l42a/incendiary
	name = "\improper L42A燃烧弹匣（10x24mm）"
	desc = "10mm战斗步枪燃烧弹匣。"
	caliber = "10x24mm"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	max_rounds = 20
	gun_type = /obj/item/weapon/gun/rifle/l42a
	w_class = SIZE_MEDIUM
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/l42a/abr40
	name = "\improper ABR-40弹匣（10x24mm）"
	desc = "装有全金属被甲弹的ABR-40弹匣，用于靶场练习或狩猎。理论上与L42A战斗步枪兼容。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "abr40"
	bonus_overlay = "abr40_mag_overlay"
	max_rounds = 12
	w_class = SIZE_SMALL
	ammo_band_icon = "+abr40_band"
	ammo_band_icon_empty = "+abr40_band_e"

/obj/item/ammo_magazine/rifle/l42a/abr40/holo_target
	name = "\improper ABR-40全息标记弹匣（10x24mm）"
	desc = "装有全息标记弹的ABR-40弹匣，主要用于突出显示猎物，便于锁定目标。理论上与L42A战斗步枪兼容。"
	default_ammo = /datum/ammo/bullet/rifle/holo_target/hunting
	ammo_band_color = AMMO_BAND_COLOR_HOLOTARGETING

//M20A

/obj/item/ammo_magazine/rifle/m20a
	name = "\improper M20A弹匣（10x24mm）"
	desc = "10mm突击步枪弹匣。"
	caliber = "10x24mm"
	icon_state = "m20a"
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/m20a
	w_class = SIZE_MEDIUM
	ammo_band_icon = "+m20a_band"
	ammo_band_icon_empty = "+m20a_band_e"
//-------------------------------------------------------
// NSG 23 ASSAULT RIFLE - PMC PRIMARY RIFLE

/obj/item/ammo_magazine/rifle/nsg23
	name = "\improper NSG 23弹匣（8.5x33mm）"
	desc = "适配NSG 23和L23A1突击步枪的大容量弹鼓。"
	caliber = "8.5x33mm"
	default_ammo = /datum/ammo/bullet/rifle/twe
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/wy.dmi'
	icon_state = "nsg23"
	item_state = "nsg23"
	bonus_overlay = "nsg23_mag_overlay" //needs to be an overlay, as the mag has a hole that would be filled over by the ext overlay
	max_rounds = 65
	gun_type = /obj/item/weapon/gun/rifle/nsg23
	ammo_band_icon = "+nsg23_band"
	ammo_band_icon_empty = "+nsg23_band_e"

/obj/item/ammo_magazine/rifle/nsg23/ap
	name = "\improper NSG 23穿甲弹匣（8.5x33mm）"
	desc = "适配NSG 23和L23A1突击步枪的大容量弹鼓，装有穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/rifle/nsg23/heap
	name = "\improper NSG 23高爆穿甲弹匣（8.5x33mm）"
	desc = "适配NSG 23和L23A1突击步枪的大容量弹鼓，装有爆炸弹头穿甲弹。"
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

//--------------------------------------------------------
//Bolt action rifle ammo
/obj/item/ammo_magazine/rifle/boltaction
	name = "\improper 巴希拉-阿姆斯特朗弹匣（6.5mm）"
	desc = "巴希拉-阿姆斯特朗猎枪使用的弹匣，符合民用猎枪15发弹药的容量限制。"
	caliber = "6.5mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "hunting"
	default_ammo = /datum/ammo/bullet/sniper/crude
	max_rounds = 10
	gun_type = /obj/item/weapon/gun/boltaction
	w_class = SIZE_SMALL

/obj/item/ammo_magazine/rifle/boltaction/vulture
	name = "\improper M707“秃鹫”弹匣（20x102mm）"
	desc = "M707“秃鹫”反器材步枪使用的弹匣，最多容纳4发硕大的弹药。"
	caliber = "20x102mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "vulture"
	handful_state = "vulture_bullet"
	default_ammo = /datum/ammo/bullet/sniper/anti_materiel/vulture
	max_rounds = 4
	gun_type = /obj/item/weapon/gun/boltaction/vulture
	w_class = SIZE_MEDIUM // maybe small? This shit's >4 inches long mind you
	ammo_band_icon = "+vulture_band"
	ammo_band_icon_empty = "+vulture_band_e"

/obj/item/ammo_magazine/rifle/boltaction/vulture/holo_target
	name = "\improper M707“秃鹫”全息标记弹匣（20x102mm）"
	desc = "M707“秃鹫”反器材步枪使用的弹匣，最多容纳4发硕大的、<b>支持敌我识别</b>的全息标记弹，擅长标记重型目标，供友方地面部队攻击。实现这些功能所需的配套条件大幅限制了弹药性能和停止作用。"
	default_ammo =  /datum/ammo/bullet/sniper/anti_materiel/vulture/holo_target
	ammo_band_color = AMMO_BAND_COLOR_HOLOTARGETING

//=ROYAL MARINES=\\

/obj/item/ammo_magazine/rifle/rmc_f90
	name = "\improper F903弹匣（10x24mm）"
	desc = "皇家海军陆战队使用的10mm突击步枪弹匣。"
	caliber = "10x24mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/twe_ammo.dmi'
	icon_state = "aug"
	item_state = "aug"
	w_class = SIZE_MEDIUM
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 30
	gun_type = /obj/item/weapon/gun/rifle/rmc_f90
	ammo_band_icon = "+aug_band"
	ammo_band_icon_empty = "+aug_band_e"

/obj/item/ammo_magazine/rifle/rmc_f90/marksman
	name = "\improper F903A1精确射手弹匣（10x24mm）"
	desc = "皇家海军陆战队使用的10mm突击步枪穿甲弹匣。"
	icon_state = "aug_dmr"
	item_state = "aug_dmr"
	default_ammo = /datum/ammo/bullet/rifle/ap
	gun_type = /obj/item/weapon/gun/rifle/rmc_f90/scope
	max_rounds = 20
	ammo_band_color = AMMO_BAND_COLOR_AP
	ammo_band_icon = "+aug_dmr_band"
	ammo_band_icon_empty = "+aug_dmr_band_e"

/obj/item/ammo_magazine/rifle/rmc_f90/heap
	name = "\improper F903高爆穿甲弹匣（10x24mm）"
	desc = "皇家海军陆战队使用的10mm突击步枪高爆穿甲弹匣。"
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/rifle/rmc_f90/marksman/heap
	name = "\improper F903A1精确射手弹匣（10x24mm）"
	desc = "皇家海军陆战队使用的10mm突击步枪高爆穿甲弹匣。"
	icon_state = "aug_dmr"
	item_state = "aug_dmr"
	default_ammo = /datum/ammo/bullet/rifle/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

//--------------------------------------------------------
//XM51 BREACHING SHOTGUN

/obj/item/ammo_magazine/rifle/xm51
	name = "\improper M1771弹匣（16号）"
	desc = "16号泵动霰弹枪弹匣。"
	icon_state = "xm51"
	caliber = "16g"
	w_class = SIZE_MEDIUM
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/light
	max_rounds = 12
	gun_type = /obj/item/weapon/gun/rifle/xm51
	transfer_handful_amount = 6

/obj/item/ammo_magazine/rifle/isr
	name = "\improper ISR盒式弹匣（9.2x34mm）"
	desc = "ISR轻机枪使用的9.2x34mm盒式弹匣。"
	caliber = "9.2x34mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "isr"
	item_state = "isr"
	default_ammo = /datum/ammo/bullet/rifle/isr
	max_rounds = 80
	gun_type = /obj/item/weapon/gun/rifle/isr
