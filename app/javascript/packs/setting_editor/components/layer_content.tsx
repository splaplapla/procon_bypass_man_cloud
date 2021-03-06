/** @jsx jsx */

import { jsx, css } from '@emotion/react';
import React from 'react';
import { LayerKey } from 'types/layer';
import { ModeSetting } from '../../setting_editor/components/mode_setting';
import { MacroSetting } from '../../setting_editor/components/macro_setting';

type Props = {
  layerKey: LayerKey;
};

export const LayerContent = ({ layerKey }: Props) => {
  return (
    <>
      <div>
        ここに{layerKey}のボタンの設定が並びます
        <h4>モード</h4>
        <ModeSetting layerKey={layerKey} />
        <h4>マクロ</h4>
        <MacroSetting layerKey={layerKey} />
      </div>
    </>
  );
};
