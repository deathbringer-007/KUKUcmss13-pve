// All reagents related to medicine

/datum/reagent/medical
	flags = REAGENT_TYPE_MEDICAL | REAGENT_SCANNABLE

/datum/reagent/medical/inaprovaline
	name = "Inaprovaline"
	localized_name = "因纳普罗伐林"
	id = "inaprovaline"
	description = "因纳普罗伐林是一种突触兴奋剂和强心剂，常用于稳定患者状态。只要肺部功能正常，它就能让患者在心搏骤停时继续呼吸，还能减缓出血并提供轻微镇痛。过量使用可能严重损伤心脏组织。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = HIGH_REAGENTS_OVERDOSE
	overdose_critical = HIGH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_CARDIOSTABILIZING = 3)

/datum/reagent/medical/ryetalyn
	name = "Ryetalyn"
	localized_name = "基因修复素"
	id = "ryetalyn"
	description = "基因修复素通过催化过程修复遗传缺陷、突变和异常，可用于治疗遗传性眼部及视力问题。过量使用会产生很强的毒性，并可能影响平衡感。"
	reagent_state = SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_AIDING = 2)

/datum/reagent/medical/paracetamol
	name = "Paracetamol"
	localized_name = "对乙酰氨基酚"
	id = "paracetamol"
	description = "又称泰诺，是一种自 1950 年起广泛使用、药效持久的中效止痛药。具有镇痛和退热作用，但没有抗炎作用。过量使用会产生毒性，可能引发幻觉和急性肝衰竭。"
	reagent_state = LIQUID
	color = "#C855DC"
	custom_metabolism = AMOUNT_PER_TIME(15, 10 MINUTES) // Lasts 10 minutes for 15 units
	overdose = HIGH_REAGENTS_OVERDOSE
	overdose_critical = HIGH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 2)

/datum/reagent/medical/saline
	name = "Saline Solution"
	localized_name = "盐水溶液"
	id = "saline"
	description = "由水、氯化钠和葡萄糖配制而成的溶液，用于治疗失血、轻度中毒症状或体温过高。"
	reagent_state = LIQUID
	color = COLOR_SILVER
	chemfiresupp = TRUE
	intensitymod = 0.1
	burncolor = "#ffff00"
	burncolormod = 2
	overdose = 999
	overdose_critical = 999 //customlife
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_HYPOTHERMIC = 0.5, PROPERTY_HEMOGENIC = 1, PROPERTY_ANTITOXIC = 1, PROPERTY_OXYGENATING = 1)

/datum/reagent/medical/saline/on_mob_life(mob/living/M)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/human = M
		if(volume >= 40 && prob(25))
			human.EyeBlur(3)
		if(volume >= 60 && prob(25))
			human.EyeBlur(9)
			M.make_dizzy(3)
		if(volume >= 100 && prob(25))
			human.vomit()

/datum/reagent/medical/tramadol
	name = "Tramadol"
	localized_name = "曲马多"
	id = "tramadol"
	description = "曲马多是一种中枢性镇痛药，被认为较为安全，镇痛效力据称约为吗啡的十分之一。用于治疗中度至中重度的急性和慢性疼痛。与吗啡相比，其依赖性通常较低。过量使用具有很强的毒性。"
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = AMOUNT_PER_TIME(15, 10 MINUTES) // Lasts 10 minutes for 15 units
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 5)

/datum/reagent/medical/oxycodone
	name = "Oxycodone"
	localized_name = "羟考酮"
	id = "oxycodone"
	description = "羟考酮是一种阿片受体激动剂，成瘾性与吗啡相近。获准用于治疗预计需要长期持续使用阿片类药物的中重度疼痛患者。过量使用可能引发幻觉、脑损伤和严重中毒。"
	reagent_state = LIQUID
	color = "#E01D25"
	custom_metabolism = AMOUNT_PER_TIME(15, 5 MINUTES) // Lasts 5 minutes for 15 units
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PAINKILLING = 8)

/datum/reagent/medical/sterilizine
	name = "Sterilizine"
	localized_name = "灭菌灵"
	id = "sterilizine"
	description = "用于术前清洁伤口的灭菌剂，目前大多已被更廉价的太空清洁剂取代。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/medical/leporazine
	name = "Leporazine"
	localized_name = "恒温嗪"
	id = "leporazine"
	description = "用于治疗体温过低或过高的药物，可稳定患者体温，但会使低温治疗无法进行。过量使用可能引发严重嗜睡。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_THERMOSTABILIZING = 2)

/datum/reagent/medical/kelotane
	name = "Kelotane"
	localized_name = "克洛坦"
	id = "kelotane"
	description = "用于治疗烧伤及化学腐蚀伤的常用药物。过量使用可能损伤内部组织。"
	reagent_state = LIQUID
	color = "#D8C58C"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ANTICORROSIVE = 2)

/datum/reagent/medical/dermaline
	name = "Dermaline"
	localized_name = "德玛林"
	id = "dermaline"
	description = "用于治疗严重烧伤的高级药物，可使身体修复受热损伤极其严重的组织。过量使用可能严重损伤内部组织。"
	reagent_state = LIQUID
	color = "#F8C57C"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_ANTICORROSIVE = 3)

/datum/reagent/medical/dexalin
	name = "Dexalin"
	localized_name = "右氧林"
	id = "dexalin"
	description = "右氧林通过在血液中直接向红细胞供氧来治疗缺氧，也可用于解除勒克索林中毒。"
	reagent_state = LIQUID
	color = "#C865FC"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_OXYGENATING = 4)

/datum/reagent/medical/dexalinp
	name = "Dexalin Plus"
	localized_name = "强化右氧林"
	id = "dexalinp"
	description = "右氧林的强化配方，加入铁和碳以加快氧气与红细胞中血红蛋白的结合。"
	reagent_state = LIQUID
	color = "#C8A5FC"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_OXYGENATING = 6)

/datum/reagent/medical/tricordrazine
	name = "Tricordrazine"
	localized_name = "广效康复嗪"
	id = "tricordrazine"
	description = "一种最初由康复嗪衍生而来的强效兴奋剂，可用于治疗多种损伤。"
	reagent_state = LIQUID
	color = "#B865CC"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEOGENETIC = 1, PROPERTY_ANTICORROSIVE = 1, PROPERTY_ANTITOXIC = 1, PROPERTY_OXYGENATING = 1)

/datum/reagent/medical/anti_toxin
	name = "Dylovene"
	localized_name = "迪洛文（抗毒素）"
	id = "anti_toxin"
	description = "通用抗毒药剂，可中和血液中的大多数毒素，也是许多高级化学品的常用原料。还具有轻微的抗幻觉和缓解疲劳作用。"
	reagent_state = LIQUID
	color = "#A8F59C"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ANTITOXIC = 2, PROPERTY_ANTIHALLUCINOGENIC = 2)

/datum/reagent/medical/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "A magical substance created by gods to dissolve extreme amounts of salt."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	properties = list(PROPERTY_OMNIPOTENT = 2)
	flags = REAGENT_TYPE_MEDICAL

/datum/reagent/medical/thwei //OP yautja chem
	name = "Thwei"
	localized_name = "铁血复苏液"
	id = "thwei"
	description = "一种奇异的外星液体。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_HIGH_VALUE
	properties = list(
		PROPERTY_CROSSMETABOLIZING = 1,
		PROPERTY_ANTITOXIC = 1,
		PROPERTY_YAUTJA_HEMOGENIC = 9,
		PROPERTY_OXYGENATING = 6,
		PROPERTY_ANTICARCINOGENIC = 6,
		PROPERTY_BONEMENDING = 6,
		PROPERTY_AIDING = 1,
		PROPERTY_ANTIHALLUCINOGENIC = 2,
		PROPERTY_FOCUSING = 6,
		PROPERTY_CURING = 4,
	)
	flags = REAGENT_TYPE_MEDICAL

/datum/reagent/medical/neuraline //injected by neurostimulator implant
	name = "Neuraline"
	localized_name = "神经调节素"
	id = "neuraline"
	description = "一种专门调配的复合药剂，可增强或抑制特定的神经活动。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)
	overdose = 2
	overdose_critical = 3
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NERVESTIMULATING = 5)
	flags = REAGENT_TYPE_MEDICAL

/datum/reagent/medical/arithrazine
	name = "Arithrazine"
	localized_name = "稳效抗毒嗪"
	id = "arithrazine"
	description = "迪洛文的稳定化衍生物。解毒效果较弱，并有有害副作用，但不会与其他化合物反应生成毒素。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = AMOUNT_PER_TIME(1, 40 SECONDS)
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_ANTITOXIC = 1, PROPERTY_BIOCIDIC = 1)

/datum/reagent/medical/russianred
	name = "Russian Red"
	localized_name = "俄罗斯红"
	id = "russianred"
	description = "用于紧急处理辐射损伤的药剂。潜在副作用包括视网膜损伤和失去意识。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = AMOUNT_PER_TIME(1, 2 SECONDS)
	overdose = MED_REAGENTS_OVERDOSE
	overdose_critical = MED_REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_ANTITOXIC = 4, PROPERTY_AIDING = 1, PROPERTY_BIOCIDIC = 2, PROPERTY_OCULOTOXIC = 0.5)

/datum/reagent/medical/alkysine
	name = "Alkysine"
	localized_name = "神经修复素"
	id = "alkysine"
	description = "用于减轻和修复严重创伤后的神经组织损伤，少量即可修复大范围脑部创伤，还具有极弱的镇痛作用。过量使用毒性极强。"
	reagent_state = LIQUID
	color = "#E89599"
	custom_metabolism = AMOUNT_PER_TIME(1, 40 SECONDS)
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEUROPEUTIC = 2)

/datum/reagent/medical/imidazoline
	name = "Imidazoline"
	localized_name = "咪唑啉"
	id = "imidazoline"
	description = "用于治疗非遗传性眼部创伤。在多数眼外伤病例中，通常采用此药物治疗以替代手术。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_OCULOPEUTIC = 2)

/datum/reagent/medical/peridaxon
	name = "Peridaxon"
	localized_name = "佩里达酮"
	id = "peridaxon"
	description = "在血液中存在时可抑制内脏损伤引起的症状，但不会修复器官本身。建议用于等待内脏手术的患者。过量使用会损伤内部组织。"
	reagent_state = LIQUID
	color = "#C845DC"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	custom_metabolism = AMOUNT_PER_TIME(1, 40 SECONDS)
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_ORGANSTABILIZE = 4)

/datum/reagent/medical/bicaridine // yes it cures IB, it's located in some other part of wound code for whatever reason
	name = "Bicaridine"
	localized_name = "比卡定"
	id = "bicaridine"
	description = "具有镇痛作用的药物，可治疗严重的外部钝伤并稳定患者状态。过量使用会造成化学灼伤和毒素损伤。"
	reagent_state = LIQUID
	color = "#E8756C"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_NEOGENETIC = 2)

/datum/reagent/medical/meralyne
	name = "Meralyne"
	localized_name = "美拉林"
	id = "meralyne"
	description = "用于治疗极重度钝伤的高级镇痛药，可使身体快速修复受损组织。过量使用可能严重腐蚀细胞膜。"
	reagent_state = LIQUID
	color = "#b40000"
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NEOGENETIC = 3)

/datum/reagent/medical/adrenaline
	name = "Epinephrine"
	localized_name = "肾上腺素"
	id = "adrenaline"
	description = "一种天然的肌肉和心脏兴奋剂，有助于恢复心跳。过量使用可能增加心脏负担并造成组织损伤。"
	reagent_state = LIQUID
	color = "#FFE703" // Yellow-ish
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 1.5, PROPERTY_ELECTROGENETIC = 4, PROPERTY_INTRAVENOUS = 1)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_SCANNABLE

/datum/reagent/medical/adrenaline_concentrated
	name = "Concentrated Adrenaline"
	localized_name = "浓缩肾上腺素"
	id = "adrenaline_concentrated"
	description = "高浓度的天然肌肉和心脏兴奋剂，有助于恢复心跳并防止失去意识，但浓缩配方会造成轻微缺氧。过量使用可能增加心脏负担并造成组织损伤。"
	reagent_state = LIQUID
	color = "#FFE702" // Yellow-ish
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	custom_metabolism = AMOUNT_PER_TIME(1, 10 SECONDS)
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_PAINKILLING = 10, PROPERTY_ELECTROGENETIC = 6, PROPERTY_OXYGENATING = 3, PROPERTY_REVITALIZING = 1, PROPERTY_INTRAVENOUS = 1, PROPERTY_CARDIOTOXIC = 2.5)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_SCANNABLE

/datum/reagent/medical/ultrazine
	name = "Ultrazine"
	localized_name = "超能嗪"
	id = "ultrazine"
	description = "同时作用于中枢神经系统和肌肉的强效长效复合兴奋剂，成瘾性极强。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.0167 //5 units will last approximately 10 minutes
	overdose = LOWM_REAGENTS_OVERDOSE
	overdose_critical = LOWM_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_MUSCLESTIMULATING = 40, PROPERTY_ADDICTIVE = 8)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_NO_GENERATION

/datum/reagent/medical/stimulant
	name = "Stimulant"
	localized_name = "兴奋剂"
	id = "antag_stimulant"
	description = "同时作用于中枢神经系统和肌肉的强效长效复合兴奋剂。"
	reagent_state = LIQUID
	color = "#00ffff" // rgb: 200, 165, 220
	custom_metabolism = AMOUNT_PER_TIME(1, 40 SECONDS) // 4x longer
	overdose = LOWH_REAGENTS_OVERDOSE
	overdose_critical = LOWH_REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_UNKNOWN = 1)
	flags = REAGENT_TYPE_MEDICAL | REAGENT_NO_GENERATION

/datum/reagent/medical/cryoxadone
	name = "Cryoxadone"
	localized_name = "低温修复酮"
	id = "cryoxadone"
	description = "工业级低温治疗药物，可治疗大多数组织损伤。主要限制是患者体温必须低于 170 K，药物才能正常代谢。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CRYOMETABOLIZING = 2, PROPERTY_NEOGENETIC = 1, PROPERTY_ANTICORROSIVE = 1, PROPERTY_ANTITOXIC = 1, PROPERTY_ANTICARCINOGENIC = 1)

/datum/reagent/medical/cryoxadone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-1)
		M.apply_damage(-1, OXY)
		M.heal_limb_damage(1,1)
		M.apply_damage(-1, TOX)

/datum/reagent/medical/clonexadone
	name = "Clonexadone"
	localized_name = "强化低温修复酮"
	id = "clonexadone"
	description = "由低温修复酮制成的高级低温治疗药物，可治疗大多数组织损伤。需要低于 170 K 的体温才能正常代谢。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CRYOMETABOLIZING = 6, PROPERTY_NEOGENETIC = 3, PROPERTY_ANTICORROSIVE = 3, PROPERTY_ANTITOXIC = 3, PROPERTY_ANTICARCINOGENIC = 3)

/datum/reagent/medical/rezadone
	name = "Rezadone"
	localized_name = "遗传修复酮"
	id = "rezadone"
	description = "从鱼类毒素中提取的粉末，可有效治疗类人生物的遗传损伤。摄入过量可能产生灾难性的副作用。"
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_NEOGENETIC = 1, PROPERTY_AIDING = 3, PROPERTY_TOXIC = 2, PROPERTY_ANTICARCINOGENIC = 2)

/datum/reagent/medical/spaceacillin
	name = "Spaceacillin"
	localized_name = "太空西林"
	id = "spaceacillin"
	description = "一种通用的 θ-内酰胺类抗生素，可预防和治疗普通感染。"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_UNKNOWN = 1)

/datum/reagent/medical/ethylredoxrazine // FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	localized_name = "乙醇氧化嗪"
	id = "ethylredoxrazine"
	description = "将血液中的酒精氧化为水分子，从而消除其影响，但不能阻止即时醉酒。由于它是强氧化剂，高剂量使用会产生毒性。"
	reagent_state = SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_FOCUSING = 3)

///////ANTIDEPRESSANTS///////
/datum/reagent/medical/antidepressant/methylphenidate
	name = "Methylphenidate"
	localized_name = "哌甲酯"
	id = "methylphenidate"
	description = "一种常见的处方精神兴奋剂，可增强中枢神经系统活动，常用于治疗注意缺陷多动障碍（ADHD）和发作性睡病。主要改善前额叶皮质的执行功能，如推理、行为抑制、组织、解决问题和规划等。"
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 4)

/datum/reagent/medical/antidepressant/citalopram
	name = "Citalopram"
	localized_name = "西酞普兰"
	id = "citalopram"
	description = "用于治疗抑郁症、强迫症和惊恐障碍的药物，被认为可安全服用，自 1998 年起广泛使用。"
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 2)

/datum/reagent/medical/antidepressant/paroxetine
	name = "Paroxetine"
	localized_name = "帕罗西汀"
	id = "paroxetine"
	description = "一种强效抗抑郁药，用于治疗重性抑郁障碍（MDD）、强迫症（OCD）、社交焦虑障碍（SAD）、惊恐障碍、创伤后应激障碍（PTSD）、广泛性焦虑障碍（GAD）和经前烦躁障碍（PMDD）。长期使用可能产生副作用。"
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	data = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_PSYCHOSTIMULATING = 6, PROPERTY_HALLUCINOGENIC = 6)

/datum/reagent/medical/antized
	name = "Anti-Zed"
	localized_name = "抗尸毒剂"
	id = "antiZed"
	description = "一种实验性药物，可消灭活人体内的丧尸病毒，并抑制已经尸变者的再生能力。"
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = AMOUNT_PER_TIME(1, 200 SECONDS)
	data = 0
	properties = list(PROPERTY_CURING = 2)
