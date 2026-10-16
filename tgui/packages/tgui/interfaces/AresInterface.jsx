// -------------------------------------------------------------------- //
// Please ensure when updating this menu, changes are reflected in AresAdmin.js
// -------------------------------------------------------------------- //

import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Stack } from '../components';
import { Window } from '../layouts';

const PAGES = {
  login: () => Login,
  main: () => MainMenu,
  announcements: () => AnnouncementLogs,
  bioscans: () => BioscanLogs,
  bombardments: () => BombardmentLogs,
  apollo: () => ApolloLog,
  access_log: () => AccessLogs,
  delete_log: () => DeletionLogs,
  flight_log: () => FlightLogs,
  talking: () => ARESTalk,
  deleted_talks: () => DeletedTalks,
  read_deleted: () => ReadingTalks,
  security: () => Security,
  requisitions: () => Requisitions,
  emergency: () => Emergency,
  tech_log: () => TechLogs,
  core_security: () => CoreSec,
};

export const AresInterface = (props) => {
  const { data } = useBackend();
  const { current_menu, sudo } = data;
  const PageComponent = PAGES[current_menu]();

  let themecolor = 'crtblue';
  if (sudo >= 1) {
    themecolor = 'crtred';
  } else if (current_menu === 'emergency') {
    themecolor = 'crtred';
  } else if (current_menu === 'core_security') {
    themecolor = 'crtred';
  }

  return (
    <Window theme={themecolor} width={800} height={725}>
      <Window.Content>
        <Section pl="6px" pt="6px" fill scrollable>
          <PageComponent />
        </Section>
      </Window.Content>
    </Window>
  );
};

const Login = (props) => {
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
      <Box fontFamily="monospace">ARES v3.2界面</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS执行程序
      </Box>
      <Box fontFamily="monospace">版本8.3.4</Box>
      <Box fontFamily="monospace">版权所有 © 2182，维兰德-汤谷公司。</Box>

      <Button
        icon="id-card"
        width="30vw"
        textAlign="center"
        fontSize="1.5rem"
        p="1rem"
        mt="5rem"
        onClick={() => act('login')}
      >
        登录
      </Button>
    </Flex>
  );
};

const MainMenu = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    access_level,
    sudo,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
              disabled={current_menu === 'main'}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">导航菜单</h1>

        <Stack>
          <Stack.Item grow>
            <h3>一级访问权限</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltip="查看AI公告日志。"
              icon="bullhorn"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_announcements')}
            >
              公告日志
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltip="与ARES进行一对一通讯。"
              icon="comments"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_1to1')}
            >
              ARES通讯
            </Button>
          </Stack.Item>
        </Stack>
        {access_level >= 2 && (
          <Stack>
            <Stack.Item grow>
              <h3>二级访问权限</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="阅读运输机飞行控制记录。"
                icon="jet-fighter-up"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_flight')}
              >
                飞行记录
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="查看生命扫描记录。"
                icon="eye"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_bioscans')}
              >
                生命扫描日志
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="查看轨道轰炸日志。"
                icon="meteor"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_bombardments')}
              >
                轰炸日志
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {access_level >= 3 && (
          <Stack>
            <Stack.Item grow>
              <h3>三级访问权限</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="阅读安全动态。"
                icon="file-shield"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_security')}
              >
                安全动态
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="阅读阿波罗链路记录。"
                icon="clipboard"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_apollo')}
              >
                查看阿波罗日志
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {access_level >= 5 && (
          <Stack>
            <Stack.Item grow>
              <h3>五级访问权限</h3>
            </Stack.Item>
            <Stack.Item>
              <Button.Confirm
                tooltip="访问应急协议。"
                icon="shield"
                color="red"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_emergency')}
              >
                应急协议
              </Button.Confirm>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="查看自动仓储系统审计日志。"
                icon="magnifying-glass-dollar"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_requisitions')}
              >
                自动仓储系统审计日志
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="查看情报技术日志。"
                icon="magnifying-glass-chart"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_tech')}
              >
                技术控制日志
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {access_level >= 6 && (
          <Stack>
            <Stack.Item grow>
              <h3>六级访问权限</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="查看近期登录记录。"
                icon="users"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_access')}
              >
                查看访问日志
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {access_level >= 9 && (
          <Stack>
            <Stack.Item grow>
              <h3>九级访问权限</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="查看删除日志。"
                icon="sd-card"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_deleted')}
              >
                查看删除日志
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="查看已删除的ARES一对一对话。"
                icon="sd-card"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_deleted_1to1')}
              >
                View Deleted 1:1&apos;s
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {access_level >= 11 && (
          <Stack>
            <Stack.Item grow>
              <h3>维护权限</h3>
            </Stack.Item>
            {sudo === 0 && (
              <Stack.Item>
                <Button
                  tooltip="远程登录。"
                  icon="user-secret"
                  ml="auto"
                  px="2rem"
                  width="25vw"
                  bold
                  onClick={() => act('sudo')}
                >
                  提权登录
                </Button>
              </Stack.Item>
            )}
            {sudo >= 1 && (
              <Stack.Item>
                <Button
                  tooltip="退出提权模式。"
                  icon="user-secret"
                  ml="auto"
                  px="2rem"
                  width="25vw"
                  bold
                  onClick={() => act('sudo_logout')}
                >
                  退出提权
                </Button>
              </Stack.Item>
            )}
          </Stack>
        )}
      </Section>
      {(access_level === 3 || access_level >= 6) && (
        <Section>
          <h1 align="center">核心安全协议</h1>
          <Stack>
            <Stack.Item grow>
              <Button
                align="center"
                tooltip="从安全通风口释放储存的CN20-X神经毒气。"
                icon="wind"
                color="red"
                ml="auto"
                px="2rem"
                width="100%"
                bold
                onClick={() => act('page_core_sec')}
              >
                神经毒气控制
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button.Confirm
                align="center"
                tooltip="启用或解除AI核心封锁。"
                icon="lock"
                color="red"
                ml="auto"
                px="2rem"
                width="100%"
                bold
                onClick={() => act('security_lockdown')}
              >
                AI核心封锁
              </Button.Confirm>
            </Stack.Item>
          </Stack>
        </Section>
      )}
    </>
  );
};

const AnnouncementLogs = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_announcement,
    access_level,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">公告日志</h1>

        {!!records_announcement.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item width="10rem" grow bold>
              标题
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              详情
            </Flex.Item>
          </Flex>
        )}
        {records_announcement.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="10rem" grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="40rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="删除记录"
                  disabled={access_level < 4}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const BioscanLogs = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_bioscan,
    access_level,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">生命扫描日志</h1>

        {!!records_bioscan.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item grow bold>
              标题
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              详情
            </Flex.Item>
          </Flex>
        )}
        {records_bioscan.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="40rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="删除记录"
                  disabled={access_level < 5}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const BombardmentLogs = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_bombardment,
    access_level,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">轨道轰炸日志</h1>

        {!!records_bombardment.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item grow bold>
              弹头
            </Flex.Item>
            <Flex.Item grow bold>
              用户
            </Flex.Item>
            <Flex.Item width="30rem" textAlign="center">
              详情
            </Flex.Item>
          </Flex>
        )}
        {records_bombardment.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item>{record.user}</Flex.Item>
              <Flex.Item width="30rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="删除记录"
                  disabled={access_level < 5}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const ApolloLog = (props) => {
  const { data, act } = useBackend();
  const { logged_in, access_text, last_page, current_menu, apollo_log } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">阿波罗日志</h1>

        {apollo_log.map((apollo_message, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{apollo_message}</Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const AccessLogs = (props) => {
  const { data, act } = useBackend();
  const { logged_in, access_text, last_page, current_menu, access_log } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">访问日志</h1>

        {access_log.map((login, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{login}</Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const DeletionLogs = (props) => {
  const { data, act } = useBackend();
  const { logged_in, access_text, last_page, current_menu, records_deletion } =
    data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">删除日志</h1>

        {!!records_deletion.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              删除时间
            </Flex.Item>
            <Flex.Item grow bold>
              删除者
            </Flex.Item>
            <Flex.Item grow bold>
              标题
            </Flex.Item>
            <Flex.Item width="30rem" textAlign="center">
              详情
            </Flex.Item>
          </Flex>
        )}
        {records_deletion.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="10rem">{record.user}</Flex.Item>
              <Flex.Item grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="30rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const ARESTalk = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    active_convo,
    active_ref,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">ARES通讯</h1>
      </Section>

      <Section align="center">
        {!active_convo.length && (
          <Button
            icon="pen"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('new_conversation')}
          >
            新建对话
          </Button>
        )}
        {active_convo.map((message, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{message}</Flex.Item>
            </Flex>
          );
        })}
        {!!active_convo.length && (
          <Button
            icon="pen"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('message_ares', { active_convo: active_ref })}
          >
            发送消息
          </Button>
        )}
      </Section>
      <Section align="center">
        <Button.Confirm
          icon="trash"
          tooltip="清空对话。请注意，一对一对话仅你自己可见。"
          width="30vw"
          textAlign="center"
          fontSize="1.5rem"
          bold
          onClick={() =>
            act('clear_conversation', { active_convo: active_ref })
          }
          disabled={!active_convo.length}
        >
          清空对话
        </Button.Confirm>
      </Section>
    </>
  );
};

const DeletedTalks = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    deleted_discussions,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">删除日志</h1>
        {!!deleted_discussions.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              删除时间
            </Flex.Item>
            <Flex.Item grow bold>
              标题
            </Flex.Item>
            <Flex.Item width="30rem" textAlign="center">
              阅读记录
            </Flex.Item>
          </Flex>
        )}
        {deleted_discussions.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="30rem" ml="1rem" shrink="0" textAlign="center">
                <Button
                  icon="eye"
                  tooltip="阅读对话"
                  onClick={() => act('read_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const ReadingTalks = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    deleted_conversation,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">已删除的对话</h1>
        {deleted_conversation.map((message, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{message}</Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const Requisitions = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_requisition,
    printer_cooldown,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">自动仓储系统审计日志</h1>
        <h4 align="center">
          <Button
            icon="print"
            px="2rem"
            textAlign="center"
            tooltip="打印审计日志"
            onClick={() => act('print_req')}
            disabled={printer_cooldown}
          >
            打印审计日志
          </Button>
        </h4>

        {!!records_requisition.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item grow bold>
              用户
            </Flex.Item>
            <Flex.Item bold width="9rem" shrink="0" mr="1rem">
              来源
            </Flex.Item>
            <Flex.Item bold width="30rem" textAlign="center">
              订单
            </Flex.Item>
          </Flex>
        )}
        {records_requisition.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item grow italic>
                {record.user}
              </Flex.Item>
              <Flex.Item width="9rem" shrink="0" mr="1rem">
                {record.title}
              </Flex.Item>
              <Flex.Item width="30rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const FlightLogs = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_flight,
    access_level,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">飞行控制日志</h1>
        {!!records_flight.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item width="10rem" grow bold>
              用户
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              详情
            </Flex.Item>
          </Flex>
        )}
        {records_flight.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="10rem" grow italic>
                {record.user}
              </Flex.Item>
              <Flex.Item width="40rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="删除记录"
                  disabled={access_level < 4}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const Security = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_security,
    access_level,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">安全动态</h1>
        {!!records_security.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item width="10rem" grow bold>
              标题
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              详情
            </Flex.Item>
          </Flex>
        )}
        {records_security.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="10rem" grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="40rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="删除记录"
                  disabled={access_level < 8}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const Emergency = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    alert_level,
    worldtime,
    distresstimelock,
    distresstime,
    quarterstime,
    evac_status,
    mission_failed,
    nuketimelock,
    nuke_available,
  } = data;
  const minimumEvacTime = worldtime > distresstimelock;
  const distressCooldown = worldtime < distresstime;
  const quartersCooldown = worldtime < quarterstime;
  const canQuarters = !quartersCooldown;
  let quarters_reason = '发布全员战斗部署令。';
  if (quartersCooldown) {
    quarters_reason = '距离上一次全员战斗部署令的时间还不够长。';
  }
  const canDistress = alert_level === 2 && !distressCooldown && minimumEvacTime;
  let distress_reason = '发送求救信标。';
  if (alert_level === 3) {
    distress_reason = '正在自毁，信标已停用。';
  } else if (alert_level !== 2) {
    distress_reason = '舰船当前未处于紧急状态。';
  } else if (distressCooldown) {
    distress_reason = '信标正在冷却。';
  } else if (!minimumEvacTime) {
    distress_reason = '现在还太早，无法发送求救信标。';
  }

  const canEvac = (evac_status === 0, alert_level >= 2);
  let evac_reason = '启动疏散程序，授权救生艇。';
  if (alert_level !== 2) {
    evac_reason = '舰船当前未处于紧急状态。';
  } else if (evac_status === 1) {
    evac_reason = '正在启动疏散。';
  } else if (evac_status === 2) {
    evac_reason = '正在疏散。';
  } else if (evac_status === 3) {
    evac_reason = '疏散完成。';
  }

  const minimumNukeTime = worldtime > nuketimelock;
  const canNuke =
    (nuke_available, !mission_failed, evac_reason === 0, minimumNukeTime);
  let nuke_reason = '请求殖民地陆战队高级指挥部授权核装置。';
  if (!nuke_available) {
    nuke_reason = '本次行动不提供核武器，或已有核武器获发。';
  } else if (mission_failed) {
    nuke_reason = '行动目标已经失败，你不能在舰上使用核装置！';
  } else if (evac_status !== 0) {
    nuke_reason = '弃舰期间不能使用核装置！';
  } else if (!minimumNukeTime) {
    nuke_reason = '现在还太早，不能使用核装置。继续战斗！';
  }

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <h1 align="center">应急协议</h1>
      <Flex align="center" justify="center" height="50%" direction="column">
        <Button.Confirm
          tooltip={quarters_reason}
          icon="triangle-exclamation"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          onClick={() => act('general_quarters')}
          disabled={!canQuarters}
        >
          全员战斗部署
        </Button.Confirm>
        <Button.Confirm
          tooltip={evac_reason}
          icon="shuttle-space"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          onClick={() => act('evacuation_start')}
          disabled={!canEvac}
        >
          启动疏散
        </Button.Confirm>
        <Button.Confirm
          tooltip={distress_reason}
          icon="circle-exclamation"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          onClick={() => act('distress')}
          disabled={!canDistress}
        >
          发送求救信标
        </Button.Confirm>
        <Button.Confirm
          tooltip={nuke_reason}
          icon="circle-radiation"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          onClick={() => act('nuclearbomb')}
          disabled={!canNuke}
        >
          申请核装置
        </Button.Confirm>
      </Flex>
    </>
  );
};

const TechLogs = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_tech,
    access_level,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">技术控制日志</h1>
        {!!records_tech.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item width="15rem" grow bold>
              授权者
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              详情
            </Flex.Item>
          </Flex>
        )}
        {records_tech.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="15rem" grow italic>
                {record.user}
              </Flex.Item>
              {!!record.tier_changer && (
                <Flex.Item
                  width="40rem"
                  ml="1rem"
                  shrink="0"
                  textAlign="center"
                  color="red"
                >
                  {record.details}
                </Flex.Item>
              )}
              {!record.tier_changer && (
                <Flex.Item
                  width="40rem"
                  ml="1rem"
                  shrink="0"
                  textAlign="center"
                >
                  {record.details}
                </Flex.Item>
              )}

              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="删除记录"
                  disabled={access_level < 4 || !!record.tier_changer}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const CoreSec = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    access_level,
    last_page,
    current_menu,
    security_vents,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="返回"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="导航菜单"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            退出登录
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">核心安全协议</h1>
      </Section>
      <Section>
        <h1 align="center">神经毒气释放</h1>
        {security_vents.map((vent, i) => {
          return (
            <Button.Confirm
              key={i}
              align="center"
              icon="wind"
              tooltip="释放毒气"
              width="100%"
              disabled={
                (access_level < 5 && access_level !== 3) || !vent.available
              }
              onClick={() => act('trigger_vent', { vent: vent.ref })}
            >
              {vent.vent_tag}
            </Button.Confirm>
          );
        })}
      </Section>
    </>
  );
};
