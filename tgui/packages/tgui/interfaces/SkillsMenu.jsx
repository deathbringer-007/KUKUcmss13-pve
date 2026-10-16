import { capitalizeAll } from 'common/string';
import { Fragment } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  NoticeBox,
  ProgressBar,
  Section,
  Slider,
} from '../components';
import { Window } from '../layouts';

export const SkillsMenu = (props) => {
  const { act, data } = useBackend();
  const { skillset_name, skills, owner, admin } = data;

  return (
    <Window width={300} height={550}>
      <Window.Content>
        <Section
          title={'技能组名称：' + skillset_name}
          buttons={
            <Button
              color="transparent"
              tooltip="刷新"
              tooltipPosition="left"
              icon="sync-alt"
              onClick={() => act('refresh')}
            />
          }
        >
          {skills ? (
            admin ? (
              <SkillsEdit />
            ) : (
              <SkillsView />
            )
          ) : (
            <NoticeBox danger>警告！该角色没有技能数据！</NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const SkillsView = (props) => {
  const { act, data } = useBackend();
  const { skillset_name, skills, owner, admin } = data;
  return skills.map((skill, index) => (
    <Fragment key={index}>
      <ProgressBar value={skill.level / skill.maxlevel}>
        {capitalizeAll(skill.name)}: {skill.level}/{skill.maxlevel}
      </ProgressBar>
      <Box height="3px" />
    </Fragment>
  ));
};

const SkillsEdit = (props) => {
  const { act, data } = useBackend();
  const { skillset_name, skills, owner, admin } = data;
  return skills.map((skill, index) => (
    <Fragment key={index}>
      <Slider
        value={skill.level}
        stepPixelSize={150 / skill.maxlevel}
        minValue={0}
        maxValue={skill.maxlevel}
        onChange={(e, value) =>
          act('set_skill', {
            skill: skill.realname,
            level: value,
            oldlevel: skill.level,
          })
        }
      >
        {capitalizeAll(skill.name)}: {skill.level}/{skill.maxlevel}
      </Slider>
      <Box height="3px" />
    </Fragment>
  ));
};
