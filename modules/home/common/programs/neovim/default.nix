{ inputs, ... }:
{
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;

        imports = [
            ./base.nix
            ./autocmds.nix
            ./lsp.nix
            ./plugins.nix
            ./keymaps.nix
        ];
    };
}
