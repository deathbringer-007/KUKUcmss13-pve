//-----------------------AMMUNITION BOXES (LOOSE AMMO)-----------------------

//----------------10x24mm Ammunition Boxes (for M41 family, M49A, and L42)------------------

/obj/item/ammo_box/rounds/ap
	name = "\improper 步枪弹药箱（10x24mm穿甲弹）"
	desc = "10x24mm穿甲弹药箱，用于补充M41A MK2和M49A穿甲弹匣。附有皮带，可背在背上。"
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/rifle/ap

/obj/item/ammo_box/rounds/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/le
	name = "\improper 步枪弹药箱（10x24mm削甲弹）"
	desc = "10x24mm削甲弹药箱，用于补充M41A MK2 LE弹匣。附有皮带，可背在背上。"
	overlay_content = "_le"
	default_ammo = /datum/ammo/bullet/rifle/le

/obj/item/ammo_box/rounds/le/empty
	empty = TRUE

/obj/item/ammo_box/rounds/incen
	name = "\improper 步枪弹药箱（10x24mm燃烧弹）"
	desc = "10x24mm燃烧弹药箱，用于补充M41A MK2和M49A燃烧弹匣。附有皮带，可背在背上。"
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/rifle/incendiary
	bullet_amount = 400 //Incen is OP
	max_bullet_amount = 400

/obj/item/ammo_box/rounds/incen/empty
	empty = TRUE

/obj/item/ammo_box/rounds/heap
	name = "步枪弹药箱（10x24mm高爆穿甲弹）"
	desc = "10x24mm高爆穿甲弹药箱，用于补充弹匣。附有皮带，可背在背上。"
	overlay_content = "_heap"
	default_ammo = /datum/ammo/bullet/rifle/heap

/obj/item/ammo_box/rounds/heap/empty
	empty = TRUE

//----------------10x28mm Ammunition Boxes (for smartguns)------------------

/obj/item/ammo_box/rounds/smartgun
	name = "\improper 智能机枪弹药箱（10x28mm）"
	icon_state = "base_m56rd"
	desc = "10x28mm弹药箱，用于补充智能机枪弹鼓。附有皮带，可背在背上。"
	overlay_content = "_reg"
	default_ammo = /datum/ammo/bullet/rifle/heavy/tracer
	caliber = "10x28mm"
	bullet_amount = 1000
	max_bullet_amount = 1000

/obj/item/ammo_box/rounds/smartgun/empty
	empty = TRUE

// RMC SG
/obj/item/ammo_box/rounds/smartgun/holo_target
	name = "\improper 智能机枪全息标记弹药箱（10x28mm）"
	desc = "装满10x28mm全息标记弹的弹药箱，用于补充L58A3智能机枪弹鼓。附有皮带，可背在背上。"
	overlay_content = "_impact"
	default_ammo = /datum/ammo/bullet/rifle/heavy/holo_target

/obj/item/ammo_box/rounds/smartgun/holo_target/empty
	empty = TRUE

//----------------9mm Ammunition Boxes (for Viper 9 SMG)------------------

/obj/item/ammo_box/rounds/smg
	name = "\improper 冲锋枪弹药箱（9mm）"
	desc = "9mm弹药箱。附有皮带，可背在背上。"
	caliber = "9mm"
	icon_state = "base_m39"
	overlay_content = "_hv"
	default_ammo = /datum/ammo/bullet/pistol

/obj/item/ammo_box/rounds/smg/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/ap
	name = "\improper 冲锋枪弹药箱（9mm穿甲弹）"
	desc = "9mm穿甲弹药箱。附有皮带，可背在背上。"
	caliber = "9mm"
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/pistol/ap

/obj/item/ammo_box/rounds/smg/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/le
	name = "\improper 冲锋枪弹药箱（9mm削甲弹）"
	desc = "9mm削甲弹药箱。附有皮带，可背在背上。"
	caliber = "9mm"
	overlay_content = "_le"
	default_ammo = /datum/ammo/bullet/pistol/le

/obj/item/ammo_box/rounds/smg/le/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/incen
	name = "\improper 冲锋枪弹药箱（9mm燃烧弹）"
	desc = "9mm燃烧弹药箱。附有皮带，可背在背上。"
	caliber = "9mm"
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/pistol/incendiary
	bullet_amount = 400 //Incen is OP
	max_bullet_amount = 400

/obj/item/ammo_box/rounds/smg/incen/empty
	empty = TRUE

/obj/item/ammo_box/rounds/smg/heap
	name = "冲锋枪弹药箱（9mm高爆穿甲弹）"
	desc = "9mm高爆穿甲弹药箱。附有皮带，可背在背上。"
	caliber = "9mm"
	overlay_content = "_heap"
	default_ammo = /datum/ammo/bullet/smg/heap

/obj/item/ammo_box/rounds/smg/heap/empty
	empty = TRUE

//----------------10x27mm Ammunition Boxes (for UPP Type71 family)------------------

/obj/item/ammo_box/rounds/type71
	name = "\improper 步枪弹药箱（10x27mm）"
	desc = "10x27mm弹药箱，用于补充71式弹匣。附有皮带，可背在背上。"
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_reg"
	caliber = "10x27mm"
	default_ammo = /datum/ammo/bullet/rifle/upp

/obj/item/ammo_box/rounds/type71/empty
	empty = TRUE

/obj/item/ammo_box/rounds/type71/ap
	name = "\improper 步枪弹药箱（10x27mm穿甲弹）"
	desc = "10x27mm穿甲弹药箱，用于补充71式穿甲弹匣。附有皮带，可背在背上。"
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_ap"
	default_ammo = /datum/ammo/bullet/rifle/upp/ap

/obj/item/ammo_box/rounds/type71/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/type71/heap
	name = "步枪弹药箱（10x27mm高爆穿甲弹）"
	desc = "10x27mm高爆穿甲弹药箱，用于补充71式和QYJ-72高爆穿甲弹匣。附有皮带，可背在背上。"
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_type71"
	overlay_content = "_type71_heap"
	default_ammo = /datum/ammo/bullet/rifle/upp/heap

/obj/item/ammo_box/rounds/type71/heap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/pkp
	name = "大型步枪弹药箱（10x27mm）"
	desc = "10x27mm机枪弹药箱，主要用于补充71式和QYJ-72盒式弹匣。附有皮带，可背在背上。"
	icon_state = "base_type71"
	overlay_gun_type = "_rounds_pkp"
	overlay_content = "_type71_heap"
	default_ammo = /datum/ammo/bullet/rifle/upp/heap/tracer
	bullet_amount = 1500
	max_bullet_amount = 1500
	caliber = "10x27mm"

//----------------9mm Pistol Ammunition Boxes (for mod88, M4A3 pistols)------------------

/obj/item/ammo_box/rounds/pistol
	name = "\improper 手枪弹药箱（9mm）"
	desc = "9mm弹药箱，用于补充M4A3弹匣。附有皮带，可背在背上。"
	caliber = "9mm"
	icon_state = "base_m4a3"
	overlay_content = "_reg"
	default_ammo = /datum/ammo/bullet/pistol

/obj/item/ammo_box/rounds/pistol/empty
	empty = TRUE

/obj/item/ammo_box/rounds/pistol/ap
	name = "\improper 手枪弹药箱（9mm穿甲弹）"
	desc = "9mm穿甲弹药箱，用于补充Mod88和M4A3弹匣。附有皮带，可背在背上。"
	overlay_content = "_ap"
	default_ammo = /datum/ammo/bullet/pistol/ap

/obj/item/ammo_box/rounds/pistol/ap/empty
	empty = TRUE

/obj/item/ammo_box/rounds/pistol/hp
	name = "\improper 手枪弹药箱（9mm空尖弹）"
	desc = "9mm空尖弹药箱，用于补充M4A3弹匣。附有皮带，可背在背上。"
	overlay_content = "_hp"
	default_ammo = /datum/ammo/bullet/pistol/hollow

/obj/item/ammo_box/rounds/pistol/hp/empty
	empty = TRUE

/obj/item/ammo_box/rounds/pistol/incen
	name = "\improper 手枪弹药箱（9mm燃烧弹）"
	desc = "9mm燃烧弹药箱，用于补充M4A3弹匣。附有皮带，可背在背上。"
	overlay_content = "_incen"
	default_ammo = /datum/ammo/bullet/pistol/incendiary

/obj/item/ammo_box/rounds/pistol/incen/empty
	empty = TRUE
