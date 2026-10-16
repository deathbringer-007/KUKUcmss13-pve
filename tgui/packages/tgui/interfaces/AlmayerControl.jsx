import { Fragment } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Flex,
  NoticeBox,
  Section,
} from '../components';
import { Window } from '../layouts';

export const AlmayerControl = (_props) => {
  const { act, data } = useBackend();

  const worldTime = data.worldtime;
  const messages = data.messages;

  const evacstatus = data.evac_status;
  const evacEta = data.evac_eta;

  const AlertLevel = data.alert_level;

  const minimumTimeElapsed = worldTime > data.distresstimelock;

  const canMessage = data.time_message < worldTime; // ship announcement
  const canRequest = // requesting distress beacon
    data.time_request < worldTime && AlertLevel === 2 && minimumTimeElapsed;
  const canEvac = (evacstatus === 0, AlertLevel >= 2); // triggering evac
  const canDestruct =
    data.time_destruct < worldTime && minimumTimeElapsed && AlertLevel === 2;
  const canCentral = data.time_central < worldTime; // messaging HC

  let distress_reason;
  let destruct_reason;
  if (AlertLevel === 3) {
    distress_reason = '正在自毁，信标已停用。';
    destruct_reason = '自毁程序已经启动！';
  } else if (AlertLevel !== 2) {
    distress_reason = '舰船当前未处于紧急状态。';
    destruct_reason = '舰船当前未处于紧急状态。';
  } else if (data.time_request < worldTime) {
    distress_reason =
      '信标正在充能，剩余时间：' +
      Math.ceil((data.time_message - worldTime) / 10) +
      '秒。';
  } else if (data.time_destruct < worldTime) {
    destruct_reason =
      '请求已发送至高级指挥部。再次发送前请等待：' +
      Math.ceil((data.time_destruct - worldTime) / 10) +
      '秒。';
  } else if (!minimumTimeElapsed) {
    distress_reason = '现在还太早，无法启动求救信标。';
    destruct_reason = '现在还太早，无法启动自毁。';
  }

  let alertLevelString;
  let alertLevelColor;
  if (AlertLevel === 3) {
    alertLevelString = '德尔塔';
    alertLevelColor = 'purple';
  }
  if (AlertLevel === 2) {
    alertLevelString = '红色';
    alertLevelColor = 'red';
  }
  if (AlertLevel === 1) {
    alertLevelString = '蓝色';
    alertLevelColor = 'blue';
  }
  if (AlertLevel === 0) {
    alertLevelString = '绿色';
    alertLevelColor = 'green';
  }

  return (
    <Window width={450} height={700}>
      <Window.Content scrollable>
        <Section title="舰船控制">
          <Flex height="100%" direction="column">
            <Flex.Item>
              <Button
                fluid
                color={alertLevelColor}
                icon="triangle-exclamation"
                disabled={AlertLevel === 3}
                onClick={() => act('change_sec_level')}
              >
                更改警戒等级；当前警戒等级：{alertLevelString}。
              </Button>
            </Flex.Item>
            <Flex.Item>
              {!canMessage && (
                <Button color="bad" warning={1} fluid icon="ban">
                  全舰广播正在冷却：{' '}
                  {Math.ceil((data.time_message - worldTime) / 10)} secs
                </Button>
              )}
              {!!canMessage && (
                <Button
                  fluid
                  icon="bullhorn"
                  title="发布全舰广播"
                  onClick={() => act('ship_announce')}
                  disabled={!canMessage}
                >
                  发布全舰广播
                </Button>
              )}
            </Flex.Item>
            <Flex.Item>
              {!canCentral && (
                <Button color="bad" warning={1} fluid icon="ban">
                  量子中继器正在恢复：{' '}
                  {Math.ceil((data.time_message - worldTime) / 10)} secs
                </Button>
              )}
              {!!canCentral && (
                <Button
                  fluid
                  icon="paper-plane"
                  title="向殖民地陆战队高级指挥部发送消息"
                  onClick={() => act('messageUSCM')}
                  disabled={!canCentral}
                >
                  向殖民地陆战队高级指挥部发送消息
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
            <Section title="应急措施">
              {AlertLevel < 2 && (
                <NoticeBox color="bad" warning={1} textAlign="center">
                  舰船必须处于红色警戒才能启动疏散程序。
                </NoticeBox>
              )}
              {evacstatus === 0 && (
                <Flex.Item>
                  <Button.Confirm
                    fluid
                    color="orange"
                    icon="door-open"
                    confirmColor="bad"
                    confirmContent="确认？"
                    confirmIcon="question"
                    onClick={() => act('evacuation_start')}
                    disabled={!canEvac}
                  >
                    启动疏散
                  </Button.Confirm>
                </Flex.Item>
              )}
              {evacstatus === 1 && (
                <Flex.Item>
                  <NoticeBox color="good" info={1} textAlign="center">
                    疏散进行中，逃生舱发射倒计时：{evacEta}。
                  </NoticeBox>
                  <Button.Confirm
                    fluid
                    color="red"
                    icon="ban"
                    confirmColor="bad"
                    confirmContent="确认？"
                    confirmIcon="question"
                    onClick={() => act('evacuation_cancel')}
                  >
                    取消疏散
                  </Button.Confirm>
                </Flex.Item>
              )}
              {evacstatus === 2 && (
                <NoticeBox color="good" info={1} textAlign="center">
                  逃生舱正在发射。
                </NoticeBox>
              )}
              {evacstatus === 3 && (
                <NoticeBox color="good" success={1} textAlign="center">
                  疏散完成。
                </NoticeBox>
              )}
              <Flex.Item>
                {!canDestruct && (
                  <Button
                    disabled={1}
                    tooltip={destruct_reason}
                    fluid
                    icon="ban"
                  >
                    自毁已禁用！
                  </Button>
                )}
                {canDestruct && (
                  <Button.Confirm
                    fluid
                    color="red"
                    icon="explosion"
                    confirmColor="bad"
                    confirmContent="确认启动自毁？"
                    confirmIcon="question"
                    onClick={() => act('destroy')}
                  >
                    请求启动自毁
                  </Button.Confirm>
                )}
              </Flex.Item>
              <Flex.Item>
                {!canRequest && (
                  <Button
                    disabled={1}
                    tooltip={distress_reason}
                    fluid
                    icon="ban"
                  >
                    求救信标已禁用
                  </Button>
                )}
                {canRequest && (
                  <Button.Confirm
                    fluid
                    color="orange"
                    icon="phone-volume"
                    confirmColor="bad"
                    confirmContent="确认？"
                    confirmIcon="question"
                    onClick={() => act('distress')}
                  >
                    发送求救信标
                  </Button.Confirm>
                )}
              </Flex.Item>
            </Section>
          </Flex>
        </Section>
        {messages && (
          <>
            <Divider />
            <Collapsible title="消息">
              <Flex>
                {messages.map((entry) => {
                  return (
                    <Flex.Item key={entry} grow>
                      <Section
                        title={entry.title}
                        buttons={
                          <Button
                            color="red"
                            icon="trash"
                            onClick={() =>
                              act('delmessage', { number: entry.number })
                            }
                          >
                            删除消息
                          </Button>
                        }
                      >
                        <Box>{entry.text}</Box>
                      </Section>
                    </Flex.Item>
                  );
                })}
              </Flex>
            </Collapsible>
          </>
        )}
      </Window.Content>
    </Window>
  );
};
