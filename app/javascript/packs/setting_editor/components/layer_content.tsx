/** @jsx jsx */

import { jsx, css } from '@emotion/react';
import React from 'react';
import { LayerKey } from 'types/layer';

type Props = {
  layerKey: LayerKey;
};

export const LayerContent = ({ layerKey }: Props) => {
  return(
    <>
      <div>
        ここに{layerKey}のボタンの設定が並びます
      </div>
    </>
  )
}
