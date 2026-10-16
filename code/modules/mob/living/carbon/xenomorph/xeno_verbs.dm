//// Holds Xeno verbs that don't belong anywhere else.
/mob/living/carbon/xenomorph/verb/hive_status()
	set name = "虫巢状态"
	set desc = "查看我们当前虫巢的状态。"
	set category = "Alien"

	if(!hive)
		return

	if((!hive.living_xeno_queen || SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST) && !hive.allow_no_queen_actions) //No Hive status on WO
		to_chat(src, SPAN_WARNING("没有女皇，我们孤立无援。"))
		return

	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		to_chat(src, SPAN_WARNING("我们的精神连接暂时中断了！"))
		return

	hive.hive_ui.open_hive_status(src)

/mob/living/carbon/xenomorph/verb/hive_alliance_status()
	set name = "虫巢同盟状态"
	set desc = "查看同盟的状态。"
	set category = "Alien"

	if(!hive)
		return

	if(hive.hivenumber == XENO_HIVE_RENEGADE) //Renegade's ability to attack someone depends on IFF settings, not on alliance
		if(!iff_tag)
			to_chat(src, SPAN_NOTICE("你没有保护任何人的义务。"))
			return
		to_chat(src, SPAN_NOTICE("你似乎被迫保护[english_list(iff_tag.faction_groups, "无人")]。"))
		return

	if((!hive.living_xeno_queen || Check_WO()) && !hive.allow_no_queen_actions) //No Hive status on WO
		to_chat(src, SPAN_WARNING("没有女皇，你孤立无援。"))
		return

	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		to_chat(src, SPAN_WARNING("我们的精神连接暂时中断了！"))
		return

	hive.faction_ui.tgui_interact(src)

/mob/living/carbon/xenomorph/verb/clear_built_structures()
	set name = "清除已建建筑"
	set desc = "清除你建造且归属于你的建筑。"
	set category = "Alien"

	if(!length(built_structures))
		to_chat(usr, SPAN_WARNING("你没有建造任何建筑！"))
		return

	var/list/options = list()
	for(var/i in built_structures)
		var/atom/A = i
		options[initial(A.name)] = i

	var/input = tgui_input_list(usr, "选择要清除的建筑类型", "清除已建建筑", options, theme="hive_status")

	if(!input)
		return

	var/type = options[input]

	var/cleared_amount = 0
	for(var/i in built_structures[type])
		cleared_amount++
		built_structures[type] -= i
		if(isturf(i))
			var/turf/T = i
			T.ScrapeAway()
			continue
		qdel(i)

	to_chat(usr, SPAN_INFO("已摧毁[cleared_amount]个[input]。"))


/mob/living/carbon/xenomorph/verb/toggle_xeno_mobhud()
	set name = "切换异形状态HUD"
	set desc = "切换异形头顶显示生命值和等离子体的HUD。"
	set category = "Alien"

	var/datum/mob_hud/H = GLOB.huds[MOB_HUD_XENO_STATUS]
	if (xeno_mobhud)
		H.remove_hud_from(usr, usr)
	else
		H.add_hud_to(usr, usr)

	xeno_mobhud = !xeno_mobhud

/mob/living/carbon/xenomorph/verb/toggle_xeno_hostilehud()
	set name = "切换敌方状态HUD"
	set desc = "切换显示人类各类负面状态的HUD。"
	set category = "Alien"

	var/datum/mob_hud/H = GLOB.huds[MOB_HUD_XENO_HOSTILE]
	if (xeno_hostile_hud)
		H.remove_hud_from(usr, usr)
	else
		H.add_hud_to(usr, usr)

	xeno_hostile_hud = !xeno_hostile_hud

/mob/living/carbon/xenomorph/verb/ability_deactivation_toggle()
	set name = "切换技能取消激活"
	set desc = "切换再次选择当前技能时是否取消激活。"
	set category = "Alien"

	if (!client || !client.prefs)
		return

	client.prefs.toggle_prefs ^= TOGGLE_ABILITY_DEACTIVATION_OFF
	client.prefs.save_preferences()
	if (client.prefs.toggle_prefs & TOGGLE_ABILITY_DEACTIVATION_OFF)
		to_chat(src, SPAN_NOTICE("再次选择当前技能时，不会再取消激活。"))
	else
		to_chat(src, SPAN_NOTICE("再次选择当前技能时，会取消激活。"))

/mob/living/carbon/xenomorph/verb/directional_attack_toggle()
	set name = "切换方向攻击"
	set desc = "切换方向辅助攻击。"
	set category = "Alien"

	if (!client || !client.prefs)
		return

	client.prefs.toggle_prefs ^= TOGGLE_DIRECTIONAL_ATTACK
	client.prefs.save_preferences()
	if(client.prefs.toggle_prefs & TOGGLE_DIRECTIONAL_ATTACK)
		to_chat(src, SPAN_NOTICE("攻击现在会使用方向辅助。"))
	else
		to_chat(src, SPAN_NOTICE("攻击不再使用方向辅助。"))

/mob/living/carbon/xenomorph/cancel_camera()
	. = ..()

	if(observed_xeno)
		overwatch(observed_xeno, TRUE)

// /mob/living/carbon/xenomorph/verb/enter_tree()
// set name = "Enter Techtree"
// set desc = "Enter the Xenomorph techtree"
// set category = "Alien.Techtree"

// var/datum/techtree/T = GET_TREE(TREE_XENO)
// T.enter_mob(src)
