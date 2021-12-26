/** @jsx jsx */

import { jsx, css } from '@emotion/react';

import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import { ButtonsSetting } from './setting_editor/components/main';
import { Button } from 'types/button';
import { InstalledModeMap } from 'types/plugin';
import { Layers } from 'types/layer';
import { SettingContext } from './setting_editor/setting_context';

const SettingProvider = ({ children }) => {
  const initLayers: Layers = {
    installed_modes: {},
  };
  const defaultPrefixKeys: Array<Button> = JSON.parse(
    document.getElementById('config-prefix-keys').dataset.configPrefixKeys
  );

  const [installedModes, setInstalledModes] = useState({} as InstalledModeMap);
  const [prefixKeys, setPrefixKeys] = useState(defaultPrefixKeys);

  const value = {
    prefixKeys,
    setPrefixKeys,
    installedModes,
    setInstalledModes,
  };
  return (
    <SettingContext.Provider value={value}>{children}</SettingContext.Provider>
  );
};

export const ButtonsSettingPage = () => {
  return (
    <>
      <SettingProvider>
        <ButtonsSetting />
      </SettingProvider>
    </>
  );
};

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ButtonsSettingPage />,
    document.body.appendChild(document.createElement('div'))
  );
});
