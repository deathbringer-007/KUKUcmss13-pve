
// Light Replacer (LR)
//
// ABOUT THE DEVICE
//
// This is a device supposedly to be used by Janitors and Janitor Cyborgs which will
// allow them to easily replace lights. This was mostly designed for Janitor Cyborgs since
// they don't have hands or a way to replace lightbulbs.
//
// HOW IT WORKS
//
// You attack a light fixture with it, if the light fixture is broken it will replace the
// light fixture with a working light; the broken light is then placed on the floor for the
// user to then pickup with a trash bag. If it's empty then it will just place a light in the fixture.
//
// HOW TO REFILL THE DEVICE
//
// It will need to be manually refilled with lights.
// If it's part of a robot module, it will charge when the Robot is inside a Recharge Station.
//
// EMAGGED FEATURES
//
// NOTICE: The Cyborg cannot use the emagged Light Replacer and the light's explosion was nerfed. It cannot create holes in the station anymore.
//
// I'm not sure everyone will react the emag's features so please say what your opinions are of it.
//
// When emagged it will rig every light it replaces, which will explode when the light is on.
// This is VERY noticeable, even the device's name changes when you emag it so if anyone
// examines you when you're holding it in your hand, you will be discovered.
// It will also be very obvious who is setting all these lights off, since only Janitor Borgs and Janitors have easy
// access to them, and only one of them can emag their device.
//
// The explosion cannot insta-kill anyone with 30% or more health.

#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3


/obj/item/device/lightreplacer

	name = "灯具更换器"
	desc = "用于自动更换灯具的设备。可装入完好的灯泡补充库存。"

	icon = 'icons/obj/janitor.dmi'
	icon_state = "lightreplacer0"
	item_state = "electronic"

	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST


	var/max_uses = 50
	var/uses = 0
	var/failmsg = ""
	var/charge = 1

/obj/item/device/lightreplacer/Initialize()
	. = ..()
	uses = max_uses
	failmsg = "[name]的补充指示灯闪着红光。"

/obj/item/device/lightreplacer/get_examine_text(mob/user)
	. = ..()
	. += "还剩 [uses] 个备用灯具。"

/obj/item/device/lightreplacer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/G = W
		if(uses >= max_uses)
			to_chat(user, SPAN_WARNING("[src.name]已装满。"))
			return
		else if(G.use(1))
			AddUses(5)
			to_chat(user, SPAN_NOTICE("你将一片玻璃装入[src.name]。现有 [uses] 个备用灯具。"))
			return
		else
			to_chat(user, SPAN_WARNING("你需要一片玻璃来补充备用灯具。"))

	if(istype(W, /obj/item/light_bulb))
		var/obj/item/light_bulb/L = W
		if(L.status == 0) // LIGHT OKAY
			if(uses < max_uses)
				AddUses(1)
				to_chat(user, "你将[L.name]装入[src.name]。现有 [uses] 个备用灯具。")
				user.drop_held_item()
				qdel(L)
				return
		else
			to_chat(user, "你需要一个完好的灯具。")
			return


/obj/item/device/lightreplacer/attack_self(mob/user)
	..()
	to_chat(usr, "还剩 [uses] 个备用灯具。")

/obj/item/device/lightreplacer/update_icon()
	icon_state = "lightreplacer0"


/obj/item/device/lightreplacer/proc/Use(mob/user)

	playsound(src.loc, 'sound/machines/click.ogg', 25, 1)
	AddUses(-1)
	return 1

// Negative numbers will subtract
/obj/item/device/lightreplacer/proc/AddUses(amount = 1)
	uses = min(max(uses + amount, 0), max_uses)

/obj/item/device/lightreplacer/proc/Charge(mob/user)
	charge++
	if(charge > 7)
		AddUses(1)
		charge = 1

/obj/item/device/lightreplacer/proc/ReplaceLight(obj/structure/machinery/light/target, mob/living/U)

	if(target.status != LIGHT_OK)
		if(CanUse(U))
			if(!Use(U)) return
			to_chat(U, SPAN_NOTICE("你用[src]更换了[target.fitting]。"))

			if(target.status != LIGHT_EMPTY)

				var/obj/item/light_bulb/L1 = new target.light_type(target.loc)
				L1.status = target.status
				L1.rigged = target.rigged
				L1.brightness = target.brightness
				L1.switchcount = target.switchcount
				target.switchcount = 0
				L1.update()

				target.status = LIGHT_EMPTY
				target.update()

			var/obj/item/light_bulb/L2 = new target.light_type()

			target.status = L2.status
			target.switchcount = L2.switchcount
			target.rigged = FALSE
			target.brightness = L2.brightness
			target.on = target.has_power()
			target.update()
			qdel(L2)

			if(target.on && target.rigged)
				target.explode()
			return

		else
			to_chat(U, failmsg)
			return
	else
		to_chat(U, "这里已装有完好的[target.fitting]。")
		return

//Can you use it?

/obj/item/device/lightreplacer/proc/CanUse(mob/living/user)
	src.add_fingerprint(user)
	//Not sure what else to check for. Maybe if clumsy?
	if(uses > 0)
		return 1
	else
		return 0

#undef LIGHT_OK
#undef LIGHT_EMPTY
#undef LIGHT_BROKEN
#undef LIGHT_BURNED
