import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Dimmer,
  Divider,
  Icon,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const OrbitalCannonConsole = () => {
  const { act, data } = useBackend();

  const timeLeft = data.nextchambertime - data.worldtime;
  const timeLeftPct = timeLeft / data.chamber_cooldown;

  const cantChamber = timeLeft > 0 || !data.loadedtray;

  const fullyLoaded = !!data.warhead && data.fuel > 0;

  const fuelLoadedPct = data.fuel / 6;

  return (
    <Window width={500} height={500}>
      <Window.Content scrollable>
        <Section title="战斗部状态">
          {(!!data.warhead && (
            <NoticeBox info>已装载{data.warhead}！</NoticeBox>
          )) || <NoticeBox danger>未装载战斗部！</NoticeBox>}
        </Section>
        <Section title="燃料状态">
          <Box textAlign="center">
            <ProgressBar
              width="100%"
              value={fuelLoadedPct}
              ranges={{
                bad: [-Infinity, 0.51],
                good: [0.51, Infinity],
              }}
            >
              <Box textAlign="center">已装载{data.fuel}块燃料</Box>
            </ProgressBar>
          </Box>
          <Divider />
          <Collapsible title="燃料需求">
            <Box>
              战斗部燃料需求：
              <br />
              轨道高爆战斗部：
              <b> {data.hefuel}块固体燃料。</b>
              <br />
              轨道燃烧战斗部：
              <b> {data.incfuel}块固体燃料。</b>
              <br />
              轨道集束战斗部：
              <b> {data.clusterfuel}块固体燃料。</b>
            </Box>
          </Collapsible>
        </Section>
        <Section title="装填盘状态">
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
                距离可将炮弹装入炮膛还有{Math.ceil(timeLeft / 10)}秒！
              </Box>
            </ProgressBar>
          )}
          {(!data.loadedtray && (
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={!fullyLoaded}
              icon="truck-loading"
              color="good"
              onClick={() => act('load_tray')}
            >
              装载装填盘
            </Button>
          )) || (
            <Box>
              {(!data.chamberedtray && (
                <Button
                  fontSize="20px"
                  textAlign="center"
                  fluid
                  icon="sign-out-alt"
                  color="good"
                  onClick={() => act('unload_tray')}
                >
                  卸下装填盘
                </Button>
              )) || (
                <NoticeBox fontSize="15px" textAlign="center" fluid danger>
                  装填盘已送入炮膛，无法退出。
                </NoticeBox>
              )}
            </Box>
          )}
          {!data.chamberedtray && !!data.loadedtray && (
            <Button.Confirm
              fontSize="20px"
              textAlign="center"
              disabled={!!cantChamber || !fullyLoaded}
              fluid
              icon="sign-in-alt"
              color="good"
              confirmContent="装填盘入膛后无法退出。确定吗？"
              onClick={() => act('chamber_tray')}
            >
              将装填盘送入炮膛
            </Button.Confirm>
          )}
        </Section>
        {(!data.linkedtray || !data.linkedcannon || !!data.disabled) && (
          <Dimmer fontSize="32px">
            <Icon name="exclamation-triangle" />
            {!data.linkedtray && ' 控制台未连接装填盘！'}
            {!data.linkedcannon && ' 控制台未连接舰炮！'}
            {!!data.disabled && '  舰炮已停用！'}
          </Dimmer>
        )}
      </Window.Content>
    </Window>
  );
};
