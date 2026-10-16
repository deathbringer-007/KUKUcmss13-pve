import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
  Tabs,
} from '../components';
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

export const SupplyDropConsole = () => {
  const { act, data } = useBackend();

  const can_pick_squad = data.can_pick_squad;

  const timeLeft = data.nextfiretime - data.worldtime;
  const timeLeftPct = timeLeft / data.launch_cooldown;

  const cantFire = (timeLeft < 0, data.loaded === null);

  const squads = data.squad_list;

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        {!!can_pick_squad && (
          <NoticeBox info={1} fluid textAlign="center">
            {data.current_squad
              ? `当前小队：${squadLabels.get(data.current_squad) ?? data.current_squad}`
              : '未选择小队'}
          </NoticeBox>
        )}
        {!!can_pick_squad && (
          <Tabs horizontal textAlign="center" fluid>
            {squads.map((val) => {
              return (
                <Tabs.Tab
                  onClick={() => {
                    act('pick_squad', { squad_name: val.squad_name });
                  }}
                  key={val.squad_name}
                >
                  <Box color={val.squad_color}>{squadLabels.get(val.squad_name) ?? val.squad_name}</Box>
                </Tabs.Tab>
              );
            })}
          </Tabs>
        )}
        <Section title="补给空投">
          <LabeledList>
            <LabeledList.Item label="经度">
              <NumberInput
                width="4em"
                step={1}
                minValue={-1000}
                maxValue={1000}
                value={data.x_offset}
                onChange={(value) => act('set_x', { set_x: `${value}` })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="纬度">
              <NumberInput
                width="4em"
                step={1}
                minValue={-1000}
                maxValue={1000}
                value={data.y_offset}
                onChange={(value) => act('set_y', { set_y: `${value}` })}
              />
            </LabeledList.Item>
          </LabeledList>
          <Divider />
          <Section
            title="补给平台状态"
            buttons={
              <Button icon="sync-alt" onClick={() => act('refresh_pad')}>
                更新
              </Button>
            }
          >
            <NoticeBox info={1} textAlign="center">
              {data.loaded
                ? `补给平台状态：已装载${data.crate_name}。`
                : '未装载补给箱。'}
            </NoticeBox>
            {(timeLeft < 0 && (
              <NoticeBox success={1} textAlign="center">
                准备就绪！
              </NoticeBox>
            )) || (
              <ProgressBar
                width="100%"
                value={timeLeftPct}
                ranges={{
                  good: [-Infinity, 0.33],
                  average: [0.33, 0.67],
                  bad: [0.67, Infinity],
                }}
              >
                <Box textAlign="center">
                  距离下次发射还有{Math.ceil(timeLeft / 10)}秒
                </Box>
              </ProgressBar>
            )}
            <Button
              fontSize="20px"
              textAlign="center"
              disabled={!!cantFire}
              fluid
              icon="paper-plane"
              color="good"
              onClick={() => act('send_beacon')}
            >
              发射补给空投
            </Button>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
