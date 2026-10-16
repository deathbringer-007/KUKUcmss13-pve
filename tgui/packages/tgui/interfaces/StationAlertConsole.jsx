import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';

export const StationAlertConsole = () => {
  return (
    <Window width={325} height={500} resizable>
      <Window.Content scrollable>
        <StationAlertConsoleContent />
      </Window.Content>
    </Window>
  );
};

export const StationAlertConsoleContent = (props) => {
  const { data } = useBackend();
  const categories = data.alarms || [];
  const fire = categories['Fire'] || [];
  const atmos = categories['Atmosphere'] || [];
  const power = categories['Power'] || [];
  return (
    <>
      <Section title="火灾警报">
        <ul>
          {fire.length === 0 && <li className="color-good">系统正常</li>}
          {fire.map((alert) => (
            <li key={alert} className="color-average">
              {alert}
            </li>
          ))}
        </ul>
      </Section>
      <Section title="大气警报">
        <ul>
          {atmos.length === 0 && (
            <li className="color-good">系统正常</li>
          )}
          {atmos.map((alert) => (
            <li key={alert} className="color-average">
              {alert}
            </li>
          ))}
        </ul>
      </Section>
      <Section title="电力警报">
        <ul>
          {power.length === 0 && (
            <li className="color-good">系统正常</li>
          )}
          {power.map((alert) => (
            <li key={alert} className="color-average">
              {alert}
            </li>
          ))}
        </ul>
      </Section>
    </>
  );
};
