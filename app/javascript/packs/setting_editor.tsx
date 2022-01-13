/** @jsx jsx */

import { jsx } from '@emotion/react';

import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import { ButtonsSetting } from './setting_editor/components/main';
import { Button } from 'types/button';
import {
  InstalledModeMap,
  InstalledMacroMap,
  PluginClassNamespace,
} from 'types/plugin';
import { Layer } from 'types/layer';
import { SettingContext } from './setting_editor/setting_context';

export interface SettingProviderProps {
  children: React.ReactNode;
}

// { a => true, b => false, c => true } を [a, c] にする
const toArrayOnlyTrue = (
  obj: InstalledMacroMap | InstalledModeMap
): Array<PluginClassNamespace> => {
  return Object.keys(obj).reduce((acc, EntreyName: PluginClassNamespace) => {
    if (obj[EntreyName]) {
      acc.push(EntreyName);
    }
    return acc;
  }, []);
};

// [a, c] を { a => true, c => true } にする
const toMapAndFillingWithTrue = (
  array: Array<PluginClassNamespace>
): InstalledModeMap | InstalledMacroMap => {
  return array.reduce((hash, item) => {
    hash[item] = true;
    return hash;
  }, {} as InstalledModeMap | InstalledMacroMap);
};

const SettingProvider = ({ children }: SettingProviderProps) => {
  const sourceElem = document.getElementById('config-prefix-keys');
  const defaultPrefixKeys: Array<Button> = JSON.parse(
    sourceElem.dataset.configPrefixKeys
  );
  const defaultInstalledModes: Array<PluginClassNamespace> = JSON.parse(
    sourceElem.dataset.configInstalledModes
  );
  const defaultInstalledMacros: Array<PluginClassNamespace> = JSON.parse(
    sourceElem.dataset.configInstalledMacros
  );
  const sourceLayers = JSON.parse(sourceElem.dataset.configLayers);

  const [installedModeMap, setInstalledModeMap] = useState(
    toMapAndFillingWithTrue(defaultInstalledModes)
  );

  const availableModes = toArrayOnlyTrue(installedModeMap);

  const [installedMacroMap, setInstalledMacroMap] = useState(
    toMapAndFillingWithTrue(defaultInstalledMacros)
  );

  const availableMacros = toArrayOnlyTrue(installedMacroMap);

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
