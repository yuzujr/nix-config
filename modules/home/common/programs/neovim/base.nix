{ pkgs, ... }:
{
    globals = {
        mapleader = " ";
        maplocalleader = " ";
    };

    opts = {
        breakindent = true;
        clipboard = "unnamedplus";
        confirm = true;
        cursorline = true;
        expandtab = true;
        fillchars.eob = " ";
        foldenable = false;
        hlsearch = false;
        ignorecase = true;
        incsearch = true;
        inccommand = "split";
        linebreak = true;
        mouse = "a";
        number = true;
        relativenumber = true;
        scrolloff = 8;
        shiftwidth = 4;
        showmode = false;
        sidescrolloff = 8;
        signcolumn = "yes:1";
        smartcase = true;
        smartindent = true;
        softtabstop = 4;
        splitbelow = true;
        splitright = true;
        swapfile = false;
        tabstop = 4;
        termguicolors = true;
        timeoutlen = 300;
        undofile = true;
        updatetime = 200;
        winborder = "rounded";
        wrap = true;
    };

    colorscheme = "rose-pine";
    colorschemes.rose-pine = {
        enable = true;
        settings = {
            variant = "auto";
            styles.italic = false;
        };
    };

    extraPlugins = with pkgs.vimPlugins; [
        vim-lastplace
        vim-sleuth
    ];
}
