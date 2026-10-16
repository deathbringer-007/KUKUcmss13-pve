import { capitalizeFirst } from 'common/string';
import { createContext, useContext, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  ColorBox,
  Icon,
  Image,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import {
  getDisplayName,
  getHealthColor,
  getMostRelevant,
  isJobOrNameMatch,
} from './helpers';
import {
  buildSquadObservable,
  groupSorter,
  type Observable,
  type OrbitData,
  splitter,
} from './types';

const groupLabels = new Map<string, string>([
  ['Prime', '主虫巢'],
  ['Corrupted', '腐化虫巢'],
  ['Forsaken', '遗弃虫巢'],
  ['Other', '其他'],
  ['Alpha', '阿尔法'],
  ['Bravo', '布拉沃'],
  ['Charlie', '查理'],
  ['Delta', '德尔塔'],
  ['Echo', '埃科'],
  ['Foxtrot', '福克斯特罗特'],
  ['CBRN', '核生化部队'],
  ['FORECON', '武装侦察队'],
  ['SOF', '特种部队'],
]);
const groupLabel = (value: string) => groupLabels.get(value) ?? value;

type search = {
  value: string;
  setValue: (value: string) => void;
};

const SearchContext = createContext<search>({ value: '', setValue: () => {} });

export const Orbit = () => {
  const [searchQuery, setSearchQuery] = useState<string>('');

  return (
    <Window title="环绕观察" width={500} height={700}>
      <Window.Content scrollable>
        <SearchContext.Provider
          value={{ value: searchQuery, setValue: setSearchQuery }}
        >
          <Stack fill vertical>
            <Stack.Item>
              <ObservableSearch />
            </Stack.Item>
            <Stack.Item mt={0.2} grow>
              <Section fill>
                <ObservableContent />
              </Section>
            </Stack.Item>
          </Stack>
        </SearchContext.Provider>
      </Window.Content>
    </Window>
  );
};

/** Controls filtering out the list of observables via search */
const ObservableSearch = () => {
  const { act, data } = useBackend<OrbitData>();
  const { humans = [], marines = [], survivors = [], xenos = [] } = data;

  let auto_observe = data.auto_observe;

  /** Gets a list of Observables, then filters the most relevant to orbit */
  const orbitMostRelevant = (searchQuery: string) => {
    const mostRelevant = getMostRelevant(searchQuery, [
      humans,
      marines,
      survivors,
      xenos,
    ]);

    if (mostRelevant !== undefined) {
      act('orbit', {
        ref: mostRelevant.ref,
      });
    }
  };

  const { value, setValue } = useContext(SearchContext);

  return (
    <Section>
      <Stack>
        <Stack.Item>
          <Icon name="search" />
        </Stack.Item>
        <Stack.Item grow>
          <Input
            autoFocus
            fluid
            onEnter={(event, value) => orbitMostRelevant(value)}
            onInput={(event, value) => setValue(value)}
            placeholder="搜索……"
            value={value}
          />
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          <Button
            color={auto_observe ? 'good' : 'transparent'}
            icon={auto_observe ? 'toggle-on' : 'toggle-off'}
            onClick={() => act('toggle_auto_observe')}
            tooltip="切换完整观察。启用后可查看环绕目标的界面和完整装备。"
            tooltipPosition="bottom-start"
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            color="transparent"
            icon="sync-alt"
            onClick={() => act('refresh')}
            tooltip="刷新"
            tooltipPosition="bottom-start"
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const xenoSplitter = (members: Array<Observable>) => {
  const primeHive: Array<Observable> = [];
  const corruptedHive: Array<Observable> = [];
  const forsakenHive: Array<Observable> = [];
  const otherHives: Array<Observable> = [];

  members.forEach((x) => {
    if (x.hivenumber?.includes('normal')) {
      primeHive.push(x);
    } else if (x.hivenumber?.includes('corrupted')) {
      corruptedHive.push(x);
    } else if (x.hivenumber?.includes('forsaken')) {
      forsakenHive.push(x);
    } else {
      otherHives.push(x);
    }
  });
  const squads = [
    buildSquadObservable('Prime', 'xeno', primeHive),
    buildSquadObservable('Corrupted', 'green', corruptedHive),
    buildSquadObservable('Forsaken', 'grey', forsakenHive),
    buildSquadObservable('Other', 'light-grey', otherHives),
  ];
  return squads;
};

const marineSplitter = (members: Array<Observable>, platoon: string) => {
  const mainPlatoon: Array<Observable> = [];
  const alphaSquad: Array<Observable> = [];
  const bravoSquad: Array<Observable> = [];
  const charlieSquad: Array<Observable> = [];
  const deltaSquad: Array<Observable> = [];
  const foxtrotSquad: Array<Observable> = [];
  const echoSquad: Array<Observable> = [];
  const CBRNSquad: Array<Observable> = [];
  const FORECONSquad: Array<Observable> = [];
  const SOFSquad: Array<Observable> = [];
  const other: Array<Observable> = [];

  members.forEach((x) => {
    if (x.job?.includes(platoon)) {
      mainPlatoon.push(x);
    } else if (x.job?.includes('Alpha')) {
      alphaSquad.push(x);
    } else if (x.job?.includes('Bravo')) {
      bravoSquad.push(x);
    } else if (x.job?.includes('Charlie')) {
      charlieSquad.push(x);
    } else if (x.job?.includes('Delta')) {
      deltaSquad.push(x);
    } else if (x.job?.includes('Foxtrot')) {
      foxtrotSquad.push(x);
    } else if (x.job?.includes('Echo')) {
      echoSquad.push(x);
    } else if (x.job?.includes('CBRN')) {
      CBRNSquad.push(x);
    } else if (x.job?.includes('FORECON')) {
      FORECONSquad.push(x);
    } else if (x.job?.includes('SOF')) {
      SOFSquad.push(x);
    } else {
      other.push(x);
    }
  });

  const squads = [
    buildSquadObservable(platoon, 'blue', mainPlatoon),
    buildSquadObservable('Alpha', 'red', alphaSquad),
    buildSquadObservable('Bravo', 'yellow', bravoSquad),
    buildSquadObservable('Charlie', 'purple', charlieSquad),
    buildSquadObservable('Delta', 'blue', deltaSquad),
    buildSquadObservable('Foxtrot', 'brown', foxtrotSquad),
    buildSquadObservable('Echo', 'teal', echoSquad),
    buildSquadObservable('CBRN', 'dark-blue', CBRNSquad),
    buildSquadObservable('FORECON', 'green', FORECONSquad),
    buildSquadObservable('SOF', 'red', SOFSquad),
    buildSquadObservable('Other', 'grey', other),
  ];
  return squads;
};

const rankList = [
  'Rifleman',
  'Spotter',
  'Hospital Corpsman',
  'Combat Technician',
  'Smartgunner',
  'Weapons Specialist',
  'Fireteam Leader',
  'Squad Leader',
];
const marineSort = (a: Observable, b: Observable) => {
  const a_index = rankList.findIndex((str) => a.job?.includes(str)) ?? 0;
  const b_index = rankList.findIndex((str) => b.job?.includes(str)) ?? 0;
  if (a_index === b_index) {
    return a.full_name.localeCompare(b.full_name);
  }
  return a_index > b_index ? -1 : 1;
};

const GroupedObservable = (props: {
  readonly color?: string;
  readonly section: Array<Observable>;
  readonly title: string;
  readonly splitter: splitter;
  readonly platoon?: string;
  readonly sorter?: groupSorter;
}) => {
  const { color, section = [], title } = props;

  const { value: searchQuery } = useContext(SearchContext);

  if (!section.length) {
    return null;
  }

  const filteredSection = section
    .filter((observable) => isJobOrNameMatch(observable, searchQuery))
    .sort((a, b) =>
      a.full_name
        .toLocaleLowerCase()
        .localeCompare(b.full_name.toLocaleLowerCase()),
    );

  if (!filteredSection.length) {
    return null;
  }

  const squads = props.splitter(filteredSection, props.platoon);

  return (
    <Stack.Item>
      <Collapsible
        bold
        color={color ?? 'grey'}
        open={!!color}
        title={title + ` - (${filteredSection.length})`}
      >
        <Box style={{ paddingLeft: '12px' }}>
          {squads.map((x) => (
            <ObservableSection
              color={x.color}
              title={groupLabel(x.title)}
              section={props.sorter ? x.members.sort(props.sorter) : x.members}
              key={x.title}
            />
          ))}
        </Box>
      </Collapsible>
    </Stack.Item>
  );
};

/**
 * The primary content display for points of interest.
 * Renders a scrollable section replete with subsections for each
 * observable group.
 */
const ObservableContent = () => {
  const { data } = useBackend<OrbitData>();
  const {
    humans = [],
    marines = [],
    survivors = [],
    xenos = [],
    infected = [],
    ert_members = [],
    upp = [],
    clf = [],
    wy = [],
    twe = [],
    freelancer = [],
    mercenary = [],
    contractor = [],
    dutch = [],
    marshal = [],
    synthetics = [],
    predators = [],
    animals = [],
    dead = [],
    ghosts = [],
    misc = [],
    npcs = [],
    vehicles = [],
    escaped = [],
    main_platoon_name,
  } = data;

  return (
    <Stack vertical>
      <GroupedObservable
        color="blue"
        section={marines}
        title="陆战队员"
        splitter={marineSplitter}
        platoon={main_platoon_name}
        sorter={marineSort}
      />
      <ObservableSection color="teal" section={humans} title="人类" />
      <GroupedObservable
        color="xeno"
        section={xenos}
        title="异形"
        splitter={xenoSplitter}
      />
      <ObservableSection color="good" section={survivors} title="幸存者" />
      <ObservableSection color="red" section={infected} title="感染者" />
      <ObservableSection
        color="average"
        section={ert_members}
        title="紧急响应队成员"
      />
      <ObservableSection
        color="light-grey"
        section={synthetics}
        title="合成人"
      />
      <ObservableSection color="green" section={upp} title="进步人民联盟" />
      <ObservableSection color="teal" section={clf} title="殖民地解放阵线" />
      <ObservableSection color="white" section={wy} title="维兰德-汤谷" />
      <ObservableSection color="red" section={twe} title="皇家陆战突击队" />
      <ObservableSection color="orange" section={freelancer} title="自由佣兵" />
      <ObservableSection color="label" section={mercenary} title="雇佣兵" />
      <ObservableSection
        color="light-grey"
        section={contractor}
        title="军事承包商"
      />
      <ObservableSection color="good" section={dutch} title="达奇十二人组" />
      <ObservableSection
        color="dark-blue"
        section={marshal}
        title="殖民地执法局"
      />
      <ObservableSection color="green" section={predators} title="铁血战士" />
      <ObservableSection color="olive" section={escaped} title="已逃生" />
      <ObservableSection section={vehicles} title="载具" />
      <ObservableSection section={animals} title="动物" />
      <ObservableSection section={dead} title="死者" />
      <ObservableSection section={ghosts} title="幽灵" />
      <ObservableSection section={misc} title="其他" />
      <ObservableSection section={npcs} title="非玩家角色" />
    </Stack>
  );
};

/**
 * Displays a collapsible with a map of observable items.
 * Filters the results if there is a provided search query.
 */
const ObservableSection = (props: {
  readonly color?: string;
  readonly section: Array<Observable>;
  readonly title: string;
}) => {
  const { color, section = [], title } = props;

  const { value: searchQuery } = useContext(SearchContext);

  if (!section.length) {
    return null;
  }

  const filteredSection = section
    .filter((observable) => isJobOrNameMatch(observable, searchQuery))
    .sort((a, b) =>
      a.full_name
        .toLocaleLowerCase()
        .localeCompare(b.full_name.toLocaleLowerCase()),
    );

  if (!filteredSection.length) {
    return null;
  }

  return (
    <Stack.Item>
      <Collapsible
        bold
        color={color ?? 'grey'}
        open={!!color}
        title={title + ` - (${filteredSection.length})`}
      >
        {filteredSection.map((poi, index) => {
          return <ObservableItem color={color} item={poi} key={index} />;
        })}
      </Collapsible>
    </Stack.Item>
  );
};

/** Renders an observable button that has tooltip info for living Observables*/
const ObservableItem = (props: {
  readonly color?: string;
  readonly item: Observable;
}) => {
  const { act } = useBackend<OrbitData>();
  const { color, item } = props;
  const { health, icon, full_name, nickname, orbiters, ref, background_color } =
    item;

  const displayHealth = typeof health === 'number';

  return (
    <Button
      color={'transparent'}
      style={{
        borderColor: color ? '#2185d0' : 'grey',
        borderStyle: 'solid',
        borderWidth: '1px',
        color: color ? 'white' : 'grey',
      }}
      onClick={() => act('orbit', { ref: ref })}
      tooltip={displayHealth && <ObservableTooltip item={item} />}
      tooltipPosition="bottom-start"
    >
      {displayHealth && <ColorBox color={getHealthColor(health)} mr="0.5em" />}
      {!!icon && (
        <ObservableIcon icon={icon} background_color={background_color} />
      )}
      {capitalizeFirst(getDisplayName(full_name, nickname))}
      {!!orbiters && (
        <>
          {' '}
          <Icon mr={0} name={'ghost'} />
          {orbiters}
        </>
      )}
    </Button>
  );
};

/** Displays some info on the mob as a tooltip. */
const ObservableTooltip = (props: { readonly item: Observable }) => {
  const {
    item: { caste, health, job, full_name, icon, background_color },
  } = props;

  const displayHealth = typeof health === 'number';
  const healthText = !!health && health >= 0 ? `${health}%` : '危急';

  return (
    <LabeledList>
      {!!full_name && (
        <LabeledList.Item label="全名">{full_name}</LabeledList.Item>
      )}
      {!!caste && (
        <LabeledList.Item label="阶级">
          {!!icon && (
            <ObservableIcon icon={icon} background_color={background_color} />
          )}
          {caste}
        </LabeledList.Item>
      )}
      {!!job && (
        <LabeledList.Item label="职业">
          {!!icon && (
            <ObservableIcon icon={icon} background_color={background_color} />
          )}
          {job}
        </LabeledList.Item>
      )}
      {displayHealth && (
        <LabeledList.Item label="生命值">{healthText}</LabeledList.Item>
      )}
    </LabeledList>
  );
};

/** Generates a small icon for buttons based on ICONMAP */
const ObservableIcon = (props: {
  readonly icon: Observable['icon'];
  readonly background_color: Observable['background_color'];
}) => {
  const { data } = useBackend<OrbitData>();
  const { icons = [] } = data;
  const { icon, background_color } = props;
  if (!icon || !icons[icon]) {
    return null;
  }

  return (
    <Image
      mr={1.3}
      src={`data:image/jpeg;base64,${icons[icon]}`}
      fixBlur
      verticalAlign="middle"
      backgroundColor={background_color ? background_color : undefined}
      style={{
        transform: 'scale(2) translatey(-1px)',
      }}
    />
  );
};
