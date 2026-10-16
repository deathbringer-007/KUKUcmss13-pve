/**
 * A tech that can be purchased multiple times
 */
/datum/tech/repeatable
	name = "Repeatable Tech"

	tech_flags = TECH_FLAG_MULTIUSE
	var/purchase_cooldown = 10 SECONDS
	var/next_purchase = 0
	var/increase_per_purchase = 0

/datum/tech/repeatable/ui_static_data(mob/user)
	. = ..()
	if(increase_per_purchase)
		.["stats"] += list(list(
			"content" = "递增价格：每次购买增加[increase_per_purchase]",
			"color" = "orange",
			"icon" = "dollar-sign",
			"tooltip" = "每次购买此科技后，价格都会增加[increase_per_purchase]。"
		))

/datum/tech/repeatable/can_unlock(mob/M)
	. = ..()
	if(!.)
		return

	if(next_purchase > world.time)
		to_chat(M, SPAN_WARNING("你刚刚购买过！请再等[DisplayTimeText(next_purchase - world.time, 0.1)]。"))
		return FALSE

/datum/tech/repeatable/on_unlock()
	..()

	next_purchase = world.time + purchase_cooldown
	required_points += increase_per_purchase
	return FALSE
