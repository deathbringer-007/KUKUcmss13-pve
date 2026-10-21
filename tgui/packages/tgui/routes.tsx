/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useBackend } from './backend';
import { useDebug } from './debug';
import { LoadingScreen } from './interfaces/common/LoadingToolbox';
import { Window } from './layouts';

const requireInterface = require.context('./interfaces');

const routingError =
  (type: 'notFound' | 'missingExport', name: string) => () => {
    return (
      <Window>
        <Window.Content scrollable>
          {type === 'notFound' && (
            <div>
              未找到界面<b>{name}</b>。
            </div>
          )}
          {type === 'missingExport' && (
            <div>
              界面<b>{name}</b>缺少导出组件。
            </div>
          )}
        </Window.Content>
      </Window>
    );
  };

// Displays an empty Window with scrollable content
const SuspendedWindow = () => {
  return (
    <Window>
      <Window.Content scrollable />
    </Window>
  );
};

// Displays a loading screen with a spinning icon
const RefreshingWindow = () => {
  return (
    <Window title="正在加载">
      <Window.Content>
        <LoadingScreen />
      </Window.Content>
    </Window>
  );
};

// Get the component for the current route
export const getRoutedComponent = () => {
  const { suspended, config } = useBackend();
  const { kitchenSink = false } = useDebug();

  if (suspended) {
    return SuspendedWindow;
  }
  if (config?.refreshing) {
    return RefreshingWindow;
  }
  if (process.env.NODE_ENV !== 'production') {
    // Show a kitchen sink
    if (kitchenSink) {
      return require('./debug').KitchenSink;
    }
  }

  const name = config?.interface;
  const interfacePathBuilders = [
    (name: string) => `./${name}.tsx`,
    (name: string) => `./${name}.jsx`,
    (name: string) => `./${name}/index.tsx`,
    (name: string) => `./${name}/index.jsx`,
  ];
  let esModule;
  while (!esModule && interfacePathBuilders.length > 0) {
    const interfacePathBuilder = interfacePathBuilders.shift()!;
    const interfacePath = interfacePathBuilder(name);
    try {
      esModule = requireInterface(interfacePath);
    } catch (err) {
      if (err.code !== 'MODULE_NOT_FOUND') {
        throw err;
      }
    }
  }
  if (!esModule) {
    return routingError('notFound', name);
  }
  const Component = esModule[name];
  if (!Component) {
    return routingError('missingExport', name);
  }
  return Component;
};
