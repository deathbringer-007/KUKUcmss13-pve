import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';

interface CasSimData {
  configuration: any;
  dummy_mode: string;
  worldtime: number;
  nextdetonationtime: number;
  detonation_cooldown: number;
}

export const CasSim = () => {
  const { act, data } = useBackend<CasSimData>();
  const [simulationView, setSimulationView] = useState(false);

  const timeLeft = data.nextdetonationtime - data.worldtime;
  const timeLeftPct = timeLeft / data.detonation_cooldown;

  const canDetonate = timeLeft < 0 && data.configuration && simulationView;

  return (
    <Box className="CasSim">
      <Section title="配置状态">
        {(!!data.configuration && (
          <NoticeBox info>
            配置：执行 {data.configuration}！
          </NoticeBox>
        )) || (
          <NoticeBox danger>尚未载入火力任务配置！</NoticeBox>
        )}
        <NoticeBox info>靶标类型：{data.dummy_mode}</NoticeBox>
        {timeLeft > 0 && (
          <ProgressBar
            width="100%"
            value={timeLeftPct}
            ranges={{
              good: [-Infinity, 0.33],
              average: [0.33, 0.67],
              bad: [0.67, Infinity],
            }}
          >
            <Box textAlign="center">
              控制台处理器还需 {Math.ceil(timeLeft / 10)} 秒冷却！
            </Box>
          </ProgressBar>
        )}
      </Section>
      <Section title="近距空中支援模拟控制">
        <Stack>
          <Stack.Item grow>
            {(!simulationView && (
              <Button
                fluid
                icon="eye"
                color="good"
                onClick={() => {
                  act('start_watching');
                  setSimulationView(true);
                }}
              >
                进入模拟
              </Button>
            )) || (
              <Button
                fluid
                icon="eye-slash"
                color="good"
                onClick={() => {
                  act('stop_watching');
                  setSimulationView(false);
                }}
              >
                退出模拟
              </Button>
            )}
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              icon="repeat"
              color="good"
              onClick={() => act('switchmode')}
            >
              切换靶标类型
            </Button>
          </Stack.Item>
        </Stack>
        <Stack>
          <Stack.Item grow>
            <Button
              disabled={!data.configuration}
              fluid
              icon="sign-in-alt"
              color="good"
              onClick={() => act('switch_firemission')}
            >
              切换火力任务
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button.Confirm
              disabled={!canDetonate}
              fluid
              icon="bomb"
              color="good"
              confirmContent="确认？"
              onClick={() => act('execute_simulated_firemission')}
            >
              执行火力任务？
            </Button.Confirm>
          </Stack.Item>
        </Stack>
        <Stack />
      </Section>
    </Box>
  );
};
