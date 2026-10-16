/obj/item/explosive/grenade/empgrenade
	name = "经典电磁脉冲手榴弹"
	desc = "大范围电磁脉冲手榴弹。"
	icon_state = "emp"
	item_state = "emp"
	

/obj/item/explosive/grenade/empgrenade/prime()
	..()
	if(empulse(src, 4, 10))
		qdel(src)
	return

/obj/item/explosive/grenade/empgrenade/dutch
	name = "达奇特调"
	desc = "大范围电磁脉冲手榴弹。标签上写着：“隐形装置克星——超强效”。"
	icon_state = "emp"
	item_state = "emp"

/obj/item/explosive/grenade/empgrenade/dutch/prime()
	..()
	if(empulse(src, 15, 20))
		qdel(src)
	return
