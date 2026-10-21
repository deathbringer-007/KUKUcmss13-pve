import { toFixed } from 'common/math';
import { useDispatch, useSelector } from 'tgui/backend';
import {
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Slider,
  Stack,
} from 'tgui/components';

import { updateSettings } from '../actions';
import { selectSettings } from '../selectors';

const TabsViews = ['default', 'classic', 'scrollable'];
const LinkedToChat = () => (
  <NoticeBox color="red">请先解除状态面板与聊天的关联！</NoticeBox>
);

export function SettingsStatPanel(props) {
  const { statLinked, statFontSize, statTabsStyle } =
    useSelector(selectSettings);
  const dispatch = useDispatch();

  return (
    <Section fill>
      <Stack fill vertical>
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="选项卡" verticalAlign="middle">
              {TabsViews.map((view) => (
                <Button
                  key={view}
                  color="transparent"
                  selected={statTabsStyle === view}
                  onClick={() =>
                    dispatch(updateSettings({ statTabsStyle: view }))
                  }
                >
                  {view === 'classic'
                    ? '经典'
                    : view === 'scrollable'
                      ? '滚动'
                      : '默认'}
                </Button>
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="字号">
              <Stack.Item grow>
                {statLinked ? (
                  <LinkedToChat />
                ) : (
                  <Slider
                    width="100%"
                    step={1}
                    stepPixelSize={20}
                    minValue={8}
                    maxValue={32}
                    value={statFontSize}
                    unit="px"
                    format={(value) => toFixed(value)}
                    onChange={(e, value) =>
                      dispatch(updateSettings({ statFontSize: value }))
                    }
                  />
                )}
              </Stack.Item>
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Divider mt={2.5} />
        <Stack.Item textAlign="center">
          <Button
            fluid
            icon={statLinked ? 'unlink' : 'link'}
            color={statLinked ? 'bad' : 'good'}
            onClick={() =>
              dispatch(updateSettings({ statLinked: !statLinked }))
            }
          >
            {statLinked ? '解除与聊天的关联' : '与聊天关联'}
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
}
