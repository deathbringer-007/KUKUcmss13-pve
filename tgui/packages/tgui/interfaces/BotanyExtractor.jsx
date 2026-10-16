import { Fragment } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const BotanyExtractor = () => {
  const { act, data } = useBackend();

  const { disk, seed, geneMasks, degradation, hasGenetics, sourceName } = data;

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
                {disk ? '取出' + disk : '取出磁盘'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!seed}
                onClick={() => act('eject_packet')}
              >
                {seed ? '取出' + seed : '取出种子包'}
              </Button>
            </Stack.Item>
            {!!seed && (
              <Stack.Item>
                <Button.Confirm
                  fluid
                  icon="industry"
                  confirmContent="确定吗？这会销毁种子。"
                  disabled={!seed}
                  onClick={() => act('scan_genome')}
                >
                  {'处理' + seed + '的基因组'}
                </Button.Confirm>
              </Stack.Item>
            )}
          </Stack>
        </Section>
        <Section title="暂存基因数据">
          {(!!hasGenetics && (
            <>
              {!disk && (
                <NoticeBox danger>
                  未插入磁盘，无法提取基因数据。
                </NoticeBox>
              )}
              {degraded && (
                <NoticeBox danger>
                  基因数据退化严重，无法提取！
                </NoticeBox>
              )}
              <LabeledList>
                <LabeledList.Item label="来源">{sourceName}</LabeledList.Item>
                <LabeledList.Item label="基因退化">
                  {!degraded ? degradation + '%' : '#!错误%'}
                </LabeledList.Item>
                {geneMasks.map((entry) => {
                  return (
                    <LabeledList.Item label={entry.mask} key={entry}>
                      <Button
                        icon="download"
                        disabled={!disk || degraded}
                        onClick={() => act('get_gene', { gene: entry.tag })}
                      >
                        提取基因
                      </Button>
                    </LabeledList.Item>
                  );
                })}
              </LabeledList>
              <Box height="10px" />
              <Button.Confirm
                fluid
                icon="snowplow"
                disabled={!hasGenetics}
                onClick={() => act('clear_buffer')}
              >
                清空暂存区
              </Button.Confirm>
            </>
          )) || <NoticeBox danger>没有储存的基因数据！</NoticeBox>}
        </Section>
      </Window.Content>
    </Window>
  );
};
