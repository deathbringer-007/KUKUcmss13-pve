import { classes } from 'common/react';
import dateformat from 'dateformat';
import yaml from 'js-yaml';
import { Component, Fragment } from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Section,
  Stack,
  Table,
  Tooltip,
} from '../components';
import { Window } from '../layouts';

const changeTypes = {
  bugfix: { icon: 'bug', color: 'green', desc: '修复' },
  fix: { icon: 'bug', color: 'green', desc: '修复' },
  wip: { icon: 'hammer', color: 'orange', desc: '开发中' },
  qol: { icon: 'hand-holding-heart', color: 'green', desc: '体验改进' },
  soundadd: { icon: 'tg-sound-plus', color: 'green', desc: '新增音效' },
  sounddel: { icon: 'tg-sound-minus', color: 'red', desc: '移除音效' },
  soundtweak: { icon: 'wrench', color: 'green', desc: '调整音效' },
  add: { icon: 'check-circle', color: 'green', desc: '新增内容' },
  expansion: { icon: 'check-circle', color: 'green', desc: '新增内容' },
  rscadd: { icon: 'check-circle', color: 'green', desc: '新增内容' },
  rscdel: { icon: 'times-circle', color: 'red', desc: '移除内容' },
  del: { icon: 'times-circle', color: 'red', desc: '移除内容' },
  imageadd: { icon: 'tg-image-plus', color: 'green', desc: '新增图像' },
  imagedel: { icon: 'tg-image-minus', color: 'red', desc: '移除图像' },
  imagetweak: { icon: 'wrench', color: 'green', desc: '调整图像' },
  spellcheck: { icon: 'spell-check', color: 'green', desc: '文本修正' },
  experiment: { icon: 'radiation', color: 'yellow', desc: '实验性改动' },
  balance: { icon: 'balance-scale-right', color: 'yellow', desc: '平衡性调整' },
  code: { icon: 'code', color: 'green', desc: '代码改进' },
  code_imp: { icon: 'code', color: 'green', desc: '代码改进' },
  refactor: { icon: 'tools', color: 'green', desc: '代码重构' },
  config: { icon: 'cogs', color: 'purple', desc: '配置' },
  admin: { icon: 'user-shield', color: 'purple', desc: '管理功能' },
  server: { icon: 'server', color: 'purple', desc: '服务器' },
  tgs: { icon: 'toolbox', color: 'purple', desc: '服务器（TGS）' },
  tweak: { icon: 'wrench', color: 'green', desc: '调整' },
  ui: { icon: 'desktop', color: 'blue', desc: '界面' },
  mapadd: { icon: 'earth-africa', color: 'yellow', desc: '新增地图' },
  maptweak: { icon: 'map-location-dot', color: 'green', desc: '地图调整' },
  unknown: { icon: 'info-circle', color: 'label', desc: '未知' },
};

export class Changelog extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: '正在载入更新日志……',
      selectedDate: '',
      selectedIndex: 0,
    };
    this.dateChoices = [];
  }

  setData(data) {
    this.setState({ data });
  }

  setSelectedDate(selectedDate) {
    this.setState({ selectedDate });
  }

  setSelectedIndex(selectedIndex) {
    this.setState({ selectedIndex });
  }

  getData = (date, attemptNumber = 1) => {
    const { act } = useBackend();
    const self = this;
    const maxAttempts = 6;

    if (attemptNumber > maxAttempts) {
      return this.setData('尝试' + maxAttempts + '次后仍无法载入数据');
    }

    act('get_month', { date });

    fetch(resolveAsset(date + '.yml')).then(async (changelogData) => {
      const result = await changelogData.text();
      const errorRegex = /^Cannot find/;

      if (errorRegex.test(result)) {
        const timeout = 50 + attemptNumber * 50;

        self.setData('正在载入更新日志' + '.'.repeat(attemptNumber + 3));
        setTimeout(() => {
          self.getData(date, attemptNumber + 1);
        }, timeout);
      } else {
        self.setData(yaml.load(result, { schema: yaml.CORE_SCHEMA }));
      }
    });
  };

  componentDidMount() {
    const {
      data: { dates = [] },
    } = useBackend();

    if (dates) {
      dates.forEach((date) =>
        this.dateChoices.push(dateformat(date, 'yyyy年m月', true)),
      );
      this.setSelectedDate(this.dateChoices[0]);
      this.getData(dates[0]);
    }
  }

  render() {
    const { data, selectedDate, selectedIndex } = this.state;
    const {
      data: { dates },
    } = useBackend();
    const { dateChoices } = this;

    const dateDropdown = dateChoices.length > 0 && (
      <Stack mb={1}>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === 0}
            icon={'chevron-left'}
            onClick={() => {
              const index = selectedIndex - 1;

              this.setData('正在载入更新日志……');
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            displayText={selectedDate}
            options={dateChoices}
            onSelected={(value) => {
              const index = dateChoices.indexOf(value);

              this.setData('正在载入更新日志……');
              this.setSelectedIndex(index);
              this.setSelectedDate(value);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
            selected={selectedDate}
            width="150px"
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === dateChoices.length - 1}
            icon={'chevron-right'}
            onClick={() => {
              const index = selectedIndex + 1;

              this.setData('正在载入更新日志……');
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
      </Stack>
    );

    const header = (
      <Section>
        <h1>殖民地陆战队：空间站13</h1>
        <p>
          <b>致谢：</b>
          感谢Baystation 12、/tg/station、/vg/station、NTstation、CDK Station、
          FacepunchStation和GoonStation的开发者，空间站13的最初开发者，
          提供标题图的Invisty，以及多年来为游戏、问题追踪和维基作出贡献的无数参与者。
        </p>
        <p>
          {'项目当前维护者名单见'}
          <a href="https://github.com/orgs/cmss13-devs/people">此处</a>
          {'，近期GitHub贡献者见'}
          <a href="https://github.com/cmss13-devs/cmss13/pulse/monthly">此处</a>
          .
        </p>
        <p>
          {'你也可以加入我们的Discord：'}
          <a href="https://discord.gg/cmss13">此处</a>。
        </p>
        {dateDropdown}
      </Section>
    );

    const footer = (
      <Section>
        {dateDropdown}
        <h3>CM 13开发团队</h3>
        <h3>殖民地陆战队：空间站13许可协议</h3>
        <p>
          {'在'}
          <a
            href={
              'https://github.com/cmss13-devs/cmss13/commit/' +
              '9a001bf520f889b434acd295253a1052420860af'
            }
          >
            2020/14/9的提交9a001bf520f889b434acd295253a1052420860af
          </a>
          {'之后的所有代码采用'}
          <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU AGPL v3</a>
          {'许可协议。该提交之前的所有代码采用'}
          <a href="https://www.gnu.org/licenses/gpl-3.0.html">GNU GPL v3</a>
          {'许可协议，工具也包括在内，除非其自述文件另有说明。详情请参阅'}
          <a href="https://github.com/cmss13-devs/cmss13/blob/master/LICENSE">
            LICENSE
          </a>
          {'和'}
          <a href="https://github.com/cmss13-devs/cmss13/blob/master/LICENSE-GPL3">
            GPLv3.txt
          </a>
          {'。'}
        </p>
        <p>
          TGS DMAPI API作为子项目采用MIT许可协议。
          {'MIT许可协议见'}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/__DEFINES/tgs.dm'
            }
          >
            code/__DEFINES/tgs.dm
          </a>
          {'和'}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/modules/tgs/LICENSE'
            }
          >
            code/modules/tgs/LICENSE
          </a>
          {'底部的说明。'}
        </p>
        <p>
          {'所有资源（包括图标和音效）均采用'}
          <a href="https://creativecommons.org/licenses/by-sa/3.0/">
            知识共享署名-相同方式共享3.0许可协议
          </a>
          {'，除非另有说明。'}
        </p>
      </Section>
    );

    const changes =
      typeof data === 'object' &&
      Object.keys(data).length > 0 &&
      Object.entries(data)
        .reverse()
        .map(([date, authors]) => (
          <Section key={date} title={dateformat(date, 'yyyy年m月d日', true)}>
            <Box ml={3}>
              {Object.entries(authors).map(([name, changes]) => (
                <Fragment key={name}>
                  <h4>{name} changed:</h4>
                  <Box ml={3}>
                    <Table>
                      {changes.map((change) => {
                        const changeKey = Object.keys(change)[0];
                        const changeType =
                          changeTypes[changeKey] || changeTypes['unknown'];
                        return (
                          <Table.Row key={changeKey + change[changeKey]}>
                            <Table.Cell
                              className={classes([
                                'Changelog__Cell',
                                'Changelog__Cell--Icon',
                              ])}
                            >
                              <Tooltip
                                position="right"
                                content={changeType.desc}
                              >
                                <Icon
                                  color={changeType.color}
                                  name={changeType.icon}
                                />
                              </Tooltip>
                            </Table.Cell>
                            <Table.Cell className="Changelog__Cell">
                              {change[changeKey]}
                            </Table.Cell>
                          </Table.Row>
                        );
                      })}
                    </Table>
                  </Box>
                </Fragment>
              ))}
            </Box>
          </Section>
        ));

    return (
      <Window title="更新日志" width={675} height={650}>
        <Window.Content scrollable>
          {header}
          {changes}
          {typeof data === 'string' && <p>{data}</p>}
          {footer}
        </Window.Content>
      </Window>
    );
  }
}
