export const PluginTitles = [
  "splatoon2",
] as const;
export type PluginTitle = typeof PluginTitles[number];


export const ModeDisplayNames = [
  "splatoon2.guruguru",
] as const;
export type ModeDisplayName = typeof ModeDisplayNames[number];


export const ModeClassNamespaces = [
  "ProconBypassMan::Splatoon2::Mode::Guruguru",
] as const;
export type ModeClassNamespace = typeof ModeClassNamespaces[number];


export const MacroDisplayNames = [
  "splatoon2.fast_return",
  "splatoon2.jump_right",
  "splatoon2.jump_up",
  "splatoon2.jump_left",
] as const;
export type MacroDisplayName = typeof MacroDisplayNames[number];


export const MacroClassNamespaces = [
  "ProconBypassMan::Splatoon2::Macro::FastReturn",
  "ProconBypassMan::Splatoon2::Macro::JumpToRightKey",
  "ProconBypassMan::Splatoon2::Macro::JumpToUpKey",
  "ProconBypassMan::Splatoon2::Macro::JumpToLeftKey",
] as const;
export type MacroClassNamespace = typeof MacroClassNamespaces[number];


export type Plugin = {
  [key in PluginTitle] : {
    modes: Array<PluginSpec>;
    macros: Array<PluginSpec>;
  }
}

export type PluginSpec = {
  display_name: ModeDisplayName | MacroDisplayName,
  class_namespace: ModeClassNamespace | MacroClassNamespace,
  description?: string,
}

// plugins.
export const AvailablePlugins: Array<Plugin> = [
  {
    splatoon2: {
      modes: [
        { display_name: "splatoon2.guruguru", class_namespace: "ProconBypassMan::Splatoon2::Mode::Guruguru", description: "ぐるぐるします" },
      ],
      macros: [
        { display_name: "splatoon2.fast_return", class_namespace: "ProconBypassMan::Splatoon2::Macro::FastReturn" },
        { display_name: "splatoon2.jump_right", class_namespace: "ProconBypassMan::Splatoon2::Macro::JumpToRightKey" },
        { display_name: "splatoon2.jump_up", class_namespace: "ProconBypassMan::Splatoon2::Macro::JumpToUpKey" },
        { display_name: "splatoon2.jump_left", class_namespace: "ProconBypassMan::Splatoon2::Macro::JumpToLeftKey" },
      ],
    }
  },
]

export const MacroNameMap = AvailablePlugins.reduce((hash, item: Plugin) => {
  for (var [name, plugin] of Object.entries(item)) {
    plugin.macros.forEach((macro: PluginSpec) => {
      hash[macro.class_namespace] = macro.display_name
    })
  };
  return hash;
}, {} as any)


export const FindNameByClassNamespace = (mode_class_namespace: ModeClassNamespace): ModeDisplayName => {
  const classNamespaceMap = AvailablePlugins.reduce((hash, item: Plugin) => {
    for (var [name, plugin] of Object.entries(item)) {
      plugin.modes.forEach((mode: PluginSpec) => {
        hash[mode.class_namespace] = mode.display_name
      })
    };
    return hash;
  }, {})
  return classNamespaceMap[mode_class_namespace];
}
