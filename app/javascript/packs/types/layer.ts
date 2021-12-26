export type InstalledPlugin = {
  [key in string]: boolean;
};

export type Layers = {
  installed_modes: InstalledPlugin;
};
