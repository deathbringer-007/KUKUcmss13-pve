/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const MAX_VISIBLE_MESSAGES = 2500;
export const MAX_PERSISTED_MESSAGES = 1000;
export const MESSAGE_SAVE_INTERVAL = 10000;
export const MESSAGE_PRUNE_INTERVAL = 60000;
export const COMBINE_MAX_MESSAGES = 5;
export const COMBINE_MAX_TIME_WINDOW = 5000;
export const IMAGE_RETRY_DELAY = 250;
export const IMAGE_RETRY_LIMIT = 10;
export const IMAGE_RETRY_MESSAGE_AGE = 60000;
export const RENDERER_RELOAD_WAIT = 1000;

// Remove with 516
export const RENDERER_RELOAD_WAIT_TRIDENT = 2500;

// Default message type
export const MESSAGE_TYPE_UNKNOWN = 'unknown';

// Internal message type
export const MESSAGE_TYPE_INTERNAL = 'internal';

// Must match the set of defines in code/__DEFINES/chat.dm
export const MESSAGE_TYPE_SYSTEM = 'system';
export const MESSAGE_TYPE_LOCALCHAT = 'localchat';
export const MESSAGE_TYPE_RADIO = 'radio';
export const MESSAGE_TYPE_HIVEMIND = 'hivemind';
export const MESSAGE_TYPE_INFO = 'info';
export const MESSAGE_TYPE_WARNING = 'warning';
export const MESSAGE_TYPE_HELPFUL = 'helpful';
export const MESSAGE_TYPE_DEADCHAT = 'deadchat';
export const MESSAGE_TYPE_OOC = 'ooc';
export const MESSAGE_TYPE_ADMINPM = 'adminpm';
export const MESSAGE_TYPE_COMBAT = 'combat';
export const MESSAGE_TYPE_ADMINCHAT = 'adminchat';
export const MESSAGE_TYPE_MODCHAT = 'modchat';
export const MESSAGE_TYPE_MENTOR = 'mentor';
export const MESSAGE_TYPE_STAFF_IC = 'staff_ic';
export const MESSAGE_TYPE_EVENTCHAT = 'eventchat';
export const MESSAGE_TYPE_ADMINLOG = 'adminlog';
export const MESSAGE_TYPE_ATTACKLOG = 'attacklog';
export const MESSAGE_TYPE_DEBUG = 'debug';
export const MESSAGE_TYPE_NICHE = 'niche';

// Metadata for each message type
export const MESSAGE_TYPES = [
  // Always-on types
  {
    type: MESSAGE_TYPE_SYSTEM,
    name: '系统消息',
    description: '客户端发出的消息，始终启用',
    selector: '.boldannounce',
    important: true,
  },
  // Basic types
  {
    type: MESSAGE_TYPE_LOCALCHAT,
    name: '附近',
    description: '附近的角色内消息（说话、表情等）',
    selector:
      '.say, .emote, .say_quote, .german, .rough, .japanese, .monkey, .vox, .changeling, .soghun, .tajaran, .xenotalk',
  },
  {
    type: MESSAGE_TYPE_RADIO,
    name: '无线电',
    description: '所有部门的无线电消息',
    selector: '.radio, .alert, .newscaster',
  },
  {
    type: MESSAGE_TYPE_HIVEMIND,
    name: '虫巢意志',
    description: '异形虫巢意志消息',
    selector: '.xeno, .xenoqueen, .xenoleader',
  },
  {
    type: MESSAGE_TYPE_INFO,
    name: '信息',
    description: '游戏与物品发出的非紧急消息',
    selector:
      '.notice:not(.pm), .adminnotice, .info, .role_body, .role_header, .event_announcement, .announce_header, .announce_header_blue, .announce_body, .sinister, .cult, .xenonotice, .xenoannounce, .yautjabold, .yautjaboldbig',
  },
  {
    type: MESSAGE_TYPE_WARNING,
    name: '警告',
    description: '游戏与物品发出的紧急消息',
    selector:
      '.warning:not(.pm), .critical, .userdanger, .italics, .xenowarning, .xenominorwarning',
  },
  {
    type: MESSAGE_TYPE_DEADCHAT,
    name: '死者聊天',
    description: '所有死者聊天消息',
    selector: '.deadsay',
  },
  {
    type: MESSAGE_TYPE_OOC,
    name: 'OOC',
    description: '全局OOC频道的蓝色消息',
    selector: '.ooc, .adminooc, .xooc, .mooc, .yooc, .modooc',
  },
  {
    type: MESSAGE_TYPE_ADMINPM,
    name: '管理员私信',
    description: '与管理员之间的消息（管理员求助）',
    selector: '.pm, .adminhelp',
  },
  {
    type: MESSAGE_TYPE_COMBAT,
    name: '战斗日志',
    description: '例如：Urist McTraitor用刀刺伤了你！',
    selector:
      '.danger, .moderate, .disarm, .attack, .passive, .xenodanger, .xenohighdanger, .highdanger, .avoidharm',
  },
  {
    type: MESSAGE_TYPE_HELPFUL,
    name: '协助',
    description: '例如：一等兵Unga Dunga开始喂你吃药。',
    selector: '.helpful',
  },
  {
    type: MESSAGE_TYPE_UNKNOWN,
    name: '未分类',
    description: '所有无法分类的消息，始终启用',
  },
  {
    type: MESSAGE_TYPE_STAFF_IC,
    name: '管理人员角色互动',
    description: '与管理人员进行的角色内互动',
    selector: '.staff_ic',
  },
  // Admin stuff
  {
    type: MESSAGE_TYPE_ADMINCHAT,
    name: 'Admin Chat',
    description: 'ASAY messages',
    selector:
      '.admin_channel, .adminsay, .headminsay, .mod_channel, .mod, .adminmod, .staffsay',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_MENTOR,
    name: 'Mentor',
    description: 'Mentor Chat, Mhelps',
    selector: '.mentorsay, .mentorhelp, .mentorbody, .mentorstaff',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_ADMINLOG,
    name: 'Admin Log',
    description: 'ADMIN LOG: Urist McAdmin has jumped to coordinates X, Y, Z',
    selector: '.log_message, .admin',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_ATTACKLOG,
    name: 'Attack Log',
    description: 'Urist McTraitor has shot John Doe',
    selector: '.attacklog',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_DEBUG,
    name: 'Debug Log',
    description: 'DEBUG: SSPlanets subsystem Recover().',
    selector: '.debuginfo',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_NICHE,
    name: 'Niche Log',
    description: 'ADMIN NICHE LOG: Urist McTraitor stuttered while saying: Boo',
    selector: '.niche',
    admin: true,
  },
];
