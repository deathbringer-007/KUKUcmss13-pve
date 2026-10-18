/datum/chem_property
	var/name
	var/code = "ZZZ" //should be unique to all properties
	var/description = "You shouldn't be seeing this."
	var/datum/reagent/holder
	var/rarity = PROPERTY_DISABLED
	var/category = PROPERTY_TYPE_MEDICINE
	var/level = 1 //used to calculate potency
	var/max_level //if there a point where it makes no logical sense to increase the level? Remember potency is level / 2
	var/value //how much value per level? Negative properties should have a high negative value, neutral should have a value near zero, and positive ones should have a high value
	var/starter = FALSE //whether or not this is a starter property and should be added to the property database on startup
	var/updates_stats = FALSE //should the property change other variables in the reagent when added or removed?
	/// Should reagent with this property explode/start fire when mixed more than overdose threshold at once?
	var/volatile = FALSE
	/// a cost penalty is added at each level above 5 (+1 at 6, +2 at 7, +4 at 8, +5 at 9, +7 at 10)
	var/cost_penalty = TRUE

/datum/chem_property/proc/get_display_name()
	var/static/list/display_names = list(
		PROPERTY_HYPOXEMIC = "致低氧血症",
		PROPERTY_TOXIC = "毒性",
		PROPERTY_CORROSIVE = "腐蚀性",
		PROPERTY_BIOCIDIC = "细胞杀伤",
		PROPERTY_HEMOLYTIC = "溶血",
		PROPERTY_HEMORRAGING = "致出血",
		PROPERTY_CARCINOGENIC = "致癌",
		PROPERTY_HEPATOTOXIC = "肝毒性",
		PROPERTY_INTRAVENOUS = "仅限静脉给药",
		PROPERTY_NEPHROTOXIC = "肾毒性",
		PROPERTY_PNEUMOTOXIC = "肺毒性",
		PROPERTY_OCULOTOXIC = "眼毒性",
		PROPERTY_CARDIOTOXIC = "心脏毒性",
		PROPERTY_NEUROTOXIC = "神经毒性",
		PROPERTY_HYPERMETABOLIC = "快速代谢",
		PROPERTY_NUTRITIOUS = "营养性",
		PROPERTY_KETOGENIC = "生酮",
		PROPERTY_PAINING = "致痛",
		PROPERTY_NEUROINHIBITING = "神经抑制",
		PROPERTY_ALCOHOLIC = "醉酒",
		PROPERTY_HALLUCINOGENIC = "致幻",
		PROPERTY_RELAXING = "肌肉松弛",
		PROPERTY_HYPERTHERMIC = "升温",
		PROPERTY_HYPOTHERMIC = "降温",
		PROPERTY_BALDING = "脱发",
		PROPERTY_FLUFFING = "毛发增生",
		PROPERTY_ALLERGENIC = "致敏",
		PROPERTY_CRYOMETABOLIZING = "低温代谢",
		PROPERTY_EUPHORIC = "欣快",
		PROPERTY_EMETIC = "催吐",
		PROPERTY_PSYCHOSTIMULATING = "精神刺激",
		PROPERTY_ANTIHALLUCINOGENIC = "抗幻觉",
		PROPERTY_EXCRETING = "促进排泄",
		PROPERTY_HYPOMETABOLIC = "缓慢代谢",
		PROPERTY_SEDATIVE = "镇静",
		PROPERTY_TRANSFORMATIVE = "转化修复",
		PROPERTY_ANTITOXIC = "抗毒",
		PROPERTY_ANTICORROSIVE = "抗腐蚀",
		PROPERTY_NEOGENETIC = "组织再生",
		PROPERTY_REPAIRING = "机械修复",
		PROPERTY_HEMOGENIC = "造血",
		PROPERTY_YAUTJA_HEMOGENIC = "铁血造血",
		PROPERTY_HEMOSTATIC = "止血",
		PROPERTY_NERVESTIMULATING = "神经刺激",
		PROPERTY_MUSCLESTIMULATING = "肌肉刺激",
		PROPERTY_PAINKILLING = "镇痛",
		PROPERTY_HEPATOPEUTIC = "肝脏修复",
		PROPERTY_NEPHROPEUTIC = "肾脏修复",
		PROPERTY_PNEUMOPEUTIC = "肺部修复",
		PROPERTY_OCULOPEUTIC = "视力修复",
		PROPERTY_CARDIOPEUTIC = "心脏修复",
		PROPERTY_NEUROPEUTIC = "神经修复",
		PROPERTY_BONEMENDING = "骨骼修复",
		PROPERTY_FLUXING = "异物溶排",
		PROPERTY_NEUROCRYOGENIC = "脑部冷冻保存",
		PROPERTY_CRYSTALLIZATION = "结晶",
		PROPERTY_PHOTOSENSITIVE = "感光",
		PROPERTY_NEUTRALIZING = "中和",
		PROPERTY_DISRUPTING = "神经交流干扰",
		PROPERTY_ANTIPARASITIC = "抗寄生虫",
		PROPERTY_ELECTROGENETIC = "电击辅助复苏",
		PROPERTY_ORGANSTABILIZE = "内脏稳定",
		PROPERTY_DEFIBRILLATING = "除颤",
		PROPERTY_THANATOMETABOL = "濒死代谢",
		PROPERTY_HYPERDENSIFICATING = "超致密化",
		PROPERTY_HYPERTHROTTLING = "思维超频",
		PROPERTY_NEUROSHIELDING = "神经保护",
		PROPERTY_ANTIADDICTIVE = "抗成瘾",
		PROPERTY_ADDICTIVE = "成瘾性",
		PROPERTY_ENCEPHALOPHRASIVE = "思维广播",
		PROPERTY_HYPERGENETIC = "全面再生",
		PROPERTY_BOOSTING = "效力增强",
		PROPERTY_DNA_DISINTEGRATING = "DNA瓦解",
		PROPERTY_REGULATING = "代谢调节",
		PROPERTY_CIPHERING = "生物编码",
		PROPERTY_CIPHERING_PREDATOR = "跨种生物编码",
		PROPERTY_FIRE_PENETRATING = "火焰穿透",
		PROPERTY_ORGAN_HEALING = "器官再生",
		PROPERTY_CROSSMETABOLIZING = "跨种代谢",
		PROPERTY_EMBRYONIC = "寄生胚胎",
		PROPERTY_TRANSFORMING = "宿主转变",
		PROPERTY_RAVENING = "X-65感染",
		PROPERTY_CURING = "病原体清除",
		PROPERTY_OMNIPOTENT = "全能恢复",
		PROPERTY_RADIUS = "火焰范围",
		PROPERTY_INTENSITY = "火焰强度",
		PROPERTY_DURATION = "火焰持续时间",
		PROPERTY_FUELING = "助燃燃料",
		PROPERTY_OXIDIZING = "氧化性",
		PROPERTY_FLOWING = "易流散",
		PROPERTY_VISCOUS = "黏滞性",
		PROPERTY_EXPLOSIVE = "爆炸性",
		PROPERTY_CARDIOSTABILIZING = "心律稳定",
		PROPERTY_AIDING = "遗传缺陷修复",
		PROPERTY_THERMOSTABILIZING = "体温稳定",
		PROPERTY_OXYGENATING = "供氧增强",
		PROPERTY_FOCUSING = "醒酒专注",
		PROPERTY_ANTICARCINOGENIC = "抗癌",
		PROPERTY_UNKNOWN = "未知",
		PROPERTY_HEMOSITIC = "血细胞寄生",
		PROPERTY_REVITALIZING = "活力恢复",
	)
	return display_names[name] || name

/datum/chem_property/Destroy()
	holder = null
	. = ..()
	return QDEL_HINT_IWILLGC

/datum/chem_property/proc/reagent_added(atom/A, datum/reagent/R, amount)
	return

/datum/chem_property/proc/pre_process(mob/living/M) //used for properties that need special checks before processing starts, such as cryometabolization
	return

/datum/chem_property/proc/on_delete(mob/living/M) //used for properties that do something on delete
	qdel(src)
	return

/datum/chem_property/process(mob/living/M, potency = 1, delta_time)
	if(QDELETED(src))
		CRASH("Attempted to process a deleted chemical property: [name], type=[type]")

	return TRUE

/datum/chem_property/proc/process_overdose(mob/living/M, potency = 1, delta_time)
	if(QDELETED(src))
		CRASH("Attempted to process_overdose a deleted chemical property: [name], type=[type]")

	return TRUE

/datum/chem_property/proc/process_critical(mob/living/M, potency = 1, delta_time)
	if(QDELETED(src))
		CRASH("Attempted to process_critical a deleted chemical property: [name], type=[type]")

	return TRUE

/datum/chem_property/proc/process_dead(mob/living/M, potency = 1, delta_time)
	return FALSE // By default, chemicals don't process in dead personnel.

/datum/chem_property/proc/trigger(A) //used for properties that needs something to trigger outside of where process is usually called
	return

/datum/chem_property/proc/reset_reagent()
	return

/datum/chem_property/proc/update_reagent() //used for changing other variables in the reagent, set update to FALSE to remove the update
	return

/datum/chem_property/proc/reaction_mob(mob/M, method=TOUCH, volume, potency)
	return

/datum/chem_property/proc/reaction_obj(obj/O, volume, potency)
	return

/datum/chem_property/proc/reaction_turf(turf/T, volume, potency)
	return

/datum/chem_property/proc/post_update_reagent()
	return

/datum/chem_property/proc/categories_to_string()
	var/text = ""
	switch(rarity)
		if(PROPERTY_DISABLED)
			text += "Unique "
		if(PROPERTY_COMMON)
			text += "Common "
		if(PROPERTY_UNCOMMON)
			text += "Uncommon "
		if(PROPERTY_RARE)
			text += "Rare "
		if(PROPERTY_LEGENDARY)
			text += "Legendary "
		if(PROPERTY_ADMIN)
			text += "Special "
	if(isNegativeProperty(src))
		text += "Harmful "
	else if(isPositiveProperty(src))
		text += "Helpful "
	if(category & PROPERTY_TYPE_MEDICINE)
		text += "Medicine "
	if(category & PROPERTY_TYPE_TOXICANT)
		text += "Toxicant "
	if(category & PROPERTY_TYPE_STIMULANT)
		text += "Stimulant "
	if(category & PROPERTY_TYPE_REACTANT)
		text += "Reactant "
	if(category & PROPERTY_TYPE_IRRITANT)
		text += "Irritant "
	if(category & PROPERTY_TYPE_METABOLITE)
		text += "Metabolite "
	if(category & PROPERTY_TYPE_ANOMALOUS)
		text += "Anomalous "
	return text

