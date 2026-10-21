/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { toFixed } from 'common/math';
import { useDispatch, useSelector } from 'tgui/backend';
import { Button, Collapsible, Knob, Section, Stack } from 'tgui/components';

import { useSettings } from '../settings';
import { selectAudio } from './selectors';
import type { AudioState } from './types';

export const NowPlayingWidget = (props) => {
  const audio: AudioState = useSelector(selectAudio),
    dispatch = useDispatch(),
    settings = useSettings(),
    title = audio.meta?.title,
    URL = audio.meta?.link,
    Artist = audio.meta?.artist || 'Unknown Artist',
    upload_date = audio.meta?.upload_date || 'Unknown Date',
    album = audio.meta?.album || 'Unknown Album',
    duration = audio.meta?.duration,
    date = !isNaN(Number(upload_date))
      ? upload_date?.substring(0, 4) +
        '-' +
        upload_date?.substring(4, 6) +
        '-' +
        upload_date?.substring(6, 8)
      : upload_date;

  return (
    <Stack align="center">
      {(audio.playing && (
        <Stack.Item
          mx={0.5}
          grow
          style={{
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
          }}
        >
          {
            <Collapsible title={title || '未知曲目'} color={'blue'}>
              <Section>
                {URL !== 'Song Link Hidden' && (
                  <Stack.Item grow color="label">
                    链接：{URL}
                  </Stack.Item>
                )}
                <Stack.Item grow color="label">
                  时长：{duration}
                </Stack.Item>
                {Artist !== 'Song Artist Hidden' &&
                  Artist !== 'Unknown Artist' && (
                    <Stack.Item grow color="label">
                      艺术家：{Artist}
                    </Stack.Item>
                  )}
                {album !== 'Song Album Hidden' && album !== 'Unknown Album' && (
                  <Stack.Item grow color="label">
                    专辑：{album}
                  </Stack.Item>
                )}
                {upload_date !== 'Song Upload Date Hidden' &&
                  upload_date !== 'Unknown Date' && (
                    <Stack.Item grow color="label">
                      上传日期：{date}
                    </Stack.Item>
                  )}
              </Section>
            </Collapsible>
          }
        </Stack.Item>
      )) || (
        <Stack.Item grow color="label">
          暂无播放内容。
        </Stack.Item>
      )}
      {audio.playing && (
        <Stack.Item mx={0.5} fontSize="0.9em">
          <Button
            tooltip="停止"
            icon="stop"
            onClick={() =>
              dispatch({
                type: 'audio/stopMusic',
              })
            }
          />
        </Stack.Item>
      )}
      <Stack.Item mx={0.5} fontSize="0.9em">
        <Knob
          minValue={0}
          maxValue={1}
          value={settings.adminMusicVolume}
          step={0.0025}
          stepPixelSize={1}
          format={(value) => toFixed(value * 100) + '%'}
          onDrag={(e, value) =>
            settings.update({
              adminMusicVolume: value,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};
