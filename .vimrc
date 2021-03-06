set exrc
set nocompatible
set showmode
set showcmd
set ruler
set autoindent
set nolist
set listchars=tab:>-,trail:-
set modeline
set lazyredraw

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
    elseif &filetype == 'tex'
        exec "normal" "I\%\<esc>j"
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
    elseif &filetype == 'tex'
        let repl = '\1%'
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
    elseif &filetype == 'tex'
        s/^\(\s*\)%/\1/
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
    elseif &filetype == 'tex'
        let pat = '%'
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
        syn match mncfmt /PRI[diouxX][a-zA-Z0-9]*/
        syn match mncfmt /SCN[dioux][a-zA-Z0-9]*/
        syn match mnl4c /[A-Z_]*_LDEBUG/
        syn match mnl4c /[A-Z_]*_LINFO/
        syn match mnl4c /[A-Z_]*_LWARNING/
        syn match mnl4c /[A-Z_]*_LERROR/
        syn match mnl4c /[A-Z_]*_LLOG/
        syn match mntrace /\<TRACEN\>/
        syn match mntrace /\<TRACEC\>/
        syn match mntrace /\<CTRACE\>/
        syn match mntrace /\<LTRACE\>/
        syn match mntrace /\<LTRACEN\>/
        syn match mntrace /\<TRACE\>/
        syn match mncomm /\<UNUSED\>/
        syn match mncomm /\<RESERVED\>/
        syn match mncomm /\<DEPRECATED\>/
        syn match mncomm /\<PACKED\>/
        syn match mncomm /\<NONNULL\>/
        syn match mncomm /\<NORETURN\>/
        syn match mncomm /\<PRINTFLIKE\>/
        syn match mncomm /\<MNLIKELY\>/
        syn match mncomm /\<MNUNLIKELY\>/
        syn match mncomm /\<countof\>/
        syn match mncomm /\<F\?FAIL\>/
        syn match mnty /\<mn[a-z0-9_]*_t\>/
        syn match mnty /\<MN[A-Z0-9]*_[A-Z0-9_]*\>/
        syn match mnfn /\<mn[a-z0-9]*_[a-z0-9_]*\>/
        syn match mnex /\<NAN\>/
        syn match mnex /\<INFINITY\>/
        syn match mnft /\<FT_[a-zA-Z0-9_]*\>/
        syn match mnxft /\<[Xx][Ff][Tt][a-zA-Z0-9_]*\>/
        syn match mnfc /\<F[Cc][a-zA-Z0-9_]*\>/
        syn match mnxr /\<XRender[a-zA-Z0-9_]*\>/
        syn match mnxcb /\<[Xx][Cc][Bb]_[a-zA-Z0-9_]*\>/
        syn keyword cStorageClass restrict
        hi _mncfmt ctermfg=darkmagenta
        hi _mnl4c ctermfg=darkyellow
        hi _mntrace ctermfg=darkyellow
        hi _mncomm ctermfg=darkgreen
        hi _mnty ctermfg=cyan
        hi _mnfn ctermfg=cyan
        hi _mntp ctermfg=lightcyan
        command -nargs=+ HiLink hi def link <args>
        HiLink mncfmt _mncfmt
        HiLink mnl4c _mnl4c
        HiLink mntrace _mntrace
        HiLink mncomm _mncomm
        HiLink mnty _mnty
        HiLink mnfn _mnfn
        HiLink mnex cConstant
        HiLink cOctalZero cError
        HiLink mnft _mntp
        HiLink mnxft _mntp
        HiLink mnfc _mntp
        HiLink mnxr _mntp
        HiLink mnxcb _mntp
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
nnoremap <leader>0 ^

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

if has("cscope")
    set csprg=/usr/local/bin/cscope
    set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb

    nnoremap <leader>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nnoremap <leader>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>

    nnoremap <leader>F :vert scs find d <C-R>=expand("<cword>")<CR><CR>
    nnoremap <leader>f :vert scs find c <C-R>=expand("<cword>")<CR><CR>

    nnoremap <leader>T :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nnoremap <leader>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nnoremap <leader>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nnoremap <leader>I :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nnoremap <leader>a :vert scs find a <C-R>=expand("<cword>")<CR><CR>
endif
