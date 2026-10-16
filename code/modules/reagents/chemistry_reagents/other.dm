
//*****************************************************************************************************/
//********************************************Blood****************************************************/
//*****************************************************************************************************/

/datum/reagent/blood
	name = "Blood"
	localized_name = "血液"
	id = "blood"
	description = "血液属于结缔组织，主要由两部分组成：血浆，即透明的细胞外液；有形成分，即血细胞和血小板。"
	reagent_state = LIQUID
	color = "#A10808"
	data_properties = new/list("blood_type"=null,"blood_color"= "#A10808","viruses"=null,"resistances"=null)
	chemclass = CHEM_CLASS_RARE


/datum/reagent/blood/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	var/datum/reagent/blood/self = src
	src = null
	if(self.data_properties && self.data_properties["viruses"])
		for(var/datum/disease/D in self.data_properties["viruses"])
			//var/datum/disease/virus = new D.type(0, D, 1)
			// We don't spread.
			if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS) continue

			if(method == TOUCH)
				M.contract_disease(D)
			else //injected
				M.contract_disease(D, 1, 0)


/datum/reagent/blood/reaction_turf(turf/T, volume)//splash the blood all over the place
	if(!istype(T)) return
	var/datum/reagent/blood/self = src
	src = null
	if(!(volume >= 3)) return

	T.add_blood(self.color)



/datum/reagent/blood/yaut_blood
	name = "Green Blood"
	localized_name = "绿色血液"
	id = "greenblood"
	description = "浓稠的绿色血液，绝对不是人类的。"
	color = BLOOD_COLOR_YAUTJA
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_HIGH_VALUE

/datum/reagent/blood/synth_blood
	name = "Synthetic Blood"
	localized_name = "合成人血液"
	id = "whiteblood"
	color = BLOOD_COLOR_SYNTHETIC
	description = "所有合成人使用的仿血液合成液体，作为电子设备液冷介质十分有效。"
	chemclass = CHEM_CLASS_NONE

/datum/reagent/blood/zomb_blood
	name = "Grey Blood"
	localized_name = "灰色血液"
	id = "greyblood"
	color = "#333333"
	description = "一种灰色液体，稠度与血液相同。"
	chemclass = CHEM_CLASS_NONE

/datum/reagent/blood/xeno_blood
	name = "Acidic Blood"
	localized_name = "酸性血液"
	id = "xenoblood"
	color = BLOOD_COLOR_XENO
	description = "具有腐蚀性的仿血液物质，成分似乎是酸与血浆。"
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_HIGH_VALUE
	properties = list(PROPERTY_CORROSIVE = 3)

/datum/reagent/blood/xeno_blood/royal
	name = "Dark Acidic Blood"
	localized_name = "深色酸性血液"
	id = "xenobloodroyal"
	color = BLOOD_COLOR_XENO_ROYAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_CORROSIVE = 6)

/datum/reagent/vaccine
	//data must contain virus type
	name = "Vaccine"
	localized_name = "疫苗"
	id = "vaccine"
	reagent_state = LIQUID
	color = "#C81040" // rgb: 200, 16, 64
	properties = list(PROPERTY_CURING = 4)

/datum/reagent/vaccine/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	if(has_species(M,"Horror"))
		return
	var/datum/reagent/vaccine/self = src
	src = null
	if(self.data_properties && method == INGEST)
		for(var/datum/disease/D in M.viruses)
			if(istype(D, /datum/disease/advance))
				var/datum/disease/advance/A = D
				if(A.GetDiseaseID() == self.data_properties)
					D.cure()
			else
				if(D.type == self.data_properties)
					D.cure()

		M.resistances += self.data_properties
	return

/datum/reagent/water
	name = "Water"
	localized_name = "水"
	id = "water"
	description = "由氢和氧组成的常见化学物质。虽然不提供热量或有机营养，却是所有已知有机生命不可或缺的组成部分。也是有效的溶剂，可用于清洁。"
	reagent_state = LIQUID
	color = "#0064C8" // rgb: 0, 100, 200
	chemclass = CHEM_CLASS_BASIC
	chemfiresupp = TRUE
	intensitymod = -3
	properties = list(PROPERTY_HEMOGENIC = 1)

/datum/reagent/water/reaction_turf(turf/T, volume)
	if(!istype(T)) return
	src = null
	if(volume >= 3)
		T.wet_floor(FLOOR_WET_WATER)

/datum/reagent/water/reaction_obj(obj/O, volume)
	src = null
	O.extinguish()

/datum/reagent/water/reaction_mob(mob/living/M, method=TOUCH, volume, permeable)//Splashing people with water can help put them out!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(-(volume / 10))
		if(M.fire_stacks <= 0)
			M.ExtinguishMob()

/datum/reagent/water/on_mob_life(mob/living/M)
	. = ..()
	if(ishuman(M) && volume >= 100 && prob(25))
		var/mob/living/carbon/human/human = M
		human.vomit()

/datum/reagent/water/holywater
	name = "Holy Water"
	localized_name = "圣水"
	id = "holywater"
	description = "灰烬、黑曜石与水的混合液，会改变大脑中某些负责理性思维的区域。"
	color = "#E0E8EF" // rgb: 224, 232, 239
	chemclass = CHEM_CLASS_NONE

/datum/reagent/plasticide
	name = "Plasticide"
	localized_name = "液态塑料"
	id = "plasticide"
	description = "液态的塑料，不可食用。"
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	properties = list(PROPERTY_TOXIC = 1)

/datum/reagent/space_drugs
	name = "Space drugs"
	localized_name = "太空毒品"
	id = "space_drugs"
	description = "一种非法化合物，会引起幻觉、视觉异常和失去平衡。"
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HALLUCINOGENIC = 2)

/datum/reagent/sleen
	name = "Sleen"
	localized_name = "赤酮饮"
	id = "sleen"
	description = "陆战队医疗兵的最爱，以名牌青柠汽水和羟考酮调成的非法混合饮品，因鲜明的红色而闻名。过量使用可能引发幻觉、协调能力丧失、癫痫发作、脑损伤、呼吸衰竭和死亡。"
	reagent_state = LIQUID
	color = "#C21D24" // rgb: 194, 29, 36
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 6)

/datum/reagent/serotrotium
	name = "Serotrotium"
	localized_name = "促血清素剂"
	id = "serotrotium"
	description = "可促进人体集中产生血清素神经递质的化合物。"
	reagent_state = LIQUID
	color = "#202040" // rgb: 20, 20, 40
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_ALLERGENIC = 2)

/datum/reagent/oxygen
	name = "Oxygen"
	localized_name = "氧气"
	id = "oxygen"
	description = "原子序数为 8 的化学元素，是能与大多数元素及许多化合物反应生成氧化物的氧化剂。氧分子参与细胞呼吸，是维持有机生命所必需的。"
	reagent_state = GAS
	color = COLOR_GRAY
	chemfiresupp = TRUE
	properties = list(PROPERTY_OXIDIZING = 2)
	intensitymod = 0.75
	radiusmod = -0.08
	burncolor = "#58daff"
	burncolormod = 2
	chemclass = CHEM_CLASS_BASIC
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/copper
	name = "Copper"
	localized_name = "铜"
	id = "copper"
	description = "原子序数为 29 的化学元素。质软、易延展的红色金属，导热性和导电性都很高。"
	color = "#6E3B08" // rgb: 110, 59, 8
	chemfiresupp = TRUE
	burncolor = "#78be5a"
	burncolormod = 4
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/nitrogen
	name = "Nitrogen"
	localized_name = "氮气"
	id = "nitrogen"
	description = "原子序数为 7 的化学元素。液氮常用于低温技术，其熔点为 63.15 K。氮也是许多爆炸性化合物和肥料的组成元素。"
	reagent_state = GAS
	color = COLOR_GRAY
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)


/datum/reagent/hydrogen
	name = "Hydrogen"
	localized_name = "氢气"
	id = "hydrogen"
	description = "原子序数为 1 的化学元素，也是宇宙中含量最丰富的元素。液氢是太空航行最早使用的燃料之一。极易燃烧，参与许多化学反应。"
	reagent_state = GAS
	color = COLOR_GRAY
	chemfiresupp = TRUE
	durationmod = -0.5
	radiusmod = 0.2
	intensitymod = -0.5
	burncolor = "#b6f8ff"
	burncolormod = 2
	explosive = TRUE
	power = 0.15
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/potassium
	name = "Potassium"
	localized_name = "钾"
	id = "potassium"
	description = "原子序数为 19 的化学元素，是一种质软且活性很高的金属，与水接触会产生极其剧烈的放热反应。"
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/mercury
	name = "Mercury"
	localized_name = "汞"
	id = "mercury"
	description = "原子序数为 80 的化学元素，是唯一在室温下呈液态的金属单质，具有许多工业化学用途。汞的低蒸气压使其产生有毒蒸气。汞中毒极其危险，可能造成严重脑损伤。"
	reagent_state = LIQUID
	color = "#484848" // rgb: 72, 72, 72
	overdose = REAGENTS_OVERDOSE
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_NEUROTOXIC = 4, PROPERTY_NEUROCRYOGENIC = 1, PROPERTY_DISRUPTING = 1)

/datum/reagent/sulfur
	name = "Sulfur"
	localized_name = "硫"
	id = "sulfur"
	description = "原子序数为 16 的化学元素，是氨基酸和维生素的组成元素，对所有生命都不可或缺。工业用途包括制造火药和硫酸。"
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/carbon
	name = "Carbon"
	localized_name = "碳"
	id = "carbon"
	description = "原子序数为 6 的化学元素。含量十分丰富，存在于所有已知有机生命及超过半数的已知化合物中。可用作燃料，还用于炼钢、纳米技术及许多其他工业领域。"
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0
	chemfiresupp = TRUE
	durationmod = 1
	burncolor = "#ffd700"
	burncolormod = 3
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/carbon/reaction_turf(turf/T, volume)
	src = null
	if(!istype(T, /turf/open/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if(!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume*30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha+volume*30, 255)

/datum/reagent/chlorine
	name = "Chlorine"
	localized_name = "氯气"
	id = "chlorine"
	description = "原子序数为 17 的化学元素。高浓度氯单质活性很高，对所有生物都有毒，氯气曾被用作化学战剂。工业上用于生产消毒剂、药品、塑料及净化水。"
	reagent_state = GAS
	color = COLOR_GRAY
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_BIOCIDIC = 1)

/datum/reagent/fluorine
	name = "Fluorine"
	localized_name = "氟气"
	id = "fluorine"
	description = "原子序数为 9 的化学元素，标准条件下是活性很高、剧毒的淡黄色气体。主要用于医疗和牙科领域。"
	reagent_state = GAS
	color = COLOR_GRAY
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_NEUTRALIZING = 1)

/datum/reagent/sodium
	name = "Sodium"
	localized_name = "钠"
	id = "sodium"
	description = "原子序数为 11 的化学元素。纯钠是质软且活性很高的金属，氯化钠、碳酸氢钠等多种盐类都含有钠。钠盐的用途比金属钠更广。"
	reagent_state = SOLID
	color = COLOR_GRAY
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/phosphorus
	name = "Phosphorus"
	localized_name = "磷"
	id = "phosphorus"
	description = "原子序数为 15 的化学元素，活性很高。作为 DNA、RNA 和 ATP 的组成元素，对生命不可或缺。白磷因易燃并能产生烟雾，被用于多种曳光弹和燃烧弹药。"
	reagent_state = SOLID
	color = "#832828" // rgb: 131, 40, 40
	chemfiresupp = TRUE
	intensitymod = 1
	durationmod = 0.1
	radiusmod = -0.12
	burncolor = "#ffdba4"
	burncolormod = 5
	chemclass = CHEM_CLASS_BASIC

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/lithium
	name = "Lithium"
	localized_name = "锂"
	id = "lithium"
	description = "原子序数为 3 的化学元素，是常用于电池生产的软质碱金属。活性很高且易燃，也用于抗抑郁和治疗双相情感障碍。"
	reagent_state = SOLID
	color = COLOR_GRAY
	chemfiresupp = TRUE
	intensitymod = 0.15
	rangefire = 2
	durationfire = BURN_TIME_TIER_1-5
	burncolor = "#ff356f"
	burncolormod = 5
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_OXIDIZING = 1, PROPERTY_PSYCHOSTIMULATING = 1)

/datum/reagent/sugar
	name = "Sugar"
	localized_name = "糖"
	id = "sugar"
	description = "俗称食糖、也称蔗糖的有机化合物，是无臭的白色结晶粉末，具有怡人的甜味。最简单的糖——葡萄糖，是没有线粒体的红细胞唯一能利用的营养物质。因此糖可作为营养来源促进血液再生，但效率较低。"
	reagent_state = SOLID
	color = COLOR_WHITE
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_NUTRITIOUS = 1)
	flags = REAGENT_TYPE_MEDICAL

/datum/reagent/cornsyrup
	name = "High-Fructose Corn Syrup"
	localized_name = "高果糖玉米糖浆"
	id = "cornsyrup"
	description = "啊，经典的纯美式高果糖玉米糖浆，甜得发腻。能吃进身体里而又比它更糟的东西当然有，但其中没几种原本就是拿来吃的。"
	color = "#593512" // rgb: 89, 53, 18
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_NUTRITIOUS = 1)

/datum/reagent/sucralose
	name = "Sucralose"
	localized_name = "三氯蔗糖"
	id = "sucralose"
	description = "甜度是糖的 600 倍，却没有热量！"
	color = "#FFFFFF" // rgb: 255, 255, 255
	chemclass = CHEM_CLASS_NONE

/datum/reagent/glycerol
	name = "Glycerol"
	localized_name = "甘油"
	id = "glycerol"
	description = "一种简单的多元醇化合物，味甜且毒性较低，常用于药品和饮料，也用于制造塑料、硝化甘油及其他炸药。"
	reagent_state = LIQUID
	color = COLOR_GRAY
	chemclass = CHEM_CLASS_RARE

	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)

/datum/reagent/radium
	name = "Radium"
	localized_name = "镭"
	id = "radium"
	description = "原子序数为 88 的化学元素，是放射性很强的金属，衰变时释放 α 和 γ 射线。接触镭可能导致癌症及其他疾病。"
	reagent_state = SOLID
	color = "#C7C7C7" // rgb: 199,199,199
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_CARCINOGENIC = 2, PROPERTY_HEMORRAGING = 1)

/datum/reagent/thermite
	name = "Thermite"
	localized_name = "铝热剂"
	id = "thermite"
	description = "由粉状氧化铁组成的烟火混合物，是极不稳定的爆炸物。用于手榴弹、燃烧弹、焊接及矿石加工。"
	reagent_state = SOLID
	color = "#673910" // rgb: 103, 57, 16
	chemfiresupp = TRUE
	burncolor = "#ffb300"
	explosive = TRUE
	power = 0.5
	falloff_modifier = 1
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_FUELING = 7, PROPERTY_OXIDIZING = 5, PROPERTY_VISCOUS = 4, PROPERTY_CORROSIVE = 2)

/datum/reagent/thermite/reaction_turf(turf/T, volume)
	src = null
	if(istype(T, /turf/closed/wall))
		var/turf/closed/wall/W = T
		W.thermite += volume
		W.overlays += image('icons/effects/effects.dmi',icon_state = "#673910")

/datum/reagent/virus_food
	name = "Virus Food"
	localized_name = "病毒营养液"
	id = "virusfood"
	description = "水、牛奶和氧气的混合物，病毒细胞可利用它繁殖。"
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#899613" // rgb: 137, 150, 19
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/iron
	name = "Iron"
	localized_name = "铁"
	id = "iron"
	description = "原子序数为 26 的化学元素，在众多行业中用途广泛，尤其是工程和建筑。铁是血红蛋白的重要组成元素，后者负责在红细胞中携带氧气。过量摄入铁具有极强的毒性。"
	reagent_state = SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_HEMOGENIC = 3)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_SCANNABLE

/datum/reagent/gold
	name = "Gold"
	localized_name = "金"
	id = "gold"
	description = "原子序数为 79 的化学元素。密度高、质软且有光泽，是已知延展性最强的金属，广泛用于电子、珠宝和医疗等行业。"
	reagent_state = SOLID
	color = "#F7C430" // rgb: 247, 196, 48
	chemclass = CHEM_CLASS_RARE

/datum/reagent/silver
	name = "Silver"
	localized_name = "银"
	id = "silver"
	description = "原子序数为 47 的化学元素，是质软、有光泽的白色过渡金属。在所有元素中导电性最高，在所有金属中导热性最高。"
	reagent_state = SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208
	chemclass = CHEM_CLASS_RARE

/datum/reagent/uranium
	name ="Uranium"
	localized_name = "铀"
	id = "uranium"
	description = "原子序数为 92 的化学元素，是锕系中的银白色金属，具有弱放射性。历史上被用于核能发电和制造核弹。"
	reagent_state = SOLID
	color = "#B8B8C0" // rgb: 184, 184, 192
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_CARCINOGENIC = 2)

/datum/reagent/uranium/reaction_turf(turf/T, volume)
	src = null
	if(volume >= 3)
		if(!istype(T, /turf/open/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)

/datum/reagent/aluminum
	name = "Aluminum"
	localized_name = "铝"
	id = "aluminum"
	description = "原子序数为 13 的化学元素，属于硼族的银白色软金属。由于密度低，常用作飞机结构材料。"
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	chemclass = CHEM_CLASS_BASIC

/datum/reagent/silicon
	name = "Silicon"
	localized_name = "硅"
	id = "silicon"
	description = "原子序数为 14 的化学元素，常在电子设备中用作半导体，也是沙和玻璃的主要组成元素。"
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	chemclass = CHEM_CLASS_BASIC

/datum/reagent/fuel
	name = "Welding fuel"
	localized_name = "焊接燃料"
	id = "fuel"
	description = "工业级液态喷灯燃料。"
	reagent_state = LIQUID
	color = "#660000" // rgb: 102, 0, 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemfiresupp = TRUE
	//------------------//
	intensityfire = BURN_LEVEL_TIER_1
	durationfire = BURN_TIME_TIER_1
	burn_sprite = "red"
	rangefire = 4
	//------------------//
	explosive = TRUE
	power = 0.12
	falloff_modifier = -0.1
	burncolor = "#ff9900"
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_FUELING = 5, PROPERTY_OXIDIZING = 3, PROPERTY_VISCOUS = 4, PROPERTY_TOXIC = 1)

/datum/reagent/space_cleaner
	name = "Space cleaner"
	localized_name = "太空清洁剂"
	id = "cleaner"
	description = "一种挥发迅速、又不像水那样湿滑的合成清洁剂，因此常用于太空和低重力环境的清洁。对物体表面灭菌十分有效。"
	reagent_state = LIQUID
	color = "#A5F0EE" // rgb: 165, 240, 238
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/space_cleaner/reaction_obj(obj/O, volume)
	if(istype(O, /obj/effect/decal/cleanable))
		var/obj/effect/decal/cleanable/C = O
		C.cleanup_cleanable()
	else if(O)
		O.clean_blood()

/datum/reagent/space_cleaner/reaction_turf(turf/T, volume)
	if(volume >= 1 && istype(T))
		T.clean_cleanables()

/datum/reagent/space_cleaner/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.r_hand)
			C.r_hand.clean_blood()
		if(C.l_hand)
			C.l_hand.clean_blood()
		if(C.wear_mask)
			if(C.wear_mask.clean_blood())
				C.update_inv_wear_mask(0)
		if(ishuman(M))
			var/mob/living/carbon/human/H = C
			if(H.head)
				if(H.head.clean_blood())
					H.update_inv_head(0)
			if(H.wear_suit)
				if(H.wear_suit.clean_blood())
					H.update_inv_wear_suit(0)
			else if(H.w_uniform)
				if(H.w_uniform.clean_blood())
					H.update_inv_w_uniform(0)
			if(H.shoes)
				if(H.shoes.clean_blood())
					H.update_inv_shoes(0)
			else
				H.clean_blood(1)
				return
		M.clean_blood()

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	localized_name = "隐生素"
	id = "cryptobiolin"
	description = "制造太空西林的原料之一。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/impedrezene
	name = "Impedrezene"
	localized_name = "阻神嗪"
	id = "impedrezene"
	description = "一种通过减缓高级脑细胞功能来抑制神经活动的麻醉药，可能造成严重脑损伤。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEUROTOXIC = 2, PROPERTY_RELAXING = 1)

//*****************************************************************************************************/

/datum/reagent/oxidizing_agent
	name = "Oxidizing Agent"
	localized_name = "氧化剂"
	id = "oxidizing_agent"
	description = "合成的高纯度氧化剂，人类食用后极有可能严重损害健康。"
	reagent_state = GAS
	color = "#c4c4c4"
	chemfiresupp = TRUE
	properties = list(PROPERTY_OXIDIZING = 6)
	intensitymod = 1
	radiusmod = -0.12
	burncolor = "#a9ecff"
	burncolormod = 2
	chemclass = CHEM_CLASS_RARE
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	flags = REAGENT_NO_GENERATION

/datum/reagent/xenomicrobes
	name = "Xenomicrobes"
	localized_name = "异星微生物"
	id = "xenomicrobes"
	description = "细胞结构完全异于地球生命的微生物。"
	reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102

/datum/reagent/xenomicrobes/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	src = null
	if((prob(10) && method==TOUCH) || method==INGEST)
		M.contract_disease(new /datum/disease/xeno_transformation(0),1)

/datum/reagent/fluorosurfactant//foam precursor
	name = "Fluorosurfactant"
	localized_name = "含氟表面活性剂"
	id = "fluorosurfactant"
	description = "一种全氟化磺酸，与水混合后会形成泡沫。"
	reagent_state = LIQUID
	color = "#9E6B38" // rgb: 158, 107, 56
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/foaming_agent// Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	localized_name = "发泡剂"
	id = "foaming_agent"
	description = "与轻金属和强酸混合后会产生金属泡沫的制剂。"
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/foaming_agent/stabilized
	name = "Stabilized metallic foam"
	localized_name = "稳定金属泡沫"
	id = "stablefoam"
	description = "遇到明火便会凝固的稳定金属泡沫。"
	reagent_state = LIQUID
	color = "#d4b8d1"
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 8)

/datum/reagent/nicotine
	name = "Nicotine"
	localized_name = "尼古丁"
	id = "nicotine"
	description = "从烟草中提取的合法兴奋剂，成瘾性很高，是最常被滥用的药物之一。"
	reagent_state = LIQUID
	color = "#181818" // rgb: 24, 24, 24
	chemclass = CHEM_CLASS_RARE
	flags = REAGENT_SCANNABLE

/datum/reagent/ammonia
	name = "Ammonia"
	localized_name = "氨"
	id = "ammonia"
	description = "具有腐蚀性的物质，常用于肥料或家用清洁剂。"
	reagent_state = GAS
	color = "#404030" // rgb: 64, 64, 48
	chemclass = CHEM_CLASS_COMMON

/datum/reagent/hexamine
	name = "Hexamine"
	localized_name = "六亚甲基四胺"
	id = "hexamine"
	description = "用途广泛的结晶化合物，可用作食品添加剂、塑料原料、尿路感染治疗药物、军用口粮的无烟加热剂，以及多种炸药的原料。"
	reagent_state = SOLID
	color = "#F0F0F0"
	chemfiresupp = TRUE
	durationmod = 0.5
	burncolor = "#ff9900"
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/ultraglue
	name = "Ultra Glue"
	localized_name = "超强胶"
	id = "glue"
	description = "黏合力极强的胶黏剂。"
	color = "#FFFFCC" // rgb: 255, 255, 204

/datum/reagent/diethylamine
	name = "Diethylamine"
	localized_name = "二乙胺"
	id = "diethylamine"
	description = "用作高效肥料及氨的替代品，也用于制备橡胶加工助剂、农用化学品和药品。"
	reagent_state = LIQUID
	color = "#604030" // rgb: 96, 64, 48
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/blackgoo
	name = "Black goo"
	localized_name = "黑色黏液"
	id = "blackgoo"
	description = "一种奇异的深色液体，来源和作用均不明。"
	reagent_state = LIQUID
	color = "#222222"
	custom_metabolism = 100 //disappears immediately
	properties = list(PROPERTY_RAVENING = 1)

/datum/reagent/blackgoo/reaction_mob(mob/M, method=TOUCH, volume, permeable)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name == "Human")
			H.contract_disease(new /datum/disease/black_goo)

/datum/reagent/blackgoo/reaction_turf(turf/T, volume)
	if(!istype(T)) return
	if(volume < 3) return
	if(!(locate(/obj/effect/decal/cleanable/blackgoo) in T))
		new /obj/effect/decal/cleanable/blackgoo(T)


// Chemfire supplements

/datum/reagent/napalm
	name = "Napalm"
	localized_name = "凝固汽油"
	id = "napalm"
	description = "你还没来得及读完这句，它大概就燃起来了。"
	reagent_state = LIQUID
	color = "#ffb300"
	chemfiresupp = TRUE
	burncolor = "#D05006"
	burn_sprite = "red"
	properties = list(PROPERTY_OXIDIZING = 6, PROPERTY_FUELING = 7, PROPERTY_FLOWING = 1)

/datum/reagent/napalm/sticky
	name = "Sticky-Napalm"
	localized_name = "高黏凝固汽油"
	id = "stickynapalm"
	description = "特调凝固汽油，黏附性更强、持续时间更长，但伤害较低。"
	reagent_state = LIQUID
	color = "#f8e3b2"
	burncolor = "#f8e3b2"
	burn_sprite = "dynamic"
	intensitymod = -1.5
	durationmod = -5
	radiusmod = -0.5
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_2,
		PROPERTY_DURATION = BURN_TIME_TIER_5,
		PROPERTY_RADIUS = 5,
	)

/datum/reagent/napalm/high_damage
	name = "High-Combustion Napalm Fuel"
	localized_name = "高强度凝固汽油燃料"
	id = "highdamagenapalm"
	description = "特调凝固汽油，伤害更高，但黏附性较弱。"
	reagent_state = LIQUID
	color = "#c51c1c"
	burncolor = "#c51c1c"
	burn_sprite = "dynamic"
	intensitymod = -4.5
	durationmod = -1
	radiusmod = -0.5
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_8,
		PROPERTY_DURATION = BURN_TIME_TIER_1,
		PROPERTY_RADIUS = 5,
	)

// Weak flame for scaring marines without instantkilling them
/datum/reagent/napalm/weak
	name = "Impure Napalm"
	localized_name = "低纯度凝固汽油"
	id = "weaknapalm"
	description = "含杂质的凝固汽油，因此燃烧温度较低，通常用于火焰喷射器。"
	burncolor = "#e49320"
	burn_sprite = "dynamic"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_2,
		PROPERTY_DURATION = BURN_TIME_TIER_2,
		PROPERTY_RADIUS = 5,
	)

// This is the regular flamer fuel and pyro regular flamer fuel.
/datum/reagent/napalm/ut
	name = "UT-Napthal Fuel"
	localized_name = "UT-Napthal燃料"
	id = "utnapthal"
	description = "全称为超稠 Napthal 燃料，是黏稠的易燃液态化学品，通常用于火焰喷射器。"
	burncolor = "#EE6515"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_5,
		PROPERTY_DURATION = BURN_TIME_TIER_2,
		PROPERTY_RADIUS = 5,
	)

// This is gellie fuel. Green Flames.
/datum/reagent/napalm/gel
	name = "Napalm B-Gel"
	localized_name = "B型凝固汽油"
	id = "napalmgel"
	description = "与液态配方不同，这种凝胶型凝固汽油很容易被扑灭，但喷射距离远，会黏稠地滞留在地面，并与无机材料反应将其点燃。"
	flameshape = FLAMESHAPE_LINE
	color = COLOR_GREEN
	burncolor = COLOR_GREEN
	burn_sprite = "green"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_2,
		PROPERTY_DURATION = BURN_TIME_TIER_5,
		PROPERTY_RADIUS = 7,
	)
	fire_type = FIRE_VARIANT_TYPE_B //Armor Shredding Greenfire

// This is the blue flamer fuel for the pyro.
/datum/reagent/napalm/blue
	name = "Napalm X"
	localized_name = "X型凝固汽油"
	id = "napalmx"
	description = "一种黏稠的易燃液态化学品，燃烧温度极高。"
	color = "#00b8ff"
	burncolor = "#00b8ff"
	burn_sprite = "blue"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_7,
		PROPERTY_DURATION = BURN_TIME_TIER_4,
		PROPERTY_RADIUS = 6,
	)

// This is the green flamer fuel for the pyro.
/datum/reagent/napalm/green
	name = "Napalm B"
	localized_name = "B型凝固汽油（扩散型）"
	id = "napalmb"
	description = "一种不易黏附的特殊凝固汽油，可在大范围内散布并缓慢燃烧。其成分会与无机材料反应将其点燃，造成严重损伤。"
	flameshape = FLAMESHAPE_TRIANGLE
	color = COLOR_GREEN
	burncolor = COLOR_GREEN
	burn_sprite = "green"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_2,
		PROPERTY_DURATION = BURN_TIME_TIER_5,
		PROPERTY_RADIUS = 6,
	)
	fire_type = FIRE_VARIANT_TYPE_B //Armor Shredding Greenfire

/datum/reagent/napalm/penetrating
	name = "Napalm E"
	localized_name = "E型凝固汽油"
	id = "napalme"
	description = "一种黏稠的易燃液态化学品，能够穿透最好的阻燃防护。"
	color = COLOR_PURPLE
	burncolor = COLOR_PURPLE
	burn_sprite = "dynamic"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_2,
		PROPERTY_DURATION = BURN_TIME_TIER_5,
		PROPERTY_RADIUS = 6,
		PROPERTY_FIRE_PENETRATING = 1,
	)

/datum/reagent/napalm/deathsquad //version of fuel for dsquad flamers.
	name = "Napalm EX"
	localized_name = "EX型凝固汽油"
	id = "napalmex"
	description = "由多种稀有危险试剂混合而成的黏稠易燃液体，既能穿透最好的阻燃防护，又能以极高温度燃烧。"
	color = "#641dd6"
	burncolor = "#641dd6"
	burn_sprite = "dynamic"
	properties = list(
		PROPERTY_INTENSITY 			= BURN_LEVEL_TIER_7,
		PROPERTY_DURATION 			= BURN_TIME_TIER_4,
		PROPERTY_RADIUS 			= 6,
		PROPERTY_FIRE_PENETRATING	= 1
	)

/datum/reagent/napalm/upp
	name = "R189"
	localized_name = "R189"
	id = "R189"
	description = "进步人民联盟的化学品，燃烧温度极高，专为直接熔穿加固阵地或碉堡而设计。"
	color = "#ffe49c"
	burncolor = "#ffe49c"
	burn_sprite = "dynamic"
	properties = list(
		PROPERTY_INTENSITY = BURN_LEVEL_TIER_9,
		PROPERTY_DURATION = BURN_TIME_TIER_3,
		PROPERTY_RADIUS = 6,
		PROPERTY_FIRE_PENETRATING = 1,
	)

/datum/reagent/chlorinetrifluoride
	name = "Chlorine Trifluoride"
	localized_name = "三氟化氯"
	id = "chlorine trifluoride"
	description = "活性极高、能够自燃的卤素互化物，是极强的氧化剂，会与大多数有机和无机材料剧烈反应。"
	reagent_state = LIQUID
	color = COLOR_CYAN
	custom_metabolism = 100
	chemfiresupp = TRUE
	burncolor = "#ff9300"
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CORROSIVE = 8, PROPERTY_TOXIC = 6, PROPERTY_OXIDIZING = 9)

/datum/reagent/chlorinetrifluoride/on_mob_life(mob/living/M) // Not a good idea, instantly messes you up from the inside out.
	. = ..()
	M.adjust_fire_stacks(max(M.fire_stacks, 15))
	M.IgniteMob(TRUE)
	to_chat(M, SPAN_DANGER("好烫！这灼痛远远超出了你的想象！"))

/datum/reagent/methane
	name = "Methane"
	localized_name = "甲烷"
	id = "methane"
	description = "易燃的碳氢化合物，能迅速扩大火势，在适当浓度下甚至会爆炸。主要用作供热、照明燃料及制造有机化学品的原料。"
	reagent_state = LIQUID
	color = "#0064C8"
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)
	chemfiresupp = TRUE
	burncolor = "#00a5ff"
	burncolormod = 1.5
	explosive = TRUE
	power = 0.15
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_TOXIC = 2, PROPERTY_FLOWING = 3, PROPERTY_VISCOUS = 3, PROPERTY_FUELING = 2)

//*****************************************************************************************************/
//*****************************************Explosives**************************************************/
//*****************************************************************************************************/

/datum/reagent/potassium_hydroxide
	name = "Potassium hydroxide"
	localized_name = "氢氧化钾"
	id = "potassium_hydroxide"
	description = "你还没来得及读完这句，它大概就炸了。"
	explosive = TRUE
	power = 0.5

/datum/reagent/ammoniumnitrate
	name = "Ammonium Nitrate"
	localized_name = "硝酸铵"
	id = "ammonium_nitrate"
	description = "一种白色结晶化合物，在农业中用作高氮肥料。硝酸铵本身并不具有爆炸性，但与燃料油混合后很快便会具有爆炸性。"
	reagent_state = SOLID
	color = "#E5E5E5"
	explosive = TRUE
	power = 0.4
	falloff_modifier = 1.5
	chemfiresupp = TRUE
	durationmod = -0.2
	intensitymod = 0.5
	burncolor = "#ff9900"

/datum/reagent/anfo
	name = "Ammonium nitrate fuel oil"
	localized_name = "铵油炸药"
	id = "anfo"
	color = "#E0E0E0"
	description = "铵油炸药（ANFO）是低成本的散装炸药，常用于采矿和建筑作业。"
	explosive = TRUE
	power = 1
	falloff_modifier = -0.6

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	localized_name = "硝化甘油"
	id = "nitroglycerin"
	description = "通过对甘油进行硝化制得的重质、无色、油状爆炸性液体。虽然极不稳定，却具有许多医疗用途。"
	reagent_state = LIQUID
	color = COLOR_GRAY
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	explosive = TRUE
	power = 1
	falloff_modifier = -0.5

/datum/reagent/cyclonite
	name = "Cyclonite"
	localized_name = "黑索金"
	id = "cyclonite"
	description = "一种低感度高爆化合物，常称 RDX，被认为是能量最高的军用烈性炸药之一。有时也被民间用作鼠药。"
	reagent_state = SOLID
	color = "#E3E0BA"
	explosive = TRUE
	power = 1.5
	falloff_modifier = -0.4

/datum/reagent/cyclonite/on_mob_life(mob/living/M)
	. = ..()
	M.apply_damage(1, TOX)

/datum/reagent/octogen
	name = "Octogen"
	localized_name = "奥克托今"
	id = "octogen"
	description = "又称 HMX 或“女王陛下的炸药”，威力强大且相对不敏感。它是威力最强的化学炸药之一，超过黑索金（RDX）。"
	reagent_state = SOLID
	color = "#F5F5F5"
	explosive = TRUE
	power = 2
	falloff_modifier = -0.2
	chemfiresupp = TRUE
	properties = list(PROPERTY_OXIDIZING = 2)

//*****************************************************************************************************/
//****************************************Blood plasmas************************************************/
//*****************************************************************************************************/

/datum/reagent/plasma
	name = "plasma"
	localized_name = "血浆"
	id = "plasma"
	description = "从血液中分离出的透明细胞外液。"
	reagent_state = LIQUID
	color = "#f1e8cf"
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)

/datum/reagent/plasma/pheromone
	name = "Pheromone Plasma"
	localized_name = "信息素血浆"
	id = PLASMA_PHEROMONE
	description = "气味古怪的血浆……"
	color = "#a2e7d6"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_HALLUCINOGENIC = 8, PROPERTY_NERVESTIMULATING = 6)

/datum/reagent/plasma/chitin
	name = "Chitin Plasma"
	localized_name = "几丁质血浆"
	id = PLASMA_CHITIN
	description = "十分浓稠的纤维状血浆……"
	color = "#6d7694"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_HYPERDENSIFICATING = 1)

/datum/reagent/plasma/catecholamine
	name = "Catecholamine Plasma"
	localized_name = "儿茶酚胺血浆"
	id = PLASMA_CATECHOLAMINE
	description = "略带红色的血浆……"
	color = "#cf7551"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_PAINING = 2, PROPERTY_MUSCLESTIMULATING = 6)

/datum/reagent/plasma/egg
	name = "Egg Plasma"
	localized_name = "卵质血浆"
	id = PLASMA_EGG
	description = "略带白色、蛋白质浓度很高的血浆……"
	color = "#c3c371"
	overdose = 80
	overdose_critical = 100
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_HEMOSITIC = 4)

/datum/reagent/plasma/egg/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if((locate(/obj/item/alien_embryo) in H.contents) || (H.species.flags & IS_SYNTHETIC) || !H.huggable)
			volume = 0
			return
		if(volume < overdose_critical)
			return
		//it turns into an actual embryo at this point
		volume = 0
		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
		if(data_properties && data_properties["hive_number"])
			embryo.hivenumber = data_properties["hive_number"]
		else
			embryo.hivenumber = XENO_HIVE_NORMAL
		to_chat(H, SPAN_WARNING("你的腹部一阵绞痛，突然感到十分难受！"))

/datum/reagent/plasma/neurotoxin
	name = "Neurotoxin Plasma"
	localized_name = "神经毒素血浆"
	id = PLASMA_NEUROTOXIN
	description = "含有未知强效神经毒素的血浆。"
	color = "#ba8216"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_NEUROTOXIC = 4, PROPERTY_TOXIC = 1, PROPERTY_HALLUCINOGENIC = 6)

/datum/reagent/plasma/antineurotoxin
	name = "Anti-Neurotoxin"
	localized_name = "神经毒素拮抗剂"
	id = "antineurotoxin"
	description = "用于对抗神经毒素血浆的药剂。"
	color = "#afffc9"
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_MEDIUM_VALUE
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_NEUROSHIELDING = 1)

/datum/reagent/plasma/purple
	name = "Purple Plasma"
	localized_name = "紫色血浆"
	id = PLASMA_PURPLE
	description = "略带紫色的血浆……"
	color = "#a65d7f"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_BIOCIDIC = 2)

/datum/reagent/plasma/royal
	name = "Royal Plasma"
	localized_name = "皇族血浆"
	id = PLASMA_ROYAL
	description = "略带深紫色的血浆……"
	color = "#ffeb9c"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_ABSOLUTE_VALUE
	properties = list(PROPERTY_BIOCIDIC = 4, PROPERTY_ADDICTIVE = 1, PROPERTY_HALLUCINOGENIC = 4, PROPERTY_CIPHERING = 1)

/datum/reagent/fruit_resin
	name = "Fruit Resin"
	localized_name = "果实树脂"
	id = "fruit_resin"
	description = "在某些异形结构中发现的奇异绿色液体，似乎具有再生作用。"
	reagent_state = LIQUID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#12911d" // rgb: 102, 67, 48
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_TRANSFORMATIVE = 4, PROPERTY_NUTRITIOUS = 3, PROPERTY_HEMOGENIC = 1)
	flags = REAGENT_SCANNABLE
