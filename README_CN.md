## HicusLine

(Neo)Vim下的高度自定义状态栏。

English Document: [README](./README.md)

Gitee仓库地址: [HicusLine](https://gitee.com/springhan/HicusLine)

GitHub仓库地址: [HicusLine](https://github.com/Styadev/HicusLine)


### 截图

![图片加载失败](./demo.png)

### 安装

最好的办法就是使用 [vim-plug](https://github.com/junegunn/vim-plug) 进行安装:

```vim
Plug 'https://gitee.com/springhan/HicusLine.git'
```

### 配置

在安装过后，你可以在(Neo)Vim运行`:help hicusline`来阅读帮助文档；如果要查看中文版，可以运行`:help hicusline@cn`。

如果你不想花太多时间去配置它，你也可以看看示例配置(其实就是我的配置哈哈)。

```vim
let g:HicusLineEnabled = 1
let g:HicusColorSetWay = 1
let g:HicusLine = {
      \'active': {
      \    'left': [ 'modehighlight', 'space', 'mode', 'space', 'spell',
      \              '%#infos#', 'gitinfo', 0, 'modified', 'filename',
      \              'readonly', 'space', '%#ErrorStatus#', 'errorstatus',
      \              'space', '%#WarningStatus#', 'warningstatus', 0, ],
      \    'right': [ 'filetype2', 'space', '%#infos#', 'fileencoding', 'space',
      \               'fileformat', 'modehighlight', 'space', 'linenumber', ':',
      \               'bufferlinesnumber', 'space', 'windowpercentage', 'space',
      \    ],
      \},
      \'basic_option': {
      \    'ErrorSign': '●',
      \    'WarningSign': '●',
      \},
\}
let g:HicusLineMode = {
      \'n':      [ 'NORMAL', 'normalmode', { 'infos': 'normalinfos', }, ],
      \'i':      [ 'INSERT', 'insertmode', { 'infos': 'otherinfos',  }, ],
      \'R':      [ 'REPLACE', 'replacemode', { 'infos': 'otherinfos',  }, ],
      \'v':      [ 'VISUAL', 'visualmode', { 'infos': 'otherinfos',  }, ],
      \'V':      [ 'L-VISU', 'visualmode', { 'infos': 'otherinfos',  }, ],
      \"\<C-v>": [ 'B-VISU', 'visualmode', { 'infos': 'otherinfos',  }, ],
      \'c':      [ 'COMMAND', 'commandmode', { 'infos': 'otherinfos',  }, ],
      \'s':      [ 'SELECT', 'normalmode', { 'infos': 'normalinfos',  }, ],
      \'S':      [ 'L-SELE', 'normalmode', { 'infos': 'normalinfos',  }, ],
      \"\<C-s>": [ 'B-SELE', 'normalmode', { 'infos': 'normalinfos',  }, ],
      \'t':      [ 'TERMINAL', 'normalmode', { 'infos': 'normalinfos',  }, ],
\}
let g:HicusColor = {
      \'StatusLine':     [ 'none' ,'#8BE9FD', '#44475A', ],
      \'normalmode':     [ 'bold' ,'#282A36', '#BD93F9', ],
      \'insertmode':     [ 'bold', '#282A36', '#50FA7B', ],
      \'visualmode':     [ 'bold', '#282A36', '#FFB86C', ],
      \'replacemode':    [ 'bold', '#282A36', '#FF5555', ],
      \'commandmode':    [ 'bold', '#C6C6C6', '#3A81C3' ],
      \'normalinfos':    [ 'none', '#FFFFFF', '#6272A4', ],
      \'otherinfos':     [ 'none', '#44475A', '#8BE9FD', ],
      \'ErrorStatus':    [ 'none', '#FF0033', '#44475A', ],
      \'WarningStatus':  [ 'none', '#FFCC00', '#44475A', ],
\}
```

### 证书

MIT
