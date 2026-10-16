import { useBackend } from '../backend';
import { Button, Flex, Section } from '../components';
import { Window } from '../layouts';

const factionLabels = new Map([
  ['Neutral', '中立'],
  ['USCM', '美国殖民地海军陆战队'],
  ['USA', '美国陆军'],
  ['USASF', '美国航空航天军'],
  ['Survivor', '幸存者'],
  ['UPP', '进步人民联盟'],
  ['TWE', '三世界帝国'],
  ['Wey-Yu', '维兰德-汤谷'],
  ['CLF', '殖民地解放阵线'],
  ['TWE Rebel', '三世界帝国叛军'],
  ['UA Rebel', '美洲联盟叛军'],
  ['UPP Rebel', '中国亚洲国家合作体'],
  ['PMC', '私人军事承包商'],
  ['VAI', '先锋之箭公司'],
  ['Colonial Marshal', '殖民地法警'],
  ['WY Death Squad', '维兰德-汤谷死亡小队'],
  ['Mercenary', '雇佣兵'],
  ['Freelancer', '自由佣兵'],
  ['HEFA Order', 'HEFA教团'],
  ["Dutch's Dozen", '达奇十二人组'],
  ['Pirate', '海盗'],
  ['Gladiator', '角斗士'],
  ['Pizza Delivery', '披萨配送员'],
  ['Souto Man', '索托侠'],
  ['Colonist', '殖民者'],
  ['Yautja', '铁血战士'],
  ['Zombie', '丧尸'],
  ['Normal Hive', '普通虫巢'],
  ['Corrupted Hive', '腐化虫巢'],
  ['Alpha Hive', '阿尔法虫巢'],
  ['Bravo Hive', '布拉沃虫巢'],
  ['Charlie Hive', '查理虫巢'],
  ['Delta Hive', '德尔塔虫巢'],
  ['Feral Hive', '野生虫巢'],
  ['Forsaken Hive', '遗弃虫巢'],
  ['Tutorial Hive', '教学虫巢'],
  ['Hellhound Pack', '地狱猎犬群'],
  ['Mutated Hive', '变异虫巢'],
  ['Tamed Hive', '驯化虫巢'],
  ['Renegade Hive', '叛离虫巢'],
]);

export const HiveFaction = (props) => {
  const { act, data } = useBackend();
  const { glob_factions, current_allies } = data;

  const onFactionButtonClick = (faction) =>
    act('set_ally', {
      should_ally: !current_allies[faction],
      target_faction: faction,
    });

  return (
    <Window theme="xeno" width={400} height={550}>
      <Window.Content scrollable>
        <Flex>
          <Section title="异形" height="100%" width="100%" mr={1}>
            {glob_factions['Xenomorph'].map((faction) => (
              <Button.Checkbox
                key={faction}
                width="100%"
                checked={current_allies[faction]}
                onClick={() => onFactionButtonClick(faction)}
              >
                {factionLabels.get(faction) ?? faction}
              </Button.Checkbox>
            ))}
          </Section>
          <Section title="人类" height="100%" width="100%" ml={1}>
            {glob_factions['Human'].map((faction) => (
              <Button.Checkbox
                key={faction}
                width="100%"
                checked={current_allies[faction]}
                onClick={() => onFactionButtonClick(faction)}
              >
                {factionLabels.get(faction) ?? faction}
              </Button.Checkbox>
            ))}
          </Section>
        </Flex>
      </Window.Content>
    </Window>
  );
};
