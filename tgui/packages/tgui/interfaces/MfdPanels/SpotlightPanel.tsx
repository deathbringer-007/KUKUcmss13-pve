import { useBackend } from '../../backend';
import { Box, Stack } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState } from './stateManagers';
import { EquipmentContext, SpotlightSpec } from './types';

const SpotPanel = (props: DropshipEquipment) => {
  const spotData = props.data as SpotlightSpec;
  return (
    <Stack>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
      <Stack.Item>
        <Stack vertical width="300px" align="center">
          <Stack.Item>
            <h3>{props.name}</h3>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
    </Stack>
  );
};

export const SpotlightMfdPanel = (props: MfdProps) => {
  const { act, data } = useBackend<EquipmentContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);
  const spotlight = data.equipment_data.find(
    (x) => x.mount_point === equipmentState,
  );
  const deployLabel =
    (spotlight?.data?.deployed ?? 0) === 1 ? '关闭' : '启用';

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        { children: '设备', onClick: () => setPanelState('equipment') },
      ]}
      leftButtons={[
        {
          children: deployLabel,
          onClick: () =>
            act('deploy-equipment', { equipment_id: spotlight?.mount_point }),
        },
      ]}
      bottomButtons={[
        {
          children: '退出',
          onClick: () => setPanelState(''),
        },
      ]}
    >
      <Box className="NavigationMenu">
        {spotlight && <SpotPanel {...spotlight} />}
      </Box>
    </MfdPanel>
  );
};
