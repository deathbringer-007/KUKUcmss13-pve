//Gun attachable items code. Lets you add various effects to firearms.
//Some attachables are hardcoded in the projectile firing system, like grenade launchers, flamethrowers.
/*
When you are adding new guns into the attachment list, or even old guns, make sure that said guns
properly accept overlays. You can find the proper offsets in the individual gun dms, so make sure
you set them right. It's a pain to go back to find which guns are set incorrectly.
To summarize: rail attachments should go on top of the rail. For rifles, this usually means the middle of the gun.
For handguns, this is usually toward the back of the gun. SMGs usually follow rifles.
Muzzle attachments should connect to the barrel, not sit under or above it. The only exception is the bayonet.
Underrail attachments should just fit snugly, that's about it. Stocks are pretty obvious.

All attachment offsets are now in a list, including stocks. Guns that don't take attachments can keep the list null.
~N

Defined in conflicts.dm of the #defines folder.
#define ATTACH_REMOVABLE 1
#define ATTACH_ACTIVATION 2
#define ATTACH_PROJECTILE 4
#define ATTACH_RELOADABLE 8
#define ATTACH_WEAPON 16
*/

/obj/item/attachable
	name = "可安装物品"
	desc = "这只是枪械配件的抽象概念，你不该看见它。"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = null
	item_state = null
	var/attach_icon //the sprite to show when the attachment is attached when we want it different from the icon_state.
	var/pixel_shift_x = 16 //Determines the amount of pixels to move the icon state for the overlay.
	var/pixel_shift_y = 16 //Uses the bottom left corner of the item.

	flags_atom =  FPRINT|CONDUCT
	matter = list("metal" = 100)
	w_class = SIZE_SMALL
	force = 1
	var/slot = null //"muzzle", "rail", "side_rail", "under", "stock", "special"

	/*
	Anything that isn't used as the gun fires should be a flat number, never a percentange. It screws with the calculations,
	and can mean that the order you attach something/detach something will matter in the final number. It's also completely
	inaccurate. Don't worry if force is ever negative, it won't runtime.
	*/
	//These bonuses are applied only as the gun fires a projectile.

	//These are flat bonuses applied and are passive, though they may be applied at different points.
	var/accuracy_mod = 0 //Modifier to firing accuracy, works off a multiplier.
	var/accuracy_unwielded_mod = 0 //same as above but for onehanded.
	var/damage_mod = 0 //Modifer to the damage mult, works off a multiplier.
	var/damage_falloff_mod = 0 //Modifier to damage falloff, works off a multiplier.
	var/damage_buildup_mod = 0 //Modifier to damage buildup, works off a multiplier.
	var/range_min_mod = 0 //Modifier to minimum effective range, tile value.
	var/range_max_mod = 0 //Modifier to maximum effective range, tile value.
	var/melee_mod = 0 //Changing to a flat number so this actually doesn't screw up the calculations.
	var/scatter_mod = 0 //Increases or decreases scatter chance.
	var/scatter_unwielded_mod = 0 //same as above but for onehanded firing.
	var/recoil_mod = 0 //If positive, adds recoil, if negative, lowers it. Recoil can't go below 0.
	var/recoil_unwielded_mod = 0 //same as above but for onehanded firing.
	var/burst_scatter_mod = 0 //Modifier to scatter from wielded burst fire, works off a multiplier.
	var/light_mod = 0 //Adds an x-brightness flashlight to the weapon, which can be toggled on and off.
	var/delay_mod = 0 //Changes firing delay. Cannot go below 0.
	var/burst_mod = 0 //Changes burst rate. 1 == 0.
	var/size_mod = 0 //Increases the weight class.
	var/aim_speed_mod = 0 //Changes the aiming speed slowdown of the wearer by this value.
	var/wield_delay_mod = 0 //How long ADS takes (time before firing)
	var/movement_onehanded_acc_penalty_mod = 0 //Modifies accuracy/scatter penalty when firing onehanded while moving.
	var/velocity_mod = 0 // Added velocity to bullets
	var/hud_offset_mod  = 0 //How many pixels to adjust the gun's sprite coords by. Ideally, this should keep the gun approximately centered.
	var/fa_scatter_peak_mod = 0 //modifies how many bullets it takes to reach max scatter in FA firing.
	var/fa_max_scatter_mod = 0 //modifies maximum scatter in sustained FA

	var/activation_sound = 'sound/weapons/handling/gun_underbarrel_activate.ogg'
	var/deactivation_sound = 'sound/weapons/handling/gun_underbarrel_deactivate.ogg'

	var/flags_attach_features = ATTACH_REMOVABLE

	var/current_rounds = 0 //How much it has.
	var/max_rounds = 0 //How much ammo it can store

	var/attachment_action_type

	var/hidden = FALSE //Render on gun?

	/// An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	/// that will be given to a projectile with the current ammo datum
	var/list/list/traits_to_give
	/// List of traits to be given to the gun itself.
	var/list/gun_traits

/obj/item/attachable/Initialize(mapload, ...)
	. = ..()
	set_bullet_traits()

/obj/item/attachable/proc/set_bullet_traits()
	return

/obj/item/attachable/attackby(obj/item/I, mob/user)
	if(flags_attach_features & ATTACH_RELOADABLE)
		if(user.get_inactive_hand() != src)
			to_chat(user, SPAN_WARNING("你必须拿着[src]才能这样做！"))
		else
			reload_attachment(I, user)
		return TRUE
	else
		. = ..()

/obj/item/attachable/proc/can_be_attached_to_gun(mob/user, obj/item/weapon/gun/G)
	if(G.attachable_allowed && !(type in G.attachable_allowed) )
		to_chat(user, SPAN_WARNING("[src]无法安装在[G]上！"))
		return FALSE
	return TRUE

/obj/item/attachable/proc/Attach(obj/item/weapon/gun/G)
	if(!istype(G)) return //Guns only

	/*
	This does not check if the attachment can be removed.
	Instead of checking individual attachments, I simply removed
	the specific guns for the specific attachments so you can't
	attempt the process in the first place if a slot can't be
	removed on a gun. can_be_removed is instead used when they
	try to strip the gun.
	*/
	if(G.attachments[slot])
		var/obj/item/attachable/A = G.attachments[slot]
		A.Detach(detaching_gub = G)

	if(ishuman(loc))
		var/mob/living/carbon/human/M = src.loc
		M.drop_held_item(src)
	forceMove(G)

	G.attachments[slot] = src
	G.recalculate_attachment_bonuses()

	G.setup_firemodes()
	G.update_force_list() //This updates the gun to use proper force verbs.

	var/mob/living/living
	if(isliving(G.loc))
		living = G.loc

	if(attachment_action_type)
		var/given_action = FALSE
		if(living && (G == living.l_hand || G == living.r_hand))
			give_action(living, attachment_action_type, src, G)
			given_action = TRUE
		if(!given_action)
			new attachment_action_type(src, G)

	// Sharp attachments (bayonet) make weapons sharp as well.
	if(sharp)
		G.sharp = sharp

	for(var/trait in gun_traits)
		ADD_TRAIT(G, trait, TRAIT_SOURCE_ATTACHMENT(slot))
	for(var/entry in traits_to_give)
		if(!G.in_chamber)
			break
		var/list/L
		// Check if this is an ID'd bullet trait
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			// Prepend the bullet trait to the list
			L = list(entry) + traits_to_give[entry]
		// Apply bullet traits from attachment to gun's current projectile
		G.in_chamber.apply_bullet_trait(L)

/obj/item/attachable/proc/Detach(mob/user, obj/item/weapon/gun/detaching_gub, drop_attachment = TRUE)
	if(!istype(detaching_gub)) return //Guns only

	if(user)
		detaching_gub.on_detach(user, src)

	if(flags_attach_features & ATTACH_ACTIVATION)
		activate_attachment(detaching_gub, null, TRUE)

	detaching_gub.attachments[slot] = null
	detaching_gub.recalculate_attachment_bonuses()

	for(var/X in detaching_gub.actions)
		var/datum/action/DA = X
		if(DA.target == src)
			qdel(X)
			break

	if(drop_attachment)
		forceMove(get_turf(detaching_gub))

	if(sharp)
		detaching_gub.sharp = 0

	for(var/trait in gun_traits)
		REMOVE_TRAIT(detaching_gub, trait, TRAIT_SOURCE_ATTACHMENT(slot))
	for(var/entry in traits_to_give)
		if(!detaching_gub.in_chamber)
			break
		var/list/L
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			L = list(entry) + traits_to_give[entry]
		// Remove bullet traits of attachment from gun's current projectile
		detaching_gub.in_chamber._RemoveElement(L)

/obj/item/attachable/ui_action_click(mob/living/user, obj/item/weapon/gun/G)
	activate_attachment(G, user)
	return //success

/obj/item/attachable/proc/activate_attachment(atom/target, mob/user) //This is for activating stuff like flamethrowers, or switching weapon modes.
	return

/obj/item/attachable/proc/reload_attachment(obj/item/I, mob/user)
	return

/obj/item/attachable/proc/unique_action(mob/user)
	return

///Returns TRUE if its functionality is successfully used, FALSE if gun's own unloading should proceed instead.
/obj/item/attachable/proc/unload_attachment(mob/user, reload_override = 0, drop_override = 0, loc_override = 0)
	return FALSE

/obj/item/attachable/proc/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/user) //For actually shooting those guns.
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN_ATTACHMENT, src) // Because of this, the . = ..() check should be called last, just before firing
	return TRUE

/obj/item/attachable/proc/handle_attachment_description()
	var/base_attachment_desc
	switch(slot)
		if("rail")
			base_attachment_desc = "顶部装有[icon2html(src)] [name]。"
		if("side_rail")
			base_attachment_desc = "侧面装有[icon2html(src)] [name]。"
		if("muzzle")
			base_attachment_desc = "前端装有[icon2html(src)] [name]。"
		if("stock")
			base_attachment_desc = "装有[icon2html(src)] [name]作为枪托。"
		if("under")
			var/output = "下方装有[icon2html(src)] [name]"
			if(flags_attach_features & ATTACH_WEAPON)
				output += " ([current_rounds]/[max_rounds])"
			output += "。"
			base_attachment_desc = output
		else
			base_attachment_desc = "装有[icon2html(src)] [name]。"
	return handle_pre_break_attachment_description(base_attachment_desc) + "<br>"

/obj/item/attachable/proc/handle_pre_break_attachment_description(base_description_text as text)
	return base_description_text

// ======== Muzzle Attachments ======== //

/obj/item/attachable/suppressor
	name = "消音器"
	desc = "利用特殊内部结构降低枪口火光与噪音的小型枪口装置。\n可降低枪声、提高精度和稳定性，但会略微降低伤害。"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "suppressor"
	slot = "muzzle"
	pixel_shift_y = 15
	attach_icon = "suppressor_a"
	hud_offset_mod = -3
	gun_traits = list(TRAIT_GUN_SILENCED)

/obj/item/attachable/suppressor/New()
	..()
	damage_falloff_mod = 0.1
	attach_icon = pick("suppressor_a","suppressor2_a")

/obj/item/attachable/suppressor/xm40_integral
	name = "XM40 一体式消音器"
	icon_state = "m40sd_suppressor"
	attach_icon = "m40sd_suppressor_a"

/obj/item/attachable/suppressor/xm40_integral/New()
	..()
	attach_icon = "m40sd_suppressor_a"

/obj/item/attachable/bayonet
	name = "M5 刺刀"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "bayonet"
	item_state = "combat_knife"
	desc = "USCMC 配发的老式步枪刺刀。可稳妥收进靴上刀鞘，紧急情况下还能用来挖出弹片。"
	sharp = IS_SHARP_ITEM_ACCURATE
	force = MELEE_FORCE_NORMAL
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	hitsound = 'sound/weapons/slash.ogg'
	attack_verb = list("挥砍", "刺击", "切割", "撕扯", "撕裂", "切碎", "割伤")
	attack_speed = 9
	flags_equip_slot = SLOT_FACE
	flags_armor_protection = SLOT_FACE
	flags_item = CAN_DIG_SHRAPNEL
	flags_human_ai = MELEE_WEAPON_ITEM

	attach_icon = "bayonet_a"
	melee_mod = 20
	slot = "muzzle"
	pixel_shift_x = 14 //Below the muzzle.
	pixel_shift_y = 18
	hud_offset_mod = -4
	var/pry_delay = 3 SECONDS

/obj/item/attachable/bayonet/Initialize(mapload, ...)
	. = ..()
	if(flags_equip_slot & SLOT_FACE)
		AddElement(/datum/element/mouth_drop_item)

/obj/item/attachable/bayonet/New()
	..()
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/bayonet/upp
	name = "80 式刺刀"
	desc = "UPP 制式 80 式刺刀，配重使其也能作为有效的飞刀使用。"
	icon_state = "upp_bayonet"
	item_state = "knife"
	attach_icon = "upp_bayonet_a"
	throwforce = MELEE_FORCE_TIER_10 //doubled by throwspeed to 100
	throw_speed = SPEED_REALLY_FAST
	throw_range = 7
	pry_delay = 1 SECONDS

/obj/item/attachable/bayonet/upp/surplus
	desc = "UPP制式刺刀，这一把已经有些钝了。"
	throwforce = MELEE_FORCE_STRONG

/obj/item/attachable/bayonet/co2
	name = "M8 气瓶刺刀"
	desc = "一件经USCM认可、专供《新兵！》订阅者的过刊赠品，出自第255期《深入夜袭者——朱莉安娜·格德少尉谈摧毁士气的另类手段》。刀刃内部有一根加压管，按下按钮即可向刺伤处注入压缩CO2。摸起来很廉价，甚至像是坏的。"
	icon_state = "co2_knife"
	attach_icon = "co2_bayonet_a"
	var/filled = FALSE

/obj/item/attachable/bayonet/rmc
	name = "L5 刺刀"
	desc = "RMC 制式 L5 刺刀，配重使其也能作为有效的飞刀使用。"
	icon_state = "upp_bayonet" // PLACEHOLDER PLEASE REPLACE
	item_state = "combat_knife"
	attach_icon = "upp_bayonet_a" // PLACEHOLDER PLEASE REPLACE
	throwforce = MELEE_FORCE_TIER_10 //doubled by throwspeed to 100
	throw_speed = SPEED_REALLY_FAST
	throw_range = 7
	pry_delay = 1 SECONDS

/obj/item/attachable/bayonet/van_bandolier
	name = "费尔贝恩-赛克斯格斗刀"
	desc = "这把刀不是用来处理猎物或做营地杂务的，而是用来杀人的，几个世纪以来一直干得很出色。当其他一切都辜负了你，这把刀仍会握在你手中，准备执行它阴森的使命。"

/obj/item/attachable/bayonet/co2/update_icon()
	icon_state = "co2_knife[filled ? "-f" : ""]"
	attach_icon = "co2_bayonet[filled ? "-f" : ""]_a"

/obj/item/attachable/bayonet/co2/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/co2_cartridge))
		if(!filled)
			filled = TRUE
			user.visible_message(SPAN_NOTICE("[user]把一枚CO2气瓶装进了[src]。片刻之后，脸上明显露出了沮丧。"), SPAN_WARNING("你把一枚新的CO2气瓶装进[src]，扣好槽盖，才发现[W]的阀门断在[src]里面了。妈的。"))
			playsound(src, 'sound/machines/click.ogg')
			qdel(W)
			update_icon()
			return
		else
			user.visible_message(SPAN_WARNING("[user]摆弄着[src]，看起来很懊恼。"), SPAN_NOTICE("不行，老兄！你似乎没法把里面的气瓶从[src]中撬出来……试试螺丝刀？"))
			return
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		user.visible_message(SPAN_WARNING("[user]用[W]折腾着[src]，看起来十分懊恼。"), SPAN_NOTICE("你试图从[src]里撬出气瓶，可它卡得太深了。这破烂玩意……"))
		return
	..()

/obj/item/co2_cartridge //where tf else am I gonna put this?
	name = "CO2 气瓶"
	desc = "供M8气瓶刺刀使用的压缩CO2气瓶。请勿吞食或刺穿。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "co2_cartridge"
	item_state = ""
	w_class = SIZE_TINY

/obj/item/attachable/bayonet/canc
	name = "4式刺刀"
	desc = "一件旧时代的遗物，曾由中国与亚洲国家合作体生产；自合作体解体后，已没有军队继续使用。尽管UPP联合武装各部都未采用它，仍能在跳蚤市场、前CANC军人或如今的CANC复辟狂热分子手中找到。可惜它只装得上那破烂的LW-317卡宾枪……"
	icon_state = "knife_chinese"
	item_state = "knife_chinese"
	attach_icon = "canc_bayonet_a"
	pixel_shift_x = 17
	pixel_shift_y = 20

/obj/item/attachable/extended_barrel
	name = "加长枪管"
	desc = "加长枪管可减少未燃尽火药，提高初速与精度。"
	slot = "muzzle"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "ebarrel"
	attach_icon = "ebarrel_a"
	hud_offset_mod = -3
	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/extended_barrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	velocity_mod = AMMO_SPEED_TIER_1

/obj/item/attachable/heavy_barrel
	name = "枪管增压器"
	desc = "适用于大多数枪械枪口的超螺纹枪管延长装置，可提高子弹飞行速度。\n以精度和射速为代价，大幅提高弹体伤害。"
	slot = "muzzle"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "hbarrel"
	attach_icon = "hbarrel_a"
	hud_offset_mod = -3

/obj/item/attachable/heavy_barrel/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	damage_mod = BULLET_DAMAGE_MULT_TIER_6
	delay_mod = FIRE_DELAY_TIER_11

	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_7

/obj/item/attachable/heavy_barrel/Attach(obj/item/weapon/gun/G)
	if(G.gun_category == GUN_CATEGORY_SHOTGUN)
		damage_mod = BULLET_DAMAGE_MULT_TIER_1
	else
		damage_mod = BULLET_DAMAGE_MULT_TIER_6
	..()

/obj/item/attachable/compensator
	name = "后坐补偿器"
	desc = "将排出的气体导向上方以抵消后坐力的枪口配件。\n可提高精度并降低后坐力。"
	slot = "muzzle"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "comp"
	attach_icon = "comp_a"
	pixel_shift_x = 17
	hud_offset_mod = -3

/obj/item/attachable/compensator/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_3

	damage_falloff_mod = 0.1
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_4


/obj/item/attachable/slavicbarrel
	name = "狙击枪管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "slavicbarrel"
	desc = "一根重型枪管。无法拆卸。"
	slot = "muzzle"

	pixel_shift_x = 20
	pixel_shift_y = 16
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -4

/obj/item/attachable/slavicbarrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/f90_dmr_barrel
	name = "f90 枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "aug_dmr_barrel_a"
	attach_icon = "aug_dmr_barrel_a"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/f90_shotgun_barrel
	name = "f90 枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "aug_mkey_barrel_a"
	attach_icon = "aug_mkey_barrel_a"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/l56a2_smartgun
	name = "L58A3 枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "magsg_barrel_a"
	attach_icon = "magsg_barrel_a"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/upp_smartgun
	name = "RFVS-37 枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "rfvs37_barrel"
	attach_icon = "rfvs37_barrel"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0

/obj/item/attachable/sniperbarrel
	name = "狙击枪管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "sniperbarrel"
	desc = "一根重型枪管。无法拆卸。"
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -3

/obj/item/attachable/sniperbarrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/supsniperbarrel
	name = "消音狙击枪管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "supsniperbarrel"
	desc = "一根重型枪管。无法拆卸。"
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	gun_traits = list(TRAIT_GUN_SILENCED)
	hud_offset_mod = -3

/obj/item/attachable/supsniperbarrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/pmc_sniperbarrel
	name = "狙击枪管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "pmc_sniperbarrel"
	desc = "一根重型枪管。无法拆卸。"
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -3

/obj/item/attachable/pmc_sniperbarrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/sniperbarrel/vulture
	name = "M707 枪管"
	icon_state = "vulture_barrel"
	hud_offset_mod = -1

/obj/item/attachable/m60barrel
	name = "M60 枪管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "m60barrel"
	desc = "一根重型枪管。无法拆卸。"
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -6

/obj/item/attachable/m60barrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/mar50barrel
	name = "MAR-50 枪管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "mar50barrel"
	desc = "一根重型枪管。无法拆卸。"
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -6

/obj/item/attachable/mar50barrel/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_8

/obj/item/attachable/smartbarrel
	name = "智能机枪枪管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "m56_barrel"
	desc = "M56智能机枪的枪管末端，带有补偿器。无法拆卸。"
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	pixel_shift_x = 14
	hud_offset_mod = -4

/obj/item/attachable/smartbarrel/suppressed
	name = "消音智能机枪枪管"
	icon_state = "silenced_smartgun"
	gun_traits = list(TRAIT_GUN_SILENCED)

/obj/item/attachable/simbarrel
	name = "SIM-118 发射管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "fim_barrel"
	desc = "SIM 118发射器的发射管末端。无法拆卸。"
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	pixel_shift_x = 14
	hud_offset_mod = -4

/obj/item/attachable/emblrbarrel
	name = "EMBLR 92 发射管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "emblr_barrel"
	desc = "EMBLR地对空导弹发射器的发射管末端。无法拆卸。"
	slot = "muzzle"
	flags_attach_features = NO_FLAGS
	pixel_shift_x = 14
	hud_offset_mod = -4

// Mateba barrels

/obj/item/attachable/mateba
	name = "标准马特巴枪管"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "mateba_medium"
	desc = "标准马特巴枪管，在精度与射速之间取得平衡。"
	slot = "special"
	flags_attach_features = NO_FLAGS

/obj/item/attachable/mateba/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3

/obj/item/attachable/mateba/Attach(obj/item/weapon/gun/G)
	..()
	G.attachable_offset["muzzle_x"] = 27

/obj/item/attachable/mateba/Detach(mob/user, obj/item/weapon/gun/detaching_gub, drop_attachment = TRUE)
	..()
	detaching_gub.attachable_offset["muzzle_x"] = 20

/obj/item/attachable/mateba/dark
	icon_state = "mateba_medium_a"

/obj/item/attachable/mateba/long
	name = "马特巴精确射击枪管"
	icon_state = "mateba_long"
	desc = "马特巴精确射击枪管，以射速为代价提高精度。"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = -1

/obj/item/attachable/mateba/long/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_6
	delay_mod = FIRE_DELAY_TIER_7

/obj/item/attachable/mateba/long/Attach(obj/item/weapon/gun/G)
	..()
	G.attachable_offset["muzzle_x"] = 27

/obj/item/attachable/mateba/long/dark
	icon_state = "mateba_long_a"

/obj/item/attachable/mateba/short
	name = "马特巴短枪管"
	icon_state = "mateba_short"
	desc = "马特巴短枪管，以精度为代价提高射速。"
	hud_offset_mod = 2

/obj/item/attachable/mateba/short/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_4
	scatter_mod = SCATTER_AMOUNT_TIER_6
	delay_mod = -FIRE_DELAY_TIER_7

/obj/item/attachable/mateba/short/Attach(obj/item/weapon/gun/G)
	..()
	G.attachable_offset["muzzle_x"] = 27

/obj/item/attachable/mateba/short/dark
	icon_state = "mateba_short_a"

/obj/item/attachable/isr_barrel
	name = "ISR 枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "isr_barrel"
	attach_icon = "isr_barrel"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

// ======== Rail attachments ======== //

/obj/item/attachable/reddot
	name = "S5 红点瞄准镜"
	desc = "阿玛特 S5 红点瞄准镜，制式编号 AN/PVQ-62。无倍率光学镜配有遮光罩，能在强光下保持清晰并抵御恶劣天气。小巧、不挡视野，可提高双手持枪精度。"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "reddot"
	attach_icon = "reddot_a"
	slot = "rail"

/obj/item/attachable/reddot/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5

/obj/item/attachable/reddot/upp
	name = "EKP-9-M 红点瞄准镜"
	desc = "UPP的尖端瞄准镜，可自动修正分划以保持固定归零点，显著提高精度。"

/obj/item/attachable/reflex
	name = "S6 反射式瞄准镜"
	desc = "阿玛特 S6 反射式瞄准镜，制式编号 AN/PVG-72。无需放大的机械瞄具替代品，可降低点射散布。可连接军用抬头显示器，提供有限的连续计算命中点功能。"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "reflex"
	attach_icon = "reflex_a"
	slot = "rail"

/obj/item/attachable/reflex/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	burst_scatter_mod = -1
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5

/obj/item/attachable/reflex/upp
	name = "PK-12 反射式瞄准镜"
	desc = "兼容大多数UPP制式枪械的反射式瞄准镜。经久耐用，但供电系统出了名地不可靠。显著减小散布，并略微提高精度。"

/obj/item/attachable/flashlight
	name = "导轨手电筒"
	desc = "普通的导轨手电筒。亮度出人意料，比大多数护甲系统的内置灯更亮。"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "flashlight"
	attach_icon = "flashlight_a"
	light_mod = 5
	slot = "side_rail"
	matter = list("metal" = 50,"glass" = 20)
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	activation_sound = 'sound/handling/light_on_1.ogg'
	deactivation_sound = 'sound/handling/click_2.ogg'
	var/original_state = "flashlight"
	var/original_attach = "flashlight_a"

	var/helm_mounted_light_power = 2
	var/helm_mounted_light_range = 3

	var/datum/action/item_action/activation
	var/obj/item/attached_item

/obj/item/attachable/flashlight/on_enter_storage(obj/item/storage/internal/S)
	..()

	if(!istype(S, /obj/item/storage/internal))
		return

	if(!istype(S.master_object, /obj/item/clothing/head/helmet/marine))
		return

	remove_attached_item()

	attached_item = S.master_object
	RegisterSignal(attached_item, COMSIG_PARENT_QDELETING, PROC_REF(remove_attached_item))
	activation = new /datum/action/item_action/toggle(src, S.master_object)

	if(ismob(S.master_object.loc))
		activation.give_to(S.master_object.loc)

/obj/item/attachable/flashlight/on_exit_storage(obj/item/storage/S)
	remove_attached_item()
	return ..()

/obj/item/attachable/flashlight/proc/remove_attached_item()
	SIGNAL_HANDLER
	if(!attached_item)
		return
	if(light_on)
		icon_state = original_state
		attach_icon = original_attach
		activate_attachment(attached_item, attached_item.loc, TRUE)
	UnregisterSignal(attached_item, COMSIG_PARENT_QDELETING)
	qdel(activation)
	attached_item.update_icon()
	attached_item = null

/obj/item/attachable/flashlight/ui_action_click(mob/owner, obj/item/holder)
	if(!attached_item)
		. = ..()
	else
		activate_attachment(attached_item, owner)

/obj/item/attachable/flashlight/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	turn_light(user, turn_off ? !turn_off : !light_on)

/obj/item/attachable/flashlight/turn_light(mob/user, toggle_on, cooldown, sparks, forced, light_again)
	. = ..()
	if(. != CHECKS_PASSED)
		return

	if(istype(attached_item, /obj/item/clothing/head/helmet/marine))
		if(!toggle_on || light_on)
			if(light_on)
				playsound(user, deactivation_sound, 15, 1)
			icon_state = original_state
			attach_icon = original_attach
			light_on = FALSE
		else
			playsound(user, activation_sound, 15, 1)
			icon_state += "-on"
			attach_icon += "-on"
			light_on = TRUE
		attached_item.update_icon()
		attached_item.set_light_range(helm_mounted_light_range)
		attached_item.set_light_power(helm_mounted_light_power)
		attached_item.set_light_on(light_on)
		activation.update_button_icon()
		return

	if(!isgun(loc))
		return

	var/obj/item/weapon/gun/attached_gun = loc

	if(toggle_on && !light_on)
		attached_gun.set_light_range(attached_gun.light_range + light_mod)
		attached_gun.set_light_power(attached_gun.light_power + (light_mod * 0.5))
		if(!(attached_gun.flags_gun_features & GUN_FLASHLIGHT_ON))
			attached_gun.set_light_on(TRUE)
			light_on = TRUE
			attached_gun.flags_gun_features |= GUN_FLASHLIGHT_ON

	if(!toggle_on && light_on)
		attached_gun.set_light_range(attached_gun.light_range - light_mod)
		attached_gun.set_light_power(attached_gun.light_power - (light_mod * 0.5))
		if(attached_gun.flags_gun_features & GUN_FLASHLIGHT_ON)
			attached_gun.set_light_on(FALSE)
			light_on = FALSE
			attached_gun.flags_gun_features &= ~GUN_FLASHLIGHT_ON

	if(attached_gun.flags_gun_features & GUN_FLASHLIGHT_ON)
		icon_state += "-on"
		attach_icon += "-on"
		playsound(user, deactivation_sound, 15, 1)
	else
		icon_state = original_state
		attach_icon = original_attach
		playsound(user, activation_sound, 15, 1)
	attached_gun.update_attachable(slot)

	for(var/X in attached_gun.actions)
		var/datum/action/A = X
		if(A.target == src)
			A.update_button_icon()
	return TRUE

/obj/item/attachable/flashlight/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		to_chat(user, SPAN_NOTICE("你拆下导轨手电筒的安装座，把它改成了普通手电筒。"))
		if(isstorage(loc))
			var/obj/item/storage/S = loc
			S.remove_from_storage(src)
		if(loc == user)
			user.temp_drop_inv_item(src)
		var/obj/item/device/flashlight/F = new(user)
		user.put_in_hands(F) //This proc tries right, left, then drops it all-in-one.
		qdel(src) //Delete da old flashlight
	else
		. = ..()

/obj/item/attachable/flashlight/grip //Grip Light is here because it is a child object. Having it further down might cause a future coder a headache.
	name = "下挂手电握把"
	desc = "天哪，后勤军官老兄，他们居然给手电筒装了个握把！\n小幅降低后坐力与散布，并小幅提高精度，还能照明。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "flashgrip"
	attach_icon = "flashgrip_a"
	slot = "under"
	original_state = "flashgrip"
	original_attach = "flashgrip_a"

/obj/item/attachable/flashlight/grip/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/flashlight/grip/attackby(obj/item/I, mob/user)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		to_chat(user, SPAN_NOTICE("慢着，牛仔。握把是用螺栓固定的，你没法改装它。"))
	return

/obj/item/attachable/flashlight/grip/upp
	name = "RK-5A 手电握把"
	desc = "内置手电筒的折叠握把，略微降低后坐力与散布，并略微提高精度。\n性能与下挂手电握把相同。"

/obj/item/attachable/flashlight/laser_light_combo //Unique attachment for the VP78 based on the fact it has a Laser-Light Module in AVP2010
	name = "激光照明模块"
	desc = "供VP78制式手枪使用的激光照明模块，正作为USCM下一代手枪计划的一部分进行有限范围的实地试用。所有VP78手枪都配有该模块。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "vplaserlight"
	attach_icon = "vplaserlight_a"
	slot = "under"
	original_state = "vplaserlight"
	original_attach = "vplaserlight_a"

/obj/item/attachable/flashlight/laser_light_combo/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_9
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/flashlight/laser_light_combo/attackby(obj/item/combo_light, mob/user)
	if(HAS_TRAIT(combo_light, TRAIT_TOOL_SCREWDRIVER))
		to_chat(user, SPAN_NOTICE("你无法改装它。"))
	return

/obj/item/attachable/magnetic_harness
	name = "磁力枪背带"
	desc = "通过磁力连接到武器导轨的背带套件。武器掉落时会自动挂回穿戴的任意 USCM 护甲上。"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "magnetic"
	attach_icon = "magnetic_a"
	slot = "rail"
	pixel_shift_x = 13
	var/retrieval_slot = WEAR_J_STORE

/obj/item/attachable/magnetic_harness/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_1
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/magnetic_harness/can_be_attached_to_gun(mob/user, obj/item/weapon/gun/G)
	if(SEND_SIGNAL(G, COMSIG_DROP_RETRIEVAL_CHECK) & COMPONENT_DROP_RETRIEVAL_PRESENT)
		to_chat(user, SPAN_WARNING("[G]已经装有回收系统了！"))
		return FALSE
	return ..()

/obj/item/attachable/magnetic_harness/Attach(obj/item/weapon/gun/G)
	. = ..()
	G.AddElement(/datum/element/drop_retrieval/gun, retrieval_slot)

/obj/item/attachable/magnetic_harness/Detach(mob/user, obj/item/weapon/gun/detaching_gub, drop_attachment = TRUE)
	. = ..()
	detaching_gub.RemoveElement(/datum/element/drop_retrieval/gun, retrieval_slot)

/obj/item/attachable/magnetic_harness/lever_sling
	name = "R4T 磁力枪背带" //please don't make this attachable to any other guns...
	desc = "不知为何，专门为舒适携带十九世纪杠杆式步枪设计的定制枪背带。内置磁铁，确保杠杆式步枪不会从背上掉落，不过也有点妨碍握持。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "r4t-sling"
	attach_icon = "r4t-sling_a"
	slot = "under"
	wield_delay_mod = WIELD_DELAY_VERY_FAST
	retrieval_slot = WEAR_BACK

/obj/item/attachable/magnetic_harness/lever_sling/New()
	..()
	select_gamemode_skin(type)

/obj/item/attachable/magnetic_harness/lever_sling/Attach(obj/item/weapon/gun/G) //this is so the sling lines up correctly
	. = ..()
	G.attachable_offset["under_x"] = 15
	G.attachable_offset["under_y"] = 12


/obj/item/attachable/magnetic_harness/lever_sling/Detach(mob/user, obj/item/weapon/gun/detaching_gub, drop_attachment = TRUE)
	. = ..()
	detaching_gub.attachable_offset["under_x"] = 24
	detaching_gub.attachable_offset["under_y"] = 16

/obj/item/attachable/magnetic_harness/lever_sling/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon

/obj/item/attachable/sling //Mostly cosmetic, some one-handed fire adjustments
	name = "两点式枪背带"
	desc = "一条传统的强化尼龙枪背带，两端配有卡扣，可连接到美洲联盟武装部队大多数长枪的相应挂点上。"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "pve-sling"
	attach_icon = "pve-sling_a"
	slot = "rail"

/obj/item/attachable/sling/New()
	..()
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_2
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_2

/obj/item/attachable/scope
	name = "S8 4x 望远瞄准镜"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "sniperscope"
	attach_icon = "sniperscope_a"
	desc = "阿玛特 S8 瞄准镜，型号 AN/PVQ-31。固定 4 倍放大，瞄准目标所需时间更长，但开镜时精度更高。"
	slot = "rail"
	aim_speed_mod = SLOWDOWN_ADS_SCOPE //Extra slowdown when wielded
	wield_delay_mod = WIELD_DELAY_FAST
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/zoom_offset = 11
	var/zoom_viewsize = 12
	var/allows_movement = 0
	var/accuracy_scoped_buff
	var/delay_scoped_nerf
	var/damage_falloff_scoped_buff
	var/ignore_clash_fog = FALSE
	var/using_scope

/obj/item/attachable/scope/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	accuracy_unwielded_mod = 0

	accuracy_scoped_buff = HIT_ACCURACY_MULT_TIER_8 //to compensate initial debuff
	damage_falloff_scoped_buff = -0.4 //has to be negative

/obj/item/attachable/scope/Attach(obj/item/weapon/gun/gun)
	. = ..()
	RegisterSignal(gun, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES, PROC_REF(handle_attachment_recalc))

/obj/item/attachable/scope/Detach(mob/user, obj/item/weapon/gun/detaching_gub, drop_attachment = TRUE)
	. = ..()
	UnregisterSignal(detaching_gub, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES)


/// Due to the bipod's interesting way of handling stat modifications, this is necessary to prevent exploits.
/obj/item/attachable/scope/proc/handle_attachment_recalc(obj/item/weapon/gun/source)
	SIGNAL_HANDLER

	if(!source.zoom)
		return

	if(using_scope)
		source.accuracy_mult += accuracy_scoped_buff
		source.damage_falloff_mult += damage_falloff_scoped_buff


/obj/item/attachable/scope/proc/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	if(G.zoom)
		G.accuracy_mult += accuracy_scoped_buff
		G.damage_falloff_mult += damage_falloff_scoped_buff
		using_scope = TRUE
		RegisterSignal(user, COMSIG_LIVING_ZOOM_OUT, PROC_REF(remove_scoped_buff))

/obj/item/attachable/scope/proc/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	SIGNAL_HANDLER
	UnregisterSignal(user, COMSIG_LIVING_ZOOM_OUT)
	using_scope = FALSE
	G.accuracy_mult -= accuracy_scoped_buff
	G.damage_falloff_mult -= damage_falloff_scoped_buff

/obj/item/attachable/scope/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(turn_off || G.zoom)
		if(G.zoom)
			G.zoom(user, zoom_offset, zoom_viewsize, allows_movement)
		return TRUE

	if(!G.zoom)
		if(!(G.flags_item & WIELDED))
			if(user)
				to_chat(user, SPAN_WARNING("你必须双手握持[G]才能使用[src]。"))
			return FALSE
		if(MODE_HAS_FLAG(MODE_FACTION_CLASH) && !ignore_clash_fog)
			if(user)
				to_chat(user, SPAN_DANGER("你透过[src]看去，却发现镜片似乎起雾了，无法使用！"))
			return FALSE
		else
			G.zoom(user, zoom_offset, zoom_viewsize, allows_movement)
			apply_scoped_buff(G,user)
	return TRUE

//variable zoom scopes, they go between 2x and 4x zoom.

#define ZOOM_LEVEL_2X 0
#define ZOOM_LEVEL_4X 1

/obj/item/attachable/scope/upp
	name = "PO-M 4倍瞄准镜"
	desc = "老式4倍瞄准镜，坚固，但人体工学稍差。UPP的传统。降低射速并延长举枪时间，开镜时大幅提高精度。"

/obj/item/attachable/scope/variable_zoom
	name = "S10 可变倍望远瞄准镜"
	desc = "阿玛特S10望远瞄准镜，可在2倍与4倍之间切换；2倍时允许开镜移动。点击“使用导轨附件”抬头显示图标，或使用同名命令（Use Rail Attachment）开镜。"
	attachment_action_type = /datum/action/item_action/toggle
	var/dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC
	var/zoom_level = ZOOM_LEVEL_4X

/obj/item/attachable/scope/variable_zoom/Attach(obj/item/weapon/gun/G)
	. = ..()
	var/mob/living/living
	var/given_zoom_action = FALSE
	if(living && (G == living.l_hand || G == living.r_hand))
		give_action(living, /datum/action/item_action/toggle_zoom_level, src, G)
		given_zoom_action = TRUE
	if(!given_zoom_action)
		new /datum/action/item_action/toggle_zoom_level(src, G)

/obj/item/attachable/scope/variable_zoom/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	. = ..()
	if(G.zoom)
		G.slowdown += dynamic_aim_slowdown

/obj/item/attachable/scope/variable_zoom/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	G.slowdown -= dynamic_aim_slowdown
	..()

/obj/item/attachable/scope/variable_zoom/proc/toggle_zoom_level()
	if(using_scope)
		to_chat(usr, SPAN_WARNING("透过[src]观察时，无法调整倍率！"))
		return
	if(zoom_level == ZOOM_LEVEL_2X)
		zoom_level = ZOOM_LEVEL_4X
		zoom_offset = 11
		zoom_viewsize = 12
		allows_movement = 0
		to_chat(usr, SPAN_NOTICE("倍率已切换为4倍。"))
		return
	else
		zoom_level = ZOOM_LEVEL_2X
		zoom_offset = 6
		zoom_viewsize = 7
		allows_movement = 1
		to_chat(usr, SPAN_NOTICE("倍率已切换为2倍。"))
		return

/datum/action/item_action/toggle_zoom_level

/datum/action/item_action/toggle_zoom_level/New()
	..()
	name = "切换倍率"
	button.name = name

/datum/action/item_action/toggle_zoom_level/action_activate()
	. = ..()
	var/obj/item/weapon/gun/G = holder_item
	var/obj/item/attachable/scope/variable_zoom/S = G.attachments["rail"]
	S.toggle_zoom_level()

//other variable zoom scopes

/obj/item/attachable/scope/variable_zoom/integrated
	name = "可变倍瞄准镜"

/obj/item/attachable/scope/variable_zoom/integrated/svd_iff
	name = "带敌我识别功能的可变倍瞄准镜"

/obj/item/attachable/scope/variable_zoom/integrated/svd_iff/New()
	..()
	delay_mod = -FIRE_DELAY_TIER_2
	scatter_mod = -SCATTER_AMOUNT_TIER_10
/*
/obj/item/attachable/scope/variable_zoom/integrated/svd_iff/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))
*/

/obj/item/attachable/scope/variable_zoom/slavic
	icon_state = "slavicscope"
	attach_icon = "slavicscope"
	desc = "哎呀！你为什么把它从光荣的斯大林武器上拆下来了？妈的，装回去干活，同志。洋基佬总不会自己朝自己开枪，对吧？"

/obj/item/attachable/scope/variable_zoom/eva
	name = "RXF-M5 EVA 可变倍望远瞄准镜"
	icon_state = "rxfm5_eva_scope"
	attach_icon = "rxfm5_eva_scope_a"
	desc = "一款可在近距和远距倍率之间切换的民用瞄准镜，设计用于外星勘察。装在手枪上显得很滑稽。"
	aim_speed_mod = 0

/obj/item/attachable/scope/variable_zoom/canc
	name = "LMR-72 4倍智能瞄准镜"
	desc = "一款过时的CANC瞄准镜。"
	icon_state = "canc_scope"
	attach_icon = "canc_scope"
	pixel_shift_x = 13
	pixel_shift_y = 15

/obj/item/attachable/scope/variable_zoom/canc/toggle_zoom_level()
	if(ishuman(usr))
		var/mob/living/carbon/human/human = usr
		if(!istype(human.glasses, /obj/item/clothing/glasses/canc_monoscope))
			to_chat(human, SPAN_WARNING("没有单目镜，就无法使用该瞄准镜的高分辨率放大功能！"))
			return
	..()

/obj/item/attachable/scope/variable_zoom/canc/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		if(!istype(human.glasses, /obj/item/clothing/glasses/canc_monoscope))
			zoom_level = ZOOM_LEVEL_2X
			zoom_offset = 6
			zoom_viewsize = 7
			allows_movement = 1
	..()
#undef ZOOM_LEVEL_2X
#undef ZOOM_LEVEL_4X


/obj/item/attachable/scope/mini
	name = "S4 2x 小型望远瞄准镜"
	icon_state = "miniscope"
	attach_icon = "miniscope_a"
	desc = "阿玛特 S4 瞄准镜，型号 AN/PVQ-45。2 倍光学放大，开镜时可提高精度。\n请经常归零校准：首批产品在重度使用后会出现偏移，部分可能仍在流通。"
	slot = "rail"
	zoom_offset = 6
	zoom_viewsize = 7
	allows_movement = TRUE
	aim_speed_mod = 0
	var/dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC

/obj/item/attachable/scope/mini/New()
	..()
	damage_falloff_scoped_buff = -0.2 //has to be negative

/obj/item/attachable/scope/mini/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	. = ..()
	if(G.zoom)
		G.slowdown += dynamic_aim_slowdown

/obj/item/attachable/scope/mini/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	G.slowdown -= dynamic_aim_slowdown
	..()

/obj/item/attachable/scope/mini/upp
	name = "1P93 2倍瞄准镜"
	desc = "基于2159年UPP设计小幅改进的瞄准镜。能在各种条件下保持归零，防反光格栅可避免眩光，可惜分划过于繁杂。降低射速、延长举枪时间，开镜时提高精度。"

/obj/item/attachable/scope/mini/flaregun
	wield_delay_mod = 0
	dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC

/obj/item/attachable/scope/mini/f90
	dynamic_aim_slowdown = SLOWDOWN_ADS_NONE

/obj/item/attachable/scope/mini/flaregun/New()
	..()
	delay_mod = 0
	accuracy_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0

	accuracy_scoped_buff = HIT_ACCURACY_MULT_TIER_8

/obj/item/attachable/scope/mini/hunting
	name = "2 倍狩猎小型瞄准镜"
	icon_state = "huntingscope"
	attach_icon = "huntingscope"
	desc = "普通的固定 2 倍光学瞄准镜，在民间几乎随处可见，有时执法部门也会使用。"

/obj/item/attachable/scope/mini/hunting/upp
	name = "POS-3 狩猎小型瞄准镜"
	icon_state = "upphuntingscope"
	attach_icon = "upphuntingscope"
	desc = "联盟制造的简易民用狩猎与运动瞄准镜。"

/obj/item/attachable/scope/mini/nsg23
	name = "维兰德-汤谷 S4 2倍高级小型望远瞄准镜"
	desc = "阿玛特S4望远瞄准镜，经第三方承包商调整，改善了人体工学。"
	icon_state = "miniscope_nsg23"
	attach_icon = "miniscope_nsg23_a"
	zoom_offset = 4
	dynamic_aim_slowdown = SLOWDOWN_ADS_NONE

/obj/item/attachable/scope/mini/nsg23/rmc
	name = "L4A5 SUMSA 小型瞄准镜" //Sight Unit, General Marine Armaments was a serious contender for the name instead of this
	desc = "陆战队轻武器瞄准装置。由阿玛特S4望远瞄准镜改进而来，皇家陆战突击队将其用于L23A1步枪。这一款涂有深色哑光涂层。"
	icon_state = "miniscope"
	attach_icon = "miniscope_a"

/obj/item/attachable/scope/mini/rmcdmr
	name = "L5A2 SUMMR 瞄准镜"
	icon_state = "sniperscope"
	attach_icon = "sniperscope_a"
	desc = "陆战队精确射手步枪瞄准装置。一款4倍光学瞄准镜，常配用于皇家陆战队的L64A3精确射手步枪。"
	dynamic_aim_slowdown = SLOWDOWN_ADS_QUICK
	zoom_offset = 8
	zoom_viewsize = 9

/obj/item/attachable/scope/mini/xm88
	name = "XS-9 瞄准中继器"
	desc = "阿玛特 XS-9 光学接口，型号 XAN/PVG-90。计算机控制的 2 倍镜配有电子火控系统，可连接步枪传感器，实现近乎完美的射击精度……理论上如此。"
	icon_state = "boomslang-scope"
	zoom_offset = 7
	dynamic_aim_slowdown = SLOWDOWN_ADS_NONE

/obj/item/attachable/scope/mini/xm88/New()
	..()
	select_gamemode_skin(type)
	attach_icon = icon_state

/obj/item/attachable/scope/mini/sadar
	name = "M83A2 SADAR 瞄准组件"
	desc = "SADAR瞄准系统。"
	zoom_offset = 3

/obj/item/attachable/scope/mini/rmcgl
	name = "L164A3 准直式瞄准组件"
	desc = "L164A3瞄准系统。"
	zoom_offset = 3
	icon_state = "reflex"

/obj/item/attachable/scope/mini/rmcsg
	name = "L58A3 瞄准接口"
	desc = "L58A3 gunsight interface. You shouldn't ever see this."
	zoom_offset = 4
	icon_state = "sgsight"

/obj/item/attachable/scope/mini/army
	desc = "阿玛特S4瞄准镜，型号AN/PVQ-45。2倍光学放大，开镜时提高精度、降低射速，并提高举枪速度。"
	zoom_offset = 4

//Mini-scope for the scout rifle

/obj/item/attachable/scope/mini/scout
	name = "M49A 瞄准中继器"
	desc = "阿玛特M49A5光学接口，型号AN/PVX-56。可无线连接操作员的M49A目镜，提供与枪膛轴线对应的一比一瞄准画面，另有计算机命中点计算系统，辅助精确射击。"
	icon_state = "m49a_custom_scope"
	attach_icon = "m49a_custom_scope"
	zoom_offset = 7
	dynamic_aim_slowdown = SLOWDOWN_ADS_NONE

/obj/item/attachable/scope/mini/scout/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		if(!istype(human.glasses, /obj/item/clothing/glasses/night/M49A))
			to_chat(human, SPAN_WARNING("没有战斗瞄准目镜，就无法使用瞄准中继器！"))
			return
	..()

// PVE tech-man compliant mini scope, planned to have togglable vision modes for shitty night-vision when scoped in

/obj/item/attachable/scope/pve
	name = "AN/RVS-52 CCD 电视瞄准系统"
	desc = "阿玛特设计的3倍武器瞄准镜，能提高远距离及低光环境下的射击精度。安装座兼容USCM最常用的步枪。这一款看起来从林纳349战役开始就一直在服役。"
	icon_state = "pvescope"
	zoom_offset = 3
	zoom_viewsize = 7
	allows_movement = TRUE
	var/dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC

/obj/item/attachable/scope/pve/New()
	..()
	damage_falloff_scoped_buff = -0.2

/obj/item/attachable/scope/pve/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	. = ..()
	if(G.zoom)
		G.slowdown += dynamic_aim_slowdown

/obj/item/attachable/scope/pve/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	G.slowdown -= dynamic_aim_slowdown
	..()

/obj/item/attachable/scope/m79
	name = "M79 瞄具"
	desc = "You shouldn't be seeing this!"
	icon_state = "m79_sight"
	zoom_offset = 3
	zoom_viewsize = 7
	allows_movement = TRUE
	attach_icon = null
	hidden = TRUE

/obj/item/attachable/scope/mini_iff
	name = "B8 智能瞄准镜"
	icon_state = "iffbarrel"
	attach_icon = "iffbarrel_a"
	desc = "实验型 B8 智能瞄准镜，型号 XAN/PVG-110。有限的自动敌我识别扳机联锁系统，可与 M44 战斗左轮手枪及 M49A 战斗步枪配合使用。短暂的扳机延迟会降低伤害。"
	slot = "rail"
	zoom_offset = 6
	zoom_viewsize = 7
	pixel_shift_y = 15
	var/dynamic_aim_slowdown = SLOWDOWN_ADS_MINISCOPE_DYNAMIC

/obj/item/attachable/scope/mini_iff/New()
	..()
	damage_mod = -BULLET_DAMAGE_MULT_TIER_4
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_6
	accuracy_unwielded_mod = 0

	accuracy_scoped_buff = HIT_ACCURACY_MULT_TIER_1
	delay_scoped_nerf = 0
	damage_falloff_scoped_buff = 0

/obj/item/attachable/scope/mini_iff/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/attachable/scope/mini_iff/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	if(do_after(user, 8, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		allows_movement = 1
		. = ..()

/obj/item/attachable/scope/mini_iff/apply_scoped_buff(obj/item/weapon/gun/G, mob/living/carbon/user)
	. = ..()
	if(G.zoom)
		G.slowdown += dynamic_aim_slowdown

/obj/item/attachable/scope/mini_iff/remove_scoped_buff(mob/living/carbon/user, obj/item/weapon/gun/G)
	G.slowdown -= dynamic_aim_slowdown
	..()

/obj/item/attachable/scope/slavic
	icon_state = "slavicscope"
	attach_icon = "slavicscope"
	desc = "哎呀！你怎么把它从光荣的斯大林武器上拆下来了？妈的，装回去干活，同志。洋基佬总不会自己朝自己开枪，对吧？"

/obj/item/attachable/vulture_scope // not a subtype of scope because it uses basically none of the scope's features
	name = "M707“秃鹫”瞄准镜"
	icon = 'icons/obj/items/weapons/guns/attachments/rail.dmi'
	icon_state = "vulture_scope"
	attach_icon = "vulture_scope"
	desc = "供M707反器材步枪使用的强大瞄准镜，不过有些碍事。" // Can't be seen normally, anyway
	slot = "rail"
	aim_speed_mod = SLOWDOWN_ADS_SCOPE //Extra slowdown when wielded
	wield_delay_mod = WIELD_DELAY_FAST
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	/// Weakref to the user of the scope
	var/datum/weakref/scope_user
	/// If the scope is currently in use
	var/scoping = FALSE
	/// How far out the player should see by default
	var/start_scope_range = 12
	/// The bare minimum distance the scope can be from the player
	var/min_scope_range = 12
	/// The maximum distance the scope can be from the player
	var/max_scope_range = 25
	/// How far in the perpendicular axis the scope can move in either direction
	var/perpendicular_scope_range = 7
	/// How far in each direction the scope should see. Default human view size is 7
	var/scope_viewsize = 7
	/// The current X position of the scope within the sniper's view box. 0 is center
	var/scope_offset_x = 0
	/// The current Y position of the scope within the sniper's view box. 0 is center
	var/scope_offset_y = 0
	/// How far in any given direction the scope can drift
	var/scope_drift_max = 2
	/// The current X coord position of the scope camera
	var/scope_x = 0
	/// The current Y coord position of the scope camera
	var/scope_y = 0
	/// Ref to the scope screen element
	var/atom/movable/screen/vulture_scope/scope_element
	/// If the gun should experience scope drift
	var/scope_drift = TRUE
	/// % chance for the scope to drift on process with a spotter using their scope
	var/spotted_drift_chance = 25
	/// % chance for the scope to drift on process without a spotter using their scope
	var/unspotted_drift_chance = 90
	/// If the scope should use do_afters for adjusting and moving the sight
	var/slow_use = TRUE
	/// Cooldown for interacting with the scope's adjustment or position
	COOLDOWN_DECLARE(scope_interact_cd)
	/// If the user is currently holding their breath
	var/holding_breath = FALSE
	/// Cooldown for after holding your breath
	COOLDOWN_DECLARE(hold_breath_cd)
	/// How long you can hold your breath for
	var/breath_time = 4 SECONDS
	/// How long the cooldown for holding your breath is, only starts after breath_time finishes
	var/breath_cooldown_time = 12 SECONDS
	/// The initial dir of the scope user when scoping in
	var/scope_user_initial_dir
	/// How much to increase darkness view by
	var/darkness_view = 12
	/// If there is currently a spotter using the linked spotting scope
	var/spotter_spotting = FALSE
	/// How much time it takes to adjust the position of the scope. Adjusting the offset will take half of this time
	var/adjust_delay = 1 SECONDS

/obj/item/attachable/vulture_scope/Initialize(mapload, ...)
	. = ..()
	START_PROCESSING(SSobj, src)
	select_gamemode_skin(type)

/obj/item/attachable/vulture_scope/Destroy()
	STOP_PROCESSING(SSobj, src)
	on_unscope()
	QDEL_NULL(scope_element)
	return ..()

/obj/item/attachable/vulture_scope/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon

/obj/item/attachable/vulture_scope/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VultureScope", name)
		ui.open()

/obj/item/attachable/vulture_scope/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/obj/item/attachable/vulture_scope/ui_data(mob/user)
	var/list/data = list()
	data["offset_x"] = scope_offset_x
	data["offset_y"] = scope_offset_y
	data["valid_offset_dirs"] = get_offset_dirs()
	data["scope_cooldown"] = !COOLDOWN_FINISHED(src, scope_interact_cd)
	data["valid_adjust_dirs"] = get_adjust_dirs()
	data["breath_cooldown"] = !COOLDOWN_FINISHED(src, hold_breath_cd)
	data["breath_recharge"] = get_breath_recharge()
	data["spotter_spotting"] = spotter_spotting
	data["current_scope_drift"] = get_scope_drift_chance()
	data["time_to_fire_remaining"] = 1 - (get_time_to_fire() / FIRE_DELAY_TIER_VULTURE)
	return data

/obj/item/attachable/vulture_scope/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("adjust_dir")
			var/direction = params["offset_dir"]
			if(!(direction in GLOB.alldirs) || !scoping || !scope_user)
				return

			var/mob/scoper = scope_user.resolve()
			if(slow_use)
				if(!COOLDOWN_FINISHED(src, scope_interact_cd))
					return
				to_chat(scoper, SPAN_NOTICE("你开始调整[src]……"))
				COOLDOWN_START(src, scope_interact_cd, adjust_delay / 2)
				if(!do_after(scoper, 0.4 SECONDS))
					return

			adjust_offset(direction)
			. = TRUE

		if("adjust_position")
			var/direction = params["position_dir"]
			if(!(direction in GLOB.alldirs) || !scoping || !scope_user)
				return

			var/mob/scoper = scope_user.resolve()
			if(slow_use)
				if(!COOLDOWN_FINISHED(src, scope_interact_cd))
					return

				to_chat(scoper, SPAN_NOTICE("你开始移动[src]……"))
				COOLDOWN_START(src, scope_interact_cd, adjust_delay)
				if(!do_after(scoper, 0.8 SECONDS))
					return

			adjust_position(direction)
			. = TRUE

		if("hold_breath")
			if(!COOLDOWN_FINISHED(src, hold_breath_cd) || holding_breath)
				return

			hold_breath()
			. = TRUE

/obj/item/attachable/vulture_scope/process()
	if(scope_element && prob(get_scope_drift_chance())) //every 6 seconds when unspotted, on average
		scope_drift()

/// Returns a number between 0 and 100 for the chance of the scope drifting on process()
/obj/item/attachable/vulture_scope/proc/get_scope_drift_chance()
	if(!scope_drift || holding_breath)
		return 0

	if(spotter_spotting)
		return spotted_drift_chance

	else
		return unspotted_drift_chance

/// Returns how many deciseconds until the gun is able to fire again
/obj/item/attachable/vulture_scope/proc/get_time_to_fire()
	if(!istype(loc, /obj/item/weapon/gun/boltaction/vulture))
		return 0

	var/obj/item/weapon/gun/boltaction/vulture/rifle = loc
	if(!rifle.last_fired)
		return 0

	return (rifle.last_fired + rifle.get_fire_delay()) - world.time

/obj/item/attachable/vulture_scope/activate_attachment(obj/item/weapon/gun/gun, mob/living/carbon/user, turn_off)
	if(turn_off || scoping)
		on_unscope()
		return TRUE

	if(!scoping)
		if(!(gun.flags_item & WIELDED))
			to_chat(user, SPAN_WARNING("你必须双手握持[gun]才能使用[src]。"))
			return FALSE

		if(!HAS_TRAIT(gun, TRAIT_GUN_BIPODDED))
			to_chat(user, SPAN_WARNING("必须先架好两脚架，才能使用[src]。"))
			return FALSE

		on_scope()
	return TRUE

/obj/item/attachable/vulture_scope/proc/get_offset_dirs()
	var/list/possible_dirs = GLOB.alldirs.Copy()
	if(scope_offset_x >= scope_drift_max)
		possible_dirs -= list(NORTHEAST, EAST, SOUTHEAST)
	else if(scope_offset_x <= -scope_drift_max)
		possible_dirs -= list(NORTHWEST, WEST, SOUTHWEST)

	if(scope_offset_y >= scope_drift_max)
		possible_dirs -= list(NORTHWEST, NORTH, NORTHEAST)
	else if(scope_offset_y <= -scope_drift_max)
		possible_dirs -= list(SOUTHWEST, SOUTH, SOUTHEAST)

	return possible_dirs

/// Gets a list of valid directions to be able to adjust the reticle in
/obj/item/attachable/vulture_scope/proc/get_adjust_dirs()
	if(!scoping)
		return list()
	var/list/possible_dirs = GLOB.alldirs.Copy()
	var/turf/current_turf = get_turf(src)
	var/turf/scope_tile = locate(scope_x, scope_y, current_turf.z)
	var/mob/scoper = scope_user.resolve()
	if(!scoper)
		return list()

	var/user_dir = scoper.dir
	var/distance = get_dist(current_turf, scope_tile)
	if(distance >= max_scope_range)
		possible_dirs -= get_related_directions(user_dir)

	else if(distance <= min_scope_range)
		possible_dirs -= get_related_directions(REVERSE_DIR(user_dir))

	if((user_dir == EAST) || (user_dir == WEST))
		if(scope_y - current_turf.y >= perpendicular_scope_range)
			possible_dirs -= get_related_directions(NORTH)

		else if(current_turf.y - scope_y >= perpendicular_scope_range)
			possible_dirs -= get_related_directions(SOUTH)

	else
		if(scope_x - current_turf.x >= perpendicular_scope_range)
			possible_dirs -= get_related_directions(EAST)

		else if(current_turf.x - scope_x >= perpendicular_scope_range)
			possible_dirs -= get_related_directions(WEST)

	return possible_dirs

/// Adjusts the position of the reticle by a tile in a given direction
/obj/item/attachable/vulture_scope/proc/adjust_offset(direction = NORTH)
	var/old_x = scope_offset_x
	var/old_y = scope_offset_y
	if((direction == NORTHEAST) || (direction == EAST) || (direction == SOUTHEAST))
		scope_offset_x = min(scope_offset_x + 1, scope_drift_max)
	else if((direction == NORTHWEST) || (direction == WEST) || (direction == SOUTHWEST))
		scope_offset_x = max(scope_offset_x - 1, -scope_drift_max)

	if((direction == NORTHWEST) || (direction == NORTH) || (direction == NORTHEAST))
		scope_offset_y = min(scope_offset_y + 1, scope_drift_max)
	else if((direction == SOUTHWEST) || (direction == SOUTH) || (direction == SOUTHEAST))
		scope_offset_y = max(scope_offset_y - 1, -scope_drift_max)

	recalculate_scope_offset(old_x, old_y)

/// Adjusts the position of the scope by a tile in a given direction
/obj/item/attachable/vulture_scope/proc/adjust_position(direction = NORTH)
	var/perpendicular_axis = "x"
	var/mob/user = scope_user.resolve()
	var/turf/user_turf = get_turf(user)
	if((user.dir == EAST) || (user.dir == WEST))
		perpendicular_axis = "y"

	if((direction == NORTHEAST) || (direction == EAST) || (direction == SOUTHEAST))
		scope_x++
		scope_x = user_turf.x + axis_math(user, perpendicular_axis, "x", direction)
	else if((direction == NORTHWEST) || (direction == WEST) || (direction == SOUTHWEST))
		scope_x--
		scope_x = user_turf.x + axis_math(user, perpendicular_axis, "x", direction)
	if((direction == NORTHWEST) || (direction == NORTH) || (direction == NORTHEAST))
		scope_y++
		scope_y = user_turf.y + axis_math(user, perpendicular_axis, "y", direction)
	else if((direction == SOUTHWEST) || (direction == SOUTH) || (direction == SOUTHEAST))
		scope_y--
		scope_y = user_turf.y + axis_math(user, perpendicular_axis, "y", direction)

	SEND_SIGNAL(src, COMSIG_VULTURE_SCOPE_MOVED)

	recalculate_scope_pos()

/// Figures out which direction the scope should move based on user direction and their input
/obj/item/attachable/vulture_scope/proc/axis_math(mob/user, perpendicular_axis = "x", modifying_axis = "x", direction = NORTH)
	var/turf/user_turf = get_turf(user)
	var/inverse = FALSE
	if((user.dir == SOUTH) || (user.dir == WEST))
		inverse = TRUE
	var/user_offset
	if(modifying_axis == "x")
		user_offset = scope_x - user_turf.x

	else
		user_offset = scope_y - user_turf.y

	if(perpendicular_axis == modifying_axis)
		return clamp(user_offset, -perpendicular_scope_range, perpendicular_scope_range)

	else
		return clamp(abs(user_offset), min_scope_range, max_scope_range) * (inverse ? -1 : 1)

/// Recalculates where the reticle should be inside the scope
/obj/item/attachable/vulture_scope/proc/recalculate_scope_offset(old_x = 0, old_y = 0)
	var/mob/scoper = scope_user.resolve()
	if(!scoper.client)
		return

	var/x_to_set = (scope_offset_x >= 0 ? "+" : "") + "[scope_offset_x]"
	var/y_to_set = (scope_offset_y >= 0 ? "+" : "") + "[scope_offset_y]"
	scope_element.screen_loc = "CENTER[x_to_set],CENTER[y_to_set]"

/// Recalculates where the scope should be in relation to the user
/obj/item/attachable/vulture_scope/proc/recalculate_scope_pos()
	if(!scope_user)
		return
	var/turf/current_turf = get_turf(src)
	var/x_off = scope_x - current_turf.x
	var/y_off = scope_y - current_turf.y
	var/pixels_per_tile = 32
	var/mob/scoper = scope_user.resolve()
	if(!scoper.client)
		return

	if(scoping)
		scoper.client.pixel_x = x_off * pixels_per_tile
		scoper.client.pixel_y = y_off * pixels_per_tile
	else
		scoper.client.pixel_x = 0
		scoper.client.pixel_y = 0

/// Handler for when the user begins scoping
/obj/item/attachable/vulture_scope/proc/on_scope()
	var/turf/gun_turf = get_turf(src)
	scope_x = gun_turf.x
	scope_y = gun_turf.y
	scope_offset_x = 0
	scope_offset_y = 0
	holding_breath = FALSE

	if(!isgun(loc))
		return

	var/obj/item/weapon/gun/gun = loc
	var/mob/living/gun_user = gun.get_gun_user()
	if(!gun_user)
		return

	switch(gun_user.dir)
		if(NORTH)
			scope_y += start_scope_range
		if(EAST)
			scope_x += start_scope_range
		if(SOUTH)
			scope_y -= start_scope_range
		if(WEST)
			scope_x -= start_scope_range

	scope_user = WEAKREF(gun_user)
	scope_user_initial_dir = gun_user.dir
	scoping = TRUE
	recalculate_scope_pos()
	gun_user.overlay_fullscreen("vulture", /atom/movable/screen/fullscreen/vulture)
	scope_element = new(src)
	gun_user.client.add_to_screen(scope_element)
	gun_user.see_in_dark += darkness_view
	gun_user.lighting_alpha = 127
	gun_user.sync_lighting_plane_alpha()
	RegisterSignal(gun, list(
		COMSIG_ITEM_DROPPED,
		COMSIG_ITEM_UNWIELD,
	), PROC_REF(on_unscope))
	RegisterSignal(gun_user, COMSIG_MOB_UNDEPLOYED_BIPOD, PROC_REF(on_unscope))
	RegisterSignal(gun_user, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(on_mob_move_look))
	RegisterSignal(gun_user.client, COMSIG_PARENT_QDELETING, PROC_REF(on_unscope))

/// Handler for when the scope is deleted, dropped, etc.
/obj/item/attachable/vulture_scope/proc/on_unscope()
	SIGNAL_HANDLER
	if(!scope_user)
		return

	var/mob/scoper = scope_user.resolve()
	if(isgun(loc))
		UnregisterSignal(loc, list(
			COMSIG_ITEM_DROPPED,
			COMSIG_ITEM_UNWIELD,
		))
	UnregisterSignal(scoper, list(COMSIG_MOB_UNDEPLOYED_BIPOD, COMSIG_MOB_MOVE_OR_LOOK))
	UnregisterSignal(scoper.client, COMSIG_PARENT_QDELETING)
	stop_holding_breath()
	scope_user_initial_dir = null
	scoper.clear_fullscreen("vulture")
	scoper.client.remove_from_screen(scope_element)
	scoper.see_in_dark -= darkness_view
	scoper.lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	scoper.sync_lighting_plane_alpha()
	QDEL_NULL(scope_element)
	recalculate_scope_pos()
	scope_user = null
	scoping = FALSE
	if(scoper.client)
		scoper.client.pixel_x = 0
		scoper.client.pixel_y = 0

/// Handler for if the mob moves or changes look direction
/obj/item/attachable/vulture_scope/proc/on_mob_move_look(mob/living/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(actually_moving || (mover.dir != scope_user_initial_dir))
		on_unscope()

/// Causes the scope to drift in a random direction by 1 tile
/obj/item/attachable/vulture_scope/proc/scope_drift(forced_dir)
	var/dir_picked
	if(!forced_dir)
		dir_picked = pick(get_offset_dirs())
	else
		dir_picked = forced_dir

	adjust_offset(dir_picked)

/// Returns the turf that the sniper scope + reticle is currently focused on
/obj/item/attachable/vulture_scope/proc/get_viewed_turf()
	RETURN_TYPE(/turf)
	if(!scoping)
		return null
	var/turf/gun_turf = get_turf(src)
	return locate(scope_x + scope_offset_x, scope_y + scope_offset_y, gun_turf.z)

/// Lets the user start holding their breath, stopping gun sway for a short time
/obj/item/attachable/vulture_scope/proc/hold_breath()
	if(!scope_user)
		return

	var/mob/scoper = scope_user.resolve()
	to_chat(scoper, SPAN_NOTICE("你屏住呼吸，稳住了瞄准镜……"))
	holding_breath = TRUE
	INVOKE_ASYNC(src, PROC_REF(tick_down_breath_scope))
	addtimer(CALLBACK(src, PROC_REF(stop_holding_breath)), breath_time)

/// Slowly empties out the crosshair as the user's breath runs out
/obj/item/attachable/vulture_scope/proc/tick_down_breath_scope()
	scope_element.icon_state = "vulture_steady_4"
	sleep(breath_time * 0.25)
	scope_element.icon_state = "vulture_steady_3"
	sleep(breath_time * 0.25)
	scope_element.icon_state = "vulture_steady_2"
	sleep(breath_time * 0.25)
	scope_element.icon_state = "vulture_steady_1"

/// Stops the user from holding their breath, starting the cooldown
/obj/item/attachable/vulture_scope/proc/stop_holding_breath()
	if(!scope_user || !holding_breath)
		return

	var/mob/scoper = scope_user.resolve()
	to_chat(scoper, SPAN_NOTICE("你呼出气息，瞄准镜又开始晃动。"))
	holding_breath = FALSE
	scope_element.icon_state = "vulture_unsteady"
	COOLDOWN_START(src, hold_breath_cd, breath_cooldown_time)

/// Returns a % of how much time until the user can still their breath again
/obj/item/attachable/vulture_scope/proc/get_breath_recharge()
	return 1 - (COOLDOWN_TIMELEFT(src, hold_breath_cd) / breath_cooldown_time)

/datum/action/item_action/vulture

/datum/action/item_action/vulture/action_activate()
	. = ..()
	var/obj/item/weapon/gun/gun_holder = holder_item
	var/obj/item/attachable/vulture_scope/scope = gun_holder.attachments["rail"]
	if(!istype(scope))
		return
	scope.tgui_interact(owner)

// ======== Stock attachments ======== //


/obj/item/attachable/stock //Generic stock parent and related things.
	name = "default stock"
	desc = "If you can read this, someone screwed up. Go Gitlab this and bug a coder."
	icon_state = "stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_VERY_FAST
	melee_mod = 5
	size_mod = 2
	pixel_shift_x = 30
	pixel_shift_y = 14

	var/collapsible = FALSE
	var/stock_activated = TRUE
	var/collapse_delay  = 0
	var/list/deploy_message = list("收起", "展开")

/obj/item/attachable/stock/proc/apply_on_weapon(obj/item/weapon/gun/gun)
	return TRUE

/obj/item/attachable/stock/activate_attachment(obj/item/weapon/gun/gun, mob/living/carbon/user, turn_off)
	. = ..()

	if(!collapsible)
		return .

	if(turn_off && stock_activated)
		stock_activated = FALSE
		apply_on_weapon(gun)
		return TRUE

	if(!user)
		return TRUE

	if(gun.flags_item & WIELDED)
		to_chat(user, SPAN_NOTICE("你需要空出一只手才能调整[src]。"))
		return TRUE

	if(!do_after(user, collapse_delay, INTERRUPT_INCAPACITATED|INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC, gun, INTERRUPT_DIFF_LOC))
		return FALSE

	stock_activated = !stock_activated
	apply_on_weapon(gun)
	playsound(user, activation_sound, 15, 1)
	var/message = deploy_message[1 + stock_activated]
	to_chat(user, SPAN_NOTICE("你[message]了[src]。"))

	for(var/X in gun.actions)
		var/datum/action/A = X
		if(istype(A, /datum/action/item_action/toggle))
			A.update_button_icon()

/obj/item/attachable/stock
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'

/obj/item/attachable/stock/shotgun
	name = "伊萨卡 37 木制枪托"
	desc = "伊萨卡泵动霰弹枪的标准木制枪托。比制式短柄更笨重，但可降低后坐力并提高精度。据说打架时也是根不错的棍子。"
	slot = "stock"
	icon_state = "stock"
	wield_delay_mod = WIELD_DELAY_FAST
	pixel_shift_x = 32
	pixel_shift_y = 15
	hud_offset_mod = 6 //*Very* long sprite.

/obj/item/attachable/stock/shotgun/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10
	//but at the same time you are slow when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_med)

	select_gamemode_skin(type)

/obj/item/attachable/stock/double
	name = "双管霰弹枪枪托"
	desc = "一块厚实的木料，外面裹着清漆与岁月的痕迹。"
	slot = "stock"
	icon_state = "db_stock"
	wield_delay_mod = WIELD_DELAY_NONE//part of the gun's base stats
	flags_attach_features = NO_FLAGS
	pixel_shift_x = 32
	pixel_shift_y = 15
	hud_offset_mod = 2

/obj/item/attachable/stock/double/New()
	..()

/obj/item/attachable/stock/mou53
	name = "MOU53 战术枪托"
	desc = "专为 MOU53 中折式霰弹枪设计的金属枪托。"
	icon_state = "ou_stock"
	hud_offset_mod = 5

/obj/item/attachable/stock/mou53/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/r4t
	name = "R4T 侦察枪托"
	desc = "为R4T杠杆式步枪设计的木制枪托，可承受恶劣环境。能提高武器稳定性，但实在有些碍事。"
	icon_state = "r4t-stock"
	wield_delay_mod = WIELD_DELAY_SLOW
	hud_offset_mod = 6

/obj/item/attachable/stock/r4t/New()
	..()
	select_gamemode_skin(type)
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_4

/obj/item/attachable/stock/xm88
	name = "XM88 缓冲枪托"
	desc = "XM88 反器材步枪用聚合物框架、合金加强枪托，有助于控制后坐力。"
	icon_state = "boomslang-stock"
	wield_delay_mod = WIELD_DELAY_NORMAL
	hud_offset_mod = 6

/obj/item/attachable/stock/xm88/New()
	..()
	select_gamemode_skin(type)
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_4

/obj/item/attachable/stock/vulture
	name = "M707 重型枪托"
	icon_state = "vulture_stock"
	attach_icon = "vulture_stock"
	hud_offset_mod = 3

/obj/item/attachable/stock/vulture/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(type)
	// Doesn't give any stat additions due to the gun already having really good ones, and this is unremovable from the gun itself

/obj/item/attachable/stock/vulture/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon

/obj/item/attachable/stock/tactical
	name = "M120 战术枪托"
	desc = "专为M120战术霰弹枪制作的金属枪托。"
	icon_state = "tactical_stock"
	hud_offset_mod = 6

/obj/item/attachable/stock/tactical/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/type23
	name = "23式标准枪托"
	desc = "冲压金属枪托，内置缓冲弹簧，用来吸收8号口径霰弹枪开火时夸张的后坐力。不建议拆卸。"
	icon_state = "type23_stock"
	pixel_shift_x = 15
	pixel_shift_y = 15
	hud_offset_mod = 2

/obj/item/attachable/stock/type23/New()
	..()
	//2h
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//1h
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/type23/wood
	name = "KS-29 木制枪托"
	desc = "KS-29防暴霰弹枪的标准重型木制枪托。据说打架时也是根不错的棍子。"
	slot = "stock"
	icon_state = "type23_wood"
	wield_delay_mod = WIELD_DELAY_FAST
	pixel_shift_x = 32
	pixel_shift_y = 15
	hud_offset_mod = 6 //*Very* long sprite.
	flags_attach_features = NO_FLAGS

/obj/item/attachable/stock/type23/wood/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10
	//but at the same time you are slow when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_med)

	matter = list("wood" = 2000)

/obj/item/attachable/stock/slavic
	name = "木制枪托"
	desc = "供斯拉夫枪械使用的非制式重型木制枪托。"
	icon_state = "slavicstock"
	pixel_shift_x = 32
	pixel_shift_y = 13
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 0 //Already attached to base sprite.

/obj/item/attachable/stock/slavic/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	delay_mod = FIRE_DELAY_TIER_7
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/hunting
	name = "木制枪托"
	desc = "巴西拉-阿姆斯特朗步枪不可拆卸的枪托。"
	icon_state = "huntingstock"
	pixel_shift_x = 41
	pixel_shift_y = 10
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 6

/obj/item/attachable/stock/hunting/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_4
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8

/obj/item/attachable/stock/olympiets
	name = "奥林匹亚人“木制”枪托"
	desc = "Shouldn't be seeing this."
	icon_state = "olympiets_stock"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 6
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NONE

/obj/item/attachable/stock/hg3712
	name = "hg3712 枪托"
	desc = "HG 37-12泵动霰弹枪不可拆卸的枪托。"
	icon_state = "hg3712_stock"
	pixel_shift_x = 41
	pixel_shift_y = 10
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 6

/obj/item/attachable/stock/hg3712/New()
	..()

	//HG stock is purely aesthetics, any changes should be done to the gun itself
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NONE

/obj/item/attachable/stock/hg3712/m3717
	name = "hg3717 枪托"
	desc = "M37-17泵动霰弹枪不可拆卸的枪托。"
	icon_state = "hg3717_stock"

/obj/item/attachable/stock/rmcdmr
	name = "L64A3 枪托"
	desc = "L64A3精确射手步枪不可拆卸的枪托。"
	icon_state = "rmcdmr_stock"
	pixel_shift_x = 40
	pixel_shift_y = 10
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 6

/obj/item/attachable/stock/rmcdmr/New()
	..()

	//stock is purely aesthetics, any changes should be done to the gun itself
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NONE

/obj/item/attachable/stock/rifle
	name = "M41A 固定枪托"
	desc = "少量配发给 USCM 部队的稀有枪托。兼容 M41A，可降低后坐力、提高精度，但会影响操控性和灵活性。也能增强用枪托砸人的效果。"
	slot = "stock"
	melee_mod = 10
	size_mod = 1
	icon_state = "riflestock"
	attach_icon = "riflestock_a"
	pixel_shift_x = 40
	pixel_shift_y = 10
	wield_delay_mod = WIELD_DELAY_FAST
	hud_offset_mod = 3

/obj/item/attachable/stock/rifle/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_5
	recoil_mod = -RECOIL_AMOUNT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_7
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8
	//but at the same time you are slow when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_med)

/obj/item/attachable/stock/rifle/collapsible
	name = "M41A 伸缩枪托"
	desc = "M41A 制式聚合物伸缩枪托。展开后能减小散布、提高精度并降低后坐力，但会略微影响灵活性。"
	slot = "stock"
	melee_mod = 5
	size_mod = 1
	icon_state = "m41_folding"
	attach_icon = "m41_folding_a"
	pixel_shift_x = 40
	pixel_shift_y = 14
	hud_offset_mod = 3
	collapsible = TRUE
	stock_activated = FALSE
	wield_delay_mod = WIELD_DELAY_NONE //starts collapsed so no delay mod
	collapse_delay = 0.5 SECONDS
	flags_attach_features = ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle

/obj/item/attachable/stock/rifle/collapsible/New()
	..()

	//rifle stock starts collapsed so we zero out everything
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NONE

/obj/item/attachable/stock/rifle/collapsible/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		accuracy_mod = HIT_ACCURACY_MULT_TIER_2
		recoil_mod = -RECOIL_AMOUNT_TIER_5
		scatter_mod = -SCATTER_AMOUNT_TIER_9
		//it makes stuff slightly worse when one handed
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_1
		recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
		scatter_unwielded_mod = SCATTER_AMOUNT_TIER_7
		aim_speed_mod = CONFIG_GET(number/slowdown_med)
		hud_offset_mod = 5
		icon_state = "m41_folding_on"
		attach_icon = "m41_folding_a_on"
		wield_delay_mod = WIELD_DELAY_MIN //added 0.2 seconds for wield, basic solid stock adds 0.4

	else
		accuracy_mod = 0
		recoil_mod = 0
		scatter_mod = 0
		movement_onehanded_acc_penalty_mod = 0
		accuracy_unwielded_mod = 0
		recoil_unwielded_mod = 0
		scatter_unwielded_mod = 0
		aim_speed_mod = 0
		hud_offset_mod = 3
		icon_state = "m41_folding"
		attach_icon = "m41_folding_a"
		wield_delay_mod = WIELD_DELAY_NONE //stock is folded so no wield delay

	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")

/obj/item/attachable/stock/m20a
	name = "M20A 枪托"
	desc = "M20A的制式聚合物伸缩枪托。展开后能减小散布、提高精度并降低后坐力，但会略微影响灵活性。"
	slot = "stock"
	melee_mod = 5
	size_mod = 1
	icon_state = "m20astock"
	attach_icon = "m20astock_a"
	pixel_shift_x = 40
	pixel_shift_y = 14
	hud_offset_mod = 3

/obj/item/attachable/stock/m20a/New()
	..()

/obj/item/attachable/stock/rifle/ag80/collapsible
	name = "AG80 伸缩枪托"
	desc = "AG80的制式聚合物伸缩枪托。展开后能减小散布、提高精度并降低后坐力，但会略微影响灵活性。"
	slot = "stock"
	melee_mod = 5
	size_mod = 1
	icon_state = "ag80_folding"
	attach_icon = "ag80_folding_a"
	pixel_shift_x = 40
	pixel_shift_y = 14
	hud_offset_mod = 3
	collapsible = TRUE
	stock_activated = FALSE
	wield_delay_mod = WIELD_DELAY_NONE //starts collapsed so no delay mod
	collapse_delay = 0.5 SECONDS
	flags_attach_features = ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle

/obj/item/attachable/stock/rifle/ag80/collapsible/New()
	..()

	//rifle stock starts collapsed so we zero out everything
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NONE

/obj/item/attachable/stock/rifle/ag80/collapsible/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		accuracy_mod = HIT_ACCURACY_MULT_TIER_2
		recoil_mod = -RECOIL_AMOUNT_TIER_5
		scatter_mod = -SCATTER_AMOUNT_TIER_9
		//it makes stuff worse when one handed
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
		recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
		scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8
		aim_speed_mod = CONFIG_GET(number/slowdown_med)
		hud_offset_mod = 5
		icon_state = "ag80_folding_on"
		attach_icon = "ag80_folding_a_on"
		wield_delay_mod = WIELD_DELAY_VERY_FAST //added 0.2 seconds for wield, basic solid stock adds 0.4

	else
		accuracy_mod = 0
		recoil_mod = 0
		scatter_mod = 0
		movement_onehanded_acc_penalty_mod = 0
		accuracy_unwielded_mod = 0
		recoil_unwielded_mod = 0
		scatter_unwielded_mod = 0
		aim_speed_mod = 0
		hud_offset_mod = 3
		icon_state = "ag80_folding"
		attach_icon = "ag80_folding_a"
		wield_delay_mod = WIELD_DELAY_NONE //stock is folded so no wield delay

	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")

/obj/item/attachable/stock/m16
	name = "M16 撞火枪托"
	desc = "严格来说，在加利福尼亚州属于违禁品。"
	icon_state = "m16_stock"
	attach_icon = "m16_stock"
	wield_delay_mod = WIELD_DELAY_MIN
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 3

/obj/item/attachable/stock/m16/New()//no stats, its cosmetic
	..()

/obj/item/attachable/stock/m16/xm177
	name = "M16 伸缩枪托"
	desc = "在加利福尼亚州绝对属于违禁品。"
	icon_state = "m16_folding"
	attach_icon = "m16_folding"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 3
	collapsible = TRUE
	stock_activated = FALSE
	wield_delay_mod = WIELD_DELAY_NONE //starts collapsed so no delay mod
	collapse_delay = 0.5 SECONDS
	flags_attach_features = ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle

/obj/item/attachable/stock/m16/xm177/Initialize()
	.=..()
	accuracy_mod = 0
	recoil_mod = 0
	scatter_mod = 0
	movement_onehanded_acc_penalty_mod = 0
	accuracy_unwielded_mod = 0
	recoil_unwielded_mod = 0
	scatter_unwielded_mod = 0
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NONE

/obj/item/attachable/stock/m16/xm177/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		accuracy_mod = HIT_ACCURACY_MULT_TIER_2
		recoil_mod = -RECOIL_AMOUNT_TIER_5
		scatter_mod = -SCATTER_AMOUNT_TIER_9
		aim_speed_mod = CONFIG_GET(number/slowdown_med)
		hud_offset_mod = 5
		icon_state = "m16_folding"
		attach_icon = "m16_folding_on"
		wield_delay_mod = WIELD_DELAY_VERY_FAST

	else
		accuracy_mod = 0
		recoil_mod = 0
		scatter_mod = 0
		movement_onehanded_acc_penalty_mod = 0
		accuracy_unwielded_mod = 0
		recoil_unwielded_mod = 0
		scatter_unwielded_mod = 0
		aim_speed_mod = 0
		hud_offset_mod = 3
		icon_state = "m16_folding"
		attach_icon = "m16_folding"
		wield_delay_mod = WIELD_DELAY_NONE //stock is folded so no wield delay
	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")


/obj/item/attachable/stock/ar10
	name = "AR10 木制枪托"
	desc = "弹簧就在里面，别拆！"
	icon_state = "ar10_stock"
	attach_icon = "ar10_stock"
	wield_delay_mod = WIELD_DELAY_MIN
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 3

/obj/item/attachable/stock/ar10/New()//no stats, its cosmetic
	..()

/obj/item/attachable/stock/m79
	name = "M79 硬化聚合凯夫纶枪托"
	desc = "有助于缓解发射40mm榴弹时的后坐力，仅适用于M79。"
	icon_state = "m79_stock"
	icon_state = "m79_stock_a"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 2

/obj/item/attachable/stock/xm51
	name = "M1771 枪托"
	desc = "专为 M1771 霰弹枪设计的枪托，可帮助吸收后坐力并减小散布。"
	icon_state = "xm51_stock"
	attach_icon = "xm51_stock_a"
	wield_delay_mod = WIELD_DELAY_FAST
	hud_offset_mod = 3
	melee_mod = 10

/obj/item/attachable/stock/xm51/Initialize(mapload, ...)
	. = ..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	//but it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_5
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_6
	//and makes you slower
	aim_speed_mod = CONFIG_GET(number/slowdown_med)

/obj/item/attachable/stock/xm51/military
	name = "XM51 枪托"
	desc = "专为XM51霰弹枪设计的枪托，可帮助使用者吸收后坐力，并减小散布。"
	icon_state = "xm51_military_stock"
	attach_icon = "xm51_military_stock_a"

/obj/item/attachable/stock/vp70
	name = "VP70 点射枪托"
	desc = "Increases the fire rate and burst amount on the VP70. Some versions act as a holster for the weapon when un-attached. This is a test item and should not be used in normal gameplay (yet)."
	icon_state = "mod88_stock"
	attach_icon = "mod88_stock_a"
	wield_delay_mod = WIELD_DELAY_FAST
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 4
	size_mod = 2
	melee_mod = 5

/obj/item/attachable/stock/vp70/New()
	..()
	//2h
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	recoil_mod = -RECOIL_AMOUNT_TIER_2
	scatter_mod = -SCATTER_AMOUNT_TIER_7
	burst_scatter_mod = -1
	burst_mod = BURST_AMOUNT_TIER_2
	delay_mod = -FIRE_DELAY_TIER_11
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4
	//1h
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1
	recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_5
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_10

/obj/item/attachable/stock/carbine
	name = "L42 合成材料枪托"
	desc = "采用结实轻质材料制成的特供枪托，可安装在L42A战斗步枪上。不适合当钝器使用。"
	slot = "stock"
	size_mod = 1
	icon_state = "l42stock"
	attach_icon = "l42stock_a"
	pixel_shift_x = 37
	pixel_shift_y = 8
	wield_delay_mod = WIELD_DELAY_NORMAL
	hud_offset_mod = 2

/obj/item/attachable/stock/carbine/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_6
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8

/obj/item/attachable/stock/carbine/wood
	name = "ABR-40“木制”枪托"
	desc = "ABR-40猎枪的默认“木制”枪托，该枪是军用L42A战斗步枪的民用版本。理论上也兼容L42。等等，你刚把一把没有握把的枪的枪托拆下来了……？干得好，天才。"
	icon_state = "abr40stock"
	attach_icon = "abr40stock_a"
	melee_mod = 6
	wield_delay_mod = WIELD_DELAY_FAST

/obj/item/attachable/stock/carbine/wood/Initialize() // The gun is meant to be effectively unusable without the attachment.
	. = ..()
	accuracy_mod = (HIT_ACCURACY_MULT_TIER_6) + HIT_ACCURACY_MULT_TIER_10
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = (-SCATTER_AMOUNT_TIER_8) - SCATTER_AMOUNT_TIER_5

/obj/item/attachable/stock/carbine/wood/tactical
	name = "ABR-40 战术枪托"
	desc = "涂装精致的ABR-40枪托。等等，你刚把一把没有握把的枪的枪托拆下来了……？干得好，天才。"
	icon_state = "abr40stock_tac"
	attach_icon = "abr40stock_tac_a"

/obj/item/attachable/stock/rifle/marksman
	name = "M41A 精确射击枪托"
	icon_state = "m4markstock"
	attach_icon = "m4markstock"
	flags_attach_features = NO_FLAGS
	hud_offset_mod = 2

/obj/item/attachable/stock/twobore
	name = "重型木制枪托"
	icon_state = "twobore_stock"
	attach_icon = "twobore_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0
	pixel_shift_x = 24
	pixel_shift_y = 16
	hud_offset_mod = 10 //A sprite long enough to touch the Moon.

/obj/item/attachable/m49a_barrel
	name = "M49A 枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "m49a_barrel"
	attach_icon = "m49a_barrel"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/m49a_barrel/forecon
	name = "M49A2 枪管"
	icon_state = "m49a_barrel_a"
	attach_icon = "m49a_barrel_a"

/* /obj/item/attachable/m49a_barrel/New()
	..()
	select_gamemode_skin(type)

/obj/item/attachable/m49a_barrel/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon */

/obj/item/attachable/m49a_barrel_custom
	name = "定制M49A枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "m49a_custom_barrel"
	attach_icon = "m49a_custom_barrel"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0 //Integrated attachment for visuals, stats handled on main gun.
	size_mod = 0

/obj/item/attachable/m49a_barrel/pve
	name = "M49A6 枪口制退器"
	icon_state = "pve_m49a_barrel"
	attach_icon = "pve_m49a_barrel"

/obj/item/attachable/olympiets_barrel
	name = "奥林匹亚人枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon_state = "olympiets_barrel"
	attach_icon = "olympiets_barrel"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0

/obj/item/attachable/upp_rpg_breech
	name = "HJRA-12 后膛"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "hjra_breech"
	attach_icon = "hjra_breech"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0

/obj/item/attachable/pkpbarrel
	name = "QYJ-72 枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "uppmg_barrel"
	attach_icon = "uppmg_barrel"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0

/obj/item/attachable/stock/pkpstock
	name = "QYJ-72 枪托"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "uppmg_stock"
	attach_icon = "uppmg_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 20 //the thought of a upp spec beating people to death with a pk makes me laugh
	size_mod = 0

/obj/item/attachable/type88_barrel
	name = "88式枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "type88_barrel"
	attach_icon = "type88_barrel"
	slot = "special"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0

/obj/item/attachable/type73suppressor
	name = "73式一体消音器"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "type73_suppressor"
	attach_icon = "type73_suppressor"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0

/obj/item/attachable/stock/type71
	name = "71式枪托"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "type71_stock"
	attach_icon = "type71_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 15
	size_mod = 0

/obj/item/attachable/stock/type71/New()
	..()

/obj/item/attachable/stock/m60
	name = "M60 枪托"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "m60_stock"
	attach_icon = "m60_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 15
	size_mod = 0


/obj/item/attachable/stock/ppsh
	name = "PPSh-17b 枪托"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/stock.dmi'
	icon_state = "ppsh17b_stock"
	attach_icon = "ppsh17b_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 10
	size_mod = 0



/obj/item/attachable/stock/smg
	name = "冲锋枪枪托"
	desc = "少量配发给 USCM 部队的稀有阿玛特枪托。兼容 M39，可降低后坐力、提高精度，但会影响操控性和灵活性。似乎还能稍微增强近身搏斗能力。"
	slot = "stock"
	melee_mod = 15
	size_mod = 1
	icon_state = "smgstock"
	attach_icon = "smgstock_a"
	pixel_shift_x = 42
	pixel_shift_y = 11
	wield_delay_mod = WIELD_DELAY_FAST
	hud_offset_mod = 5

/obj/item/attachable/stock/smg/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_7
	recoil_mod = -RECOIL_AMOUNT_TIER_3
	scatter_mod = -SCATTER_AMOUNT_TIER_6
	delay_mod = 0
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	aim_speed_mod = CONFIG_GET(number/slowdown_low)


/obj/item/attachable/stock/smg/collapsible
	name = "冲锋枪折叠枪托"
	desc = "基尔希纳牌 K2 M39 折叠枪托，USCM 制式装备。展开后可降低后坐力、提高精度，但会影响操控性和灵活性，似乎还更适合近战。折叠后所有正面和负面效果都会消失。"
	slot = "stock"
	melee_mod = 10
	size_mod = 1
	icon_state = "smgstockc"
	attach_icon = "smgstockc_a"
	pixel_shift_x = 43
	pixel_shift_y = 11
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	hud_offset_mod = 5
	collapsible = TRUE


/obj/item/attachable/stock/smg/collapsible/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	wield_delay_mod = WIELD_DELAY_FAST
	delay_mod = 0
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10
	//but at the same time you are slowish when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_low)


/obj/item/attachable/stock/smg/collapsible/apply_on_weapon(obj/item/weapon/gun/gun)
	if(stock_activated)
		accuracy_mod = HIT_ACCURACY_MULT_TIER_3
		recoil_mod = -RECOIL_AMOUNT_TIER_4
		scatter_mod = -SCATTER_AMOUNT_TIER_8
		scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10
		size_mod = 1
		aim_speed_mod = CONFIG_GET(number/slowdown_low)
		wield_delay_mod = WIELD_DELAY_FAST
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
		accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
		recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
		hud_offset_mod = 5
		icon_state = "smgstockc"
		attach_icon = "smgstockc_a"

	else
		accuracy_mod = 0
		recoil_mod = 0
		scatter_mod = 0
		scatter_unwielded_mod = 0
		size_mod = 0
		aim_speed_mod = 0
		wield_delay_mod = 0
		movement_onehanded_acc_penalty_mod = 0
		accuracy_unwielded_mod = 0
		recoil_unwielded_mod = 0
		hud_offset_mod = 3
		icon_state = "smgstockcc"
		attach_icon = "smgstockcc_a"

	gun.recalculate_attachment_bonuses()
	gun.update_overlays(src, "stock")

/obj/item/attachable/stock/smg/collapsible/brace
	name = "冲锋枪臂托"
	desc = "M39 冲锋枪专用枪托。牺牲点射发数以提高单手射击精度。装上它后双手持枪，会明显恶化精度与后坐力。"
	size_mod = 1
	icon_state = "smg_brace"
	attach_icon = "smg_brace_a"
	pixel_shift_x = 43
	pixel_shift_y = 11
	collapse_delay = 2.5 SECONDS
	stock_activated = FALSE
	deploy_message = list("解锁","锁定")
	hud_offset_mod = 4

/obj/item/attachable/stock/smg/collapsible/brace/New()
	..()
	//Emulates two-handing an SMG.
	burst_mod = -BURST_AMOUNT_TIER_3 //2 shots instead of 5.

	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	scatter_mod = SCATTER_AMOUNT_TIER_8
	recoil_mod = RECOIL_AMOUNT_TIER_2
	aim_speed_mod = 0
	wield_delay_mod = WIELD_DELAY_NORMAL//you shouldn't be wielding it anyways

/obj/item/attachable/stock/smg/collapsible/brace/apply_on_weapon(obj/item/weapon/gun/G)
	if(stock_activated)
		G.flags_item |= NODROP|FORCEDROP_CONDITIONAL
		accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
		scatter_mod = SCATTER_AMOUNT_TIER_8
		recoil_mod = RECOIL_AMOUNT_TIER_2 //Hurts pretty bad if it's wielded.
		accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_4
		recoil_unwielded_mod = -RECOIL_AMOUNT_TIER_4
		movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_4 //Does well if it isn't.
		hud_offset_mod = 5
		icon_state = "smg_brace_on"
		attach_icon = "smg_brace_a_on"
	else
		G.flags_item &= ~(NODROP|FORCEDROP_CONDITIONAL)
		accuracy_mod = 0
		scatter_mod = 0
		recoil_mod = 0
		accuracy_unwielded_mod = 0
		recoil_unwielded_mod = 0
		movement_onehanded_acc_penalty_mod = 0 //Does pretty much nothing if it's not activated.
		hud_offset_mod = 4
		icon_state = "smg_brace"
		attach_icon = "smg_brace_a"

	G.recalculate_attachment_bonuses()
	G.update_overlays(src, "stock")

/obj/item/attachable/stock/revolver
	name = "M44 马格南精确射击枪托"
	desc = "为 .44 马格南改装的木制枪托。以操控性和灵活性为代价提高精度、降低后坐力，也会降低近战效果。"
	slot = "stock"
	melee_mod = -5
	size_mod = 1
	icon_state = "44stock"
	pixel_shift_x = 35
	pixel_shift_y = 19
	wield_delay_mod = WIELD_DELAY_FAST
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	hud_offset_mod = 7 //Extremely long.
	var/folded = FALSE
	var/list/allowed_hat_items = list(
					/obj/item/ammo_magazine/revolver,
					/obj/item/ammo_magazine/revolver/marksman,
					/obj/item/ammo_magazine/revolver/heavy)

/obj/item/attachable/stock/revolver/New()
	..()
	//it makes stuff much better when two-handed
	accuracy_mod = HIT_ACCURACY_MULT_TIER_7
	recoil_mod = -RECOIL_AMOUNT_TIER_4
	scatter_mod = -SCATTER_AMOUNT_TIER_8
	//it makes stuff much worse when one handed
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	recoil_unwielded_mod = RECOIL_AMOUNT_TIER_4
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_8
	//but at the same time you are slow when 2 handed
	aim_speed_mod = CONFIG_GET(number/slowdown_med)


/obj/item/attachable/stock/revolver/activate_attachment(obj/item/weapon/gun/G, mob/living/carbon/user, turn_off)
	var/obj/item/weapon/gun/revolver/m44/R = G
	if(!istype(R))
		return 0

	if(!user)
		return 1

	if(user.action_busy)
		return

	if(R.flags_item & WIELDED)
		if(folded)
			to_chat(user, SPAN_NOTICE("你需要空出一只手才能展开[src]。"))
		else
			to_chat(user, SPAN_NOTICE("你需要空出一只手才能折叠[src]。"))
		return 0

	if(!do_after(user, 15, INTERRUPT_INCAPACITATED|INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC, G, INTERRUPT_DIFF_LOC))
		return

	playsound(user, activation_sound, 15, 1)

	if(folded)
		to_chat(user, SPAN_NOTICE("你展开了[src]。"))
		R.flags_equip_slot &= ~SLOT_WAIST
		R.folded = FALSE
		icon_state = "44stock"
		size_mod = 1
		hud_offset_mod = 7
		G.recalculate_attachment_bonuses()
	else
		to_chat(user, SPAN_NOTICE("你折叠起了[src]。"))
		R.flags_equip_slot |= SLOT_WAIST // Allow to be worn on the belt when folded
		R.folded = TRUE // We can't shoot anymore, its folded
		icon_state = "44stock_folded"
		size_mod = 0
		hud_offset_mod = 4
		G.recalculate_attachment_bonuses()
	folded = !folded
	G.update_overlays(src, "stock")

// If it is activated/folded when we attach it, re-apply the things
/obj/item/attachable/stock/revolver/Attach(obj/item/weapon/gun/G)
	..()
	var/obj/item/weapon/gun/revolver/m44/R = G
	if(!istype(R))
		return 0

	if(folded)
		R.flags_equip_slot |= SLOT_WAIST
		R.folded = TRUE
	else
		R.flags_equip_slot &= ~SLOT_WAIST //Can't wear it on the belt slot with stock on when we attach it first time.

// When taking it off we want to undo everything not statwise
/obj/item/attachable/stock/revolver/Detach(mob/user, obj/item/weapon/gun/detaching_gub, drop_attachment = TRUE)
	..()
	var/obj/item/weapon/gun/revolver/m44/R = detaching_gub
	if(!istype(R))
		return 0

	if(folded)
		R.folded = FALSE
	else
		R.flags_equip_slot |= SLOT_WAIST

/obj/item/attachable/stock/nsg23
	name = "NSG 23 枪托"
	desc = "If you can read this, someone screwed up. Go Github this and bug a coder."
	icon_state = "nsg23_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	melee_mod = 5
	size_mod = 2
	pixel_shift_x = 21
	pixel_shift_y = 20
	hud_offset_mod = 2

/obj/item/attachable/stock/nsg23/rmc
	name = "NSG L23A1 枪托"
	desc = "If you can read this, someone screwed up. Go Github this and bug a coder."
	icon_state = "rmc_nsg23_stock"

/obj/item/attachable/stock/isr
	name = "ISR 枪托"
	desc = "If you can read this, someone screwed up. Go Github this and bug a coder."
	icon_state = "isr_stock"
	slot = "stock"
	wield_delay_mod = WIELD_DELAY_NONE
	melee_mod = 5
	size_mod = 2
	pixel_shift_x = 21
	pixel_shift_y = 20
	hud_offset_mod = 2

// ======== Underbarrel Attachments ======== //


/obj/item/attachable/attached_gun
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	attachment_action_type = /datum/action/item_action/toggle
	// Some attachments may be fired. So here are the variables related to that.
	/// Ammo to fire the attachment with
	var/datum/ammo/ammo = null
	var/obj/projectile/in_chamber = null
	var/max_range = 0 //Determines # of tiles distance the attachable can fire, if it's not a projectile.
	var/last_fired //When the attachment was last fired.
	var/attachment_firing_delay = 0 //the delay between shots, for attachments that fires stuff
	var/fire_sound = null //Sound to play when firing it alternately
	var/gun_original_damage_mult = 1 //so you don't buff the underbarrell gun with charger for the wrong weapon
	var/gun_deactivate_sound = 'sound/weapons/handling/gun_underbarrel_deactivate.ogg'//allows us to give the attached gun unique activate and de-activate sounds. Not used yet.
	var/gun_activate_sound  = 'sound/weapons/handling/gun_underbarrel_activate.ogg'
	var/unload_sound = 'sound/weapons/gun_shotgun_shell_insert.ogg'

	/// An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	/// that will be given to the projectiles of the attached gun
	var/list/list/traits_to_give_attached
	/// Current target we're firing at
	var/mob/target

/obj/item/attachable/attached_gun/Initialize(mapload, ...) //Let's make sure if something needs an ammo type, it spawns with one.
	. = ..()
	if(ammo)
		ammo = GLOB.ammo_list[ammo]


/obj/item/attachable/attached_gun/Destroy()
	ammo = null
	target = null
	return ..()

/// setter for target
/obj/item/attachable/attached_gun/proc/set_target(atom/object)
	if(object == target)
		return
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = object
	if(target)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clean_target))

///Set the target to its turf, so we keep shooting even when it was qdeled
/obj/item/attachable/attached_gun/proc/clean_target()
	SIGNAL_HANDLER
	target = get_turf(target)

/obj/item/attachable/attached_gun/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	if(G.active_attachable == src)
		if(user)
			to_chat(user, SPAN_NOTICE("你不再使用[src]。"))
			playsound(user, gun_deactivate_sound, 30, 1)
		G.active_attachable = null
		var/diff = G.damage_mult - 1 //so that if we buffed gun in process, it still does stuff
		//yeah you can cheat by placing BC after switching to underbarrell, but that is one time and we can skip it for sake of optimization
		G.damage_mult = gun_original_damage_mult + diff
		icon_state = initial(icon_state)
	else if(!turn_off)
		if(user)
			to_chat(user, SPAN_NOTICE("你开始使用[src]。"))
			playsound(user, gun_activate_sound, 60, 1)
		G.active_attachable = src
		gun_original_damage_mult = G.damage_mult
		G.damage_mult = 1
		icon_state += "-on"

	SEND_SIGNAL(G, COMSIG_GUN_INTERRUPT_FIRE)

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return 1



//The requirement for an attachable being alt fire is AMMO CAPACITY > 0.
/obj/item/attachable/attached_gun/grenade
	name = "下挂榴弹发射器"
	desc = "安装在武器上的可装填式榴弹发射器。"
	icon_state = "grenade"
	attach_icon = "grenade_a"
	w_class = SIZE_MEDIUM
	current_rounds = 0
	max_rounds = 3
	max_range = 11
	slot = "under"
	fire_sound = 'sound/weapons/gun_m92_attachable.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	var/caliber = "30mm"
	var/grenade_pass_flags
	var/list/loaded_grenades //list of grenade types loaded in the UGL
	var/breech_open = FALSE // is the UGL open for loading?
	var/cocked = TRUE // has the UGL been cocked via opening and closing the breech?
	var/open_sound = 'sound/weapons/handling/ugl_open.ogg'
	var/close_sound = 'sound/weapons/handling/ugl_close.ogg'
	var/has_breech = TRUE

/obj/item/attachable/attached_gun/grenade/Initialize()
	. = ..()
	grenade_pass_flags = PASS_HIGH_OVER|PASS_MOB_THRU|PASS_OVER

/obj/item/attachable/attached_gun/grenade/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_4 * 3
	loaded_grenades = list()

/obj/item/attachable/attached_gun/grenade/get_examine_text(mob/user)
	. = ..()
	if(current_rounds) . += "还剩[current_rounds]发榴弹。"
	else . += "已经空了。"

/obj/item/attachable/attached_gun/grenade/unique_action(mob/user)
	if(!has_breech)
		return
	if(!ishuman(usr))
		return
	if(user.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(user, SPAN_WARNING("现在不行。"))
		return

	var/obj/item/weapon/gun/G = user.get_held_item()
	if(!istype(G))
		G = user.get_inactive_hand()
	if(!istype(G) && G != null)
		G = user.get_active_hand()
	if(!G)
		to_chat(user, SPAN_WARNING("你必须拿着[src]才能这样做。"))
		return

	pump(user)

/obj/item/attachable/attached_gun/grenade/update_icon()
	. = ..()
	attach_icon = initial(attach_icon)
	icon_state = initial(icon_state)
	if(breech_open)
		attach_icon += "-open"
		icon_state += "-open"
	if(istype(loc, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/gun = loc
		gun.update_attachable(slot)

/obj/item/attachable/attached_gun/grenade/proc/pump(mob/user) //for want of a better proc name
	if(breech_open) // if it was ALREADY open
		breech_open = FALSE
		cocked = TRUE // by closing the gun we have cocked it and readied it to fire
		to_chat(user, SPAN_NOTICE("你合上了[src]的后膛，将其上膛待击！"))
		playsound(src, close_sound, 15, 1)
	else
		breech_open = TRUE
		cocked = FALSE
		to_chat(user, SPAN_NOTICE("你打开了[src]的后膛！"))
		playsound(src, open_sound, 15, 1)
	update_icon()

/obj/item/attachable/attached_gun/grenade/reload_attachment(obj/item/explosive/grenade/G, mob/user)
	if(has_breech && !breech_open)
		to_chat(user, SPAN_WARNING("必须打开[src]的后膛，才能装填榴弹！（使用独特动作）"))
		return
	if(!istype(G) || (G.caliber != caliber))
		to_chat(user, SPAN_WARNING("[src]无法装填这种榴弹。"))
		return
	if(!G.active) //can't load live grenades
		if(!G.underslug_launchable)
			to_chat(user, SPAN_WARNING("[src]无法装填这种榴弹。"))
			return
		if(current_rounds >= max_rounds)
			to_chat(user, SPAN_WARNING("[src]已经装满了。"))
		else
			playsound(user, 'sound/weapons/grenade_insert.wav', 25, 1)
			current_rounds++
			loaded_grenades += G
			to_chat(user, SPAN_NOTICE("你把[G]装进了[src]。"))
			user.drop_inv_item_to_loc(G, src)

/obj/item/attachable/attached_gun/grenade/unload_attachment(mob/user, reload_override = FALSE, drop_override = FALSE, loc_override = FALSE)
	. = TRUE //Always uses special unloading.
	if(has_breech && !breech_open)
		to_chat(user, SPAN_WARNING("[src]的后膛关着！必须先打开，才能取出榴弹！"))
		return
	if(!current_rounds)
		to_chat(user, SPAN_WARNING("已经空了！"))
		return

	var/obj/item/explosive/grenade/nade = loaded_grenades[length(loaded_grenades)] //Grab the last-inserted one. Or the only one, as the case may be.
	loaded_grenades.Remove(nade)
	current_rounds--

	if(drop_override || !user)
		nade.forceMove(get_turf(src))
	else
		user.put_in_hands(nade)

	user.visible_message(SPAN_NOTICE("[user]从[src]中卸下了[nade]。"),
	SPAN_NOTICE("你从[src]中卸下了[nade]。"), null, 4, CHAT_TYPE_COMBAT_ACTION)
	playsound(user, unload_sound, 30, 1)

/obj/item/attachable/attached_gun/grenade/fire_attachment(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	if(!(gun.flags_item & WIELDED))
		if(user)
			to_chat(user, SPAN_WARNING("你必须双手握持[gun]才能使用[src]。"))
		return
	if(has_breech && breech_open)
		if(user)
			to_chat(user, SPAN_WARNING("必须合上后膛，才能发射[src]！"))
			playsound(user, 'sound/weapons/gun_empty.ogg', 50, TRUE, 5)
		return
	if(has_breech && !cocked)
		if(user)
			to_chat(user, SPAN_WARNING("必须先将[src]上膛待击，才能开火！（打开再合上后膛）"))
			playsound(user, 'sound/weapons/gun_empty.ogg', 50, TRUE, 5)
		return
	if(get_dist(user,target) > max_range)
		to_chat(user, SPAN_WARNING("距离太远，无法使用下挂武器开火！"))
		playsound(user, 'sound/weapons/gun_empty.ogg', 50, TRUE, 5)
		return

	if(current_rounds > 0 && ..() || in_chamber && ..())
		prime_grenade(target,gun,user)

/obj/item/attachable/attached_gun/grenade/proc/prime_grenade(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	set waitfor = 0
	var/obj/item/explosive/grenade/G = loaded_grenades[1]

	if(G.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(G, user))
		to_chat(user, SPAN_WARNING("[name]的安全区事故防止装置阻止了开火！"))
		msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
		return

	if(G.dual_purpose != FALSE)
		G.fuse_type = IMPACT_FUSE
	G.arm_sound = null

	playsound(user.loc, fire_sound, 50, 1)
	msg_admin_attack("[key_name_admin(user)] fired an underslung grenade launcher [ADMIN_JMP_USER(user)]")
	log_game("[key_name_admin(user)] used an underslung grenade launcher.")


// canister nades explode immediately and don't leave the barrel of the weapon.
	if(istype(G, /obj/item/explosive/grenade/high_explosive/airburst/canister))
		var/obj/item/explosive/grenade/high_explosive/airburst/canister/canister_round = G
		canister_round.canister_fire(user, target)
	else
		var/pass_flags = NO_FLAGS
		pass_flags |= grenade_pass_flags
		G.det_time = min(15, G.det_time)
		G.throw_range = max_range
		G.activate(user, FALSE)
		G.forceMove(get_turf(gun))
		G.throw_atom(target, max_range, SPEED_VERY_FAST, user, null, NORMAL_LAUNCH, pass_flags)
	current_rounds--
	cocked = FALSE // we have fired so uncock the gun
	loaded_grenades.Cut(1,2)

/obj/item/attachable/attached_gun/grenade/handle_attachment_description()
	var/base_attachment_desc
	switch(slot)
		if("rail")
			base_attachment_desc = "顶部装有[icon2html(src)] [name]。"
		if("side_rail")
			base_attachment_desc = "侧面装有[icon2html(src)] [name]。"
		if("muzzle")
			base_attachment_desc = "前端装有[icon2html(src)] [name]。"
		if("stock")
			base_attachment_desc = "装有[icon2html(src)] [name]作为枪托。"
		if("under")
			var/output = "下方装有[icon2html(src)] [name]"
			var/shorten = in_chamber?.name
			var/list/select_text = splittext(shorten, " ")
			if(length(select_text) > 1)
				shorten = select_text?[1] + " " + select_text?[2]
			if(flags_attach_features & ATTACH_WEAPON)
				output += "（[current_rounds]/[max_rounds]）[in_chamber ? "，膛内装有[shorten]。" : "。"]"
			base_attachment_desc = output
		else
			base_attachment_desc = "装有[icon2html(src)] [name]。"
	return handle_pre_break_attachment_description(base_attachment_desc) + "<br>"

//NSG L23 variant
/obj/item/attachable/attached_gun/grenade/nsg
	name = "L34 30mm 下挂榴弹发射器"
	desc = "三世界帝国制式泵动下挂榴弹发射器，适用于L23。管式弹仓容量两发，膛室可容纳一发。"

/obj/item/attachable/attached_gun/grenade/nsg/preloaded

/obj/item/attachable/attached_gun/grenade/nsg/preloaded/New()
	. = ..()
	current_rounds = 2
	loaded_grenades = list(new/obj/item/explosive/grenade/high_explosive/rmc(src), new/obj/item/explosive/grenade/high_explosive/rmc(src))

//For the Mk1
/obj/item/attachable/attached_gun/grenade/mk1
	name = "PN 30mm 下挂榴弹发射器"
	desc = "制式泵动下挂榴弹发射器，适用于M41A。管式弹仓容量四发，膛室可容纳一发。"
	icon_state = "grenade-mk1"
	attach_icon = "grenade-mk1_a"
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	current_rounds = 0
	max_rounds = 4
	max_range = 10
	attachment_firing_delay = 15

/obj/item/attachable/attached_gun/grenade/mk1/pump(mob/user) //for want of a better proc name
	if(breech_open) // if it was ALREADY open
		breech_open = FALSE
		if(current_rounds && !in_chamber)
			in_chamber = loaded_grenades[length(loaded_grenades)]
			current_rounds--
			loaded_grenades.Cut(length(loaded_grenades))
		to_chat(user, SPAN_NOTICE("你把[src]的护木推向前方，将其上膛待击！"))
		playsound(src, close_sound, 15, 1)
	else
		breech_open = TRUE
		if(in_chamber) //eject the chambered round
			var/obj/item/explosive/grenade/new_grenade = in_chamber
			in_chamber = null
			user.put_in_hands(new_grenade)
		to_chat(user, SPAN_NOTICE("你把[src]的护木拉了回来！"))
		playsound(src, open_sound, 15, 1)
	update_icon()

/obj/item/attachable/attached_gun/grenade/mk1/reload_attachment(obj/item/explosive/grenade/G, mob/user)
	if(!istype(G) || istype(G, /obj/item/explosive/grenade/spawnergrenade/))
		to_chat(user, SPAN_WARNING("[src]无法装填这种榴弹。"))
		return
	if(!G.active) //can't load live grenades
		if(!G.underslug_launchable)
			to_chat(user, SPAN_WARNING("[src]无法装填这种榴弹。"))
			return
		if(breech_open)
			if(!in_chamber)
				in_chamber = G
				to_chat(user, SPAN_NOTICE("你把[G]装进了[src]的膛室。"))
				playsound(user, 'sound/weapons/grenade_insert.wav', 25, 1)
				user.drop_inv_item_to_loc(G, src)
			else
				to_chat(user, SPAN_WARNING("[src]的装填口被挡住了，请把护木推向前方！（使用独特动作）"))
			return
		if(current_rounds >= max_rounds)
			to_chat(user, SPAN_WARNING("[src]已经装满了。"))
		else
			playsound(user, 'sound/weapons/grenade_insert.wav', 25, 1)
			current_rounds++
			loaded_grenades += G
			to_chat(user, SPAN_NOTICE("你把[G]装进了[src]。"))
			user.drop_inv_item_to_loc(G, src)

/obj/item/attachable/attached_gun/grenade/mk1/unload_attachment(mob/user, reload_override = FALSE, drop_override = FALSE, loc_override = FALSE)
	. = TRUE //Always uses special unloading.
	if(breech_open)
		to_chat(user, SPAN_WARNING("[src]的装填口被挡住了，请把护木推向前方！（使用独特动作）"))
		return
	if(!current_rounds)
		to_chat(user, SPAN_WARNING("已经空了！"))
		return

	var/obj/item/explosive/grenade/nade = loaded_grenades[length(loaded_grenades)] //Grab the last-inserted one. Or the only one, as the case may be.
	loaded_grenades.Remove(nade)
	current_rounds--

	if(drop_override || !user)
		nade.forceMove(get_turf(src))
	else
		user.put_in_hands(nade)

	user.visible_message(SPAN_NOTICE("[user]从[src]中卸下了[nade]。"),
	SPAN_NOTICE("你从[src]中卸下了[nade]。"), null, 4, CHAT_TYPE_COMBAT_ACTION)
	playsound(user, unload_sound, 30, 1)

/obj/item/attachable/attached_gun/grenade/mk1/prime_grenade(atom/target,obj/item/weapon/gun/gun,mob/living/user)
	set waitfor = 0
	if(!in_chamber)
		return
	var/obj/item/explosive/grenade/G = in_chamber
	in_chamber = null


	if(G.antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(G, user))
		to_chat(user, SPAN_WARNING("[name]的安全区事故防止装置阻止了开火！"))
		msg_admin_niche("[key_name(user)] attempted to prime \a [G.name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
		return

	if(G.dual_purpose != FALSE)
		G.fuse_type = IMPACT_FUSE
	G.arm_sound = null

	playsound(user.loc, fire_sound, 50, 1)
	msg_admin_attack("[key_name_admin(user)] fired an underslung grenade launcher [ADMIN_JMP_USER(user)]")
	log_game("[key_name_admin(user)] used an underslung grenade launcher.")

// canister nades explode immediately and don't leave the barrel of the weapon.
	if(istype(G, /obj/item/explosive/grenade/high_explosive/airburst/canister))
		var/obj/item/explosive/grenade/high_explosive/airburst/canister/canister_round = G
		canister_round.canister_fire(user, target)
	else
		var/pass_flags = NO_FLAGS
		pass_flags |= grenade_pass_flags
		G.det_time = min(15, G.det_time)
		G.throw_range = max_range
		G.activate(user, FALSE)
		G.forceMove(get_turf(gun))
		G.throw_atom(target, max_range, SPEED_VERY_FAST, user, null, NORMAL_LAUNCH, pass_flags)

/obj/item/attachable/attached_gun/grenade/mk1/preloaded

/obj/item/attachable/attached_gun/grenade/mk1/preloaded/New()
	. = ..()
	current_rounds = 1
	in_chamber = new/obj/item/explosive/grenade/high_explosive(src)
	loaded_grenades = list(new/obj/item/explosive/grenade/high_explosive(src))

/obj/item/attachable/attached_gun/grenade/mk1/preloaded/army

/obj/item/attachable/attached_gun/grenade/mk1/preloaded/army/New()
	. = ..()
	current_rounds = 3
	in_chamber = new/obj/item/explosive/grenade/high_explosive(src)
	loaded_grenades = list(new/obj/item/explosive/grenade/high_explosive(src), new/obj/item/explosive/grenade/high_explosive(src), new/obj/item/explosive/grenade/high_explosive(src))

/obj/item/attachable/attached_gun/grenade/mk1/recon
	icon_state = "green_grenade-mk1"
	attach_icon = "green_grenade-mk1_a" //the UBGLs on these are outdated, by the way

/obj/item/attachable/attached_gun/grenade/mk1/recon/preloaded

/obj/item/attachable/attached_gun/grenade/mk1/recon/preloaded/New()
	. = ..()
	current_rounds = 1
	in_chamber = new/obj/item/explosive/grenade/high_explosive(src)
	loaded_grenades = list(new/obj/item/explosive/grenade/high_explosive(src))

/obj/item/attachable/attached_gun/grenade/mk1/m120
	name = "PN/c 30mm 下挂榴弹发射器"
	desc = "PN泵动下挂榴弹发射器的紧凑型号，适用于M120霰弹枪。管式弹仓容量两发，膛室可容纳一发。"
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	max_rounds = 3

/obj/item/attachable/attached_gun/grenade/m203 //M16 GL, only DD have it.
	name = "M203 榴弹发射器"
	desc = "一件古董下挂榴弹发射器，1969年为M16配套列装，几个世纪前就已过时；你完全不明白它怎么会出现在这里。只能装填一发专用40mm榴弹，没有现代敌我识别系统，弹药不会穿过友军。"
	icon_state = "grenade-m203"
	attach_icon = "grenade-m203_a"
	caliber = "40x53mm"
	current_rounds = 0
	max_rounds = 1
	max_range = 14
	attachment_firing_delay = 5 //one shot, so if you can reload fast you can shoot fast

/obj/item/attachable/attached_gun/grenade/m203/Initialize()
	. = ..()
	grenade_pass_flags = NO_FLAGS

/obj/item/attachable/attached_gun/grenade/type71
	name = "83 式上挂式榴弹发射器"
	desc = "采用非传统设计的单发榴弹发射器，专供 71 式脉冲步枪使用。可快速接入步枪的电子击发机构，但接线容易故障。"
	icon_state = "type83"
	attach_icon = "type83_a"
	caliber = "40x103mm"
	current_rounds = 0
	max_rounds = 1
	max_range = 14
	attachment_firing_delay = 5
	pixel_shift_x = 20
	pixel_shift_y = 13
	has_breech = FALSE

/obj/item/attachable/attached_gun/grenade/type71/Initialize()
	. = ..()
	grenade_pass_flags = NO_FLAGS

/obj/item/attachable/attached_gun/grenade/type71/preloaded

/obj/item/attachable/attached_gun/grenade/type71/preloaded/New()
	. = ..()
	current_rounds = 1
	loaded_grenades = list(new/obj/item/explosive/grenade/high_explosive/impact/upp(src))

/obj/item/attachable/attached_gun/grenade/type71/ag80
	name = "GP-45 榴弹发射器"
	icon_state = "grenade-ag80"
	attach_icon = "grenade-ag80_a"
	has_breech = TRUE

/obj/item/attachable/attached_gun/grenade/type71/ag80/Initialize()
	. = ..()
	grenade_pass_flags = NO_FLAGS

/obj/item/attachable/attached_gun/grenade/type71/ag80/preloaded

/obj/item/attachable/attached_gun/grenade/type71/ag80/preloaded/New()
	. = ..()
	current_rounds = 1
	loaded_grenades = list(new/obj/item/explosive/grenade/high_explosive/impact/upp(src))

//"ammo/flamethrower" is a bullet, but the actual process is handled through fire_attachment, linked through Fire().
/obj/item/attachable/attached_gun/flamer
	name = "微型喷火器"
	icon_state = "flamethrower"
	attach_icon = "flamethrower_a"
	desc = "安装在武器上的可补充式喷火器配件。另有一种模式能喷出更猛烈的火焰，但射程明显缩短，耗油量大增。"
	w_class = SIZE_MEDIUM
	current_rounds = 40
	max_rounds = 40
	max_range = 5
	slot = "under"
	fire_sound = 'sound/weapons/gun_flamethrower3.ogg'
	gun_activate_sound = 'sound/weapons/handling/gun_underbarrel_flamer_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	var/burn_level = BURN_LEVEL_TIER_1
	var/burn_duration = BURN_TIME_TIER_1
	var/round_usage_per_tile = 1
	var/intense_mode = FALSE

/obj/item/attachable/attached_gun/flamer/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_4 * 5

/obj/item/attachable/attached_gun/flamer/get_examine_text(mob/user)
	. = ..()
	if(intense_mode)
		. += "当前使用的是更猛烈、不稳定的火焰。"
	else
		. += "当前使用的是普通、稳定的火焰。"
	if(current_rounds > 0)
		. += "还剩[current_rounds]单位燃料。"
	else
		. += "已经空了。"

/obj/item/attachable/attached_gun/flamer/unique_action(mob/user)
	..()
	playsound(user,'sound/weapons/handling/flamer_ignition.ogg', 25, 1)
	if(intense_mode)
		to_chat(user, SPAN_WARNING("你将[src]切回了普通、更稳定的火焰。"))
		round_usage_per_tile = 1
		burn_level = BURN_LEVEL_TIER_1
		burn_duration = BURN_TIME_TIER_1
		max_range = 5
		intense_mode = FALSE
	else
		to_chat(user, SPAN_WARNING("你将[src]切换为更猛烈、不稳定的火焰。"))
		round_usage_per_tile = 5
		burn_level = BURN_LEVEL_TIER_5
		burn_duration = BURN_TIME_TIER_2
		max_range = 2
		intense_mode = TRUE

/obj/item/attachable/attached_gun/flamer/handle_pre_break_attachment_description(base_description_text as text)
	return base_description_text + "当前处于[intense_mode ? "强焰" : "普通"]模式。"

/obj/item/attachable/attached_gun/flamer/reload_attachment(obj/item/ammo_magazine/flamer_tank/FT, mob/user)
	if(istype(FT))
		if(current_rounds >= max_rounds)
			to_chat(user, SPAN_WARNING("[src]已经装满了。"))
		else if(FT.current_rounds <= 0)
			to_chat(user, SPAN_WARNING("[FT]已经空了！"))
		else
			playsound(user, 'sound/effects/refill.ogg', 25, 1, 3)
			to_chat(user, SPAN_NOTICE("你用[FT]为[src]补充了燃料。"))
			var/transfered_rounds = min(max_rounds - current_rounds, FT.current_rounds)
			current_rounds += transfered_rounds
			FT.current_rounds -= transfered_rounds

			var/amount_of_reagents = length(FT.reagents.reagent_list)
			var/amount_removed_per_reagent = transfered_rounds / amount_of_reagents
			for(var/datum/reagent/R in FT.reagents.reagent_list)
				R.volume -= amount_removed_per_reagent
			FT.update_icon()
	else
		to_chat(user, SPAN_WARNING("[src]只能用喷火器燃料罐补充燃料。"))

/obj/item/attachable/attached_gun/flamer/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(get_dist(user,target) > max_range+4)
		to_chat(user, SPAN_WARNING("距离太远，无法使用下挂武器开火！"))
		return

	if(!istype(loc, /obj/item/weapon/gun))
		to_chat(user, SPAN_WARNING("[src]必须安装在枪械上！"))
		return

	var/obj/item/weapon/gun/attached_gun = loc

	if(!(attached_gun.flags_item & WIELDED))
		to_chat(user, SPAN_WARNING("你必须双手握持[attached_gun]才能使用[src]开火！"))
		return

	if(current_rounds > round_usage_per_tile && ..())
		unleash_flame(target, user)
		if(attached_gun.last_fired < world.time)
			attached_gun.last_fired = world.time

/obj/item/attachable/attached_gun/flamer/proc/unleash_flame(atom/target, mob/living/user)
	set waitfor = 0
	var/list/turf/turfs = get_line(user,target)
	var/distance = 0
	var/turf/prev_T
	var/stop_at_turf = FALSE
	playsound(user, 'sound/weapons/gun_flamethrower2.ogg', 50, 1)
	for(var/turf/T in turfs)
		if(T == user.loc)
			prev_T = T
			continue
		if(!current_rounds || current_rounds < round_usage_per_tile)
			break
		if(distance >= max_range)
			break

		current_rounds -= round_usage_per_tile
		var/datum/cause_data/cause_data = create_cause_data(initial(name), user)
		if(T.density)
			T.flamer_fire_act(0, cause_data)
			stop_at_turf = TRUE
		else if(prev_T)
			var/atom/movable/temp = new/obj/flamer_fire()
			var/atom/movable/AM = LinkBlocked(temp, prev_T, T)
			qdel(temp)
			if(AM)
				AM.flamer_fire_act(0, cause_data)
				if (AM.flags_atom & ON_BORDER)
					break
				stop_at_turf = TRUE
		flame_turf(T, user)
		if (stop_at_turf)
			break
		distance++
		prev_T = T
		sleep(1)


/obj/item/attachable/attached_gun/flamer/proc/flame_turf(turf/T, mob/living/user)
	if(!istype(T)) return

	if(!locate(/obj/flamer_fire) in T) // No stacking flames!
		var/datum/reagent/napalm/ut/R = new()

		R.intensityfire = burn_level
		R.durationfire = burn_duration

		new/obj/flamer_fire(T, create_cause_data(initial(name), user), R)

/obj/item/attachable/attached_gun/flamer/advanced
	name = "高级微型火焰喷射器"
	current_rounds = 50
	max_rounds = 50
	max_range = 6
	burn_level = BURN_LEVEL_TIER_5
	burn_duration = BURN_TIME_TIER_2

/obj/item/attachable/attached_gun/flamer/advanced/unique_action(mob/user)
	return	//No need for volatile mode, it already does high damage by default

/obj/item/attachable/attached_gun/flamer/advanced/integrated
	name = "一体式喷火器"

/obj/item/attachable/attached_gun/shotgun //basically, a masterkey
	name = "U7 下挂霰弹枪"
	icon_state = "masterkey"
	attach_icon = "masterkey_a"
	desc = "阿玛特U7战术霰弹枪，可安装在大多数武器的枪管下方，最多只能装填五发鹿弹。专用于突入建筑，短枪管会降低实际伤害。"
	w_class = SIZE_MEDIUM
	max_rounds = 5
	current_rounds = 5
	ammo = /datum/ammo/bullet/shotgun/buckshot/masterkey
	slot = "under"
	pixel_shift_y = 18
	fire_sound = 'sound/weapons/gun_shotgun_u7.ogg'
	gun_activate_sound = 'sound/weapons/handling/gun_u7_activate.ogg'
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_PROJECTILE|ATTACH_RELOADABLE|ATTACH_WEAPON

/obj/item/attachable/attached_gun/shotgun/New()
	..()
	attachment_firing_delay = FIRE_DELAY_TIER_5*3

/obj/item/attachable/attached_gun/shotgun/get_examine_text(mob/user)
	. = ..()
	if(current_rounds > 0) . += "还剩[current_rounds]发霰弹。"
	else . += "已经空了。"

/obj/item/attachable/attached_gun/shotgun/set_bullet_traits()
	LAZYADD(traits_to_give_attached, list(
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_turfs),
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 10.8, GLOB.damage_boost_breaching),
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_pylons)
	))

/obj/item/attachable/attached_gun/shotgun/reload_attachment(obj/item/ammo_magazine/handful/mag, mob/user)
	if(istype(mag) && mag.flags_magazine & AMMUNITION_HANDFUL)
		if(mag.default_ammo == /datum/ammo/bullet/shotgun/buckshot)
			if(current_rounds >= max_rounds)
				to_chat(user, SPAN_WARNING("[src]已经装满了。"))
			else
				current_rounds++
				mag.current_rounds--
				mag.update_icon()
				to_chat(user, SPAN_NOTICE("你向[src]中装入了一发霰弹。"))
				playsound(user, 'sound/weapons/gun_shotgun_shell_insert.ogg', 25, 1)
				if(mag.current_rounds <= 0)
					user.temp_drop_inv_item(mag)
					qdel(mag)
			return
	to_chat(user, SPAN_WARNING("[src]只能装填霰弹枪鹿弹。"))

/obj/item/attachable/attached_gun/shotgun/m20a/unloaded
	current_rounds = 0

/obj/item/attachable/attached_gun/shotgun/m20a
	name = "U3 下挂霰弹枪"
	desc = "阿玛特U3战术霰弹枪，集成于M20A“哈灵顿”步枪，最多只能装填五发鹿弹。"
	icon_state = "masterkey"
	attach_icon = "masterkey_a"
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_PROJECTILE|ATTACH_RELOADABLE|ATTACH_WEAPON
	hidden = TRUE


/obj/item/attachable/attached_gun/shotgun/m20a/set_bullet_traits()
	return

/obj/item/attachable/attached_gun/extinguisher
	name = "HME-12 下挂灭火器"
	icon_state = "extinguisher"
	attach_icon = "extinguisher_a"
	desc = "大丰科技 HME-12 下挂灭火器，由消防员使用的系统微缩而成。可安装在大多数武器下方，对准火焰即可灭火。"
	w_class = SIZE_MEDIUM
	slot = "under"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE
	var/obj/item/tool/extinguisher/internal_extinguisher
	current_rounds = 1 //This has to be done to pass the fire_attachment check.

/obj/item/attachable/attached_gun/extinguisher/get_examine_text(mob/user)
	. = ..()
	if(internal_extinguisher)
		. += SPAN_NOTICE("还剩[internal_extinguisher.reagents.total_volume]单位水！")
		return
	. += SPAN_WARNING("已经空了。")

/obj/item/attachable/attached_gun/extinguisher/handle_attachment_description(slot)
	return "下方装有[icon2html(src)] [name]（[internal_extinguisher.reagents.total_volume]/[internal_extinguisher.max_water]）。<br>"

/obj/item/attachable/attached_gun/extinguisher/New()
	..()
	initialize_internal_extinguisher()

/obj/item/attachable/attached_gun/extinguisher/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(!internal_extinguisher)
		return
	if(..())
		return internal_extinguisher.afterattack(target, user)

/obj/item/attachable/attached_gun/extinguisher/proc/initialize_internal_extinguisher()
	internal_extinguisher = new /obj/item/tool/extinguisher/mini/integrated_flamer()
	internal_extinguisher.safety = FALSE
	internal_extinguisher.create_reagents(internal_extinguisher.max_water)
	internal_extinguisher.reagents.add_reagent("water", internal_extinguisher.max_water)

/obj/item/attachable/attached_gun/extinguisher/pyro
	name = "HME-88B 下挂灭火器"
	desc = "大丰科技的实验型HME-88B下挂灭火器，集成于少数枪械型号，能扑灭最猛烈的火焰。按压前请先对准火焰。"
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE //not removable

/obj/item/attachable/attached_gun/extinguisher/pyro/initialize_internal_extinguisher()
	internal_extinguisher = new /obj/item/tool/extinguisher/pyro()
	internal_extinguisher.safety = FALSE
	internal_extinguisher.create_reagents(internal_extinguisher.max_water)
	internal_extinguisher.reagents.add_reagent("water", internal_extinguisher.max_water)

/obj/item/attachable/attached_gun/flamer_nozzle
	name = "XM-VESG-1 喷火器喷嘴"
	desc = "专为进攻用途改装喷火器的特殊喷嘴。内壁涂有特殊凝胶与树脂，会使流过的燃料硬化。喷出枪口的是一团燃烧凝胶，而非燃烧的石脑油流。"
	desc_lore = "这款供 M240A1 喷火器使用的实验性挥发放热球发生器外挂喷嘴，专为让陆战队员向敌军散兵坑和地堡发射火球而设计。尽管覆盖了凝胶和树脂，凝固汽油火球仍会在发射后被空气阻力撕散，因此陆战队员常在岸上休假时拿它当临时烟花发射器。"
	icon_state = "flamer_nozzle"
	attach_icon = "flamer_nozzle_a_1"
	w_class = SIZE_MEDIUM
	slot = "under"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_WEAPON|ATTACH_MELEE|ATTACH_IGNORE_EMPTY
	pixel_shift_x = 4
	pixel_shift_y = 14

	max_range = 6
	last_fired = 0
	attachment_firing_delay = 2 SECONDS

	var/projectile_type = /datum/ammo/flamethrower
	var/fuel_per_projectile = 3

	var/static/list/fire_sounds = list(
		'sound/weapons/gun_flamethrower1.ogg',
		'sound/weapons/gun_flamethrower2.ogg',
		'sound/weapons/gun_flamethrower3.ogg'
	)

/obj/item/attachable/attached_gun/flamer_nozzle/handle_attachment_description(slot)
	return "枪管下方装有[icon2html(src)] [name]。<br>"

/obj/item/attachable/attached_gun/flamer_nozzle/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	. = ..()
	attach_icon = "flamer_nozzle_a_[G.active_attachable == src ? 0 : 1]"
	G.update_icon()

/obj/item/attachable/attached_gun/flamer_nozzle/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	. = ..()

	if(world.time < gun.last_fired + gun.get_fire_delay())
		return

	if((gun.flags_gun_features & GUN_WIELDED_FIRING_ONLY) && !(gun.flags_item & WIELDED))
		to_chat(user, SPAN_WARNING("你必须双手握持[gun]才能使用[src]开火！"))
		return

	if(gun.flags_gun_features & GUN_TRIGGER_SAFETY)
		to_chat(user, SPAN_WARNING("[gun]还没点火！"))
		return

	if(!istype(gun.current_mag, /obj/item/ammo_magazine/flamer_tank))
		to_chat(user, SPAN_WARNING("[gun]需要先装上喷火器燃料罐！"))
		return

	if(!length(gun.current_mag.reagents.reagent_list))
		to_chat(user, SPAN_WARNING("[gun]的燃料不足，无法发射弹体！"))
		return

	var/datum/reagent/flamer_reagent = gun.current_mag.reagents.reagent_list[1]
	if(flamer_reagent.volume < FLAME_REAGENT_USE_AMOUNT * fuel_per_projectile)
		to_chat(user, SPAN_WARNING("[gun]的燃料不足，无法发射弹体！"))
		return

	if(istype(flamer_reagent, /datum/reagent/foaming_agent/stabilized))
		to_chat(user, SPAN_WARNING("这种化学物质会堵塞喷嘴！"))
		return

	if(istype(gun.current_mag, /obj/item/ammo_magazine/flamer_tank/smoke)) // you can't fire smoke like a projectile!
		to_chat(user, SPAN_WARNING("[src]无法配合这种燃料罐使用！"))
		return

	gun.last_fired = world.time
	gun.current_mag.reagents.remove_reagent(flamer_reagent.id, FLAME_REAGENT_USE_AMOUNT * fuel_per_projectile)

	var/obj/projectile/P = new(src, create_cause_data(initial(name), user, src))
	var/datum/ammo/flamethrower/ammo_datum = new projectile_type
	ammo_datum.flamer_reagent_id = flamer_reagent.id
	P.generate_bullet(ammo_datum)
	P.icon_state = "naptha_ball"
	P.color = flamer_reagent.burncolor
	P.hit_effect_color = flamer_reagent.burncolor
	P.fire_at(target, user, user, max_range, AMMO_SPEED_TIER_2, null)
	var/turf/user_turf = get_turf(user)
	playsound(user_turf, pick(fire_sounds), 50, TRUE)

	to_chat(user, SPAN_WARNING("仪表显示：剩余燃料<b>[floor(gun.current_mag.get_ammo_percent())]</b>%！"))

/obj/item/attachable/verticalgrip
	name = "垂直握把"
	desc = "可提高精度、降低后坐力与散布的垂直前握把，点射时效果尤其明显。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "verticalgrip"
	attach_icon = "verticalgrip_a"
	slot = "under"
	pixel_shift_x = 20

/obj/item/attachable/verticalgrip/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_3
	recoil_mod = -RECOIL_AMOUNT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	burst_scatter_mod = -2
	movement_onehanded_acc_penalty_mod = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_3
	scatter_unwielded_mod = SCATTER_AMOUNT_TIER_10

/obj/item/attachable/verticalgrip/upp
	name = "RK-5 垂直握把"
	desc = "安装在最佳位置的坚固握把，可提高快速射击时的稳定性。会增大武器体积、影响单手射击，但双手握持时能减小散布并提高精度。"

/obj/item/attachable/angledgrip
	name = "倾斜握把"
	desc = "改善武器人体工学的倾斜前握把，可加快举枪速度。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "angledgrip"
	attach_icon = "angledgrip_a"
	wield_delay_mod = -WIELD_DELAY_FAST
	slot = "under"
	pixel_shift_x = 20

/obj/item/attachable/angledgrip/upp
	name = "RK-9 倾斜握把"
	desc = "符合人体工学的握把，可缩短武器抵肩所需时间。会增大武器体积，并加快举枪速度。"

/obj/item/attachable/gyro
	name = "陀螺稳定器"
	desc = "通过配重使武器在单手射击时保持稳定的装置。会略微降低射速。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "gyro"
	attach_icon = "gyro_a"
	slot = "under"

/obj/item/attachable/gyro/New()
	..()
	delay_mod = FIRE_DELAY_TIER_11
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	burst_scatter_mod = -2
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_3
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_6
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_3

/obj/item/attachable/gyro/Attach(obj/item/weapon/gun/G)
	if(istype(G, /obj/item/weapon/gun/shotgun))
		accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_10 + HIT_ACCURACY_MULT_TIER_1
	else
		accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_3
	..()


/obj/item/attachable/lasersight
	name = "激光瞄准器"
	desc = "制式可见光下挂激光模块，型号 AN/PEQ-42。可提高精度并减小散布，单手持枪时尤为明显，也能改善移动射击表现。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "lasersight"
	attach_icon = "lasersight_a"
	slot = "side_rail"
	pixel_shift_x = 17
	pixel_shift_y = 17

/obj/item/attachable/lasersight/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_1
	movement_onehanded_acc_penalty_mod = -MOVEMENT_ACCURACY_PENALTY_MULT_TIER_5
	scatter_mod = -SCATTER_AMOUNT_TIER_10
	scatter_unwielded_mod = -SCATTER_AMOUNT_TIER_9
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_1

/obj/item/attachable/lasersight/upp
	name = "星辰激光模块"
	desc = "512nm可见光波段绿激光模块，兼容夜视仪和红外设备。和维兰德-汤谷的一款老产品惊人地相似……可减小散布，单手射击时尤其明显，并略微提高精度。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "lasersight_upp"
	attach_icon = "lasersight_upp_a"
	pixel_shift_x = 15
	pixel_shift_y = 18

/obj/item/attachable/bipod
	name = "两脚架"
	desc = "一组用于射击时稳定武器的伸缩支脚。\n正确架设后可大幅提高精度并降低后坐力，但会增加武器体积并降低射速。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "bipod"
	attach_icon = "bipod_a"
	slot = "under"
	size_mod = 2
	melee_mod = -10
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle
	var/initial_mob_dir = NORTH // the dir the mob faces the moment it deploys the bipod
	var/bipod_deployed = FALSE
	/// If this should anchor the user while in use
	var/heavy_bipod = FALSE
	// Are switching to full auto when deploying the bipod
	var/full_auto_switch = FALSE
	// Store our old firemode so we can switch to it when undeploying the bipod
	var/old_firemode = null

/obj/item/attachable/bipod/New()
	..()

	wield_delay_mod = WIELD_DELAY_FAST
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	recoil_mod = RECOIL_AMOUNT_TIER_5

/obj/item/attachable/bipod/Attach(obj/item/weapon/gun/gun, mob/user)
	..()

	if((GUN_FIREMODE_AUTOMATIC in gun.gun_firemode_list) || (gun.flags_gun_features & GUN_SUPPORT_PLATFORM))
		var/given_action = FALSE
		if(user && (gun == user.l_hand || gun == user.r_hand))
			give_action(user, /datum/action/item_action/bipod/toggle_full_auto_switch, src, gun)
			given_action = TRUE
		if(!given_action)
			new /datum/action/item_action/bipod/toggle_full_auto_switch(src, gun)

	RegisterSignal(gun, COMSIG_ITEM_DROPPED, PROC_REF(handle_drop))

/obj/item/attachable/bipod/Detach(mob/user, obj/item/weapon/gun/detaching_gub, drop_attachment = TRUE)
	UnregisterSignal(detaching_gub, COMSIG_ITEM_DROPPED)

	//clear out anything related to full auto switching
	full_auto_switch = FALSE
	old_firemode = null
	for(var/item_action in detaching_gub.actions)
		var/datum/action/item_action/bipod/toggle_full_auto_switch/target_action = item_action
		if(target_action.target == src)
			qdel(item_action)
			break

	if(bipod_deployed)
		undeploy_bipod(detaching_gub, user)
	..()

/obj/item/attachable/bipod/update_icon()
	if(bipod_deployed)
		icon_state = "[icon_state]-on"
		attach_icon = "[attach_icon]-on"
	else
		icon_state = initial(icon_state)
		attach_icon = initial(attach_icon)

	if(istype(loc, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/gun = loc
		gun.update_attachable(slot)
		for(var/datum/action/item_action as anything in gun.actions)
			if(!istype(item_action, /datum/action/item_action/bipod/toggle_full_auto_switch))
				item_action.update_button_icon()

/obj/item/attachable/bipod/proc/handle_drop(obj/item/weapon/gun/gun, mob/living/carbon/human/user)
	SIGNAL_HANDLER

	UnregisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK)

	if(bipod_deployed)
		undeploy_bipod(gun, user)
		user.apply_effect(1, SUPERSLOW)
		user.apply_effect(2, SLOW)

/obj/item/attachable/bipod/proc/undeploy_bipod(obj/item/weapon/gun/gun, mob/user)
	REMOVE_TRAIT(gun, TRAIT_GUN_BIPODDED, "attached_bipod")
	bipod_deployed = FALSE
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	recoil_mod = RECOIL_AMOUNT_TIER_5
	burst_scatter_mod = 0
	//if we are no longer on full auto, don't bother switching back to the old firemode
	if(full_auto_switch && gun.gun_firemode == GUN_FIREMODE_AUTOMATIC && gun.gun_firemode != old_firemode)
		gun.do_toggle_firemode(user, null, old_firemode)

	gun.recalculate_attachment_bonuses()
	gun.stop_fire()
	SEND_SIGNAL(user, COMSIG_MOB_UNDEPLOYED_BIPOD)
	UnregisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK)

	if(gun.flags_gun_features & GUN_SUPPORT_PLATFORM)
		gun.remove_firemode(GUN_FIREMODE_AUTOMATIC)

	if(heavy_bipod)
		user.anchored = FALSE

	if(!QDELETED(gun))
		playsound(user,'sound/items/m56dauto_rotate.ogg', 55, 1)
		update_icon()

/obj/item/attachable/bipod/activate_attachment(obj/item/weapon/gun/gun, mob/living/user, turn_off)
	if(turn_off)
		if(bipod_deployed)
			undeploy_bipod(gun, user)
	else
		var/obj/support = check_bipod_support(gun, user)
		if(!support&&!bipod_deployed)
			to_chat(user, SPAN_NOTICE("你开始在地面上架设[src]。"))
			if(!do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_HOSTILE, gun, INTERRUPT_DIFF_LOC))
				return FALSE

		bipod_deployed = !bipod_deployed
		if(user)
			if(bipod_deployed)
				ADD_TRAIT(gun, TRAIT_GUN_BIPODDED, "attached_bipod")
				to_chat(user, SPAN_NOTICE("你把[src]架在了[support ? "[support]上" : "地面上"]。"))
				SEND_SIGNAL(user, COMSIG_MOB_DEPLOYED_BIPOD)
				playsound(user,'sound/items/m56dauto_rotate.ogg', 55, 1)
				accuracy_mod = HIT_ACCURACY_MULT_TIER_5
				scatter_mod = -SCATTER_AMOUNT_TIER_10
				recoil_mod = -RECOIL_AMOUNT_TIER_4
				burst_scatter_mod = -SCATTER_AMOUNT_TIER_8
				if(istype(gun, /obj/item/weapon/gun/rifle/sniper/M42A))
					delay_mod = -FIRE_DELAY_TIER_7
				else if(istype(gun,/obj/item/weapon/gun/rifle/lmg))
					delay_mod = 0
					fa_scatter_peak_mod = FULL_AUTO_SCATTER_PEAK_TIER_3
				gun.recalculate_attachment_bonuses()
				gun.stop_fire()

				initial_mob_dir = user.dir
				RegisterSignal(user, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(handle_mob_move_or_look))

				if(gun.flags_gun_features & GUN_SUPPORT_PLATFORM)
					gun.add_firemode(GUN_FIREMODE_AUTOMATIC)

				if(heavy_bipod)
					user.anchored = TRUE

				old_firemode = gun.gun_firemode
				if(full_auto_switch && gun.gun_firemode != GUN_FIREMODE_AUTOMATIC)
					gun.do_toggle_firemode(user, null, GUN_FIREMODE_AUTOMATIC)

			else
				to_chat(user, SPAN_NOTICE("你收起了[src]。"))
				undeploy_bipod(gun, user)

	update_icon()

	return 1

/obj/item/attachable/bipod/proc/handle_mob_move_or_look(mob/living/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(!actually_moving && (specific_direction & initial_mob_dir)) // if you're facing north, but you're shooting north-east and end up facing east, you won't lose your bipod
		return
	undeploy_bipod(loc, mover)
	mover.apply_effect(1, SLOW)


//when user fires the gun, we check if they have something to support the gun's bipod.
/obj/item/attachable/proc/check_bipod_support(obj/item/weapon/gun/gun, mob/living/user)
	return 0

/obj/item/attachable/bipod/check_bipod_support(obj/item/weapon/gun/gun, mob/living/user)
	var/turf/T = get_turf(user)
	for(var/obj/O in T)
		if(O.throwpass && O.density && O.dir == user.dir && O.flags_atom & ON_BORDER)
			return O
	var/turf/T2 = get_step(T, user.dir)

	for(var/obj/O2 in T2)
		if(O2.throwpass && O2.density)
			return O2
	return 0

//item actions for handling deployment to full auto.
/datum/action/item_action/bipod/toggle_full_auto_switch/New(Target, obj/item/holder)
	. = ..()
	name = "架设后切换全自动"
	action_icon_state = "full_auto_switch"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/bipod/toggle_full_auto_switch/action_activate()
	. = ..()
	var/obj/item/weapon/gun/holder_gun = holder_item
	var/obj/item/attachable/bipod/attached_bipod = holder_gun.attachments["under"]

	attached_bipod.full_auto_switch = !attached_bipod.full_auto_switch
	to_chat(owner, SPAN_NOTICE("[icon2html(holder_gun, owner)] [attached_bipod.full_auto_switch? "架设两脚架后将<B>自动切换</b>为全自动射击模式。" : "架设两脚架后将<B>不再自动切换</b>为全自动射击模式。"]"))
	playsound(owner, 'sound/weapons/handling/gun_burst_toggle.ogg', 15, 1)

	if(attached_bipod.full_auto_switch)
		button.icon_state = "template_on"
	else
		button.icon_state = "template"

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/obj/item/attachable/bipod/integral
	name = "一体式两脚架"
	desc = "M41AE2重型脉冲步枪的一体式两脚架。"
	icon_state = "bipod"
	attach_icon = "integ_bipod_a"
	slot = "under"
	size_mod = 0
	melee_mod = 0
	flags_attach_features = ATTACH_ACTIVATION
	attachment_action_type = /datum/action/item_action/toggle

/obj/item/attachable/bipod/integral/New()
	..()

	delay_mod = 0
	wield_delay_mod = WIELD_DELAY_FAST
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_5
	scatter_mod = SCATTER_AMOUNT_TIER_9
	fa_scatter_peak_mod = 15 //fifteen more shots until you hit max scatter

/obj/item/attachable/bipod/m60
	name = "两脚架"
	desc = "一组用于射击时稳定武器的简易伸缩支脚，这一组看起来相当老旧。\n正确架设后可大幅提高精度并降低后坐力，但也会增大武器体积、降低射速。"
	icon_state = "bipod_m60"
	attach_icon = "bipod_m60_a"

	flags_attach_features = ATTACH_ACTIVATION

/obj/item/attachable/bipod/vulture
	name = "重型两脚架"
	desc = "一组结实耐用的伸缩支脚，可在射击时稳定武器。"
	icon_state = "bipod_m60"
	attach_icon = "vulture_bipod"
	heavy_bipod = TRUE

/obj/item/attachable/bipod/vulture/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(type)

/obj/item/attachable/bipod/vulture/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	var/new_attach_icon
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			attach_icon = new_attach_icon ? new_attach_icon : "s_" + attach_icon
		if("desert")
			attach_icon = new_attach_icon ? new_attach_icon : "d_" + attach_icon
		if("classic")
			attach_icon = new_attach_icon ? new_attach_icon : "c_" + attach_icon
		if("urban")
			attach_icon = new_attach_icon ? new_attach_icon : "u_" + attach_icon

/obj/item/attachable/burstfire_assembly
	name = "点射组件"
	desc = "一件小巧的精密机械组件，可增加部分武器的点射发数，或让其他武器具备点射能力。\n会增大武器散布。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "rapidfire"
	attach_icon = "rapidfire_a"
	slot = "under"

/obj/item/attachable/burstfire_assembly/New()
	..()
	accuracy_mod = -HIT_ACCURACY_MULT_TIER_3
	burst_mod = BURST_AMOUNT_TIER_2

	accuracy_unwielded_mod = -HIT_ACCURACY_MULT_TIER_4

/obj/item/attachable/eva_doodad
	name = "RXF-M5 EVA 光束投射器"
	desc = "一个古怪的小装置，会投射出一道不可见光束，EVA手枪的激光就在其中传播。它用于聚焦，但会略微削弱激光强度。至少说明书是这么说的。"
	icon = 'icons/obj/items/weapons/guns/attachments/under.dmi'
	icon_state = "rxfm5_eva_doodad"
	attach_icon = "rxfm5_eva_doodad_a"
	slot = "under"

/obj/item/attachable/eva_doodad/New()
	..()
	accuracy_mod = HIT_ACCURACY_MULT_TIER_5
	accuracy_unwielded_mod = HIT_ACCURACY_MULT_TIER_5
	damage_mod -= BULLET_DAMAGE_MULT_TIER_4

/obj/item/attachable/lw317barrel
	name = "LW-317 枪管"
	desc = "This isn't supposed to be separated from the gun, how'd this happen?"
	icon = 'icons/obj/items/weapons/guns/attachments/barrel.dmi'
	icon_state = "lw317_dmr_barrel"
	attach_icon = "lw317_dmr_barrel"
	slot = "muzzle"
	wield_delay_mod = WIELD_DELAY_NONE
	flags_attach_features = NO_FLAGS
	melee_mod = 0
	size_mod = 0
