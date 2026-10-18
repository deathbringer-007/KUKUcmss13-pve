/datum/random_fact/damage
	statistic_name = "点伤害"
	statistic_verb = "承受了"

/datum/random_fact/damage/life_grab_stat(mob/fact_mob)
	return fact_mob.life_damage_taken_total

/datum/random_fact/damage/death_grab_stat(datum/entity/statistic/death/fact_death)
	return fact_death.total_damage_taken
