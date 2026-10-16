import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Flex, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

type Ingredient = {
  name: string;
  count: number;
  measure: string;
};

type BackendContext = {
  operating: BooleanLike;
  broken: BooleanLike;
  dirty: BooleanLike;
  ingredients: Ingredient[];
};

export const Microwave = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const { operating, broken, dirty, ingredients } = data;

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        <Section
          fill
          title="食材"
          buttons={
            <Flex>
              <Button
                height="100%"
                icon="power-off"
                disabled={!!operating || !!dirty || !!broken}
                onClick={() => act('cook')}
              >
                启动
              </Button>

              <Button
                height="100%"
                icon="eject"
                disabled={!ingredients.length || !!operating}
                onClick={() => act('eject_all')}
              >
                全部取出
              </Button>
            </Flex>
          }
        >
          {!!operating && (
            <NoticeBox
              width="100%"
              textAlign="center"
              p=".5rem"
              fontSize="1.5rem"
            >
              正在烹饪……
            </NoticeBox>
          )}

          {!!broken && (
            <NoticeBox danger width="100%" textAlign="center" p="1rem">
              设备已损坏，请联系技术人员。
            </NoticeBox>
          )}

          {!!dirty && (
            <NoticeBox danger width="100%" textAlign="center" p="1rem">
              微波炉太脏了，需要清洁。
            </NoticeBox>
          )}

          {!ingredients.length && <Box>无</Box>}

          <Flex direction="column">
            {ingredients.map((ingredient) => {
              return (
                <Flex.Item key={ingredient.name} py=".2rem">
                  <b>{ingredient.name}</b>: {ingredient.count}{' '}
                  {ingredient.measure}
                </Flex.Item>
              );
            })}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
