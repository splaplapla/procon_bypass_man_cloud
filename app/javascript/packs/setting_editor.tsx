/** @jsx jsx */

import { jsx, css } from '@emotion/react'

import React, { useState } from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

type Props = {
  prefixKeys: Array<string>;
};

export const ButtonsSettingPage = ({ prefixKeys }) => {

  return(
    <>
      <div css={css`display: table`}>
        <div css={css`display: table-cell; width: 400px;`}>
          <h2>設定ファイルの変更</h2>
          <div>
            <a href="#" >エクスポートする</a>
          </div>

          <h3>インストール可能なモード</h3>

          <h3>インストール可能なマクロ</h3>

          <h3>設定中のプレフィックスキー</h3>
          {prefixKeys.join(", ")}
        </div>
        <div css={css`display: table-cell`}>
        </div>
      </div>
    </>
  )
}

const prefixKeys = JSON.parse(document.getElementById("config-prefix-keys").dataset.configPrefixKeys)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ButtonsSettingPage prefixKeys={prefixKeys} />,
    document.body.appendChild(document.createElement('div')),
  )
})
