/** @jsx jsx */

import { jsx } from '@emotion/react';
import React, { useContext } from 'react';
import {
  PluginSpec,
  AvailablePlugins,
  FindNameByClassNamespace,
  ModeClassNamespace,
} from '../../types/plugin';
import { SettingContext } from './../setting_context';

type Props = {
  classNamespace: ModeClassNamespace;
};
export const InstallableMode = ({ classNamespace }: Props) => {
  const modeName = FindNameByClassNamespace(classNamespace);
  const { installedModeMap, setInstalledModeMap } = useContext(SettingContext);

  const isChecked = (classNamespace: ModeClassNamespace): boolean => {
    return !!installedModeMap[classNamespace];
  };

  const handleClick = (): void => {
    if (isChecked(classNamespace)) {
      setInstalledModeMap((prev) => {
        prev[classNamespace] = false;
        return Object.assign({}, prev);
      });
    } else {
      setInstalledModeMap((prev) => {
        prev[classNamespace] = true;
        return Object.assign({}, prev);
      });
    }
  };
  return (
    <>
      <label>
        <input
          type="checkbox"
          onChange={handleClick}
          checked={isChecked(classNamespace)}
        />
        {modeName}
      </label>
    </>
  );
};

export const InstallableModes = () => {
  const renderModes = () => {
    return AvailablePlugins.map((v, i) => {
      return (
        <div key={i}>
          <h3>{Object.keys(v)[0]}</h3>
          {Object.entries(v).map((v) => {
            {
              return v[1].modes.map((mode: PluginSpec, i) => {
                return (
                  <InstallableMode
                    classNamespace={mode.class_namespace as ModeClassNamespace}
                    key={i}
                  />
                );
              });
            }
          })}
        </div>
      );
    });
  };

  return <>{renderModes()}</>;
};
