# 我的vim配置

> 原则：
> - 尽量不引入第三方插件
> - 结合其他工具

## 配置

### 基本编辑
|  feature   | degree | detail |
|  ----  | ----  | ---- |
| 补全  | 4 |  vim基本补全功能 |
| 语法高亮  | 4 | nord-vim |
| 目录导航  | 3 | 自带netrw插件 |

### 项目开发
|  feature   | degree | detail |
|  ----  | ----  | ---- |
| 搜索替换  | 4 | 自带搜索替换功能，整个项目的搜索使用fzf + rg |
| 语法检查/智能补全/跳转  | 4 | neovim build in lsp client + typescript-language-server  |
| snippet  | 4 | vim-vsnip插件 |

### 其他
|  feature   | degree | detail |
|  ----  | ----  | ---- |
| markdown预览  | 4 | chrome MarkdownPreviewPlus插件 |
| 翻译 | 4 | translate-shell命令行工具 |

---

## submodule管理插件
目录 `pack/bundle/start/`

## 基本submodule插件
`nord-vim` 语法高亮theme
`nvim-lspconfig` neovim built-in lsp client
`vim-vsnip` snippet
`indentLine` 缩进提示

## 引入插件
```
git submodule add url path
git submodule update -remote
```

### 更新插件
```
git submodule update --remote
```

### 仓库初始化时初始化submodule
```
git submodule init
git submodule update
```

### 删除插件
```
git rm --cached submodulepath
#Delete the relevant lines from the .gitmodules file.
#Delete the relevant section from .git/config.
git add .gitmodules
git commit -m "commitmsg"
rm -rf submodulepath
rm -rf .git/modules/submodulepath
```
