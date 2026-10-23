# 验证记录

验证日期：2026-10-23。

## 环境

- macOS 26.5.2、Xcode 26.0.1、CocoaPods 1.16.2。
- Flutter 3.41.6 stable、Dart 3.11.4。
- iPhone 17 Pro 模拟器、iOS 26.0。

## 检查与结果

| 检查 | 结果 |
| --- | --- |
| `flutter analyze` | 无问题 |
| `flutter test` | 状态持久化与组件流程测试通过 |
| iOS 模拟器构建 | 成功 |
| `flutter drive` 集成测试 | 完整用户操作流程通过 |
| 页面截图 | 20 张实际 Flutter 界面 PNG 已生成 |
| 设计参考 | 12 张 Pixso 原稿 PNG 已导出 |

组件与状态测试覆盖：关注、收藏、点赞、消息与评论持久化；作品间评论隔离；空输入不提交；筛选切换与搜索空结果。

模拟器测试通过实际点击与输入覆盖：New、筛选搜索、网格/列表切换、Recommended、关注、作品画廊滑动、点赞与收藏、展开作品说明、评论排序与发表、播放器播放/暂停、Activity、Explore 与菜单、个人主页、聊天发送、Inbox、全局搜索、清空搜索与收藏结果。

截图后逐项回看，修正了 Pixso 图片导出附带的阴影留白、过亮分隔线、详情区域点击命中和个人主页底栏。最终已使用 WebP 本地资源并统一复用组件。

## 可重复验证

在项目根目录执行：

```sh
flutter pub get
flutter analyze
flutter test
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d <ios-simulator-id>
```

测试会清除本应用的演示状态键，再生成可重复的操作结果与截图。截图驱动写入 `docs/screenshots/`；不要将测试期间创建的示例消息当作真实服务端数据。

## 平台与功能边界

已实际验证 iOS 模拟器。Android 工程已提供，但未执行 Android 设备/模拟器运行验证；当前机器的 Android SDK 尚有许可未接受。iOS 真机签名、App Store 发布与 Android 发行签名未配置。

未连接后端、账号、即时通信、文件上传、推送、真实视频与直播。消息、评论、关注、点赞与收藏仅在设备本地生效。播放器为静帧及本地时间轴的交互预览；文件、举报和内容偏好菜单为演示反馈。
