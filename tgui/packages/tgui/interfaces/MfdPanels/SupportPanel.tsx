import { useBackend } from '../../backend';
import { Box, Stack } from '../../components';
import { FultonMfdPanel } from './FultonPanel';
import { MedevacMfdPanel } from './MedevacPanel';
import { MgMfdPanel } from './MGPanel';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { ParadropMfdPanel } from './ParadropPanel';
import { SentryMfdPanel } from './SentryPanel';
import { SpotlightMfdPanel } from './SpotlightPanel';
import { mfdState, useEquipmentState } from './stateManagers';
import { EquipmentContext } from './types';

export const SupportMfdPanel = (props: MfdProps) => {
  const { equipmentState } = useEquipmentState(props.panelStateId);

  const { setPanelState } = mfdState(props.panelStateId);

  const { data } = useBackend<EquipmentContext>();
  const result = data.equipment_data.find(
    (x) => x.mount_point === equipmentState,
  );
  if (result?.shorthand === 'Medevac') {
    return <MedevacMfdPanel panelStateId={props.panelStateId} />;
  }
  if (result?.shorthand === 'Fulton') {
    return <FultonMfdPanel panelStateId={props.panelStateId} />;
  }
  if (result?.shorthand === 'Sentry') {
    return <SentryMfdPanel panelStateId={props.panelStateId} />;
  }
  if (result?.shorthand === 'PDS') {
    return <ParadropMfdPanel panelStateId={props.panelStateId} />;
  }
  if (result?.shorthand === 'MG') {
    return <MgMfdPanel panelStateId={props.panelStateId} />;
  }
  if (result?.shorthand === 'Spotlight') {
    return <SpotlightMfdPanel panelStateId={props.panelStateId} />;
  }
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        { children: '设备', onClick: () => setPanelState('equipment') },
      ]}
      bottomButtons={[
        {
          children: '退出',
          onClick: () => setPanelState(''),
        },
      ]}
    >
      <Box className="NavigationMenu">
        <Stack align="center" vertical>
          <Stack.Item>
            <h3>未找到组件：{result?.shorthand}</h3>
          </Stack.Item>
          <Stack.Item>
            <h3>这是经过授权的设备吗？</h3>
          </Stack.Item>
          <Stack.Item width="300px">
            <h3>
              如需了解更多升级方案，请联系当地维兰德-汤谷代表。
            </h3>
          </Stack.Item>
        </Stack>
      </Box>
    </MfdPanel>
  );
};
