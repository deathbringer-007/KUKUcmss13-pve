import { useBackend } from '../backend';
import { Box, Button, Flex, Section } from '../components';
import { Window } from '../layouts';

export const TechControl = (props) => {
  const { act, data } = useBackend();
  data.leader_data = data.leader_data || {
    name: '未指派',
    job: '无',
    paygrade: '无',
    rank: 0,
  };

  const { leader_data, user_data } = data;

  return (
    <Window width={500} height={250} resizable>
      <Window.Content>
        <Flex height="100%" justify="space-between">
          <Flex.Item grow={1}>
            <Flex direction="column" height="100%">
              <Flex.Item grow={1}>
                <Section fill title="指挥者信息">
                  <Flex direction="column">
                    <Flex.Item>
                      <Label label="姓名" content={leader_data.name} />
                    </Flex.Item>
                    <Flex.Item mt={1}>
                      <Label label="职务" content={leader_data.job} />
                    </Flex.Item>
                    <Flex.Item mt={1}>
                      <Label label="军衔" content={leader_data.paygrade} />
                    </Flex.Item>
                  </Flex>
                </Section>
              </Flex.Item>
              <Flex.Item>
                <Section fill title="你的信息">
                  <Flex direction="column">
                    <Flex.Item>
                      <Label label="姓名" content={user_data.name} />
                    </Flex.Item>
                    <Flex.Item mt={1}>
                      <Label label="职务" content={user_data.job || '无'} />
                    </Flex.Item>
                    <Flex.Item mt={1}>
                      <Label
                        label="军衔"
                        content={user_data.paygrade || '无'}
                      />
                    </Flex.Item>
                  </Flex>
                </Section>
              </Flex.Item>
            </Flex>
          </Flex.Item>
          <Flex.Item ml={1}>
            <Section fill title="指令">
              <Flex direction="column" height="100%">
                <Flex.Item>
                  <Button
                    disabled={
                      (user_data.rank || 0) < leader_data.rank ||
                      user_data.is_leader
                    }
                    textAlign="center"
                    width="100%"
                    onClick={() => act('override_leader')}
                  >
                    接管指挥权
                  </Button>
                </Flex.Item>
                <Flex.Item mt={1}>
                  <Button
                    disabled={!user_data.is_leader}
                    color="red"
                    textAlign="center"
                    width="100%"
                    onClick={() => act('giveup_control')}
                  >
                    放弃指挥权
                  </Button>
                </Flex.Item>
              </Flex>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

export const Label = (props) => {
  const { label, content, ...rest } = props;

  return (
    <Flex {...rest}>
      <Flex.Item width="25%">
        <Box color="label">{label}:</Box>
      </Flex.Item>
      <Flex.Item width="75%">
        <Box className="TechNode__content">{content}</Box>
      </Flex.Item>
    </Flex>
  );
};
