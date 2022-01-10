/** @jsx jsx */

import { jsx, css } from '@emotion/react';
import React, { useContext } from 'react';
import { LayerKey } from 'types/layer';
import { SettingContext } from './../../setting_editor/setting_context';

type Props = {
  layerKey: LayerKey;
};

export const MacroSetting = ({ layerKey }: Props) => {
  const { availableMacros } = useContext(SettingContext);
  const available = () => {
    return availableMacros;
  };

  return (
    <>
      <ul>
        {available().map((name) => {
          return <li>{name}</li>;
        })}
      </ul>
    </>
  );
};
