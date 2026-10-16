import { toFixed } from 'common/math';

import { useBackend } from '../backend';
import {
  Button,
  LabeledControls,
  NoticeBox,
  NumberInput,
  RoundGauge,
  Section,
} from '../components';
import { formatSiUnit } from '../format';
import { Window } from '../layouts';

const formatPressure = (value) => {
  if (value < 10000) {
    return toFixed(value) + ' kPa';
  }
  return formatSiUnit(value * 1000, 1, 'Pa');
};

export const Tank = (props) => {
  const { act, data } = useBackend();

  return (
    <Window width={310} height={150}>
      <Window.Content>
        {(!!data.mask_connected && (
          <NoticeBox success>此气瓶已连接面罩。</NoticeBox>
        )) || (
          <NoticeBox danger>此气瓶未连接面罩。</NoticeBox>
        )}
        <Section>
          <LabeledControls>
            <LabeledControls.Item label="压力">
              <RoundGauge
                value={data.tankPressure}
                minValue={0}
                maxValue={data.tankMaxPressure}
                format={formatPressure}
                size={2}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="压力调节器">
              <Button
                icon="fast-backward"
                disabled={data.ReleasePressure === data.minReleasePressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'min',
                  })
                }
              />
              <NumberInput
                animated
                value={parseFloat(data.ReleasePressure)}
                width="65px"
                unit="kPa"
                step={1}
                minValue={data.minReleasePressure}
                maxValue={data.maxReleasePressure}
                onChange={(value) =>
                  act('pressure', {
                    pressure: value,
                  })
                }
              />
              <Button
                icon="fast-forward"
                disabled={data.ReleasePressure === data.maxReleasePressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'max',
                  })
                }
              />
              <Button
                icon="undo"
                disabled={data.ReleasePressure === data.defaultReleasePressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'reset',
                  })
                }
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="阀门">
              <Button
                my={0.5}
                width="60px"
                lineHeight={2}
                fontSize="11px"
                disabled={!data.mask_connected}
                color={data.valve_open ? 'danger' : null}
                icon={data.valve_open ? 'lock-open' : 'lock'}
                onClick={() => act('valve')}
              >
                {data.valve_open ? '开启' : '关闭'}
              </Button>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
