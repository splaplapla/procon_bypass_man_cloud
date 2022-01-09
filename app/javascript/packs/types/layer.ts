import { InstalledModeMap, InstalledMacroMap } from 'types/plugin';

export type Layer = {
  installed_macros: InstalledMacroMap;
  installed_modes: InstalledModeMap;
};

export const layer_keys = ['up', 'down', 'left', 'right'] as const;
export type LayerKey = typeof layer_keys[number];
