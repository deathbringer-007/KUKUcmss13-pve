// Polyfills and compatibility ------------------------------------------------
var decoder = decodeURIComponent || unescape;
if (!Array.prototype.includes) {
	Array.prototype.includes = function (thing) {
		for (var i = 0; i < this.length; i++) {
			if (this[i] == thing) return true;
		}
		return false;
	};
}
if (!String.prototype.trim) {
	String.prototype.trim = function () {
		return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, "");
	};
}

// Storage.js stuff ------------------------------------------------
function testHubStorage() {
	try {
		return Boolean(window.hubStorage && window.hubStorage.getItem);
	} catch (error) {
		return false;
	}
}

function loadFontSize() {
	current_fontsize = parseInt(window.hubStorage.getItem("fontsize"));
	if (isNaN(current_fontsize) || current_fontsize <= 0) {
		current_fontsize = 14;
	}
	statcontentdiv.style.fontSize = current_fontsize + "px";
	tab_change(current_tab, true); // Redraw the current tab
}

function onByondStorageLoad(event) {
	document.removeEventListener('byondstorageupdated', onByondStorageLoad);
	setTimeout(loadFontSize, 0); // Unfortunately its STILL not ready yet
}

// Status panel implementation ------------------------------------------------
var status_tab_parts = ["加载中……"];
var current_tab = null;
var current_fontsize = 14; // in px, also determines line height and category header sizes for the verb menus
// Per `storage.js` for tgui:
// Localstorage can sometimes throw an error, even if DOM storage is not
// disabled in IE11 settings.
// See: https://superuser.com/questions/1080011
try {
	if (!Byond.TRIDENT) {
		// Unfortunately byond storage isn't available immediately
		if (!testHubStorage()) {
			document.addEventListener('byondstorageupdated', onByondStorageLoad);
		} else {
			current_fontsize = parseInt(window.hubStorage.getItem("fontsize"));
		}
	} else { // TODO: Remove with 516
		current_fontsize = parseInt(window.localStorage.getItem("fontsize"));
	}
} catch (error) {
	current_fontsize = 14;
}
if (isNaN(current_fontsize) || current_fontsize <= 0) {
	current_fontsize = 14;
}
var mc_tab_parts = [["Loading...", ""]];
var href_token = null;
var spells = [];
var spell_tabs = [];
var verb_tabs = [];
var verbs = [["", ""]]; // list with a list inside
var tickets = [];
var interviewManager = { status: "", interviews: [] };
var sdql2 = [];
var permanent_tabs = []; // tabs that won't be cleared by wipes
var turfcontents = [];
var turfname = "";
var imageRetryDelay = 500;
var imageRetryLimit = 50;
var menu = document.getElementById("menu");
var under_menu = document.getElementById("under_menu");
var statcontentdiv = document.getElementById("statcontent");
var storedimages = [];
var split_admin_tabs = false;

// Any BYOND commands that could result in the client's focus changing go through this
// to ensure that when we relinquish our focus, we don't do it after the result of
// a command has already taken focus for itself.
function run_after_focus(callback) {
	setTimeout(callback, 0);
}

var stat_command_labels = {
	"Adminhelp": "向管理员求助",
	"Pray": "祈祷",
	"Mentorhelp": "向导师求助",
	"View Latest Ticket": "查看最近的求助",
	"Activate Cloak": "启动隐身",
	"Add Item to Tracker": "将物品加入追踪器",
	"Add Teleporter Destination": "添加传送目的地",
	"Adjust Volume Ambience": "调整环境音量",
	"Adjust Volume LobbyMusic": "调整大厅音乐音量",
	"Adjust Volume SFX": "调整音效音量",
	"Analyze Air": "分析空气",
	"Call Smart-Disc": "召回智能飞盘",
	"Change Explosion Type": "切换爆炸类型",
	"Claim Equipment": "领取装备",
	"Configure Hunting Trap": "配置狩猎陷阱",
	"Current Map": "当前地图",
	"Deal": "发牌",
	"Destroy Kit": "销毁套件",
	"Detach revolver holster": "拆下左轮手枪套",
	"Draw": "抽牌",
	"Draw Pile (Concealed)": "抽取牌堆（背面朝上）",
	"Draw X Cards": "抽取指定张数的牌",
	"Drop held item": "放下手持物品",
	"Eject ID Card": "弹出ID卡",
	"Empty": "清空",
	"Empty canister": "清空燃料罐",
	"Examine": "查看",
	"Examine Meta-Info (OOC)": "查看机制信息（角色外）",
	"Field Strip Weapon": "分解武器",
	"Final Countdown (!)": "最终倒计时（！）",
	"Fit Viewport": "适配游戏视口",
	"Fix Interfaces": "修复界面",
	"Flip table": "掀翻桌子",
	"Flush Container": "清空容器",
	"Flush Tray": "冲洗培养槽",
	"Follow Local Mob": "跟随附近角色",
	"Give Medal Recommendation": "提交勋章推荐",
	"Go DNR": "拒绝复苏",
	"Hear/Silence Ambience": "开关环境音",
	"Hear/Silence Ghost Announcements": "开关观察者公告提示音",
	"Hear/Silence Ghost Fax Machines": "开关幽灵传真机音效",
	"Hear/Silence LobbyMusic": "开关大厅音乐",
	"Hear/Silence Reboot Sound": "开关重启音效",
	"Hide Combat Chat Prefs": "隐藏战斗聊天偏好",
	"Hide Ghost Prefs": "隐藏幽灵偏好",
	"Hive Status": "虫巢状态",
	"Join Response Team": "加入响应队",
	"Join as Xeno": "作为异形加入",
	"Join as a Facehugger": "作为抱脸虫加入",
	"Join as a Lesser Drone": "作为次级工蜂加入",
	"Join as a Working Joe": "作为工作乔加入",
	"Join the Hunt": "加入狩猎",
	"LOOC": "本地角色外聊天",
	"Label Disk": "标注磁盘",
	"Mark for Hunt": "标记猎物",
	"Me": "表情动作",
	"OOC": "角色外聊天",
	"OOC Text Color - Global": "全局角色外聊天颜色",
	"Permit/Disallow Construction Placement": "允许或禁止放置建筑",
	"Permit/Disallow Slashing": "允许或禁止爪击",
	"Permit/Disallow Special Structure Destruction": "允许或禁止摧毁特殊建筑",
	"Permit/Disallow Unnesting": "允许或禁止解开巢穴束缚",
	"Pick Ghost Orbit Shape": "选择幽灵环绕轨迹",
	"Pick Up": "拿起",
	"Pick-Say": "选择发言",
	"Pull": "拖拽",
	"Put table back": "扶正桌子",
	"Re-enter Corpse": "重新进入尸体",
	"Read ID Card": "读取ID卡",
	"Remove Canister": "卸下燃料罐",
	"Remove Item from Tracker": "将物品移出追踪器",
	"Remove Your Splints": "拆除自己的夹板",
	"Remove from Hunt": "移除猎物标记",
	"Rename Seeds": "重命名种子",
	"Rename paper": "重命名纸张",
	"Rotate Chair": "旋转椅子",
	"Rotate Window Clockwise": "顺时针旋转窗户",
	"Rotate Window Counter-Clockwise": "逆时针旋转窗户",
	"Say": "说话",
	"Scan Health": "扫描健康状况",
	"Set Flavour Text": "设置外观描述",
	"Set Headset Volume": "设置耳机音量",
	"Set Hive Orders (50)": "设置虫巢指令（50）",
	"Set Pose": "设置姿态描述",
	"Set short label (on-sprite)": "设置短标签（显示在图像上）",
	"Shake": "摇晃",
	"Show Combat Chat Prefs": "显示战斗聊天偏好",
	"Show Ghost Prefs": "显示幽灵偏好",
	"Show Held Item": "展示手持物品",
	"Show Server Revision": "显示服务器版本",
	"Show/Hide Actions": "显示或隐藏动作按钮",
	"Show/Hide LOOC": "显示或隐藏本地角色外聊天",
	"Show/Hide OOC": "显示或隐藏角色外聊天",
	"Silence Current Admin Sound": "停止当前管理员音效",
	"Sit": "坐下",
	"Sleep": "睡觉",
	"Sort Hand": "整理手牌",
	"Spectator Vote": "观察者投票",
	"Steal from ground": "从地上偷取",
	"Steal from mob": "从角色身上偷取",
	"Switch Gathering Method": "切换收集方式",
	"Switch Storage Drawing Method": "切换取物方式",
	"Switch Tracker Target": "切换追踪目标",
	"Teleport to Area": "传送到区域",
	"Teleport to Mob": "传送到角色",
	"Teleport to Techtree": "传送到科技树",
	"Tie Up/Down": "绑起或放下护耳",
	"Toggle Abovehead Chat": "切换头顶聊天",
	"Toggle Abovehead Chat Emotes": "切换头顶表情动作",
	"Toggle Adaptive Zooming": "切换自适应缩放",
	"Toggle Admin PM Flash": "切换管理员私信闪烁提醒",
	"Toggle Ambient Occlusion": "切换环境光遮蔽",
	"Toggle Auto Eject": "切换自动退匣",
	"Toggle Auto Viewport Fit": "切换自动适配视口",
	"Toggle Bracer Lock": "切换护腕锁定",
	"Toggle Bracer Name": "切换护腕名称",
	"Toggle Bracer Sound": "切换护腕提示音",
	"Toggle Buttons": "切换纽扣",
	"Toggle Cloaking Device": "切换隐身装置",
	"Toggle Country Flag": "切换国旗显示",
	"Toggle Custom Cursors": "切换自定义鼠标指针",
	"Toggle Deadchat": "切换死者聊天",
	"Toggle Firemode": "切换射击模式",
	"Toggle Firing Messages": "切换开火消息",
	"Toggle Fuel Type": "切换燃料类型",
	"Toggle Fullscreen Preference": "切换全屏偏好",
	"Toggle Ghost HUDs": "切换幽灵抬头显示",
	"Toggle Ghost Vision": "切换幽灵视觉",
	"Toggle GhostEars": "切换幽灵全局听觉",
	"Toggle GhostHivemind": "切换幽灵虫巢意志收听",
	"Toggle GhostRadio": "切换幽灵全局无线电",
	"Toggle GhostSight": "切换幽灵全局视觉",
	"Toggle GhostSpyRadio": "切换幽灵窃听器收听",
	"Toggle Gun Safety": "切换枪械保险",
	"Toggle Hair": "收放头发",
	"Toggle Headset HUD": "切换耳机抬头显示",
	"Toggle Health Scan": "切换健康扫描",
	"Toggle Hood": "收放兜帽",
	"Toggle ID Chip": "切换身份芯片",
	"Toggle Inquisitiveness": "切换点击检视",
	"Toggle Internals": "切换内部供气",
	"Toggle Jacket Buttons": "开合夹克纽扣",
	"Toggle Larva Unpool Flash": "切换幼虫出池闪烁提醒",
	"Toggle Laser": "开关激光",
	"Toggle M2 night vision goggles": "开关M2夜视仪",
	"Toggle Mask Visors": "切换面具目镜",
	"Toggle Mask Zoom": "切换面具缩放",
	"Toggle Membership Publicity": "切换会员身份公开显示",
	"Toggle Open": "打开或关闭",
	"Toggle Pain Messages": "切换疼痛消息",
	"Toggle Permission Errors": "切换权限错误提示",
	"Toggle Pile State": "切换牌堆状态",
	"Toggle Preferences": "切换偏好设置",
	"Toggle Revival Flash": "切换复苏闪烁提醒",
	"Toggle Roundend Flash": "切换回合结束闪烁提醒",
	"Toggle Roundstart Flash": "切换回合开始闪烁提醒",
	"Toggle Say Input Color": "切换发言输入框配色",
	"Toggle Say Input Style": "切换发言输入框样式",
	"Toggle Scope Zoom Level": "切换瞄准镜倍率",
	"Toggle Self Visibility": "切换自身可见性",
	"Toggle Someone Hit Messages": "切换他人命中消息",
	"Toggle SpecialRole Candidacy": "切换特殊身份候选资格",
	"Toggle Stock Attachment": "切换枪托附件",
	"Toggle Tile Dumping": "切换整格倾倒",
	"Toggle Underbarrel Attachment": "切换下挂附件",
	"Toggle Unnest Flash": "切换脱离巢穴闪烁提醒",
	"Toggle Xeno Armor Messages": "切换异形护甲消息",
	"Toggle Xeno Attack Messages": "切换异形攻击消息",
	"Toggle You Hit Messages": "切换自身命中消息",
	"Toggle Zoom": "切换缩放",
	"Toggle belt mode": "切换腰带模式",
	"Toggle hotkey buttons": "切换快捷键按钮",
	"Toggle medevac": "切换医疗撤离",
	"Track Yautja Gear": "追踪铁血装备",
	"Unique Action": "独特动作",
	"Unload Weapon": "卸下弹药",
	"Use Attachment": "使用附件",
	"Use Plasma Caster": "使用等离子肩炮",
	"Use Rail Attachment": "使用导轨附件",
	"Use Wrist Blades": "使用腕刃",
	"View Clan Info": "查看氏族信息",
	"View Crew Manifest": "查看船员名册",
	"View Kill Feed": "查看击杀信息",
	"View USCM Tacmap": "查看陆战队战术地图",
	"Vote": "投票",
	"Whisper": "低语",
	"Who": "在线玩家",
	"Word of the Queen (50)": "女皇之言（50）",
	"Yank combi-stick": "拔回伸缩战矛",
	"Yank out object": "拔出嵌入物"
};
var stat_tab_labels = {
	"Admin": "管理",
	"Status": "状态",
	"Panel Options": "面板选项",
	"Alien": "异形",
	"Ghost": "幽灵",
	"IC": "角色",
	"OOC": "角色外",
	"Object": "物品",
	"Preferences": "偏好设置",
	"Parrot": "鹦鹉",
	"Pyro": "火焰兵",
	"Scout": "侦察兵",
	"Weapons": "武器",
	"Yautja": "铁血战士",
	"Body": "躯体",
	"Follow": "跟随",
	"Join": "加入",
	"Settings": "设置",
	"View": "查看",
	"Medals": "勋章",
	"Fix": "修复",
	"Records": "记录",
	"Chat": "聊天",
	"Combat": "战斗",
	"Sound": "声音",
	"TaskbarFlashing": "任务栏闪烁",
	"UI": "界面",
	"Marks": "猎物标记",
	"Misc": "杂项",
	"Tracker": "追踪器",
	"Utility": "工具"
};

function stat_display_label(value, category, labels) {
	if (labels === stat_tab_labels && value === "Admin") return labels[value];
	if (labels === stat_command_labels && category === "Admin" && /^(Adminhelp|Mentorhelp|View Latest Ticket)$/.test(value)) return labels[value];
	if (/^(Admin|Debug|Game Master|GameMaster|MC)(\.|$)/.test(category || "")) return value;
	return Object.prototype.hasOwnProperty.call(labels, value) ? labels[value] : value;
}

function createStatusTab(name, category) {
	var original_category = category || name;
	if (name.indexOf(".") != -1) {
		var splitName = name.split(".");
		if (split_admin_tabs && splitName[0] === "Admin") name = splitName[1];
		else name = splitName[0];
	}
	if (document.getElementById(name) || name.trim() == "") {
		return;
	}
	if (!verb_tabs.includes(name) && !permanent_tabs.includes(name)) {
		return;
	}
	var B = document.createElement("BUTTON");
	B.onclick = function () {
		tab_change(name);
		this.blur();
	};
	B.id = name;
	B.textContent = stat_display_label(name, original_category, stat_tab_labels);
	B.className = "button";
	//ORDERING ALPHABETICALLY

	switch (name) {
		case "Status":
			B.style.order = 1;
			break;
		case "MC":
			B.style.order = 2;
			break;
		case "Panel Options":
			B.style.order = 999;
			break;
		default:
			B.style.order = name.charCodeAt(0);
	}

	//END ORDERING
	menu.appendChild(B);
	SendTabToByond(name);
	under_menu.style.height = menu.clientHeight + "px";
}

function removeStatusTab(name) {
	if (!document.getElementById(name) || permanent_tabs.includes(name)) {
		return;
	}
	for (var i = verb_tabs.length - 1; i >= 0; --i) {
		if (verb_tabs[i] == name) {
			verb_tabs.splice(i, 1);
		}
	}
	menu.removeChild(document.getElementById(name));
	TakeTabFromByond(name);
	under_menu.style.height = menu.clientHeight + "px";
}

function sortVerbs() {
	verbs.sort(function (a, b) {
		var selector = a[0] == b[0] ? 1 : 0;
		if (a[selector].toUpperCase() < b[selector].toUpperCase()) {
			return 1;
		} else if (a[selector].toUpperCase() > b[selector].toUpperCase()) {
			return -1;
		}
		return 0;
	});
}

window.onresize = function () {
	under_menu.style.height = menu.clientHeight + "px";
};

function addPermanentTab(name) {
	if (!permanent_tabs.includes(name)) {
		permanent_tabs.push(name);
	}
	createStatusTab(name);
}

function removePermanentTab(name) {
	for (var i = permanent_tabs.length - 1; i >= 0; --i) {
		if (permanent_tabs[i] == name) {
			permanent_tabs.splice(i, 1);
		}
	}
	removeStatusTab(name);
}

function checkStatusTab() {
	for (var i = 0; i < menu.children.length; i++) {
		if (
			!verb_tabs.includes(menu.children[i].id) &&
			!permanent_tabs.includes(menu.children[i].id)
		) {
			menu.removeChild(menu.children[i]);
		}
	}
}

function remove_verb(v) {
	var verb_to_remove = v; // to_remove = [verb:category, verb:name]
	for (var i = verbs.length - 1; i >= 0; i--) {
		var part_to_remove = verbs[i];
		if (part_to_remove[1] == verb_to_remove[1]) {
			verbs.splice(i, 1);
		}
	}
}

function check_verbs() {
	for (var v = verb_tabs.length - 1; v >= 0; v--) {
		verbs_cat_check(verb_tabs[v]);
	}
}

function verbs_cat_check(cat) {
	var tabCat = cat;
	if (cat.indexOf(".") != -1) {
		var splitName = cat.split(".");
		if (split_admin_tabs && splitName[0] === "Admin") tabCat = splitName[1];
		else tabCat = splitName[0];
	}
	var verbs_in_cat = 0;
	var verbcat = "";
	if (!verb_tabs.includes(tabCat)) {
		removeStatusTab(tabCat);
		return;
	}
	for (var v = 0; v < verbs.length; v++) {
		var part = verbs[v];
		verbcat = part[0];
		if (verbcat.indexOf(".") != -1) {
			var splitName = verbcat.split(".");
			if (split_admin_tabs && splitName[0] === "Admin")
				verbcat = splitName[1];
			else verbcat = splitName[0];
		}
		if (verbcat != tabCat || verbcat.trim() == "") {
			continue;
		} else {
			verbs_in_cat = 1;
			break; // we only need one
		}
	}
	if (verbs_in_cat != 1) {
		removeStatusTab(tabCat);
		if (current_tab == tabCat) tab_change("Status");
	}
}

function findVerbindex(name, verblist) {
	for (var i = 0; i < verblist.length; i++) {
		var part = verblist[i];
		if (part[1] == name) return i;
	}
}
function wipe_verbs() {
	verbs = [["", ""]];
	verb_tabs = [];
	checkStatusTab(); // remove all empty verb tabs
}

function update_verbs() {
	wipe_verbs();
	Byond.sendMessage("Update-Verbs");
}

function SendTabsToByond() {
	var tabstosend = [];
	tabstosend = tabstosend.concat(permanent_tabs, verb_tabs);
	for (var i = 0; i < tabstosend.length; i++) {
		SendTabToByond(tabstosend[i]);
	}
}

function SendTabToByond(tab) {
	Byond.sendMessage("Send-Tabs", { tab: tab });
}

//Byond can't have this tab anymore since we're removing it
function TakeTabFromByond(tab) {
	Byond.sendMessage("Remove-Tabs", { tab: tab });
}

function spell_cat_check(cat) {
	var spells_in_cat = 0;
	var spellcat = "";
	for (var s = 0; s < spells.length; s++) {
		var spell = spells[s];
		spellcat = spell[0];
		if (spellcat == cat) {
			spells_in_cat++;
		}
	}
	if (spells_in_cat < 1) {
		removeStatusTab(cat);
	}
}

function tab_change(tab, force) {
	if (!force && tab == current_tab) return;
	if (document.getElementById(current_tab))
		document.getElementById(current_tab).className = "button"; // disable active on last button
	var oldTab = current_tab;
	current_tab = tab;
	set_byond_tab(tab);
	if (document.getElementById(tab))
		document.getElementById(tab).className = "button active"; // make current button active
	var spell_tabs_thingy = spell_tabs.includes(tab);
	var verb_tabs_thingy = verb_tabs.includes(tab);
	if (tab == "Status") {
		draw_status();
	} else if (tab == "MC") {
		draw_mc();
	} else if (spell_tabs_thingy) {
		draw_spells(tab);
	} else if (verb_tabs_thingy) {
		draw_verbs(tab);
	} else if (tab == "Debug Stat Panel") {
		draw_debug();
	} else if (tab == "Tickets") {
		draw_tickets();
		draw_interviews();
	} else if (tab == "SDQL2") {
		draw_sdql2();
	} else if (tab == turfname) {
		draw_listedturf();
	} else if (tab == "Panel Options") {
		openOptionsMenu();
		tab_change(oldTab);
	} else {
		statcontentdiv.textContext = "加载中……";
	}
	Byond.winset(Byond.windowId, {
		"is-visible": true,
	});
}

function set_byond_tab(tab) {
	Byond.sendMessage("Set-Tab", { tab: tab });
}

function draw_debug() {
	statcontentdiv.textContent = "";
	var wipeverbstabs = document.createElement("div");
	var link = document.createElement("a");
	link.onclick = function () {
		wipe_verbs();
	};
	link.textContent = "Wipe All Verbs";
	wipeverbstabs.appendChild(link);
	document.getElementById("statcontent").appendChild(wipeverbstabs);
	var wipeUpdateVerbsTabs = document.createElement("div");
	var updateLink = document.createElement("a");
	updateLink.onclick = function () {
		update_verbs();
	};
	updateLink.textContent = "Wipe and Update All Verbs";
	wipeUpdateVerbsTabs.appendChild(updateLink);
	document.getElementById("statcontent").appendChild(wipeUpdateVerbsTabs);
	var text = document.createElement("div");
	text.textContent = "Verb Tabs:";
	document.getElementById("statcontent").appendChild(text);
	var table1 = document.createElement("table");
	for (var i = 0; i < verb_tabs.length; i++) {
		var part = verb_tabs[i];
		// Hide subgroups except admin subgroups if they are split
		if (verb_tabs[i].lastIndexOf(".") != -1) {
			var splitName = verb_tabs[i].split(".");
			if (split_admin_tabs && splitName[0] === "Admin")
				part = splitName[1];
			else continue;
		}
		var tr = document.createElement("tr");
		var td1 = document.createElement("td");
		td1.textContent = part;
		var a = document.createElement("a");
		a.onclick = (function (part) {
			return function () {
				removeStatusTab(part);
			};
		})(part);
		a.textContent = " Delete Tab " + part;
		td1.appendChild(a);
		tr.appendChild(td1);
		table1.appendChild(tr);
	}
	document.getElementById("statcontent").appendChild(table1);
	var header2 = document.createElement("div");
	header2.textContent = "Verbs:";
	document.getElementById("statcontent").appendChild(header2);
	var table2 = document.createElement("table");
	for (var v = 0; v < verbs.length; v++) {
		var part2 = verbs[v];
		var trr = document.createElement("tr");
		var tdd1 = document.createElement("td");
		tdd1.textContent = part2[0];
		var tdd2 = document.createElement("td");
		tdd2.textContent = part2[1];
		trr.appendChild(tdd1);
		trr.appendChild(tdd2);
		table2.appendChild(trr);
	}
	document.getElementById("statcontent").appendChild(table2);
	var text3 = document.createElement("div");
	text3.textContent = "Permanent Tabs:";
	document.getElementById("statcontent").appendChild(text3);
	var table3 = document.createElement("table");
	for (var i = 0; i < permanent_tabs.length; i++) {
		var part3 = permanent_tabs[i];
		var trrr = document.createElement("tr");
		var tddd1 = document.createElement("td");
		tddd1.textContent = part3;
		trrr.appendChild(tddd1);
		table3.appendChild(trrr);
	}
	document.getElementById("statcontent").appendChild(table3);
}
function draw_status() {
	var status_tab_map_href_exception =
		"<a href='byond://?MapView=1'>View Tactical Map</a>";
	var status_tab_map_chinese_href =
		"<a href='byond://?MapView=1'>查看战术地图</a>";
	if (!document.getElementById("Status")) {
		createStatusTab("Status");
		current_tab = "Status";
	}
	statcontentdiv.textContent = "";
	for (var i = 0; i < status_tab_parts.length; i++) {
		if (status_tab_parts[i].trim() == "") {
			document
				.getElementById("statcontent")
				.appendChild(document.createElement("br"));
		} else if (
			// hardcoded because merely using .includes() to test for a href seems unreliable for some reason.
			status_tab_parts[i] == status_tab_map_href_exception ||
			status_tab_parts[i] == status_tab_map_chinese_href
		) {
			var maplink = document.createElement("a");
			maplink.innerHTML = status_tab_map_chinese_href;
			document.getElementById("statcontent").appendChild(maplink);
		} else {
			var div = document.createElement("div");
			div.textContent = status_tab_parts[i];
			document.getElementById("statcontent").appendChild(div);
		}
	}
	if (verb_tabs.length == 0 || !verbs) {
		Byond.command("Fix-Stat-Panel");
	}
}

function draw_mc() {
	statcontentdiv.textContent = "";
	var table = document.createElement("table");
	for (var i = 0; i < mc_tab_parts.length; i++) {
		var part = mc_tab_parts[i];
		var tr = document.createElement("tr");
		var td1 = document.createElement("td");
		td1.textContent = part[0];
		var td2 = document.createElement("td");
		if (part[2]) {
			var a = document.createElement("a");
			a.href =
				"byond://?_src_=vars;admin_token=" + href_token + ";Vars=" + part[2];
			a.textContent = part[1];
			td2.appendChild(a);
		} else {
			td2.textContent = part[1];
		}
		tr.appendChild(td1);
		tr.appendChild(td2);
		table.appendChild(tr);
	}
	document.getElementById("statcontent").appendChild(table);
}

function remove_tickets() {
	if (tickets) {
		tickets = [];
		removePermanentTab("Tickets");
		if (current_tab == "Tickets") tab_change("Status");
	}
	checkStatusTab();
}

function remove_sdql2() {
	if (sdql2) {
		sdql2 = [];
		removePermanentTab("SDQL2");
		if (current_tab == "SDQL2") tab_change("Status");
	}
	checkStatusTab();
}

function remove_interviews() {
	if (tickets) {
		tickets = [];
	}
	checkStatusTab();
}

function iconError(e) {
	if (current_tab != turfname) {
		return;
	}
	setTimeout(function () {
		var node = e.target;
		var current_attempts = Number(node.getAttribute("data-attempts")) || 0;
		if (current_attempts > imageRetryLimit) {
			return;
		}
		var src = node.src;
		node.src = null;
		node.src = src + "#" + current_attempts;
		node.setAttribute("data-attempts", current_attempts + 1);
		draw_listedturf();
	}, imageRetryDelay);
}

function draw_listedturf() {
	statcontentdiv.textContent = "";
	var table = document.createElement("table");
	for (var i = 0; i < turfcontents.length; i++) {
		var part = turfcontents[i];
		if (storedimages[part[1]] == null && part[2]) {
			var img = document.createElement("img");
			img.src = part[2];
			img.id = part[1];
			storedimages[part[1]] = part[2];
			img.onerror = iconError;
			table.appendChild(img);
		} else {
			var img = document.createElement("img");
			img.onerror = iconError;
			img.src = storedimages[part[1]];
			img.id = part[1];
			table.appendChild(img);
		}
		var b = document.createElement("div");
		var clickcatcher = "";
		b.className = "link";
		b.onmousedown = (function (part) {
			// The outer function is used to close over a fresh "part" variable,
			// rather than every onmousedown getting the "part" of the last entry.
			return function (e) {
				e.preventDefault();
				clickcatcher = "byond://?src=" + part[1];
				switch (e.button) {
					case 1:
						clickcatcher += ";statpanel_item_click=middle";
						break;
					case 2:
						clickcatcher += ";statpanel_item_click=right";
						break;
					default:
						clickcatcher += ";statpanel_item_click=left";
				}
				if (e.shiftKey) {
					clickcatcher += ";statpanel_item_shiftclick=1";
				}
				if (e.ctrlKey) {
					clickcatcher += ";statpanel_item_ctrlclick=1";
				}
				if (e.altKey) {
					clickcatcher += ";statpanel_item_altclick=1";
				}
				window.location.href = clickcatcher;
			};
		})(part);
		b.textContent = part[0];
		table.appendChild(b);
		table.appendChild(document.createElement("br"));
	}
	document.getElementById("statcontent").appendChild(table);
}

function remove_listedturf() {
	removePermanentTab(turfname);
	checkStatusTab();
	if (current_tab == turfname) {
		tab_change("Status");
	}
}

function remove_mc() {
	removePermanentTab("MC");
	if (current_tab == "MC") {
		tab_change("Status");
	}
}

function draw_sdql2() {
	statcontentdiv.textContent = "";
	var table = document.createElement("table");
	for (var i = 0; i < sdql2.length; i++) {
		var part = sdql2[i];
		var tr = document.createElement("tr");
		var td1 = document.createElement("td");
		td1.textContent = part[0];
		var td2 = document.createElement("td");
		if (part[2]) {
			var a = document.createElement("a");
			a.href = "byond://?src=" + part[2] + ";statpanel_item_click=left";
			a.textContent = part[1];
			td2.appendChild(a);
		} else {
			td2.textContent = part[1];
		}
		tr.appendChild(td1);
		tr.appendChild(td2);
		table.appendChild(tr);
	}
	document.getElementById("statcontent").appendChild(table);
}

function draw_tickets() {
	statcontentdiv.textContent = "";
	var table = document.createElement("table");
	if (!tickets) {
		return;
	}
	for (var i = 0; i < tickets.length; i++) {
		var part = tickets[i];
		var tr = document.createElement("tr");
		var td1 = document.createElement("td");
		td1.textContent = part[0];
		var td2 = document.createElement("td");
		if (part[2]) {
			var a = document.createElement("a");
			a.href =
				"byond://?_src_=admin_holder;admin_token=" +
				href_token +
				";ahelp=" +
				part[2] +
				";ahelp_action=ticket;statpanel_item_click=left;action=ticket";
			a.textContent = part[1];
			td2.appendChild(a);
		} else if (part[3]) {
			var a = document.createElement("a");
			a.href = "byond://?src=" + part[3] + ";statpanel_item_click=left";
			a.textContent = part[1];
			td2.appendChild(a);
		} else {
			td2.textContent = part[1];
		}
		tr.appendChild(td1);
		tr.appendChild(td2);
		table.appendChild(tr);
	}
	document.getElementById("statcontent").appendChild(table);
}

function draw_interviews() {
	var body = document.createElement("div");
	var header = document.createElement("h3");
	header.textContent = "Interviews";
	body.appendChild(header);
	var manDiv = document.createElement("div");
	manDiv.className = "interview_panel_controls";
	var manLink = document.createElement("a");
	manLink.textContent = "Open Interview Manager Panel";
	manLink.href =
		"byond://?_src_=admin_holder;admin_token=" +
		href_token +
		";interview_man=1;statpanel_item_click=left";
	manDiv.appendChild(manLink);
	body.appendChild(manDiv);

	// List interview stats
	var statsDiv = document.createElement("table");
	statsDiv.className = "interview_panel_stats";
	for (var key in interviewManager.status) {
		var d = document.createElement("div");
		var tr = document.createElement("tr");
		var stat_name = document.createElement("td");
		var stat_text = document.createElement("td");
		stat_name.textContent = key;
		stat_text.textContent = interviewManager.status[key];
		tr.appendChild(stat_name);
		tr.appendChild(stat_text);
		statsDiv.appendChild(tr);
	}
	body.appendChild(statsDiv);
	document.getElementById("statcontent").appendChild(body);

	// List interviews if any are open
	var table = document.createElement("table");
	table.className = "interview_panel_table";
	if (!interviewManager) {
		return;
	}
	for (var i = 0; i < interviewManager.interviews.length; i++) {
		var part = interviewManager.interviews[i];
		var tr = document.createElement("tr");
		var td = document.createElement("td");
		var a = document.createElement("a");
		a.textContent = part["status"];
		a.href =
			"byond://?_src_=admin_holder;admin_token=" +
			href_token +
			";interview=" +
			part["ref"] +
			";statpanel_item_click=left";
		td.appendChild(a);
		tr.appendChild(td);
		table.appendChild(tr);
	}
	document.getElementById("statcontent").appendChild(table);
}

function draw_spells(cat) {
	statcontentdiv.textContent = "";
	var table = document.createElement("table");
	for (var i = 0; i < spells.length; i++) {
		var part = spells[i];
		if (part[0] != cat) continue;
		var tr = document.createElement("tr");
		var td1 = document.createElement("td");
		td1.textContent = part[1];
		var td2 = document.createElement("td");
		if (part[3]) {
			var a = document.createElement("a");
			a.href = "byond://?src=" + part[3] + ";statpanel_item_click=left";
			a.textContent = part[2];
			td2.appendChild(a);
		} else {
			td2.textContent = part[2];
		}
		tr.appendChild(td1);
		tr.appendChild(td2);
		table.appendChild(tr);
	}
	document.getElementById("statcontent").appendChild(table);
}

function make_verb_onclick(command) {
	return function () {
		run_after_focus(function () {
			Byond.command(command);
		});
	};
}

function draw_verbs(cat) {
	var display_category = cat;
	statcontentdiv.textContent = "";
	var table = document.createElement("div");
	var additions = {}; // additional sub-categories to be rendered
	table.className = "grid-container";
	sortVerbs();
	if (split_admin_tabs && cat.lastIndexOf(".") != -1) {
		var splitName = cat.split(".");
		if (splitName[0] === "Admin") cat = splitName[1];
	}
	verbs.reverse(); // sort verbs backwards before we draw
	for (var i = 0; i < verbs.length; ++i) {
		var part = verbs[i];
		var name = part[0];
		if (split_admin_tabs && name.lastIndexOf(".") != -1) {
			var splitName = name.split(".");
			if (splitName[0] === "Admin") name = splitName[1];
		}
		var command = part[1];

		if (
			command &&
			name.lastIndexOf(cat, 0) != -1 &&
			(name.length == cat.length || name.charAt(cat.length) == ".")
		) {
			var subCat =
				name.lastIndexOf(".") != -1 ? name.split(".")[1] : null;
			if (subCat && !additions[subCat]) {
				var newTable = document.createElement("div");
				newTable.className = "grid-container";
				additions[subCat] = newTable;
			}

			var a = document.createElement("a");
			a.href = "#";
			display_category = part[0];
			a.onclick = make_verb_onclick(command.replace(/\s/g, "-"));
			a.className = "grid-item";
			a.style.lineHeight = current_fontsize + 2 + "px";
			var t = document.createElement("span");
			t.textContent = stat_display_label(command, part[0], stat_command_labels);
			t.className = "grid-item-text";
			a.appendChild(t);
			(subCat ? additions[subCat] : table).appendChild(a);
		}
	}

	// Append base table to view
	var content = document.getElementById("statcontent");
	content.appendChild(table);

	// Append additional sub-categories if relevant
	for (var cat in additions) {
		if (additions.hasOwnProperty(cat)) {
			// do addition here
			var header = document.createElement("h3");
			header.textContent = stat_display_label(cat, display_category, stat_tab_labels);
			header.style.fontSize = current_fontsize + 4 + "px";
			content.appendChild(header);
			content.appendChild(additions[cat]);
		}
	}
}

function set_theme(which) {
	if (which == "light") {
		document.body.className = "";
		set_style_sheet("browserOutput_white");
	} else if (which == "dark") {
		document.body.className = "dark";
		set_style_sheet("browserOutput");
	}
}

function set_style_sheet(sheet) {
	if (document.getElementById("goonStyle")) {
		var currentSheet = document.getElementById("goonStyle");
		currentSheet.parentElement.removeChild(currentSheet);
	}
	var head = document.getElementsByTagName("head")[0];
	var sheetElement = document.createElement("link");
	sheetElement.id = "goonStyle";
	sheetElement.rel = "stylesheet";
	sheetElement.type = "text/css";
	sheetElement.href = sheet + ".css";
	sheetElement.media = "all";
	head.appendChild(sheetElement);
}

function restoreFocus() {
	run_after_focus(function () {
		Byond.winset("map", {
			focus: true,
		});
	});
}

function getCookie(cname) {
	var name = cname + "=";
	var ca = document.cookie.split(";");
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == " ") c = c.substring(1);
		if (c.indexOf(name) === 0) {
			return decoder(c.substring(name.length, c.length));
		}
	}
	return "";
}

function add_verb_list(payload) {
	var to_add = payload; // list of a list with category and verb inside it
	to_add.sort(); // sort what we're adding
	for (var i = 0; i < to_add.length; i++) {
		var part = to_add[i];
		if (!part[0]) continue;
		var category = part[0];
		if (category.indexOf(".") != -1) {
			var splitName = category.split(".");
			if (split_admin_tabs && splitName[0] === "Admin")
				category = splitName[1];
			else category = splitName[0];
		}
		if (findVerbindex(part[1], verbs)) continue;
		if (verb_tabs.includes(category)) {
			verbs.push(part);
			if (current_tab == category) {
				draw_verbs(category); // redraw if we added a verb to the tab we're currently in
			}
		} else if (category) {
			verb_tabs.push(category);
			verbs.push(part);
			createStatusTab(category, part[0]);
		}
	}
}

function init_spells() {
	var cat = "";
	for (var i = 0; i < spell_tabs.length; i++) {
		cat = spell_tabs[i];
		if (cat.length > 0) {
			verb_tabs.push(cat);
			createStatusTab(cat);
		}
	}
}

document.addEventListener("mouseup", restoreFocus);
document.addEventListener("keyup", restoreFocus);

if (!current_tab) {
	addPermanentTab("Status");
	tab_change("Status");
}

window.onload = function () {
	Byond.sendMessage("Update-Verbs");
};

Byond.subscribeTo("update_spells", function (payload) {
	spell_tabs = payload.spell_tabs;
	var do_update = false;
	if (spell_tabs.includes(current_tab)) {
		do_update = true;
	}
	init_spells();
	if (payload.actions) {
		spells = payload.actions;
		if (do_update) {
			draw_spells(current_tab);
		}
	} else {
		remove_spells();
	}
});

Byond.subscribeTo("remove_verb_list", function (v) {
	var to_remove = v;
	for (var i = 0; i < to_remove.length; i++) {
		remove_verb(to_remove[i]);
	}
	check_verbs();
	sortVerbs();
	if (verb_tabs.includes(current_tab)) draw_verbs(current_tab);
});

// passes a 2D list of (verbcategory, verbname) creates tabs and adds verbs to respective list
// example (IC, Say)
Byond.subscribeTo("init_verbs", function (payload) {
	statcontentdiv.style.fontSize = current_fontsize + "px";
	wipe_verbs(); // remove all verb categories so we can replace them
	checkStatusTab(); // remove all status tabs
	verb_tabs = payload.panel_tabs;
	verb_tabs.sort(); // sort it
	var do_update = false;
	var cat = "";
	for (var i = 0; i < verb_tabs.length; i++) {
		cat = verb_tabs[i];
		createStatusTab(cat); // create a category if the verb doesn't exist yet
	}
	if (verb_tabs.includes(current_tab)) {
		do_update = true;
	}
	if (payload.verblist) {
		add_verb_list(payload.verblist);
		sortVerbs(); // sort them
		if (do_update) {
			draw_verbs(current_tab);
		}
	}
	createOptionsButton();
	SendTabsToByond();
});

Byond.subscribeTo("update_stat", function (payload) {
	//status_tab_parts = [payload.ping_str];
	status_tab_parts = [];
	var parsed = payload.global_data;

	for (var i = 0; i < parsed.length; i++)
		if (parsed[i] != null) status_tab_parts.push(parsed[i]);

	parsed = payload.other_str;

	for (var i = 0; i < parsed.length; i++)
		if (parsed[i] != null) status_tab_parts.push(parsed[i]);

	if (current_tab == "Status") {
		draw_status();
	} else if (current_tab == "Debug Stat Panel") {
		draw_debug();
	}
});

Byond.subscribeTo("update_mc", function (payload) {
	mc_tab_parts = payload.mc_data;
	mc_tab_parts.splice(0, 0, ["Location:", payload.coord_entry]);

	if (!verb_tabs.includes("MC")) {
		verb_tabs.push("MC");
	}

	createStatusTab("MC");

	if (current_tab == "MC") {
		draw_mc();
	}
});

Byond.subscribeTo("remove_spells", function () {
	for (var s = 0; s < spell_tabs.length; s++) {
		removeStatusTab(spell_tabs[s]);
	}
});

Byond.subscribeTo("init_spells", function () {
	var cat = "";
	for (var i = 0; i < spell_tabs.length; i++) {
		cat = spell_tabs[i];
		if (cat.length > 0) {
			verb_tabs.push(cat);
			createStatusTab(cat);
		}
	}
});

Byond.subscribeTo("check_spells", function () {
	for (var v = 0; v < spell_tabs.length; v++) {
		spell_cat_check(spell_tabs[v]);
	}
});

Byond.subscribeTo("create_debug", function () {
	if (!document.getElementById("Debug Stat Panel")) {
		addPermanentTab("Debug Stat Panel");
	} else {
		removePermanentTab("Debug Stat Panel");
	}
});

Byond.subscribeTo("create_listedturf", function (TN) {
	remove_listedturf(); // remove the last one if we had one
	turfname = TN;
	addPermanentTab(turfname);
	tab_change(turfname);
});

Byond.subscribeTo("remove_admin_tabs", function () {
	href_token = null;
	remove_mc();
	remove_tickets();
	remove_sdql2();
	remove_interviews();
});

Byond.subscribeTo("update_listedturf", function (TC) {
	turfcontents = TC;
	if (current_tab == turfname) {
		draw_listedturf();
	}
});

Byond.subscribeTo("update_interviews", function (I) {
	interviewManager = I;
	if (current_tab == "Tickets") {
		draw_interviews();
	}
});

Byond.subscribeTo("update_split_admin_tabs", function (status) {
	status = status == true;

	if (split_admin_tabs !== status) {
		if (split_admin_tabs === true) {
			removeStatusTab("Events");
			removeStatusTab("Fun");
			removeStatusTab("Game");
		}
		update_verbs();
	}
	split_admin_tabs = status;
});

Byond.subscribeTo("add_admin_tabs", function (ht) {
	href_token = ht;
	addPermanentTab("Tickets");
});

Byond.subscribeTo("add_debug_tabs", function (ht) {
	href_token = ht;
	addPermanentTab("MC");
});

Byond.subscribeTo("update_sdql2", function (S) {
	sdql2 = S;
	if (sdql2.length > 0 && !verb_tabs.includes("SDQL2")) {
		verb_tabs.push("SDQL2");
		addPermanentTab("SDQL2");
	}
	if (current_tab == "SDQL2") {
		draw_sdql2();
	}
});

Byond.subscribeTo("update_tickets", function (T) {
	tickets = T;
	if (!verb_tabs.includes("Tickets")) {
		verb_tabs.push("Tickets");
		addPermanentTab("Tickets");
	}
	if (current_tab == "Tickets") {
		draw_tickets();
	}
});

Byond.subscribeTo("remove_listedturf", remove_listedturf);

Byond.subscribeTo("remove_sdql2", remove_sdql2);

Byond.subscribeTo("remove_mc", remove_mc);

Byond.subscribeTo("add_verb_list", add_verb_list);

function createOptionsButton() {
	addPermanentTab("Panel Options");
}

function openOptionsMenu() {
	Byond.command("Open-Statbrowser-Options " + current_fontsize);
}

Byond.subscribeTo("change_fontsize", function (new_fontsize) {
	current_fontsize = parseInt(new_fontsize);
	if (!Byond.TRIDENT) {
		window.hubStorage.setItem("fontsize", current_fontsize.toString());
	} else { // TODO: Remove with 516
		window.localStorage.setItem("fontsize", current_fontsize.toString());
	}
	statcontentdiv.style.fontSize = current_fontsize + "px";
	tab_change(current_tab, true); // Redraw the current tab
});
