/datum/xeno_strain/hedgehog
	name = RAVAGER_HEDGEHOG
	localized_name = "刺猬"
	description = "你失去强化、冲锋、剪切斩和部分爪击伤害，换取更高的抗爆能力。抗性随碎片数量提高，达到50%时免疫部分爆炸眩晕。碎片会随时间及受到伤害而积累，可用于三种新技能：尖刺护盾提供临时护盾，受击时向周围射出骨片；发射尖刺使目标减速，并在其移动时造成伤害；释放尖刺射出全部尖刺，暂时加速，但在三十秒内停止生成碎片。"
	flavor_description = "刺穿它们千百次，让它们体会这种滋味。它将成为我的盾牌。"
	icon_state_prefix = "Hedgehog"

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/empower,
		/datum/action/xeno_action/activable/pounce/charge,
		/datum/action/xeno_action/activable/scissor_cut,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/spike_shield,
		/datum/action/xeno_action/activable/rav_spikes,
		/datum/action/xeno_action/onclick/spike_shed,
	)

	behavior_delegate_type = /datum/behavior_delegate/ravager_hedgehog

/datum/xeno_strain/hedgehog/apply_strain(mob/living/carbon/xenomorph/ravager/ravager)
	ravager.plasma_max = 0
	ravager.small_explosives_stun = TRUE
	ravager.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_SMALL
	ravager.damage_modifier -= XENO_DAMAGE_MOD_SMALL

	ravager.recalculate_everything()

/datum/behavior_delegate/ravager_hedgehog
	name = "Hedgehog Ravager Behavior Delegate"

	// Shard config
	var/max_shards = 300
	var/shard_gain_onlife = 5
	var/shards_per_projectile = 10
	var/shards_per_slash = 15
	var/armor_buff_per_fifty_shards = 2.50
	var/shard_lock_duration = 150
	var/shard_lock_speed_mod = 0.45

	// Shard state
	var/shards = 0
	var/shards_locked = FALSE //are we locked at 0 shards?

	// Armor buff state
	var/times_armor_buffed = 0

/datum/behavior_delegate/ravager_hedgehog/append_to_stat()
	. = list()
	. += "骨片：[shards]/[max_shards]"
	. += "碎片护甲加成：[times_armor_buffed*armor_buff_per_fifty_shards]"

/datum/behavior_delegate/ravager_hedgehog/proc/lock_shards()

	if (!bound_xeno)
		return

	to_chat(bound_xeno, SPAN_XENODANGER("你已释放尖刺，在[shard_lock_duration/10]秒内无法再积累尖刺！"))

	bound_xeno.speed_modifier -= shard_lock_speed_mod
	bound_xeno.recalculate_speed()

	shards = 0
	shards_locked = TRUE
	addtimer(CALLBACK(src, PROC_REF(unlock_shards)), shard_lock_duration)

/datum/behavior_delegate/ravager_hedgehog/proc/unlock_shards()

	if (!bound_xeno)
		return

	to_chat(bound_xeno, SPAN_XENODANGER("你感到积累碎片的能力恢复了！"))

	bound_xeno.speed_modifier += shard_lock_speed_mod
	bound_xeno.recalculate_speed()
	shards_locked = FALSE

// Return true if we have enough shards, false otherwise
/datum/behavior_delegate/ravager_hedgehog/proc/check_shards(amount)
	if (!amount)
		return FALSE
	else
		return (shards >= amount)

/datum/behavior_delegate/ravager_hedgehog/proc/use_shards(amount)
	if (!amount)
		return
	shards = max(0, shards - amount)

/datum/behavior_delegate/ravager_hedgehog/on_life()

	if (!shards_locked)
		shards = min(max_shards, shards + shard_gain_onlife)

	var/armor_buff_count = shards/50 //0-6
	bound_xeno.armor_modifier -= times_armor_buffed * armor_buff_per_fifty_shards
	bound_xeno.armor_modifier += armor_buff_count * armor_buff_per_fifty_shards
	bound_xeno.recalculate_armor()
	times_armor_buffed = armor_buff_count

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_shards = round((shards / max_shards) * 100, 10)
	if(percentage_shards)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_shards]")

	if(percentage_shards >= 50)
		bound_xeno.small_explosives_stun = FALSE
		bound_xeno.add_filter("hedge_unstunnable", 1, list("type" = "outline", "color" = "#421313", "size" = 1))
	else
		bound_xeno.small_explosives_stun = TRUE
		bound_xeno.remove_filter("hedge_unstunnable", 1, list("type" = "outline", "color" = "#421313", "size" = 1))


	return


/datum/behavior_delegate/ravager_hedgehog/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/ravager_hedgehog/on_hitby_projectile()
	if (!shards_locked)
		shards = min(max_shards, shards + shards_per_projectile)
	return

/datum/behavior_delegate/ravager_hedgehog/melee_attack_additional_effects_self()
	if (!shards_locked)
		shards = min(max_shards, shards + shards_per_slash)
	return
