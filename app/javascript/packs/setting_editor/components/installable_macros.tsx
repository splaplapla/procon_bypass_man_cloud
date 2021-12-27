/** @jsx jsx */

import { jsx, css } from '@emotion/react'
import React, { useState, useEffect, useContext } from "react";
import { PluginSpec, AvailablePlugins, MacroClassNamespace } from "../../types/plugin";
import { SettingContext } from './../setting_context';

type Props = {
  classNamespace: MacroClassNamespace;
};
export const InstallableMacro = ({ classNamespace }: Props) => {
  const { installedMacroMap, setInstalledMacroMap } = useContext(SettingContext);

  const isChecked = (name: any) => {
    return !!installedMacroMap[classNamespace];
  }
  const handleClick = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (isChecked(classNamespace)) {
      setInstalledMacroMap((prev) => {
        prev[classNamespace] = false;
        return Object.assign({}, prev);;
      });
    } else {
      setInstalledMacroMap((prev) => {
        prev[classNamespace] = true;
        return Object.assign({}, prev);;
      });
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
