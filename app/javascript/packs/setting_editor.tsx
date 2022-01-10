/** @jsx jsx */

import { jsx } from '@emotion/react';

import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import { ButtonsSetting } from './setting_editor/components/main';
import { Button } from 'types/button';
import {
  InstalledModeMap,
  InstalledMacroMap,
  ModeClassNamespace,
} from 'types/plugin';
import { Layer } from 'types/layer';
import { SettingContext } from './setting_editor/setting_context';

export interface SettingProviderProps {
  children: React.ReactNode;
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
  const sourceLayers = JSON.parse(sourceElem.dataset.configLayers);

  const [installedModeMap, setInstalledModeMap] = useState(
    defaultInstalledModes.reduce((hash, item) => {
      hash[item] = true;
      return hash;
    }, {}) as InstalledModeMap
  );

  const availableModes = Object.keys(installedModeMap).reduce(
    (acc, modeName: ModeClassNamespace) => {
      if (installedModeMap[modeName]) {
        acc.push(modeName);
      }
      return acc;
    },
    []
  );

  const [installedMacroMap, setInstalledMacroMap] = useState(
    defaultInstalledMacros.reduce((hash, item) => {
      hash[item] = true;
      return hash;
    }, {}) as InstalledMacroMap
  );

  const availableMacros = Object.keys(installedMacroMap).reduce(
    (acc, modeName) => {
      if (installedMacroMap[modeName]) {
        acc.push(modeName);
      }
      return acc;
    },
    []
  );

  const [prefixKeys, setPrefixKeys] = useState(defaultPrefixKeys);
  const defaultLayer = {
    up: { mode: sourceLayers.up.mode } as Layer,
    down: { mode: sourceLayers.down.mode } as Layer,
    left: { mode: sourceLayers.left.mode } as Layer,
    right: { mode: sourceLayers.right.mode } as Layer,
  };

  const [layers, setLayers] = useState(defaultLayer);

  const value = {
    prefixKeys,
    setPrefixKeys,
    installedModeMap,
    setInstalledModeMap,
    installedMacroMap,
    setInstalledMacroMap,
    layers,
    setLayers,
    availableModes,
    availableMacros,
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
      availableModes: {availableModes}
      <br />
      <ul>
        <li>layers.up.mode: {layers.up.mode}</li>
        <li>layers.down.mode: {layers.down.mode}</li>
        <li>layers.left.mode: {layers.left.mode}</li>
        <li>layers.right.mode: {layers.right.mode}</li>
      </ul>
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
