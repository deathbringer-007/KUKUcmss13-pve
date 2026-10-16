import { useBackend } from '../backend';
import { Button, Flex, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const CommandTablet = () => {
  const { act, data } = useBackend();

  const evacstatus = data.evac_status;

  const AlertLevel = data.alert_level;

  const minimumTimeElapsed = data.worldtime > data.distresstimelock;

  const canAnnounce = data.endtime < data.worldtime;

  const distressCooldown = data.worldtime < data.distresstime;

  const roundends = data.roundends;

  const canEvac = (evacstatus === 0, AlertLevel >= 2);

  const canDistress =
    AlertLevel === 2 && !distressCooldown && minimumTimeElapsed;

  let distress_reason;
  if (AlertLevel === 3) {
    distress_reason = '正在执行自毁程序，信标已禁用。';
  } else if (AlertLevel !== 2) {
    distress_reason = '舰船尚未处于紧急状态。';
  } else if (distressCooldown) {
    distress_reason = '信标正在充能。';
  } else if (!minimumTimeElapsed) {
    distress_reason = "现在发射求救信标还为时过早。";
  }

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        <Section title="指挥">
          <Flex height="100%" direction="column">
            <Flex.Item>
              {!canAnnounce && (
                <Button color="bad" warning={1} fluid icon="ban">
                  公告冷却中：{' '}
                  {Math.ceil((data.endtime - data.worldtime) / 10)} 秒
                </Button>
              )}
              {!!canAnnounce && (
                <Button
                  fluid
                  icon="bullhorn"
                  title="发布公告"
                  onClick={() => act('announce')}
                  disabled={!canAnnounce}
                >
                  发布公告
                </Button>
              )}
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                icon="medal"
                title="授予勋章"
                onClick={() => act('award')}
              >
                授予勋章
              </Button>
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                icon="globe-africa"
                title="查看战术地图"
                onClick={() => act('mapview')}
              >
                查看战术地图
              </Button>
            </Flex.Item>
            {data.faction === 'USCM' && (
              <Section title="疏散">
                {AlertLevel < 2 && (
                  <NoticeBox color="bad" warning={1} textAlign="center">
                    舰船必须处于红色警报状态才能启动疏散程序。
                  </NoticeBox>
                )}
                <Flex.Item>
                  {!canDistress && (
                    <Button
                      disabled={1}
                      tooltip={distress_reason}
                      fluid
                      icon="ban"
                    >
                      {'求救信标已禁用'}
                    </Button>
                  )}
                  {canDistress && (
                    <Button.Confirm
                      fluid
                      color="orange"
                      icon="phone-volume"
                      confirmColor="bad"
                      confirmContent="确定？"
                      confirmIcon="question"
                      onClick={() => act('distress')}
                    >
                      {'发送求救信标'}
                    </Button.Confirm>
                  )}
                </Flex.Item>
                {evacstatus === 0 && (
                  <Flex.Item>
                    <Button.Confirm
                      fluid
                      color="orange"
                      icon="door-open"
                      confirmColor="bad"
                      confirmContent="确定？"
                      confirmIcon="question"
                      onClick={() => act('evacuation_start')}
                      disabled={!canEvac}
                    >
                      {'启动疏散'}
                    </Button.Confirm>
                  </Flex.Item>
                )}
                {evacstatus === 1 && (
                  <NoticeBox color="good" info={1} textAlign="center">
                    正在疏散。
                  </NoticeBox>
                )}
                {evacstatus === 2 && (
                  <NoticeBox color="good" info={1} textAlign="center">
                    逃生舱正在发射。
                  </NoticeBox>
                )}
                {evacstatus === 3 && (
                  <NoticeBox color="good" success={1} textAlign="center">
                    疏散已完成。
                  </NoticeBox>
                )}
              </Section>
            )}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
