{ inputs, ... }:
{
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        nixpkgs.source = inputs.nixpkgs;

        imports = [
            ./base.nix
            ./autocmds.nix
            ./lsp.nix
            ./plugins.nix
            ./keymaps.nix
        ];
    };
}
