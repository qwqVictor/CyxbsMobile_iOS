# Catalyst

玩具级别的 Catalyst 支持。

## 注意事项

- 使用 `Podfile.catalyst`
- YYKit 的 Target 需要显式链接 `CoreTelephony`
- YYKit 需要进行修改以禁用 WebP 支持，由于 `WebP.framework` 不支持 Catalyst

## 现状

Catalyst 下，以下功能不可用：
- 校车（高德地图相关禁用）
- 友盟相关（推送通知、统计等）

UI 十分奇怪。
