/** @jsx jsx */

import { jsx, css } from '@emotion/react'
import React, { useState, useEffect, useContext } from "react";
import { PluginSpec, AvailablePlugins, MacroClassNamespace } from "../../types/plugin";

type Props = {
  classNamespace: MacroClassNamespace;
};
export const InstallableMacro = ({ classNamespace }: Props) => {
  const isChecked = (name: any) => {
    return false;
  }
  const handleClick = (e: React.ChangeEvent<HTMLInputElement>) => {
    if(isChecked(classNamespace)) {
      // TODO
    }
  }
  return(
    <>
      <label>
        <input type="checkbox" onChange={handleClick} checked={isChecked(classNamespace)} /> {classNamespace}
      </label>
    </>
  )
}

export const InstallableMacros = () => {
  const renderJsx = () => {
    return AvailablePlugins.map((v, i) => {
      return (
        <div key={i}>
          <h3>{Object.keys(v)[0]}</h3>
          {Object.entries(v).map((v) => {
            {
              return v[1].macros.map((macro: PluginSpec, i) => {
                return (
                  <InstallableMacro
                    classNamespace={macro.class_namespace as MacroClassNamespace}
                    key={i}
                  />
                );
              });
            }
          })}
        </div>
      );
    });

  }
  return(<>{renderJsx()}</>);
}
