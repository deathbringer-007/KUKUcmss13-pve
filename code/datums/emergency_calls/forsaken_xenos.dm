/datum/emergency_call/forsaken_xenos
	name = "Xenomorphs Groundside (Forsaken)"
	localized_name = "地面异形（遗弃虫巢）"
	mob_min = 1
	mob_max = 4
	hostility = TRUE
	shuttle_id = ""
	name_of_spawn = /obj/effect/landmark/ert_spawns/groundside_xeno
	objectives = "你被留在这里守卫废弃的殖民地。不得让外来者闯入。"

/datum/emergency_call/forsaken_xenos/create_member(datum/mind/new_member, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/current_mob = new_member.current

	var/picked = pick_weight(list(/mob/living/carbon/xenomorph/warrior = 2, /mob/living/carbon/xenomorph/lurker = 2, /mob/living/carbon/xenomorph/spitter = 2, /mob/living/carbon/xenomorph/drone = 5, /mob/living/carbon/xenomorph/runner = 5))

	var/mob/living/carbon/xenomorph/new_xeno = new picked(spawn_loc)

	new_member.transfer_to(new_xeno, TRUE)

	new_xeno.set_hive_and_update(XENO_HIVE_FORSAKEN)
	new_xeno.lock_evolve = TRUE

	QDEL_NULL(current_mob)
