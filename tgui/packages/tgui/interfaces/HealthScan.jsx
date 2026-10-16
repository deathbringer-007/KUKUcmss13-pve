import { useBackend } from '../backend';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  Flex,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

const statusLabels = new Map([
  ['Possible Fracture', '疑似骨折'],
  ['Fracture', '骨折'],
  ['Splinted', '夹板固定'],
  ['Nanosplinted', '纳米夹板固定'],
  ['Nonfunctional Cybernetic', '机械义肢失效'],
  ['Cybernetic', '机械义肢'],
  ['Synthskin', '合成皮肤'],
  ['Broken', '严重损伤'],
  ['Bruised', '挫伤'],
  ['Eyes', '眼部'],
  ['Mouth', '口部'],
  ['Eyes and mouth', '眼部和口部'],
]);

const statusLabel = (value) => statusLabels.get(value) ?? value;

export const HealthScan = (props) => {
  const { act, data } = useBackend();
  const {
    patient,
    detail_level,
    species,
    has_chemicals,
    diseases,
    advice,
    limbs_damaged,
    damaged_organs,
    ui_mode,
  } = data;

  const bodyscanner = detail_level >= 1;
  const Synthetic = species === 'Synthetic';
  const theme = Synthetic ? 'hackerman' : bodyscanner ? 'ntos' : 'default';

  return (
    <Window
      width={ui_mode ? 300 : 500}
      height={bodyscanner ? 700 : 600}
      theme={theme}
      title={'患者：' + patient}
    >
      <Window.Content scrollable>
        <Patient />
        {limbs_damaged ? <ScannerLimbs /> : null}
        {has_chemicals ? <ScannerChems /> : null}
        <Misc />
        {diseases ? <Diseases /> : null}
        {advice && !ui_mode ? <MedicalAdvice /> : null}
        {damaged_organs?.length && bodyscanner ? <ScannerOrgans /> : null}
      </Window.Content>
    </Window>
  );
};

const Patient = (props) => {
  const { act, data } = useBackend();
  const {
    patient_mob,
    patient,
    dead,
    health,
    total_brute,
    total_burn,
    toxin,
    oxy,
    clone,
    ui_mode,

    has_chemicals,
    limbs_damaged,

    damaged_organs,
    ssd,

    diseases,

    blood_type,
    blood_amount,
    has_blood,
    body_temperature,
    pulse,
    implants,
    core_fracture,
    lung_ruptured,
    hugged,
    detail_level,
    permadead,
    heart_broken,
    advice,
    species,
    holocard,
  } = data;

  let holocard_message;
  if (holocard === 'red') {
    holocard_message = '患者需要紧急救治。';
  } else if (holocard === 'orange') {
    holocard_message = '患者需要非紧急手术。';
  } else if (holocard === 'purple') {
    holocard_message = '患者体内寄生着 XX-121 胚胎。';
  } else if (holocard === 'black') {
    holocard_message = '患者已死亡，无法复苏。';
  } else {
    holocard_message = '患者未设置全息分诊卡。';
  }

  const ghostscan = detail_level >= 2;
  const Synthetic = species === 'Synthetic';

  return (
    <Section>
      {hugged && ghostscan ? (
        <NoticeBox danger>
          患者体内被植入了异形胚胎！
        </NoticeBox>
      ) : null}
      {dead ? <NoticeBox danger>患者已死亡！</NoticeBox> : null}
      {ssd ? (
        <NoticeBox warning color="grey">
          {ssd}
        </NoticeBox>
      ) : null}

      {ui_mode ? (
        <Stack vertical>
          {dead ? (
            <Stack.Item>
              <Stack>
                <Stack.Item>状态：</Stack.Item>
                <Stack.Item>
                  <Box color={permadead ? 'red' : 'green'} bold={1}>
                    {permadead
                      ? heart_broken
                        ? '心肌破裂，需要手术治疗'
                        : '已死亡，无法复苏'
                      : Synthetic
                        ? '中央供电系统已停机，可使用重置钥匙重启'
                        : '心搏骤停，可进行除颤'}
                  </Box>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          ) : null}
          <Stack.Item>
            <Stack>
              <Stack.Item>伤害：</Stack.Item>
              <Stack.Item>
                <Box inline bold color={'red'} mr={1}>
                  {total_brute}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box inline bold color={'#ffb833'} mx={1}>
                  {total_burn}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box inline bold color={'green'} mx={1}>
                  {toxin}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box inline bold color={'blue'} mx={1}>
                  {oxy}
                </Box>
              </Stack.Item>
              {!!clone && (
                <Box inline bold color={'teal'} mx={1}>
                  {clone}
                </Box>
              )}
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item>全息分诊卡：</Stack.Item>
              {holocard ? (
                <Stack.Item>
                  <ColorBox color={holocard} />
                </Stack.Item>
              ) : (
                <Stack.Item>
                  <Icon name="x" />
                </Stack.Item>
              )}
              <Stack.Item>
                <Box
                  inline
                  onClick={() => act('change_holo_card')}
                  backgroundColor="rgba(255, 255, 255, .05)"
                >
                  更改
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box
                  inline
                  onClick={() => act('change_ui_mode')}
                  backgroundColor="rgba(255, 255, 255, .05)"
                >
                  完整界面
                </Box>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      ) : (
        <LabeledList>
          <LabeledList.Item label="健康">
            {health >= 0 ? (
              <ProgressBar
                value={health / 100}
                ranges={{
                  good: [0.7, Infinity],
                  average: [0.2, 0.7],
                  bad: [-Infinity, 0.2],
                }}
              >
                健康度：{health}%
              </ProgressBar>
            ) : (
              <ProgressBar
                value={1 + health / 100}
                ranges={{
                  bad: [-Infinity, Infinity],
                }}
              >
                健康度：{health}%
              </ProgressBar>
            )}
          </LabeledList.Item>
          {dead ? (
            <LabeledList.Item label="状态">
              <Box color={permadead ? 'red' : 'green'} bold={1}>
                {permadead
                  ? heart_broken
                    ? '心肌破裂，需要手术治疗'
                    : '已死亡，无法复苏'
                  : Synthetic
                    ? '中央供电系统已停机，可使用重置钥匙重启'
                    : '心搏骤停，可进行除颤'}
              </Box>
            </LabeledList.Item>
          ) : null}
          <LabeledList.Item label="伤害">
            <Box inline>
              <ProgressBar>
                物理损伤：{' '}
                <Box inline bold color={'red'}>
                  {total_brute}
                </Box>
              </ProgressBar>
            </Box>
            <Box inline width={'5px'} />
            <Box inline>
              <ProgressBar>
                烧伤：{' '}
                <Box inline bold color={'#ffb833'}>
                  {total_burn}
                </Box>
              </ProgressBar>
            </Box>
            <Box inline width={'5px'} />
            <Box inline>
              <ProgressBar>
                毒素损伤：{' '}
                <Box inline bold color={'green'}>
                  {toxin}
                </Box>
              </ProgressBar>
            </Box>
            <Box inline width={'5px'} />
            <Box inline>
              <ProgressBar>
                缺氧损伤：{' '}
                <Box inline bold color={'blue'}>
                  {oxy}
                </Box>
              </ProgressBar>
            </Box>
            <Box inline width={'5px'} />
            {!!clone && (
              <Box inline>
                <ProgressBar>
                  遗传损伤：{' '}
                  <Box inline color={'teal'}>
                    {clone}
                  </Box>
                </ProgressBar>
              </Box>
            )}
          </LabeledList.Item>
          <LabeledList.Item label="全息分诊卡">
            <NoticeBox color={holocard} inline>
              {holocard_message}
            </NoticeBox>

            <Button
              inline
              style={{ marginLeft: '2%' }}
              onClick={() => act('change_holo_card')}
            >
              更改
            </Button>

            <Button inline onClick={() => act('change_ui_mode')}>
              简洁界面
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="已存扫描">
            <Button
              inline
              style={{ marginLeft: '2%' }}
              onClick={() => act('previous_scan')}
            >
              上一份
            </Button>
            <Button
              inline
              style={{ marginLeft: '2%' }}
              onClick={() => act('print_scan')}
            >
              打印报告
            </Button>
            <Button
              inline
              style={{ marginLeft: '2%' }}
              onClick={() => act('next_scan')}
            >
              下一份
            </Button>
            <Button
              inline
              style={{ marginLeft: '2%' }}
              onClick={() => act('clear_scans')}
            >
              清除扫描
            </Button>
          </LabeledList.Item>
        </LabeledList>
      )}
    </Section>
  );
};

const Misc = (props) => {
  const { data } = useBackend();
  const {
    blood_type,
    blood_amount,
    has_blood,
    body_temperature,
    pulse,
    implants,
    core_fracture,
    lung_ruptured,
    hugged,
    detail_level,
    ui_mode,
  } = data;
  const bloodpct = blood_amount / 560;
  const healthanalyser = detail_level < 1;
  const bodyscanner = detail_level >= 1;
  return (
    <Section>
      <LabeledList>
        {has_blood ? (
          <LabeledList.Item label={'血型：' + blood_type}>
            <Box
              color={
                bloodpct > 0.9 ? 'green' : bloodpct > 0.7 ? 'orange' : 'red'
              }
            >
              {Math.round(blood_amount / 5.6)}%, {blood_amount}cl
            </Box>
          </LabeledList.Item>
        ) : null}
        <LabeledList.Item label={'体温'}>
          {body_temperature}
        </LabeledList.Item>
        <LabeledList.Item label={'脉搏'}>{pulse}</LabeledList.Item>
      </LabeledList>
      {implants || hugged || core_fracture || (lung_ruptured && bodyscanner) ? (
        <Divider />
      ) : null}
      {implants && detail_level !== 1 ? (
        <NoticeBox danger>
          检测到 {implants} 个嵌入异物！
          {healthanalyser && !ui_mode
            ? ' 需要高级扫描仪确定位置。'
            : null}
        </NoticeBox>
      ) : null}
      {(implants || hugged) && detail_level === 1 ? (
        <NoticeBox danger>
          检测到 {implants + (hugged ? 1 : 0)} 个未知异物！
        </NoticeBox>
      ) : null}
      {lung_ruptured && bodyscanner ? (
        <NoticeBox danger>检测到肺破裂！</NoticeBox>
      ) : null}
      {core_fracture && healthanalyser ? (
        <NoticeBox danger>
          检测到骨折！
          {!ui_mode ? ' 需要高级扫描仪确定位置。' : null}
        </NoticeBox>
      ) : null}
    </Section>
  );
};

const Diseases = (props) => {
  const { data } = useBackend();
  const { diseases } = data;
  return (
    <Section title="疾病">
      <LabeledList>
        {diseases.map((disease) => (
          <LabeledList.Item
            key={disease.name}
            label={disease.name[0].toUpperCase() + disease.name.slice(1)}
          >
            <Box inline bold={1}>
              传播方式：{disease.type}，可能的疗法：{disease.cure}
            </Box>
            <Box inline width={'5px'} />
            <Box inline>
              <ProgressBar
                width="200px"
                value={disease.stage / disease.max_stage}
                ranges={{
                  good: [-Infinity, 20],
                  average: [20, 50],
                  bad: [50, Infinity],
                }}
              >
                阶段：{disease.stage}/{disease.max_stage}
              </ProgressBar>
            </Box>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const MedicalAdvice = (props) => {
  const { data } = useBackend();
  const { advice } = data;
  return (
    <Section title="治疗建议">
      <Stack vertical>
        {advice.map((advice) => (
          <Stack.Item key={advice.advice}>
            <Box inline>
              <Icon name={advice.icon} ml={0.2} color={advice.color} />
              <Box inline width={'5px'} />
              {advice.advice}
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const ScannerChems = (props) => {
  const { data } = useBackend();
  const { has_unknown_chemicals, chemicals_lists, ui_mode } = data;
  const chemicals = Object.values(chemicals_lists);

  return (
    <Section title={ui_mode ? null : '体内化学物质'}>
      {has_unknown_chemicals ? (
        <NoticeBox warning color="grey">
          检测到未知试剂。
        </NoticeBox>
      ) : null}
      <Stack vertical>
        {chemicals.map((chemical) => (
          <Stack.Item key={chemical.name}>
            <Box inline>
              <Icon name={'flask'} ml={0.2} color={chemical.color} />
              <Box inline width={'5px'} />
              <Box
                inline
                color={chemical.dangerous ? 'red' : 'white'}
                bold={chemical.dangerous}
              >
                {chemical.amount + ' 单位' + chemical.name}
              </Box>
              <Box inline width={'5px'} />
              {chemical.od ? (
                <Box inline color={'red'} bold={1}>
                  {'过量'}
                </Box>
              ) : null}
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const ScannerLimbs = (props) => {
  const { data } = useBackend();
  const { limb_data_lists, detail_level, ui_mode } = data;
  const limb_data = Object.values(limb_data_lists);
  const bodyscanner = detail_level >= 1;

  let index = 0;
  const row_bg_color = 'rgba(255, 255, 255, .05)';

  limb_data.forEach((limb) => {
    limb.unbandaged = !limb.bandaged && limb.brute > 0 && !limb.limb_type;
    limb.unsalved = !limb.salved && limb.burn > 0 && !limb.limb_type;
  });

  return (
    <Section title={ui_mode ? null : '肢体损伤'}>
      <Stack vertical fill>
        {ui_mode ? null : (
          <Flex width="100%" height="20px">
            <Flex.Item basis="85px" />
            <Flex.Item basis="55px" bold color="red">
              物理损伤
            </Flex.Item>
            <Flex.Item basis="55px" bold color="#ffb833">
              烧伤
            </Flex.Item>
            <Flex.Item grow="1" shrink="1" textAlign="right" nowrap>
              {'{ } = 未处理'}
            </Flex.Item>
          </Flex>
        )}
        {limb_data.map((limb) => (
          <Flex
            key={limb.name}
            width="100%"
            minHeight="15px"
            py="3px"
            backgroundColor={index++ % 2 === 0 ? row_bg_color : ''}
          >
            <Flex.Item basis="85px" shrink="0" bold pl="3px">
              {limb.name[0].toUpperCase() + limb.name.slice(1)}
            </Flex.Item>
            {limb.missing ? (
              <Flex.Item color={'red'} bold={1}>
                缺失
              </Flex.Item>
            ) : (
              <>
                <Flex.Item basis="fit-content" shrink="0">
                  <Box
                    inline
                    width="50px"
                    color={limb.brute > 0 ? 'red' : 'white'}
                  >
                    {limb.unbandaged ? `{${limb.brute}}` : `${limb.brute}`}
                  </Box>
                  <Box
                    inline
                    width="40px"
                    color={limb.burn > 0 ? '#ffb833' : 'white'}
                  >
                    {limb.unsalved ? `{${limb.burn}}` : `${limb.burn}`}
                  </Box>
                </Flex.Item>
                <Flex.Item shrink="1">
                  {limb.bleeding ? (
                    <Box inline color={'red'} bold={1}>
                      {ui_mode ? `[出血]` : `[正在出血]`}
                    </Box>
                  ) : null}
                  {limb.internal_bleeding ? (
                    limb.arterial_bleeding ? (
                      <Box inline color="red" bold={1}>
                        {ui_mode ? '[内出血]' : '[内出血]'}
                      </Box>
                    ) : (
                      <Box inline color="pink" bold={1}>
                        {ui_mode ? '[动脉出血!]' : '[动脉出血！]'}
                      </Box>
                    )
                  ) : null}

                  {limb.limb_status ? (
                    <Box inline color="white" bold={1}>
                      {ui_mode ? '[骨折]' : `[${statusLabel(limb.limb_status)}]`}
                    </Box>
                  ) : null}
                  {limb.limb_splint ? (
                    <Box inline color={'lime'} bold={1}>
                      {ui_mode ? '[夹板]' : `[${statusLabel(limb.limb_splint)}]`}
                    </Box>
                  ) : null}
                  {limb.limb_type ? (
                    <Box
                      inline
                      color={
                        limb.limb_type === 'Nonfunctional Cybernetic'
                          ? 'red'
                          : 'green'
                      }
                      bold={1}
                    >
                      {ui_mode ? '[机械]' : `[${statusLabel(limb.limb_type)}]`}
                    </Box>
                  ) : null}
                  {limb.open_incision ? (
                    <Box inline color={'red'} bold={1}>
                      {ui_mode ? `[切口]` : `[手术切口未闭合]`}
                    </Box>
                  ) : null}
                  {limb.implant && bodyscanner ? (
                    <Box inline color={'white'} bold={1}>
                      {ui_mode ? `[异物]` : `[嵌入异物]`}
                    </Box>
                  ) : null}
                  {limb.open_zone_incision ? (
                    <Box inline color={'red'} bold={1}>
                      [{statusLabel(limb.open_zone_incision)}手术切口未闭合]
                      {ui_mode
                        ? `[切口：${statusLabel(limb.open_zone_incision)}]`
                        : `[${statusLabel(limb.open_zone_incision)}手术切口未闭合]`}
                    </Box>
                  ) : null}
                </Flex.Item>
              </>
            )}
          </Flex>
        ))}
      </Stack>
    </Section>
  );
};

const ScannerOrgans = (props) => {
  const { data } = useBackend();
  const { damaged_organs, ui_mode } = data;

  return (
    <Section title={ui_mode ? null : '器官损伤'}>
      <LabeledList>
        {damaged_organs.map((organ) => (
          <LabeledList.Item
            key={organ.name}
            label={organ.name[0].toUpperCase() + organ.name.slice(1)}
          >
            <Box
              inline
              color={organ.status === 'Bruised' ? 'orange' : 'red'}
              bold={1}
            >
              {statusLabel(organ.status) + ' [' + organ.damage + ' 损伤]'}
            </Box>
            <Box inline width={'5px'} />
            {organ.robotic ? (
              <Box inline bold={1} color="blue">
                机械器官
              </Box>
            ) : null}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
