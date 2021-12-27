/** @jsx jsx */

import { jsx, css } from '@emotion/react'
import React, { useState, useEffect, useContext } from "react";
import { Plugin, AvailablePlugins } from "../../types/plugin";

const macroClassNamespaces = AvailablePlugins.map((v) => {
  return Object.entries(v).map((v) => {
    const name = v[0];
    const plugin = v[1];
    return plugin.macros.map((m) => {
      return m.class_namespace
    })
  })
}).flat().flat();


type Props = {
  classNamespace: string;
};
export const InstallableMacro = ({ classNamespace }: Props) => {
  const isChecked = (name: string) => {
    return false;
  }
  const handleClick = (e: React.ChangeEvent<HTMLInputElement>) => {
    if(isChecked(classNamespace)) {
      // TODO
    }
  }
  return(
    <>
      <input type="checkbox" onChange={handleClick} checked={isChecked(classNamespace)} /> {classNamespace}
    </>
  )
}

export const InstallableMacros = () => {
  return(
    <>
      {
        macroClassNamespaces.map((classNamespace, i) => {
          return(
            <div key={i}>
              <label>
                <InstallableMacro classNamespace={classNamespace} />
              </label>
            </div>
          );
        })
      }
    </>
  )
}
