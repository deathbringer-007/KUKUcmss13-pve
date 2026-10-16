import { useBackend } from '../backend';
import { Button, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';

export const TechNode = (props) => {
  const { act, data } = useBackend();

  const {
    total_points,
    can_afford,
    valid_tier,
    unlocked,
    theme,
    cost,
    name,
    desc,
    stats,
  } = data;

  return (
    <Window width={500} height={300} theme={theme}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Section
              title="信息"
              fill
              buttons={
                <Button backgroundColor="transparent">
                  {'科技点数：' + total_points}
                </Button>
              }
            >
              <LabeledList>
                <LabeledList.Item label="名称">{name}</LabeledList.Item>
                <LabeledList.Item label="说明">{desc}</LabeledList.Item>
                <LabeledList.Item label="费用">{cost}</LabeledList.Item>

                {!!stats && (
                  <LabeledList.Item label="属性">
                    {stats.map((stat, i) => (
                      <Button
                        key={i}
                        color={stat.color}
                        icon={stat.icon}
                        tooltip={stat.tooltip}
                        mr="100%"
                      >
                        {stat.content}
                      </Button>
                    ))}
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Button
                color="green"
                textAlign="center"
                width="100%"
                p=".5rem"
                disabled={!can_afford || !valid_tier || unlocked ? true : false}
                tooltip={
                  unlocked
                    ? '已经解锁'
                    : !valid_tier
                      ? '尚未解锁该科技等级'
                      : !can_afford
                        ? '科技点数不足'
                        : ''
                }
                onClick={() => act('purchase')}
              >
                购买
              </Button>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
