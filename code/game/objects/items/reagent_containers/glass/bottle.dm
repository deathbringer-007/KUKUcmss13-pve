//Not to be confused with /obj/item/reagent_container/food/drinks/bottle

/obj/item/reagent_container/glass/bottle
	name = "瓶"
	desc = "一个小瓶子。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = null
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30, 40, 180)
	flags_atom = FPRINT|OPENCONTAINER
	volume = 180
	attack_speed = 4

/obj/item/reagent_container/glass/bottle/on_reagent_change()
	update_icon()

/obj/item/reagent_container/glass/bottle/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/bottle/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/bottle/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/glass/bottle/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "bottle-[rand(1,4)]"

/obj/item/reagent_container/glass/bottle/update_icon()
	overlays.Cut()

	if(reagents.total_volume && (icon_state == "bottle-1" || icon_state == "bottle-2" || icon_state == "bottle-3" || icon_state == "bottle-4"))
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = floor((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9) filling.icon_state = "[icon_state]--10"
			if(10 to 24) filling.icon_state = "[icon_state]-10"
			if(25 to 49) filling.icon_state = "[icon_state]-25"
			if(50 to 74) filling.icon_state = "[icon_state]-50"
			if(75 to 79) filling.icon_state = "[icon_state]-75"
			if(80 to 90) filling.icon_state = "[icon_state]-80"
			if(91 to INFINITY) filling.icon_state = "[icon_state]-100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_bottle")
		overlays += lid

/obj/item/reagent_container/glass/bottle/inaprovaline
	name = "因纳普罗伐林瓶"
	desc = "一小瓶瓶身光亮的因纳普罗伐林，能人工刺激呼吸反射，减轻昏迷时的缺氧。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle19"
	volume = 140
	amount_per_transfer_from_this = 140

/obj/item/reagent_container/glass/bottle/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 140)

/obj/item/reagent_container/glass/bottle/bicaridine
	name = "比卡定瓶"
	desc = "一小瓶瓶身光亮的比卡定，能促进受损组织再生。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle17"
	amount_per_transfer_from_this = 180

/obj/item/reagent_container/glass/bottle/bicaridine/Initialize()
	. = ..()
	reagents.add_reagent("bicaridine", 180)

/obj/item/reagent_container/glass/bottle/peridaxon
	name = "佩里达酮瓶"
	desc = "一小瓶瓶身光亮的佩里达酮，新型复方药，可暂时抑制器官损伤的症状。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle4"
	volume = 140
	amount_per_transfer_from_this = 140

/obj/item/reagent_container/glass/bottle/peridaxon/Initialize()
	. = ..()
	reagents.add_reagent("peridaxon", 140)

/obj/item/reagent_container/glass/bottle/tramadol
	name = "曲马多瓶"
	desc = "一小瓶瓶身光亮的曲马多，非处方合成镇痛药。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle1"
	amount_per_transfer_from_this = 180

/obj/item/reagent_container/glass/bottle/tramadol/Initialize()
	. = ..()
	reagents.add_reagent("tramadol", 180)

/obj/item/reagent_container/glass/bottle/oxycodone
	name = "羟考酮瓶"
	desc = "一小瓶瓶身光亮的羟考酮，强效镇痛药，可能成瘾。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle2"
	volume = 140
	amount_per_transfer_from_this = 140

/obj/item/reagent_container/glass/bottle/oxycodone/Initialize()
	. = ..()
	reagents.add_reagent("oxycodone", 140)

/obj/item/reagent_container/glass/bottle/tricordrazine
	name = "广效康复嗪瓶"
	desc = "一小瓶瓶身光亮的广效康复嗪，可缓慢治疗各种轻伤。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle18"
	volume = 180

/obj/item/reagent_container/glass/bottle/tricordrazine/Initialize()
	. = ..()
	reagents.add_reagent("tricordrazine", 180)

/obj/item/reagent_container/glass/bottle/kelotane
	name = "克洛坦瓶"
	desc = "一小瓶瓶身光亮的克洛坦，用于烧伤组织修复。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle16"
	amount_per_transfer_from_this = 180

/obj/item/reagent_container/glass/bottle/kelotane/Initialize()
	. = ..()
	reagents.add_reagent("kelotane", 180)

/obj/item/reagent_container/glass/bottle/dexalin
	name = "右氧林瓶"
	desc = "一小瓶瓶身光亮的右氧林。微胶囊缓慢向血液释放氧气，缓解缺氧影响。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle10"
	amount_per_transfer_from_this = 180

/obj/item/reagent_container/glass/bottle/dexalin/Initialize()
	. = ..()
	reagents.add_reagent("dexalin", 180)

/obj/item/reagent_container/glass/bottle/dexalinplus
	name = "强化右氧林瓶"
	desc = "一小瓶强化右氧林。高度浓缩的微胶囊迅速向血液释放氧气，立即缓解缺氧影响。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle10"
	volume = 140
	amount_per_transfer_from_this = 140

/obj/item/reagent_container/glass/bottle/dexalinplus/Initialize()
	. = ..()
	reagents.add_reagent("dexalinp", 140)

/obj/item/reagent_container/glass/bottle/spaceacillin
	name = "\improper 太空西林药瓶"
	desc = "一个小药瓶，内含用于治疗伤口感染的太空西林。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle8"
	amount_per_transfer_from_this = 180

/obj/item/reagent_container/glass/bottle/spaceacillin/Initialize()
	. = ..()
	reagents.add_reagent("spaceacillin", 180)

/obj/item/reagent_container/glass/bottle/toxin
	name = "毒素瓶"
	desc = "一小瓶毒素。有毒，请勿饮用。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle12"

/obj/item/reagent_container/glass/bottle/toxin/Initialize()
	. = ..()
	reagents.add_reagent("toxin", 150)

/obj/item/reagent_container/glass/bottle/cyanide
	name = "氰化物瓶"
	desc = "一小瓶氰化物。苦杏仁味？"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle12"

/obj/item/reagent_container/glass/bottle/cyanide/Initialize()
	. = ..()
	reagents.add_reagent("cyanide", 150)

/obj/item/reagent_container/glass/bottle/stoxin
	name = "催眠剂瓶"
	desc = "一小瓶催眠剂，光是气味就能让你昏昏欲睡。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle20"
	amount_per_transfer_from_this = 150

/obj/item/reagent_container/glass/bottle/stoxin/Initialize()
	. = ..()
	reagents.add_reagent("stoxin", 150)

/obj/item/reagent_container/glass/bottle/chloralhydrate
	name = "水合氯醛瓶"
	desc = "一小瓶水合氯醛，米基的最爱！"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle20"

/obj/item/reagent_container/glass/bottle/chloralhydrate/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 30) //Intentionally low since it is so strong. Still enough to knock someone out.

/obj/item/reagent_container/glass/bottle/antitoxin
	name = "迪洛文瓶"
	desc = "一小瓶瓶身光亮的迪洛文，新型广谱抗毒药。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle7"
	amount_per_transfer_from_this = 150

/obj/item/reagent_container/glass/bottle/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 150)

/obj/item/reagent_container/glass/bottle/imialk
	name = "咪唑啉-神经修复素瓶"
	desc = "一小瓶咪唑啉与神经修复素，用于治疗脑部和眼部损伤。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle19"
	volume = 140
	amount_per_transfer_from_this = 140

/obj/item/reagent_container/glass/bottle/imialk/Initialize()
	. = ..()
	reagents.add_reagent("imidazoline", 70)
	reagents.add_reagent("alkysine", 70)

/obj/item/reagent_container/glass/bottle/merabica
	name = "美拉林-比卡定瓶"
	desc = "一小瓶美拉林与比卡定，可快速治疗钝伤。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle17"
	volume = 140
	amount_per_transfer_from_this = 140

/obj/item/reagent_container/glass/bottle/merabica/Initialize()
	. = ..()
	reagents.add_reagent("bicaridine", 70)
	reagents.add_reagent("meralyne", 70)

/obj/item/reagent_container/glass/bottle/keloderm
	name = "克洛坦-德玛林瓶"
	desc = "一小瓶克洛坦与德玛林，两种用于烧伤组织修复的药物。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle15"
	volume = 140
	amount_per_transfer_from_this = 140

/obj/item/reagent_container/glass/bottle/keloderm/Initialize()
	. = ..()
	reagents.add_reagent("kelotane", 70)
	reagents.add_reagent("dermaline", 70)

/obj/item/reagent_container/glass/bottle/mutagen
	name = "不稳定诱变剂瓶"
	desc = "一小瓶不稳定诱变剂，会随机改变接触者的 DNA 结构。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle7"

/obj/item/reagent_container/glass/bottle/mutagen/Initialize()
	. = ..()
	reagents.add_reagent("mutagen", 150)

/obj/item/reagent_container/glass/bottle/ammonia
	name = "氨水瓶"
	desc = "一个小瓶子。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle20"

/obj/item/reagent_container/glass/bottle/ammonia/Initialize()
	. = ..()
	reagents.add_reagent("ammonia", 150)

/obj/item/reagent_container/glass/bottle/diethylamine
	name = "二乙胺瓶"
	desc = "一个小瓶子，内装强效肥料。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle17"

/obj/item/reagent_container/glass/bottle/diethylamine/Initialize()
	. = ..()
	reagents.add_reagent("diethylamine", 150)

/obj/item/reagent_container/glass/bottle/flu_virion
	name = "流感病毒培养瓶"
	desc = "一个小瓶，内含以合成血液为培养基的 H13N1 流感病毒培养物。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/flu_virion/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/advance/flu(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/epiglottis_virion
	name = "会厌炎病毒培养瓶"
	desc = "一个小瓶，内含以合成血液为培养基的会厌炎病毒培养物。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/epiglottis_virion/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/advance/voice_change(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/liver_enhance_virion
	name = "肝脏强化病毒培养瓶"
	desc = "一个小瓶，内含以合成血液为培养基的肝脏强化病毒培养物。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/liver_enhance_virion/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/advance/heal(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/hullucigen_virion
	name = "致幻病毒培养瓶"
	desc = "一个小瓶，内含以合成血液为培养基的致幻病毒培养物。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/hullucigen_virion/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/advance/hullucigen(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/pierrot_throat
	name = "\improper 皮埃罗之喉培养瓶"
	desc = "一个小瓶，内含以合成血液为培养基的 H0NI<42 病毒培养物。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/pierrot_throat/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/pierrot_throat(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/cold
	name = "鼻病毒培养瓶"
	desc = "一个小瓶，内含以合成血液为培养基的 XY 鼻病毒培养物。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/cold/Initialize()
	. = ..()
	var/datum/disease/advance/F = new /datum/disease/advance/cold(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/random
	name = "随机培养瓶"
	desc = "一个小瓶，内含一种随机疾病。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/random/Initialize()
	. = ..()
	var/datum/disease/advance/F = new(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/gbs
	name = "\improper GBS 培养瓶"
	desc = "一个小瓶，内含以合成血液为培养基的重力动能双势体 SADS+ 培养物。"//Or simply - General BullShit
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"
	amount_per_transfer_from_this = 5

/obj/item/reagent_container/glass/bottle/gbs/Initialize()
	. = ..()
	create_reagents(20)
	var/datum/disease/F = new /datum/disease/gbs
	var/list/data = list("virus"= F)
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/fake_gbs
	name = "\improper GBS 培养瓶"
	desc = "一个小瓶，内含以合成血液为培养基的重力动能双势体 SADS- 培养物。"//Or simply - General BullShit
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/fake_gbs/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/fake_gbs(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)
/*
/obj/item/reagent_container/glass/bottle/rhumba_beat
	name = "Rhumba Beat culture bottle"
	desc = "A small bottle. Contains The Rhumba Beat culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"
	amount_per_transfer_from_this = 5

	New()
		var/datum/reagents/R = new/datum/reagents(20)
		reagents = R
		R.my_atom = src
		var/datum/disease/F = new /datum/disease/rhumba_beat
		var/list/data = list("virus"= F)
		R.add_reagent("blood", 20, data)
*/

/obj/item/reagent_container/glass/bottle/brainrot
	name = "\improper 脑腐病培养瓶"
	desc = "一个小瓶，内含以合成血液为培养基的宇宙隐球菌培养物。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/brainrot/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/brainrot(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/magnitis
	name = "\improper 磁化症培养瓶"
	desc = "一个小瓶，内含少量福科斯·米拉科斯。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/magnitis/Initialize()
	. = ..()
	var/datum/disease/F = new /datum/disease/magnitis(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 20, data)

/obj/item/reagent_container/glass/bottle/pacid
	name = "聚三酸瓶"
	desc = "一个小瓶，内含少量极为强效且危险的聚三酸。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle17"

/obj/item/reagent_container/glass/bottle/pacid/Initialize()
	. = ..()
	reagents.add_reagent("pacid", 150)

/obj/item/reagent_container/glass/bottle/adminordrazine
	name = "\improper 神赐康复嗪瓶"
	desc = "一个小瓶，内含诸神的液态精华。"
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = "holyflask"

/obj/item/reagent_container/glass/bottle/adminordrazine/Initialize()
	. = ..()
	reagents.add_reagent("adminordrazine", 150)

/obj/item/reagent_container/glass/bottle/capsaicin
	name = "\improper 辣椒素瓶"
	desc = "一个小瓶，内含辣酱。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle3"

/obj/item/reagent_container/glass/bottle/capsaicin/Initialize()
	. = ..()
	reagents.add_reagent("capsaicin", 150)

/obj/item/reagent_container/glass/bottle/frostoil
	name = "\improper 寒霜油瓶"
	desc = "一个小瓶，内含冰凉酱。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle17"

/obj/item/reagent_container/glass/bottle/frostoil/Initialize()
	. = ..()
	reagents.add_reagent("frostoil", 150)
