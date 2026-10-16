/datum/tech/transitory
	name = "Transitory tech"
	desc = "将科技树提升至下一等级。"
	icon_state = "upgrade"

	var/datum/tier/before
	var/datum/tier/next

	var/techs_to_unlock = 0
	is_tier_changer = TRUE

/datum/tech/transitory/check_tier_level(mob/M)
	if(before && before != holder.tier.type)
		to_chat(M, SPAN_WARNING("你无法解锁此节点！"))
		return

	if(techs_to_unlock > 0)
		var/amount_of_unlocked_techs = LAZYLEN(holder.unlocked_techs[before])

		if(amount_of_unlocked_techs < techs_to_unlock)
			to_chat(M, SPAN_WARNING("你必须先解锁[initial(before.name)]中的[techs_to_unlock]项科技，才能解锁此科技！"))
			return FALSE

	return TRUE

/datum/tech/transitory/on_unlock(mob/user)
	. = ..()
	if(!next)
		return
	var/datum/tier/previous_tier = holder.tier
	var/datum/tier/next_tier = holder.tree_tiers[next]
	if(next_tier)
		holder.tier = next_tier
		holder.on_tier_change(previous_tier)
		if(flags & TREE_FLAG_MARINE)
			/// Due to calling parent, points will have already been spent by now.
			var/current_points = holder.points + required_points
			log_ares_tech(user.real_name, is_tier_changer, "阿尔迈耶号战备等级已提升", "威胁评估等级已提升至[next_tier.tier]级。\n\n已授权使用[next_tier.tier]级装备应对当前情况。", required_points, current_points)

/datum/tech/transitory/get_tier_overlay()
	if(!next)
		return

	var/datum/tier/next_tier = holder.tree_tiers[next]
	var/image/I = ..()
	I.color = next_tier.color

	return I

/datum/tech/transitory/tier1
	name = "解锁一级"
	tier = /datum/tier/free

	flags = TREE_FLAG_MARINE|TREE_FLAG_XENO

	next = /datum/tier/one

/datum/tech/transitory/tier2
	name = "解锁二级"
	tier = /datum/tier/one_transition_two

	before = /datum/tier/one
	next = /datum/tier/two

/datum/tech/transitory/tier2/xeno
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_XENO

/datum/tech/transitory/tier2/marine
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_MARINE

/datum/tech/transitory/tier3
	name = "解锁三级"
	tier = /datum/tier/two_transition_three

	before = /datum/tier/two
	next = /datum/tier/three

/datum/tech/transitory/tier3/xeno
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_XENO

/datum/tech/transitory/tier3/marine
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_MARINE

/datum/tech/transitory/tier4
	name = "解锁四级"
	tier = /datum/tier/three_transition_four

	before = /datum/tier/three
	next = /datum/tier/four

/datum/tech/transitory/tier4/xeno
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_XENO

/datum/tech/transitory/tier4/marine
	techs_to_unlock = 0
	required_points = 5

	flags = TREE_FLAG_MARINE
