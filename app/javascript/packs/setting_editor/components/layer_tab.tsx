/** @jsx jsx */

import { jsx, css } from '@emotion/react';
import React from 'react';
import { LayerKey } from 'types/layer';

type Props = {
  activeTab: any;
};

export const LayerTab = ({ activeTab }: Props) => {
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
          <a>up</a>
        </li>
        <li className={getLiClassName('down')}>
          <a>down</a>
        </li>
        <li className={getLiClassName('left')}>
          <a>left</a>
        </li>
        <li className={getLiClassName('right')}>
          <a>right</a>
        </li>
      </ul>
    </>
  );
};
