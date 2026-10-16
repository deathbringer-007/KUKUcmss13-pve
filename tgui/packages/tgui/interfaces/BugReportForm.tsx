import { BooleanLike } from 'common/react';
import React, { useState } from 'react';

import { useBackend } from '../backend';
import { Flex, Section } from '../components';
import { ButtonCheckbox } from '../components/Button';
import { Window } from '../layouts';
interface FormTypes {
  awaiting_admin_approval: BooleanLike;
  report_details: FormDetails;
}

// all the information necessary to pass into the github api
type FormDetails = {
  steps: string;
  title: string;
  description: string;
  expected_behavior: string;
  admin_note: string;
  log: string;
};

const InputTitle = (props) => {
  return (
    <h2>
      {props.children}
      {props.required && <span className="input-title-required">{' *'}</span>}
    </h2>
  );
};

export const BugReportForm = (props) => {
  const { act, data } = useBackend<FormTypes>();
  const { awaiting_admin_approval, report_details } = data;
  const [checkBox, setCheckbox] = useState(false);

  const [title, setTitle] = useState(report_details?.title || '');
  const [steps, setSteps] = useState(report_details?.steps || '');
  const [description, setDescription] = useState(
    report_details?.description || '',
  );
  const [expected_behavior, setExpectedBehavior] = useState(
    report_details?.expected_behavior || '',
  );
  const [admin_note, setAdminNote] = useState(report_details?.admin_note || '');
  const [log, setLog] = useState(report_details?.log || '');

  const submit = () => {
    if (!title || !description || !expected_behavior || !steps || !checkBox) {
      alert('请填写所有必填项！');
      return;
    }
    const updatedReportDetails = {
      title,
      steps,
      description,
      expected_behavior,
      admin_note,
      log,
    };
    act('confirm', updatedReportDetails);
  };

  return (
    <Window
      title={'问题报告表'}
      width={700}
      height={awaiting_admin_approval ? 1000 : 700}
    >
      <Window.Content>
        <Section fill scrollable>
          <Flex direction="column" height="100%">
            <Flex.Item className="text-center">
              <a
                href="https://github.com/cmss13-devs/cmss13/issues"
                target="_blank"
                rel="noreferrer"
                className="link"
              >
                GitHub仓库
              </a>
            </Flex.Item>
            <Flex.Item>
              <h2 className="tip">
                {'提示：请尽可能详细地描述问题，这对排查非常有帮助。'}
              </h2>
            </Flex.Item>
            <Flex.Item>
              <InputTitle required>{'标题'}</InputTitle>
              <input
                width="100%"
                className="textarea"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>{'问题描述'}</InputTitle>
              {'请描述遇到的问题'}
              <textarea
                rows={3}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>{'实际结果与预期有何不同？'}</InputTitle>
              {'请描述你预期会发生什么'}
              <textarea
                rows={3}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={expected_behavior}
                onChange={(e) => setExpectedBehavior(e.target.value)}
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>{'如何重现这个问题？'}</InputTitle>
              {'请列出重现问题的操作步骤，越详细越好'}
              <textarea
                rows={4}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={steps}
                onChange={(e) => setSteps(e.target.value)}
                placeholder={'1) 第一步\n2) 第二步\n3) 第三步\n'}
              />
            </Flex.Item>
            {!!awaiting_admin_approval && (
              <Flex.Item my={2}>
                <InputTitle>{'Admin note'}</InputTitle>
                {"Any additional notes to submit with the author's bug report "}
                <textarea
                  rows={4}
                  className="textarea"
                  onInput={(e) => {
                    const target = e.target as HTMLTextAreaElement;
                    target.style.height = 'auto';
                    target.style.height = `${target.scrollHeight}px`;
                  }}
                  value={admin_note}
                  onChange={(e) => setAdminNote(e.target.value)}
                />
              </Flex.Item>
            )}
            <Flex.Item my={2}>
              <InputTitle>{'日志'}</InputTitle>
              {'请在此处粘贴相关日志'}
              <textarea
                rows={4}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={log}
                onChange={(e) => setLog(e.target.value)}
              />
            </Flex.Item>
            <Flex.Item my={2} className={'text-center'}>
              <ButtonCheckbox
                checked={checkBox}
                onClick={() => {
                  setCheckbox(!checkBox);
                }}
              >
                {awaiting_admin_approval
                  ? 'I confirm that this bug report follows all GitHub TOS'
                  : '我已在GitHub上搜索过，没有找到同样的问题报告'}
                {!checkBox && (
                  <span className="input-title-required">{' *'}</span>
                )}
              </ButtonCheckbox>
            </Flex.Item>
            <Flex.Item my={2}>
              <Flex className="flex-center">
                <Flex.Item mx={1}>
                  <div className="button-cancel" onClick={() => act('cancel')}>
                    {awaiting_admin_approval ? 'Reject' : '取消'}
                  </div>
                </Flex.Item>
                <Flex.Item mx={1}>
                  <div className="button-submit" onClick={submit}>
                    {awaiting_admin_approval ? 'Approve' : '提交'}
                  </div>
                </Flex.Item>
              </Flex>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
