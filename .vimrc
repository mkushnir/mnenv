set exrc
set nocompatible
set showmode
set showcmd
set ruler
set autoindent
set nolist
set listchars=tab:>-,trail:-
set modeline

set path=.,/usr/include,/usr/local/include,$HOME/include

if v:version >= 800
    set fixendofline
endif
"set termguicolors

set tags+=/home/mkushnir/development/tags

filetype plugin indent on
au BufNewFile,BufRead *.q           setf lkit
au BufNewFile,BufRead *.eql         setf eql
au BufNewFile,BufRead *.lk          setf lkit
au BufNewFile,BufRead *.lb          setf lbnf
au BufNewFile,BufRead *.llvm        setf llvm
au BufNewFile,BufRead *.jt          setf html


set backspace=indent,eol,start

set softtabstop=4
set shiftwidth=4
set tabstop=8

set expandtab

"set nowrap
set wrap
set textwidth=74
set formatoptions=qrn1
set splitright

syntax on

colorscheme elflord
"set colorcolumn=+0
"hi ColorColumn ctermbg=darkgray

set foldmethod=indent
set foldlevelstart=99
set nonumber
set nohidden
set wildmenu
set wildmode=list:longest
set cursorline
set ttyfast
let python_highlight_all=1
" see syntax/c.vim
let c_space_errors=1
set ignorecase
set smartcase
set gdefault
if has('reltime')
  set incsearch
endif
set showmatch
set hlsearch
if v:version >= 800
    set display=truncate
endif

set smartindent

"if has('mouse')
"  set mouse=a
"endif

"nnoremap / /\v
"vnoremap / /\v
nnoremap <leader><space> :nohl<cr>
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" from defaults.vim
if !exists(":DO")
  command DO vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Jira type
inoremap <c-j><c-t> {color:green}__{color}<ESC>7hi
" Jira keyword
inoremap <c-j><c-k> **<ESC>i
" Jira variable
inoremap <c-j><c-v> __<ESC>i

function! BSurround(ch1, ch2) range
    exec 'normal' '`<'
    let ln = getline('.')
    let l = strlen(ln)
    let p0 = getpos('.')
    let ch1len = strlen(a:ch1)
    let ch2len = strlen(a:ch2)
    call setline('.', strpart(ln, 0, p0[2] - 1)  . a:ch1 . strpart(ln, p0[2] - 1, l - p0[2] + ch1len))

    exec 'normal' '`>l'
    let ln = getline('.')
    let l = strlen(ln)
    let p1 = getpos('.')
    let shift = 0
    if p0[1] == p1[1]
        let shift = ch1len
    endif
    call setline('.', strpart(ln, 0, p1[2] - 1 + shift)  . a:ch2 . strpart(ln, p1[2] - 1 + shift, l - p1[2] + ch2len + shift))

    let shift = shift + ch2len
    exec 'normal' shift . 'l'
endfunction

function! BJiraVar() range
    call BSurround('_', '_')
endfunction

vnoremap <leader>v :call BJiraVar()<cr>

function! BJiraKeyword() range
    call BSurround('*', '*')
endfunction
vnoremap <leader>k :call BJiraKeyword()<cr>

function! BJiraType() range
    call BSurround('{color:green}_', '_{color}')
endfunction
vnoremap <leader>t :call BJiraType()<cr>

function! BJiraCode() range
    call BSurround('{code}', '{code}')
endfunction
vnoremap <leader>d :call BJiraCode()<cr>

function! BCComment() range
    call BSurround("/*", " */")
endfunction

function! BCUncomment() range
    let pat1 = '/\*'
    let pat2 = ' \*/'
    for i in range(a:firstline, a:lastline)
        call setline(i, substitute(substitute(getline(i), pat1, '', ''), pat2, '', ''))
    endfor
    exec "normal" "`<"
endfunction
vnoremap <leader>b :call BCComment()<cr>
vnoremap <leader>B :call BCUncomment()<cr>

function! Comment()
    if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'lex' || &filetype == 'yacc' || &filetype == 'eql' || &filetype == 'javascript' || &filetype == 'proto'
        exec "normal" "I//\<esc>j"
    elseif &filetype == 'vim'
        exec "normal" "I\"\<esc>j"
    elseif &filetype == 'lua' || &filetype == 'sql'
        exec "normal" "I\--\<esc>j"
    elseif &filetype == 'lkit'
        exec "normal" "I\;\<esc>j"
    elseif &filetype == 'llvm'
        exec "normal" "I\;\<esc>j"
    elseif &filetype == 'xdefaults'
        exec "normal" "I\!\<esc>j"
    else
        exec "normal" "I#\<esc>j"
    endif
endfunction

function! BComment() range
    if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'lex' || &filetype == 'yacc' || &filetype == 'eql' || &filetype == 'javascript' || &filetype == 'proto'
        let repl = '\1//'
    elseif &filetype == 'vim'
        let repl = '\1"'
    elseif &filetype == 'lua' || &filetype == 'sql'
        let repl = '\1--'
    elseif &filetype == 'lkit'
        let repl = '\1;'
    elseif &filetype == 'llvm'
        let repl = '\1;'
    elseif &filetype == 'xdefaults'
        let repl = '\1!'
    else
        let repl = '\1#'
    endif
    call search('\S', 'c')
    let c = col('.') - 1
    let pat = '\(^ \{'.c.'}\)'
    for i in range(a:firstline, a:lastline)
        call setline(i, substitute(getline(i), pat, repl, ''))
    endfor
    exec "normal" "`>j"
endfunction

function! UnComment()
    if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'lex' || &filetype == 'yacc' || &filetype == 'eql' || &filetype == 'javascript' || &filetype == 'proto'
        s/^\(\s*\)\/\//\1/
    elseif &filetype == 'vim'
        s/^\(\s*\)"/\1/
    elseif &filetype == 'lua' || &filetype == 'sql'
        s/^\(\s*\)--/\1/
    elseif &filetype == 'lkit'
        s/^\(\s*\);/\1/
    elseif &filetype == 'llvm'
        s/^\(\s*\);/\1/
    elseif &filetype == 'xdefaults'
        s/^\(\s*\)!/\1/
    else
        s/^\(\s*\)#/\1/
    endif
endfunction

function! BUnComment() range
    if &filetype == 'c' || &filetype == 'cpp' || &filetype == 'lex' || &filetype == 'yacc' || &filetype == 'eql' || &filetype == 'javascript' || &filetype == 'proto'
        let pat = '//'
    elseif &filetype == 'vim'
        let pat = '"'
    elseif &filetype == 'lua' || &filetype == 'sql'
        let pat = '--'
    elseif &filetype == 'lkit'
        let pat = ';'
    elseif &filetype == 'llvm'
        let pat = ';'
    elseif &filetype == 'xdefaults'
        let pat = '!'
    else
        let pat = '#'
    endif
    for i in range(a:firstline, a:lastline)
        call setline(i, substitute(getline(i), pat, '', ''))
    endfor
    exec "normal" "`<"
endfunction

function! BMacro(term) range
    let sz = 0
    for i in range(a:firstline, a:lastline)
        let llen = strlen(getline(i))
        let sz = max([sz, llen])
    endfor
    let sz = sz + 8 - (sz % 8)
    for i in range(a:firstline, a:lastline)
        let ln = getline(i)
        let llen = strlen(ln)
        let nspaces = sz - llen - strlen(a:term)
        call setline(i, ln . repeat(' ', nspaces) . a:term)
    endfor
endfunction

function! BUnMacro(term) range
    let pat = ' *' . a:term . '$'
    for i in range(a:firstline, a:lastline)
        call setline(i, substitute(getline(i), pat, '', ''))
    endfor
endfunction

function! BReMacro(term0, term1) range
    let pat = ' *' . a:term0 . '$'
    for i in range(a:firstline, a:lastline)
        call setline(i, substitute(getline(i), pat, '', ''))
    endfor
    let sz = 0
    for i in range(a:firstline, a:lastline)
        let llen = strlen(getline(i))
        let sz = max([sz, llen])
    endfor
    let sz = sz + 8 - (sz % 8)
    for i in range(a:firstline, a:lastline)
        let ln = getline(i)
        let llen = strlen(ln)
        let nspaces = sz - llen - strlen(a:term1)
        call setline(i, ln . repeat(' ', nspaces) . a:term1)
    endfor
endfunction

function! MySyntaxExt()
    "colorscheme elflord
    if &filetype == 'c' || &filetype == 'cpp'
        syn match mrkcfmt /PRI[diouxX][a-zA-Z0-9]*/
        syn match mrkcfmt /SCN[dioux][a-zA-Z0-9]*/
        syn match mrkl4c /[A-Z_]*_LDEBUG/
        syn match mrkl4c /[A-Z_]*_LINFO/
        syn match mrkl4c /[A-Z_]*_LWARNING/
        syn match mrkl4c /[A-Z_]*_LERROR/
        syn match mrktrace /\<TRACEN\>/
        syn match mrktrace /\<TRACEC\>/
        syn match mrktrace /\<CTRACE\>/
        syn match mrktrace /\<LTRACE\>/
        syn match mrktrace /\<LTRACEN\>/
        syn match mrktrace /\<TRACE\>/
        syn match mrkcomm /\<UNUSED\>/
        syn match mrkcomm /\<RESERVED\>/
        syn match mrkcomm /\<DEPRECATED\>/
        syn match mrkcomm /\<PACKED\>/
        syn match mrkcomm /\<NONNULL\>/
        syn match mrkcomm /\<NORETURN\>/
        syn match mrkcomm /\<PRINTFLIKE\>/
        syn match mrkcomm /\<MRKLIKELY\>/
        syn match mrkcomm /\<MRKUNLIKELY\>/
        syn match mrkcomm /\<countof\>/
        syn match mrkcomm /\<F\?FAIL\>/
        syn match mrkty /\<mn[a-z0-9_]*_t\>/
        syn match mrkty /\<mrk[a-z0-9_]*_t\>/
        hi _mrkcfmt ctermfg=darkmagenta
        hi _mrkl4c ctermfg=darkyellow
        hi _mrktrace ctermfg=darkyellow
        hi _mrkcomm ctermfg=darkgreen
        hi _mrkty ctermfg=cyan
        command -nargs=+ HiLink hi def link <args>
        HiLink mrkcfmt _mrkcfmt
        HiLink mrkl4c _mrkl4c
        HiLink mrktrace _mrktrace
        HiLink mrkcomm _mrkcomm
        HiLink mrkty _mrkty
        HiLink cOctalZero cError
        delcommand HiLink
        set cindent

    else
        if &filetype == 'proto'
            syn keyword protoRepeat optional required repeated oneof
        endif
    endif
endfunction

function! MyHTMLSettings()
    set softtabstop=2
    set shiftwidth=2
    set tabstop=2
endfunction

au Syntax c,cpp,proto   call MySyntaxExt()
au Syntax html,javascript   call MyHTMLSettings()

nnoremap <leader>c :call Comment()<cr>
vnoremap <leader>c :call BComment()<cr>
nnoremap <leader>u :call UnComment()<cr>
vnoremap <leader>u :call BUnComment()<cr>
vnoremap <leader>d :call BUnMacro('\\')<cr>
vnoremap <leader>m :call BMacro('\')<cr>
vnoremap <leader>r :call BReMacro('\\', '\')<cr>
nnoremap <leader>8 <c-w>80\|
vnoremap <leader>8 <c-w>80\|
nnoremap <leader>t :call MySyntaxExt()<cr>

"nnoremap gl "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>:nohlsearch<CR>
"nnoremap gh "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>

"au BufNewFile,BufRead *.ly setf ly
"au Syntax ly runtime! /usr/local/share/lilypond/current/vim/syntax/lilypond.vim

function! MySwap()
    exec 'normal' 'yiw'
    let p0 = getcurpos()
    echo 'p0='.p0[1].'/'.p0[2]
    let p1 = searchpos('\v\W|$', 'nzW')
    echo 'p1='.p1[0].'/'.p1[1]
    call cursor(p1)
    let p2 = searchpos('\w', 'nzW')
    echo 'p2='.p2[0].'/'.p2[1]
    call cursor(p2)
    let p3 = searchpos('\v\W|$', 'nzW')
    echo 'p3='.p3[0].'/'.p3[1]
    "call setpos('.', p0)
endfunction

ab teh the
ab Teh The
ab TEH THE
ab ocnfiguration configuration
ab NOne None
ab ahve have
ab ouy you
ab ALthough Although
ab BEfore Before

