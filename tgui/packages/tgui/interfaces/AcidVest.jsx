import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Section, Slider } from '../components';
import { Window } from '../layouts';

const categoryLabels = new Map([
  ['Brute', '物理损伤'],
  ['Burn', '烧伤'],
  ['Toxin', '毒素损伤'],
  ['Oxygen', '缺氧损伤'],
  ['Genetic', '基因损伤'],
  ['Heart', '心脏'],
  ['Liver', '肝脏'],
  ['Lungs', '肺部'],
  ['Kidneys', '肾脏'],
  ['Brain', '大脑'],
  ['Vitals Level', '生命体征等级'],
  ['Bleeding', '出血'],
  ['Internal', '内出血'],
  ['Bloodloss', '失血'],
  ['Fracture', '骨折'],
  ['Splinted', '已上夹板'],
  ['Organ Damage', '器官损伤'],
  ['Organ Failure', '器官衰竭'],
  ['Death', '死亡'],
  ['Defibrillation', '除颤'],
  ['Concussion', '脑震荡'],
  ['Intoxication', '醉酒'],
  ['Foreign Object', '异物'],
  ['Optimal', '最佳'],
  ['Nominal', '正常'],
  ['Low', '偏低'],
  ['Very low', '极低'],
  ['Critical', '危急'],
  ['Emergency', '紧急'],
]);

export const AcidVest = (_props) => {
  const { act, data } = useBackend();

  const damageList = data.configList.Damage;
  const vitalsList = data.configList.Vitals;
  const conditionsList = data.configList.Conditions;

  const injectLogic = data.inject_logic;
  const injectThreshold = data.inject_damage_threshold;
  const injectAmount = data.inject_amount;

  const Ormode = injectLogic === 'OR' ? true : false;

  return (
    <Window width={400} height={550} theme="ntos">
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="注射量">
              <Slider
                inline
                maxValue={30}
                minValue={1}
                value={injectAmount}
                onChange={(e, value) =>
                  act('set_inject_amount', { value: value })
                }
                mt={1}
                stepPixelSize={10}
              />
            </LabeledList.Item>
            <LabeledList.Item label="伤害阈值">
              <Slider
                inline
                maxValue={200}
                minValue={1}
                value={injectThreshold}
                onChange={(e, value) =>
                  act('set_inject_damage_threshold', { value: value })
                }
                mt={1}
                stepPixelSize={2}
              />
            </LabeledList.Item>
            <LabeledList.Item label="触发逻辑">
              <Button
                onClick={() => act('inject_logic')}
                icon={Ormode ? 'question' : 'plus'}
              >
                {Ormode ? '或：任一条件' : '且：全部条件'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="配置">
          <Flex direction="row" grow>
            <Flex.Item>
              <Section title="伤害">
                <Flex direction="column" grow>
                  {Object.keys(damageList).map((category) => (
                    <Flex.Item key={category}>
                      <Button.Checkbox
                        fontSize="1.2rem"
                        checked={!!damageList[category]['flag']}
                        onClick={() =>
                          act('configurate', {
                            config_type: 'Damage',
                            config_value: damageList[category]['value'],
                          })
                        }
                      >
                        {categoryLabels.get(category) ?? category}
                      </Button.Checkbox>
                    </Flex.Item>
                  ))}
                </Flex>
              </Section>
            </Flex.Item>
            <Box width="10px" />
            <Flex.Item>
              <Section title="条件">
                <Flex direction="column" grow>
                  {Object.keys(conditionsList).map((category) => (
                    <Flex.Item key={category}>
                      <Button.Checkbox
                        fontSize="1.2rem"
                        checked={!!conditionsList[category]['flag']}
                        onClick={() =>
                          act('configurate', {
                            config_type: 'Conditions',
                            config_value: conditionsList[category]['value'],
                          })
                        }
                      >
                        {categoryLabels.get(category) ?? category}
                      </Button.Checkbox>
                    </Flex.Item>
                  ))}
                </Flex>
              </Section>
            </Flex.Item>
            <Box width="10px" />
            <Flex.Item>
              <Section title="生命体征">
                <Flex direction="column" grow>
                  {Object.keys(vitalsList).map((category) => (
                    <Flex.Item key={category}>
                      <Button.Checkbox
                        fontSize="1.2rem"
                        checked={!!vitalsList[category]['flag']}
                        onClick={() =>
                          act('configurate', {
                            config_type: 'Vitals',
                            config_value: vitalsList[category]['value'],
                          })
                        }
                      >
                        {categoryLabels.get(category) ?? category}
                      </Button.Checkbox>
                    </Flex.Item>
                  ))}
                </Flex>
              </Section>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
