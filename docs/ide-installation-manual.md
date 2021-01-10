# 集成开发环境安装配置手册

## 系统要求

1. 本手册适用于 Windows 10+ 系统。
2. 在有足够空间的磁盘建立一个不含空格的目录，用于安装相关环境，例如：`C:\SDK`，我们定义为 `${SDK}$`。

## Visual Studio Code 安装和配置

1. 获取最新版本的 [Visual Studio Code](https://code.visualstudio.com/)。
2. 设置安装路径：

    ![](images/ide-installation-manual/visual-studio-code-installation-path.png)
3. 选择安装任务：

    ![](images/ide-installation-manual/visual-studio-code-installation-tasks.png)

## Git 安装和配置

1. 获取最新版本的 [Git](https://git-scm.com/)。
2. 设置安装路径：

    ![](images/ide-installation-manual/git-installation-path.png)
3. 选择默认编辑器：

    ![](images/ide-installation-manual/git-installation-default-editor.png)
4. 开启软链接支持：

    ![](images/ide-installation-manual/git-installation-enable-symbolic-links.png)
5. Git 相关操作详见 Pro Git，[在线版本](https://git-scm.com/book/zh/v2)。

## R 安装和配置

1. 获取最新版的 R ([下载地址](https://cloud.r-project.org/))。
2. 将 R 安装在 `${SDK}` 目录中，R 的安装根目录我们定义为 `${R_ROOT}`，如图所示：

    ![](images/ide-installation-manual/r-installation-path.png)
3. 选择安装组件：

    ![](images/ide-installation-manual/r-installation-components.png)

## RStudio 安装和配置

1. 获取最新版 Preview 版本的 RStudio ([下载地址](https://www.rstudio.com/products/rstudio/download/preview/))。
2. 将 RStudio 安装在 `${SDK}` 目录中，相关选项如图：

    ![](images/ide-installation-manual/rstudio-installation-path.png)
3. 安装完毕后打开，从菜单栏依次单击 `Tools -> Global Options...` 打开配置对话框。
4. 基本配置选项如下，其他配置用户可自行设置：
    - `Code -> Editing -> General -> Tab Width -> 4`
    - `Code -> Display -> General -> Show margin -> TRUE`
    - `Code -> Saving -> Serialization -> Default text encoding -> UTF-8`

## Python 安装和配置

1. 下载最新版本 [Anaconda 3](https://www.anaconda.com/download/)。
2. 选择安装类型：

    ![](images/ide-installation-manual/anaconda3-installation-type.png)
3. 设置安装路径：

    ![](images/ide-installation-manual/anaconda3-installation-path.png)
4. 启动 Anaconda 3 Navigator：

    ![](images/ide-installation-manual/anaconda3-navigator.png)

## Jupyter 安装和配置

1. Jupyter 已经在包含在 Anaconda 3 发行版中。
2. 进入 Anaconda Prompt，运行 `${R_ROOT}/bin/R.exe` 并启动 R，运行如下命令安装用于 Jupyter 的 R Kernel：
    ```shell
    install.packages('IRkernel')
    IRkernel::installspec()
    ```
3. 通过 Anaconda 3 Navigator 启动 Jupyter Lab：

    ![](images/ide-installation-manual/jupyter-lab.png)
4. 通过 Anaconda 3 Navigator 启动 Jupyter Notebook：

    ![](images/ide-installation-manual/jupyter-notebook.png)