import { Fragment } from 'react';

import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const BotanyEditor = () => {
  const { act, data } = useBackend();

  const { disk, seed, degradation, sourceName, locus } = data;

  const degraded = degradation >= 100;

  return (
    <Window width={400} height={450} theme="weyland">
      <Window.Content scrollable>
        <Section>
          <Stack fill vertical>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!disk}
                onClick={() => act('eject_disk')}
              >
                {disk ? '弹出' + disk : '弹出磁盘'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!seed}
                onClick={() => act('eject_packet')}
              >
                {seed ? '弹出' + seed : '弹出目标种子'}
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="已缓存的遗传数据">
          <>
            {!disk && (
              <NoticeBox danger>
                未插入磁盘！无法应用遗传数据。
              </NoticeBox>
            )}
            {!seed && (
              <NoticeBox danger>没有可供应用遗传数据的种子！</NoticeBox>
            )}
          </>
          {!!disk && (
            <LabeledList>
              <LabeledList.Item label="来源">{sourceName}</LabeledList.Item>
              <LabeledList.Item label="基因座">{locus}</LabeledList.Item>
            </LabeledList>
          )}
        </Section>
        {!!seed && (
          <Section title="来源材料">
            {degraded && (
              <NoticeBox danger>遗传数据损坏严重，无法编辑！</NoticeBox>
            )}
            <LabeledList>
              <LabeledList.Item label="目标">{seed}</LabeledList.Item>
              <LabeledList.Item label="基因退化程度">
                {!degraded ? degradation + '%' : '#!错误%'}
              </LabeledList.Item>
              <LabeledList.Item>
                <Button
                  fluid
                  icon="download"
                  disabled={!seed || degraded}
                  onClick={() => act('apply_gene')}
                >
                  应用基因改造
                </Button>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
