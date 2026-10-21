/** Window sizes in pixels */
export enum WindowSize {
  Small = 30,
  Medium = 45,
  Large = 60,
  Width = 380,
}

/** Line lengths for autoexpand */
export enum LineLength {
  Small = 38,
  Medium = 76,
  Large = 104,
}

/**
 * Radio prefixes.
 * Contains the properties:
 * id - string. css class identifier.
 * label - string. button label.
 */
export const CHANNEL_LABELS: Record<string, string> = {
  Say: '说话',
  Comms: '无线电',
  Me: '表情',
  Mentor: '导师',
  ASAY: '管理频道',
};

export const RADIO_PREFIXES = {
  ':h ': {
    id: 'department',
    label: '部门',
  },
  '.h ': {
    id: 'department',
    label: '部门',
  },
  '#h ': {
    id: 'department',
    label: '部门',
  },
  ':i ': {
    id: 'comms',
    label: '对讲机',
  },
  '.i ': {
    id: 'comms',
    label: '对讲机',
  },
  '#i ': {
    id: 'comms',
    label: '对讲机',
  },
  ':l ': {
    id: 'comms',
    label: '左手',
  },
  '.l ': {
    id: 'comms',
    label: '左手',
  },
  ':r ': {
    id: 'comms',
    label: '右手',
  },
  '.r ': {
    id: 'comms',
    label: '右手',
  },
  ':w ': {
    id: 'whisper',
    label: '低语',
  },
  '.w ': {
    id: 'whisper',
    label: '低语',
  },
  '#w ': {
    id: 'whisper',
    label: '低语',
  },
  ':a ': {
    id: 'alpha',
    label: '阿尔法',
  },
  '.a ': {
    id: 'alpha',
    label: '阿尔法',
  },
  '#a ': {
    id: 'clf-med',
    label: 'CLF医疗',
  },
  ':b ': {
    id: 'bravo',
    label: '布拉沃',
  },
  '.b ': {
    id: 'bravo',
    label: '布拉沃',
  },
  '#b ': {
    id: 'clf-engi',
    label: 'CLF工程',
  },
  ':c ': {
    id: 'charlie',
    label: '查理',
  },
  '.c ': {
    id: 'charlie',
    label: '查理',
  },
  '#c ': {
    id: 'cia',
    label: 'CIA',
  },
  ':d ': {
    id: 'delta',
    label: '德尔塔',
  },
  '.d ': {
    id: 'delta',
    label: '德尔塔',
  },
  '#d ': {
    id: 'merc',
    label: '雇佣兵',
  },
  ':e ': {
    id: 'echo',
    label: '埃科',
  },
  '.e ': {
    id: 'echo',
    label: '埃科',
  },
  '#e ': {
    id: 'pmc-engi',
    label: 'PMC工程',
  },
  ':f ': {
    id: 'foxtrot',
    label: '福克斯特罗特',
  },
  '.f ': {
    id: 'foxtrot',
    label: '福克斯特罗特',
  },
  '#f ': {
    id: 'pmc-med',
    label: 'PMC医疗',
  },
  ':g ': {
    id: 'ship',
    label: '舰船',
  },
  '.g ': {
    id: 'ship',
    label: '舰船',
  },
  '#g ': {
    id: 'clf',
    label: 'CLF',
  },
  ':j ': {
    id: 'jtac',
    label: 'JTAC',
  },
  '.j ': {
    id: 'jtac',
    label: 'JTAC',
  },
  '#j ': {
    id: 'upp-cct',
    label: 'UPP战斗控制',
  },
  ':k ': {
    id: 'sof',
    label: 'SOF',
  },
  '.k ': {
    id: 'sof',
    label: 'SOF',
  },
  '#k ': {
    id: 'specops',
    label: '特别行动',
  },
  '#l ': {
    id: 'provost',
    label: '军法监察',
  },
  ':m ': {
    id: 'medsci',
    label: '医研',
  },
  '.m ': {
    id: 'medsci',
    label: '医研',
  },
  '#m ': {
    id: 'upp-med',
    label: 'UPP医疗',
  },
  ':n ': {
    id: 'engi',
    label: '工程',
  },
  '.n ': {
    id: 'engi',
    label: '工程',
  },
  '#n ': {
    id: 'upp-engi',
    label: 'UPP工程',
  },
  ':o ': {
    id: 'colony',
    label: '殖民地',
  },
  '.o ': {
    id: 'colony',
    label: '殖民地',
  },
  '#o ': {
    id: 'pmc-cct',
    label: 'PMC战斗控制',
  },
  ':p ': {
    id: 'security',
    label: '宪兵',
  },
  '.p ': {
    id: 'security',
    label: '宪兵',
  },
  '#p ': {
    id: 'pmc',
    label: 'PMC',
  },
  ':q ': {
    id: 'rmc',
    label: 'RMC',
  },
  '.q ': {
    id: 'rmc',
    label: 'RMC',
  },
  '#q ': {
    id: 'rmc',
    label: 'RMC',
  },
  '#r ': {
    id: 'yautja',
    label: '铁血战士',
  },
  ':s ': {
    id: 'us-army',
    label: '美国陆军',
  },
  '.s ': {
    id: 'us-army',
    label: '美国陆军',
  },
  '#s ': {
    id: 'us-army',
    label: '美国陆军',
  },
  ':t ': {
    id: 'intel',
    label: '情报',
  },
  '.t ': {
    id: 'intel',
    label: '情报',
  },
  '#t ': {
    id: 'upp-kdo',
    label: 'UPP突击队',
  },
  ':u ': {
    id: 'req',
    label: '补给',
  },
  '.u ': {
    id: 'req',
    label: '补给',
  },
  '#u ': {
    id: 'upp',
    label: 'UPP',
  },
  ':v ': {
    id: 'command',
    label: '指挥',
  },
  '.v ': {
    id: 'command',
    label: '指挥',
  },
  '#v ': {
    id: 'upp-cmd',
    label: 'UPP指挥',
  },
  ':x ': {
    id: 'usasf',
    label: 'USASF',
  },
  '.x ': {
    id: 'usasf',
    label: 'USASF',
  },
  '#x ': {
    id: 'usasf',
    label: 'USASF',
  },
  ':y ': {
    id: 'wy',
    label: 'W-Y',
  },
  '.y ': {
    id: 'wy',
    label: 'W-Y',
  },
  '#y ': {
    id: 'wy',
    label: 'W-Y',
  },
  ':z ': {
    id: 'highcom',
    label: '最高指挥部',
  },
  '.z ': {
    id: 'highcom',
    label: '最高指挥部',
  },
  '#z ': {
    id: 'pmc-cmd',
    label: 'PMC指挥',
  },
  ':0 ': {
    id: 'uscg',
    label: 'USCG',
  },
  '.0 ': {
    id: 'uscg',
    label: 'USCG',
  },
  '#0 ': {
    id: 'uscg',
    label: 'USCG',
  },
  ':1 ': {
    id: 'usasf',
    label: 'USASF',
  },
  '.1 ': {
    id: 'usasf',
    label: 'USASF',
  },
  '#1 ': {
    id: 'usasf',
    label: 'USASF',
  },
  ':2 ': {
    id: 'pfa',
    label: 'PFA',
  },
  '.2 ': {
    id: 'pfa',
    label: 'PFA',
  },
  '#2 ': {
    id: 'pfa',
    label: 'PFA',
  },
  ':3 ': {
    id: 'jsc',
    label: 'JSC',
  },
  '.3 ': {
    id: 'jsc',
    label: 'JSC',
  },
  '#3 ': {
    id: 'jsc',
    label: 'JSC',
  },
} as const;

export const LANGUAGE_PREFIXES = {
  '!0 ': {
    id: 'scandinavian',
    label: '斯堪的纳维亚语',
  },
  '!1 ': {
    id: 'english',
    label: '英语',
  },
  '!2 ': {
    id: 'japanese',
    label: '日语',
  },
  '!3 ': {
    id: 'russian',
    label: '俄语',
  },
  '!4 ': {
    id: 'german',
    label: '德语',
  },
  '!5 ': {
    id: 'spanish',
    label: '西班牙语',
  },
  '!6 ': {
    id: 'apollo',
    label: '阿波罗',
  },
  '!7 ': {
    id: 'french',
    label: '法语',
  },
  '!8 ': {
    id: 'chinese',
    label: '中文',
  },
  '!9 ': {
    id: 'russian patois',
    label: '俄语混合方言',
  },
  '!f ': {
    id: 'filipino',
    label: '菲律宾语',
  },
  '!h ': {
    id: 'hellhound',
    label: '地狱猎犬语',
  },
  '!l ': {
    id: 'tactical sign language',
    label: '战术手语',
  },
  '!m ': {
    id: 'primitive',
    label: '原始语',
  },
  '!p ': {
    id: 'polish',
    label: '波兰语',
  },
  '!s ': {
    id: 'sainja',
    label: '赛因加语',
  },
  '!t ': {
    id: 'telepathy',
    label: '心灵感应',
  },
  '!q ': {
    id: 'hivemind',
    label: '虫巢意志',
  },
  '!x ': {
    id: 'xenomorph',
    label: '异形语',
  },
} as const;
