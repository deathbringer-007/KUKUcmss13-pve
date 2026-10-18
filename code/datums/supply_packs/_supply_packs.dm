//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

// The lists of supply groups and contraband groups have been moved to /obj/structure/machinery/computer/supplycomp definition as static variables.

/datum/supply_packs
	var/name = "Basic supply pack."
	var/localized_name = "基础补给包"
	/// If this variable is null (not if it's an empty list), *and* so is containertype, it won't show up on the order computer.
	var/list/contains = list()
	var/manifest = ""
	var/cost = 7 /// Determine the price of the crate. Give it a value between 7 and 100 to avoid breaking the game.
	/// If this variable is null (not if it's an empty list), *and* so is contains, it won't show up on the order computer.
	var/containertype = null
	var/containername = null
	var/access = null
	var/contraband = 0 /// Tell if the crate is a contraband value 1 or not 0.
	var/group = null
	var/buyable = 1 ///Can this pack be bought? These packs don't show up at all - they have to be spawned externally (fe: DEFCON ASRS)
	var/randomised_num_contained = 0 //Randomly picks X of items out of the contains list instead of using all.
	/// How many W-Y dollars are deducted from the supply controller. Only use for contraband.
	var/dollar_cost = 0
	/// How much "heat" this crate adds, too much heat will send an investigation. Only use for contraband.
	var/crate_heat = 0

/datum/supply_packs/proc/get_display_name()
	return localized_name || name

/datum/supply_packs/New()
	if(randomised_num_contained)
		manifest += "包含以下物品中的任意[randomised_num_contained]件："
	manifest += "<ul>"
	for(var/atom/movable/path in contains)
		if(!path) continue
		manifest += "<li>[initial(path.name)]</li>"
	manifest += "</ul>"

/proc/localized_supply_group_name(value)
	var/static/list/labels = list(
		"Operations" = "行动物资",
		"Weapons" = "武器",
		"Vehicle Ammo" = "载具弹药",
		"Vehicle Equipment" = "载具装备",
		"Attachments" = "武器配件",
		"Ammo" = "弹药",
		"Weapons Specialist Ammo" = "武器专家弹药",
		"Restricted Equipment" = "受限装备",
		"Clothing" = "服装",
		"Medical" = "医疗",
		"Engineering" = "工程",
		"Research" = "科研",
		"Supplies" = "日用品",
		"Food" = "食品",
		"Gear" = "装备",
		"Mortar" = "迫击炮",
		"Explosives" = "爆炸物",
		"Reagent tanks" = "试剂罐",
		"Seized Items" = "查扣物品",
		"Shipside Contraband" = "舰上违禁品",
		"Surplus Equipment" = "剩余库存装备",
		"Contraband Ammo" = "违禁弹药",
		"Deep Storage" = "深层储藏区",
		"Miscellaneous" = "杂项",
		"Black Market" = "黑市"
	)
	return labels[value] || value
