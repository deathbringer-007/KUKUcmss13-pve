import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';
import { BeakerContents } from './common/BeakerContents';

const damageTypes = [
  {
    label: '物理损伤',
    type: 'bruteLoss',
  },
  {
    label: '缺氧损伤',
    type: 'oxyLoss',
  },
  {
    label: '毒素损伤',
    type: 'toxLoss',
  },
  {
    label: '烧伤',
    type: 'fireLoss',
  },
];

export const Cryo = () => {
  return (
    <Window width={400} height={550}>
      <Window.Content scrollable>
        <CryoContent />
      </Window.Content>
    </Window>
  );
};

const CryoContent = (props) => {
  const { act, data } = useBackend();

  let soundicon = 'volume-high';
  if (!data.notify) {
    soundicon = 'volume-xmark';
  }
  return (
    <>
      <Section title="患者">
        <LabeledList>
          <LabeledList.Item label="患者">
            {data.occupant.name || '无患者'}
          </LabeledList.Item>
          {!!data.hasOccupant && (
            <>
              <LabeledList.Item label="状态" color={data.occupant.statstate}>
                {data.occupant.stat}
              </LabeledList.Item>
              <LabeledList.Item
                label="温度"
                color={data.occupant.temperaturestatus}
              >
                <AnimatedNumber value={data.occupant.bodyTemperature} />
                {' K'}
              </LabeledList.Item>
              <LabeledList.Item label="健康">
                <ProgressBar
                  value={data.occupant.health / data.occupant.maxHealth}
                  color={data.occupant.health > 0 ? 'good' : 'average'}
                >
                  <AnimatedNumber value={data.occupant.health} />
                </ProgressBar>
              </LabeledList.Item>
              {damageTypes.map((damageType) => (
                <LabeledList.Item key={damageType.id} label={damageType.label}>
                  <ProgressBar value={data.occupant[damageType.type] / 100}>
                    <AnimatedNumber value={data.occupant[damageType.type]} />
                  </ProgressBar>
                </LabeledList.Item>
              ))}
            </>
          )}
        </LabeledList>
      </Section>
      <Section title="冷冻舱">
        <LabeledList>
          <LabeledList.Item label="电源">
            <Button
              icon={data.isOperating ? 'power-off' : 'times'}
              disabled={data.isOpen}
              onClick={() => act('power')}
              color={data.isOperating && 'green'}
            >
              {data.isOperating ? '开启' : '关闭'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="温度">
            <AnimatedNumber value={data.cellTemperature} /> K
          </LabeledList.Item>
          <LabeledList.Item label="舱门">
            <Button
              icon="eject"
              disabled={!data.hasOccupant}
              onClick={() => act('eject')}
            >
              移出患者
            </Button>
            <Button
              icon={data.autoEject ? 'sign-out-alt' : 'sign-in-alt'}
              width="6rem"
              tooltipPosition="top"
              tooltip={
                '自动移出已' + (data.autoEject ? '启用。' : '禁用。')
              }
              onClick={() => act('autoeject')}
            >
              {data.autoEject ? '自动' : '手动'}
            </Button>
            <Button
              icon={soundicon}
              ml="auto"
              mr="1rem"
              width="5.5rem"
              tooltipPosition="top"
              tooltip={
                '自动移出通知已' +
                (data.notify ? '启用。' : '禁用。')
              }
              onClick={() => act('notice')}
            >
              {data.notify ? '通知' : '静音'}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="烧杯"
        buttons={
          <Button
            icon="eject"
            disabled={!data.isBeakerLoaded}
            onClick={() => act('ejectbeaker')}
          >
            取出
          </Button>
        }
      >
        <BeakerContents
          beakerLoaded={data.isBeakerLoaded}
          beakerContents={data.beakerContents}
        />
      </Section>
    </>
  );
};
