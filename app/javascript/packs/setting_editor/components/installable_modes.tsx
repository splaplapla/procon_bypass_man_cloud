/** @jsx jsx */

import { jsx, css } from '@emotion/react';
import React, { useState, useEffect, useContext } from 'react';
import {
  PluginSpec,
  AvailablePlugins,
  FindNameByClassNamespace,
  InstalledModeMap,
  ModeClassNamespace,
} from '../../types/plugin';
import { SettingContext } from './../setting_context';

type Props = {
  modeClassNamespace: ModeClassNamespace;
};
export const InstallableMode = ({ modeClassNamespace }: Props) => {
  const modeName = FindNameByClassNamespace(modeClassNamespace);
  const { installedModeMap, setInstalledModeMap } = useContext(SettingContext);

  const isChecked = (modeClassNamespace: ModeClassNamespace): boolean => {
    return !!installedModeMap[modeClassNamespace];
  };

  const handleClick = (e: React.ChangeEvent<HTMLInputElement>): void => {
    if (isChecked(modeClassNamespace)) {
      setInstalledModeMap((prev) => {
        prev[modeClassNamespace] = false;
        return Object.assign({}, prev);;
      });
    } else {
      setInstalledModeMap((prev) => {
        prev[modeClassNamespace] = true;
        return Object.assign({}, prev);;
      });
    }
  };
  return (
    <>
      <label>
        <input
          type="checkbox"
          onChange={handleClick}
          checked={isChecked(modeClassNamespace)}
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
                    modeClassNamespace={
                      mode.class_namespace as ModeClassNamespace
                    }
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
