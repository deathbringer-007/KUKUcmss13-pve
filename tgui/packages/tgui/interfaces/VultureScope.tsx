import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type ScopeData = {
  offset_x: number;
  offset_y: number;
  valid_offset_dirs: Array<String>;
  valid_adjust_dirs: Array<String>;
  scope_cooldown: BooleanLike;
  breath_cooldown: BooleanLike;
  breath_recharge: number;
  current_scope_drift: number;
  time_to_fire_remaining: number;
};

enum Direction {
  North = 1,
  NorthEast = 5,
  East = 4,
  SouthEast = 6,
  South = 2,
  SouthWest = 10,
  West = 8,
  NorthWest = 9,
}

const DirectionAbbreviation: Record<Direction, string> = {
  [Direction.North]: '北',
  [Direction.NorthEast]: '东北',
  [Direction.East]: '东',
  [Direction.SouthEast]: '东南',
  [Direction.South]: '南',
  [Direction.SouthWest]: '西南',
  [Direction.West]: '西',
  [Direction.NorthWest]: '西北',
};

const OffsetAdjuster = (props) => {
  const { act, data } = useBackend<ScopeData>();
  return (
    <div
      style={{
        flex: '1',
        marginRight: '20px',
      }}
    >
      <Section title="偏移">
        <Box>
          <Stack vertical>
            <Flex>
              <OffsetDirection dir={Direction.NorthWest} />
              <OffsetDirection dir={Direction.North} />
              <OffsetDirection dir={Direction.NorthEast} />
            </Flex>
            <Flex>
              <OffsetDirection dir={Direction.West} />
              <Flex.Item grow={1} basis={0}>
                <Button
                  disabled
                  textAlign="center"
                  color="yellow"
                  lineHeight={3}
                  m={-0.2}
                  fluid
                >
                  <Icon name="arrows-alt" size={1.5} m="0%" />
                </Button>
              </Flex.Item>
              <OffsetDirection dir={Direction.East} />
            </Flex>
            <Flex>
              <OffsetDirection dir={Direction.SouthWest} />
              <OffsetDirection dir={Direction.South} />
              <OffsetDirection dir={Direction.SouthEast} />
            </Flex>
          </Stack>
        </Box>
      </Section>
    </div>
  );
};

const OffsetDirection = (props) => {
  const { dir } = props;
  const { data, act } = useBackend<ScopeData>();
  return (
    <Flex.Item grow={1} basis={0}>
      <Button
        tooltip={`向${DirectionAbbreviation[dir]}调整瞄准镜偏移`}
        disabled={
          data.valid_offset_dirs.indexOf(dir) === -1 || data.scope_cooldown
        }
        textAlign="center"
        onClick={() => act('adjust_dir', { offset_dir: dir })}
        color="yellow"
        lineHeight={3}
        m={-0.2}
        fluid
      >
        {DirectionAbbreviation[dir]}
      </Button>
    </Flex.Item>
  );
};

const PositionAdjuster = (props) => {
  const { act, data } = useBackend<ScopeData>();
  return (
    <div style={{ flex: '1' }}>
      <Section title="位置" textAlign="right">
        <Box>
          <Stack vertical>
            <Flex>
              <ScopePosition dir={Direction.NorthWest} />
              <ScopePosition dir={Direction.North} />
              <ScopePosition dir={Direction.NorthEast} />
            </Flex>
            <Flex>
              <ScopePosition dir={Direction.West} />
              <Flex.Item grow={1} basis={0}>
                <Button
                  disabled
                  textAlign="center"
                  color="yellow"
                  lineHeight={3}
                  m={-0.2}
                  fluid
                >
                  <Icon name="arrows-alt" size={1.5} m="0%" />
                </Button>
              </Flex.Item>
              <ScopePosition dir={Direction.East} />
            </Flex>
            <Flex>
              <ScopePosition dir={Direction.SouthWest} />
              <ScopePosition dir={Direction.South} />
              <ScopePosition dir={Direction.SouthEast} />
            </Flex>
          </Stack>
        </Box>
      </Section>
    </div>
  );
};

const ScopePosition = (props) => {
  const { dir } = props;
  const { data, act } = useBackend<ScopeData>();
  return (
    <Flex.Item grow={1} basis={0}>
      <Button
        tooltip={`向${DirectionAbbreviation[dir]}调整瞄准镜位置`}
        disabled={
          data.valid_adjust_dirs.indexOf(dir) === -1 || data.scope_cooldown
        }
        textAlign="center"
        onClick={() => act('adjust_position', { position_dir: dir })}
        color="red"
        lineHeight={3}
        m={-0.2}
        fluid
      >
        {DirectionAbbreviation[dir]}
      </Button>
    </Flex.Item>
  );
};

const SecondarySection = (props) => {
  const { data, act } = useBackend<ScopeData>();
  return (
    <Section title="呼吸与数据" textAlign="center">
      <Flex.Item grow={1} basis={0}>
        <Button
          tooltip="短时间内控制呼吸，消除瞄准镜晃动。"
          disabled={data.breath_cooldown}
          textAlign="center"
          onClick={() => act('hold_breath')}
          color="green"
          lineHeight={3}
          m={-0.2}
          fluid
        >
          控制呼吸
        </Button>
      </Flex.Item>
      <div style={{ padding: '6px' }} />
      <Flex.Item>
        <ProgressBar
          minValue={0}
          maxValue={1}
          value={data.breath_recharge}
          ranges={{
            good: [0.8, Infinity],
            average: [0.5, 0.8],
            bad: [-Infinity, 0.5],
          }}
        >
          呼吸恢复
        </ProgressBar>
      </Flex.Item>
      <Flex.Item>
        <div style={{ paddingTop: '8px', paddingBottom: '8px' }}>
          <ProgressBar
            minValue={0}
            maxValue={100}
            value={data.current_scope_drift}
            ranges={{
              good: [-Infinity, 0],
              average: [1, 50],
              bad: [51, Infinity],
            }}
          >
            瞄准镜晃动：{data.current_scope_drift}%
          </ProgressBar>
        </div>
      </Flex.Item>
      <Flex.Item>
        <ProgressBar
          minValue={0}
          maxValue={1}
          value={data.time_to_fire_remaining}
          ranges={{
            good: [0.8, Infinity],
            average: [0.5, 0.8],
            bad: [-Infinity, 0.5],
          }}
        >
          射击就绪进度
        </ProgressBar>
      </Flex.Item>
    </Section>
  );
};

export const VultureScope = (props) => {
  const { act, data } = useBackend<ScopeData>();
  return (
    <Window title="瞄准镜设置" width={325} height={400}>
      <Window.Content>
        <Section title="瞄准镜调整">
          <div style={{ display: 'flex' }}>
            <OffsetAdjuster />
            <PositionAdjuster />
          </div>
        </Section>
        <SecondarySection />
      </Window.Content>
    </Window>
  );
};
