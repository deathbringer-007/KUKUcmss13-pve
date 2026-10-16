import { useBackend } from '../backend';
import { Button, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const SelfDestructConsole = (props) => {
  const { act, data } = useBackend();
  const { dest_status } = data;

  let statusMessage = '错误！';
  let statusColor = 'bad';

  switch (dest_status) {
    case 0:
      statusMessage = '未启用。';
      statusColor = 'blue';
      break;
    case 1:
      statusMessage = '等待输入。';
      statusColor = 'yellow';
      break;
    case 2:
      statusMessage = '已就绪！';
      statusColor = 'green';
      break;
  }

  return (
    <Window width={300} height={170}>
      <Window.Content>
        <Section>
          <NoticeBox textAlign="center" color={statusColor}>
            自毁系统状态： {statusMessage}
          </NoticeBox>
          {dest_status === 1 && (
            <Button.Confirm
              fluid
              color="average"
              textAlign="center"
              icon="power-off"
              onClick={() => act('dest_start')}
            >
              启动系统
            </Button.Confirm>
          )}
          {dest_status === 2 && (
            <>
              <Button.Confirm
                fluid
                color="red"
                textAlign="center"
                icon="explosion"
                onClick={() => act('dest_trigger')}
              >
                引爆
              </Button.Confirm>
              <Button.Confirm
                fluid
                color="yellow"
                textAlign="center"
                icon="ban"
                onClick={() => act('dest_cancel')}
              >
                取消
              </Button.Confirm>
            </>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
