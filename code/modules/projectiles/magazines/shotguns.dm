//-------------------------------------------------------
//Generic shotgun magazines. Only three of them, since all shotguns can use the same ammo unless we add other gauges.

/*
Shotguns don't really use unique "ammo" like other guns. They just load from a pool of ammo and generate the projectile
on the go. There's also buffering involved. But, we do need the ammo to check handfuls type, and it's nice to have when
you're looking back on the different shotgun projectiles available. In short of it, it's not needed to have more than
one type of shotgun ammo, but I think it helps in referencing it. ~N
*/

GLOBAL_LIST_INIT(shotgun_boxes_12g, list(
	/obj/item/ammo_magazine/shotgun/buckshot,
	/obj/item/ammo_magazine/shotgun/flechette,
	/obj/item/ammo_magazine/shotgun/slugs
	))

/obj/item/ammo_magazine/shotgun
	name = "一盒霰弹枪独头弹"
	desc = "一盒重型霰弹枪弹药，经久不衰的经典。12号。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "slugs"
	item_state = "slugs"
	default_ammo = /datum/ammo/bullet/shotgun/slug
	caliber = "12g"
	gun_type = /obj/item/weapon/gun/shotgun
	max_rounds = 25 // Real shotgun boxes are usually 5 or 25 rounds. This works with the new system, five handfuls.
	w_class = SIZE_MEDIUM // Can't throw it in your pocket, friend.
	flags_magazine = AMMUNITION_REFILLABLE|AMMUNITION_HANDFUL_BOX
	handful_state = "slug_shell"
	transfer_handful_amount = 5

/obj/item/ammo_magazine/shotgun/attack_self(mob/user)
	if(current_rounds == 0)
		new /obj/item/stack/sheet/cardboard(user.loc)
		qdel(src)
	else
		return ..()

/obj/item/ammo_magazine/shotgun/slugs//for distinction on weapons that can't take child objects but still take slugs.

/obj/item/ammo_magazine/shotgun/incendiary
	name = "一盒燃烧独头弹"
	desc = "一盒自爆式燃烧霰弹枪弹药。12号。"
	icon_state = "incendiary"
	item_state = "incendiary"
	default_ammo = /datum/ammo/bullet/shotgun/incendiary
	handful_state = "incendiary_slug"

/obj/item/ammo_magazine/shotgun/incendiarybuck
	name = "一盒燃烧鹿弹"
	desc = "一盒自爆式燃烧鹿弹。12号。"
	icon_state = "incendiarybuck"
	item_state = "incendiarybuck"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/incendiary
	handful_state = "incen_buckshot"

/obj/item/ammo_magazine/shotgun/buckshot
	name = "一盒鹿弹"
	desc = "一盒散射鹿弹。12号。"
	icon_state = "buckshot"
	item_state = "buckshot"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	handful_state = "buckshot_shell"

/obj/item/ammo_magazine/shotgun/flechette
	name = "一盒箭形弹"
	desc = "一盒霰弹枪箭形弹。12号。"
	icon_state = "flechette"
	item_state = "flechette"
	default_ammo = /datum/ammo/bullet/shotgun/flechette
	handful_state = "flechette_shell"

/obj/item/ammo_magazine/shotgun/beanbag
	name = "一盒布袋弹"
	desc = "一盒用于非致命人群控制的霰弹枪布袋弹。12号。"
	icon_state = "beanbag"
	item_state = "beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag
	handful_state = "beanbag_slug"

/obj/item/ammo_magazine/shotgun/buckshot/light
	name = "一盒轻型鹿弹"
	desc = "一盒鹿弹。16号。"
	icon_state = "lightbuckshot"
	item_state = "buckshot"
	max_rounds = 30 //6 handfuls of 6 shells, 12 rounds in a XM51 mag
	transfer_handful_amount = 6
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/light
	handful_state = "lightshot_shell"
	caliber = "16g"


/obj/item/ammo_magazine/shotgun/buckshot/special
	name = "一盒USCM特制鹿弹"
	desc = "一盒USCM特制散射鹿弹。12号。"
	icon_state = "special"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/special

/obj/item/ammo_magazine/shotgun/buckshot/heavy
	name = "一盒重型鹿弹"
	desc = "一盒鹿弹。8号。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "heavy_buckshot"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot
	transfer_handful_amount = 4
	max_rounds = 24
	caliber = "8g"

/obj/item/ammo_magazine/shotgun/slug/heavy
	name = "一盒重型独头弹"
	desc = "一盒独头弹。8号。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "heavy_slug"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/slug
	transfer_handful_amount = 4
	max_rounds = 24
	caliber = "8g"

/obj/item/ammo_magazine/shotgun/slug/dragonsbreath
	name = "一盒重型龙息弹"
	desc = "一盒独头弹。8号。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "heavy_dragon"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath
	transfer_handful_amount = 4
	max_rounds = 24
	caliber = "8g"

/obj/item/ammo_magazine/shotgun/flechette/heavy
	name = "一盒重型箭形弹"
	desc = "一盒箭形弹。8号。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "heavy_flechette"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/flechette
	transfer_handful_amount = 4
	max_rounds = 24
	caliber = "8g"

/obj/item/ammo_magazine/shotgun/beanbag/heavy
	name = "一盒重型布袋弹"
	desc = "一盒布袋独头弹。8号。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "heavy_beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/beanbag
	transfer_handful_amount = 4
	max_rounds = 24
	caliber = "8g"

//-------------------------------------------------------

/*
Generic internal magazine. All shotguns will use this or a variation with different ammo number.
Since all shotguns share ammo types, the gun path is going to be the same for all of them. And it
also doesn't really matter. You can only reload them with handfuls.
*/

/obj/item/ammo_magazine/internal/shotgun
	name = "shotgun tube"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	caliber = "12g"
	max_rounds = 4
	current_rounds = 4
	chamber_closed = 0

/obj/item/ammo_magazine/internal/shotgun/slug
	default_ammo = /datum/ammo/bullet/shotgun/slug

/obj/item/ammo_magazine/internal/shotgun/riot
	default_ammo = /datum/ammo/bullet/shotgun/beanbag

/obj/item/ammo_magazine/internal/shotgun/unloaded
	current_rounds = 0

/obj/item/ammo_magazine/internal/shotgun/double //For a double barrel.
	max_rounds = 2
	current_rounds = 0
	chamber_closed = 1 //Starts out with a closed tube.

/obj/item/ammo_magazine/internal/shotgun/double/cane
	default_ammo = /datum/ammo/bullet/revolver/marksman
	max_rounds = 6
	current_rounds = 6
	caliber = ".44"
/obj/item/ammo_magazine/internal/shotgun/double/mou53
	default_ammo = /datum/ammo/bullet/shotgun/flechette
	max_rounds = 3

/obj/item/ammo_magazine/internal/shotgun/double/twobore //Van Bandolier's superheavy double-barreled hunting rifle.
	caliber = "2 bore"
	max_rounds = 2
	current_rounds = 0
	default_ammo = /datum/ammo/bullet/shotgun/twobore

/obj/item/ammo_magazine/internal/shotgun/combat
	caliber = "12g"
	max_rounds = 6
	current_rounds = 6

/obj/item/ammo_magazine/internal/shotgun/combat/slug
	default_ammo = /datum/ammo/bullet/shotgun/slug

/obj/item/ammo_magazine/internal/shotgun/combat/riot
	default_ammo = /datum/ammo/bullet/shotgun/beanbag

/obj/item/ammo_magazine/internal/shotgun/combat/unloaded
	current_rounds = 0

/obj/item/ammo_magazine/internal/shotgun/marsoc
	caliber = "12g"
	max_rounds = 7
	current_rounds = 7

/obj/item/ammo_magazine/internal/shotgun/merc
	max_rounds = 5

/obj/item/ammo_magazine/internal/shotgun/type23
	caliber = "8g"
	max_rounds = 4
	current_rounds = 4
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot

/obj/item/ammo_magazine/internal/shotgun/type23/slug
	default_ammo = /datum/ammo/bullet/shotgun/heavy/slug

/obj/item/ammo_magazine/internal/shotgun/type23/riot
	default_ammo = /datum/ammo/bullet/shotgun/heavy/beanbag

/obj/item/ammo_magazine/internal/shotgun/type23/unloaded
	current_rounds = 0

/obj/item/ammo_magazine/internal/shotgun/cmb
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	max_rounds = 4
	current_rounds = 4

/obj/item/ammo_magazine/internal/shotgun/cmb/slug
	default_ammo = /datum/ammo/bullet/shotgun/slug

/obj/item/ammo_magazine/internal/shotgun/cmb/riot
	default_ammo = /datum/ammo/bullet/shotgun/beanbag
/obj/item/ammo_magazine/internal/shotgun/cmb/riot
	current_rounds = 0

/obj/item/ammo_magazine/internal/shotgun/cmb/m3717
	max_rounds = 5

//-------------------------------------------------------

/*
Handfuls of shotgun rounds. For spawning directly on mobs in roundstart, ERTs, etc
*/

GLOBAL_LIST_INIT(shotgun_handfuls_8g, list(
	/obj/item/ammo_magazine/handful/shotgun/heavy/slug,
	/obj/item/ammo_magazine/handful/shotgun/heavy/buckshot,
	/obj/item/ammo_magazine/handful/shotgun/heavy/flechette,
	/obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath
	))

GLOBAL_LIST_INIT(shotgun_handfuls_8g_reasonable, list(
	/obj/item/ammo_magazine/handful/shotgun/heavy/slug,
	/obj/item/ammo_magazine/handful/shotgun/heavy/buckshot,
	/obj/item/ammo_magazine/handful/shotgun/heavy/flechette,
	))

GLOBAL_LIST_INIT(shotgun_handfuls_12g, list(
	/obj/item/ammo_magazine/handful/shotgun/slug,
	/obj/item/ammo_magazine/handful/shotgun/buckshot,
	/obj/item/ammo_magazine/handful/shotgun/flechette,
	/obj/item/ammo_magazine/handful/shotgun/incendiary,
	/obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary,
	/obj/item/ammo_magazine/handful/shotgun/beanbag
	))

GLOBAL_LIST_INIT(shotgun_handfuls_12g_reasonable, list(
	/obj/item/ammo_magazine/handful/shotgun/slug,
	/obj/item/ammo_magazine/handful/shotgun/buckshot,
	/obj/item/ammo_magazine/handful/shotgun/flechette,
	/obj/item/ammo_magazine/handful/shotgun/beanbag
	))

/obj/item/ammo_magazine/handful/shotgun
	name = "一把霰弹枪独头弹（12号）"
	icon_state = "slug_shell_5"
	default_ammo = /datum/ammo/bullet/shotgun/slug
	caliber = "12g"
	max_rounds = 5
	current_rounds = 5
	gun_type = /obj/item/weapon/gun/shotgun
	handful_state = "slug_shell"
	transfer_handful_amount = 5
	flags_human_ai = AMMUNITION_ITEM

/obj/item/ammo_magazine/handful/shotgun/slug

/obj/item/ammo_magazine/handful/shotgun/incendiary
	name = "一把燃烧独头弹（12号）"
	icon_state = "incendiary_slug_5"
	default_ammo = /datum/ammo/bullet/shotgun/incendiary
	handful_state = "incendiary_slug"

/obj/item/ammo_magazine/handful/shotgun/buckshot
	name = "一把霰弹枪鹿弹（12号）"
	icon_state = "buckshot_shell_5"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	handful_state = "buckshot_shell"

/obj/item/ammo_magazine/handful/shotgun/buckshot/special
	name = "一把USCM特制霰弹枪鹿弹（12号）"
	icon_state = "special_buck_5"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/special

/obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary
	name = "一把燃烧鹿弹（12号）"
	icon_state = "incen_buckshot_5"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/incendiary
	handful_state = "incen_buckshot"

/obj/item/ammo_magazine/handful/shotgun/custom_color
	name = "abstract handful custom type"
	icon_state = "shell_greyscale_5"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	handful_state = "shell_greyscale" //unneeded

//updates on init
/obj/item/ammo_magazine/handful/shotgun/custom_color/update_icon()
	overlays.Cut()
	. = ..()
	icon_state = "shell_greyscale" + "_[current_rounds]"
	var/image/I = image(icon, src, "+shell_base_[src.current_rounds]")
	I.color = "#ffffff"
	I.appearance_flags = RESET_COLOR|KEEP_APART
	overlays += I

/obj/item/ammo_magazine/handful/shotgun/flechette
	name = "一把霰弹枪箭形弹（12号）"
	icon_state = "flechette_shell_5"
	default_ammo = /datum/ammo/bullet/shotgun/flechette
	handful_state = "flechette_shell"

/obj/item/ammo_magazine/handful/shotgun/beanbag
	name = "一把布袋弹（12号）"
	icon_state = "beanbag_slug_5"
	default_ammo = /datum/ammo/bullet/shotgun/beanbag
	handful_state = "beanbag_slug"

/obj/item/ammo_magazine/handful/shotgun/beanbag/riot
	name = "一把布袋弹（20号）"
	caliber = "20g"

/obj/item/ammo_magazine/handful/shotgun/heavy
	name = "一把重型霰弹枪独头弹（8号）"
	icon_state = "heavy_slug_4"
	handful_state = "heavy_slug"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/slug
	caliber = "8g"
	max_rounds = 4
	current_rounds = 4
	transfer_handful_amount = 4
	gun_type = /obj/item/weapon/gun/shotgun

/obj/item/ammo_magazine/handful/shotgun/heavy/slug

/obj/item/ammo_magazine/handful/shotgun/heavy/buckshot
	name = "一把重型鹿弹（8号）"
	icon_state = "heavy_buckshot_4"
	handful_state = "heavy_buckshot"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot

/obj/item/ammo_magazine/handful/shotgun/heavy/buckshot/special
	name = "一把超重型鹿弹（8号）"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot/special


/obj/item/ammo_magazine/handful/shotgun/heavy/dragonsbreath
	name = "一把龙息弹（8号）"
	desc = "这种弹药发射的是镁丸而非普通铅丸，接触空气即会燃烧，使命中的物体着火。其定制设计也提高了最大射程。"
	icon_state = "heavy_dragonsbreath_4"
	handful_state = "heavy_dragonsbreath"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath

/obj/item/ammo_magazine/handful/shotgun/heavy/flechette
	name = "一把重型箭形弹（8号）"
	icon_state = "heavy_flechette_4"
	handful_state = "heavy_flechette"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/flechette

/obj/item/ammo_magazine/handful/shotgun/heavy/beanbag
	name = "一把重型布袋弹（8号）"
	icon_state = "heavy_beanbag_4"
	handful_state = "heavy_beanbag"
	default_ammo = /datum/ammo/bullet/shotgun/heavy/beanbag

/obj/item/ammo_magazine/handful/shotgun/light
	name = "一把轻型鹿弹（16号）"
	icon_state = "lightshot_shell_6"
	handful_state = "lightshot_shell"
	max_rounds = 6 //XM51 magazines are 12 rounds total, two handfuls should be enough to reload a mag
	current_rounds = 6
	transfer_handful_amount = 6
	default_ammo = /datum/ammo/bullet/shotgun/buckshot/light
	caliber = "16g"
	gun_type = /obj/item/weapon/gun/rifle/xm51

/obj/item/ammo_magazine/handful/shotgun/twobore
	name = "一把霰弹枪独头弹（2号）"
	icon_state = "twobore_3"
	default_ammo = /datum/ammo/bullet/shotgun/twobore
	caliber = "2 bore"
	max_rounds = 3
	current_rounds = 3
	gun_type = /obj/item/weapon/gun/shotgun/double/twobore
	handful_state = "twobore"
	transfer_handful_amount = 3

// i fucking hate gun code

/obj/item/ammo_magazine/handful/revolver
	name = "一把左轮手枪子弹（.44）"
	default_ammo = /datum/ammo/bullet/revolver
	caliber = ".44"
	max_rounds = 8
	current_rounds = 8
	gun_type = /obj/item/weapon/gun/shotgun/double/cane
	flags_human_ai = AMMUNITION_ITEM

/obj/item/ammo_magazine/handful/revolver/marksman
	name = "一把精确射手左轮手枪子弹（.44）"
	default_ammo = /datum/ammo/bullet/revolver/marksman
	gun_type = /obj/item/weapon/gun/shotgun/double/cane

/obj/item/ammo_magazine/handful/revolver/marksman/six_rounds
	name = "一把精确射手左轮手枪子弹（.44）"
	default_ammo = /datum/ammo/bullet/revolver/marksman
	current_rounds = 6
	gun_type = /obj/item/weapon/gun/shotgun/double/cane
