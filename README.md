# network_info_plus_ohos

[![pub package](https://img.shields.io/pub/v/network_info_plus_ohos.svg)](https://pub.dartlang.org/packages/network_info_plus_ohos) [![GitHub stars](https://img.shields.io/github/stars/harmonycandies/network_info_plus_ohos)](https://github.com/harmonycandies/network_info_plus_ohos/stargazers) [![GitHub forks](https://img.shields.io/github/forks/harmonycandies/network_info_plus_ohos)](https://github.com/harmonycandies/network_info_plus_ohos/network) [![GitHub license](https://img.shields.io/github/license/harmonycandies/network_info_plus_ohos)](https://github.com/harmonycandies/network_info_plus_ohos/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/harmonycandies/network_info_plus_ohos)](https://github.com/harmonycandies/network_info_plus_ohos/issues) <a target="_blank" href="https://qm.qq.com/q/ajfsyk2RcA"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="harmony-candies" title="harmony-candies"></a>

Flutter plugin for discovering information (e.g. WiFi details) of the network on OpenHarmony.

The OpenHarmony implementation of [`network_info_plus`][1].

[`network_info_plus`][1] 在 OpenHarmony 平台的实现。


# 使用

```yaml
dependencies:
  network_info_plus: any
  network_info_plus_ohos: any
```

在你的项目的 `module.json5` 文件中增加以下权限设置。

```json
    requestPermissions: [
      {"name" :  "ohos.permission.INTERNET"},
      {"name" :  "ohos.permission.GET_WIFI_INFO"},
    ],
```


 [1]: https://pub.dev/packages/network_info_plus

