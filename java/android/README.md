## 开发入门

## 安装sdk
[下载Command line tools](https://developer.android.google.cn/studio#downloads)

[sdkmanager 使用](https://developer.android.google.cn/studio/command-line/sdkmanager)

### 报错 Warning: Could not create settings
[父目录必须为：cmdline-tools，如/data/app/android/cmdline-tools/tools/bin](https://stackoverflow.com/questions/60440509/android-command-line-tools-sdkmanager-always-shows-warning-could-not-create-se)


### 安装android-30
    cd /data/app/android/cmdline-tools/tools/bin
    sh sdkmanager "platform-tools" "platforms;android-30"

    生成位置 /data/app/android/platforms
    SDK HOME目录 /data/app/android