import { useBackend } from '../../backend';
import { Box, Stack } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState } from './stateManagers';
import { EquipmentContext, MGSpec } from './types';

const MgPanel = (props: DropshipEquipment) => {
  const mgData = props.data as MGSpec;

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
          <Stack.Item>
            <h3>
              耐久：{mgData.health} / {mgData.health_max}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              弹药：{mgData.rounds} / {mgData.max_rounds}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>{mgData.deployed === 1 ? '已展开' : '未展开'}</h3>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
    </Stack>
  );
};

export const MgMfdPanel = (props: MfdProps) => {
  const { act, data } = useBackend<EquipmentContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);
  const mg = data.equipment_data.find((x) => x.mount_point === equipmentState);
  const deployLabel = (mg?.data?.deployed ?? 0) === 1 ? '收回' : '展开';

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
            act('deploy-equipment', { equipment_id: mg?.mount_point }),
        },
      ]}
      bottomButtons={[
        {
          children: '退出',
          onClick: () => setPanelState(''),
        },
      ]}
    >
      <Box className="NavigationMenu">{mg && <MgPanel {...mg} />}</Box>
    </MfdPanel>
  );
};
