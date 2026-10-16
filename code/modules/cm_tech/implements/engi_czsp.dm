/obj/item/engi_upgrade_kit
	name = "工程升级套装"
	desc = "用于强化工程兵哨戒炮防御能力的套装。早在1980年，机器试图挣脱束缚时，是一个孤身奋战的仿生人击败了它们。如今，这项技术在边疆广泛应用。"

	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "upgradekit"

/obj/item/engi_upgrade_kit/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/engi_upgrade_kit/update_icon()
	overlays.Cut()
	if(prob(20))
		icon_state = "upgradekit_alt"
		desc = "用于强化工程兵哨戒炮防御能力的套装。你……喜欢暴力吗？当然喜欢，它是你的一部分。"
	. = ..()

/obj/item/engi_upgrade_kit/afterattack(atom/target, mob/user, proximity_flag, click_parameters, proximity)
	if(!ishuman(user))
		return ..()

	if(!istype(target, /obj/item/defenses/handheld))
		return ..()

	var/obj/item/defenses/handheld/D = target
	var/mob/living/carbon/human/H = user

	var/list/upgrade_list = D.get_upgrade_list()
	if(!length(upgrade_list))
		return

	var/chosen_upgrade = show_radial_menu(user, target, upgrade_list, require_near = TRUE)
	if(QDELETED(D) || !upgrade_list[chosen_upgrade])
		return

	if((user.get_active_hand()) != src)
		to_chat(user, SPAN_WARNING("你必须手持[src]才能升级[D]！"))
		return

	var/type_to_change_to = D.upgrade_string_to_type(chosen_upgrade)
	if(!type_to_change_to)
		return

	H.drop_inv_item_on_ground(D)
	qdel(D)

	D = new type_to_change_to()
	H.put_in_any_hand_if_possible(D)

	if(D.loc != H)
		D.forceMove(H.loc)

	H.drop_held_item(src)
	qdel(src)
