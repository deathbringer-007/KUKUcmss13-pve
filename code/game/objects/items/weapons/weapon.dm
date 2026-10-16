//items designed as weapon
/obj/item/weapon
	name = "武器"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	hitsound = "swing_hit"
	flags_atom = FPRINT|QUICK_DRAWABLE

/obj/item/weapon/get_examine_text(mob/user)
	. = ..()
	var/strong_text = "威力较弱的"
	if(force >= MELEE_FORCE_TIER_1)
		switch(force)
			if((MELEE_FORCE_WEAK + 1) to MELEE_FORCE_NORMAL)
				strong_text = "威力普通的"
			if((MELEE_FORCE_NORMAL + 1) to MELEE_FORCE_STRONG)
				strong_text = "威力较强的"
			if((MELEE_FORCE_STRONG + 1) to MELEE_FORCE_VERY_STRONG)
				strong_text = "威力很强的"
			if((MELEE_FORCE_VERY_STRONG + 1) to INFINITY)
				strong_text = "威力超乎常理的"
		. += SPAN_INFO("如果用来击打他人，[src]会是一件[strong_text]武器。")

	if(throwforce >= MELEE_FORCE_TIER_1)
		strong_text = "威力较弱的"
		switch(throwforce)
			if((MELEE_FORCE_WEAK + 1) to MELEE_FORCE_NORMAL)
				strong_text = "威力普通的"
			if((MELEE_FORCE_NORMAL + 1) to MELEE_FORCE_STRONG)
				strong_text = "威力较强的"
			if((MELEE_FORCE_STRONG + 1) to MELEE_FORCE_VERY_STRONG)
				strong_text = "威力很强的"
			if((MELEE_FORCE_VERY_STRONG + 1) to INFINITY)
				strong_text = "威力超乎常理的"
		. += SPAN_INFO("如果把[src]扔向别人，它会是一件[strong_text]武器。")
