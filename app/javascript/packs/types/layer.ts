export type InstalledPlugin = {
  [key in string]: boolean;
};

export type Layers = {
  installed_modes: InstalledPlugin;
};

export const layer_keys = ['up', 'down', 'left', 'right'] as const;
export type LayerKey = typeof layer_keys[number];
