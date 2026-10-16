import { useBackend } from '../backend';
import { Box, Button, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const Disposals = () => {
  const { act, data } = useBackend();

  const { pressure, mode, flush } = data;

  return (
    <Window width={350} height={150}>
      <Window.Content scrollable>
        <Section>
          <Button
            fluid
            icon={flush ? 'trash-arrow-up' : 'trash'}
            onClick={() => act('handle')}
          >
            {flush ? '松开手柄' : '拉下手柄'}
          </Button>
          <Button fluid icon="trash-arrow-up" onClick={() => act('eject')}>
            弹出内容物
          </Button>
          <Box height="5px" />
          <ProgressBar width="100%" value={pressure / 100} color="good">
            <Box>压力：{pressure}%</Box>
          </ProgressBar>
          <Button
            fluid
            icon={mode <= 0 ? 'rotate' : 'power-off'}
            onClick={() => act('pump')}
          >
            {mode <= 0 ? '启动气泵' : '关闭气泵'}
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
