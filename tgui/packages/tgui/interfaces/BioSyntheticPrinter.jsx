import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const BioSyntheticPrinter = () => {
  const { act, data } = useBackend();

  const Working = data.working;

  const PrintingPct =
    1 - (data.printtime - data.worldtime) / data.printingitemtime;

  const recipes = data.recipes;

  return (
    <Window width={400} height={320}>
      <Window.Content scrollable>
        <Section
          title="金属储量"
          buttons={
            <Button
              onClick={() => act('eject')}
              disabled={data.metal_amt < 100}
            >
              全部取出
            </Button>
          }
        >
          <ProgressBar value={data.metal_amt} maxValue={data.metal_max}>
            <Box textAlign="center">
              已存金属：{data.metal_amt}/{data.metal_max}
            </Box>
          </ProgressBar>
        </Section>
        <Section title="肢体" grow>
          {!!Working && (
            <Box>
              <NoticeBox>正在打印： {data.printingitem}</NoticeBox>
              <ProgressBar value={PrintingPct} />
              <Divider />
            </Box>
          )}

          <LabeledList vertical>
            {recipes.map((val) => {
              return (
                <LabeledList.Item
                  key={val.recipe_id}
                  label={val.name}
                  onFocus={() =>
                    document.activeElement
                      ? document.activeElement.blur()
                      : false
                  }
                  buttons={
                    <Button
                      color="good"
                      disabled={data.metal_amt < val.metal || !!Working}
                      textAlign="center"
                      onClick={() => act('print', { recipe_id: val.recipe_id })}
                    >
                      打印
                    </Button>
                  }
                >
                  <Box>
                    {val.metal} 金属，{val.time / 10} 秒
                  </Box>
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
