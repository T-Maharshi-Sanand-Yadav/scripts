cd ==> This will take you to your home directory

touch .gvimrc and add the below-mentioned content

To set all these configurations in your .gvimrc for all gVim instances, you can add the following lines to your .gvimrc file as seen from the image you provided:

syntax on
set background=dark
colorscheme murphy
set backspace=2
set nu
set hlsearch
set ic
nnoremap <F5> :let keyword=input("Enter keyword: ") \| execute ":%s/".keyword."//gn"<CR>
set cursorline
set colorcolumn=80

:source ~/.gvimrc


Website Link : https://www.tmsytutorials.com/2025/01/gvimrc.html
