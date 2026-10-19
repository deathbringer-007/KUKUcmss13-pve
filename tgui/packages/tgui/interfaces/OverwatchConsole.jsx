import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Input,
  LabeledControls,
  NumberInput,
  Section,
  Stack,
  Table,
  Tabs,
} from '../components';
import { Window } from '../layouts';

const overwatchLabels = new Map([
  ['Alpha', '阿尔法'],
  ['Bravo', '布拉沃'],
  ['Charlie', '查理'],
  ['Delta', '德尔塔'],
  ['Echo', '艾可'],
  ['Foxtrot', '狐步'],
  ['Intel', '情报'],
  ['SOF', '特种作战部队'],
  ['Cryo', '冷冻休眠'],
  ['NONE', '无'],
  ['MULTIPLE', '多种专精'],
  ['UNKNOWN', '未知'],
  ['unknown', '未知'],
  ['N/A', '不适用'],
  ['Sniper', '狙击手'],
  ['Heavy Grenadier', '重型榴弹兵'],
  ['Demolitionist', '爆破手'],
  ['Demolitions', '爆破'],
  ['Scout', '侦察兵'],
  ['Pyrotechnician', '火焰兵'],
  ['groundside', '地面'],
  ['shipside', '舰上'],
  ['all', '全部'],
  ['N', '北'],
  ['NE', '东北'],
  ['E', '东'],
  ['SE', '东南'],
  ['S', '南'],
  ['SW', '西南'],
  ['W', '西'],
  ['NW', '西北'],
]);
const overwatchLabel = (value) => overwatchLabels.get(value) ?? value;
const overwatchState = (value) =>
  String(value).replace(
    /Conscious|Unconscious|Incapacitated|Dead|\(SSD\)/g,
    (state) =>
      ({
        Conscious: '清醒',
        Unconscious: '昏迷',
        Incapacitated: '失能',
        Dead: '阵亡',
        '(SSD)': '（断线）',
      })[state],
  );
const overwatchDistance = (value) =>
  String(overwatchLabel(value)).replace(
    /\((N|NE|E|SE|S|SW|W|NW)\)/g,
    (_, direction) => `（${overwatchLabel(direction)}）`,
  );

export const OverwatchConsole = (props) => {
  const { act, data } = useBackend();

  return (
    <Window
      width={800}
      height={600}
      theme={data.theme ? data.theme : 'crtblue'}
    >
      <Window.Content>
        {(!data.current_squad && <HomePanel />) || <SquadPanel />}
      </Window.Content>
    </Window>
  );
};

const HomePanel = (props) => {
  const { act, data } = useBackend();

  // Buttons don't seem to support hexcode colors, so we'll have to do this manually, sadly
  const squadColorMap = {
    alpha: 'red',
    bravo: 'yellow',
    charlie: 'purple',
    delta: 'blue',
    echo: 'green',
    foxtrot: 'brown',
    intel: 'green',
  };

  return (
    <Section
      fontSize="20px"
      textAlign="center"
      title="战术指挥未启用——请选择单位"
    >
      <Stack justify="center" align="end" fontSize="20px">
        {data.squad_list.map((squad, index) => {
          return (
            <Stack.Item key={index}>
              <Button
                color={
                  squadColorMap[squad.toLowerCase()]
                    ? squadColorMap[squad.toLowerCase()]
                    : 'red'
                }
                onClick={() => act('pick_squad', { squad: squad })}
              >
                {overwatchLabel(squad)}
              </Button>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};

const SquadPanel = (props) => {
  const { act, data } = useBackend();

  const [category, setCategory] = useSharedState('selected', 'monitor');

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Collapsible title="主面板" fontSize="16px">
          <MainDashboard />
        </Collapsible>
      </Stack.Item>
      <Stack.Item>
        <Collapsible title="小队岗位" fontSize="16px">
          <RoleTable />
        </Collapsible>
      </Stack.Item>
      <Stack.Item>
        <Tabs fluid pr="0" pl="0" mb="0" fontSize="16px">
          <Tabs.Tab
            selected={category === 'monitor'}
            icon="heartbeat"
            onClick={() => setCategory('monitor')}
          >
            小队监控
          </Tabs.Tab>
          {!!data.can_launch_crates && (
            <Tabs.Tab
              selected={category === 'supply'}
              icon="wrench"
              onClick={() => setCategory('supply')}
            >
              补给空投
            </Tabs.Tab>
          )}
          {!!data.can_launch_obs && (
            <Tabs.Tab
              selected={category === 'ob'}
              icon="bomb"
              onClick={() => setCategory('ob')}
            >
              轨道轰炸
            </Tabs.Tab>
          )}
          <Tabs.Tab icon="map" onClick={() => act('tacmap_unpin')}>
            战术地图
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>
        {category === 'monitor' && <SquadMonitor />}
        {category === 'supply' && data.can_launch_crates && <SupplyDrop />}
        {category === 'ob' && data.can_launch_obs && <OrbitalBombardment />}
      </Stack.Item>
    </Stack>
  );
};

const MainDashboard = (props) => {
  const { act, data } = useBackend();

  let { current_squad, primary_objective, secondary_objective } = data;

  return (
    <Section
      fontSize="16px"
      title={overwatchLabel(current_squad) + '战术指挥 | 主面板'}
      buttons={
        <>
          <Button icon="user" onClick={() => act('change_operator')}>
            操作员：{data.operator}
          </Button>
          <Button icon="sign-out-alt" onClick={() => act('logout')}>
            停止战术指挥
          </Button>
        </>
      }
    >
      <Table mb="5px">
        <Table.Row bold>
          <Table.Cell textAlign="center">主要命令</Table.Cell>
          <Table.Cell textAlign="center">次要命令</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell textAlign="center">
            {primary_objective ? primary_objective : '无'}
          </Table.Cell>
          <Table.Cell textAlign="center">
            {secondary_objective ? secondary_objective : '无'}
          </Table.Cell>
        </Table.Row>
      </Table>
      <Box textAlign="center">
        <Button
          inline
          width="23%"
          icon="envelope"
          onClick={() => act('set_primary')}
        >
          设置主要目标
        </Button>
        {primary_objective && (
          <Button
            inline
            width="23%"
            icon="person"
            onClick={() => act('remind_primary')}
          >
            提醒主要目标
          </Button>
        )}
        <Button
          inline
          width="23%"
          icon="envelope"
          onClick={() => act('set_secondary')}
        >
          设置次要目标
        </Button>
        {secondary_objective && (
          <Button
            inline
            width="23%"
            icon="person"
            onClick={() => act('remind_secondary')}
          >
            提醒次要目标
          </Button>
        )}
      </Box>

      <Box textAlign="center">
        <Button
          inline
          width="45%"
          icon="envelope"
          onClick={() => act('message')}
        >
          向分队发消息
        </Button>
        <Button
          inline
          width="45%"
          icon="person"
          onClick={() => act('sl_message')}
        >
          向分队长发消息
        </Button>
      </Box>
    </Section>
  );
};

const RoleTable = (props) => {
  const { act, data } = useBackend();

  const {
    squad_leader,
    leaders_alive,
    ftl_alive,
    ftl_count,
    specialist_type,
    spec_alive,
    smart_alive,
    smart_count,
    spec_count,
    medic_count,
    medic_alive,
    engi_alive,
    engi_count,
    living_count,
    total_deployed,
  } = data;

  return (
    <Table pb="4px" m="1px" fontSize="12px" bold>
      <Table.Row>
        <Table.Cell textAlign="center" p="4px">
          分队士官
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          小队长
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          武器专家
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          智能机枪手
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          排卫生员
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          战斗技术员
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          总数／存活
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        {(squad_leader && (
          <Table.Cell textAlign="center">
            {squad_leader.name ? squad_leader.name : '无'}
            <Box color={squad_leader.state !== 'Dead' ? 'green' : 'red'}>
              {squad_leader.state !== 'Dead' ? '存活' : '阵亡'}
            </Box>
          </Table.Cell>
        )) || (
          <Table.Cell textAlign="center">
            无<Box color="red">未部署</Box>
          </Table.Cell>
        )}

        <Table.Cell textAlign="center" bold>
          <Box>{ftl_count}人已部署</Box>
          <Box color={ftl_alive ? 'green' : 'red'}>{ftl_alive}人存活</Box>
        </Table.Cell>
        <Table.Cell textAlign="center" bold>
          <Box>{specialist_type ? overwatchLabel(specialist_type) : '无'}</Box>
          <Box color={spec_alive ? 'green' : 'red'}>
            {spec_count ? (spec_alive ? '存活' : '阵亡') : '未部署'}
          </Box>
        </Table.Cell>
        <Table.Cell textAlign="center" bold>
          <Box color={smart_count ? 'green' : 'red'}>
            {smart_count ? smart_count + '人已部署' : '无'}
          </Box>
          <Box color={smart_alive ? 'green' : 'red'}>
            {smart_count ? (smart_alive ? '存活' : '阵亡') : '不适用'}
          </Box>
        </Table.Cell>
        <Table.Cell textAlign="center" bold>
          <Box>{medic_count}人已部署</Box>
          <Box color={medic_alive ? 'green' : 'red'}>{medic_alive}人存活</Box>
        </Table.Cell>
        <Table.Cell textAlign="center" bold>
          <Box>{engi_count}人已部署</Box>
          <Box color={engi_alive ? 'green' : 'red'}>{engi_alive}人存活</Box>
        </Table.Cell>
        <Table.Cell textAlign="center" bold>
          <Box>{total_deployed}人总计</Box>
          <Box color={living_count ? 'green' : 'red'}>{living_count}人存活</Box>
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};

const SquadMonitor = (props) => {
  const { act, data } = useBackend();

  const sortByRole = (a, b) => {
    a = a.role;
    b = b.role;
    const roleValues = {
      'Section Sergeant': 10,
      'Squad Leader': 9,
      'Weapons Specialist': 8,
      Smartgunner: 7,
      'Platoon Corpsman': 6,
      'Combat Technician': 5,
      Rifleman: 4,
    };
    let valueA = roleValues[a];
    let valueB = roleValues[b];
    if (a.includes('Weapons Specialist')) {
      valueA = roleValues['Weapons Specialist'];
    }
    if (b.includes('Weapons Specialist')) {
      valueB = roleValues['Weapons Specialist'];
    }
    if (!valueA && !valueB) return 0; // They're both unknown
    if (!valueA) return 1; // B is defined but A is not
    if (!valueB) return -1; // A is defined but B is not

    if (valueA > valueB) return -1; // A is more important
    if (valueA < valueB) return 1; // B is more important

    return 0; // They're equal
  };

  let { marines, squad_leader } = data;

  const [hidden_marines, setHiddenMarines] = useSharedState(
    'hidden_marines',
    [],
  );

  const [showHiddenMarines, setShowHiddenMarines] = useSharedState(
    'showhidden',
    false,
  );
  const [showDeadMarines, setShowDeadMarines] = useSharedState(
    'showdead',
    true,
  );

  const [marineSearch, setMarineSearch] = useSharedState('marinesearch', null);

  let determine_status_color = (status) => {
    let conscious = status.includes('Conscious');
    let incapacitated = status.includes('Incapacitated');
    let unconscious = status.includes('Unconscious');

    let state_color = 'red';
    if (conscious) {
      state_color = 'green';
    } else if (incapacitated || unconscious) {
      state_color = 'yellow';
    }
    return state_color;
  };

  let toggle_marine_hidden = (ref) => {
    if (!hidden_marines.includes(ref)) {
      setHiddenMarines([...hidden_marines, ref]);
    } else {
      let array_copy = [...hidden_marines];
      let index = array_copy.indexOf(ref);
      if (index > -1) {
        array_copy.splice(index, 1);
      }
      setHiddenMarines(array_copy);
    }
  };

  let location_filter;
  if (data.z_hidden === 2) {
    location_filter = 'groundside';
  } else if (data.z_hidden === 1) {
    location_filter = 'shipside';
  } else {
    location_filter = 'all';
  }

  return (
    <Section
      pb="3%"
      fill
      fontSize="14px"
      title="人员监控"
      buttons={
        <>
          <Button
            color="yellow"
            tooltip="按位置筛选陆战队员"
            onClick={() => act('change_locations_ignored')}
          >
            显示范围：{overwatchLabel(location_filter)}
          </Button>
          {(showDeadMarines && (
            <Button color="yellow" onClick={() => setShowDeadMarines(false)}>
              隐藏阵亡人员
            </Button>
          )) || (
            <Button color="yellow" onClick={() => setShowDeadMarines(true)}>
              显示阵亡人员
            </Button>
          )}
          {(showHiddenMarines && (
            <Button color="yellow" onClick={() => setShowHiddenMarines(false)}>
              隐藏已隐藏人员
            </Button>
          )) || (
            <Button color="yellow" onClick={() => setShowHiddenMarines(true)}>
              显示已隐藏人员
            </Button>
          )}
          <Button
            color="yellow"
            icon="arrow-right"
            onClick={() => act('transfer_marine')}
          >
            调动陆战队员
          </Button>
          <Button color="blue" icon="medal" onClick={() => act('award_medal')}>
            授予勋章
          </Button>
        </>
      }
    >
      <Input
        fluid
        placeholder="搜索……"
        m="0"
        value={marineSearch}
        onInput={(e, value) => setMarineSearch(value)}
      />
      <Stack vertical fill>
        <Stack.Item grow align="center">
          <Section mt="2px" width="96vw" fill scrollable>
            <Table>
              <Table.Row bold fontSize="14px">
                <Table.Cell textAlign="center">姓名</Table.Cell>
                <Table.Cell textAlign="center">职务</Table.Cell>
                <Table.Cell textAlign="center" collapsing>
                  状态
                </Table.Cell>
                <Table.Cell textAlign="center">位置</Table.Cell>
                <Table.Cell textAlign="center" collapsing fontSize="12px">
                  距小队长
                </Table.Cell>
                <Table.Cell textAlign="center" />
              </Table.Row>
              {squad_leader && (
                <Table.Row key="index" bold>
                  <Table.Cell collapsing p="2px">
                    {(squad_leader.has_helmet && (
                      <Button
                        onClick={() =>
                          act('watch_camera', { target_ref: squad_leader.ref })
                        }
                      >
                        {squad_leader.name}
                      </Button>
                    )) || (
                      <Box color="yellow">{squad_leader.name} （无摄像头）</Box>
                    )}
                  </Table.Cell>
                  <Table.Cell p="2px">
                    {squad_leader.role_display ||
                      overwatchLabel(squad_leader.role)}
                  </Table.Cell>
                  <Table.Cell
                    p="2px"
                    color={determine_status_color(squad_leader.state)}
                  >
                    {overwatchState(squad_leader.state)}
                  </Table.Cell>
                  <Table.Cell p="2px">{squad_leader.area_name}</Table.Cell>
                  <Table.Cell p="2px" collapsing>
                    {overwatchDistance(squad_leader.distance)}
                  </Table.Cell>
                  <Table.Cell />
                </Table.Row>
              )}
              {marines &&
                marines
                  .sort(sortByRole)
                  .filter((marine) => {
                    if (marineSearch && !marineSearch.includes('\\')) {
                      const searchableString = String(
                        marine.name,
                      ).toLowerCase();
                      return searchableString.match(
                        new RegExp(marineSearch, 'i'),
                      );
                    }
                    return marine;
                  })
                  .map((marine, index) => {
                    if (squad_leader) {
                      if (marine.ref === squad_leader.ref) {
                        return;
                      }
                    }
                    if (
                      hidden_marines.includes(marine.ref) &&
                      !showHiddenMarines
                    ) {
                      return;
                    }
                    if (marine.state === 'Dead' && !showDeadMarines) {
                      return;
                    }

                    return (
                      <Table.Row key={index}>
                        <Table.Cell collapsing p="2px">
                          {(marine.has_helmet && (
                            <Button
                              onClick={() =>
                                act('watch_camera', { target_ref: marine.ref })
                              }
                            >
                              {marine.name}
                            </Button>
                          )) || (
                            <Box color="yellow">{marine.name} （无摄像头）</Box>
                          )}
                        </Table.Cell>
                        <Table.Cell p="2px">
                          {marine.role_display || overwatchLabel(marine.role)}
                        </Table.Cell>
                        <Table.Cell
                          p="2px"
                          color={determine_status_color(marine.state)}
                        >
                          {overwatchState(marine.state)}
                        </Table.Cell>
                        <Table.Cell p="2px">{marine.area_name}</Table.Cell>
                        <Table.Cell p="2px" collapsing>
                          {overwatchDistance(marine.distance)}
                        </Table.Cell>
                        <Table.Cell p="2px">
                          {(hidden_marines.includes(marine.ref) && (
                            <Button
                              icon="plus"
                              color="green"
                              tooltip="显示此陆战队员"
                              onClick={() => toggle_marine_hidden(marine.ref)}
                            />
                          )) || (
                            <Button
                              icon="minus"
                              color="red"
                              tooltip="隐藏此陆战队员"
                              onClick={() => toggle_marine_hidden(marine.ref)}
                            />
                          )}
                          <Button
                            icon="arrow-up"
                            color="green"
                            tooltip="将此陆战队员晋升为单位长官"
                            onClick={() =>
                              act('replace_lead', { ref: marine.ref })
                            }
                          />
                        </Table.Cell>
                      </Table.Row>
                    );
                  })}
            </Table>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const SupplyDrop = (props) => {
  const { act, data } = useBackend();

  const [supplyX, setSupplyX] = useSharedState('supplyx', 0);
  const [supplyY, setSupplyY] = useSharedState('supply', 0);

  let crate_status = '补给箱已装载';
  let crate_color = 'green';
  if (data.supply_cooldown) {
    crate_status = '冷却中——' + data.supply_cooldown / 10 + '秒';
    crate_color = 'yellow';
  } else if (!data.has_crate_loaded) {
    crate_status = '未装载补给箱';
    crate_color = 'red';
  }

  return (
    <Section fill fontSize="14px" title="补给空投">
      <Stack justify={'space-between'} m="10px">
        <Stack.Item fontSize="14px">
          <LabeledControls mb="5px">
            <LabeledControls.Item label="经度">
              <NumberInput
                value={supplyX}
                step={1}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setSupplyX(value)}
                width="75px"
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="纬度">
              <NumberInput
                value={supplyY}
                step={1}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setSupplyY(value)}
                width="75px"
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="状态">
              <Box color={crate_color} bold>
                {crate_status}
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
          <Box textAlign="center">
            <Button
              fontSize="20px"
              width="100%"
              icon="box"
              color="yellow"
              onClick={() => act('dropsupply', { x: supplyX, y: supplyY })}
            >
              发射
            </Button>
            <Button
              fontSize="20px"
              width="100%"
              icon="save"
              color="yellow"
              onClick={() =>
                act('save_coordinates', { x: supplyX, y: supplyY })
              }
            >
              保存
            </Button>
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Divider vertical />
        </Stack.Item>
        <SavedCoordinates forSupply />
      </Stack>
      <Divider />
    </Section>
  );
};

const OrbitalBombardment = (props) => {
  const { act, data } = useBackend();

  const [OBX, setOBX] = useSharedState('obx', 0);
  const [OBY, setOBY] = useSharedState('oby', 0);

  let ob_status = '就绪';
  let ob_color = 'green';
  if (data.ob_cooldown) {
    ob_status = '冷却中——' + data.ob_cooldown / 10 + '秒';
    ob_color = 'yellow';
  } else if (!data.ob_loaded) {
    ob_status = '未装弹入膛';
    ob_color = 'red';
  }

  return (
    <Section fill fontSize="14px" title="轨道轰炸">
      <Stack justify={'space-between'} m="10px">
        <Stack.Item fontSize="14px">
          <LabeledControls mb="5px">
            <LabeledControls.Item label="经度">
              <NumberInput
                value={OBX}
                step={1}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setOBX(value)}
                width="75px"
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="纬度">
              <NumberInput
                value={OBY}
                step={1}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setOBY(value)}
                width="75px"
              />
            </LabeledControls.Item>

            <LabeledControls.Item label="状态">
              <Box color={ob_color} bold>
                {ob_status}
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
          <Box textAlign="center">
            <Button
              fontSize="20px"
              width="100%"
              icon="bomb"
              color="red"
              onClick={() => act('dropbomb', { x: OBX, y: OBY })}
            >
              开火
            </Button>
            <Button
              fontSize="20px"
              width="100%"
              icon="save"
              color="yellow"
              onClick={() => act('save_coordinates', { x: OBX, y: OBY })}
            >
              保存
            </Button>
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Divider vertical />
        </Stack.Item>
        <SavedCoordinates forOB />
      </Stack>
      <Divider />
    </Section>
  );
};

const SavedCoordinates = (props) => {
  const { act, data } = useBackend();

  const [OBX, setOBX] = useSharedState('obx', 0);
  const [OBY, setOBY] = useSharedState('oby', 0);
  const [supplyX, setSupplyX] = useSharedState('supplyx', 0);
  const [supplyY, setSupplyY] = useSharedState('supply', 0);

  const { forOB, forSupply } = props;

  let transferCoords = (x, y) => {
    if (forSupply) {
      setSupplyX(x);
      setSupplyY(y);
    } else if (forOB) {
      setOBX(x);
      setOBY(y);
    }
  };

  return (
    <Stack.Item>
      <Box bold textAlign="center">
        最多保存3组坐标，超出后将优先覆盖最早保存的一组。
      </Box>
      <Table>
        <Table.Row bold>
          <Table.Cell p="5px" collapsing>
            经度
          </Table.Cell>
          <Table.Cell p="5px" collapsing>
            纬度
          </Table.Cell>
          <Table.Cell p="5px">备注</Table.Cell>
          <Table.Cell p="5px" collapsing />
        </Table.Row>
        {data.saved_coordinates.map((coords, index) => (
          <Table.Row key={index}>
            <Table.Cell p="6px">{coords.x}</Table.Cell>
            <Table.Cell p="5px">{coords.y}</Table.Cell>
            <Table.Cell p="5px">
              <Input
                width="100%"
                value={coords.comment}
                onChange={(e, value) =>
                  act('change_coordinate_comment', {
                    comment: value,
                    index: coords.index,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell p="5px">
              <Button
                color="yellow"
                icon="arrow-left"
                onClick={() => transferCoords(coords.x, coords.y)}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Stack.Item>
  );
};
