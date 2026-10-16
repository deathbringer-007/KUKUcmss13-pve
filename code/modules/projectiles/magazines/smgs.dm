/obj/item/ammo_magazine/smg
	name = "\improper default SMG magazine"
	desc = "一个冲锋枪弹匣。"
	item_state = "generic_mag"
	default_ammo = /datum/ammo/bullet/smg
	max_rounds = 30

//-------------------------------------------------------
//M39 SMG ammo

/obj/item/ammo_magazine/smg/m39
	name = "\improper 毒蛇 9 弹匣（9mm）"
	desc = "一个 9mm 冲锋枪弹匣。"
	caliber = "9mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "m39"
	max_rounds = 48
	w_class = SIZE_MEDIUM
	gun_type = /obj/item/weapon/gun/smg/m39
	default_ammo = /datum/ammo/bullet/smg
	ammo_band_icon = "+m39_band"
	ammo_band_icon_empty = "+m39_band_e"

/obj/item/ammo_magazine/smg/m39/ap
	name = "\improper 毒蛇 9 穿甲弹匣（9mm）"
	desc = "一个 9mm 冲锋枪穿甲弹匣。"
	default_ammo = /datum/ammo/bullet/smg/ap
	ammo_band_color = AMMO_BAND_COLOR_AP

/obj/item/ammo_magazine/smg/m39/le
	name = "\improper 毒蛇 9 轻型爆破弹匣（9mm）"
	desc = "一个 9mm 冲锋枪轻型爆破弹匣。"
	default_ammo = /datum/ammo/bullet/smg/le
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/smg/m39/rubber
	name = "\improper 毒蛇 9 橡胶弹匣（9mm）"
	desc = "一个 9mm 冲锋枪橡胶弹匣。"
	default_ammo = /datum/ammo/bullet/smg/rubber
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/smg/m39/heap
	name = "\improper 毒蛇 9 高爆穿甲弹匣（9mm）"
	desc = "一个 9mm 冲锋枪高爆穿甲弹匣。"
	default_ammo = /datum/ammo/bullet/smg/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP

/obj/item/ammo_magazine/smg/m39/penetrating
	name = "\improper 毒蛇 9 穿墙弹匣（9mm）"
	desc = "一个 9mm 冲锋枪穿墙弹匣。"
	default_ammo = /datum/ammo/bullet/smg/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING

/obj/item/ammo_magazine/smg/m39/toxin
	name = "\improper 毒蛇 9 毒素弹匣（9mm）"
	desc = "一个 9mm 冲锋枪毒素弹匣。"
	default_ammo = /datum/ammo/bullet/smg/ap/toxin
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

/obj/item/ammo_magazine/smg/m39/incendiary
	name = "\improper 毒蛇 9 燃烧弹匣（9mm）"
	desc = "一个 9mm 冲锋枪燃烧弹匣。"
	default_ammo = /datum/ammo/bullet/smg/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/smg/m39/extended
	name = "\improper 毒蛇 9 扩容弹匣（9mm）"
	desc = "一个 9mm 冲锋枪扩容弹匣。"
	max_rounds = 72
	icon_state = "m39_HV_extended"
	bonus_overlay = "m39_ex"

/obj/item/ammo_magazine/smg/m39/pve
	name = "\improper 毒蛇 9 双头弹匣（9mm）"
	desc = "一个装有特殊双头弹的 9mm 冲锋枪弹匣，旨在提高每次扣动扳机的火力。每发子弹内有两个弹头，因此弹速较低。"
	max_rounds = 54
	default_ammo = /datum/ammo/bullet/smg/pve
	ammo_band_color = AMMO_BAND_COLOR_LIGHT_EXPLOSIVE

/obj/item/ammo_magazine/smg/m39/squash
	name = "\improper L6A2 碎甲弹匣（9mm）"
	max_rounds = 48
	default_ammo = /datum/ammo/bullet/smg/squash
	ammo_band_color = AMMO_BAND_COLOR_IMPACT

//-------------------------------------------------------
//M5, a classic SMG used in a lot of action movies.

/obj/item/ammo_magazine/smg/mp5
	name = "\improper MP5 弹匣（9mm）"
	desc = "供 MP5 使用的 9mm 弹匣。"
	default_ammo = /datum/ammo/bullet/smg
	caliber = "9mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "mp5"
	gun_type = /obj/item/weapon/gun/smg/mp5
	max_rounds = 30 //Also comes in 10 and 40.


//-------------------------------------------------------
//MP27, based on the MP27, based on the M7.

/obj/item/ammo_magazine/smg/mp27
	name = "\improper MP27 弹匣（4.6x30mm）"
	desc = "供 MP27 使用的 4.6mm 弹匣。发射体积大、重量重的子弹，对冲锋枪而言威力相当突出，但散布增大和精度下降也同样明显。"
	default_ammo = /datum/ammo/bullet/smg/mp27
	caliber = "4.6x30mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "mp7_30"
	gun_type = /obj/item/weapon/gun/smg/mp27
	max_rounds = 30 //Also comes in 20 and 40.
	bonus_overlay = "mp7_30_overlay"
	var/random_magazine = TRUE

/obj/item/ammo_magazine/smg/mp27/Initialize(mapload, spawn_empty)
	. = ..()
	if(random_magazine)
		var/capacity = pick(20, 30, 40)
		name = "\improper MP27 [capacity] 发弹匣（4.6x30mm）"
		desc = "供 MP27 使用的 [capacity] 发 4.6mm 弹匣。弹头小而沉重，对冲锋枪而言威力相当突出，但散布增大和精度下降也同样明显。由于工厂图纸混淆，20 发、30 发和 40 发弹匣都用相同包装出售，引发了使公司破产的集体诉讼。"
		caliber = "4.6x30mm"
		base_mag_icon = "mp7_[capacity]"
		icon_state = "mp7_[capacity]"
		bonus_overlay = "mp7_[capacity]_overlay"
		current_rounds = capacity
		max_rounds = capacity
		random_magazine = FALSE

//-------------------------------------------------------
//PPSH //Based on the PPSh-41.

#define PPSH_STICK_MAGAZINE_JAM_CHANCE 0.1
#define PPSH_DRUM_MAGAZINE_JAM_CHANCE 1

/obj/item/ammo_magazine/smg/ppsh
	name = "\improper PPSh-17b 直弹匣（7.62x25mm）"
	desc = "供 PPSh 冲锋枪使用的直弹匣。容量不及标志性的弹鼓，但后者存在供弹和操控问题。孰优孰劣，由你决定。"
	caliber = "7.62x25mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "ppsh17b_stick"
	bonus_overlay = "ppsh17b_stick_overlay"
	max_rounds = 35
	gun_type = /obj/item/weapon/gun/smg/ppsh
	default_ammo = /datum/ammo/bullet/smg/ppsh
	var/bonus_mag_aim_slowdown = 0
	var/bonus_mag_wield_delay = 0
	var/jam_chance = PPSH_STICK_MAGAZINE_JAM_CHANCE
	var/new_item_state = "ppsh17b"


/obj/item/ammo_magazine/smg/ppsh/extended
	name = "\improper PPSh-17b 弹鼓（7.62x25mm）"
	desc = "标志性的 PPSh-17b 弹鼓。容量约为直弹匣的两倍，但可能出现操控和供弹问题。孰优孰劣，由你决定。"
	icon_state = "ppsh17b_drum"
	bonus_overlay = "ppsh17b_drum_overlay"
	max_rounds = 71
	w_class = SIZE_MEDIUM
	bonus_mag_aim_slowdown = SLOWDOWN_ADS_QUICK_MINUS
	bonus_mag_wield_delay = WIELD_DELAY_VERY_FAST
	jam_chance = PPSH_DRUM_MAGAZINE_JAM_CHANCE
	new_item_state = "ppsh17b_d"

#undef PPSH_STICK_MAGAZINE_JAM_CHANCE
#undef PPSH_DRUM_MAGAZINE_JAM_CHANCE

//-------------------------------------------------------
//Type-19, based on the PPS-43

/obj/item/ammo_magazine/smg/pps43
	name = "\improper 19 式直弹匣（7.62x25mm）"
	desc = "供 19 式冲锋枪使用的直弹匣。"
	caliber = "7.62x25mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "insasu_stickmag"
	bonus_overlay = "insasu_stickmag_overlay"
	max_rounds = 35
	gun_type = /obj/item/weapon/gun/smg/pps43
	default_ammo = /datum/ammo/bullet/smg/pps43
	var/bonus_mag_aim_slowdown = 0
	var/bonus_mag_wield_delay = 0


/obj/item/ammo_magazine/smg/pps43/extended
	name = "\improper 19 式弹鼓（7.62x25mm）"
	desc = "供 19 式冲锋枪使用的弹鼓。"
	icon_state = "insasu_drum"
	bonus_overlay = "insasu_drum_overlay"
	max_rounds = 71
	w_class = SIZE_MEDIUM
	bonus_mag_aim_slowdown = SLOWDOWN_ADS_QUICK_MINUS
	bonus_mag_wield_delay = WIELD_DELAY_VERY_FAST
//-------------------------------------------------------
//Type 64 SMG, based on the PP Bizon.

/obj/item/ammo_magazine/smg/bizon
	name = "\improper 64 式螺旋弹筒（7.62x19mm）"
	desc = "供 UPP 武装力量制式冲锋枪 64 式使用的 64 发弹筒。"
	caliber = "7.62x19mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "type64mag"
	ammo_band_icon = "+type64mag_band"
	ammo_band_icon_empty = "+type64mag_band_e"
	max_rounds = 64
	gun_type = /obj/item/weapon/gun/smg/bizon

/obj/item/ammo_magazine/smg/bizon/ap
	name = "\improper 64 式穿甲弹螺旋弹筒（7.62x19mm）"
	desc = "供 UPP 武装力量制式冲锋枪 64 式使用的 64 发穿甲弹筒。"
	default_ammo = /datum/ammo/bullet/smg/ap
	ammo_band_color = AMMO_BAND_COLOR_AP
	bonus_overlay = "type64_ap"

/obj/item/ammo_magazine/smg/bizon/ap/penetrating
	name = "\improper 64 式穿墙弹螺旋弹筒（7.62x19mm）"
	desc = "供 UPP 武装力量制式冲锋枪 64 式使用的 64 发穿墙弹筒。"
	default_ammo = /datum/ammo/bullet/smg/ap/penetrating
	ammo_band_color = AMMO_BAND_COLOR_PENETRATING
	bonus_overlay = "type64_pen"


/obj/item/ammo_magazine/smg/bizon/heap
	name = "\improper 64 式高爆穿甲弹螺旋弹筒（7.62x19mm）"
	desc = "供 UPP 武装力量制式冲锋枪 64 式使用的 64 发高爆穿甲弹筒。"
	default_ammo = /datum/ammo/bullet/smg/heap
	ammo_band_color = AMMO_BAND_COLOR_HEAP
	bonus_overlay = "type64_heap"

//-------------------------------------------------------
//GENERIC UZI //Based on the uzi submachinegun, of course.

/obj/item/ammo_magazine/smg/mac15 //Based on the Uzi.
	name = "\improper MAC-15 弹匣（9mm）"
	desc = "供 MAC-15 使用的弹匣。"
	caliber = "9mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "mac15"
	max_rounds = 25 //Can also be 20, 25, 40, and 50.
	gun_type = /obj/item/weapon/gun/smg/mac15

/obj/item/ammo_magazine/smg/mac15/extended
	name = "\improper MAC-15 扩容弹匣（9mm）"
	icon_state = "mac15_extended"
	bonus_overlay = "mac15_ext"
	max_rounds = 50

//-------------------------------------------------------
// the real UZI

#define UZI_NORMAL_MAGAZINE_JAM_CHANCE 0
#define UZI_EXTENDED_MAGAZINE_JAM_CHANCE 1

/obj/item/ammo_magazine/smg/uzi
	name = "\improper 乌兹弹匣（9x21mm）"
	desc = "供乌兹冲锋枪使用的弹匣。看起来挺小吧？再大就会供弹故障。"
	caliber = "9x12mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "uzi"
	max_rounds = 25
	gun_type = /obj/item/weapon/gun/smg/uzi
	var/jam_chance = UZI_NORMAL_MAGAZINE_JAM_CHANCE

/obj/item/ammo_magazine/smg/uzi/extended
	name = "\improper 乌兹扩容弹匣（9x21mm）"
	desc = "供乌兹冲锋枪使用的略微加长弹匣。由于尺寸较大，可能出现供弹故障，也可能不会。"
	icon_state = "uzi_extended"
	bonus_overlay = "uzi_ext"
	max_rounds = 32
	jam_chance = UZI_EXTENDED_MAGAZINE_JAM_CHANCE

#undef UZI_NORMAL_MAGAZINE_JAM_CHANCE
#undef UZI_EXTENDED_MAGAZINE_JAM_CHANCE

//-------------------------------------------------------
//FP9000 //Based on the FN P90

/obj/item/ammo_magazine/smg/fp9000
	name = "FN FP9000 弹匣（5.7x28mm）"
	desc = "供 FN FP9000 冲锋枪使用的弹匣。"
	default_ammo = /datum/ammo/bullet/smg/ap
	caliber = "5.7x28mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "fp9000"
	w_class = SIZE_MEDIUM
	max_rounds = 50
	gun_type = /obj/item/weapon/gun/smg/fp9000

//-------------------------------------------------------
//Nailgun!
/obj/item/ammo_magazine/smg/nailgun
	name = "射钉枪弹匣（7x45mm）"
	desc = "装有超大塑钢钉的大型弹匣。可惜这些钉子的生产成本太高，多数军事项目都负担不起，只有少数特殊建筑工程才会用到。"
	default_ammo = /datum/ammo/bullet/smg/nail
	flags_magazine = NO_FLAGS // Let's not start messing with nails...
	caliber = "7x45mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "nailgun"
	w_class = SIZE_SMALL
	max_rounds = 48
	gun_type = /obj/item/weapon/gun/smg/nailgun
