import { useBackend } from '../backend';
import { Button, Flex, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const ResearchDoorDisplay = () => {
  const { act, data } = useBackend();

  return (
    <Window width={350} height={170}>
      <Window.Content scrollable>
        <Section>
          <Flex height="100%" direction="column">
            <Flex.Item>
              <NoticeBox info textAlign="center">
                关联门： {data.door_id}
              </NoticeBox>
            </Flex.Item>
            <Flex.Item>
              {(!data.open_shutter && (
                <Button fluid icon="lock-open" onClick={() => act('shutter')}>
                  打开卷闸
                </Button>
              )) || (
                <Button fluid icon="lock" onClick={() => act('shutter')}>
                  关闭卷闸
                </Button>
              )}
            </Flex.Item>
            <Flex.Item>
              {(!data.open_door && (
                <Button fluid icon="door-open" onClick={() => act('door')}>
                  开门
                </Button>
              )) || (
                <Button fluid icon="door-closed" onClick={() => act('door')}>
                  关门
                </Button>
              )}
            </Flex.Item>
            {!!data.has_divider && (
              <Flex.Item>
                <Button
                  fluid
                  icon="arrows-alt-v"
                  onClick={() => act('divider')}
                >
                  切换隔板
                </Button>
              </Flex.Item>
            )}
            {!!data.has_flash && (
              <Flex.Item>
                {(!data.flash_charging && (
                  <Button fluid icon="sun" onClick={() => act('flash')}>
                    启动闪光器
                  </Button>
                )) || (
                  <Button fluid color="bad" icon="sync-alt">
                    闪光器正在充能！
                  </Button>
                )}
              </Flex.Item>
            )}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
