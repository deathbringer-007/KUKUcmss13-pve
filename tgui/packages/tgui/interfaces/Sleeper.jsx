import { round } from 'common/math';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

const stats = [
  ['good', '存活'],
  ['average', '危重'],
  ['bad', '死亡'],
];

const damages = [
  ['物理损伤', 'bruteLoss'],
  ['烧伤', 'fireLoss'],
  ['毒素损伤', 'toxLoss'],
  ['缺氧损伤', 'oxyLoss'],
];

const damageRange = {
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

const tempColors = [
  'bad',
  'average',
  'average',
  'good',
  'average',
  'average',
  'bad',
];

export const Sleeper = (props) => {
  const { act, data } = useBackend();
  const { hasOccupant } = data;
  const body = hasOccupant ? <SleeperMain /> : <SleeperEmpty />;
  const windowHeight = hasOccupant ? 850 : 150;
  return (
    <Window resizable width={500} height={windowHeight}>
      <Window.Content className="Layout__content--flexColumn">
        {body}
      </Window.Content>
    </Window>
  );
};

const SleeperMain = (props) => {
  const { act, data } = useBackend();
  const { occupant } = data;
  return (
    <>
      <SleeperDialysis />
      <SleeperOccupant />
      <SleeperDamage />
      <SleeperChemicals />
    </>
  );
};

const SleeperOccupant = (props) => {
  const { act, data } = useBackend();
  const { occupant, auto_eject_dead } = data;
  return (
    <Section
      title="患者"
      buttons={
        <>
          <Box color="label" inline>
            死亡后自动移出：&nbsp;
          </Box>
          <Button
            icon={auto_eject_dead ? 'toggle-on' : 'toggle-off'}
            selected={auto_eject_dead}
            onClick={() =>
              act('auto_eject_dead_' + (auto_eject_dead ? 'off' : 'on'))
            }
          >
            {auto_eject_dead ? '开启' : '关闭'}
          </Button>
          <Button icon="user-slash" onClick={() => act('ejectify')}>
            移出患者
          </Button>
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="姓名">{occupant.name}</LabeledList.Item>
        <LabeledList.Item label="健康">
          <ProgressBar
            min="0"
            max={occupant.maxHealth}
            value={occupant.health / occupant.maxHealth}
            ranges={{
              good: [0.5, Infinity],
              average: [0, 0.5],
              bad: [-Infinity, 0],
            }}
          >
            {round(occupant.health, 0)}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="状态" color={stats[occupant.stat][0]}>
          {stats[occupant.stat][1]}
        </LabeledList.Item>
        <LabeledList.Item label="体温">
          <ProgressBar
            min="0"
            max={occupant.maxTemp}
            value={occupant.bodyTemperature / occupant.maxTemp}
            color={tempColors[occupant.temperatureSuitability + 3]}
          >
            {round(occupant.btCelsius, 0)}&deg;C,
            {round(occupant.btFaren, 0)}&deg;F
          </ProgressBar>
        </LabeledList.Item>
        {!!occupant.hasBlood && (
          <>
            <LabeledList.Item label="血量">
              <ProgressBar
                min="0"
                max={occupant.bloodMax}
                value={occupant.bloodLevel / occupant.bloodMax}
                ranges={{
                  bad: [-Infinity, 0.6],
                  average: [0.6, 0.9],
                  good: [0.6, Infinity],
                }}
              >
                {occupant.bloodPercent}%, {occupant.bloodLevel}厘升
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="脉搏" verticalAlign="middle">
              {occupant.pulse}次/分
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
    </Section>
  );
};

const SleeperDamage = (props) => {
  const { data } = useBackend();
  const { occupant } = data;
  return (
    <Section title="患者伤势">
      <LabeledList>
        {damages.map((d, i) => (
          <LabeledList.Item key={i} label={d[0]}>
            <ProgressBar
              key={i}
              min="0"
              max="100"
              value={occupant[d[1]] / 100}
              ranges={damageRange}
            >
              {round(occupant[d[1]], 0)}
            </ProgressBar>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const SleeperDialysis = (props) => {
  const { act, data } = useBackend();
  const { hasOccupant, dialysis, occupant } = data;
  const canDialysis = dialysis;
  const dialysisDisabled = !hasOccupant || !occupant.totalreagents;
  return (
    <Section
      title="透析"
      buttons={
        <Button
          disabled={dialysisDisabled}
          selected={canDialysis}
          icon={canDialysis ? 'toggle-on' : 'toggle-off'}
          onClick={() => act('togglefilter')}
        >
          {canDialysis ? '已启用' : '未启用'}
        </Button>
      }
    >
      {!occupant.totalreagents && (
        <NoticeBox danger>患者体内没有需要清除的化学物质！</NoticeBox>
      )}
      {(canDialysis && (
        <ProgressBar
          min="0"
          max={occupant.reagentswhenstarted}
          value={occupant.totalreagents / occupant.reagentswhenstarted}
          title="剩余试剂量／开始透析时的试剂量"
        >
          {occupant.totalreagents}/{occupant.reagentswhenstarted}
        </ProgressBar>
      )) ||
        (!dialysisDisabled && <NoticeBox info>透析未启用！</NoticeBox>)}
    </Section>
  );
};

const SleeperChemicals = (props) => {
  const { act, data } = useBackend();
  const { occupant, chemicals, maxchem, amounts } = data;
  return (
    <Section title="患者体内药物">
      {chemicals.map((chem, i) => {
        let barColor = '';
        let odWarning;
        if (chem.overdosing) {
          barColor = 'bad';
          odWarning = (
            <Box color="bad">
              <Icon name="exclamation-circle" />
              &nbsp; 药物过量！
            </Box>
          );
        } else if (chem.od_warning) {
          barColor = 'average';
          odWarning = (
            <Box color="average">
              <Icon name="exclamation-triangle" />
              &nbsp; 接近过量
            </Box>
          );
        }
        return (
          <Box key={i} backgroundColor="rgba(0, 0, 0, 0.33)" mb="0.5rem">
            <Section
              title={chem.title}
              level="3"
              mx="0"
              lineHeight="18px"
              buttons={odWarning}
            >
              <Flex align="flex-start">
                <ProgressBar
                  min="0"
                  max={maxchem}
                  value={chem.occ_amount / maxchem}
                  color={barColor}
                  title="患者体内当前药量／本设备最大可注射量"
                  mr="0.5rem"
                >
                  {chem.pretty_amount}/{maxchem}u
                </ProgressBar>
                {amounts.map((a, i) => (
                  <Button
                    key={i}
                    disabled={
                      !chem.injectable ||
                      chem.occ_amount + a > maxchem ||
                      occupant.stat === 2
                    }
                    icon="syringe"
                    title={`向患者注射 ${a} 单位${chem.title}`}
                    mb="0"
                    height="19px"
                    onClick={() =>
                      act('chemical', {
                        chemid: chem.id,
                        amount: a,
                      })
                    }
                  >
                    {'注射 ' + a + ' 单位'}
                  </Button>
                ))}
              </Flex>
            </Section>
          </Box>
        );
      })}
    </Section>
  );
};

const SleeperEmpty = (props) => {
  return (
    <Section textAlign="center">
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size="5" />
          <br />
          未检测到患者。
        </Flex.Item>
      </Flex>
    </Section>
  );
};
