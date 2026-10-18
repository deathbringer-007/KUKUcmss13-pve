//mode datums at the bottom.
#define MODE_AMPLIFY 1
#define MODE_SUPPRESS 2
#define MODE_RELATE 3
#define MODE_CREATE 4

#define SIMULATION_FAILURE -1
#define SIMULATION_STAGE_OFF 0
#define SIMULATION_STAGE_FINAL 1
#define SIMULATION_STAGE_WAIT 2
#define SIMULATION_STAGE_3 3
#define SIMULATION_STAGE_4 4
#define SIMULATION_STAGE_5 5
#define SIMULATION_STAGE_BEGIN 6

/obj/structure/machinery/chem_simulator
	name = "合成模拟器"
	desc = "这台计算机采用先进算法模拟试剂特性，用于计算合成新变体所需的配方。"
	icon = 'icons/obj/structures/machinery/science_machines_64x32.dmi'
	icon_state = "modifier"
	active_power_usage = 1000
	layer = BELOW_OBJ_LAYER
	density = TRUE
	bound_x = 32

	var/obj/item/paper/research_report/target
	var/obj/item/paper/research_report/reference
	var/list/simulations

	var/mode = MODE_AMPLIFY
	var/datum/chem_property/target_property
	var/datum/chem_property/reference_property
	var/datum/reagent/generated/chem_cache
	var/list/property_costs
	var/list/recipe_targets
	var/recipe_target
	var/new_od_level = 10

	var/simulating = SIMULATION_STAGE_OFF
	var/status_bar = "就绪"
	var/ready = FALSE

	var/template_filter = PROPERTY_TYPE_ALL
	var/creation_template
	var/creation_complexity = list(CHEM_CLASS_COMMON, CHEM_CLASS_UNCOMMON, CHEM_CLASS_RARE)
	var/creation_name = ""
	var/creation_cost = 0
	var/min_creation_cost = 0
	var/creation_od_level = 10 //a cache for new_od_level when switching between modes

	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/chem_simulator/Initialize()
	. = ..()
	LAZYINITLIST(simulations)
	LAZYINITLIST(property_costs)
	LAZYINITLIST(recipe_targets)
	LAZYINITLIST(creation_template)

/obj/structure/machinery/chem_simulator/power_change()
	..()
	if(inoperable())
		icon_state = "modifier_off"

/obj/structure/machinery/chem_simulator/attackby(obj/item/B, mob/living/user)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("你完全不知道如何使用它。"))
		return
	if(istype(B, /obj/item/paper/research_notes))
		var/obj/item/paper/research_notes/note = B
		if(!target || (mode == MODE_RELATE && !reference))
			B = note.convert_to_chem_report()
		else
			to_chat(user, SPAN_WARNING("已经插入化学数据。"))
			return
	if(istype(B, /obj/item/paper/research_report))
		var/obj/item/paper/research_report/note = B
		if(!target && note.data)
			target = B
			ready = check_ready()
		else if(mode == MODE_RELATE && !reference && note.data)
			target_property = null
			reference = B
			ready = check_ready()
		else
			to_chat(user, SPAN_WARNING("化学数据[note.data ? "已经插入" : "被拒绝接收"]。"))
			return
	else
		to_chat(user, SPAN_WARNING("[src]拒绝接收[B]。"))
		return
	user.drop_inv_item_to_loc(B, src)
	to_chat(user, SPAN_NOTICE("你将[B]插入[src]。"))
	flick("[icon_state]_reading",src)
	update_costs()

/obj/structure/machinery/chem_simulator/attack_hand(mob/user as mob)
	if(inoperable())
		return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("你完全不知道如何使用它。"))
		return
	tgui_interact(user)

/obj/structure/machinery/chem_simulator/tgui_interact(mob/user, datum/tgui/ui) //death to the chem simulator! All Hail the new chem simulator!
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemSimulator", "化学模拟器")
		ui.open()

/obj/structure/machinery/chem_simulator/ui_data(mob/user)
	. = ..()
	var/list/data = list()
	data["status"] = status_bar
	ready = check_ready()
	data["is_ready"] = ready
	data["can_simulate"] = (ready && simulating == SIMULATION_STAGE_OFF)
	data["can_eject_target"] = ((target ? TRUE : FALSE) && simulating == SIMULATION_STAGE_OFF)
	data["can_eject_reference"] = ((reference ? TRUE : FALSE) && simulating == SIMULATION_STAGE_OFF)
	data["is_picking_recipe"] = (simulating == SIMULATION_STAGE_FINAL && mode != MODE_CREATE)
	data["lock_control"] = (simulating != SIMULATION_STAGE_OFF)
	data["can_cancel_simulation"] = (simulating <= SIMULATION_STAGE_WAIT)
	data["estimated_cost"] = (mode == MODE_CREATE ? creation_cost : (!target_property ? "无" : property_costs[target_property.name]))
	calculate_new_od_level()
	data["od_level"] = new_od_level
	data["chemical_name"] = (mode == MODE_CREATE ? (creation_name == "" ? "未命名" : creation_name) : (isnull(target) ? "未插入化学数据" : target.data.name))
	data["reference_name"] = (isnull(reference) ? "未插入化学数据" : reference.data.name)

	if(mode == MODE_CREATE && GLOB.chemical_data.has_new_properties)
		update_costs()

	if(simulating == SIMULATION_STAGE_FINAL)
		for(var/reagent_id in recipe_targets)
			var/datum/reagent/recipe_option = GLOB.chemical_reagents_list[reagent_id]
			data["reagent_option_data"] += list(list(
				"id" = recipe_option.id,
				"name" = recipe_option.name,
			))
	if(target && length(target?.data?.properties))
		for(var/datum/chem_property/target_property_data in target.data.properties)
			var/is_locked = FALSE
			var/conflicting_tooltip = null
			if(!isnull(reference_property))
				if(LAZYACCESS(GLOB.conflicting_properties, reference_property.name) == target_property_data.name || LAZYACCESS(GLOB.conflicting_properties, target_property_data.name) == reference_property.name )
					is_locked = TRUE
					conflicting_tooltip = "该特性与已选参考特性冲突！"
			data["target_data"] += list(list(
				"code" = target_property_data.code,
				"level" = target_property_data.level,
				"name" = target_property_data.name,
				"display_name" = target_property_data.get_display_name(),
				"desc" = target_property_data.description,
				"cost" = property_costs[target_property_data.name],
				"is_locked" = is_locked,
				"tooltip" = conflicting_tooltip,
			))
	else
		data["target_data"] = null

	if(reference && length(reference?.data?.properties))
		for(var/datum/chem_property/reference_property_data in reference.data.properties)
			var/is_locked = FALSE
			var/conflicting_tooltip = null
			if(!isnull(target_property))
				if(LAZYACCESS(GLOB.conflicting_properties, target_property.name) == reference_property_data.name || LAZYACCESS(GLOB.conflicting_properties, reference_property_data.name) == target_property.name )
					is_locked = TRUE
					conflicting_tooltip = "该特性与已选目标特性冲突！"
			data["reference_data"] += list(list(
				"code" = reference_property_data.code,
				"level" = reference_property_data.level,
				"name" = capitalize_first_letters(reference_property_data.name),
				"display_name" = reference_property_data.get_display_name(),
				"desc" = reference_property_data.description,
				"cost" = property_costs[reference_property_data.name],
				"is_locked" = is_locked,
				"tooltip" = conflicting_tooltip,
			))
	else
		data["reference_data"] = null
	data["template_filters"] = list(
		"MED" = list(HAS_FLAG(template_filter, PROPERTY_TYPE_MEDICINE), PROPERTY_TYPE_MEDICINE),
		"TOX" = list(HAS_FLAG(template_filter, PROPERTY_TYPE_TOXICANT), PROPERTY_TYPE_TOXICANT),
		"STI" = list(HAS_FLAG(template_filter, PROPERTY_TYPE_STIMULANT), PROPERTY_TYPE_STIMULANT),
		"REA" = list(HAS_FLAG(template_filter, PROPERTY_TYPE_REACTANT), PROPERTY_TYPE_REACTANT),
		"IRR" = list(HAS_FLAG(template_filter, PROPERTY_TYPE_IRRITANT), PROPERTY_TYPE_IRRITANT),
		"MET" = list(HAS_FLAG(template_filter, PROPERTY_TYPE_METABOLITE), PROPERTY_TYPE_METABOLITE)
	)
	if(mode == MODE_CREATE)
		for(var/datum/chem_property/known_properties in GLOB.chemical_data.research_property_data)
			var/datum/chem_property/template_property
			var/is_locked = FALSE
			var/conflicting_tooltip = null
			if(template_filter && !HAS_FLAG(known_properties.category, template_filter))
				continue
			for(var/template in creation_template)
				template_property = template
				if(LAZYACCESS(GLOB.conflicting_properties, template_property.name) == known_properties.name || LAZYACCESS(GLOB.conflicting_properties, known_properties.name) == template_property.name)
					is_locked = TRUE
					conflicting_tooltip = "该特性与[template_property.code]冲突！"
				if(template_property.code == known_properties.code)
					break
				template_property = null

			data["known_properties"] += list(list(
				"code" = known_properties.code,
				"level" = (isnull(template_property) ? 0 : template_property.level) ,
				"name" = capitalize_first_letters(known_properties.name),
				"display_name" = known_properties.get_display_name(),
				"desc" = known_properties.description,
				"is_enabled" = LAZYISIN(creation_template, known_properties),
				"is_locked" = is_locked,
				"conflicting_tooltip" = conflicting_tooltip,
			))
		if(!length(data["known_properties"]))
			data["known_properties"] = null
		data["complexity_list"] += complexity_to_string_list()

	return data

/obj/structure/machinery/chem_simulator/ui_static_data(mob/user)
	. = ..()
	var/list/static_data = list()
	for(var/modes in subtypesof(/datum/chemical_simulator_modes))
		var/datum/chemical_simulator_modes/modes_datum = modes
		static_data["mode_data"] += list(list(
			"name" = modes_datum.name,
			"desc" = modes_datum.desc,
			"mode_id" = modes_datum.mode_id,
			"icon_type" = modes_datum.icon_type
		))
	static_data["credits"] = GLOB.chemical_data.rsc_credits
	return static_data

/obj/structure/machinery/chem_simulator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("change_mode")
			mode = params["mode_id"]
			update_costs()
		if("eject_target")
			if(target)
				if(!usr.put_in_active_hand(target))
					target.forceMove(loc)
				target = null
			target_property = null
			stop_processing()
			simulating = SIMULATION_STAGE_OFF
			flick("[icon_state]_printing",src)
		if("eject_reference")
			if(reference)
				if(!usr.put_in_active_hand(reference))
					reference.forceMove(loc)
				reference = null
			reference_property = null
			stop_processing()
			flick("[icon_state]_printing",src)
		if("select_target_property")
			if(mode != MODE_CREATE)
				if(!target)
					return
				for(var/datum/chem_property/target_prop in target.data.properties)
					if(target_prop.code != params["property_code"])
						continue
					target_property = target_prop
				if(!target_property)
					to_chat(usr, SPAN_WARNING("[src]发出一声可疑的哀鸣。"))
					return
		if("select_reference_property")
			if(!reference)
				return
			for(var/datum/chem_property/reference_prop in reference.data.properties)
				if(reference_prop.code != params["property_code"])
					continue
				reference_property = reference_prop
			if(!reference_property)
				to_chat(usr, SPAN_WARNING("[src]发出一声可疑的哀鸣。"))
				return
		if("simulate")
			if(!ready)
				return
			simulating = SIMULATION_STAGE_BEGIN
			status_bar = "开始模拟"
			icon_state = "modifier_running"
			recipe_targets = list() //reset
			start_processing()
			if(mode == MODE_CREATE)
				msg_admin_niche("[key_name(usr)] has created the chemical: [creation_name]")
		if("submit_recipe_pick")
			if(recipe_target)
				return
			if(params["reagent_picked"] in recipe_targets)
				recipe_target = params["reagent_picked"]
				finalize_simulation(chem_cache)
			recipe_target = null
		if("cancel_simulation")
			stop_processing()
			icon_state = "modifier"
			simulating = SIMULATION_STAGE_OFF
		if("toggle_flag")
			var/flag_value = params["flag_id"]
			if(template_filter & flag_value)
				template_filter &= ~flag_value
			else
				template_filter |= flag_value
		if("select_create_property")
			if(mode == MODE_CREATE)
				if(target_property?.code == params["property_code"])
					if(LAZYISIN(creation_template, target_property))
						target_property.level = 0
						LAZYREMOVE(creation_template, target_property)
					else
						target_property.level = 1
						LAZYADD(creation_template, target_property)
				else
					for(var/datum/chem_property/known_prop in GLOB.chemical_data.research_property_data)
						if(known_prop.code != params["property_code"])
							continue
						target_property = known_prop
				if(!target_property)
					to_chat(usr, SPAN_WARNING("[src]发出一声可疑的哀鸣。"))
					return
				calculate_creation_cost()
		if("select_overdose")
			if(simulating == SIMULATION_STAGE_OFF && mode == MODE_CREATE)
				var/od_to_set = tgui_input_list(usr, "设置新的过量阈值：", "[src]", list(5,10,15,20,25,30,35,40,45,50,55,60))
				if(!od_to_set || simulating != SIMULATION_STAGE_OFF)
					return
				creation_od_level = od_to_set
				calculate_new_od_level()
				calculate_creation_cost()
		if("change_name")
			if(simulating == SIMULATION_STAGE_OFF && mode == MODE_CREATE)
				var/newname = input("为模板命名（2至20个字符）","[src]") as text
				newname = reject_bad_name(newname, TRUE, 20, FALSE)
				if(isnull(newname))
					to_chat(usr, SPAN_WARNING("不允许使用这个名称。"))
				else if(GLOB.chemical_reagents_list[newname])
					to_chat(usr, SPAN_WARNING("这个名称已被使用。"))
				else
					creation_name = newname
		if("change_create_target_level")
			var/level_to_set = 1
			if(GLOB.chemical_data.clearance_level <= 2)
				level_to_set = tgui_input_list(usr, "设置[target_property.get_display_name()]的目标等级：","[src]", list(1,2,3,4))
			else if(GLOB.chemical_data.clearance_level <= 4)
				level_to_set = tgui_input_list(usr, "设置[target_property.get_display_name()]的目标等级：","[src]", list(1,2,3,4,5,6,7,8))
			else
				level_to_set = tgui_input_list(usr, "设置[target_property.get_display_name()]的目标等级：","[src]", list(1,2,3,4,5,6,7,8,9,10))
			if(!level_to_set)
				return
			if(!LAZYISIN(creation_template, target_property))
				LAZYADD(creation_template, target_property)
			target_property.level = level_to_set
			if(target_property.max_level && target_property.level > target_property.max_level)
				target_property.level = target_property.max_level
				to_chat(usr, "[target_property.get_display_name()]的最高等级为[target_property.max_level]。")
			calculate_creation_cost()
		if("change_complexity")
			var/slot = params["complexity_slot"]
			var/new_rarity = tgui_input_list(usr, "设置复杂度槽位[slot]的化学品稀有度：", "[src]", list("基础（+7）", "常见（+4）", "少见（1）", "稀有（-5）"))
			if(!new_rarity || simulating != SIMULATION_STAGE_OFF)
				return
			switch(new_rarity)
				if("基础（+7）")
					creation_complexity[slot] = CHEM_CLASS_BASIC
				if("常见（+4）")
					creation_complexity[slot] = CHEM_CLASS_COMMON
				if("少见（1）")
					creation_complexity[slot] = CHEM_CLASS_UNCOMMON
				if("稀有（-5）")
					creation_complexity[slot] = CHEM_CLASS_RARE
			calculate_creation_cost()
		if("keyboard_sound")//only exists to give sound
			playsound(loc, pick('sound/machines/computer_typing1.ogg','sound/machines/computer_typing2.ogg','sound/machines/computer_typing3.ogg'), 5, 1)
			return
	playsound(loc, pick('sound/machines/computer_typing1.ogg','sound/machines/computer_typing2.ogg','sound/machines/computer_typing3.ogg'), 5, 1)

/obj/structure/machinery/chem_simulator/process()
	if(inoperable())
		return
	if(simulating > SIMULATION_STAGE_OFF)
		simulating = max(simulating - 1, SIMULATION_STAGE_FINAL)
		switch(simulating)
			if(SIMULATION_STAGE_5)
				status_bar = pick("正在模拟人类","正在模拟猴子","正在模拟身体机能","正在测量特性","正在给虚拟人类注射","正在折磨数字猴子","正在仿真代谢")
			if(SIMULATION_STAGE_4)
				status_bar = pick("正在寻找黑猩猩","正在与阿瑞斯下棋","正在咨询医生","正在责怪上帝","正在寻找存在意义","正在偷看琼斯","正在除以空值","正在求解时空方程")
			if(SIMULATION_STAGE_3)
				status_bar = pick("正在预测反应模式","正在计算过量比例","正在计算合成配方","正在排除意外情况","正在计算试剂分析结果",)
			if(SIMULATION_STAGE_WAIT)
				var/datum/reagent/generated/C = new /datum/reagent/generated
				if(mode == MODE_CREATE)
					status_bar = "创建完成"
					simulating = SIMULATION_STAGE_OFF
					create(C)
				else
					switch(mode)
						if(MODE_AMPLIFY)
							amplify(C)
						if(MODE_SUPPRESS)
							suppress(C)
						if(MODE_RELATE)
							relate(C)
					if(!C.original_id)
						C.original_id = target.data.id
					encode_reagent(C)
					if(C.id in simulations)
						//We've already simulated this before, so we don't need to continue
						C = GLOB.chemical_reagents_list[C.id]
						print(C.id)
						status_bar = "模拟完成"
						simulating = SIMULATION_STAGE_OFF
					else if(prepare_recipe_options())
						chem_cache = C
						status_bar = "分析结果已就绪"
						icon_state = "modifier_ready"
						playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
					else
						finalize_simulation(C)
	else
		ready = check_ready()
		stop_processing()
	SSnano.nanomanager.update_uis(src)

/obj/structure/machinery/chem_simulator/proc/update_costs()
	property_costs = list()
	var/only_positive = TRUE
	if(mode == MODE_CREATE)
		for(var/datum/chem_property/P in GLOB.chemical_data.research_property_data)
			property_costs[P.name] = max(abs(P.value), 1)
	else if(target && target.data && target.completed)
		for(var/datum/chem_property/P in target.data.properties)
			if(!isPositiveProperty(P))
				only_positive = FALSE
			if(P.category & PROPERTY_TYPE_ANOMALOUS)
				property_costs[P.name] = P.level * PROPERTY_MULTIPLIER_ANOMALOUS
				continue
			switch(mode)
				if(MODE_AMPLIFY)
					property_costs[P.name] = max(min(P.level - 1, PROPERTY_COST_MAX), 1)
				if(MODE_SUPPRESS)
					property_costs[P.name] = 2
				if(MODE_RELATE)
					if(reference_property)
						if(reference_property.category & PROPERTY_TYPE_ANOMALOUS)
							property_costs[P.name] = P.level * 10
						else if(reference_property.rarity < PROPERTY_RARE)
							property_costs[P.name] = P.level
						else
							property_costs[P.name] = P.level * PROPERTY_MULTIPLIER_RARE
					else
						property_costs[P.name] = P.level * 1
		if(only_positive)
			for(var/P in property_costs)
				property_costs[P] = property_costs[P] + 1
	GLOB.chemical_data.has_new_properties = FALSE

//Here the cost for creating a chemical is calculated. If you're looking to rebalance create mode, this is where you do it
/obj/structure/machinery/chem_simulator/proc/calculate_creation_cost()
	creation_cost = 0
	min_creation_cost = 5 //min cost of 5
	var/slots_used = LAZYLEN(creation_template)
	creation_cost += slots_used * 3 - 6 //3 cost for each slot after the 2nd
	min_creation_cost += slots_used - 2
	for(var/datum/chem_property/P in creation_template)
		creation_cost += max(abs(P.value), 1) * P.level
		if(P.level > 5 && P.cost_penalty) // a penalty is added at each level above 5 (+1 at 6, +2 at 7, +4 at 8, +5 at 9, +7 at 10)
			creation_cost += P.level - 6 + ceil((P.level - 5) / 2)
	creation_cost += ((new_od_level - 10) / 5) * 3 //3 cost for every 5 units above 10
	for(var/rarity in creation_complexity)
		switch(rarity)
			if(CHEM_CLASS_BASIC)
				creation_cost += 7
			if(CHEM_CLASS_COMMON)
				creation_cost += 4
			if(CHEM_CLASS_UNCOMMON)
				creation_cost++
			if(CHEM_CLASS_RARE)
				creation_cost -= 5
	creation_cost = max(creation_cost, min_creation_cost) //checks against minimum cost

/obj/structure/machinery/chem_simulator/proc/calculate_new_od_level()
	if(mode == MODE_CREATE || !target || !target.data)
		new_od_level = creation_od_level
		return
	new_od_level = max(target.data.overdose, 1)
	if(new_od_level <= 5)
		new_od_level = max(new_od_level - 1, 1)
	else
		new_od_level = max(new_od_level - 5, 5)

/obj/structure/machinery/chem_simulator/proc/prepare_recipe_options()
	var/datum/chemical_reaction/generated/O = GLOB.chemical_reactions_list[target.data.id]
	if(!O) //If it doesn't have a recipe, go immediately to finalizing, which will then generate a new associated recipe
		return FALSE
	recipe_targets = list() //reset
	var/list/old_reaction = O.required_reagents.Copy()
	var/datum/chemical_reaction/generated/R = new /datum/chemical_reaction/generated()
	R.required_reagents = old_reaction.Copy()
	while(LAZYLEN(recipe_targets) < 3)
		var/list/target_elevated[0]
		for(var/i = 0 to 5) //5 attempts at modifying the recipe before elevating recipe length
			if(LAZYLEN(R.required_reagents) > 2)
				LAZYREMOVE(R.required_reagents, pick(R.required_reagents))
			var/new_component_id = R.add_component(tier = max(min(target.data.chemclass, CHEM_CLASS_COMMON), target.data.gen_tier, 1))
			var/datum/reagent/new_component = GLOB.chemical_reagents_list[new_component_id]
			//Make sure we don't have an identical reaction and that the component is identified
			if(R.check_duplicate() || R.check_reaction_uses_all_default_medical() || new_component.chemclass >= CHEM_CLASS_SPECIAL)
				R.required_reagents = old_reaction.Copy()
				if(i >= 5)
					//Elevate the reaction to a higher order
					target_elevated["[new_component.id]"] = TRUE
					break
				continue
			target_elevated["[new_component.id]"] = FALSE
			break
		LAZYADD(recipe_targets, target_elevated)
		R.required_reagents = old_reaction.Copy() //it was just a simulation
	return TRUE

/obj/structure/machinery/chem_simulator/proc/check_ready()
	if(simulating == SIMULATION_FAILURE)
		status_bar = "严重失败：没有可行的化学组合"
		simulating = SIMULATION_STAGE_OFF
		return FALSE
	if(target && mode != MODE_CREATE)
		if(!target.completed)
			status_bar = "检测到目标数据不完整"
			return FALSE
		if(!target.data)
			status_bar = "检测到数据损坏，请重新扫描化学品"
			return FALSE
		if(target.data.chemclass < CHEM_CLASS_BASIC || !istype(target.data, /datum/reagent/generated)) //Requires a custom/generated chem as a base
			status_bar = "无法修改目标"
			return FALSE
		//Safety check in case of irregular papers
		var/datum/chemical_reaction/C = GLOB.chemical_reactions_list[target.data.id]
		if(C)
			for(var/component in C.required_reagents)
				var/datum/reagent/R = GLOB.chemical_reagents_list[component]
				if(R && R.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[R.id])
					status_bar = "检测到未登记组分"
					return FALSE
			for(var/catalyst in C.required_catalysts)
				var/datum/reagent/R = GLOB.chemical_reagents_list[catalyst]
				if(R && R.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[R.id])
					status_bar = "检测到未登记催化剂"
					return FALSE
		if(target_property)
			if(property_costs[target_property.name] > GLOB.chemical_data.rsc_credits)
				status_bar = "研究经费不足"
				return FALSE
			if(target_property.category & PROPERTY_TYPE_UNADJUSTABLE)
				status_bar = "无法模拟目标特性"
				return FALSE
			if(mode == MODE_AMPLIFY)
				if(target_property.level >= GLOB.chemical_data.clearance_level*TECHTREE_LEVEL_MULTIPLIER + 2 && GLOB.chemical_data.clearance_level < 5)
					status_bar = "权限不足，无法增幅"
					return FALSE
		else
			status_bar = "未选择目标"
			return FALSE
		if(target && length(target.data.properties) < 2)
			status_bar = "目标复杂度不适合进行特性替换"
			return FALSE
		if(mode == MODE_RELATE && isnull(reference))
			status_bar = "未检测到参考数据"
			return FALSE
		if(mode == MODE_RELATE)
			if(reference && target)
				if(!reference.completed)
					status_bar = "检测到参考数据不完整"
					return FALSE
				if(reference_property)
					if(target.data.get_property(reference_property.name))
						status_bar = "目标已具备参考特性"
						return FALSE
					if(target_property)
						if(target_property.level != reference_property.level)
							status_bar = "参考特性与目标特性的等级必须相同"
							return FALSE
						if(reference_property.category & PROPERTY_TYPE_UNADJUSTABLE)
							status_bar = "无法模拟参考特性"
							return FALSE
				else
					status_bar = "未选择参考特性"
					return FALSE
	if(mode == MODE_CREATE)
		if(!LAZYLEN(creation_template))
			status_bar = "模板为空"
			return FALSE
		if(LAZYLEN(creation_name) < 2)
			status_bar = "未命名"
			return FALSE
		if(creation_cost > GLOB.chemical_data.rsc_credits)
			status_bar = "研究经费不足"
			return FALSE
	else if(!target)
		status_bar = "未插入目标"
		return FALSE
	if(simulating == SIMULATION_STAGE_OFF)
		status_bar = "就绪"
	return TRUE

/obj/structure/machinery/chem_simulator/proc/print(id, is_new)
	icon_state = "modifier"
	playsound(loc, 'sound/machines/fax.ogg', 15, 1)
	flick("[icon_state]_printing",src)
	sleep(10)
	var/obj/item/paper/research_report/report = new /obj/item/paper/research_report/(loc)
	var/datum/reagent/D = GLOB.chemical_reagents_list[id]
	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	report.name = "[D.id]的模拟结果"
	report.info += "<center><img src = [asset.get_url_mappings()["wylogo.png"]]><HR><I><B>公司正式文件</B><BR>合成模拟报告</I><HR><H2>[D.id]的结果</H2></center>"
	report.generate(D)
	report.info += "<BR><HR><font size = \"1\"><I>本报告由合成模拟器自动打印。<BR>[MAIN_SHIP_NAME]，[time2text(world.timeofday, "MM/DD")]/[GLOB.game_year]，[worldtime2text()]</I></font><BR>\n<span class=\"paper_field\"></span>"
	playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
	if(is_new)
		GLOB.chemical_data.save_document(report, "Synthesis Simulations", report.name)

/obj/structure/machinery/chem_simulator/proc/encode_reagent(datum/reagent/C)
	var/datum/reagent/O = GLOB.chemical_reagents_list[C.original_id] //So make the new name based on the Original
	var/suffix = " "
	for(var/datum/chem_property/P in C.properties)
		suffix += P.code+"[P.level]"
	C.id = O.name + " " + copytext(md5(suffix),1,3) + suffix //Show random suffix AND real properties on research paper
	C.name = O.name + " " + copytext(md5(suffix),1,3) //Show ONLY random suffix on health analyzers
	return

/obj/structure/machinery/chem_simulator/proc/complexity_to_string_list()
	var/list/L = list()
	for(var/rarity in creation_complexity)
		switch(rarity)
			if(CHEM_CLASS_BASIC)
				LAZYADD(L, "BASIC")
			if(CHEM_CLASS_COMMON)
				LAZYADD(L, "COMMON")
			if(CHEM_CLASS_UNCOMMON)
				LAZYADD(L, "UNCOMMON")
			if(CHEM_CLASS_RARE)
				LAZYADD(L, "RARE")
	return L

/obj/structure/machinery/chem_simulator/proc/finalize_simulation(datum/reagent/generated/C)
	simulating = SIMULATION_STAGE_OFF
	end_simulation(C)
	chem_cache = null

/obj/structure/machinery/chem_simulator/proc/amplify(datum/reagent/generated/C)
	if(!target || !target_property)
		return
	C.make_alike(target.data)
	//Change the reagent
	C.relevel_property(target_property.name, target_property.level + 1)

/obj/structure/machinery/chem_simulator/proc/suppress(datum/reagent/generated/C)
	if(!target || !target_property)
		return
	C.make_alike(target.data)
	//Change the reagent
	C.relevel_property(target_property.name, max(target_property.level - 1, 0))

/obj/structure/machinery/chem_simulator/proc/relate(datum/reagent/generated/C)
	if(!target || !reference || !target_property || !reference_property)
		return
	C.make_alike(target.data)
	//Override the target with the reference
	C.remove_property(target_property.name)
	C.insert_property(reference_property.name, reference_property.level)

/obj/structure/machinery/chem_simulator/proc/create(datum/reagent/generated/C)
	C.chemclass = CHEM_CLASS_RARE
	C.name = creation_name
	if(LAZYLEN(C.name) < 2) //Don't know how this would even happen, but here's a safety
		C.generate_name()
	C.id = C.name
	C.properties = list()
	C.custom_metabolism = REAGENTS_METABOLISM
	C.color = text("#[][][]",num2hex(rand(0,255)),num2hex(rand(0,255)),num2hex(rand(0,255)))
	C.burncolor = C.color
	for(var/datum/chem_property/P in creation_template)
		C.insert_property(P.name, P.level)
	creation_name = "" //reset it
	end_simulation(C)

/obj/structure/machinery/chem_simulator/proc/end_simulation(datum/reagent/C)
	//Set tier
	C.gen_tier = max(min(C.chemclass, CHEM_CLASS_COMMON),C.gen_tier,1)
	if(C.chemclass == CHEM_CLASS_SPECIAL)
		C.gen_tier = 4

	//Change a single component of the reaction or generate a new one if there is no recipe
	var/datum/chemical_reaction/generated/R = new /datum/chemical_reaction/generated
	var/datum/chemical_reaction/generated/assoc_R

	R.gen_tier = C.gen_tier

	if(mode != MODE_CREATE)
		assoc_R = GLOB.chemical_reactions_list[target.data.id]
	if(!assoc_R) //no associated recipe found
		if(mode == MODE_CREATE)
			assoc_R = C.generate_assoc_recipe(creation_complexity)
		else
			assoc_R = C.generate_assoc_recipe()
	if(!assoc_R) //no possible associated recipe could be generated
		icon_state = "modifier"
		playsound(loc, 'sound/machines/buzz-two.ogg', 15, 1)
		simulating = SIMULATION_FAILURE
		qdel(C)
		qdel(R)
		return

	R.make_alike(assoc_R)

	if(mode != MODE_CREATE)
		if(length(R.required_reagents) > 2 && !recipe_targets[recipe_target]) //we only replace if the recipe isn't small and the target is not set TRUE to being elevated
			LAZYREMOVE(R.required_reagents, pick(R.required_reagents))
		R.add_component(recipe_target)

	//Handle new overdose
	C.overdose = new_od_level
	if(C.overdose < 1) //to prevent chems that start at 0 OD to become un-OD-able
		C.overdose = 1
	C.overdose_critical = max(min(new_od_level * 2, new_od_level + 30), 10)

	//Pay
	if(mode == MODE_CREATE)
		GLOB.chemical_data.update_credits(creation_cost * -1)
	else
		GLOB.chemical_data.update_credits(property_costs[target_property.name] * -1)
		//Refund 1 credit if a rare or rarer target was added
		var/datum/reagent/component = GLOB.chemical_reagents_list[recipe_target]
		if(component && component.chemclass >= CHEM_CLASS_RARE)
			GLOB.chemical_data.update_credits(1)


	//Save the reagent
	C.generate_description()
	C.chemclass = CHEM_CLASS_RARE //So that we can always scan this in the future, don't generate defcon, and don't get a loop of making credits
	GLOB.chemical_reagents_list[C.id] = C
	LAZYADD(simulations, C.id) //Remember we've simulated this

	//Save the reaction
	R.id = C.id
	R.result = C.id
	GLOB.chemical_reactions_list[R.id] = R
	R.add_to_filtered_list()
	status_bar = "模拟完成"
	print(C.id, TRUE)

/datum/chemical_simulator_modes
	var/name
	var/desc
	var/mode_id
	var/icon_type

/datum/chemical_simulator_modes/create
	name = "创建"
	desc = "根据先前发现的已知特性，创建一种新的自定义化学品。"
	mode_id = MODE_CREATE
	icon_type = "bolt"

/datum/chemical_simulator_modes/supress
	name = "抑制"
	desc = "将所选特性降低一级。此操作会降低过量阈值。"
	mode_id = MODE_SUPPRESS
	icon_type = "square-minus"

/datum/chemical_simulator_modes/amplify
	name = "增幅"
	desc = "将所选特性提高一级。此操作会降低过量阈值。"
	mode_id = MODE_AMPLIFY
	icon_type = "square-plus"

/datum/chemical_simulator_modes/relate
	name = "替换"
	desc = "使用参考化学品的特性替换目标化学品的一项特性。目标特性与参考特性的等级必须相同。此操作会降低过量阈值。"
	mode_id = MODE_RELATE
	icon_type = "repeat"

#undef SIMULATION_FAILURE
#undef SIMULATION_STAGE_OFF
#undef SIMULATION_STAGE_FINAL
#undef SIMULATION_STAGE_WAIT
#undef SIMULATION_STAGE_3
#undef SIMULATION_STAGE_4
#undef SIMULATION_STAGE_5
#undef SIMULATION_STAGE_BEGIN

#undef MODE_AMPLIFY
#undef MODE_SUPPRESS
#undef MODE_RELATE
#undef MODE_CREATE
