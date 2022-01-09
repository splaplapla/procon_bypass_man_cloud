import { Button } from 'types/button';
import { ModeClassNamespace } from 'types/plugin';

export type Layer = {
  mode: string | ModeClassNamespace;
};

export const layer_keys = ['up', 'down', 'left', 'right'] as const;
export type LayerKey = typeof layer_keys[number];
