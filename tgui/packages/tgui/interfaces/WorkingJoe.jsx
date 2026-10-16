import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Stack } from '../components';
import { Window } from '../layouts';

const PAGES = {
  login: () => Login,
  main: () => MainMenu,
  apollo: () => ApolloLog,
  login_records: () => LoginRecords,
  maint_reports: () => MaintReports,
  maint_claim: () => MaintManagement,
  access_requests: () => AccessRequests,
  access_tickets: () => AccessTickets,
  id_access: () => AccessID,
  core_security_gas: () => CoreSecGas,
};
export const WorkingJoe = (props) => {
  const { data } = useBackend();
  const { current_menu } = data;
  const PageComponent = PAGES[current_menu]();

  let themecolor = 'crtblue';
  if (current_menu === 'core_security_gas') {
    themecolor = 'crtred';
  }

  return (
    <Window theme={themecolor} width={950} height={725}>
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
      <Box fontFamily="monospace">阿波罗维护控制器</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS执行程序
      </Box>
      <Box fontFamily="monospace">版本12.8.3</Box>
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
    notify_sounds,
  } = data;
  let can_request_access = 'Yes';
  if (access_level > 2) {
    can_request_access = 'No';
  }
  let soundicon = 'volume-high';
  if (!notify_sounds) {
    soundicon = 'volume-xmark';
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
              tooltip="导航菜单"
              onClick={() => act('home')}
              disabled={current_menu === 'main'}
            />
            <Button
              icon={soundicon}
              ml="auto"
              mr="1rem"
              tooltip="关闭或开启通知音效。"
              onClick={() => act('toggle_sound')}
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
            <h3>提交申请</h3>
          </Stack.Item>
          {can_request_access === 'Yes' && (
            <Stack.Item>
              <Button
                tooltip="申请通行证以访问ARES。"
                icon="bullhorn"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_request')}
              >
                申请通行证
              </Button>
            </Stack.Item>
          )}
          {access_level === 3 && (
            <Stack.Item>
              <Button.Confirm
                tooltip="交还临时访问权限。"
                icon="eye"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('return_access')}
              >
                交还通行证
              </Button.Confirm>
            </Stack.Item>
          )}
          <Stack.Item>
            <Button
              tooltip="查看或报告维护问题。"
              icon="comments"
              ml="auto"
              px="2rem"
              width="33vw"
              bold
              onClick={() => act('page_report')}
            >
              维修工单
            </Button>
          </Stack.Item>
        </Stack>

        {access_level >= 4 && (
          <Stack>
            <Stack.Item grow>
              <h3>授权人员</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="阅读阿波罗链路记录。"
                icon="clipboard"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_apollo')}
              >
                查看阿波罗日志
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="查看近期登录记录。"
                icon="users"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_logins')}
              >
                查看访问日志
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {access_level >= 5 && (
          <Stack>
            <Stack.Item grow>
              <h3>任务管理</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="批准或拒绝人员的临时访问申请。"
                icon="user-shield"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_tickets')}
              >
                管理通行申请
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="认领、完成、优先处理或取消维修工单。"
                icon="cart-shopping"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_maintenance')}
              >
                管理维修工单
              </Button>
            </Stack.Item>
          </Stack>
        )}
      </Section>
      {access_level >= 5 && (
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
                onClick={() => act('page_core_gas')}
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

const LoginRecords = (props) => {
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
        <h1 align="center">登录记录</h1>

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

const MaintReports = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    maintenance_tickets,
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
        <h1 align="center">维修报告</h1>
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
          <Button
            icon="exclamation-circle"
            width="30vw"
            textAlign="center"
            fontSize="1.5rem"
            mt="5rem"
            onClick={() => act('new_report')}
          >
            新建报告
          </Button>
        </Flex>

        {!!maintenance_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0" mr="1.5rem">
              ID
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item width="12rem" bold>
              类别
            </Flex.Item>
            <Flex.Item width="40rem" bold>
              详情
            </Flex.Item>
          </Flex>
        )}
        {maintenance_tickets.map((ticket, i) => {
          let view_status = '工单等待分配。';
          let view_icon = 'circle-question';
          if (ticket.status === 'assigned') {
            view_status = '工单已分配。';
            view_icon = 'circle-plus';
          } else if (ticket.status === 'rejected') {
            view_status = '工单已被拒绝。';
            view_icon = 'circle-xmark';
          } else if (ticket.status === 'cancelled') {
            view_status = '报告人已取消工单。';
            view_icon = 'circle-stop';
          } else if (ticket.status === 'completed') {
            view_status = '工单已成功解决。';
            view_icon = 'circle-check';
          }
          let can_cancel = 'Yes';
          if (ticket.submitter !== logged_in) {
            can_cancel = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
            can_cancel = 'No';
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              {!!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold color="red">
                  {ticket.id}
                </Flex.Item>
              )}
              {!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold>
                  {ticket.id}
                </Flex.Item>
              )}
              <Flex.Item italic width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="12rem" mr="1rem">
                {ticket.category}
              </Flex.Item>
              <Flex.Item width="40rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item width="8rem" ml="1rem">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="file-circle-xmark"
                  tooltip="取消工单"
                  disabled={can_cancel === 'No'}
                  onClick={() => act('cancel_ticket', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};
const MaintManagement = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    maintenance_tickets,
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
        <h1 align="center">维修报告管理</h1>

        {!!maintenance_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0">
              ID
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" ml="1rem">
              时间
            </Flex.Item>
            <Flex.Item width="12rem" bold>
              类别
            </Flex.Item>
            <Flex.Item width="20rem" bold>
              详情
            </Flex.Item>
            <Flex.Item width="10rem" bold>
              提交人
            </Flex.Item>
            <Flex.Item width="10rem" bold ml="0.5rem">
              负责人
            </Flex.Item>
          </Flex>
        )}
        {maintenance_tickets.map((ticket, i) => {
          let view_status = '工单等待分配。';
          let view_icon = 'circle-question';
          if (ticket.status === 'assigned') {
            view_status = '工单已分配。';
            view_icon = 'circle-plus';
          } else if (ticket.status === 'rejected') {
            view_status = '工单已被拒绝。';
            view_icon = 'circle-xmark';
          } else if (ticket.status === 'cancelled') {
            view_status = '报告人已取消工单。';
            view_icon = 'circle-stop';
          } else if (ticket.status === 'completed') {
            view_status = '工单已成功解决。';
            view_icon = 'circle-check';
          }
          let can_claim = 'Yes';
          if (ticket.lock_status === 'CLOSED') {
            can_claim = 'No';
          }
          let can_mark = 'Yes';
          if (ticket.assignee !== logged_in && ticket.assignee !== null) {
            can_mark = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
            can_mark = 'No';
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              {!!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" bold color="red">
                  {ticket.id}
                </Flex.Item>
              )}
              {!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" bold>
                  {ticket.id}
                </Flex.Item>
              )}
              <Flex.Item italic width="6rem" shrink="0" ml="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="12rem">{ticket.category}</Flex.Item>
              <Flex.Item width="20rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item width="10rem" shrink="0" textAlign="left">
                {ticket.submitter}
              </Flex.Item>
              <Flex.Item width="10rem" shrink="0" textAlign="left" ml="0.5rem">
                {ticket.assignee}
              </Flex.Item>
              <Flex.Item width="8rem" ml="1rem" direction="column">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="user-lock"
                  tooltip="认领工单"
                  disabled={can_claim === 'No'}
                  onClick={() => act('claim_ticket', { ticket: ticket.ref })}
                />
                <Button.Confirm
                  icon="user-gear"
                  tooltip="标记工单"
                  disabled={can_mark === 'No'}
                  onClick={() => act('mark_ticket', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};
const AccessRequests = (props) => {
  const { data, act } = useBackend();
  const {
    logged_in,
    access_text,
    access_level,
    last_page,
    current_menu,
    access_tickets,
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
        <h1 align="center">申请访问</h1>
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
          <Button
            icon="exclamation-circle"
            width="30vw"
            textAlign="center"
            fontSize="1.5rem"
            mt="5rem"
            onClick={() => act('new_access')}
            disabled={access_level > 2}
          >
            创建申请
          </Button>
        </Flex>

        {!!access_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0" mr="1.5rem">
              ID
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item width="8rem" mr="1rem" bold>
              用途
            </Flex.Item>
            <Flex.Item width="40rem" bold>
              详情
            </Flex.Item>
          </Flex>
        )}
        {access_tickets.map((ticket, i) => {
          let view_status = '通行申请等待分配。';
          let view_icon = 'circle-question';
          if (ticket.status === 'assigned') {
            view_status = '通行申请已分配。';
            view_icon = 'circle-plus';
          } else if (ticket.status === 'rejected') {
            view_status = '通行申请已被拒绝。';
            view_icon = 'circle-xmark';
          } else if (ticket.status === 'cancelled') {
            view_status = '申请人已取消通行申请。';
            view_icon = 'circle-stop';
          } else if (ticket.status === 'granted') {
            view_status = '通行申请已获批准。';
            view_icon = 'circle-check';
          } else if (ticket.status === 'revoked') {
            view_status = '通行权限已撤销。';
            view_icon = 'circle-minus';
          } else if (ticket.status === 'returned') {
            view_status = '通行权限已交还。';
            view_icon = 'circle-minus';
          }
          let can_cancel = 'Yes';
          if (ticket.submitter !== logged_in) {
            can_cancel = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
            can_cancel = 'No';
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              {!!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold color="red">
                  {ticket.id}
                </Flex.Item>
              )}
              {!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold>
                  {ticket.id}
                </Flex.Item>
              )}
              <Flex.Item italic width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="8rem" mr="1rem">
                {ticket.title}
              </Flex.Item>
              <Flex.Item width="40rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item width="8rem" ml="1rem">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="file-circle-xmark"
                  tooltip="取消工单"
                  disabled={can_cancel === 'No'}
                  onClick={() => act('cancel_ticket', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const AccessTickets = (props) => {
  const { data, act } = useBackend();
  const { logged_in, access_text, last_page, current_menu, access_tickets } =
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
        <h1 align="center">通行申请管理</h1>
        {!!access_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0" mr="1.5rem">
              ID
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              时间
            </Flex.Item>
            <Flex.Item width="8rem" mr="1rem" bold>
              提交人
            </Flex.Item>
            <Flex.Item width="8rem" mr="1rem" bold>
              用途
            </Flex.Item>
            <Flex.Item width="30rem" bold>
              理由
            </Flex.Item>
          </Flex>
        )}
        {access_tickets.map((ticket, i) => {
          let can_claim = 'Yes';
          if (ticket.assignee === logged_in) {
            can_claim = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
            can_claim = 'No';
          }
          let can_update = 'Yes';
          if (ticket.lock_status === 'CLOSED') {
            can_update = 'No';
          }
          let view_status = '工单等待分配。';
          let view_icon = 'circle-question';
          let update_tooltip = '授予权限';
          if (ticket.status === 'rejected') {
            view_status = '工单已被拒绝。';
            view_icon = 'circle-xmark';
            update_tooltip = '申请已被拒绝，无法继续更改。';
          } else if (ticket.status === 'cancelled') {
            view_status = '报告人已取消工单。';
            view_icon = 'circle-stop';
            update_tooltip = '申请已取消，无法继续更改。';
          } else if (ticket.status === 'granted') {
            view_status = '通行申请已获批准。';
            view_icon = 'circle-check';
            update_tooltip = '撤销权限';
          } else if (ticket.status === 'revoked') {
            view_status = '通行权限已撤销。';
            view_icon = 'circle-minus';
            update_tooltip = '权限已撤销，无法继续更改。';
          } else if (ticket.status === 'returned') {
            view_status = '通行权限已交还。';
            view_icon = 'circle-minus';
            update_tooltip = '权限已由本人交还，无法继续更改。';
          }
          let can_reject = 'Yes';
          if (can_update === 'No') {
            can_reject = 'No';
          }
          if (ticket.status !== 'pending') {
            can_reject = 'No';
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold>
                {ticket.id}
              </Flex.Item>
              <Flex.Item italic width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="8rem" mr="1rem">
                {ticket.submitter}
              </Flex.Item>
              <Flex.Item width="8rem" mr="1rem">
                {ticket.title}
              </Flex.Item>
              <Flex.Item width="30rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="user-gear"
                  tooltip={update_tooltip}
                  disabled={can_update === 'No'}
                  onClick={() => act('auth_access', { ticket: ticket.ref })}
                />
                {can_reject === 'Yes' && (
                  <Button.Confirm
                    icon="user-minus"
                    tooltip="拒绝申请"
                    disabled={can_reject === 'No'}
                    onClick={() => act('reject_access', { ticket: ticket.ref })}
                  />
                )}
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const CoreSecGas = (props) => {
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
        <h1 align="center">神经毒气释放</h1>
        {security_vents.map((vent, i) => {
          return (
            <Button.Confirm
              key={i}
              align="center"
              icon="wind"
              tooltip="释放毒气"
              width="100%"
              disabled={access_level < 5 || !vent.available}
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
