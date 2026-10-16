import { useState } from 'react';

import { useBackend } from '../backend';
import { Flex, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const StatbrowserOptions = (props) => {
  const { act, data } = useBackend();
  const { current_fontsize } = data;
  const [fontsize, setFontsize] = useState(current_fontsize);

  return (
    <Window title="状态面板选项" width={300} height={120}>
      <Window.Content>
        <Options>
          <NumberOption
            category="字号"
            value={fontsize}
            minValue={10}
            maxValue={30}
            step={0.5}
            format={(value) => value + 'px'}
            onChange={(value) => {
              setFontsize(value);
              act('change_fontsize', { new_fontsize: value });
            }}
          />
        </Options>
      </Window.Content>
    </Window>
  );
};

const Options = (props) => {
  const { children } = props;

  return (
    <Section title="选项">
      <Flex spacing={16 * 2}>
        {!Array.isArray(children)
          ? children
          : children.map((option, i) => (
              <Flex.Item key={i}>{option}</Flex.Item>
            ))}
      </Flex>
    </Section>
  );
};

const Option = (props) => {
  const { category, input } = props;

  return (
    <Flex>
      <Flex.Item mr="5px">{category}</Flex.Item>
      <Flex.Item>{input}</Flex.Item>
    </Flex>
  );
};

const NumberOption = (props) => {
  const { category, ...rest } = props;

  return <Option category={category} input={<NumberInput {...rest} />} />;
};
