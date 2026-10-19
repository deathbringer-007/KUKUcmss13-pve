import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Flex,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const XenomorphExtractor = () => {
  const { act, data } = useBackend();

  const {
    organ,
    points,
    upgrades,
    caste,
    value,
    categories,
    current_clearance,
    is_x_level,
  } = data;
  const categoryLabels = {
    NONE: '选择类别',
    Machinery: '机械设备',
    Items: '物品',
    Armor: '护甲',
  };
  const dropdownOptions = categories.map((value) => ({
    value,
    displayText: categoryLabels[value] ?? value,
  }));
  const [selectedTab, setSelectedTab] = useState('NONE');

  return (
    <Window width={850} height={800} theme="crtyellow">
      <Window.Content scrollable>
        <Section>
          <Stack fill vertical>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!organ}
                onClick={() => act('eject_organ')}
              >
                {!organ ? '弹出生物质' : '弹出' + caste + '生物质'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!organ}
                onClick={() => act('process_organ')}
              >
                {!organ
                  ? '处理生物质'
                  : '处理生物质，预计产出：' + value}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <NoticeBox info>生物质储量：{points}</NoticeBox>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="生物材料">
          {!organ ? (
            <NoticeBox danger>
              容器为空，无法分析！
            </NoticeBox>
          ) : (
            <NoticeBox notice>已接收生物质，可以开始分析。</NoticeBox>
          )}
        </Section>
        <Divider />
        <Section title={<span> 选择要制造的科技产品。</span>}>
          <Box ml={1}>
            <Dropdown
              selected={selectedTab}
              displayText={categoryLabels[selectedTab] ?? selectedTab}
              options={dropdownOptions}
              color={'#876500'}
              onSelected={(value) => setSelectedTab(value)}
            />
          </Box>
          <Flex height="200%" direction="row">
            <Flex.Item>
              <Box m={2} bold>
                {selectedTab !== 'NONE' && (
                  <LabeledList>
                    {upgrades.map((upgrades) =>
                      upgrades.category === selectedTab ? (
                        <LabeledList.Item
                          key={upgrades.name}
                          label={
                            <Box width={25}>
                              <h3 style={{ color: '#ffbf00' }}>
                                {upgrades.name}
                              </h3>
                            </Box>
                          }
                          buttons={
                            <Box preserveWhitespace>
                              {' '}
                              <Button
                                fluid={1}
                                icon="print"
                                tooltip={upgrades.desc}
                                tooltipPosition="left"
                                onClick={() =>
                                  act('produce', {
                                    ref: upgrades.ref,
                                  })
                                }
                              >
                                制造（{upgrades.cost}）
                              </Button>
                            </Box>
                          }
                        >
                          <Box mb={0.8}>
                            所需权限等级：{' '}
                            {upgrades.clearance === 6
                              ? '5X'
                              : upgrades.clearance}{' '}
                            {upgrades.price_change !== 0 && (
                              <Box>
                                <Divider />
                                此科技产品每次购买后，费用将{' '}
                                {upgrades.price_change > 0
                                  ? '增加'
                                  : '减少'}{' '}
                                {Math.abs(upgrades.price_change)}
                              </Box>
                            )}
                            {upgrades.price_change === 0 && (
                              <Box>
                                <Divider />
                                此科技产品的费用不会随购买次数变化。
                              </Box>
                            )}
                          </Box>
                        </LabeledList.Item>
                      ) : null,
                    )}
                  </LabeledList>
                )}
              </Box>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
