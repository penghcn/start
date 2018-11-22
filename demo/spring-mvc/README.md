# spring-mvc demo
    需要提前安装：jdk1.8、gradle、git、mysql、idea、eclipse
    以下大部分是linux命令，win10可以使用自带的bash

## 1、创建、初始化项目
    cd /demo
    mkdir spring-mvc
    cd spring-mvc

### 初步编辑`build.gradle`文件，构建标准maven结构
    vi build.gradle

    plugins 'war'
    [compileJava, compileTestJava, javadoc]*.options*.encoding = 'UTF-8'

    task dirs {
        doLast {
            sourceSets*.java.srcDirs*.each { it.mkdirs() }
            sourceSets*.resources.srcDirs*.each { it.mkdirs() }
            //for web app --> src/main/webapp
            webAppDir.mkdirs()
        }
    }

    gradle dirs
### 初始化git
    cp ..xx.../.gitignore .
    git init

### idea打开项目
    Import Project，选择 Gradle，下一步(第一次使用，可能需要配置gradle安装目录，jdk安装目录)，勾选“Use auto-import”，结束。


## 附录
[Java入门参考](../../java)

[Gradle入门](../../gradle)

[Git入门](../../git)