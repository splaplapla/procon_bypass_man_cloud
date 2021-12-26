/** @jsx jsx */

import { jsx, css } from '@emotion/react';
import React, { useState, useEffect, useContext } from 'react';
import {
  PluginSpec,
  AvailablePlugins,
  FindNameByClassNamespace,
  ModeClassNamespace,
} from '../../types/plugin';

type Props = {
  modeClassNamespace: ModeClassNamespace;
};
export const InstallableMode = ({ modeClassNamespace }: Props) => {
  const modeName = FindNameByClassNamespace(modeClassNamespace);
  const isChecked = (name: string) => {
    return true;
  };
  const handleClick = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (isChecked(modeClassNamespace)) {
      // TODO update state
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
