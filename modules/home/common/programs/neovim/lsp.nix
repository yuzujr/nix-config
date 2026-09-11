{ config, ... }:
{
    lsp = {
        servers = {
            nixd = {
                enable = true;
                package = null;
            };
            clangd = {
                enable = true;
                package = null;
            };
            rust_analyzer = {
                enable = true;
                package = null;
            };
            basedpyright = {
                enable = true;
                package = null;
            };
            bashls = {
                enable = true;
                package = null;
            };
            cssls = {
                enable = true;
                package = null;
            };
            jsonls = {
                enable = true;
                package = null;
            };
            yamlls = {
                enable = true;
                package = null;
            };
            taplo = {
                enable = true;
                package = null;
            };
            marksman = {
                enable = true;
                package = null;
            };
        };
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
