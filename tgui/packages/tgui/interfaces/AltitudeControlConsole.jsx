import { useBackend } from '../backend';
import { Box, Button, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { createLogger } from '../logging';
export const AltitudeControlConsole = () => {
  const { act, data } = useBackend();
  const logger = createLogger('Debug');
  logger.warn(data);
  return (
    <Window width={455} height={275}>
      <Window.Content scrollable>
        <Section title="引擎温度">
          <Box textAlign="center">
            <ProgressBar
              width="100%"
              minValue={0}
              maxValue={100}
              value={data.temp}
              ranges={{
                good: [-Infinity, 50],
                bad: [51, Infinity],
              }}
            >
              <Box textAlign="center">已达过热阈值的 {data.temp}%</Box>
            </ProgressBar>
          </Box>
        </Section>
        <Section title="高度控制">
          {
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={data.alt === 0.5}
              onClick={() => act('low_alt')}
            >
              设为低空
            </Button>
          }
          {
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={data.alt === 1}
              onClick={() => act('med_alt')}
            >
              设为中空
            </Button>
          }
          {
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={data.alt === 1.5}
              onClick={() => act('high_alt')}
            >
              设为高空
            </Button>
          }
        </Section>
      </Window.Content>
    </Window>
  );
};
