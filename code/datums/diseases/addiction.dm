/datum/disease/addiction
	form = "病症"
	name = "药物成瘾"
	max_stages = 4
	cure = "戒断"
	curable = 0
	agent = "化学物质成瘾"
	affected_species = list("Human")
	permeability_mod = 1
	can_carry = 0
	spread_type = NON_CONTAGIOUS
	desc = "使用成瘾性兴奋剂会导致生理和心理依赖。"
	severity = "中等"
	longevity = 1000
	hidden = list(1, 1) //hidden from med-huds and pandemic scanners
	contagious_period = 900001 //additional safeguard to prevent spreading
	stage_minimum_age = 900001 // advanced only by chemical
	var/addiction_progression = 1
	var/progression_threshold = 300 //how many life() ticks it takes to advance stage. At 300, a 5 unit pill should increase progression from 0 to just below the threshold
	var/withdrawal_progression = 0 //how long the individual has been in withdrawal
	var/addiction_multiplier = 1
	var/chemical_id

/datum/disease/addiction/New(chem_id, potency = 1)
	addiction_multiplier = potency
	chemical_id = chem_id
	..(TRUE)

/datum/disease/addiction/stage_act()
	..()

	//withdrawal process
	if(affected_mob.reagents.has_reagent(chemical_id))
		withdrawal_progression = 0
		return

	addiction_progression -= 0.383 //about 30 minutes to get past each stage
	if(addiction_progression < 0)
		if(stage == 1)
			addiction_progression = 0 // never truly goes away
		else
			stage = max(stage-1, 0)
			addiction_progression = progression_threshold

	withdrawal_progression += addiction_multiplier

	//symptoms
	switch(stage)
		if(1)
			if(addiction_progression)
				if(prob(20))
					affected_mob.halloss = max(affected_mob.halloss, min(20, withdrawal_progression*0.5) )
					if(prob(50))
						var/message = SPAN_DANGER( pick("你觉得该再来一口。", "再多来一点就舒服了。", "再用一剂就会好起来。", "再来一剂也无妨。", "何不再来一次？") )
						to_chat(affected_mob, message)

				affected_mob.next_move_slowdown = max(affected_mob.next_move_slowdown, 5)

			else
				if(prob(20))
					affected_mob.halloss = max(affected_mob.halloss, 12)

		if(2)
			if(prob(20))
				affected_mob.halloss = max(affected_mob.halloss, min(40, withdrawal_progression) )
				if(prob(50))
					var/message = SPAN_DANGER( pick("没了它，感觉就是不一样。", "你觉得该再来一口。", "你该再用一次。", "就再来一次。", "看来你又需要它了。") )
					to_chat(affected_mob, message)
				if(prob(25))
					affected_mob.emote("me",1, pick("微微抽搐了一下。", "露出痛苦的表情。") )

			affected_mob.next_move_slowdown = max(affected_mob.next_move_slowdown, 7)

		if(3)
			if(prob(3))
				affected_mob.hallucination = max(50, affected_mob.hallucination)

			if(prob(20))
				affected_mob.halloss = max(affected_mob.halloss, min(60, withdrawal_progression*1.5) )
				if(prob(50))
					var/message = SPAN_DANGER( pick("你需要更多。", "这样下去实在难熬。", "你想要更多。你需要更多。", "再来一口。现在就来。", "再来一次。") )
					to_chat(affected_mob, message)
				if(prob(25))
					affected_mob.emote("me",1, pick("痛苦地抽搐了一下。", "露出痛苦的表情。", "呻吟起来！") )

			affected_mob.next_move_slowdown = max(affected_mob.next_move_slowdown, 10)

		if(4)
			if(prob(5))
				affected_mob.hallucination = max(75, affected_mob.hallucination)

			if(prob(20))
				affected_mob.halloss = max(affected_mob.halloss, min(80, withdrawal_progression*2) )
				if(prob(50))
					var/message = SPAN_DANGER( pick("你需要再用一剂，现在。马上！", "你受不了了。你必须回去。必须回去。", "你需要更多。你必须得到更多！", "更多！", "再多用一点！") )
					to_chat(affected_mob, message)
				if(prob(25))
					affected_mob.emote("me",1, pick("痛苦地呻吟着！", "痛得蜷缩起来！"))
			affected_mob.next_move_slowdown = max(affected_mob.next_move_slowdown, 10)

/datum/disease/addiction/proc/handle_chem()
	if(stage < max_stages)
		addiction_progression += addiction_multiplier
		if(addiction_progression > progression_threshold)
			addiction_progression = 0
			stage++
	else
		addiction_progression = min(addiction_progression+1, progression_threshold) //withdrawal buffer

	switch(stage)
		if(2)
			if(prob(1))
				affected_mob.hallucination = max(50, affected_mob.hallucination)
		if(3)
			if(prob(1))
				affected_mob.hallucination = max(75, affected_mob.hallucination)
		if(4)
			if(prob(2))
				affected_mob.hallucination = max(75, affected_mob.hallucination)
			if(prob(0.5))
				var/affected_organ = pick("heart","lungs","liver","kidneys")
				var/mob/living/carbon/human/H = affected_mob
				var/datum/internal_organ/I =  H.internal_organs_by_name[affected_organ]
				I.take_damage(5)

	if(prob(2))
		affected_mob.emote(pick("twitch","blink_r","shiver"))

/datum/disease/addiction/Copy()
	return new type(chemical_id, addiction_multiplier)
