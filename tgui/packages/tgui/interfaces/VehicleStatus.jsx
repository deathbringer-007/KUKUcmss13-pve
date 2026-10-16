import { Fragment } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Collapsible,
  Divider,
  Flex,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const VehicleStatus = (props) => {
  const { act, data } = useBackend();
  const {
    resistance_data,
    integrity,
    door_locked,
    total_passenger_slots,
    total_taken_slots,
    passenger_categories_data,
    hardpoint_data,
  } = data;

  const height = 150 + hardpoint_data.length * 80;

  return (
    <Window width={400} height={height}>
      <Window.Content>
        <Section>
          {integrity >= 0 ? (
            <ProgressBar
              value={integrity}
              ranges={{
                good: [0.7, Infinity],
                average: [0.2, 0.7],
                bad: [-Infinity, 0.2],
              }}
            >
              车体完整度： {integrity}%
            </ProgressBar>
          ) : (
            <NoticeBox danger>车体已被摧毁！</NoticeBox>
          )}
          <Box height="5px" />
          <NoticeBox info={door_locked ? 0 : 1} danger={door_locked ? 1 : 0}>
            {door_locked ? '车门已锁定。' : '车门已解锁。'}
          </NoticeBox>
          <Collapsible title="当前装甲抗性">
            <ResistanceView />
          </Collapsible>
          <Collapsible title="乘员">
            <Box>
              乘员总容量： {total_taken_slots}/
              {total_passenger_slots}
            </Box>
            <PassengersView />
          </Collapsible>
        </Section>
        <Section title="挂载模块">
          <HardpointsView />
        </Section>
      </Window.Content>
    </Window>
  );
};

const ResistanceView = (props) => {
  const { act, data } = useBackend();
  const { resistance_data, integrity } = data;
  return resistance_data.map((resistance, index) => (
    <Fragment key={index}>
      <Box>
        {
          {
            Bio: '酸液',
            Slash: '劈砍',
            Bullet: '弹丸',
            Expl: '爆炸',
            Blunt: '钝击',
          }[resistance.name] || resistance.name
        }: {resistance.pct * 100}%
      </Box>
      <Box width="3px" />
    </Fragment>
  ));
};

const HardpointsView = (props) => {
  const { act, data } = useBackend();
  const { hardpoint_data } = data;
  return hardpoint_data.map((hardpoint, index) => (
    <Fragment key={index}>
      {index !== 0 ? <Divider /> : null}
      <Box>{hardpoint.name}</Box>
      <Box width="3px" />
      {hardpoint.fpw ? null : hardpoint.health >= 0 ? (
        <ProgressBar
          value={hardpoint.health}
          ranges={{
            good: [0.7, Infinity],
            average: [0.2, 0.7],
            bad: [-Infinity, 0.2],
          }}
        >
          模块完整度： {hardpoint.health}%
        </ProgressBar>
      ) : (
        <NoticeBox danger>模块已被摧毁！</NoticeBox>
      )}
      <Box height="3px" />
      {hardpoint.uses_ammo ? (
        <Flex direction="row">
          <ProgressBar
            value={hardpoint.current_rounds / hardpoint.max_rounds}
            width={hardpoint.fpw ? '100%' : '49%'}
          >
            弹药： {hardpoint.current_rounds} / {hardpoint.max_rounds}
          </ProgressBar>
          {hardpoint.fpw ? null : (
            <>
              <Box width="3px" />
              <ProgressBar
                value={hardpoint.mags / hardpoint.max_mags}
                width="49%"
              >
                弹匣： {hardpoint.mags} / {hardpoint.max_mags}
              </ProgressBar>
            </>
          )}
        </Flex>
      ) : null}
    </Fragment>
  ));
};

const PassengersView = (props) => {
  const { act, data } = useBackend();
  const { passenger_categories_data } = data;
  return passenger_categories_data.map((cat, index) => (
    <Fragment key={index}>
      <Box>
        {
          {
            Crewmen: '车组成员',
            'Synthetic Unit': '合成人',
            'CIC Officer': '作战情报中心军官',
            'Intelligence Officer': '情报官',
            'Medical Support': '医疗支援人员',
            'Command Staff': '指挥人员',
          }[cat.name] || cat.name
        }: {cat.taken}/{cat.total}
      </Box>
      <Box width="3px" />
    </Fragment>
  ));
};
