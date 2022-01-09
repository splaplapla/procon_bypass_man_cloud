/** @jsx jsx */

import { jsx, css } from '@emotion/react';
import React, { useContext } from 'react';
import { LayerKey } from 'types/layer';
import { SettingContext } from './../../setting_editor/setting_context';

const ManualValue = 'manual';

type ModeItemProps = {
  modeName: string;
  layerKey: LayerKey;
};
const ModeItem = ({ modeName, layerKey }: ModeItemProps) => {
  const { layers } = useContext(SettingContext);
  const handleClick = (e: React.ChangeEvent<HTMLInputElement>) => {};

  const isChecked = () => {
    return layers[layerKey].mode === modeName
  };

  return (
    <>
      <label>
        <input
          type="radio"
          onChange={handleClick}
          checked={isChecked()}
        />
        {modeName}
      </label>
    </>
  );
};

type Props = {
  layerKey: LayerKey;
};
export const ModeSetting = ({ layerKey }: Props) => {
  const { availableModes } = useContext(SettingContext);
  const available = () => {
    const l = [ManualValue];
    availableModes.forEach((modeName) => {
      l.push(modeName);
    });

    return l;
  };

  return (
    <>
      {availableModes.length === 0 && '選択可能なモードがありません'}
      <ul>
        {available().map((modeName) => {
          return (
            <li key={modeName}>
              <ModeItem modeName={modeName} layerKey={layerKey} />
            </li>
          );
        })}
      </ul>
    </>
  );
};
