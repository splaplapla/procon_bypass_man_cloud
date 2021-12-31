/** @jsx jsx */

import { jsx } from '@emotion/react';

import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import { ButtonsSetting } from './setting_editor/components/main';
import { Button } from 'types/button';
import { InstalledModeMap, InstalledMacroMap } from 'types/plugin';
import { SettingContext } from './setting_editor/setting_context';

export interface SettingProviderProps  {
   children: React.ReactNode
}

const SettingProvider = ({ children }: SettingProviderProps) => {
  const sourceElem = document.getElementById('config-prefix-keys');
  const defaultPrefixKeys: Array<Button> = JSON.parse(
    sourceElem.dataset.configPrefixKeys
  );
  const defaultInstalledModes: Array<Button> = JSON.parse(
    sourceElem.dataset.configInstalledModes
  );
  const defaultInstalledMacros: Array<Button> = JSON.parse(
    sourceElem.dataset.configInstalledMacros
  );

  const [installedModeMap, setInstalledModeMap] = useState(
    defaultInstalledModes.reduce((hash, item) => {
      hash[item] = true;
      return hash;
    }, {}) as InstalledModeMap
  );

  const [installedMacroMap, setInstalledMacroMap] = useState(
    defaultInstalledMacros.reduce((hash, item) => {
      hash[item] = true;
      return hash;
    }, {}) as InstalledMacroMap
  );
  const [prefixKeys, setPrefixKeys] = useState(defaultPrefixKeys);

  const value = {
    prefixKeys,
    setPrefixKeys,
    installedModeMap,
    setInstalledModeMap,
    installedMacroMap,
    setInstalledMacroMap,
  };
  return (
    <>
      <SettingContext.Provider value={value}>
        {children}
      </SettingContext.Provider>

      <hr />
      <h1>debug</h1>
      prefixKeys: {prefixKeys.join(',')}
      <br />
      installedModeMap: {Object.entries(installedModeMap).join(',')}
      <br />
      installedMacroMap: {Object.entries(installedMacroMap).join(',')}
      <br />
    </>
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
