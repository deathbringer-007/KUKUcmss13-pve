import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Stack, Tabs } from '../components';
import { BoxProps } from '../components/Box';
import { Table, TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

export interface DocumentLog {
  ['XRF Scans']?: Array<DocumentRecord>;
}

export interface DocumentRecord {
  document_title: string;
  time: string;
  document: string;
  category: string;
}

interface TerminalProps {
  clearance_level: number;
  research_documents: DocumentLog;
  published_documents: DocumentLog;
  rsc_credits: number;
  broker_cost: number;
  base_purchase_cost: number;
  main_terminal: number;
  terminal_view: number;
  clearance_x_access: number;
  photocopier_error: number;
  printer_toner: number;
}

interface ConfirmationProps extends BoxProps {
  readonly onConfirm: () => any;
  readonly onCancel: () => any;
}

const ConfirmationDialogue = (props: ConfirmationProps) => {
  return (
    <Stack vertical className="Confirm-Dialogue">
      <Stack.Item>{props.children}</Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              className="Button ConfirmButton"
              icon="check"
              onClick={props.onConfirm}
            >
              确认
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon="cancel" onClick={props.onCancel}>
              取消
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const NoCompoundsDetected = () => {
  return <span>错误：未检测到化学物质。</span>;
};

interface CompoundRecordProps extends BoxProps {
  readonly compound: CompoundData;
  readonly canPrint: boolean;
}

const CompoundRecord = (props: CompoundRecordProps) => {
  const { data, act } = useBackend<TerminalProps>();
  const isMainTerminal = data.main_terminal === 1;
  const { compound } = props;
  const doc_ref = {
    print_type: compound.category,
    print_title: compound.id,
  };
  return (
    <TableRow key={compound.id}>
      <TableCell>
        <span className="compound_label">{compound.type.time}</span>
      </TableCell>

      <TableCell>
        <span className="compound_label">{compound.type.doctype}</span>
      </TableCell>

      <TableCell className="chemical-td">
        {compound.type.document.split(' ')[0] === 'Simulation' ? (
          <span className="compound_label">
            {compound.type.document.split(' ')[3]}
          </span>
        ) : (
          <span className="compound_label">
            {compound.type.document.split(' ')[2]}
          </span>
        )}
      </TableCell>

      <TableCell>
        <Flex
          className="compound_actions"
          justify="space-around"
          align-items="stretch"
          wrap={false}
        >
          <Flex.Item>
            <Button icon="book" onClick={() => act('read_document', doc_ref)}>
              阅读
            </Button>
          </Flex.Item>
          {props.canPrint && (
            <Flex.Item>
              <Button
                disabled={data.photocopier_error || data.printer_toner === 0}
                icon="print"
                onClick={() => act('print', doc_ref)}
              >
                打印
              </Button>
            </Flex.Item>
          )}
          {isMainTerminal && !compound.isPublished && (
            <Flex.Item>
              <Button
                icon="upload"
                onClick={() => act('publish_document', doc_ref)}
              >
                发布
              </Button>
            </Flex.Item>
          )}
          {isMainTerminal && compound.isPublished && (
            <Flex.Item>
              <Button
                icon="remove"
                onClick={() => act('unpublish_document', doc_ref)}
              >
                撤回发布
              </Button>
            </Flex.Item>
          )}
        </Flex>
      </TableCell>
    </TableRow>
  );
};

interface DocInfo {
  time: string;
  document: string;
  doctype: string;
}

interface CompoundData {
  id: string;
  category: string;
  docNumber: number;
  type: DocInfo;
  isPublished: boolean;
}

const ResearchReportTable = (props: {
  readonly hideOld: boolean;
  readonly setHideOld: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
  const { data } = useBackend<TerminalProps>();
  const { hideOld, setHideOld } = props;
  const documents = Object.keys(data.research_documents)
    .map((x) => {
      const output = data.research_documents[x] as DocumentRecord[];
      output.forEach((y) => {
        y.category = x;
      });
      return output;
    })
    .flat() as DocumentRecord[];
  return (
    <Stack vertical>
      <Stack.Item>
        <Flex justify="space-between" fill={1}>
          <Flex.Item>
            {hideOld && (
              <Button onClick={() => setHideOld(false)}>
                显示全部报告
              </Button>
            )}
            {!hideOld && (
              <Button onClick={() => setHideOld(true)}>隐藏旧报告</Button>
            )}
          </Flex.Item>
        </Flex>
      </Stack.Item>
      <hr />
      <Stack.Item>
        <CompoundTable
          hideOld={hideOld}
          docs={documents}
          timeLabel="扫描时间"
          canPrint
        />
      </Stack.Item>
    </Stack>
  );
};

export interface CompoundTableProps extends BoxProps {
  readonly docs: DocumentRecord[];
  readonly timeLabel: string;
  readonly canPrint: boolean;
  readonly hideOld?: boolean | true;
}

export const CompoundTable = (props: CompoundTableProps) => {
  const { data } = useBackend<TerminalProps>();
  const published = Object.keys(data.published_documents)
    .map((x) => {
      const output = data.published_documents[x] as DocumentRecord[];
      output.forEach((y) => {
        y.category = x;
      });
      return output;
    })
    .flat() as DocumentRecord[];
  const [sortby, setSortBy] = useState('time');
  const [sortdir, setSortdir] = useState('asc');
  const { docs, hideOld } = props;

  const outputDocs: Map<String, CompoundData> = new Map();
  docs
    .map<CompoundData>((x) => {
      const document_prefix = x.document_title.split(' ')[0];
      const doc_number = Number.parseInt(document_prefix, 10);
      const doctype: DocInfo = {
        doctype: Number.isNaN(doc_number) ? '合成' : '分析',
        document: x.document,
        time: x.time,
      };
      const isPublished = (chemName: string) =>
        published.filter((x) => x.document_title.includes(chemName)).length > 0;

      return {
        id: x.document_title,
        category: x.category,
        docNumber: Number.isNaN(doc_number) ? 0 : doc_number,
        type: doctype,
        isPublished: isPublished(doctype.document),
      };
    })
    .forEach((x) => {
      if (hideOld) {
        if (!outputDocs.has(x.type.document)) {
          outputDocs.set(x.type.document, x);
          return;
        }

        if (
          x.type.time.localeCompare(
            outputDocs.get(x.type.document)?.type.time ?? '',
          )
        ) {
          outputDocs.set(x.type.document, x);
        }
      } else {
        outputDocs.set(x.id + x.type.time, x);
      }
    });

  if (outputDocs.size === 0) {
    return <NoCompoundsDetected />;
  }

  const iconRef = (name: string, isNum: boolean) =>
    sortby === name
      ? sortdir === 'asc'
        ? isNum
          ? 'arrow-down-1-9'
          : 'arrow-down-a-z' // small to big
        : isNum
          ? 'arrow-down-9-1'
          : 'arrow-down-z-a' // big to small
      : 'space';

  const sortColClick = (name: string) => {
    if (sortby === name) {
      setSortdir(sortdir === 'asc' ? 'desc' : 'asc');
    } else {
      setSortBy(name);
    }
  };

  return (
    <Table className={props.className}>
      <TableRow>
        <TableCell textAlign="center">
          <Button
            icon={iconRef('time', true)}
            onClick={() => sortColClick('time')}
          >
            {props.timeLabel}
          </Button>
        </TableCell>
        <TableCell textAlign="center">
          <span>类型</span>
        </TableCell>
        <TableCell textAlign="center">
          <Button
            icon={iconRef('name', false)}
            onClick={() => sortColClick('name')}
          >
            化合物
          </Button>
        </TableCell>
        <TableCell textAlign="center">
          <span>操作</span>
        </TableCell>
      </TableRow>
      {Array.from(outputDocs.values())
        .sort((a, b) => {
          if (sortby === 'time') {
            if (sortdir === 'asc') {
              return a.type.time < b.type.time ? -1 : 1;
            } else {
              return a.type.time > b.type.time ? -1 : 1;
            }
          } else {
            if (sortdir === 'asc') {
              return a.type.document.localeCompare(b.type.document);
            } else {
              return b.type.document.localeCompare(a.type.document);
            }
          }
        })
        .map((x, i) => (
          <CompoundRecord compound={x} key={i} canPrint={props.canPrint} />
        ))}
    </Table>
  );
};

const PhotocopierMissing = () => {
  return <span>错误：未找到已连接的打印机。</span>;
};

const TonerEmpty = () => {
  return <span>错误：打印机墨粉已用尽。</span>;
};

const ImproveClearanceConfirmation = (props: {
  readonly isConfirm: string | undefined;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
}) => {
  const { data, act } = useBackend<TerminalProps>();
  const { isConfirm, setConfirm } = props;
  if (isConfirm === undefined || isConfirm !== 'broker_clearance') {
    return null;
  }
  return (
    <Stack vertical>
      <Stack.Item>
        <ConfirmationDialogue
          onConfirm={() => {
            act('broker_clearance');
            setConfirm(undefined);
          }}
          onCancel={() => setConfirm(undefined)}
        >
          <span>
            确定要花费 <u>{data.broker_cost}</u> 点研究积分立即提升权限等级吗？
          </span>
        </ConfirmationDialogue>
      </Stack.Item>
    </Stack>
  );
};

const XClearanceConfirmation = (props: {
  readonly isConfirm: string | undefined;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
}) => {
  const { data, act } = useBackend<TerminalProps>();
  const { isConfirm, setConfirm } = props;
  if (isConfirm === undefined || isConfirm !== 'request_clearance_x_access') {
    return null;
  }
  return (
    <Stack vertical>
      <Stack.Item>
        <ConfirmationDialogue
          onConfirm={() => {
            act('request_clearance_x_access');
            setConfirm(undefined);
          }}
          onCancel={() => setConfirm(undefined)}
        >
          <span>
            确定要申请 <u>X</u> 级权限吗？费用为 <u>5</u> 点研究积分。
          </span>
        </ConfirmationDialogue>
      </Stack.Item>
    </Stack>
  );
};

const ResearchManager = (props: {
  readonly isConfirm: string | undefined;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
}) => {
  const { data } = useBackend<TerminalProps>();
  const { isConfirm, setConfirm } = props;
  return (
    <Box>
      <Stack vertical>
        <Stack.Item>
          <span>可用研究积分：{data.rsc_credits}</span>
        </Stack.Item>
      </Stack>
      <hr />
      <ImproveClearanceConfirmation
        isConfirm={isConfirm}
        setConfirm={setConfirm}
      />
      <XClearanceConfirmation isConfirm={isConfirm} setConfirm={setConfirm} />
    </Box>
  );
};

const ErrorStack = () => {
  const { data } = useBackend<TerminalProps>();
  return (
    <Stack>
      {data.photocopier_error === 1 && (
        <Stack.Item>
          <PhotocopierMissing />
        </Stack.Item>
      )}
      {data.printer_toner === 0 && (
        <Stack.Item>
          <TonerEmpty />
        </Stack.Item>
      )}
    </Stack>
  );
};

const PublishedMaterial = (props: { readonly hideOld: boolean }) => {
  const { data } = useBackend<TerminalProps>();
  const { hideOld } = props;
  const documents = Object.keys(data.published_documents)
    .map((x) => {
      const output = data.published_documents[x] as DocumentRecord[];
      output.forEach((y) => {
        y.category = x;
      });
      return output;
    })
    .flat() as DocumentRecord[];

  return (
    <Stack vertical>
      <Stack.Item>
        <CompoundTable
          hideOld={hideOld}
          docs={documents}
          timeLabel="发布时间"
          canPrint
        />
      </Stack.Item>
    </Stack>
  );
};

const ResearchOverview = (props: {
  readonly isConfirm: string | undefined;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
  readonly selectedTab: number;
  readonly setSelectedTab: React.Dispatch<React.SetStateAction<number>>;
}) => {
  const { isConfirm, setConfirm, selectedTab, setSelectedTab } = props;
  const [hideOld, setHideOld] = useState(true);

  return (
    <div className="TabWrapper">
      <Tabs fluid>
        <Tabs.Tab
          selected={selectedTab === 1}
          onClick={() => {
            setSelectedTab(1);
            setConfirm(undefined);
          }}
          icon="gear"
          color="black"
        >
          研究管理
        </Tabs.Tab>
        <Tabs.Tab
          selected={selectedTab === 2}
          onClick={() => {
            setSelectedTab(2);
            setConfirm(undefined);
          }}
          icon="flask"
          color="black"
        >
          查看化学物质
        </Tabs.Tab>
        <Tabs.Tab
          selected={selectedTab === 3}
          onClick={() => {
            setSelectedTab(3);
            setConfirm(undefined);
          }}
          icon="book"
          color="black"
        >
          已发布资料
        </Tabs.Tab>
      </Tabs>
      <div className="TabbedContent">
        <Stack vertical>
          <Stack.Item>
            <ErrorStack />
          </Stack.Item>
          <Stack.Item>
            {selectedTab === 1 && (
              <ResearchManager isConfirm={isConfirm} setConfirm={setConfirm} />
            )}
            {selectedTab === 2 && (
              <ResearchReportTable hideOld={hideOld} setHideOld={setHideOld} />
            )}
            {selectedTab === 3 && <PublishedMaterial hideOld={hideOld} />}
          </Stack.Item>
        </Stack>
      </div>
    </div>
  );
};

const ClearanceImproveButton = (props: {
  readonly setSelectedTab: React.Dispatch<React.SetStateAction<number>>;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
}) => {
  const { data } = useBackend<TerminalProps>();
  const { setSelectedTab, setConfirm } = props;
  const clearance_level = data.clearance_level;
  const x_access = data.clearance_x_access;
  const isDisabled = data.rsc_credits < data.broker_cost;
  return (
    <>
      {clearance_level < 5 && (
        <Button
          disabled={isDisabled}
          onClick={() => {
            setSelectedTab(1);
            setConfirm('broker_clearance');
          }}
        >
          提升权限（{data.broker_cost} 积分）
        </Button>
      )}
      {clearance_level === 5 && x_access === 0 && (
        <Flex.Item>
          <Button
            disabled={data.rsc_credits < 5}
            onClick={() => {
              setSelectedTab(1);
              setConfirm('request_clearance_x_access');
            }}
          >
            申请 X 级权限（5 积分）
          </Button>
        </Flex.Item>
      )}
      {x_access !== 0 && (
        <Flex.Item>
          <Button disabled>已达到最高权限</Button>
        </Flex.Item>
      )}
    </>
  );
};

export const ResearchTerminal = () => {
  const { data } = useBackend<TerminalProps>();
  const [selectedTab, setSelectedTab] = useState(1);
  const [isConfirm, setConfirm] = useState<string | undefined>(undefined);
  return (
    <Window width={480 * 2} height={320 * 2} theme="crtyellow">
      <Window.Content scrollable className="ResearchTerminal">
        <Section
          title={`权限等级：${data.clearance_level}`}
          buttons={
            <ClearanceImproveButton
              setSelectedTab={setSelectedTab}
              setConfirm={setConfirm}
            />
          }
        >
          <ResearchOverview
            isConfirm={isConfirm}
            setConfirm={setConfirm}
            selectedTab={selectedTab}
            setSelectedTab={setSelectedTab}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
