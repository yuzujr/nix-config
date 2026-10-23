{ config, lib, ... }:
let
    languageServers = {
        nixd = "nixd";
        clangd = "clangd";
        rust_analyzer = "rust-analyzer";
        basedpyright = "basedpyright-langserver";
        bashls = "bash-language-server";
        cssls = "vscode-css-language-server";
        jsonls = "vscode-json-language-server";
        yamlls = "yaml-language-server";
        taplo = "taplo";
        marksman = "marksman";
    };
in
{
    lsp = {
        servers = lib.mapAttrs (_name: _command: {
            enable = true;
            activate = false;
            package = null;
        }) languageServers;
        luaConfig.content = lib.mkAfter ''
            local language_servers = ${lib.nixvim.toLuaObject languageServers}

            for name, command in pairs(language_servers) do
                if vim.fn.executable(command) == 1 then
                    vim.lsp.enable(name)
                end
            end
        '';
        keymaps = [
            {
                mode = "n";
                key = "gd";
                lspBufAction = "definition";
                options.desc = "Go to definition";
            }
            {
                mode = "n";
                key = "gD";
                lspBufAction = "declaration";
                options.desc = "Go to declaration";
            }
            {
                mode = "n";
                key = "gr";
                lspBufAction = "references";
                options.desc = "References";
            }
            {
                mode = "n";
                key = "gI";
                lspBufAction = "implementation";
                options.desc = "Go to implementation";
            }
            {
                mode = "n";
                key = "gy";
                lspBufAction = "type_definition";
                options.desc = "Go to type definition";
            }
            {
                mode = "n";
                key = "K";
                lspBufAction = "hover";
                options.desc = "Hover";
            }
            {
                mode = "i";
                key = "<C-k>";
                lspBufAction = "signature_help";
                options.desc = "Signature help";
            }
            {
                mode = [
                    "n"
                    "x"
                ];
                key = "<leader>ca";
                lspBufAction = "code_action";
                options.desc = "Code action";
            }
            {
                mode = "n";
                key = "<leader>cr";
                lspBufAction = "rename";
                options.desc = "Rename";
            }
            {
                mode = "n";
                key = "<leader>cs";
                lspBufAction = "document_symbol";
                options.desc = "Document symbols";
            }
            {
                mode = "n";
                key = "[d";
                action.__raw = "function() vim.diagnostic.jump({ count = -1, float = true }) end";
                options.desc = "Previous diagnostic";
            }
            {
                mode = "n";
                key = "]d";
                action.__raw = "function() vim.diagnostic.jump({ count = 1, float = true }) end";
                options.desc = "Next diagnostic";
            }
        ];
    };

    diagnostic.settings = {
        severity_sort = true;
        underline = true;
        update_in_insert = false;
        virtual_text = {
            source = "if_many";
            spacing = 2;
        };
        float = {
            border = "rounded";
            source = "if_many";
        };
    };

    plugins = {
        blink-cmp = {
            enable = true;
            setupLspCapabilities = false;
            settings = {
                appearance.nerd_font_variant = "mono";
                completion = {
                    documentation.auto_show = true;
                    list.selection = {
                        auto_insert = false;
                        preselect = false;
                    };
                };
                fuzzy.implementation = "lua";
                keymap = {
                    preset = "default";
                    "<Tab>" = [
                        "select_next"
                        "fallback"
                    ];
                    "<S-Tab>" = [
                        "select_prev"
                        "fallback"
                    ];
                    "<CR>" = [
                        "select_and_accept"
                        "fallback"
                    ];
                };
                sources.default = [
                    "lsp"
                    "path"
                    "buffer"
                ];
            };
        };
        lspconfig.enable = true;
        treesitter = {
            enable = true;
            highlight.enable = true;
            indent.enable = true;
            folding.enable = true;
            grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
                bash
                c
                cpp
                css
                fish
                git_config
                git_rebase
                gitattributes
                gitcommit
                gitignore
                html
                javascript
                json
                lua
                markdown
                markdown_inline
                nix
                python
                regex
                rust
                toml
                tsx
                typescript
                vim
                vimdoc
                yaml
            ];
        };
    };
}
