import { range } from 'common/collections';
import { useState } from 'react';

import { useBackend } from '../../backend';
import { Box, Divider, Flex, Stack } from '../../components';
import { Icon } from '../../components';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState } from './stateManagers';
import { MedevacContext, MedevacTargets } from './types';

const MedevacOccupant = (props: { readonly data: MedevacTargets }) => (
  <Box>
    <Flex justify="space-between" direction="horizontal">
      <Flex.Item grow>
        <Stack vertical>
          <Stack.Item>{props.data.occupant ?? '空置'}</Stack.Item>
          <Stack.Item>{props.data.area ?? '未知'}</Stack.Item>
        </Stack>
      </Flex.Item>
      <Flex.Item grow>
        <Flex fill={1} justify="space-around">
          <Flex.Item>
            生命
            <br />
            {props.data.damage?.hp}
          </Flex.Item>
          <Flex.Item>
            外伤
            <br />
            {props.data.damage?.brute}
          </Flex.Item>
          <Flex.Item>
            烧伤
            <br />
            {props.data.damage?.fire}
          </Flex.Item>
          <Flex.Item>
            毒伤
            <br />
            {props.data.damage?.tox}
          </Flex.Item>
          <Flex.Item>
            缺氧
            <br /> {props.data.damage?.oxy}
          </Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  </Box>
);

export const MedevacMfdPanel = (props: MfdProps) => {
  const { data, act } = useBackend<MedevacContext>();
  const [medevacOffset, setMedevacOffset] = useState(0);
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);

  const result = data.equipment_data.find(
    (x) => x.mount_point === equipmentState,
  );
  const medevacs = data.medevac_targets === null ? [] : data.medevac_targets;
  const medevac_mapper = (x: number) => {
    const target = medevacs.length > x ? medevacs[x] : undefined;
    return {
      children: target ? target.occupant?.split(' ')[0] ?? '空置' : undefined,
      onClick: () =>
        act('medevac-target', {
          equipment_id: result?.mount_point,
          ref: target?.ref,
        }),
    };
  };

  const left_targets = range(medevacOffset, medevacOffset + 5).map(
    medevac_mapper,
  );

  const right_targets = range(medevacOffset + 5, medevacOffset + 8).map(
    medevac_mapper,
  );

  const all_targets = range(medevacOffset, medevacOffset + 8)
    .map((x) => data.medevac_targets[x])
    .filter((x) => x !== undefined);

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={left_targets}
      rightButtons={[
        {
          children: <Icon name="arrow-up" />,
          onClick: () => {
            if (medevacOffset > 0) {
              setMedevacOffset(medevacOffset - 1);
            }
          },
        },
        ...right_targets,
        {
          children: <Icon name="arrow-down" />,
          onClick: () => {
            if (medevacOffset + 8 < data.medevac_targets.length) {
              setMedevacOffset(medevacOffset + 1);
            }
          },
        },
      ]}
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
        <Flex justify="space-between">
          <Flex.Item>
            <svg width="60px">
              {all_targets.length > 0 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 50 l -20 0 l -20 -20 l -20 0"
                />
              )}
              {all_targets.length > 1 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 100 l -20 0 l -20 30 l -20 0"
                />
              )}
              {all_targets.length > 2 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 155 l -20 0 l -20 80 l -20 0"
                />
              )}
              {all_targets.length > 3 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 210 l -20 0 l -20 120 l -20 0"
                />
              )}
              {all_targets.length > 4 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 260 l -20 0 l -20 170 l -20 0"
                />
              )}
            </svg>
          </Flex.Item>
          <Flex.Item width="400px">
            <Stack vertical align="center">
              <Stack.Item>
                <h3>医疗后送请求</h3>
              </Stack.Item>
              {all_targets.map((x) => (
                <>
                  <Stack.Item key={x.occupant} width="100%" minHeight="32px">
                    <MedevacOccupant data={x} />
                  </Stack.Item>
                  <Divider />
                </>
              ))}
            </Stack>
          </Flex.Item>
          <Flex.Item>
            <svg width="60px">
              {all_targets.length > 5 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 0 310 l 20 0 l 20 -180 l 20 0"
                />
              )}
              {all_targets.length > 6 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 0 360 l 20 0 l 20 -130 l 20 0"
                />
              )}
              {all_targets.length > 7 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 0 410 l 20 0 l 20 -80 l 20 0"
                />
              )}
            </svg>
          </Flex.Item>
        </Flex>
      </Box>
    </MfdPanel>
  );
};
