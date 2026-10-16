//Analyzer, pestkillers, weedkillers, nutrients, hatchets, cutters.

/obj/item/tool/wirecutters/clippers
	name = "植物采样剪"
	desc = "用于采集植物样本的工具。"

/obj/item/device/analyzer/plant_analyzer
	name = "植物分析仪"
	icon_state = "hydro"
	item_state = "analyzer"

/obj/item/device/analyzer/plant_analyzer/afterattack(obj/target, mob/user, flag)
	if(!flag)
		return

	var/datum/seed/grown_seed
	var/datum/reagents/grown_reagents
	if(istype(target,/obj/structure/surface/rack) || istype(target,/obj/structure/surface/table))
		return ..()
	else if(istype(target,/obj/item/reagent_container/food/snacks/grown))
		var/obj/item/reagent_container/food/snacks/grown/G = target
		grown_seed = GLOB.seed_types[G.plantname]
		grown_reagents = G.reagents
	else if(istype(target,/obj/item/grown))
		var/obj/item/grown/G = target
		grown_seed = GLOB.seed_types[G.plantname]
		grown_reagents = G.reagents
	else if(istype(target,/obj/item/seeds))
		var/obj/item/seeds/S = target
		grown_seed = S.seed
	else if(istype(target,/obj/structure/machinery/portable_atmospherics/hydroponics))
		var/obj/structure/machinery/portable_atmospherics/hydroponics/H = target
		grown_seed = H.seed
		grown_reagents = H.reagents

	if(!grown_seed)
		to_chat(user, SPAN_DANGER("[src]无法提供[target]的任何信息。"))
		return

	var/dat = "<h3>[target]的植物数据</h3>"
	dat += "<h2>基本数据</h2>"
	dat += "<table>"
	dat += "<tr><td><b>耐久</b></td><td>[grown_seed.endurance]</td></tr>"
	dat += "<tr><td><b>产量</b></td><td>[grown_seed.yield]</td></tr>"
	dat += "<tr><td><b>寿命</b></td><td>[grown_seed.lifespan]</td></tr>"
	dat += "<tr><td><b>成熟时间</b></td><td>[grown_seed.maturation]</td></tr>"
	dat += "<tr><td><b>结果周期</b></td><td>[grown_seed.production]</td></tr>"
	dat += "<tr><td><b>效力</b></td><td>[grown_seed.potency]</td></tr>"
	dat += "</table>"

	if(grown_reagents && LAZYLEN(grown_reagents.reagent_list))
		dat += "<h2>试剂数据</h2>"
		dat += "<br>该样本含有："
		for(var/datum/reagent/R in grown_reagents.reagent_list)
			dat += "<br>- [R.name]，[grown_reagents.get_reagent_amount(R.id)]单位"

	dat += "<h2>其他数据</h2>"

	if(grown_seed.harvest_repeat)
		dat += "这种植物可以多次收获。<br>"

	if(grown_seed.immutable == -1)
		dat += "这种植物很容易发生突变。<br>"
	else if(grown_seed.immutable > 0)
		dat += "这种植物的遗传特征无法修改。<br>"

	if(LAZYLEN(grown_seed.products))
		dat += "这种植物成熟后会结出[length(grown_seed.products) == 1 ? "果实" : "[length(grown_seed.products)]种果实"]。<br>"

	if(grown_seed.requires_nutrients)
		if(grown_seed.nutrient_consumption < 0.05)
			dat += "它消耗少量营养液。<br>"
		else if(grown_seed.nutrient_consumption > 0.2)
			dat += "它需要大量营养液。<br>"
		else
			dat += "它需要营养液供应。<br>"

	if(grown_seed.requires_water)
		if(grown_seed.water_consumption < 1)
			dat += "它需要的水很少。<br>"
		else if(grown_seed.water_consumption > 5)
			dat += "它需要大量水分。<br>"
		else
			dat += "它需要稳定的水分供应。<br>"

	if(LAZYLEN(grown_seed.mutants))
		dat += "它很容易变异为其他亚种。<br>"

	dat += "它在[grown_seed.ideal_heat]开尔文的温度下生长旺盛。"

	if(grown_seed.lowkpa_tolerance < 20)
		dat += "<br>它很适应低气压环境。"
	if(grown_seed.highkpa_tolerance > 220)
		dat += "<br>它很适应高气压环境。"

	if(grown_seed.heat_tolerance > 30)
		dat += "<br>它能适应较大的温度范围。"
	else if(grown_seed.heat_tolerance < 10)
		dat += "<br>它对温度变化十分敏感。"

	dat += "<br>它在[grown_seed.ideal_light]流明[grown_seed.ideal_light == 1 ? "" : ""]的光照下生长旺盛。"

	if(grown_seed.light_tolerance > 10)
		dat += "<br>它能适应较大的光照强度范围。"
	else if(grown_seed.light_tolerance < 3)
		dat += "<br>它对光照强度变化十分敏感。"

	if(grown_seed.toxins_tolerance < 3)
		dat += "<br>它对毒素十分敏感。"
	else if(grown_seed.toxins_tolerance > 6)
		dat += "<br>它对毒素有很强的抵抗力。"

	if(grown_seed.pest_tolerance < 3)
		dat += "<br>它对害虫十分敏感。"
	else if(grown_seed.pest_tolerance > 6)
		dat += "<br>它对害虫有很强的抵抗力。"

	if(grown_seed.weed_tolerance < 3)
		dat += "<br>它对杂草十分敏感。"
	else if(grown_seed.weed_tolerance > 6)
		dat += "<br>它对杂草有很强的抵抗力。"

	switch(grown_seed.spread)
		if(1)
			dat += "<br>它能生长到种植槽之外。"
		if(2)
			dat += "<br>它是一种强健旺盛的藤蔓，会迅速蔓延。"

	switch(grown_seed.carnivorous)
		if(1)
			dat += "<br>它具有食肉性，会吞食种植槽内的害虫来获取养分。"
		if(2)
			dat += "<br>它具有食肉性，会对周围的生物构成严重威胁。"

	if(grown_seed.parasite)
		dat += "<br>它能寄生于种植槽内的杂草，从中获取养分。"
	if(grown_seed.alter_temp)
		dat += "<br>它会周期性地使附近温度改变[grown_seed.alter_temp]开尔文。"

	if(grown_seed.biolum)
		dat += "<br>它具有[grown_seed.biolum_color ? "<font color='[grown_seed.biolum_color]'>生物发光特性</font>" : "生物发光特性"]。"
	if(grown_seed.flowers)
		dat += "<br>它会开出[grown_seed.flower_color ? "<font color='[grown_seed.flower_color]'>花朵</font>" : "花朵"]。"

	if(dat)
		show_browser(user, dat, "植物分析", "plant_analyzer")

	return



// *************************************
// Nutrient defines for hydroponics
// *************************************

/obj/item/reagent_container/glass/fertilizer
	name = "肥料瓶"
	desc = "一个小玻璃瓶，最多可容纳10单位。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle16"
	flags_atom = FPRINT| OPENCONTAINER
	possible_transfer_amounts = null
	w_class = SIZE_SMALL

	var/fertilizer //Reagent contained, if any.

	//Like a shot glass!
	amount_per_transfer_from_this = 10
	volume = 10

/obj/item/reagent_container/glass/fertilizer/Initialize()
	. = ..()

	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)

	if(fertilizer)
		reagents.add_reagent(fertilizer,10)

/obj/item/reagent_container/glass/fertilizer/ez
	name = "易养营养液瓶"
	icon_state = "bottle16"
	fertilizer = "eznutrient"

/obj/item/reagent_container/glass/fertilizer/l4z
	name = "求生突变肥瓶"
	icon_state = "bottle18"
	fertilizer = "left4zed"

/obj/item/reagent_container/glass/fertilizer/rh
	name = "丰收壮苗肥瓶"
	icon_state = "bottle15"
	fertilizer = "robustharvest"
