/obj/structure/prop/mech
	icon = 'icons/obj/structures/props/mech.dmi'

/obj/structure/prop/mech/hydralic_clamp
	name = "液压夹钳"
	icon_state = "mecha_clamp"

/obj/structure/prop/mech/drill
	name = "钻头"
	desc = "这就是能钻破天际的钻头！"
	icon_state = "mecha_drill"

/obj/structure/prop/mech/armor_booster
	name = "装甲强化模块（近战武器防护）"
	desc = "强化外骨骼装甲，使其更能抵御近战武器攻击。运行时需要消耗能量。"
	icon_state = "mecha_abooster_ccw"

/obj/structure/prop/mech/repair_droid
	name = "维修机器人"
	desc = "自动维修机器人，会扫描并修复外骨骼的损伤，几乎能修复所有类型的内部和外部损坏。"
	icon_state = "repair_droid"

/obj/structure/prop/mech/tesla_energy_relay
	name = "能量中继器"
	desc = "以无线方式从区域内任何可用的供电通道抽取能量，性能指标相当低。"
	icon_state = "tesla"

/obj/structure/prop/mech/parts
	name = "机甲部件"
	flags_atom = FPRINT|CONDUCT

/obj/structure/prop/mech/parts/chassis
	name="机甲底盘"
	icon_state = "backbone"

// ripley to turn into P-1000 an Older version of the P-5000 to anchor it more into the lore...
/obj/structure/prop/mech/parts/chassis/ripley
	name = "P-1000底盘"
	icon_state = "ripley_chassis"
/obj/structure/prop/mech/parts/chassis/firefighter
	name = "消防员底盘"
	icon_state = "ripley_chassis"
/obj/structure/prop/mech/parts/ripley_torso
	name="P-1000躯干"
	desc="P-1000 APLU的躯干部件，内含动力单元、处理核心和生命维持系统。"
	icon_state = "ripley_harness"
/obj/structure/prop/mech/parts/ripley_left_arm
	name="P-1000左臂"
	desc="P-1000 APLU的左臂，数据和电源接口兼容大多数外骨骼工具。"
	icon_state = "ripley_l_arm"
/obj/structure/prop/mech/parts/ripley_right_arm
	name="P-1000右臂"
	desc="P-1000 APLU的右臂，数据和电源接口兼容大多数外骨骼工具。"
	icon_state = "ripley_r_arm"
/obj/structure/prop/mech/parts/ripley_left_leg
	name="P-1000左腿"
	desc="P-1000 APLU的左腿，内含相当复杂的伺服驱动装置和平衡维持系统。"
	icon_state = "ripley_l_leg"
/obj/structure/prop/mech/parts/ripley_right_leg
	name="P-1000右腿"
	desc="P-1000 APLU的右腿，内含相当复杂的伺服驱动装置和平衡维持系统。"
	icon_state = "ripley_r_leg"

//gygax turned into MAX (Mobile Assault Exo-Warrior)look like a gygax from afar
/obj/structure/prop/mech/parts/chassis/gygax
	name = "MAX底盘"
	icon_state = "gygax_chassis"
/obj/structure/prop/mech/parts/gygax_torso
	name="MAX躯干"
	desc="MAX的躯干部件，内含动力单元、处理核心和生命维持系统，另有一个额外装备插槽。"
	icon_state = "gygax_harness"
/obj/structure/prop/mech/parts/gygax_head
	name="MAX头部"
	desc="MAX的头部，内置先进的监视和瞄准传感器。"
	icon_state = "gygax_head"
/obj/structure/prop/mech/parts/gygax_left_arm
	name="MAX左臂"
	desc="MAX的左臂，数据和电源接口兼容大多数外骨骼工具及武器。"
	icon_state = "gygax_l_arm"
/obj/structure/prop/mech/parts/gygax_right_arm
	name="MAX右臂"
	desc="MAX的右臂，数据和电源接口兼容大多数外骨骼工具及武器。"
	icon_state = "gygax_r_arm"
/obj/structure/prop/mech/parts/gygax_left_leg
	name="MAX左腿"
	icon_state = "gygax_l_leg"
/obj/structure/prop/mech/parts/gygax_right_leg
	name="MAX右腿"
	icon_state = "gygax_r_leg"
/obj/structure/prop/mech/parts/gygax_armor
	name="MAX装甲板"
	icon_state = "gygax_armor"

// durand MOX (mobile offensive exo-warrior) look like a durand from afar.
/obj/structure/prop/mech/parts/chassis/durand
	name = "MOX底盘"
	icon_state = "durand_chassis"
/obj/structure/prop/mech/parts/durand_torso
	name="MOX躯干"
	icon_state = "durand_harness"
/obj/structure/prop/mech/parts/durand_head
	name="MOX头部"
	icon_state = "durand_head"
/obj/structure/prop/mech/parts/durand_left_arm
	name="MOX左臂"
	icon_state = "durand_l_arm"
/obj/structure/prop/mech/parts/durand_right_arm
	name="MOX右臂"
	icon_state = "durand_r_arm"
/obj/structure/prop/mech/parts/durand_left_leg
	name="MOX左腿"
	icon_state = "durand_l_leg"
/obj/structure/prop/mech/parts/durand_right_leg
	name="MOX右腿"
	icon_state = "durand_r_leg"
/obj/structure/prop/mech/parts/durand_armor
	name="MOX装甲板"
	icon_state = "durand_armor"

// phazon currently not in use. could  be deleted...
/obj/structure/prop/mech/parts/chassis/phazon
	name = "法宗底盘"
	icon_state = "phazon_chassis"
/obj/structure/prop/mech/parts/phazon_torso
	name="法宗躯干"
	icon_state = "phazon_harness"
/obj/structure/prop/mech/parts/phazon_head
	name="法宗头部"
	icon_state = "phazon_head"
/obj/structure/prop/mech/parts/phazon_left_arm
	name="法宗左臂"
	icon_state = "phazon_l_arm"
/obj/structure/prop/mech/parts/phazon_right_arm
	name="法宗右臂"
	icon_state = "phazon_r_arm"
/obj/structure/prop/mech/parts/phazon_left_leg
	name="法宗左腿"
	icon_state = "phazon_l_leg"
/obj/structure/prop/mech/parts/phazon_right_leg
	name="法宗右腿"
	icon_state = "phazon_r_leg"
/obj/structure/prop/mech/parts/phazon_armor_plates
	name="法宗装甲板"
	icon_state = "phazon_armor"

// odysseus currently not in use  could  be deleted...
/obj/structure/prop/mech/parts/chassis/odysseus
	name = "奥德修斯底盘"
	icon_state = "odysseus_chassis"
/obj/structure/prop/mech/parts/odysseus_head
	name="奥德修斯头部"
	icon_state = "odysseus_head"
/obj/structure/prop/mech/parts/odysseus_torso
	name="奥德修斯躯干"
	desc="奥德修斯的躯干部件，内含动力单元、处理核心和生命维持系统。"
	icon_state = "odysseus_torso"
/obj/structure/prop/mech/parts/odysseus_left_arm
	name="奥德修斯左臂"
	desc="奥德修斯的左臂，数据和电源接口兼容大多数外骨骼工具。"
	icon_state = "odysseus_l_arm"
/obj/structure/prop/mech/parts/odysseus_right_arm
	name="奥德修斯右臂"
	desc="奥德修斯的右臂，数据和电源接口兼容大多数外骨骼工具。"
	icon_state = "odysseus_r_arm"
/obj/structure/prop/mech/parts/odysseus_left_leg
	name="奥德修斯左腿"
	desc="奥德修斯的左腿，内含相当复杂的伺服驱动装置和平衡维持系统。"
	icon_state = "odysseus_l_leg"
/obj/structure/prop/mech/parts/odysseus_right_leg
	name="奥德修斯右腿"
	desc="奥德修斯的右腿，内含相当复杂的伺服驱动装置和平衡维持系统。"
	icon_state = "odysseus_r_leg"
/obj/structure/prop/mech/parts/odysseus_armor_plates
	name="奥德修斯装甲板"
	icon_state = "odysseus_armor"
