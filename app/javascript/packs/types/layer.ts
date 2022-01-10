import { Button } from 'types/button';
import { ModeClassNamespace, MacroClassNamespace } from 'types/plugin';

export const modeManual = 'manual';
export const reservedModes = [modeManual] as const;
export type ReservedMode = typeof reservedModes[number];

type HasMacroCondition = {
  if_pressed: Array<Button>;
};
export type HasMacro = {
  [key in MacroClassNamespace]: HasMacroCondition;
};

export type Layer = {
  mode: ReservedMode | ModeClassNamespace;
  macros: HasMacro;
};

export const layer_keys = ['up', 'down', 'left', 'right'] as const;
export type LayerKey = typeof layer_keys[number];
