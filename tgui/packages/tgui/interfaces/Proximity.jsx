import { useBackend } from '../backend';
import { Button, Knob, LabeledList, Section, Slider } from '../components';
import { Window } from '../layouts';

export const Proximity = (props) => {
  const { act, data } = useBackend();
  const { max_time, min_time, max_range, min_range, max_delay, min_delay } =
    data;

  const window_width = 360;
  return (
    <Window width={window_width} height={215}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="布防设置">
              <Button
                color={data.is_arming ? 'green' : 'red'}
                icon="clock"
                onClick={() =>
                  act('set_arming', { should_start_arming: !data.is_arming })
                }
              >
                {data.is_arming ? '正在布防' : '未在布防'}
              </Button>
              <Slider
                maxValue={max_time}
                minValue={min_time}
                value={data.current_arm_time}
                onChange={(e, value) =>
                  act('set_arm_time', { arm_time: value })
                }
                unit="秒"
                stepPixelSize={window_width / max_time} // width / max_time
              />
            </LabeledList.Item>
            <LabeledList.Item label="范围">
              <Knob
                inline
                animated={false}
                maxValue={max_range}
                minValue={min_range}
                value={data.current_range}
                onChange={(e, value) => act('set_range', { value: value })}
                stepPixelSize={20}
              />
            </LabeledList.Item>
            <LabeledList.Item label="延迟">
              <Knob
                inline
                animated={false}
                maxValue={max_delay}
                minValue={min_delay}
                value={data.current_delay}
                onChange={(e, value) => act('set_delay', { value: value })}
                stepPixelSize={20}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <Button
            fluid
            color={data.armed ? 'red' : 'green'}
            icon={data.armed ? 'exclamation-triangle' : 'bomb'}
            onClick={() => act('set_armed', { armed: !data.armed })}
            tooltip="开始扫描潜在敌人。连接到爆炸性物品时非常危险。"
            tooltipPosition="top"
          >
            {data.armed ? '已布防' : '未布防'}
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
