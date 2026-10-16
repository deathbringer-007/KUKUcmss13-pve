import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Divider,
  Flex,
  Icon,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export interface DockingPort {
  id: string;
  name: string;
  available: 0 | 1;
  error: string | null;
}

export interface NavigationProps {
  destinations: DockingPort[];
  doors_locked?: boolean;
  shuttle_mode: string;
  target_destination?: string;
  flight_time: number;
  max_flight_duration: number;
  max_refuel_duration: number;
  max_engine_start_duration: number;
  max_pre_arrival_duration: number;
  must_launch_home: boolean;
  spooling: boolean;
  mission_accomplished: boolean;
  is_disabled: 0 | 1;
  locked_down: 0 | 1;
}

export const CancelLaunchButton = () => {
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    'target_site',
    undefined,
  );
  return (
    <Button
      icon="ban"
      disabled={siteselection === undefined}
      onClick={() => setSiteSelection(undefined)}
    >
      取消
    </Button>
  );
};

export const LaunchButton = () => {
  const { act } = useBackend<NavigationProps>();
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    'target_site',
    undefined,
  );
  return (
    <Button
      icon="rocket"
      disabled={siteselection === undefined}
      onClick={() => {
        act('move', { target: siteselection });
        setSiteSelection(undefined);
      }}
    >
      起飞
    </Button>
  );
};

export const DestionationSelection = () => {
  const { data, act } = useBackend<NavigationProps>();
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    'target_site',
    undefined,
  );
  return (
    <Section title="选择目的地">
      <Stack fill justify="space-evenly">
        <Stack.Item align="center">
          <CancelLaunchButton />
        </Stack.Item>
        <Stack.Item>
          <Divider vertical />
        </Stack.Item>
        <Stack.Item align="center">
          <LaunchButton />
        </Stack.Item>
      </Stack>
      <Divider />
      <Stack vertical className="DestinationSelector">
        {data.destinations
          .filter((x) => x.available === 1)
          .map((x) => (
            <Stack.Item key={x.id}>
              <Flex align="center">
                {siteselection === x.id && (
                  <>
                    <Flex.Item>
                      <Icon name="play" />
                    </Flex.Item>
                    <Flex.Item>
                      <Box width={1} />
                    </Flex.Item>
                  </>
                )}
                <Flex.Item grow={1}>
                  <Button
                    disabled={x.available === 0}
                    onClick={() => {
                      setSiteSelection(x.id);
                      act('button-push');
                    }}
                  >
                    {x.name}
                  </Button>
                </Flex.Item>
              </Flex>
            </Stack.Item>
          ))}
      </Stack>
    </Section>
  );
};

export const ShuttleRecharge = () => {
  const { data } = useBackend<NavigationProps>();
  return (
    <Section m="0" title="正在补充燃料">
      <div className="LaunchCountdown">
        <Stack vertical>
          <Stack.Item>
            <span>
              距离准备就绪还有<u>T-{data.flight_time}秒</u>。
            </span>
          </Stack.Item>
          <Stack.Item>
            <ProgressBar
              maxValue={data.max_refuel_duration}
              value={data.flight_time}
            >
              T-{data.flight_time}秒
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

export const LaunchCountdown = () => {
  const { data } = useBackend<NavigationProps>();
  return (
    <Section m="0" title="正在起飞">
      <div className="LaunchCountdown">
        <Stack vertical>
          <Stack.Item>
            <span>
              将在<u>T-{data.flight_time}秒</u>后起飞，前往
              {data.target_destination}。
            </span>
          </Stack.Item>
          <Stack.Item>
            <ProgressBar
              maxValue={data.max_engine_start_duration}
              value={data.flight_time}
            >
              T-{data.flight_time}秒
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

export const InFlightCountdown = () => {
  const { data, act } = useBackend<NavigationProps>();
  return (
    <Section
      title={`航行中：${data.target_destination}`}
      m="0"
      buttons={
        data.target_destination === 'Flyby' && (
          <Button onClick={() => act('cancel-flyby')}>取消</Button>
        )
      }
    >
      <div className="InFlightCountdown">
        <Stack vertical>
          <Stack.Item>
            <span>
              距离抵达目的地还有<u>T-{data.flight_time}秒</u>。
            </span>
          </Stack.Item>
          <Stack.Item>
            <ProgressBar
              maxValue={data.max_flight_duration}
              value={data.flight_time}
            >
              T-{data.flight_time}秒
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

const DoorControls = () => {
  const { data, act } = useBackend<NavigationProps>();
  const in_flight = data.shuttle_mode === 'called';
  const disable_door_controls = in_flight;
  const disable_normal_control = data.locked_down === 1;
  return (
    <Section
      title="舱门控制"
      buttons={
        <>
          {data.locked_down === 0 && (
            <Button
              disabled={disable_door_controls}
              onClick={() => act('lockdown')}
              icon="triangle-exclamation"
            >
              封锁
            </Button>
          )}
          {data.locked_down === 1 && (
            <Button
              disabled={disable_door_controls}
              onClick={() => act('unlock')}
              icon="triangle-exclamation"
            >
              解除封锁
            </Button>
          )}
        </>
      }
    >
      <Stack justify="space-evenly" align="center" className="DoorControlStack">
        <Stack.Item grow>
          <Button
            disabled={disable_normal_control || disable_door_controls}
            onClick={() => act('open')}
            icon="door-open"
            width="100%"
            textAlign="center"
          >
            强制开启
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          <Button
            disabled={disable_normal_control || disable_door_controls}
            onClick={() => act('close')}
            icon="door-closed"
            width="100%"
            textAlign="center"
          >
            强制关闭
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const DisabledScreen = (props) => {
  const { data } = useBackend<NavigationProps>();

  const disabled_text = data.mission_accomplished
    ? '自动导航程序已完成，已返回基地。穿梭机已停用。'
    : '穿梭机发生故障，请联系附近的系统管理员处理。';

  return (
    <Box className="DisabledScreen">
      <div>
        <span>{disabled_text}</span>
      </div>
    </Box>
  );
};

const LaunchHome = (props) => {
  const { data, act } = useBackend<NavigationProps>();

  return (
    <Section title="已启用自动返航" className="DestinationSelector">
      <Button.Confirm
        fluid
        confirmContent={'已启用单程导航，确认返航？'}
        onClick={() => act('launch_home')}
      >
        返回基地
      </Button.Confirm>
    </Section>
  );
};

const SpoolingDimmer = (props) => {
  const { data, act } = useBackend<NavigationProps>();

  return (
    <Dimmer>
      <Stack>
        <Stack.Item>
          <Box>引擎正在升速……</Box>
        </Stack.Item>
        <Stack.Item>
          <Icon name={'spinner'} spin />
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

const DestinationOptions = (props) => {
  const { data, act } = useBackend<NavigationProps>();

  if (data.must_launch_home) {
    return (
      <>
        <LaunchHome />
        <DestionationSelection />
      </>
    );
  } else {
    return <DestionationSelection />;
  }
};

const RenderScreen = (props) => {
  const { data } = useBackend<NavigationProps>();
  return (
    <>
      {!!data.spooling && <SpoolingDimmer />}
      {data.shuttle_mode === 'idle' && <DestinationOptions />}
      {data.shuttle_mode === 'igniting' && <LaunchCountdown />}
      {data.shuttle_mode === 'recharging' && <ShuttleRecharge />}
      {data.shuttle_mode === 'called' && <InFlightCountdown />}
      <DoorControls />
    </>
  );
};

export const NavigationShuttle = (props) => {
  const { data } = useBackend<NavigationProps>();
  return (
    <Window theme="crtgreen" height={505} width={700}>
      <Window.Content className="NavigationMenu">
        {data.is_disabled === 1 && <DisabledScreen />}
        {data.is_disabled === 0 && <RenderScreen />}
      </Window.Content>
    </Window>
  );
};
