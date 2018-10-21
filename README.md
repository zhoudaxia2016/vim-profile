# 我的vim配置

> 基本都是利用原始的vim功能实现的

---
<div class="table-users">
  <div class="header">已经实现的功能</div>
  <table border="0" cellspacing="0" style="width:100%">
    <tr>
      <th>tag</th>
      <th>subject</th>
      <th>completion</th>
      <th>desc</th>
    </tr>
    <tr>
      <td rowspan="4" class="t">基本编辑</td>
      <td>缩进</td>
      <td>4</td>
      <td>使用基本的tab设置就可以了，再有就是还要设置cleverTab，一键tab缩进</td>
    </tr>
    <tr>
      <td>补全</td>
      <td>2.5</td>
      <td>基本是利用关键字补全，没有语法补全功能</td>
    </tr>
    <tr>
      <td>高亮</td>
      <td>4</td>
      <td>onedark配色,以上功能还要考虑vue文件的配置,在公司电脑上利用了终端的配色</td>
    </tr>
    <tr>
      <td>文件浏览</td>
      <td>3.5</td>
      <td>自带netrw插件</td>
    </tr>
    <tr>
      <td rowspan="5" class="t">项目开发</td>
      <td>搜索替换</td>
      <td>3.5</td>
      <td>自带搜索替换功能</td>
    </tr>
    <tr>
      <td>语法检查</td>
      <td>2</td>
      <td>只做了eslint的语法检查</td>
    </tr>
    <tr>
      <td>模板</td>
      <td>3</td>
      <td>包括项目模板和文件模板,基本实现</td>
    </tr>
    <tr>
      <td>snippet</td>
      <td>2</td>
      <td>使用abbr，没有跳转和默认值功能</td>
    </tr>
    <tr>
      <td>git flow</td>
      <td>1</td>
      <td>使用vimdiff作为diff.tool,git log和git status结果用vim打开</td>
    </tr>
    <tr>
      <td rowspan="2" class="t">其他</td>
      <td>markdown预览</td>
      <td>4</td>
      <td>使用vim8的job和js的markodwn库</td>
    </tr>
    <tr>
      <td>翻译</td>
      <td>4</td>
      <td>ydcv.py</td>
    </tr>
  </table>
</div>

---

## TODO

### 1. Debug and bug jump



## Bug fix
### 2018 10 13

- [x] netrw打开当前目录 `设置autochdir选项`
- [] 文件修改后reload
- [] netrw宽度
- [x] 打开markdown的bug `端口占用导致的`
- [] 目录下搜索bug 

### 2018 10 14

- [x] markdown文件自动保存

### 2018 10 18

> 远程编辑文件遇到的bug

- [x] 打开与编辑都需要输入密码 `配置ssh的ControlMaster属性,每次打开远程文件或者目录时建立一个ssh的socket链接`
- [] 保存文件后字符错乱，需要跳转到底部刷新界面
- [] 错误会生成错误信息在目录上
