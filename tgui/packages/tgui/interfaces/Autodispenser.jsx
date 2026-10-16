import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const Autodispenser = () => {
  const { act, data } = useBackend();
  const {
    energy,
    status,
    error,
    multiplier,
    cycle_limit,
    automode,
    networked_storage,
    smartlink,
    outputmode,
    buffervolume,
    buffermax,
    output_container,
    output_totalvol,
    output_maxvol,
    output_color,
    input_container,
    memory,
    box,
  } = data;

  const energyPct = energy / 100;
  const outputPct = output_totalvol / output_maxvol;

  const memoryEmpty = memory === 'Empty';
  const boxEmpty = box === 'Empty';

  let statusmessage = '错误';

  switch (status) {
    case 0:
      statusmessage = '待机';
      break;
    case 1:
      statusmessage = '运行中';
      break;
    case 2:
      statusmessage = '已完成';
      break;
  }

  let outputmessage = '错误';
  let outputicon;

  switch (outputmode) {
    case 0:
      outputmessage = '容器';
      outputicon = 'flask';
      break;
    case 1:
      outputmessage = '智能冰箱';
      outputicon = 'box';
      break;
    case 2:
      outputmessage = '离心机';
      outputicon = 'industry';
      break;
  }

  return (
    <Window width={600} height={600} theme="weyland">
      <Window.Content scrollable>
        <Flex direction="row">
          <Flex.Item grow>
            <Section title="图灵自动配药机控制">
              <ProgressBar
                width="100%"
                value={energyPct}
                ranges={{
                  bad: [-Infinity, 0.1],
                  average: [0.1, 0.33],
                  good: [0.33, Infinity],
                }}
              >
                <Box textAlign="right">能量：{energy}%</Box>
              </ProgressBar>
              <Box height="5px" />
              <NoticeBox color={error ? 'red' : null}>
                状态：{statusmessage} {error ? error : null}
              </NoticeBox>
              <Button.Confirm
                icon="trash"
                fluid
                disabled={memoryEmpty}
                onClick={() => act('clearmemory')}
              >
                清空存储程序
              </Button.Confirm>
              <Button
                icon="play"
                tooltip={
                  memoryEmpty
                    ? !boxEmpty
                      ? '将按试管盒中的程序运行。'
                      : !output_container && outputmode === 0
                        ? '未装入接收烧杯！'
                        : '未装入试管盒，也未保存程序！'
                    : '将运行已保存的程序。'
                }
                fluid
                disabled={
                  (memoryEmpty && boxEmpty) ||
                  (!output_container && outputmode === 0)
                }
                onClick={() => act('runprogram')}
              >
                运行程序
              </Button>
              <Box height="5px" />
              <NoticeBox color={input_container ? null : 'red'}>
                {input_container
                  ? '输入试管盒：' + input_container
                  : '未装入输入试管盒！'}
              </NoticeBox>
              {(!memoryEmpty && (
                <Button.Confirm
                  tooltip="将覆盖当前保存的试管盒程序"
                  icon="floppy-disk"
                  fluid
                  disabled={!input_container}
                  onClick={() => act('saveprogram')}
                >
                  保存试管盒程序
                </Button.Confirm>
              )) || (
                <Button
                  icon="floppy-disk"
                  fluid
                  disabled={!input_container}
                  onClick={() => act('saveprogram')}
                >
                  保存试管盒程序
                </Button>
              )}
              <Button
                icon="eject"
                fluid
                disabled={!input_container}
                onClick={() => act('ejectI')}
              >
                取出试管盒
              </Button>
              <Box height="5px" />
              {outputmode === 0 && (
                <NoticeBox color={output_container ? null : 'red'}>
                  {output_container
                    ? '接收容器：' + output_container + '。'
                    : '未装入接收烧杯！'}
                </NoticeBox>
              )}
              {outputmode === 1 && (
                <NoticeBox>
                  {networked_storage && smartlink
                    ? '装瓶后送入联网智能冰箱。'
                    : '装瓶后送入智能冰箱。'}
                </NoticeBox>
              )}
              {outputmode === 2 && (
                <NoticeBox>
                  {status === 2
                    ? '输出至内部暂存槽：' +
                      buffervolume +
                      'u / ' +
                      buffermax +
                      'u.'
                    : '等待离心机。'}
                </NoticeBox>
              )}
              {output_container && outputmode === 0 && (
                <>
                  <ProgressBar
                    width="100%"
                    value={outputPct}
                    color={output_color ? output_color : 'blue'}
                  >
                    <Box textAlign="right">
                      烧杯容量：{output_totalvol}u/{output_maxvol}u
                    </Box>
                  </ProgressBar>
                  <Box height="5px" />
                </>
              )}
              {outputmode === 0 && (
                <Button.Confirm
                  tooltip={
                    output_container
                      ? '这将清空' + output_container + '中的内容物。'
                      : null
                  }
                  icon="trash"
                  fluid
                  disabled={!output_container}
                  onClick={() => act('dispose')}
                >
                  清空烧杯
                </Button.Confirm>
              )}
              {(output_container || outputmode === 0) && (
                <Button
                  icon="eject"
                  fluid
                  disabled={!output_container}
                  onClick={() => act('ejectO')}
                >
                  取出烧杯
                </Button>
              )}
            </Section>
            <Section title="设置">
              <LabeledList>
                <LabeledList.Item label="配药倍数">
                  <NumberInput
                    width="4em"
                    step={0.1}
                    minValue={0.1}
                    maxValue={10}
                    value={multiplier}
                    onChange={(value) =>
                      act('set_multiplier', { set_multiplier: `${value}` })
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="执行次数">
                  <NumberInput
                    width="4em"
                    step={1}
                    minValue={1}
                    maxValue={100}
                    value={cycle_limit}
                    onChange={(value) =>
                      act('set_cycles', { set_cycles: `${value}` })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
              <Box height="5px" />
              <Button
                icon={automode ? 'repeat' : 'dice-one'}
                fluid
                onClick={() => act('toggleauto')}
              >
                {'自动运行：' + (automode ? '已启用' : '已禁用')}
              </Button>
              <Button
                icon={smartlink ? 'link' : 'link-slash'}
                fluid
                onClick={() => act('togglesmart')}
              >
                {'智能联动：' + (smartlink ? '已启用' : '已禁用')}
              </Button>
              <Button
                icon={outputicon}
                fluid
                onClick={() => act('toggleoutput')}
              >
                {'输出至：' + outputmessage}
              </Button>
            </Section>
          </Flex.Item>
          <Flex.Item>
            <Box width="5px" />
          </Flex.Item>
          <Flex.Item grow>
            <Section title="已保存的程序">
              {(!memoryEmpty && (
                <Flex direction="column">
                  {Object.keys(memory).map((entry) => (
                    <Flex.Item key={entry}>
                      <Box>
                        {memory[entry]['name']}, {memory[entry]['amount']}u
                      </Box>
                    </Flex.Item>
                  ))}
                </Flex>
              )) || <NoticeBox danger>尚未保存程序！</NoticeBox>}
            </Section>
            <Section title="试管盒程序">
              {(!boxEmpty && (
                <Flex direction="column">
                  {Object.keys(box).map((entry) => (
                    <Flex.Item key={entry}>
                      <Box>
                        {box[entry]['name']}, {box[entry]['amount']}u
                      </Box>
                    </Flex.Item>
                  ))}
                </Flex>
              )) || <NoticeBox danger>未装入试管盒！</NoticeBox>}
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
