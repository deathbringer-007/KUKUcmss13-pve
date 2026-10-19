import { classes } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Stack, Table } from '../components';
import { BoxProps } from '../components/Box';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

const squadLabels = new Map<string, string>([
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

interface SquadLeadEntry {
  name: string;
  observer: number;
}

interface SquadMarineEntry {
  name: string;
  med: number;
  eng: number;
  status: null;
  refer?: string;
  paygrade: string;
  rank: string;
}

interface FireTeamEntry {
  name: string;
  total: number;
  sqldr?: SquadMarineEntry | [];
  mar: SquadMarineEntry[];
}

interface FireTeams {
  SQ1: FireTeamEntry;
  SQ2: FireTeamEntry;
}

interface SquadProps {
  sctsgt?: SquadLeadEntry;
  fireteams: FireTeams;
  mar_free: SquadMarineEntry[];
  total_mar: number;
  total_kia: number;
  total_free: number;
  user: { name: string; observer: number };
  squad: string;
  partial_squad_ref: string;
  squad_color: string;
  is_lead: 'sctsgt' | 'SQ1' | 'SQ2' | 'SQ3' | 'SQ4' | 0;
  objective: { primary?: string; secondary?: string };
}

const FireTeamLeadLabel = (props: { readonly ftl: SquadMarineEntry }) => {
  const { data } = useBackend<SquadProps>();
  const { ftl } = props;
  return (
    <>
      <Stack.Item>
        <span>小队长：</span>
      </Stack.Item>
      <Stack.Item>
        <span
          className={classes([
            'squadranks16x16',
            `squad-${data.partial_squad_ref}-hud-${ftl.rank}`,
          ])}
        />
      </Stack.Item>
      <Stack.Item>
        <span>
          {ftl.paygrade === 'N/A' ? '不适用' : ftl.paygrade} {ftl.name}
        </span>
      </Stack.Item>
    </>
  );
};

const FireTeamLead = (props: {
  readonly fireteam: FireTeamEntry;
  readonly sqldr: string;
}) => {
  const { data, act } = useBackend<SquadProps>();
  const fireteamLead = props.fireteam.sqldr;
  const isNotAssigned =
    fireteamLead === undefined ||
    fireteamLead instanceof Array ||
    fireteamLead.name === 'Not assigned';

  const assignedFireteamLead = fireteamLead as SquadMarineEntry;

  const demote = () => act('demote_ftl', { target_ft: props.sqldr });
  return (
    <Flex fill={1} justify="space-between" className="TeamLeadFlex">
      <Flex.Item>
        <Stack>
          {isNotAssigned && (
            <Stack.Item>
              <span>小队长：未指派</span>
            </Stack.Item>
          )}
          {!isNotAssigned && <FireTeamLeadLabel ftl={assignedFireteamLead} />}
        </Stack>
      </Flex.Item>
      <Flex.Item>
        {assignedFireteamLead.name !== 'Not assigned' &&
          data.is_lead === 'sctsgt' && <Button icon="xmark" onClick={demote} />}
      </Flex.Item>
    </Flex>
  );
};

interface FireteamBoxProps extends BoxProps {
  readonly name: string;
  readonly isEmpty: boolean;
}

const FireteamBox = (props: FireteamBoxProps) => {
  return (
    <Box className={classes(['FireteamBox'])}>
      <div className="Title">{props.name}</div>
      {!props.isEmpty && <div>{props.children}</div>}
    </Box>
  );
};

const FireTeam = (props: { readonly sqldr: string }) => {
  const { data, act } = useBackend<SquadProps>();
  const fireteam: FireTeamEntry = data.fireteams[props.sqldr];

  const members: SquadMarineEntry[] =
    fireteam === undefined
      ? Object.keys(data.mar_free).map((x) => data.mar_free[x])
      : Object.keys(fireteam.mar).map((x) => fireteam.mar[x]);

  const isEmpty =
    members.length === 0 &&
    (fireteam?.sqldr instanceof Array ||
      fireteam?.sqldr?.name === 'Not assigned' ||
      fireteam?.sqldr?.name === 'Unassigned' ||
      fireteam?.sqldr?.name === undefined);
  const rankList = ['Mar', 'ass', 'Med', 'Eng', 'SG', 'Spc', 'SqLdr', 'PltSgt'];
  const rankSort = (a: SquadMarineEntry, b: SquadMarineEntry) => {
    if (a.rank === 'Mar' && b.rank === 'Mar') {
      return a.paygrade === 'PFC' ? -1 : 1;
    }
    const a_index = rankList.findIndex((str) => a.rank === str);
    const b_index = rankList.findIndex((str) => b.rank === str);
    return a_index > b_index ? -1 : 1;
  };

  if (isEmpty) {
    return null;
  }

  return (
    <FireteamBox name={fireteam?.name ?? '未分配'} isEmpty={isEmpty}>
      <Flex direction="column">
        {!isEmpty && (
          <>
            {props.sqldr !== 'Unassigned' && (
              <Flex.Item>
                <FireTeamLead fireteam={fireteam} sqldr={props.sqldr} />
              </Flex.Item>
            )}
            <Flex.Item>
              <Table className="FireteamMembersTable">
                <TableRow>
                  <TableCell className="RoleCell">职责</TableCell>
                  <TableCell className="RankCell">军衔</TableCell>
                  <TableCell className="MemberCell">成员</TableCell>
                  {data.is_lead === 'sctsgt' && (
                    <TableCell className="ActionCell">
                      {props.sqldr === 'Unassigned' ? '分配至战斗组' : '操作'}
                    </TableCell>
                  )}
                </TableRow>
                {members.sort(rankSort).map((x) => (
                  <TableRow key={x.name}>
                    <FireTeamMember
                      member={x}
                      key={x.name}
                      team={props.sqldr}
                      fireteam={fireteam}
                    />
                  </TableRow>
                ))}
              </Table>
            </Flex.Item>
          </>
        )}
      </Flex>
    </FireteamBox>
  );
};

const FireTeamMember = (props: {
  readonly member: SquadMarineEntry;
  readonly team: string;
  readonly fireteam?: FireTeamEntry;
}) => {
  const { data, act } = useBackend<SquadProps>();
  const assignFT1 = { target_ft: 'SQ1', target_marine: props.member.name };
  const assignFT2 = { target_ft: 'SQ2', target_marine: props.member.name };
  const assignFT3 = { target_ft: 'SQ3', target_marine: props.member.name };
  const assignFT4 = { target_ft: 'SQ4', target_marine: props.member.name };

  const promote = () => {
    const teamlead = props.fireteam?.sqldr;
    if (teamlead !== undefined && !(teamlead instanceof Array)) {
      if (teamlead.name !== 'Not assigned') {
        act('demote_ftl', {
          target_ft: props.team,
          target_marine: teamlead.name,
        });
      }
    }
    act('promote_ftl', {
      target_ft: props.team,
      target_marine: props.member.name,
    });
  };

  const unassign = () =>
    act('unassign_ft', {
      target_ft: props.team,
      target_marine: props.member.name,
    });
  return (
    <>
      <TableCell>
        <span
          className={classes([
            'squadranks16x16',
            `squad-${data.partial_squad_ref}-hud-${props.member.rank}`,
          ])}
        />
      </TableCell>
      <TableCell>
        {props.member.paygrade === 'N/A' ? '不适用' : props.member.paygrade}
      </TableCell>
      <TableCell>{props.member.name}</TableCell>

      {data.is_lead === 'sctsgt' && (
        <TableCell>
          <Stack fill justify="center">
            {props.team === 'Unassigned' && (
              <>
                <Stack.Item>
                  <Button onClick={() => act('assign_ft', assignFT1)}>1</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('assign_ft', assignFT2)}>2</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('assign_ft', assignFT3)}>3</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('assign_ft', assignFT4)}>4</Button>
                </Stack.Item>
              </>
            )}
            {props.team !== 'Unassigned' && (
              <>
                <Stack.Item>
                  <Button icon="chevron-up" onClick={promote} />
                </Stack.Item>
                <Stack.Item>
                  <Button icon="xmark" onClick={unassign} />
                </Stack.Item>
              </>
            )}
          </Stack>
        </TableCell>
      )}
    </>
  );
};

const SquadObjectives = (props) => {
  const { data } = useBackend<SquadProps>();
  const primaryObjective = data.objective?.primary ?? '未设置';
  const secondaryObjective = data.objective?.secondary ?? '未设置';
  return (
    <Stack vertical>
      <Stack.Item>
        <span>主要目标：{primaryObjective}</span>
      </Stack.Item>
      <Stack.Item>
        <span>次要目标：{secondaryObjective}</span>
      </Stack.Item>
    </Stack>
  );
};

export const SquadInfo = () => {
  const { config, data } = useBackend<SquadProps>();
  const fireteams = ['SQ1', 'SQ2', 'SQ3', 'SQ4', 'Unassigned'];

  return (
    <Window theme="usmc" width={710} height={675}>
      <Window.Content className="SquadInfo">
        <Flex fill={1} justify="space-around" direction="column">
          <Flex.Item>
            <Section
              title={`${squadLabels.get(data.squad) ?? data.squad}分队军士：${data.sctsgt?.name ?? '无'}`}
            >
              <SquadObjectives />
            </Section>
          </Flex.Item>
          <Flex.Item>
            <Section title="小队">
              <Box width="100%" className="ftlFlex" fillPositionedParent>
                {fireteams.map((x) => (
                  <FireTeam sqldr={x} key={x} />
                ))}
              </Box>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
