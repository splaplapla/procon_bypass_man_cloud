/** @jsx jsx */

import { jsx, css } from '@emotion/react';
import React from 'react';
import { LayerKey } from 'types/layer';

type Props = {
  activeTab: LayerKey;
  switchTab: (param: LayerKey) => void;
};

export const LayerTab = ({ activeTab, switchTab }: Props) => {
  const layersTabStyle = () => {
    return css`
      list-style: none;
      display: flex;
      margin: 0;
      padding: 0;
      border-left: 1px solid #aaa;
      margin-bottom: 30px;
      li {
        border-top: 1px solid #aaa;
        border-right: 1px solid #aaa;
        &.active {
          border-bottom: 1px solid #white;
        }
        &.inactive {
          border-bottom: 1px solid #aaa;
        }
        a {
          padding: 20px;
          display: block;
          &:hover {
            cursor: pointer;
          }
        }
      }
    `;
  };

  const getLiClassName = (key: LayerKey) => {
    if (key === activeTab) {
      return 'active';
    } else {
      return 'inactive';
    }
  };

  return (
    <>
      <ul css={layersTabStyle()}>
        <li className={getLiClassName('up')}>
          <a onClick={() => switchTab('up')}>up</a>
        </li>
        <li className={getLiClassName('down')}>
          <a onClick={() => switchTab('down')}>down</a>
        </li>
        <li className={getLiClassName('left')}>
          <a onClick={() => switchTab('left')}>left</a>
        </li>
        <li className={getLiClassName('right')}>
          <a onClick={() => switchTab('right')}>right</a>
        </li>
      </ul>
    </>
  );
};
