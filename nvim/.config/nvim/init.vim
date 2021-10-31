
set nocompatible
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set encoding=utf-8
set textwidth=0
syntax on
set hidden
set title
set scrolloff=7
set wrap!
set signcolumn=no
set tags=./tags;/
set termguicolors
set t_Co=256
set background=dark
set clipboard=unnamedplus
set relativenumber
set guifont=Powerline_Consolas:h11
set completeopt=menu,menuone,noselect




call plug#begin()
"Colorscemes
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'gosukiwi/vim-atom-dark'
Plug 'mhartington/oceanic-next'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'rhysd/vim-color-spring-night'
Plug 'tomasiser/vim-code-dark'
Plug 'KeitaNakamura/neodark.vim'
Plug 'nightsense/forgotten'
Plug 'glepnir/oceanic-material'
Plug 'zaki/zazen'
Plug 'junegunn/seoul256.vim'
Plug 'kyoz/purify'
Plug 'arcticicestudio/nord-vim'
Plug 'bryanmylee/vim-colorscheme-icons'

"random styling
Plug 'prettier/vim-prettier'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'itchyny/lightline.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Raimondi/delimitMate' " parrenthesis autocomplete
Plug 'tpope/vim-commentary' "auto comment out i think?

" Plug 'puremourning/vimspector' "look it up later, shows what happens when you run file
Plug 'tpope/vim-fugitive'
Plug 'moll/vim-bbye'

"start screen
Plug 'mhinz/vim-startify'


"lsp & autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

"File Nav
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'ThePrimeagen/harpoon'

call plug#end()



let g:tokyonight_style = "night"
let g:neodark#background = '#202020'
colorscheme tokyonight   


"the color bar at bottem, two simple options
let g:lightline = {'colorscheme': 'tokyonight'}
" let g:lightline = {
"       \ 'enable': {
"       \    'tabline': 0
"       \ },
"       \ 'colorscheme': 'Tomorrow_Night',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'component_function': {
"       \   'gitbranch': 'FugitiveHead'
"       \ },
"       \ }



"treesitter?
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF



"LSP && AUTOCOMPLETE----------------------------------------------------------
lua << EOF
require'lspconfig'.pyright.setup{}
EOF

lua << EOF
    local nvim_lsp = require('lspconfig')
    local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
end
EOF

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/`.
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':'.
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
EOF


"-----------------------------------------------------------------------------------------------------------------


let mapleader=" "
nnoremap <leader>init :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>tele :e ~/.config/nvim/plugged/telescope.nvim/lua/telescope/mappings.lua<CR>
nnoremap <leader>h :noh<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader><F12> :hi Normal guibg=NONE ctermbg=NONE<CR>
nnoremap <leader>x :bd<CR>

" nnoremap <leader>t :NERDTreeToggle<CR>
" nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <leader>j :BufferPrevious<CR>
" nnoremap <leader>k :BufferNext<CR>
" nnoremap <leader>J :BufferMovePrevious<CR>
" nnoremap <leader>K :BufferMoveNext<CR>

nmap <leader>J <Plug>vem_move_buffer_left-
nmap <leader>K <Plug>vem_move_buffer_right-
nmap <leader>j <Plug>vem_prev_buffer-
nmap <leader>k <Plug>vem_next_buffer-


"idk prettier?
vmap <leader>y :w! /tmp/vitmp<CR>
vmap <leader>p :r! cat tmp/vitmp<CR>


"telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>n <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>t <cmd>Telescope file_browser<cr>

"file directory add/delete files
nnoremap <leader>tt :Ex<CR>
nnoremap <leader>T :Rex<CR>









" For tabs----no in use but still usefull
" #CA92F4-purple
highlight VemTablineNormal           term=reverse cterm=none ctermfg=0   ctermbg=251 guifg=#cdcdcd guibg=#343434 gui=none
highlight VemTablineLocation         term=reverse cterm=none ctermfg=239 ctermbg=251 guifg=#666666 guibg=#cdcdcd gui=none
highlight VemTablineNumber           term=reverse cterm=none ctermfg=239 ctermbg=251 guifg=#666666 guibg=#cdcdcd gui=none
highlight VemTablineSelected         term=bold    cterm=bold ctermfg=0   ctermbg=255 guifg=#242424 guibg=#CA92F4 gui=bold
highlight VemTablineLocationSelected term=bold    cterm=none ctermfg=239 ctermbg=255 guifg=#666666 guibg=#ffffff gui=bold
highlight VemTablineNumberSelected   term=bold    cterm=none ctermfg=239 ctermbg=255 guifg=#666666 guibg=#ffffff gui=bold
highlight VemTablineShown            term=reverse cterm=none ctermfg=0   ctermbg=251 guifg=#242424 guibg=#cdcdcd gui=none
highlight VemTablineLocationShown    term=reverse cterm=none ctermfg=0   ctermbg=251 guifg=#666666 guibg=#cdcdcd gui=none
highlight VemTablineNumberShown      term=reverse cterm=none ctermfg=0   ctermbg=251 guifg=#666666 guibg=#cdcdcd gui=none
highlight VemTablineSeparator        term=reverse cterm=none ctermfg=246 ctermbg=251 guifg=#888888 guibg=#cdcdcd gui=none
highlight VemTablinePartialName      term=reverse cterm=none ctermfg=246 ctermbg=251 guifg=#888888 guibg=#cdcdcd gui=none
highlight VemTablineTabNormal        term=reverse cterm=none ctermfg=0   ctermbg=251 guifg=#242424 guibg=#4a4a4a gui=none
highlight VemTablineTabSelected      term=bold    cterm=bold ctermfg=0   ctermbg=255 guifg=#242424 guibg=#ffffff gui=bold


