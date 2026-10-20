import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, Input, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

const categoryLabels = new Map([
  ['Uncategorised', '未分类'],
  ['Marine', '陆战队员'],
  ['Soldier', '士兵'],
  ['IO', '情报官'],
]);

export const PhoneMenu = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={500} height={400}>
      <Window.Content>
        <GeneralPanel />
      </Window.Content>
    </Window>
  );
};

const GeneralPanel = (props) => {
  const { act, data } = useBackend();
  const { availability, last_caller, last_caller_display } = data;
  const available_transmitters = Object.keys(data.available_transmitters);
  const transmitters = data.transmitters.filter((val1) =>
    available_transmitters.includes(val1.phone_id),
  );

  const categoryDisplayNames = new Map(
    transmitters.map((phone) => [
      phone.phone_category,
      phone.display_phone_category,
    ]),
  );
  const categories = [];
  for (let i = 0; i < transmitters.length; i++) {
    let data = transmitters[i];
    if (categories.includes(data.phone_category)) continue;

    categories.push(data.phone_category);
  }

  const [currentSearch, setSearch] = useState('');
  const [selectedPhone, setSelectedPhone] = useState(null);
  const [currentCategory, setCategory] = useState(categories[0]);

  let dnd_tooltip = '勿扰模式已关闭';
  let dnd_locked = 'No';
  let dnd_icon = 'volume-high';
  if (availability === 1) {
    dnd_tooltip = '勿扰模式已开启';
    dnd_icon = 'volume-xmark';
  } else if (availability >= 2) {
    dnd_tooltip = '勿扰模式已开启（已锁定）';
    dnd_locked = 'Yes';
    dnd_icon = 'volume-xmark';
  } else if (availability < 0) {
    dnd_tooltip = '勿扰模式已关闭（已锁定）';
    dnd_locked = 'Yes';
  }

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Tabs>
            {categories.map((val) => (
              <Tabs.Tab
                selected={val === currentCategory}
                onClick={() => setCategory(val)}
                key={val}
              >
                {categoryDisplayNames.get(val) ?? categoryLabels.get(val) ?? val}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          <Input
            fluid
            value={currentSearch}
            placeholder="搜索电话"
            onInput={(e, value) => setSearch(value.toLowerCase())}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Section fill scrollable>
            <Tabs vertical>
              {transmitters.map((val) => {
                if (
                  !currentSearch.includes('\\') &&
                  (val.phone_category !== currentCategory ||
                    !(
                      val.phone_id.toLowerCase().match(currentSearch) ||
                      (val.display_phone_id || val.phone_id)
                        .toLowerCase()
                        .match(currentSearch)
                    ))
                ) {
                  return;
                }
                return (
                  <Tabs.Tab
                    selected={selectedPhone === val.phone_id}
                    onClick={() => {
                      if (selectedPhone === val.phone_id) {
                        act('call_phone', { phone_id: selectedPhone });
                      } else {
                        setSelectedPhone(val.phone_id);
                      }
                    }}
                    key={val.phone_id}
                    color={val.phone_color}
                    onFocus={() =>
                      document.activeElement
                        ? document.activeElement.blur()
                        : false
                    }
                    icon={val.phone_icon}
                  >
                    {val.display_phone_id || val.phone_id}
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Section>
        </Stack.Item>
        {!!selectedPhone && (
          <Stack.Item>
            <Button
              color="good"
              fluid
              textAlign="center"
              onClick={() => act('call_phone', { phone_id: selectedPhone })}
            >
              拨号
            </Button>
          </Stack.Item>
        )}
        {!!last_caller && (
          <Stack.Item>上次来电：{last_caller_display || last_caller}</Stack.Item>
        )}
        <Stack.Item>
          <Button
            color="red"
            tooltip={dnd_tooltip}
            disabled={dnd_locked === 'Yes'}
            icon={dnd_icon}
            fluid
            textAlign="center"
            onClick={() => act('toggle_dnd')}
          >
            勿扰模式
          </Button>
        </Stack.Item>
        {data.virtual_phone && (
          <Stack.Item>
            <Stack vertical fill>
              <Stack.Item>
                <Section
                  title={
                    data.calling_phone_display ||
                    data.calling_phone_id ||
                    '电话控制'
                  }
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="good"
                  fluid
                  textAlign="center"
                  disabled={!data.being_called}
                  onClick={() => act('pick_up')}
                >
                  接听
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="red"
                  fluid
                  textAlign="center"
                  disabled={!data.active_call}
                  onClick={() => act('hang_up')}
                >
                  挂断
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};
