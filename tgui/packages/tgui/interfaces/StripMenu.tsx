import { range } from 'common/collections';
import { BooleanLike } from 'common/react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, Button, Icon, Image, Stack } from '../components';
import { Window } from '../layouts';

const ROWS = 5;
const COLUMNS = 6;

const BUTTON_DIMENSIONS = '64px';

type GridSpotKey = string;

const getGridSpotKey = (spot: [number, number]): GridSpotKey => {
  return `${spot[0]}/${spot[1]}`;
};

const CornerText = (props: {
  readonly align: 'left' | 'right';
  readonly children: string;
}): JSX.Element => {
  const { align, children } = props;

  return (
    <Box
      className={
        align === 'left'
          ? 'StripMenu__cornertext_left'
          : 'StripMenu__cornertext_right'
      }
    >
      {children}
    </Box>
  );
};

type AlternateAction = {
  icon: string;
  text: string;
};

const ALTERNATE_ACTIONS: Record<string, AlternateAction> = {
  remove_splints: {
    icon: 'crutch',
    text: '移除夹板',
  },

  remove_accessory: {
    icon: 'tshirt',
    text: '取下配饰',
  },

  retrieve_tag: {
    icon: 'tags',
    text: '取出信息牌',
  },

  toggle_internals: {
    icon: 'mask-face',
    text: '切换供气系统',
  },
};

type Slot = {
  displayName: string;
  gridSpot: GridSpotKey;
  image?: string;
  additionalComponent?: JSX.Element;
  hideEmpty?: boolean;
};

const SLOTS: Record<string, Slot> = {
  glasses: {
    displayName: '眼镜',
    gridSpot: getGridSpotKey([0, 1]),
    image: 'inventory-glasses.png',
  },

  head: {
    displayName: '头饰',
    gridSpot: getGridSpotKey([0, 2]),
    image: 'inventory-head.png',
  },

  wear_mask: {
    displayName: '面罩',
    gridSpot: getGridSpotKey([1, 2]),
    image: 'inventory-mask.png',
  },

  wear_r_ear: {
    displayName: '右耳装备',
    gridSpot: getGridSpotKey([0, 3]),
    image: 'inventory-ears.png',
  },

  wear_l_ear: {
    displayName: '左耳装备',
    gridSpot: getGridSpotKey([1, 3]),
    image: 'inventory-ears.png',
  },

  handcuffs: {
    displayName: '手铐',
    gridSpot: getGridSpotKey([1, 4]),
    hideEmpty: true,
  },

  legcuffs: {
    displayName: '脚铐',
    gridSpot: getGridSpotKey([1, 5]),
    hideEmpty: true,
  },

  w_uniform: {
    displayName: '制服',
    gridSpot: getGridSpotKey([2, 1]),
    image: 'inventory-uniform.png',
  },

  wear_suit: {
    displayName: '外套',
    gridSpot: getGridSpotKey([2, 2]),
    image: 'inventory-suit.png',
  },

  gloves: {
    displayName: '手套',
    gridSpot: getGridSpotKey([2, 3]),
    image: 'inventory-gloves.png',
  },

  r_hand: {
    displayName: '右手',
    gridSpot: getGridSpotKey([2, 4]),
    image: 'inventory-hand_r.png',
    additionalComponent: <CornerText align="left">右</CornerText>,
  },

  l_hand: {
    displayName: '左手',
    gridSpot: getGridSpotKey([2, 5]),
    image: 'inventory-hand_l.png',
    additionalComponent: <CornerText align="right">左</CornerText>,
  },

  shoes: {
    displayName: '鞋子',
    gridSpot: getGridSpotKey([3, 2]),
    image: 'inventory-shoes.png',
  },

  j_store: {
    displayName: '外套储物槽',
    gridSpot: getGridSpotKey([4, 0]),
    image: 'inventory-suit_storage.png',
  },

  id: {
    displayName: '身份卡',
    gridSpot: getGridSpotKey([4, 1]),
    image: 'inventory-id.png',
  },

  belt: {
    displayName: '腰带',
    gridSpot: getGridSpotKey([4, 2]),
    image: 'inventory-belt.png',
  },

  back: {
    displayName: '背包',
    gridSpot: getGridSpotKey([4, 3]),
    image: 'inventory-back.png',
  },

  l_store: {
    displayName: '左口袋',
    gridSpot: getGridSpotKey([4, 4]),
    image: 'inventory-pocket.png',
  },

  r_store: {
    displayName: '右口袋',
    gridSpot: getGridSpotKey([4, 5]),
    image: 'inventory-pocket.png',
  },
};

enum ObscuringLevel {
  Completely = 1,
  Hidden = 2,
}

type Interactable = {
  interacting: BooleanLike;
};

/**
 * Some possible options:
 *
 * null - No interactions, no item, but is an available slot
 * { interacting: 1 } - No item, but we're interacting with it
 * { icon: icon, name: name } - An item with no alternate actions
 *   that we're not interacting with.
 * { icon, name, interacting: 1 } - An item with no alternate actions
 *   that we're interacting with.
 */
type StripMenuItem =
  | null
  | Interactable
  | ((
      | {
          icon: string;
          name: string;
          alternate: string;
        }
      | {
          obscured: ObscuringLevel;
        }
      | {
          no_item_action: string;
        }
    ) &
      Partial<Interactable>);

type StripMenuData = {
  items: Record<keyof Slot, StripMenuItem>;
  name: string;
};

const StripContent = (props: { readonly item: StripMenuItem }) => {
  if (props.item && 'name' in props.item) {
    return (
      <Image
        fixBlur
        src={`data:image/jpeg;base64,${props.item.icon}`}
        width={BUTTON_DIMENSIONS}
        height={BUTTON_DIMENSIONS}
        className="StripMenu__contentbox"
      />
    );
  }
  if (props.item && 'obscured' in props.item) {
    return (
      <Icon
        name={
          props.item.obscured === ObscuringLevel.Completely
            ? 'ban'
            : 'eye-slash'
        }
        size={3}
        ml={0}
        mt={1.3}
        className="StripMenu__obscured"
      />
    );
  }
  return <> </>;
};

export const StripMenu = (props) => {
  const { act, data } = useBackend<StripMenuData>();

  const gridSpots = new Map<GridSpotKey, string>();
  for (const key of Object.keys(data.items)) {
    const item = data.items[key];
    if (item === null && SLOTS[key].hideEmpty) continue;
    gridSpots.set(SLOTS[key].gridSpot, key);
  }

  return (
    <Window title={`查看${data.name}的装备`} width={430} height={400}>
      <Window.Content>
        <Stack fill vertical>
          {range(0, ROWS).map((row) => (
            <Stack.Item key={row}>
              <Stack fill>
                {range(0, COLUMNS).map((column) => {
                  const key = getGridSpotKey([row, column]);
                  const keyAtSpot = gridSpots.get(key);

                  if (!keyAtSpot) {
                    return (
                      <Stack.Item
                        key={key}
                        width={BUTTON_DIMENSIONS}
                        height={BUTTON_DIMENSIONS}
                      />
                    );
                  }

                  const item = data.items[keyAtSpot];
                  const slot = SLOTS[keyAtSpot];

                  let alternateAction: AlternateAction | undefined;

                  let content;
                  let tooltip;

                  if (item === null) {
                    tooltip = slot.displayName;
                  } else if ('name' in item) {
                    alternateAction = ALTERNATE_ACTIONS[item.alternate];
                    tooltip = item.name;
                  } else if ('obscured' in item) {
                    tooltip = `被遮挡的${slot.displayName}`;
                  } else if ('no_item_action' in item) {
                    tooltip = slot.displayName;
                    alternateAction = ALTERNATE_ACTIONS[item.no_item_action];
                  }

                  return (
                    <Stack.Item
                      key={key}
                      style={{
                        width: BUTTON_DIMENSIONS,
                        height: BUTTON_DIMENSIONS,
                      }}
                    >
                      <Box className="StripMenu__itembox">
                        <Button
                          onClick={() => {
                            if (item === null || 'no_item_action' in item) {
                              act('equip', {
                                key: keyAtSpot,
                              });
                            } else {
                              act('strip', {
                                key: keyAtSpot,
                              });
                            }
                          }}
                          fluid
                          tooltip={tooltip}
                          className="StripMenu__itembutton"
                          style={{
                            background: item?.interacting
                              ? 'hsl(39, 73%, 30%)'
                              : undefined,
                          }}
                        >
                          {slot.image && (
                            <Image
                              src={resolveAsset(slot.image)}
                              fixBlur
                              className="StripMenu__itemslot"
                            />
                          )}
                          {item && <StripContent item={item} />}
                          {slot.additionalComponent}
                        </Button>

                        {alternateAction !== undefined && (
                          <Button
                            onClick={() => {
                              act('alt', {
                                key: keyAtSpot,
                              });
                            }}
                            tooltip={alternateAction.text}
                            className="StripMenu__alternativeaction"
                          >
                            <Icon name={alternateAction.icon} />
                          </Button>
                        )}
                      </Box>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};
