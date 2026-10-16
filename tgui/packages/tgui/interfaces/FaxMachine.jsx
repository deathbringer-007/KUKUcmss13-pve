import { Fragment } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const FaxMachine = () => {
  const { act, data } = useBackend();
  const { idcard } = data;
  const body = idcard ? <FaxMain /> : <FaxEmpty />;
  const windowWidth = idcard ? 600 : 400;
  const windowHeight = idcard ? 270 : 215;

  return (
    <Window width={windowWidth} height={windowHeight} theme="weyland">
      <Window.Content>{body}</Window.Content>
    </Window>
  );
};

const FaxMain = (props) => {
  return (
    <>
      <FaxId />
      <FaxSelect />
    </>
  );
};

const FaxId = (props) => {
  const { act, data } = useBackend();
  const { department, network, idcard, authenticated } = data;
  return (
    <Section title="身份验证">
      <NoticeBox color="grey" textAlign="center">
        本机当前使用{network}
        <br />
        发送部门为{department}。
      </NoticeBox>
      <Stack>
        <Stack.Item>
          <Button icon="eject" mb="0" onClick={() => act('ejectid')}>
            {idcard}
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          <Button
            icon="sign-in-alt"
            fluid
            selected={authenticated}
            onClick={() => act(authenticated ? 'logout' : 'auth')}
          >
            {authenticated ? '退出登录' : '登录'}
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FaxSelect = (props) => {
  const { act, data } = useBackend();
  const {
    paper,
    paper_name,
    authenticated,
    target_department,
    worldtime,
    nextfaxtime,
    faxcooldown,
  } = data;

  const timeLeft = nextfaxtime - worldtime;

  return (
    <Section title="部门选择">
      <Stack>
        <Stack.Item>
          <Button
            icon="list"
            disabled={!authenticated}
            onClick={() => act('select')}
          >
            选择收件部门
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          <Button icon="building" fluid disabled={!authenticated}>
            {'当前收件部门：' + target_department + '。'}
          </Button>
        </Stack.Item>
      </Stack>
      <Box width="600px" height="5px" />
      <Stack>
        <Stack.Item>
          <Button
            icon="eject"
            fluid
            onClick={() => act(paper ? 'ejectpaper' : 'insertpaper')}
            color={paper ? 'default' : 'grey'}
          >
            {paper ? '待发送：' + paper_name : '未放入纸张！'}
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          {(timeLeft < 0 && (
            <Button
              icon="paper-plane"
              fluid
              onClick={() => act('send')}
              disabled={timeLeft > 0 || !paper || !authenticated}
            >
              {paper ? '发送' : '未放入纸张！'}
            </Button>
          )) || (
            <Button icon="window-close" fluid disabled={1}>
              {'发射器正在重新对准，还需' + timeLeft / 10 + '秒。'}
            </Button>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FaxEmpty = (props) => {
  const { act, data } = useBackend();
  const { paper, paper_name } = data;
  return (
    <Section textAlign="center" fill>
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="red">
          <Icon name="times-circle" mb="0.5rem" size="5" color="red" />
          <br />
          未检测到ID卡。
          <br />
          {paper && (
            <Button
              icon="eject"
              onClick={() => act('ejectpaper')}
              disabled={!paper}
            >
              {'弹出' + paper_name + '。'}
            </Button>
          )}
        </Flex.Item>
      </Flex>
    </Section>
  );
};
