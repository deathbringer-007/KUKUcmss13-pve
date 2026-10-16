import { Fragment } from 'react';

import { useBackend } from '../backend';
import { Box, Collapsible, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const KillPanel = (props) => {
  const { act, data } = useBackend();
  const { death_data } = data;

  const real_data = death_data['death_stats_list'];

  return (
    <Window width={300} height={600}>
      <Window.Content scrollable>
        <Section>
          {death_data ? (
            <KillView />
          ) : (
            <NoticeBox danger>没有击杀记录！</NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const KillView = (props) => {
  const { act, data } = useBackend();
  const { death_data } = data;

  const real_data = death_data['death_stats_list'];

  return real_data.map((entry, index) => (
    <Collapsible
      key={index}
      title={entry.mob_name + ' (' + entry.time_of_death + ')'}
    >
      <Box>角色：{entry.mob_name}</Box>
      {entry.job_name ? (
        <>
          <Box height="3px" />
          <Box>职务：{entry.job_name}</Box>
        </>
      ) : null}
      <Box height="3px" />
      <Box>区域：{entry.area_name}</Box>
      <Box height="3px" />
      <Box>死因：{entry.cause_name}</Box>
      <Box height="3px" />
      <Box>时间：{entry.time_of_death}</Box>
      <Box height="3px" />
      <Box>存活时长：{entry.total_time_alive}</Box>
      <Box height="3px" />
      <Box>承受伤害：{entry.total_damage_taken}</Box>
      <Box height="3px" />
      <Box>
        坐标：{entry.x}, {entry.y}, {entry.z}
      </Box>
    </Collapsible>
  ));
};
