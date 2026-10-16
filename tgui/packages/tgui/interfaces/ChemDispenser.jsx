import { toFixed } from 'common/math';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const ChemDispenser = (props) => {
  const { act, data } = useBackend();
  const beakerTransferAmounts = data.beakerTransferAmounts || [];
  const beakerContents = data.beakerContents || [];
  return (
    <Window width={435} height={620}>
      <Window.Content scrollable>
        <Section title="状态">
          <LabeledList>
            <LabeledList.Item label="能量">
              <ProgressBar value={data.energy / data.maxEnergy}>
                {toFixed(data.energy) + ' 能量'}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="分配试剂"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="plus"
              selected={amount === data.amount}
              onClick={() =>
                act('amount', {
                  target: amount,
                })
              }
            >
              {amount}
            </Button>
          ))}
        >
          <Box mr={-1}>
            {data.chemicals.map((chemical) => (
              <Button
                key={chemical.id}
                icon="arrow-alt-circle-down"
                width="129.5px"
                lineHeight={1.75}
                onClick={() =>
                  act('dispense', {
                    reagent: chemical.id,
                  })
                }
              >
                {chemical.title}
              </Button>
            ))}
          </Box>
        </Section>
        <Section
          title="烧杯"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="minus"
              onClick={() => act('remove', { amount })}
            >
              {amount}
            </Button>
          ))}
        >
          <LabeledList>
            <LabeledList.Item
              label="烧杯"
              buttons={
                !!data.isBeakerLoaded && (
                  <Button
                    icon="eject"
                    disabled={!data.isBeakerLoaded}
                    onClick={() => act('eject')}
                  >
                    取出
                  </Button>
                )
              }
            >
              {(data.isBeakerLoaded && (
                <>
                  <AnimatedNumber
                    initial={0}
                    value={data.beakerCurrentVolume}
                  />
                  /{data.beakerMaxVolume} 单位
                </>
              )) || <NoticeBox info>未放入烧杯！</NoticeBox>}
            </LabeledList.Item>
            <LabeledList.Item label="内容物">
              <Box color="label">
                {(!data.isBeakerLoaded && '无') ||
                  (beakerContents.length === 0 && '空')}
              </Box>
              {beakerContents.map((chemical) => (
                <Box key={chemical.name} color="label">
                  <AnimatedNumber initial={0} value={chemical.volume} /> 单位
                  {chemical.name}
                </Box>
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
