import { useBackend } from '../backend';
import { Box, Button, Flex, Input, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const Centrifuge = () => {
  const { act, data } = useBackend();

  return (
    <Window width={300} height={270} theme="weyland">
      <Window.Content scrollable>
        <Section title="离心机控制">
          <Flex direction="column">
            <Flex.Item>
              标签：{' '}
              <Input
                placeholder="无标签"
                value={data.label}
                width="210px"
                onInput={(e, value) =>
                  act('setlabel', {
                    name: value,
                  })
                }
              />
              <Box height="10px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                icon={data.mode ? 'equals' : 'arrows-split-up-and-left'}
                onClick={() => act('togglemode')}
              >
                {data.mode ? '模式：分装' : '模式：分离'}
              </Button>
              <Box width="2px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="flask"
                fluid
                disabled={!data.turing}
                onClick={() => act('togglesource')}
              >
                {data.input_source
                  ? '输入：图灵自动配药机'
                  : '输入：容器'}
              </Button>
              <Box width="2px" />
            </Flex.Item>
            {!data.turing && (
              <Flex.Item>
                <Button
                  icon="link"
                  fluid
                  disabled={!data.turing}
                  onClick={() => act('attempt_connection')}
                >
                  连接图灵自动配药机
                </Button>
                <Box width="2px" />
              </Flex.Item>
            )}
            <Flex.Item>
              <NoticeBox info>
                {data.turing
                  ? '已连接图灵自动配药机！'
                  : '未连接图灵自动配药机！'}
              </NoticeBox>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
