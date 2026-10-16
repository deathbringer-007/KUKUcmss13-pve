import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

const squadLabels = new Map([
  ['Alpha', '阿尔法'],
  ['Bravo', '布拉沃'],
  ['Charlie', '查理'],
  ['Delta', '德尔塔'],
  ['Echo', '埃科'],
  ['Foxtrot', '福克斯特罗特'],
  ['Sun Riders', '烈日骑兵'],
  ['Sun Riders B-Sct', '烈日骑兵 B 分队'],
  ['Intel', '情报组'],
  ['SOF', '特种部队'],
  ['CBRN', '核生化'],
  ['FORECON', '武装侦察部队'],
  ['Solar Devils', '太阳恶魔'],
  ['US Army', '美国陆军'],
  ['Red Dawn', '赤色黎明'],
  ['Golden Embers', '金色余烬'],
  ['AZURE-15', '苍蓝-15'],
  ['VIRIDIAN-22', '翠绿-22'],
  ['AZURE-16', '苍蓝-16'],
  ['Gamma Troop', '伽马分队'],
  ['Snake Eaters', '食蛇者'],
  ['Ocelot Grapplers', '豹猫搏击队'],
  ['UPPS1', '联盟第1小队'],
  ['UPPS2', '联盟第2小队'],
  ['UPPS3', '联盟第3小队'],
  ['UPPS4', '联盟第4小队'],
  ['UPPKdo', '联盟突击队'],
  ['Team Upsilon', '宇普西隆小组'],
  ['Team Gamma', '伽马小组'],
  ['Taskforce White', '白色特遣队'],
  ['Python', '蟒蛇'],
  ['Viper', '蝰蛇'],
  ['Cobra', '眼镜蛇'],
  ['Boa', '蚺蛇'],
]);

export const SquadMod = (props) => {
  const { act, data } = useBackend();
  const { squads = [], human, id_name, has_id } = data;
  return (
    <Window width={400} height={300}>
      <Window.Content>
        <Section>
          <Stack vertical>
            <Stack.Item>
              <Button fluid icon="eject" onClick={() => act('PRG_eject')}>
                {id_name}
              </Button>
            </Stack.Item>
            {!has_id && (
              <Stack.Item>
                <NoticeBox>
                  插入待调动人员的ID卡。
                </NoticeBox>
              </Stack.Item>
            )}
            {!human && (
              <Stack.Item>
                <NoticeBox>
                  让待调动人员将手放在扫描仪上，必要时可强行按上。
                </NoticeBox>
              </Stack.Item>
            )}
            {!!human && (
              <Stack.Item>
                <NoticeBox>选定调动人员：{human}</NoticeBox>
              </Stack.Item>
            )}
          </Stack>
        </Section>
        {!!(human && has_id) && (
          <Section title="小队调动">
            {squads.map((entry) => (
              <Button
                key={entry.name}
                fluid
                backgroundColor={entry.color}
                onClick={() =>
                  act('PRG_squad', {
                    name: entry.name,
                  })
                }
              >
                {squadLabels.get(entry.name) ?? entry.name}
              </Button>
            ))}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
