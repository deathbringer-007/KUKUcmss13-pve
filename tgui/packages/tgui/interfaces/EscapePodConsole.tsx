import { useBackend } from '../backend';
import { Box, Button, Flex, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

interface EscapePodProps {
  docking_status: number;
  door_lock: 0 | 1;
  door_state: 0 | 1;
  can_delay: 0 | 1;
  launch_without_evac: number;
}

export const EscapePodConsole = () => {
  const { act, data } = useBackend<EscapePodProps>();

  let statusMessage = '错误';
  let buttonColor = 'bad';
  let delayed = 0;
  let operable = 0;

  switch (data.docking_status) {
    case 4:
      statusMessage = '未启动撤离';
      buttonColor = 'neutral';
      if (data.launch_without_evac) {
        operable = 1;
      }
      break;
    case 5:
      statusMessage = '系统离线';
      break;
    case 6:
      statusMessage = '待命';
      buttonColor = 'good';
      operable = 1;
      break;
    case 7:
      statusMessage = '已延迟';
      buttonColor = 'yellow';
      delayed = 1;
      operable = 1;
      break;
    case 8:
      statusMessage = '正在发射';
      buttonColor = 'grey';
      break;
    case 9:
      statusMessage = '航行中';
      buttonColor = 'good';
      break;
  }

  let doorStatus = '错误';
  let doorColor = 'bad';

  if (!data.door_state) {
    doorStatus = '开启';
    doorColor = 'yellow';
  } else {
    if (data.door_lock) {
      doorStatus = '已锁定';
      doorColor = 'green';
    } else {
      doorStatus = '未锁定';
      doorColor = 'yellow';
    }
  }

  return (
    <Window width={400} height={270}>
      <Window.Content scrollable>
        <Section title="信息显示">
          <Flex height="100%" direction="column">
            <Flex.Item>
              <NoticeBox textAlign="center" color={buttonColor}>
                逃生舱状态： {statusMessage}
              </NoticeBox>
            </Flex.Item>
            <Flex.Item>
              <NoticeBox textAlign="center" color={doorColor}>
                对接舱门： {doorStatus}
              </NoticeBox>
            </Flex.Item>
          </Flex>
        </Section>
        <Section title="逃生舱控制">
          <Flex direction="column">
            <Flex.Item>
              <Button
                color="red"
                fluid
                icon={data.door_state ? 'lock-open' : 'lock'}
                disabled={!operable}
                onClick={() => act('lock_door')}
              >
                {data.door_state ? '解锁舱门' : '锁定舱门'}
              </Button>
              <Box width="2px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="plane-departure"
                color="red"
                fluid
                disabled={!operable || delayed}
                onClick={() => act('force_launch')}
              >
                手动弹射
              </Button>
              <Box width="2px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="clock"
                color="yellow"
                fluid
                disabled={!data.can_delay}
                onClick={() => act('delay_launch')}
              >
                {delayed ? '取消发射延迟' : '延迟发射'}
              </Button>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
