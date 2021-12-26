/** @jsx jsx */

import { jsx, css } from '@emotion/react'

import React, { useState } from 'react'
import ReactDOM from 'react-dom'
import { ButtonsSetting } from './setting_editor/components/main'
import { Button } from "types/button";

export const ButtonsSettingPage = () => {
  const prefixKeys = JSON.parse(document.getElementById("config-prefix-keys").dataset.configPrefixKeys) as Array<Button>

  return(
    <>
      <ButtonsSetting defaultPrefixKeys={prefixKeys} />
    </>
  )
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ButtonsSettingPage />,
    document.body.appendChild(document.createElement('div')),
  )
})
