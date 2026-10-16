
//external magazines

/obj/item/ammo_magazine/revolver
	name = "\improper M44 快速装弹器（.44）"
	desc = "供 M44 左轮手枪使用的快速装弹器。"
	default_ammo = /datum/ammo/bullet/revolver
	flags_equip_slot = NO_FLAGS
	caliber = ".44"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "m44"
	item_state = "generic_speedloader"
	w_class = SIZE_SMALL
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/m44
	ammo_band_icon = "+m44_tip"
	ammo_band_icon_empty = "empty"

/obj/item/ammo_magazine/revolver/marksman
	name = "\improper M44 精确弹快速装弹器（.44）"
	default_ammo = /datum/ammo/bullet/revolver/marksman
	caliber = ".44"
	ammo_band_color = REVOLVER_TIP_COLOR_MARKSMAN

/obj/item/ammo_magazine/revolver/heavy
	name = "\improper M44 重弹快速装弹器（.44）"
	desc = "装有重弹的左轮手枪快速装弹器。与传统弹药相比，总体伤害较低，但精度更高。"
	default_ammo = /datum/ammo/bullet/revolver/heavy
	caliber = ".44"
	ammo_band_color = REVOLVER_TIP_COLOR_HEAVY

/obj/item/ammo_magazine/revolver/incendiary
	name = "\improper M44 燃烧弹快速装弹器（.44）"
	default_ammo = /datum/ammo/bullet/revolver/incendiary
	ammo_band_color = REVOLVER_TIP_COLOR_INCENDIARY

/obj/item/ammo_magazine/revolver/marksman/toxin
	name = "\improper M44 毒素弹快速装弹器（.44）"
	default_ammo = /datum/ammo/bullet/revolver/marksman/toxin
	ammo_band_color = REVOLVER_TIP_COLOR_TOXIN

/obj/item/ammo_magazine/revolver/penetrating
	name = "\improper M44 穿墙弹快速装弹器（.44）"
	default_ammo = /datum/ammo/bullet/revolver/penetrating
	ammo_band_color = REVOLVER_TIP_COLOR_PENETRATING

/**
 * COLONY REVOLVERS
 */

/obj/item/ammo_magazine/revolver/pkd
	name = "\improper 普尔法格-胜又桥夹（.44）"
	desc = "翻起两侧卡扣（PKL 型为三个），对准枪上的供弹唇后推入。弹夹可重复使用。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "pkd_44"
	caliber = ".44 sabot"

/obj/item/ammo_magazine/revolver/upp
	name = "\improper ZHNK-72 快速装弹器（7.62x38mmR）"
	default_ammo = /datum/ammo/bullet/revolver/upp
	caliber = "7.62x38mmR"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "zhnk72loader"
	gun_type = /obj/item/weapon/gun/revolver/upp

/obj/item/ammo_magazine/revolver/upp/shrapnel
	name = "\improper ZHNK-72 碎片弹快速装弹器（7.62x38mmR）"
	desc = "这个快速装弹器装有七发“碎片弹”，用捡来的廉价弹壳重新填入火药和杂碎金属制成，效果类似箭形弹。"
	default_ammo = /datum/ammo/bullet/revolver/upp/shrapnel
	icon_state = "zhnk72loader_shrapnel"

/obj/item/ammo_magazine/revolver/small
	name = "\improper .38 高压弹快速装弹器（.38 +P）"
	desc = "装有六发手工复装 .38 高压弹的快速装弹器。冲击力强，但精度不及工厂弹药，容易损坏无法承受其膛压的枪械。"
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".38 +P"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "38"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/small

/obj/item/ammo_magazine/revolver/spearhead
	name = "\improper 矛头快速装弹器（.357）"
	desc = "装有六发 .357 全被甲弹的快速装弹器。由于存在过度穿透风险，很少配发给殖民地执法官。"
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".357"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "cmb"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/spearhead

/obj/item/ammo_magazine/revolver/spearhead/hollowpoint
	name = "\improper 矛头快速装弹器（.357）"
	desc = "装有六发 .357 空尖弹的快速装弹器。常配发给殖民地执法官，既能避免过度穿透，也能提高对无甲罪犯和野生动物的杀伤力。"
	default_ammo = /datum/ammo/bullet/revolver/small/hollowpoint
	icon_state = "cmb_hp"

/**
 * MATEBA REVOLVER
 */

/obj/item/ammo_magazine/revolver/mateba
	name = "\improper 马特巴快速装弹器（.454）"
	desc = "专为马特巴自动左轮手枪制造的强力 .454 快速装弹器，威力惊人。这个标准型号针对反装甲用途进行了优化。"
	default_ammo = /datum/ammo/bullet/revolver/mateba
	caliber = ".454"
	icon_state = "mateba"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/mateba

/obj/item/ammo_magazine/revolver/mateba/highimpact
	name = "\improper 马特巴高冲击弹快速装弹器（.454）"
	desc = "专为马特巴自动左轮手枪制造的强力 .454 快速装弹器，威力惊人。这个高冲击型号针对人员杀伤进行了优化。别对准你不想摧毁的东西。"
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact
	ammo_band_color = REVOLVER_TIP_COLOR_HIGH_IMPACT

/obj/item/ammo_magazine/revolver/mateba/highimpact/ap
	name = "\improper 马特巴高冲击穿甲弹快速装弹器（.454）"
	desc = "专为马特巴自动左轮手枪制造的强力 .454 快速装弹器，威力惊人。这个穿甲型号以降低总体伤害为代价，强化了对装甲目标的效果。别对准你不想摧毁的东西。"
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact/ap
	ammo_band_color = REVOLVER_TIP_COLOR_AP

/obj/item/ammo_magazine/revolver/mateba/highimpact/explosive
	name = "\improper 马特巴爆炸弹快速装弹器（.454）"
	desc = "专为马特巴自动左轮手枪制造的强力 .454 快速装弹器。弹头内置触发装药，命中任何目标都会产生强烈爆炸。请极其谨慎地使用。"
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact/explosive
	ammo_band_color = REVOLVER_TIP_COLOR_EXPLOSIVE

/**
 * WEBLEY REVOLVER
*/

/obj/item/ammo_magazine/revolver/webley
	name = "\improper 韦伯利快速装弹器（.455）"
	desc = ".455 韦伯利，最后一种像样的手枪口径。装填 Mk III 达姆弹，因为陆战队员不是人，海牙公约不适用于他们。"
	default_ammo = /datum/ammo/bullet/revolver/webley
	caliber = ".455"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/colony.dmi'
	icon_state = "357"
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver/m44/custom/webley

//INTERNAL MAGAZINES

//---------------------------------------------------

/obj/item/ammo_magazine/internal/revolver
	name = "revolver cylinder"
	default_ammo = /datum/ammo/bullet/revolver
	max_rounds = 6
	gun_type = /obj/item/weapon/gun/revolver

//-------------------------------------------------------
//M44 MAGNUM REVOLVER //Not actually cannon, but close enough.

/obj/item/ammo_magazine/internal/revolver/m44
	caliber = ".44"
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/m44

/obj/item/ammo_magazine/internal/revolver/m44/pkd
	max_rounds = 8
	caliber = ".44 sabot"

/obj/item/ammo_magazine/internal/revolver/m44/marksman
	default_ammo = /datum/ammo/bullet/revolver/marksman //because the starting m44 custom revolver belt is full of marksman ammo, but your gun would have normal ammo loaded

//-------------------------------------------------------
//RUSSIAN REVOLVER //Based on the 7.62mm Russian revolvers.

/obj/item/ammo_magazine/internal/revolver/upp
	default_ammo = /datum/ammo/bullet/revolver/upp
	caliber = "7.62x38mmR"
	max_rounds = 7
	gun_type = /obj/item/weapon/gun/revolver/upp

/obj/item/ammo_magazine/internal/revolver/upp/shrapnel
	default_ammo = /datum/ammo/bullet/revolver/upp/shrapnel


//-------------------------------------------------------
//357 REVOLVER //Based on the generic S&W 357.

/obj/item/ammo_magazine/internal/revolver/small
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".357 Hotload"
	gun_type = /obj/item/weapon/gun/revolver/small

//-------------------------------------------------------
//BURST REVOLVER //Mateba is pretty well known. The cylinder folds up instead of to the side.

/obj/item/ammo_magazine/internal/revolver/mateba
	default_ammo = /datum/ammo/bullet/revolver
	caliber = ".454"
	gun_type = /obj/item/weapon/gun/revolver/mateba

/obj/item/ammo_magazine/internal/revolver/mateba/impact
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact

/obj/item/ammo_magazine/internal/revolver/mateba/ap
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact/ap

/obj/item/ammo_magazine/internal/revolver/mateba/explosive
	default_ammo = /datum/ammo/bullet/revolver/mateba/highimpact/explosive

//-------------------------------------------------------
//MARSHALS REVOLVER //Spearhead exists in Alien cannon.

/obj/item/ammo_magazine/internal/revolver/spearhead
	default_ammo = /datum/ammo/bullet/revolver/small
	caliber = ".357"
	gun_type = /obj/item/weapon/gun/revolver/spearhead

/obj/item/ammo_magazine/internal/revolver/spearhead/hollowpoint
	default_ammo = /datum/ammo/bullet/revolver/small/hollowpoint
	caliber = ".357"
	gun_type = /obj/item/weapon/gun/revolver/spearhead

//-------------------------------------------------------
//BIG GAME HUNTER'S REVOLVER
/obj/item/ammo_magazine/internal/revolver/webley
	caliber = ".455"
	default_ammo = /datum/ammo/bullet/revolver/webley
	gun_type = /obj/item/weapon/gun/revolver/m44/custom/webley
