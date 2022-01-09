/** @jsx jsx */

import { jsx, css } from '@emotion/react';
import React, { useContext } from 'react';
import { LayerKey } from 'types/layer';
import { SettingContext } from './../../setting_editor/setting_context';

type Props = {
  layerKey: LayerKey;
}

export const ModeSetting = ({ layerKey }: Props) => {
  const { availableModes } = useContext(SettingContext);
  const available = () => {
    const l = ["マニュアルモード"]
    availableModes.forEach((modeName) => {
      l.push(modeName);
    });

    return l;
  }

  return(
    <>
      {availableModes.length === 0 && "選択可能なモードがありません"}
      {
        available().map((modeName) => {
          return modeName;
        })
      }
    </>
  )
}
