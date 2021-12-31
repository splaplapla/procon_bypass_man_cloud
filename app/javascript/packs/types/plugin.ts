export const PluginTitles = ['splatoon2'] as const;
export type PluginTitle = typeof PluginTitles[number];

export const ModeClassNamespaces = [
  'ProconBypassMan::Plugin::Splatoon2::Mode::Guruguru',
] as const;
export type ModeClassNamespace = typeof ModeClassNamespaces[number];

export const MacroDisplayNames = [
  'splatoon2.fast_return',
  'splatoon2.jump_right',
  'splatoon2.jump_up',
  'splatoon2.jump_left',
] as const;
export type MacroDisplayName = typeof MacroDisplayNames[number];

export const MacroClassNamespaces = [
  'ProconBypassMan::Plugin::Splatoon2::Macro::FastReturn',
  'ProconBypassMan::Plugin::Splatoon2::Macro::JumpToRightKey',
  'ProconBypassMan::Plugin::Splatoon2::Macro::JumpToUpKey',
  'ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey',
] as const;
export type MacroClassNamespace = typeof MacroClassNamespaces[number];

export type Plugin = {
  [key in PluginTitle]: {
    modes: Array<PluginSpec>;
    macros: Array<PluginSpec>;
  };
};

export type InstalledModeMap = {
  [key in ModeClassNamespace]: boolean;
};

export type InstalledMacroMap = {
  [key in MacroClassNamespace]: boolean;
};

export type PluginSpec = {
  display_name: string;
  class_namespace: ModeClassNamespace | MacroClassNamespace;
  description?: string;
};

// plugins.
export const AvailablePlugins: Array<Plugin> = [
  {
    splatoon2: {
      modes: [
        {
          display_name: 'その場でピチャピチャ',
          class_namespace: 'ProconBypassMan::Plugin::Splatoon2::Mode::Guruguru',
          description: 'ぐるぐるします',
        },
      ],
      macros: [
        {
          display_name: 'splatoon2.fast_return',
          class_namespace:
            'ProconBypassMan::Plugin::Splatoon2::Macro::FastReturn',
          description: 'リスポーンにジャンプします',
        },
        {
          display_name: 'splatoon2.jump_right',
          class_namespace:
            'ProconBypassMan::Plugin::Splatoon2::Macro::JumpToRightKey',
          description:
            'マップを開いた時の右キーに割り当てられたの味方にジャンプします',
        },
        {
          display_name: 'splatoon2.jump_up',
          class_namespace:
            'ProconBypassMan::Plugin::Splatoon2::Macro::JumpToUpKey',
          description:
            'マップを開いた時の上キーに割り当てられたの味方にジャンプします',
        },
        {
          display_name: 'splatoon2.jump_left',
          class_namespace:
            'ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey',
          description:
            'マップを開いた時の左キーに割り当てられたの味方にジャンプします',
        },
      ],
    },
  },
];

export const FindNameByClassNamespace = (
  mode_class_namespace: ModeClassNamespace
): string => {
  const classNamespaceMap = AvailablePlugins.reduce((hash, item: Plugin) => {
    for (const [, plugin] of Object.entries(item)) {
      plugin.modes.forEach((mode: PluginSpec) => {
        hash[mode.class_namespace] = mode.display_name;
      });
    }
    return hash;
  }, {});
  return classNamespaceMap[mode_class_namespace];
};
