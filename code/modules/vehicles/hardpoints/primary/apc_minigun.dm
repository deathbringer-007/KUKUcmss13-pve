/obj/item/hardpoint/primary/gshk_minigun
	name = "\improper Gshk-5000.K转管机枪"
	desc = "电动转管加特林机枪。Gshk-5000.K源自单兵携行设计，是提供有效火力支援与压制的反人员系统。与美国GAU-8不同，它使用电脉冲机构，取代了自燃液体燃料。"
	icon = 'icons/obj/vehicles/hardpoints/uppapc.dmi'

	icon_state = "apc_minigun"
	disp_icon = "uppapc"
	disp_icon_state = "apc_minigun"

	health = 1000
	firing_arc = 90

	ammo = new /obj/item/ammo_magazine/hardpoint/Gshk_minigun
	max_clips = 2

	px_offsets = list(
		"1" = list(0, 0),
		"2" = list(0, 0),
		"4" = list(0, 0),
		"8" = list(0, 0)
	)

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash"

	muzzle_flash_pos = list(
		"1" = list(16.5, 45),
		"2" = list(16.3, -43),
		"4" = list(63, 0.5),
		"8" = list(-30, 1)
	)

	scatter = 3
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.2 SECONDS //base fire rate, modified by stage_delay_mult

	activation_sounds = list('sound/weapons/gun_minigun.ogg')
	/// Active firing time to reach max spin_stage.
	var/spinup_time = 8 SECONDS
	/// Grace period before losing spin_stage.
	var/spindown_grace_time = 2 SECONDS
	COOLDOWN_DECLARE(spindown_grace_cooldown)
	/// Cooldown time to reach min spin_stage.
	var/spindown_time = 3 SECONDS
	/// Index of stage_rate.
	var/spin_stage = 1
	/// Shots fired per fire_delay at a particular spin_stage.
	var/list/stage_rate = list(1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5)
	/// Fire delay multiplier for current spin_stage.
	var/stage_delay_mult = 1
	/// When it was last fired, related to world.time.
	var/last_fired = 0

/obj/item/hardpoint/primary/gshk_minigun/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/primary/gshk_minigun/set_fire_delay(value)
	fire_delay = value
	SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay * stage_delay_mult)

/obj/item/hardpoint/primary/gshk_minigun/set_fire_cooldown()
	calculate_stage_delay_mult() //needs to check grace_cooldown before refreshed
	last_fired = world.time
	COOLDOWN_START(src, spindown_grace_cooldown, spindown_grace_time)
	COOLDOWN_START(src, fire_cooldown, fire_delay * stage_delay_mult)

/obj/item/hardpoint/primary/gshk_minigun/proc/calculate_stage_delay_mult()
	var/stage_rate_len = stage_rate.len
	var/delta_time = world.time - last_fired

	var/old_spin_stage = spin_stage
	if(auto_firing || burst_firing) //spinup if continuing fire
		var/delta_stage = delta_time * (stage_rate_len - 1)
		spin_stage += delta_stage / spinup_time
	else if(COOLDOWN_FINISHED(src, spindown_grace_cooldown)) //spindown if initiating fire after grace
		var/delta_stage = (delta_time - spindown_grace_time) * (stage_rate_len - 1)
		spin_stage -= delta_stage / spindown_time
	else
		return
	spin_stage = clamp(spin_stage, 1, stage_rate_len)

	var/old_stage_rate = stage_rate[floor(old_spin_stage)]
	var/new_stage_rate = stage_rate[floor(spin_stage)]

	if(old_stage_rate != new_stage_rate)
		stage_delay_mult = 1 / new_stage_rate
		SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay * stage_delay_mult)
