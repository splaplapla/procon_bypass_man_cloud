/** @jsx jsx */

import { jsx, css } from '@emotion/react';

import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import { ButtonsSetting } from './setting_editor/components/main';
import { Button } from 'types/button';
import { Layers } from 'types/layer';
import { SettingContext } from './setting_editor/setting_context';

const SettingProvider = ({ children }) => {
  const initLayers: Layers = {
    installed_modes: {},
  };
  const [prefixKeys, setPrefixKeys] = useState([] as Array<Button>);
  const value = {
    prefixKeys,
  };
  return (
    <SettingContext.Provider value={value}>{children}</SettingContext.Provider>
  );
};

export const ButtonsSettingPage = () => {
  const prefixKeys = JSON.parse(
    document.getElementById('config-prefix-keys').dataset.configPrefixKeys
  ) as Array<Button>;

  return (
    <>
      <SettingProvider>
        <ButtonsSetting defaultPrefixKeys={prefixKeys} />
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
