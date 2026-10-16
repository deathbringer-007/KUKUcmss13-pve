import { toFixed } from 'common/math';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, Section } from '../components';
import { RADIO_CHANNELS } from '../constants';
import { Window } from '../layouts';

const channelLabels = new Map([
  ['UNSET', '未设置'],
  ['Almayer', '阿尔迈耶号'],
  ['Alamo', '阿拉莫号'],
  ['Normandy', '诺曼底号'],
  ['Saipan', '塞班号'],
  ['Command', '指挥'],
  ['Colony', '殖民地'],
  ['Common', '公共'],
  ['department', '部门'],
  ['headset', '耳机'],
  ['intercom', '对讲机'],
  ['special', '特殊'],
  ['Engi', '工程'],
  ['Engineering', '工程'],
  ['HighCom', '高级指挥部'],
  ['High Command', '高级指挥部'],
  ['Provost', '军法监察'],
  ['Intel', '情报'],
  ['JTAC', '联合终端攻击控制'],
  ['MedSci', '医疗科研'],
  ['MP', '宪兵'],
  ['Req', '军需'],
  ['Sentry', '哨戒炮'],
  ['Sentry Network', '哨戒炮网络'],
  ['USASF', '美国航空航天军'],
  ['US Army', '美国陆军'],
  ['USCG', '美洲联盟殖民地卫队'],
  ['UA Colonial Guard', '美洲联盟殖民地卫队'],
  ['CLF', '殖民地解放阵线'],
  ['CLF Command', 'CLF 指挥'],
  ['CLF CMD', 'CLF 指挥'],
  ['CLF Med', 'CLF 医疗'],
  ['CLF MED', 'CLF 医疗'],
  ['CLF Engi', 'CLF 工程'],
  ['CLF ENG', 'CLF 工程'],
  ['UPP', '进步人民联盟'],
  ['UPP Command', 'UPP 指挥'],
  ['UPP CMD', 'UPP 指挥'],
  ['UPP Med', 'UPP 医疗'],
  ['UPP MED', 'UPP 医疗'],
  ['UPP Engi', 'UPP 工程'],
  ['UPP ENG', 'UPP 工程'],
  ['UPP CCT', 'UPP 战斗控制'],
  ['UPP Kdo', 'UPP 突击队'],
  ['UPP KDO', 'UPP 突击队'],
  ['UPP Guard', 'UPP 地方卫队'],
  ['GUARD', 'UPP 地方卫队'],
  ['WY', '维兰德-汤谷'],
  ['WY PMC', '维兰德-汤谷承包商'],
  ['PMC', '私人军事承包商'],
  ['PMC Command', 'PMC 指挥'],
  ['PMC CMD', 'PMC 指挥'],
  ['PMC Med', 'PMC 医疗'],
  ['PMC MED', 'PMC 医疗'],
  ['PMC Engi', 'PMC 工程'],
  ['PMC ENG', 'PMC 工程'],
  ['PMC CCT', 'PMC 战斗控制'],
  ['SpecOps', '特种作战'],
  ['Deathsquad', '死亡小队'],
  ['Listening Device A', '窃听器 A'],
  ['LSTN BUG A', '窃听器 A'],
  ['Listening Device B', '窃听器 B'],
  ['LSTN BUG B', '窃听器 B'],
  ['DD', '达奇十二人组'],
  ["Dutch's Dozen", '达奇十二人组'],
  ['VAI', '先锋之箭公司'],
  ['CMB', '殖民地执法局'],
  ['Royal Marine', '皇家陆战突击队'],
  ['RMC', '皇家陆战突击队'],
  ['Mercenaries', '雇佣兵'],
  ['Yautja', '铁血战士'],
  ['Yautja Overseer', '铁血战士督军'],
  ['Alpha', '阿尔法'],
  ['Bravo', '布拉沃'],
  ['Charlie', '查理'],
  ['Delta', '德尔塔'],
  ['Echo', '埃科'],
  ['Foxtrot', '福克斯特罗特'],
  ['Reserves', '预备队'],
  ['SOF', '特种部队'],
  ['Sun Riders', '烈日骑兵'],
  ['Sun Riders B-Sct', '烈日骑兵 B 分队'],
]);

const channelLabel = (name) => channelLabels.get(name) ?? name;

export const Radio = (props) => {
  const { act, data } = useBackend();
  const {
    freqlock,
    frequency,
    minFrequency,
    maxFrequency,
    listening,
    broadcasting,
    command,
    useCommand,
    subspace,
    subspaceSwitchable,
  } = data;

  const radioChannels = data.channels;

  const tunedChannel = RADIO_CHANNELS.find(
    (channel) => channel.freq === frequency,
  );

  // Calculate window height
  let height = 106;
  if (subspace) {
    if (radioChannels.length > 0) {
      height += radioChannels.length * 21 + 6;
    } else {
      height += 24;
    }
  }
  return (
    <Window width={360} height={height}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="频率">
              {(freqlock && (
                <Box inline color="light-gray">
                  {toFixed(frequency / 10, 1) + ' kHz'}
                </Box>
              )) || (
                <NumberInput
                  animate
                  unit="kHz"
                  step={0.2}
                  stepPixelSize={10}
                  minValue={minFrequency / 10}
                  maxValue={maxFrequency / 10}
                  value={frequency / 10}
                  format={(value) => toFixed(value, 1)}
                  onDrag={(value) =>
                    act('frequency', {
                      adjust: value - frequency / 10,
                    })
                  }
                />
              )}
              {tunedChannel && (
                <Box inline color={tunedChannel.color} ml={2}>
                  [{channelLabel(tunedChannel.name)}]
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="音频">
              <Button
                textAlign="center"
                width="37px"
                icon={listening ? 'volume-up' : 'volume-mute'}
                selected={listening}
                onClick={() => act('listen')}
              />
              <Button
                textAlign="center"
                width="37px"
                icon={broadcasting ? 'microphone' : 'microphone-slash'}
                selected={broadcasting}
                onClick={() => act('broadcast')}
              />
              {!!command && (
                <Button
                  ml={1}
                  icon="bullhorn"
                  selected={useCommand}
                  onClick={() => act('command')}
                >
                  {`高音量：${useCommand ? '开启' : '关闭'}`}
                </Button>
              )}
              {!!subspaceSwitchable && (
                <Button
                  ml={1}
                  icon="bullhorn"
                  selected={subspace}
                  onClick={() => act('subspace')}
                >
                  {`子空间发射：${subspace ? '开启' : '关闭'}`}
                </Button>
              )}
            </LabeledList.Item>
            {!!subspace && (
              <LabeledList.Item label="频道">
                {radioChannels.length === 0 && (
                  <Box inline color="bad">
                    未安装加密密钥。
                  </Box>
                )}
                {radioChannels.map((channel) => (
                  <Box key={channel}>
                    <Button
                      icon={channel.status ? 'check-square-o' : 'square-o'}
                      selected={channel.status}
                      onClick={() =>
                        act('channel', {
                          channel: channel.name,
                        })
                      }
                    >
                      {channelLabel(channel.name) + ' '}
                      {channel.hotkey
                        ? '[' + channel.hotkey.toUpperCase() + ']'
                        : '[无]'}
                    </Button>
                  </Box>
                ))}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
