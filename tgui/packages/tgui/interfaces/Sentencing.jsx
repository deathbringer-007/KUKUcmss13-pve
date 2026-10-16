import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Section, Tabs } from '../components';
import { Window } from '../layouts';

const PAGES = {
  main: () => MainMenu,
  incident_report: () => NewReport,
  new_charge: () => NewCharge,
};

export const Sentencing = (props) => {
  const { data } = useBackend();
  const { current_menu } = data;
  const PageComponent = PAGES[current_menu]();

  return (
    <Window theme="weyland" width={780} height={725}>
      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const MainMenu = (props) => {
  const { act } = useBackend();

  return (
    <Flex
      direction="column"
      justify="center"
      align="center"
      height="100%"
      color="darkgrey"
      fontSize="2rem"
      mt="-3rem"
      bold
    >
      <Box fontFamily="monospace">司法自动化系统</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS 执行程序
      </Box>
      <Box fontFamily="monospace">版本 5.8.4</Box>
      <Box fontFamily="monospace">版权所有 © 2182，维兰德-汤谷公司。</Box>

      <Button
        width="30vw"
        textAlign="center"
        fontSize="1.5rem"
        p="1rem"
        mt="5rem"
        onClick={() => act('new_report')}
      >
        新建报告
      </Button>
      <Box fontSize="2rem" mt="1rem">
        或
      </Box>
      <Box fontSize="1.5rem" mt="1rem">
        扫描现有报告
      </Box>
    </Flex>
  );
};

const NewReport = (props) => {
  const { data, act } = useBackend();
  const { suspect_name, summary, sentence, current_charges } = data;
  const canExport = suspect_name && current_charges.length;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button.Confirm
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="删除报告"
            onClick={() => act('scrap_report')}
          />

          <h1>事件报告</h1>

          <Button
            icon="print"
            ml="auto"
            px="2rem"
            bold
            tooltip={canExport ? '' : '缺少嫌疑人或指控'}
            disabled={!canExport}
            onClick={() => act('export')}
          >
            导出
          </Button>
        </Flex>
      </Section>
      <Section>
        <LabeledList>
          <LabeledList.Item label="嫌疑人">
            <Button
              icon="pen"
              bold
              tooltip="请手持身份卡"
              onClick={() => act('set_suspect')}
            >
              {suspect_name}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="刑期">
            {sentence !== '0 minutes'
              ? sentence === 'PERMA BRIGGED'
                ? '永久监禁'
                : sentence.replace(' minutes', ' 分钟')
              : '--'}
          </LabeledList.Item>
          <LabeledList.Item label="摘要">
            <Button icon="pen" onClick={() => act('edit_summary')} />
          </LabeledList.Item>
        </LabeledList>
        <Box mt=".5rem" italic>
          {summary}
        </Box>
      </Section>

      <Charges />

      <Evidence />
    </>
  );
};

const NewCharge = (props) => {
  const { data, act } = useBackend();
  const { laws } = data;
  const [chargeCategory, setChargeCategory] = useState(0);

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            onClick={() => act('set_menu', { new_menu: 'incident_report' })}
          />
          <h1>新增指控</h1>
        </Flex>
      </Section>
      <Section>
        <Tabs fluid textAlign="center">
          {laws.map((category, i) => (
            <Tabs.Tab
              key={i}
              selected={i === chargeCategory}
              onClick={() => setChargeCategory(i)}
            >
              {category.label}
            </Tabs.Tab>
          ))}
        </Tabs>

        <Section>
          {laws[chargeCategory].laws.map((law, i) => (
            <Section key={i} title={law.name}>
              <Box mb=".75rem" italic>
                {law.desc}
              </Box>
              <LabeledList>
                <LabeledList.Item label="刑期">
                  {law.brig_time} 分钟
                </LabeledList.Item>
                {law.special_punishment && (
                  <LabeledList.Item label="附加处罚">
                    {law.special_punishment}
                  </LabeledList.Item>
                )}
              </LabeledList>
              <Button
                bold
                mt="1rem"
                onClick={() => act('new_charge', { law: law.ref })}
              >
                添加指控
              </Button>
            </Section>
          ))}
        </Section>
      </Section>
    </>
  );
};

const Charges = (props) => {
  const { data, act } = useBackend();
  const { current_charges } = data;

  return (
    <Section title="指控">
      <Flex direction="column">
        {!!current_charges.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="9rem" shrink="0" mr="1rem">
              罪名
            </Flex.Item>
            <Flex.Item grow bold>
              说明
            </Flex.Item>
            <Flex.Item
              width="10rem"
              shrink="0"
              textAlign="right"
              pr="3rem"
              bold
            >
              附加处罚
            </Flex.Item>
          </Flex>
        )}
        {current_charges.map((charge, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="9rem" shrink="0" mr="1rem">
                {charge.name}
              </Flex.Item>
              <Flex.Item grow italic>
                {charge.desc}
              </Flex.Item>
              <Flex.Item width="9rem" ml="1rem" shrink="0" textAlign="right">
                {charge.special_punishment}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button
                  icon="trash"
                  onClick={() => act('remove_charge', { charge: charge.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
        <Flex justify="center" mt=".75rem">
          <Button
            px="2rem"
            py=".25rem"
            mb=".5rem"
            bold
            onClick={() => act('set_menu', { new_menu: 'new_charge' })}
          >
            新增指控
          </Button>
        </Flex>
      </Flex>
    </Section>
  );
};

const Evidence = (props) => {
  const { data, act } = useBackend();
  const { witnesses, evidence } = data;

  return (
    <Section title="证据">
      <Flex>
        {/* Witnesses */}
        <Flex direction="column" width="50%">
          {witnesses.map((witness, i) => (
            <Flex
              key={i}
              className="candystripe"
              p=".75rem"
              mb=".75rem"
              align="center"
            >
              <Flex direction="column" align="middle" width="100%">
                <Flex.Item bold mb=".5rem">
                  {witness.name}
                </Flex.Item>

                <Flex.Item italic>{witness.notes}</Flex.Item>
              </Flex>

              <Flex
                direction="column"
                width="2.5rem"
                textAlign="center"
                ml="1rem"
              >
                <Button
                  icon="pen"
                  width="100%"
                  onClick={() =>
                    act('edit_witness_notes', { witness: witness.ref })
                  }
                />
                <Button
                  icon="trash"
                  width="100%"
                  onClick={() =>
                    act('remove_witness', { witness: witness.ref })
                  }
                />
              </Flex>
            </Flex>
          ))}
          <Button
            textAlign="center"
            bold
            width="50%"
            mx="auto"
            py=".25rem"
            tooltip="请手持身份卡"
            onClick={() => act('add_witness')}
          >
            添加证人
          </Button>
        </Flex>

        {/* Objects */}
        <Flex direction="column" width="50%">
          {evidence.map((evidence, i) => (
            <Flex
              key={i}
              className="candystripe"
              p=".75rem"
              mb=".75rem"
              align="center"
            >
              <Flex direction="column" align="middle" width="100%">
                <Flex.Item bold mb=".5rem">
                  {evidence.name}
                </Flex.Item>

                <Flex.Item italic>{evidence.notes}</Flex.Item>
              </Flex>

              <Flex
                direction="column"
                width="2.5rem"
                textAlign="center"
                ml="1rem"
              >
                <Button
                  icon="pen"
                  width="100%"
                  onClick={() =>
                    act('edit_evidence_notes', { evidence: evidence.ref })
                  }
                />
                <Button
                  icon="trash"
                  width="100%"
                  onClick={() =>
                    act('remove_evidence', { evidence: evidence.ref })
                  }
                />
              </Flex>
            </Flex>
          ))}
          <Button
            textAlign="center"
            bold
            width="50%"
            mx="auto"
            py=".25rem"
            tooltip="请手持物品"
            onClick={() => act('add_evidence')}
          >
            添加证物
          </Button>
        </Flex>
      </Flex>
    </Section>
  );
};
