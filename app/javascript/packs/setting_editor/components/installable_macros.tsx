/** @jsx jsx */

import { jsx } from '@emotion/react';
import React, { useContext } from 'react';
import {
  PluginSpec,
  AvailablePlugins,
  MacroClassNamespace,
} from '../../types/plugin';
import { SettingContext } from './../setting_context';

type Props = {
  classNamespace: MacroClassNamespace;
};
export const InstallableMacro = ({ classNamespace }: Props) => {
  const { installedMacroMap, setInstalledMacroMap } =
    useContext(SettingContext);

  const isChecked = () => {
    return !!installedMacroMap[classNamespace];
  };
  const handleClick = () => {
    if (isChecked()) {
      setInstalledMacroMap((prev) => {
        prev[classNamespace] = false;
        return Object.assign({}, prev);
      });
    } else {
      setInstalledMacroMap((prev) => {
        prev[classNamespace] = true;
        return Object.assign({}, prev);
      });
    }
  };
  return (
    <>
      <label>
        <input type="checkbox" onChange={handleClick} checked={isChecked()} />{' '}
        {classNamespace}
      </label>
    </>
  );
};

export const InstallableMacros = () => {
  const renderJsx = () => {
    return AvailablePlugins.map((v, i) => {
      return (
        <div key={i}>
          <h3>{Object.keys(v)[0]}</h3>
          <ul>
            {Object.entries(v).map((v) => {
              {
                return v[1].macros.map((macro: PluginSpec, i) => {
                  return (
                    <li key={i}>
                      <InstallableMacro
                        classNamespace={
                          macro.class_namespace as MacroClassNamespace
                        }
                      />
                    </li>
                    );
                });
              }
            })}
          </ul>
        </div>
      );
    });
  };
  return <>{renderJsx()}</>;
};
