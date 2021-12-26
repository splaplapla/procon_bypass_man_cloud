export type PluginBody = {
  display_name: string;
  class_namespace: string;
}

export type Plugin = {
  [key in string] : {
    modes: Array<PluginBody>;
    macros: Array<PluginBody>;
  }
}

// plugins.
export const AvailablePlugins = [
  {
    splatoon2: {
      modes: [
        { display_name: "splatoon2.guruguru", class_namespace: "ProconBypassMan::Splatoon2::Mode::Guruguru" },
      ],
      macros: [
        { display_name: "splatoon2.fast_return", class_namespace: "ProconBypassMan::Splatoon2::Macro::FastReturn" },
        { display_name: "splatoon2.jump_right", class_namespace: "ProconBypassMan::Splatoon2::Macro::JumpToRightKey" },
        { display_name: "splatoon2.jump_up", class_namespace: "ProconBypassMan::Splatoon2::Macro::JumpToUpKey" },
        { display_name: "splatoon2.jump_left", class_namespace: "ProconBypassMan::Splatoon2::Macro::JumpToLeftKey" },
      ],
    }
  } as Plugin,
]

export const MacroNameMap = AvailablePlugins.reduce((hash, item: Plugin) => {
  for (var [name, plugin] of Object.entries(item)) {
    plugin.macros.forEach((macro: PluginBody) => {
      hash[macro.class_namespace] = macro.display_name
    })
  };
  return hash;
}, {} as any)

export const ModeNameMap = AvailablePlugins.reduce((hash, item: Plugin) => {
  for (var [name, plugin] of Object.entries(item)) {
    plugin.modes.forEach((mode: PluginBody) => {
      hash[mode.class_namespace] = mode.display_name
    })
  };
  return hash;
}, {} as any)
