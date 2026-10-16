
//*****************************************************************************************************/
//****************************************Poison stuff*************************************************/
//*****************************************************************************************************/

/datum/reagent/toxin
	name = "Generic Toxin"
	localized_name = "通用毒素"
	id = "toxin"
	description = "对多种相似毒素的统称，有时会作为化学反应的副产物生成。"
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = AMOUNT_PER_TIME(1, 20 SECONDS)
	properties = list(PROPERTY_TOXIC = 1)// Toxins are really weak, but without being treated, last very long.

/datum/reagent/toxin/hptoxin
	name = "Toxin"
	localized_name = "毒素"
	id = "hptoxin"
	description = "一种有毒化学物质。"
	custom_metabolism = AMOUNT_PER_TIME(1, 2 SECONDS)

/datum/reagent/toxin/pttoxin
	name = "Toxin"
	localized_name = "毒素"
	id = "pttoxin"
	description = "一种有毒化学物质。"
	custom_metabolism = AMOUNT_PER_TIME(1, 2 SECONDS)

/datum/reagent/toxin/sdtoxin
	name = "Toxin"
	localized_name = "毒素"
	id = "sdtoxin"
	description = "一种有毒化学物质。"
	properties = list(PROPERTY_HYPOXEMIC = 2)

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	localized_name = "鹅膏毒素"
	id = "amatoxin"
	description = "从某些蘑菇中提取的强力毒素。"
	reagent_state = LIQUID
	color = "#792300" // rgb: 121, 35, 0
	chemclass = CHEM_CLASS_RARE

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	localized_name = "不稳定诱变剂"
	id = "mutagen"
	description = "用于实验植物学的诱变化合物。可使植物发生不可预测的突变，但对人类具有极强的致死性。请置于儿童无法接触的地方。"
	reagent_state = LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CARCINOGENIC = 1)

/datum/reagent/toxin/phoron
	name = "Phoron"
	localized_name = "弗燃素"
	id = "phoron"
	description = "一种地球上不存在的特殊金属等离子体。弗燃素高度易燃且毒性极强，但其高能量密度使其成为替代固体燃料的优选。液态弗燃素常用于科研，在医药工业中也可用作多种高级化学品的催化剂。"
	reagent_state = LIQUID
	color = "#E71B00" // rgb: 231, 27, 0
	chemfiresupp = TRUE
	intensitymod = 0.4
	durationmod = -0.8
	radiusmod = 0.05
	burncolor = "#e01e1e"
	burncolormod = 3
	chemclass = CHEM_CLASS_RARE

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	localized_name = "勒克索林"
	id = "lexorin"
	description = "勒克索林是一种极其危险的化合物，会损伤组织并麻痹肺部，使呼吸停止。即使少量也可能致命。各类右氧林配方均能有效解除其中毒。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HYPOXEMIC = 8, PROPERTY_BIOCIDIC = 1)

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	localized_name = "氰化物"
	id = "cyanide"
	description = "一种天然存在的有毒化学物质，因起效迅速，数百年来一直被用作致命毒物。中毒症状包括恶心、虚弱和呼吸困难。"
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPOXEMIC = 4, PROPERTY_SEDATIVE = 1)

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	localized_name = "薄荷毒素"
	id = "minttoxin"
	description = "用来对付不受欢迎的顾客很有效。"
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	flags = REAGENT_NO_GENERATION

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	localized_name = "太空鲤鱼毒素"
	id = "carpotoxin"
	description = "由可怕的太空鲤鱼产生的致命神经毒素。"
	reagent_state = LIQUID
	color = "#003333" // rgb: 0, 51, 51
	properties = list(PROPERTY_TOXIC = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	localized_name = "假死粉"
	id = "zombiepowder"
	description = "使目标陷入假死状态的强效神经毒素。"
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	properties = list()
	flags = REAGENT_NO_GENERATION

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!. || deleted)
		return
	M.status_flags |= FAKEDEATH
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, FAKEDEATH_TRAIT)
	M.apply_damage(0.5*REM, OXY)
	M.KnockDown(2)
	M.Stun(2)
	M.silent = max(M.silent, 10)

/datum/reagent/toxin/zombiepowder/on_delete()
	. = ..()
	if(!.)
		return

	var/mob/living/holder_mob = .

	holder_mob.status_flags &= ~FAKEDEATH
	REMOVE_TRAIT(holder_mob, TRAIT_IMMOBILIZED, FAKEDEATH_TRAIT)

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	localized_name = "摧心毒素"
	id = "mindbreaker"
	description = "太空法律禁止的强力致幻化合物，可引发极其强烈的幻觉，且成瘾性很高。旧称 LSD。"
	reagent_state = LIQUID
	color = "#B31008" // rgb: 139, 166, 233
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HALLUCINOGENIC = 8)

//Reagents used for plant fertilizers.
/datum/reagent/toxin/fertilizer
	name = "fertilizer"
	localized_name = "肥料"
	id = "fertilizer"
	description = "工业级无机植物肥料。"
	reagent_state = LIQUID
	color = "#664330" // rgb: 102, 67, 48
	properties = list(PROPERTY_TOXIC = 0.5)

/datum/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"
	localized_name = "易养营养液"
	id = "eznutrient"

/datum/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"
	localized_name = "求生突变肥"
	id = "left4zed"

/datum/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"
	localized_name = "丰收壮苗肥"
	id = "robustharvest"

/datum/reagent/toxin/dinitroaniline
	name = "Dinitroaniline"
	localized_name = "二硝基苯胺"
	id = "dinitroaniline"
	description = "二硝基苯胺类化合物在工业上用于生产杀虫剂和除草剂。"
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	localized_name = "植株净除剂"
	id = "plantbgone"
	description = "用于杀死植物的有害混合药剂，对动物也具有很强的毒性。"
	reagent_state = LIQUID
	color = "#49002E" // rgb: 73, 0, 46
	properties = list(PROPERTY_TOXIC = 2)

/datum/reagent/toxin/stoxin
	name = "Soporific"
	localized_name = "催眠剂"
	id = "stoxin"
	description = "用于治疗失眠的有效催眠药，浓缩后可用作手术麻醉剂。"
	reagent_state = LIQUID
	color = "#E895CC" // rgb: 232, 149, 204
	custom_metabolism = AMOUNT_PER_TIME(1, 20 SECONDS)
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_SEDATIVE = 2, PROPERTY_PAINKILLING = 10)
	flags = REAGENT_SCANNABLE

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	localized_name = "水合氯醛"
	id = "chloralhydrate"
	description = "最早人工合成的镇静催眠药。作为强效镇静剂，几乎能立即使人产生睡意，但大量使用可能致命。手术中常与其他麻醉剂配合使用。"
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	custom_metabolism = AMOUNT_PER_TIME(1, 20 SECONDS) //Default 0.2
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_SEDATIVE = 6)

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	localized_name = "氯化钾"
	id = "potassium_chloride"
	description = "一种味苦的盐，可用作调味料，但大量使用会导致心搏骤停，因此多年来也被用作注射死刑药物的成分。"
	reagent_state = SOLID
	color = COLOR_WHITE
	chemfiresupp = TRUE
	intensitymod = 0.1
	burncolor = COLOR_PURPLE
	burncolormod = 5
	overdose = 30
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HYPOXEMIC = 2, PROPERTY_RELAXING = 4)

/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	localized_name = "氯弗酸钾"
	id = "potassium_chlorophoride"
	description = "一种以氯化钾为基础制成的特殊化学品，用于手术中停止心跳，可立即引发心搏骤停。不可食用！"
	reagent_state = SOLID
	color = COLOR_WHITE
	overdose = 20
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_RELAXING = 8, PROPERTY_HYPOXEMIC = 4, PROPERTY_TOXIC = 2)

/datum/reagent/toxin/beer2 //disguised as normal beer for use by emagged brobots
	name = "Beer"
	localized_name = "啤酒"
	id = "beer2"
	description = "以发芽谷物、啤酒花、酵母和水酿造的酒精饮料，似乎尚未完全发酵。" //If the players manage to analyze this, they deserve to know something is wrong.
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	custom_metabolism = AMOUNT_PER_TIME(3, 40 SECONDS) // Sleep toxins should always be consumed pretty fast
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_TOXIC = 6)

/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	localized_name = "硫酸"
	id = "sulphuric acid"
	description = "一种常见且腐蚀性很强的无机酸，广泛用于工业。"
	reagent_state = LIQUID
	spray_warning = TRUE
	color = "#DB5008" // rgb: 219, 80, 8
	var/meltprob = 10
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_CORROSIVE = 3)

/datum/reagent/toxin/acid/polyacid
	name = "Polytrinic acid"
	localized_name = "聚三酸"
	id = "pacid"
	description = "腐蚀性极强的酸，能够迅速溶解多种材料。"
	reagent_state = LIQUID
	spray_warning = TRUE
	color = "#8E18A9" // rgb: 142, 24, 169
	meltprob = 30
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 2, PROPERTY_CORROSIVE = 3)

/datum/reagent/toxin/formaldehyde
	name = "Formaldehyde"
	localized_name = "甲醛"
	id = "formaldehyde"
	description = "有毒的有机气体，主要用于制造树脂、聚合物和炸药，已知是一种天然致癌物。"
	color = COLOR_GRAY
	reagent_state = GAS
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_CARCINOGENIC = 1)

/datum/reagent/toxin/paraformaldehyde
	name = "Paraformaldehyde"
	localized_name = "多聚甲醛"
	id = "paraformaldehyde"
	description = "甲醛的聚合物，在低温水溶液中缓慢形成。"
	color = "#E0E0E0"
	reagent_state = SOLID
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 1)

/datum/reagent/toxin/molecular_acid
	name = "Diluted Molecular Acid"
	localized_name = "稀释分子酸"
	id = "molecularacid"
	description = "一种成分不明的酸。这份样本似乎没有异形血液中的酸那么危险。"
	color = "#669900"
	reagent_state = LIQUID
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_CORROSIVE = 2, PROPERTY_TOXIC = 1, PROPERTY_CROSSMETABOLIZING = 3)

/datum/reagent/toxin/cia_toxin
	name = "'Clear Snow'"
	localized_name = "“清雪”"
	id = "cia_toxin"
	description = "一种强效血液毒素，据称 CIA 使用过。不过，这帮人的事谁又能说得准呢。"
	color = "#FF69B4"
	reagent_state = LIQUID
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_TOXIC = 6)
	flags = REAGENT_NO_GENERATION

/datum/reagent/toxin/mss_toxin
	name = "A-580"
	localized_name = "A-580"
	id = "mss_toxin"
	description = "一种强效神经毒剂，据称 MSS 使用过。"
	color = "#AFEEEE"
	reagent_state = LIQUID
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_TOXIC = 3, PROPERTY_HYPOXEMIC = 4)
	flags = REAGENT_NO_GENERATION
