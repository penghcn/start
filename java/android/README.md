## 开发入门

## 使用idea或者直接下载android studio
    同下面安装sdk的下载地址

## 安装sdk
[下载Command line tools](https://developer.android.google.cn/studio#downloads)，如commandlinetools-mac-6609375_latest.zip

[sdkmanager 使用](https://developer.android.google.cn/studio/command-line/sdkmanager)

### 报错 Warning: Could not create settings
[父目录必须为：cmdline-tools](https://stackoverflow.com/questions/60440509/android-command-line-tools-sdkmanager-always-shows-warning-could-not-create-se)，如/data/app/android/cmdline-tools/tools/bin


### 安装android-30
    cd /data/app/android/cmdline-tools/tools/bin
    sh sdkmanager "platform-tools" "platforms;android-30"

    生成位置 /data/app/android/platforms
    SDK HOME目录 /data/app/android

    可以在idea中添加sdk，社区版先在plugins中勾选Android插件

### 安装ndk
    ./sdkmanager --list   --no_https  | grep ndk
    ./sdkmanager --install "ndk;21.0.6113669" --channel=0 --verbose --no_https 

    或者使用国内代理镜像，大连东软 
    ./sdkmanager --update --verbose --no_https --proxy=http --proxy_host=mirrors.neusoft.edu.cn --proxy_port=80
    ./sdkmanager --list   --no_https  --proxy=http --proxy_host=mirrors.neusoft.edu.cn --proxy_port=80 | grep ndk
    ./sdkmanager --install "ndk;21.3.6528147" --channel=0 --verbose --no_https --proxy=http --proxy_host=mirrors.neusoft.edu.cn --proxy_port=80
    
### 安装emulator
    ./sdkmanager --install emulator --verbose --no_https 
    
### 安装build-tools
    ./sdkmanager --install "build-tools;30.0.2" --verbose --no_https 

### 安装基于64位的system-images
    ./sdkmanager --list   --no_https  | grep system-images
    ./sdkmanager --install "system-images;android-30;google_apis;x86_64" --verbose --no_https 

