/** @jsx jsx */

import { jsx, css } from '@emotion/react';

import React, { useState, useContext } from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import { Button } from 'types/button';
import {
  ModalProps,
  ButtonsModal,
} from './../../setting_editor/components/buttons_modal';
import { InstallableModes } from './../../setting_editor/components/installable_modes';
import { useModal } from '../../setting_editor/hooks/use_modal';
import { SettingContext } from './../setting_context';

type Props = {};

export const ButtonsSetting = () => {
  const { prefixKeys, setPrefixKeys } = useContext(SettingContext);
  const [modalProps, openModal] = useModal();
  const handlePrefixKeysField = () => {
    openModal({
      title: 'キープレフィックスの変更',
      prefill: prefixKeys,
      callbackOnSubmit: setPrefixKeys,
    });
  };

  return (
    <>
      <div
        css={css`
          display: table;
        `}
      >
        <div
          css={css`
            display: table-cell;
            width: 400px;
          `}
        >
          <h2>設定ファイルの変更</h2>
          <div>
            <a href="#">エクスポートする</a>
          </div>

          <h3>インストール可能なモード</h3>
          {<InstallableModes />}

          <h3>インストール可能なマクロ</h3>

          <h3>設定中のプレフィックスキー</h3>
          <input
            type="text"
            value={prefixKeys.join(', ')}
            readOnly={true}
            onClick={handlePrefixKeysField}
          />
          {<ButtonsModal {...(modalProps as ModalProps)} />}
        </div>
        <div
          css={css`
            display: table-cell;
          `}
        ></div>
      </div>
    </>
  );
};
