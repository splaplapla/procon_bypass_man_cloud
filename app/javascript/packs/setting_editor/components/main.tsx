/** @jsx jsx */

import { jsx, css } from '@emotion/react';

import { useContext } from 'react';
import {
  ModalProps,
  ButtonsModal,
} from './../../setting_editor/components/buttons_modal';
import { InstallableModes } from './../../setting_editor/components/installable_modes';
import { InstallableMacros } from  './../../setting_editor/components/installable_macros';
import { useModal } from '../../setting_editor/hooks/use_modal';
import { SettingContext } from './../setting_context';

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
          {<InstallableMacros />}

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
