import { useBackend } from '../backend';
import { Button, Dimmer, Icon, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const NuclearBomb = () => {
  const { act, data } = useBackend();

  const cantNuke = (!data.anchor, !!data.safety, !data.decryption_complete);
  const cantDecrypt = (!data.anchor, data.decryption_complete);

  return (
    <Window theme="retro" width={350} height={250}>
      <Window.Content scrollable>
        <Section>
          <Stack height="100%" direction="column">
            <Stack.Item>
              <NoticeBox textAlign="center">
                {data.decryption_complete
                  ? '解密完成。'
                  : `解密剩余时间：${data.decryption_time}分钟`}
              </NoticeBox>
            </Stack.Item>
            <Stack.Item>
              <NoticeBox danger textAlign="center">
                {data.timing
                  ? `引爆倒计时：${data.timeleft}`
                  : '当前未启用。'}
              </NoticeBox>
            </Stack.Item>
            <Stack.Item>
              {(!data.safety && (
                <Button fluid icon="lock" onClick={() => act('toggleSafety')}>
                  开启保险
                </Button>
              )) || (
                <Button.Confirm
                  fluid
                  icon="exclamation-triangle"
                  onClick={() => act('toggleSafety')}
                >
                  关闭保险
                </Button.Confirm>
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.command_lockout && (
                <Button
                  fluid
                  icon="lock"
                  onClick={() => act('toggleCommandLockout')}
                >
                  开启指挥权限锁
                </Button>
              )) || (
                <Button.Confirm
                  fluid
                  icon="exclamation-triangle"
                  onClick={() => act('toggleCommandLockout')}
                >
                  关闭指挥权限锁
                </Button.Confirm>
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.anchor && (
                <Button fluid icon="lock" onClick={() => act('toggleAnchor')}>
                  启用锚定
                </Button>
              )) || (
                <Button.Confirm
                  fluid
                  icon="lock-open"
                  onClick={() => act('toggleAnchor')}
                >
                  解除锚定
                </Button.Confirm>
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.decrypting && (
                <Button.Confirm
                  fluid
                  icon="exclamation-triangle"
                  color="green"
                  disabled={cantDecrypt}
                  onClick={() => act('toggleEncryption')}
                >
                  开始解密
                </Button.Confirm>
              )) || (
                <Button.Confirm
                  fluid
                  icon="power-off"
                  onClick={() => act('toggleEncryption')}
                >
                  停止解密
                </Button.Confirm>
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.timing && (
                <Button.Confirm
                  fluid
                  icon="exclamation-triangle"
                  color="red"
                  disabled={cantNuke}
                  onClick={() => act('toggleNuke')}
                >
                  启动核弹
                </Button.Confirm>
              )) || (
                <Button.Confirm
                  fluid
                  icon="power-off"
                  onClick={() => act('toggleNuke')}
                >
                  停用核弹
                </Button.Confirm>
              )}
            </Stack.Item>
          </Stack>
          {!data.allowed && (
            <Dimmer fontSize="32px">
              <Icon name="exclamation-triangle" />
              {' 拒绝访问！'}
            </Dimmer>
          )}
          {!!data.being_used && (
            <Dimmer fontSize="32px">
              <Icon name="cog" spin />
              {' 处理中……'}
            </Dimmer>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
