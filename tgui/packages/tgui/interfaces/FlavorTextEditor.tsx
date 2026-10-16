import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Section, Stack, Tabs, TextArea } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  general: string;
  head: string;
  face: string;
  eyes: string;
  torso: string;
  arms: string;
  hands: string;
  legs: string;
  feet: string;
  helmet: string;
  armor: string;
  categories: Array<string>;
};

const flavorCategoryLabels: Record<string, string> = {
  general: '整体',
  head: '头部',
  face: '面部',
  eyes: '眼睛',
  torso: '躯干',
  arms: '手臂',
  hands: '双手',
  legs: '腿部',
  feet: '双脚',
  helmet: '头盔',
  armor: '护甲',
};

export const FlavorTextEditor = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    general,
    head,
    face,
    eyes,
    torso,
    arms,
    hands,
    legs,
    feet,
    helmet,
    armor,
    categories,
  } = data;
  const [category, setCategory] = useState('general');
  const [flavorText, setFlavorText] = useState(general);
  const [buffer, setBuffer] = useState(general);
  const changeCategory = (category, text) => {
    setCategory(category);
    setFlavorText(text);
    setBuffer(text);
  };

  const save = (buffer, category, flavorText) => {
    setFlavorText(buffer);
    act('set_flavor_text', {
      category: category,
      text: buffer,
    });
  };

  return (
    <Window width={800} height={500} theme="crtblue">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Tabs fluid pr="0" pl="0" mb="0" fontSize="16px">
              {data.categories.map((iterateCategory, index) => {
                return (
                  <Tabs.Tab
                    key={index}
                    selected={category === categories[index]}
                    onClick={() =>
                      changeCategory(categories[index], data[categories[index]])
                    }
                  >
                    {flavorCategoryLabels[categories[index]] || categories[index]}
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Stack.Item>
          <Section
            fill
            title={
              '编辑' +
              (flavorCategoryLabels[category] || category) +
              '描述（Shift+Enter 换行）'
            }
            buttons={
              <>
                <Button
                  icon="floppy-disk"
                  onClick={() => save(buffer, category, flavorText)}
                >
                  保存
                </Button>
                <Button icon="undo" onClick={() => setBuffer(flavorText)}>
                  撤销修改
                </Button>
              </>
            }
          >
            <TextArea
              scrollbar
              height="100%"
              fontSize="13px"
              value={buffer}
              onChange={(e, value) => setBuffer(value)}
            />
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};
