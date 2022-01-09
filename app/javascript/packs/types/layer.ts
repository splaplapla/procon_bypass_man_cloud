import { Button } from 'types/button';
import { ModeClassNamespace } from 'types/plugin';

export const modeManual = 'manual';
export const reservedModes = [modeManual] as const;
export type ReservedMode = typeof reservedModes[number];

export type Layer = {
  mode: ReservedMode | ModeClassNamespace;
};

export const layer_keys = ['up', 'down', 'left', 'right'] as const;
export type LayerKey = typeof layer_keys[number];
