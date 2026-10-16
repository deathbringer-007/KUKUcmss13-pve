/obj/item/circuitboard
	w_class = SIZE_SMALL
	name = "电路板"
	icon = 'icons/obj/items/circuitboards.dmi'
	icon_state = "id_mod"
	item_state = "electronic"
	flags_atom = FPRINT|CONDUCT
	matter = list("metal" = 50, "glass" = 50)
	var/build_path = null





//Called when the circuitboard is used to contruct a new machine.
/obj/item/circuitboard/proc/construct(obj/structure/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0


//Called when a computer is deconstructed to produce a circuitboard.
//Only used by computers, as other machines store their circuitboard instance.
/obj/item/circuitboard/proc/disassemble(obj/structure/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0



/obj/item/circuitboard/aicore
	name = "电路板（AI 核心）"


/obj/item/circuitboard/airalarm
	name = "空气警报器电子组件"
	gender = PLURAL
	icon_state = "door_electronics"
	desc = "看起来像个电路板。大概就是吧。"



/obj/item/circuitboard/firealarm
	name = "火灾警报器电子组件"
	gender = PLURAL
	icon_state = "door_electronics"
	desc = "一个电路板。上面的标签写着：\"最高可耐受40摄氏度高温！\""


/obj/item/circuitboard/apc
	name = "电力控制模块"
	icon_state = "power_mod"
	desc = "用于电力控制的重型开关电路。"

/obj/item/circuitboard/apc/attackby(obj/item/W , mob/user)
	if (HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
		var/obj/item/circuitboard/machine/ghettosmes/newcircuit = new(user.loc)
		user.put_in_hands(newcircuit)
		qdel(src)



// Tracker Electronic
/obj/item/circuitboard/solar_tracker
	name = "追日器电子组件"
	gender = PLURAL
	icon_state = "door_electronics"
