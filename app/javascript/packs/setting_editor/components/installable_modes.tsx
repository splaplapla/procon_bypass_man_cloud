/** @jsx jsx */

import { jsx, css } from '@emotion/react'
import React, { useState, useEffect, useContext } from "react";
import { Plugin, AvailablePlugins, ModeNameMap } from "../../types/plugin";

const modeClassNamespaces = AvailablePlugins.map((v) => {
  return Object.entries(v).map((v) => {
    const name = v[0];
    const plugin = v[1];
    return plugin.modes.map((m) => {
      return m.class_namespace
    })
  })
}).flat().flat();

type Props = {
  modeKey: string;
};
export const InstallableMode = ({ modeKey }: Props) => {
  const modeName = ModeNameMap[modeKey];
  const isChecked = (name: string) => {
    return true
  }
  const handleClick = (e: React.ChangeEvent<HTMLInputElement>) => {
    if(isChecked(modeKey)) {
      // TODO update state
    }
  }
  return(
    <div>
      <input type="checkbox" onChange={handleClick} checked={isChecked(modeKey)} />{modeName}
    </div>
  )
}

export const InstallableModes = () => {
  return(
    <>
      {
        modeClassNamespaces.map((classNamespace, i) => {
          return(
            <div key={i}>
              <label>
                <InstallableMode modeKey={classNamespace} />
              </label>
            </div>
          );
        })
      }
    </>
  )
}
