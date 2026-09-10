{
    plugins = {
        conform-nvim = {
            enable = true;
            settings = {
                default_format_opts.lsp_format = "fallback";
                formatters_by_ft = {
                    css = [ "prettier" ];
                    go = [ "gofmt" ];
                    html = [ "djlint" ];
                    htmldjango = [ "djlint" ];
                    javascript = [ "prettier" ];
                    javascriptreact = [ "prettier" ];
                    json = [ "jq" ];
                    jsonc = [ "prettier" ];
                    lua = [ "stylua" ];
                    markdown = [ "prettier" ];
                    nix = [ "nixfmt" ];
                    python = [ "black" ];
                    rust = [ "rustfmt" ];
                    scss = [ "prettier" ];
                    tsx = [ "prettier" ];
                    typescript = [ "prettier" ];
                    typescriptreact = [ "prettier" ];
                    yaml = [ "prettier" ];
                };
            };
        };
        flash.enable = true;
        gitsigns.enable = true;
        lualine = {
            enable = true;
            settings.options = {
                theme = "auto";
                globalstatus = true;
                component_separators = {
                    left = "|";
                    right = "|";
                };
                section_separators = {
                    left = "";
                    right = "";
                };
            };
        };
        mini = {
            enable = true;
            modules.pairs = { };
        };
        noice = {
            enable = true;
            settings = {
                cmdline = {
                    enable = true;
                    view = "cmdline_popup";
                };
                popupmenu = {
                    enable = true;
                    backend = "nui";
                };
                lsp.override = {
                    "vim.lsp.util.convert_input_to_markdown_lines" = true;
                    "vim.lsp.util.stylize_markdown" = true;
                };
                messages = {
                    enable = true;
                    view = "notify";
                };
                presets = {
                    bottom_search = false;
                    command_palette = true;
                    long_message_to_split = true;
                    inc_rename = false;
                };
                routes = [
                    {
                        filter = {
                            event = "notify";
                            find = "No information available";
                        };
                        opts.skip = true;
                    }
                ];
            };
        };
        notify = {
            enable = true;
            settings = {
                render = "compact";
                stages = "fade_in_slide_out";
                timeout = 2600;
            };
        };
        snacks = {
            enable = true;
            settings = {
                bigfile.enabled = true;
                dashboard = {
                    enabled = true;
                    sections = [
                        { section = "header"; }
                        {
                            section = "keys";
                            gap = 1;
                            padding = 1;
                        }
                    ];
                };
                explorer.enabled = true;
                gitbrowse.enabled = true;
                indent.enabled = true;
                input.enabled = true;
                picker.enabled = true;
                quickfile.enabled = true;
                scope.enabled = true;
                statuscolumn.enabled = true;
                toggle.enabled = true;
                words.enabled = true;
            };
        };
        web-devicons.enable = true;
        which-key = {
            enable = true;
            settings = {
                preset = "helix";
                delay = 300;
                spec = [
                    {
                        __unkeyed-1 = "<leader>f";
                        group = "Find";
                        icon = "󰍉 ";
                    }
                    {
                        __unkeyed-1 = "<leader>g";
                        group = "Git";
                        icon = "󰊢 ";
                    }
                    {
                        __unkeyed-1 = "<leader>j";
                        group = "Jump";
                        icon = "󰈞 ";
                    }
                    {
                        __unkeyed-1 = "<leader>c";
                        group = "Code";
                        icon = "󰅩 ";
                    }
                    {
                        __unkeyed-1 = "<leader>b";
                        group = "Buffer";
                        icon = "󰓩 ";
                    }
                    {
                        __unkeyed-1 = "<leader>u";
                        group = "UI";
                        icon = "󰙨 ";
                    }
                    {
                        __unkeyed-1 = "[";
                        group = "Previous";
                        icon = " ";
                    }
                    {
                        __unkeyed-1 = "]";
                        group = "Next";
                        icon = " ";
                    }
                ];
            };
        };
    };
}
