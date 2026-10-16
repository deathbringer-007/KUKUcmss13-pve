import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Dropdown,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const TeleporterConsole = () => {
  const { act, data } = useBackend();

  const timeLeft = data.next_teleport_time - data.worldtime;
  const timeLeftPct = timeLeft / data.cooldown_length;

  const cantFire =
    timeLeft > 0 ||
    !data.source ||
    !data.destination ||
    data.source === data.destination;

  return (
    <Window width={500} height={380} theme="weyland">
      <Window.Content scrollable>
        <NoticeBox textAlign="center">
          此传送器正在使用{data.name}网络。
        </NoticeBox>
        <Section title="传送器控制">
          {!data.source ? (
            <NoticeBox info textAlign="center">
              未选择起点！
            </NoticeBox>
          ) : null}
          {!data.destination ? (
            <NoticeBox danger textAlign="center">
              未选择终点！
            </NoticeBox>
          ) : null}
          {data.source === data.destination ? (
            <NoticeBox danger textAlign="center">
              起点和终点不能相同！
            </NoticeBox>
          ) : null}
          {(timeLeft < 0 && (
            <NoticeBox success={1} textAlign="center">
              电容器已充满！
            </NoticeBox>
          )) || (
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
                电容器将在{Math.ceil(timeLeft / 10)}秒后充满。
              </Box>
            </ProgressBar>
          )}
          <Box height="10px" />
          <LabeledList>
            <LabeledList.Item label="起点" verticalAlign="top">
              <Dropdown
                displayText={data.source ? data.source : '选择起点'}
                icon="right-from-bracket"
                width="350px"
                height="25px"
                selected={data.source}
                options={Object.keys(data.locations)}
                onSelected={(value) => {
                  act('set_source', { location: value });
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item label="终点" verticalAlign="top">
              <Dropdown
                displayText={
                  data.destination ? data.destination : '选择终点'
                }
                icon="right-to-bracket"
                width="350px"
                height="25px"
                selected={data.destination}
                options={Object.keys(data.locations)}
                onSelected={(value) => {
                  act('set_dest', { location: value });
                }}
              />
            </LabeledList.Item>
          </LabeledList>
          <Box height="10px" />
          <Button.Confirm
            fontSize="20px"
            textAlign="center"
            disabled={!!cantFire}
            fluid
            icon="plane-departure"
            onClick={() => act('teleport')}
          >
            启动传送程序
          </Button.Confirm>
        </Section>
        {!!data.teleporting && (
          <Dimmer fontSize="32px">
            <Icon name="cog" spin />
            {' 正在传送。'}
          </Dimmer>
        )}
      </Window.Content>
    </Window>
  );
};
