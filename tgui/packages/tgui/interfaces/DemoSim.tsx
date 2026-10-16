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
import { Window } from '../layouts';

interface DemoSimData {
  configuration: any;
  dummy_mode: string;
  worldtime: number;
  nextdetonationtime: number;
  detonation_cooldown: number;
}

export const DemoSim = () => {
  const { act, data } = useBackend<DemoSimData>();
  const [simulationView, setSimulationView] = useState(false);

  const timeLeft = data.nextdetonationtime - data.worldtime;
  const timeLeftPct = timeLeft / data.detonation_cooldown;

  const canDetonate = timeLeft < 0 && data.configuration && simulationView;

  return (
    <Window width={550} height={300}>
      <Window.Content scrollable>
        <Section title="配置状态">
          {(!!data.configuration && (
            <NoticeBox info fontSize="15px">
              配置：引爆 {data.configuration}！
            </NoticeBox>
          )) || (
            <NoticeBox danger fontSize="15px">
              尚未载入爆炸物配置！
            </NoticeBox>
          )}
          <NoticeBox info fontSize="15px">
            靶标类型：{data.dummy_mode}
          </NoticeBox>
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
              <Box textAlign="center" fontSize="15px">
                控制台处理器还需 {Math.ceil(timeLeft / 10)} 秒冷却！
              </Box>
            </ProgressBar>
          )}
        </Section>
        <Section title="引爆控制">
          <Stack>
            <Stack.Item grow>
              {(!simulationView && (
                <Button
                  fontSize="16px"
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
                  fontSize="16px"
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
                fontSize="16px"
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
                fontSize="16px"
                disabled={!data.configuration}
                fluid
                icon="sign-in-alt"
                color="good"
                onClick={() => act('eject')}
              >
                弹出爆炸物
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button.Confirm
                fontSize="16px"
                disabled={!canDetonate}
                fluid
                icon="bomb"
                color="good"
                confirmContent="确认？"
                onClick={() => act('detonate')}
              >
                引爆爆炸物
              </Button.Confirm>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
