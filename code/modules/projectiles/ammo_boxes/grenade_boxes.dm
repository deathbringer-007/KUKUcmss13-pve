/obj/item/ammo_box/magazine/nade_box
	name = "M40 HEDP 手榴弹箱"
	desc = "装有 25 枚 M40 高爆两用手榴弹的安全箱。具有强爆炸性，请勿存放在喷火器燃料旁。"
	icon = 'icons/obj/items/weapons/guns/ammo_boxes/boxes_and_lids.dmi'
	icon_state = "base_uscm_nade"
	w_class = SIZE_LARGE
	holds_ammo = FALSE
	holds_grenades = TRUE
	num_of_magazines = 25	//Scuffed, but it saves making new examination procs
	magazine_type = /obj/item/explosive/grenade/high_explosive
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive)
	var/overlay_model_type = "model_m40" //Used for the on-box text
	var/overlay_icon_type = "hedp" //For the on-box color stripe, if any
	var/overlay_grenade_type = "hedp" //For the deployed state, showing grenades inside
	overlay_ammo_type = null
	overlay_gun_type = null
	overlay_content = null
	icon_state_deployed = null
	empty = FALSE
	can_explode = TRUE
	burning = FALSE
	limit_per_tile = 1 //how many you can deploy per tile

	var/grenade_text_markings_icon = 'icons/obj/items/weapons/guns/ammo_boxes/grenade_markings.dmi'
	flames_icon = 'icons/obj/items/weapons/guns/ammo_boxes/misc.dmi'

//---------------------GENERAL PROCS

/obj/item/ammo_box/magazine/nade_box/update_icon()
	if(overlays)
		overlays.Cut()
	if(!icon_state_deployed) // The lid is on the sprite already.
		overlays += image(icon, icon_state = "[icon_state]_lid") //adding lid
	if(overlay_model_type)
		overlays += image(grenade_text_markings_icon, icon_state = "[overlay_model_type]") //adding text
	if(overlay_icon_type)
		overlays += image(grenade_text_markings_icon, icon_state = "[overlay_icon_type]") //adding color stripes

//---------------------INTERACTION PROCS

/obj/item/ammo_box/magazine/nade_box/deploy_ammo_box(mob/living/user, turf/T)
	if(burning)
		to_chat(user, SPAN_DANGER("它着火了，里面的手榴弹随时可能爆炸！"))
		return

	var/obj/structure/magazine_box/nade_box/M = new /obj/structure/magazine_box/nade_box(T)
	M.icon_state = icon_state_deployed ? icon_state_deployed : icon_state
	M.name = name
	M.desc = desc
	M.boom_box = src
	M.update_icon()
	user.drop_inv_item_on_ground(src)
	Move(M)

/obj/item/ammo_box/magazine/nade_box/afterattack(atom/target, mob/living/user, proximity)
	if(burning)
		to_chat(user, SPAN_DANGER("它着火了，里面的手榴弹随时可能爆炸！"))
		return
	if(!proximity)
		return
	if(isturf(target))
		var/turf/T = target
		if(!T.density)
			deploy_ammo_box(user, T)

//---------------------FIRE HANDLING PROCS

/obj/item/ammo_box/magazine/nade_box/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	if(burning)
		return
	burning = TRUE
	process_burning(flame_cause_data)
	return

/obj/item/ammo_box/magazine/nade_box/apply_fire_overlay(will_explode = FALSE)
	. = ..()
	var/fire_overlay = image(flames_icon, icon_state = "on_fire_grenade_overlay")
	overlays.Add(fire_overlay)

//--------------------GRENADE BOXES

/obj/item/ammo_box/magazine/nade_box/bfab
	name = "\improper M51A BFAB 跳跃空爆破片手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M51A BFAB 跳跃空爆破片手榴弹。极易爆炸，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/impact/tmfrag
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/impact/tmfrag)
	overlay_model_type = "model_m51a"
	overlay_icon_type = "bfab"
	overlay_grenade_type = "bfab"

/obj/item/ammo_box/magazine/nade_box/heap
	name = "\improper M38 HEAP 高爆穿甲手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M38 HEAP 高爆穿甲手榴弹。极易爆炸，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/impact/heap
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/impact/heap)
	overlay_model_type = "model_m38"
	overlay_icon_type = "heap"
	overlay_grenade_type = "heap"

/obj/item/ammo_box/magazine/nade_box/smoke
	name = "\improper M47 HSDP 高密度双用途烟雾手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M47 HSDP 高密度双用途烟雾手榴弹。易燃，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/smokebomb
	allowed_magazines = list(/obj/item/explosive/grenade/smokebomb)
	overlay_model_type = "model_m47"
	overlay_icon_type = "smoke"
	overlay_grenade_type = "smoke"

/obj/item/ammo_box/magazine/nade_box/smoke/green
	name = "\improper M47-G HSDP 绿色烟雾手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M47-G HSDP 绿色烟雾手榴弹。易燃，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/smokebomb/green
	allowed_magazines = list(/obj/item/explosive/grenade/smokebomb/green)
	overlay_icon_type = "gsmoke"
	overlay_grenade_type = "gsmoke"

/obj/item/ammo_box/magazine/nade_box/smoke/red
	name = "\improper M47-R HSDP 红色烟雾手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M47-R HSDP 红色烟雾手榴弹。易燃，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/smokebomb/red
	allowed_magazines = list(/obj/item/explosive/grenade/smokebomb/red)
	overlay_icon_type = "rsmoke"
	overlay_grenade_type = "rsmoke"

/obj/item/ammo_box/magazine/nade_box/flare
	name = "\improper M72A2 HIPF 高强度降落伞照明手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M72A2 HIPF 高强度降落伞照明手榴弹。易燃，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/impact/flare
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/impact/flare)
	overlay_model_type = "model_m72"
	overlay_icon_type = "hipf"
	overlay_grenade_type = "hipf"

/obj/item/ammo_box/magazine/nade_box/phophorus
	name = "M60 WPSI 手榴弹箱"
	desc = "装有 25 枚 M60 白磷烟幕／燃烧化合物手榴弹的安全箱。极易燃烧和爆炸，请勿存放在喷火器燃料旁。"
	magazine_type = /obj/item/explosive/grenade/phosphorus
	allowed_magazines = list(/obj/item/explosive/grenade/phosphorus)
	overlay_model_type = "model_m60"
	overlay_icon_type = "phos"
	overlay_grenade_type = "phos"

/obj/item/ammo_box/magazine/nade_box/incen
	name = "M77 HIAM 手榴弹箱"
	desc = "装有 25 枚 M77 高爆燃烧阻行手榴弹的安全箱。极易燃烧，请勿存放在喷火器燃料旁。"
	magazine_type = /obj/item/explosive/grenade/incendiary
	allowed_magazines = list(/obj/item/explosive/grenade/incendiary)
	overlay_model_type = "model_m77"
	overlay_icon_type = "hiam"
	overlay_grenade_type = "hiam"

/obj/item/ammo_box/magazine/nade_box/canister
	name = "\improper M108 霰弹手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M108 霰弹手榴弹。易燃，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/airburst/canister
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/airburst/canister)
	overlay_model_type = "model_m108"
	overlay_icon_type = "buck"
	overlay_grenade_type = "buck"

/obj/item/ammo_box/magazine/nade_box/foam
	name = "\improper M42 MFHS 金属泡沫舱体密封手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M42 MFHS 金属泡沫舱体密封手榴弹。易燃，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/metal_foam
	allowed_magazines = list(/obj/item/explosive/grenade/metal_foam)
	overlay_model_type = "model_m42"
	overlay_icon_type = "foam"
	overlay_grenade_type = "foam"

/obj/item/ammo_box/magazine/nade_box/m15
	name = "\improper M15 老式破片手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M15 老式破片手榴弹。极易爆炸，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/m15
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/m15)
	overlay_model_type = "model_m15"
	overlay_icon_type = "m15"
	overlay_grenade_type = "m15"

/obj/item/ammo_box/magazine/nade_box/super
	name = "\improper M40-2“超级”高爆两用手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M40-2“超级”高爆两用手榴弹。极易爆炸，请勿靠近喷火器燃料存放。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/super
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/super)
	icon_state = "base_training_nade"
	overlay_model_type = "model_m40"
	overlay_icon_type = "hedp"
	overlay_grenade_type = "m40_2"

//--------------------LTL GRENADE BOXES

/obj/item/ammo_box/magazine/nade_box/training
	name = "\improper M07 训练手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M07 训练手榴弹。无害且可重复使用。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/training
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/training)
	icon_state = "base_training_nade"
	overlay_model_type = "model_mo7"
	overlay_icon_type = "training"
	overlay_grenade_type = "training"

/obj/item/ammo_box/magazine/nade_box/ltl
	name = "\improper M230 LLRB 低致命性橡胶弹手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M230 LLRB 低致命性橡胶弹手榴弹。用于防暴。"
	magazine_type = /obj/item/explosive/grenade/slug/baton
	allowed_magazines = list(/obj/item/explosive/grenade/slug/baton)
	icon_state = "base_uscm_ltl"
	overlay_model_type = "model_m230"
	overlay_icon_type = "ltl"
	overlay_grenade_type = "ltl"

/obj/item/ammo_box/magazine/nade_box/ltl/tear_gas
	name = "\improper M66 催泪手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚M66 催泪手榴弹。用于防暴。"
	magazine_type = /obj/item/explosive/grenade/tear/marine
	allowed_magazines = list(/obj/item/explosive/grenade/tear/marine)
	overlay_model_type = "model_m66"
	overlay_icon_type = "tgas"
	overlay_grenade_type = "tgas"

//Ostensibly a less-than-lethal grenade
/obj/item/ammo_box/magazine/nade_box/ltl/sebb
	name = "\improper G-2 电击手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚G-2 电击手榴弹。请勿靠近精密电子设备存放，也不要放在舰长床底下。"
	magazine_type = /obj/item/explosive/grenade/sebb
	allowed_magazines = list(/obj/item/explosive/grenade/sebb)
	overlay_model_type = "model_sebb"
	overlay_icon_type = "sebb"
	overlay_grenade_type = "sebb"

//--------------------40MM GRENADE BOXES

/obj/item/ammo_box/magazine/nade_box/fourtymil
	name = "40mm HEDP 手榴弹箱"
	desc = "装有 25 枚老式 40mm 高爆两用手榴弹的安全箱。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/impact
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/impact)
	icon_state = "base_uscm_40mm"
	overlay_model_type = "model_40mm"
	overlay_icon_type = "hedp"
	overlay_grenade_type = "40mm_hedp"

/obj/item/ammo_box/magazine/nade_box/fourtymil/frag
	name = "\improper 40 毫米 HEFA 老式高爆反步兵破片手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚40 毫米 HEFA 老式高爆反步兵破片手榴弹。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/impact/frag
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/impact/frag)
	overlay_icon_type = "hefa"
	overlay_grenade_type = "40mm_hefa"

/obj/item/ammo_box/magazine/nade_box/fourtymil/incen
	name = "\improper 40 毫米老式燃烧手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚40 毫米老式燃烧手榴弹。"
	magazine_type = /obj/item/explosive/grenade/incendiary/impact
	allowed_magazines = list(/obj/item/explosive/grenade/incendiary/impact)
	overlay_icon_type = "hiam"
	overlay_grenade_type = "40mm_hiam"

/obj/item/ammo_box/magazine/nade_box/fourtymil/canister
	name = "\improper 40 毫米老式霰弹手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚40 毫米老式霰弹手榴弹。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/airburst/buckshot
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/airburst/buckshot)
	overlay_icon_type = "buck"
	overlay_grenade_type = "40mm_buck"

/obj/item/ammo_box/magazine/nade_box/fourtymil/baton
	name = "\improper 40 毫米橡胶弹手榴弹箱"
	desc = "一个安全储存箱，内装 25 枚40 毫米橡胶弹手榴弹。"
	magazine_type = /obj/item/explosive/grenade/slug/baton/m79
	allowed_magazines = list(/obj/item/explosive/grenade/slug/baton/m79)
	icon_state = "base_uscm_ltl"
	overlay_icon_type = "agms"
	overlay_grenade_type = "40mm_ltl"

//--------------------M74 GRENADE BOXES

/obj/item/ammo_box/magazine/nade_box/fourtymil/airburst
	name = "M74 AGM-F 手榴弹箱"
	desc = "装有 25 枚 M74 AGM 破片手榴弹的安全箱。内含爆炸物，请勿存放在喷火器燃料旁。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/airburst
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/airburst)
	overlay_model_type = "model_m74"
	overlay_icon_type = "agmf"
	overlay_grenade_type = "40mm_agmf"

/obj/item/ammo_box/magazine/nade_box/fourtymil/airburst/incen
	name = "M74 AGM-I 手榴弹箱"
	desc = "装有 25 枚 M74 AGM 燃烧手榴弹的安全箱。极易燃烧，请勿存放在喷火器燃料旁。"
	magazine_type = /obj/item/explosive/grenade/incendiary/airburst
	allowed_magazines = list(/obj/item/explosive/grenade/incendiary/airburst)
	overlay_icon_type = "agmi"
	overlay_grenade_type = "40mm_agmi"

/obj/item/ammo_box/magazine/nade_box/fourtymil/airburst/smoke
	name = "M74 AGM-S 手榴弹箱"
	desc = "装有 25 枚 M74 AGM 烟幕手榴弹的安全箱。内含爆炸物，请勿存放在喷火器燃料旁。"
	magazine_type = /obj/item/explosive/grenade/smokebomb/airburst
	allowed_magazines = list(/obj/item/explosive/grenade/smokebomb/airburst)
	overlay_icon_type = "agms"
	overlay_grenade_type = "40mm_agms"

//--------------------UPP GRENADE BOXES

/obj/item/ammo_box/magazine/nade_box/upp
	name = "\improper 6 式破片手榴弹箱"
	desc = "一个安全储存箱，内装 12 枚6 式破片手榴弹。从箱中取出前，请确认保险销完好。"
	num_of_magazines = 12
	magazine_type = /obj/item/explosive/grenade/high_explosive/upp
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/upp)
	icon_state = "base_upp_nade"
	overlay_model_type = "model_type6"
	overlay_icon_type = "type6"
	overlay_grenade_type = "type6"

/obj/item/ammo_box/magazine/nade_box/upp/smoke
	name = "\improper RDG-17 烟雾手榴弹箱"
	desc = "一个安全储存箱，内装 12 枚RDG-17 烟雾手榴弹。从箱中取出前，请确认保险销完好。"
	magazine_type = /obj/item/explosive/grenade/smokebomb/upp
	allowed_magazines = list(/obj/item/explosive/grenade/smokebomb/upp)
	overlay_model_type = "model_typesmoke"
	overlay_icon_type = "typesmoke"
	overlay_grenade_type = "typesmoke"

/obj/item/ammo_box/magazine/nade_box/upp/wp
	name = "\improper 8 式白磷手榴弹箱"
	desc = "一个安全储存箱，内装 12 枚8 式白磷手榴弹。从箱中取出前，请确认保险销完好。"
	magazine_type = /obj/item/explosive/grenade/phosphorus/upp
	allowed_magazines = list(/obj/item/explosive/grenade/phosphorus/upp)
	overlay_model_type = "model_typewp"
	overlay_icon_type = "typewp"
	overlay_grenade_type = "typewp"

/obj/item/ammo_box/magazine/nade_box/upp/ugl
	name = "\improper VOG-73 高爆手榴弹箱"
	desc = "一个安全储存箱，内装 15 枚VOG-73 高爆手榴弹。请勿靠近明火存放。"
	num_of_magazines = 15
	magazine_type = /obj/item/explosive/grenade/high_explosive/impact/upp
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/impact/upp)
	overlay_model_type = "model_vog"
	overlay_icon_type = "40mmhe"
	overlay_grenade_type = "upp_40mm_he"

/obj/item/ammo_box/magazine/nade_box/upp/ugl/ap
	name = "\improper VPG-77 穿甲手榴弹箱"
	desc = "一个安全储存箱，内装 15 枚VPG-77 穿甲手榴弹。请勿靠近明火存放。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/impact/upp/ap
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/impact/upp/ap)
	overlay_model_type = "model_vpg"
	overlay_icon_type = "40mmap"
	overlay_grenade_type = "upp_40mm_ap"

/obj/item/ammo_box/magazine/nade_box/upp/ugl/canister
	name = "\improper VShG-80 突击手榴弹箱"
	desc = "一个安全储存箱，内装 15 枚VShG-80 突击手榴弹。请勿靠近明火存放。"
	magazine_type = /obj/item/explosive/grenade/high_explosive/airburst/upp
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/airburst/upp)
	overlay_model_type = "model_vsgh"
	overlay_icon_type = "40mmbuck"
	overlay_grenade_type = "upp_40mm_buck"

/obj/item/ammo_box/magazine/nade_box/upp/ugl/incen
	name = "\improper VTBG-44 温压手榴弹箱"
	desc = "一个安全储存箱，内装 15 枚VTBG-44 温压手榴弹。请勿靠近明火存放。"
	magazine_type = /obj/item/explosive/grenade/incendiary/impact/upp
	allowed_magazines = list( /obj/item/explosive/grenade/incendiary/impact/upp)
	overlay_model_type = "model_vtbg"
	overlay_icon_type = "40mmincend"
	overlay_grenade_type = "upp_40mm_hiam"

//--------------------RMC GRENADE BOXES

/obj/item/ammo_box/magazine/nade_box/rmc
	name = "\improper R2175/A HEDP 高爆两用手榴弹箱"
	desc = "一个安全储存箱，内装 18 枚R2175/A HEDP 高爆两用手榴弹。极易爆炸，请勿靠近明火存放。"
	num_of_magazines = 18
	magazine_type = /obj/item/explosive/grenade/high_explosive/rmc
	allowed_magazines = list(/obj/item/explosive/grenade/high_explosive/rmc)
	icon_state = "base_rmc_nade"
	overlay_model_type = "model_r2175"
	overlay_icon_type = "rmchedp"
	overlay_grenade_type = "rmc_hedp"

/obj/item/ammo_box/magazine/nade_box/rmc/incen
	name = "\improper R2175/B HIDP 燃烧两用手榴弹箱"
	desc = "一个安全储存箱，内装 18 枚R2175/B HIDP 燃烧两用手榴弹。极易燃烧，请勿靠近明火存放。"
	magazine_type = /obj/item/explosive/grenade/incendiary/rmc
	allowed_magazines = list(/obj/item/explosive/grenade/incendiary/rmc)
	overlay_icon_type = "rmchidp"
	overlay_grenade_type = "rmc_hidp"

/obj/item/ammo_box/magazine/nade_box/rmc/cn20
	name = "\improper R2175/CN20 神经毒气手榴弹箱"
	desc = "一个安全储存箱，内装 18 枚R2175/CN20 神经毒气手榴弹。极其致命，存放前请确认密封盖已牢固装好。"
	magazine_type = /obj/item/explosive/grenade/nerve_gas/xeno/rmc
	allowed_magazines = list(/obj/item/explosive/grenade/nerve_gas/xeno/rmc)
	overlay_icon_type = "rmcgas"
	overlay_grenade_type = "rmc_cn20"
