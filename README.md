# Infinite · Flutter 创作社区

根据用户当前 Pixso 文件的 **12 个移动端界面**开发，保留深蓝灰背景、渐变按钮、作品网格和沉浸式画廊。工程支持 iOS / Android，以本地演示数据串联完整浏览流程。

本项目交付 Flutter 源码、项目结构与架构说明、设计来源、模拟器截图及可重复执行的验证脚本。应用保持原稿英文文案，项目文档使用中文。

## 主要界面

以下为实际运行的 Flutter 界面，完整截图见[界面截图索引](docs/SCREENSHOTS.md)。

| 最新作品 | 探索 | 个人主页 |
| --- | --- | --- |
| <img src="docs/screenshots/01-feed-new.png" width="230" alt="最新作品双列网格"> | <img src="docs/screenshots/06-explore.png" width="230" alt="探索与精选作品"> | <img src="docs/screenshots/07-profile.png" width="230" alt="创作者个人主页"> |

| 作品详情 | 作品说明 | 聊天 |
| --- | --- | --- |
| <img src="docs/screenshots/09-work.png" width="230" alt="沉浸式作品详情"> | <img src="docs/screenshots/10-work-description.png" width="230" alt="展开的作品说明"> | <img src="docs/screenshots/08-chat.png" width="230" alt="聊天会话"> |

## 功能与访问路径

| 模块 | 已实现内容 | 入口 |
| --- | --- | --- |
| New | 双列网格、列表模式、创作者头像入口 | 默认首页 |
| Recommended | 推荐作者、关注、作品及互动 | Feed 筛选 → Recommended |
| Activity | 点赞、关注、收藏动态展示 | Feed 筛选 → Activity / Notifications |
| 筛选 | 模式切换、网格/列表切换、创作者实时搜索、作者操作 | 蓝色筛选按钮；再次点 Feed；页面标题 |
| Explore | 精选内容、直播预览入口、作品菜单 | Explore |
| Profile | 作者资料、关注、Works/Likes/Following、聊天入口 | 头像或作者信息 |
| 作品画廊 | 左右滑动、作品说明、更多作品、点赞、收藏、复制分享摘要 | 任意作品卡片 |
| 评论 | Popular/New 排序、评论点赞、回复引用、展开回复、发表评论 | 作品底部评论按钮 |
| 播放器预览 | 播放/暂停、时间进度、拖动进度条 | 带视频标记的作品 → 播放按钮 |
| Inbox / Chat | 会话列表、聊天气泡、作者推荐、发送本地消息 | Inbox / Profile → Message |
| Search | 作品与作者实时搜索、收藏筛选、空结果状态 | Search |

建议体验：**New → 筛选 → Recommended → Abduction! → 左滑至 Spider-Man → 点作品信息展开说明 → 评论 → 返回 → Explore → 头像 → Message**。

## 项目结构

```text
Infinite/
├── lib/
│   ├── main.dart                  # 初始化设备存储与状态，启动应用
│   ├── app/
│   │   ├── app.dart               # MaterialApp、五栏导航与页面组装
│   │   ├── app_controller.dart    # 共享状态、交互命令与持久化触发
│   │   └── app_scope.dart         # InheritedNotifier 状态分发
│   ├── core/
│   │   ├── theme.dart             # Pixso 颜色、渐变、文字与分隔线
│   │   ├── widgets.dart           # 头像、作者行、卡片、网格、按钮等
│   │   ├── art_gallery.dart       # 作品缩略图横向画廊
│   │   └── app_navigation.dart    # 首页与个人主页复用的底部导航
│   ├── data/
│   │   ├── content.dart           # Creative / Artwork 模型与演示内容
│   │   └── local_repository.dart  # SharedPreferences 存储边界
│   └── features/
│       ├── feed/                  # New / Recommended / Activity 与筛选
│       ├── explore/               # 探索与精选
│       ├── profile/               # 作者主页
│       ├── work/                  # 作品画廊、说明、播放器与评论
│       ├── messaging/             # 会话列表与聊天
│       └── search/                # 作品、作者与收藏搜索
├── assets/images/                 # 来自 Pixso 的本地 WebP 图片
├── ios/                           # iOS Runner 与应用图标
├── android/                       # Android 工程与应用图标
├── test/                          # 持久化与关键界面组件测试
├── integration_test/              # 模拟器操作流程和截图测试
├── test_driver/                   # 将截图写回 docs/screenshots
├── tools/                         # 图片优化与图标生成脚本
├── docs/
│   ├── DESIGN_SOURCE.md           # Pixso 节点与实现对应关系
│   ├── SCREENSHOTS.md             # 所有页面与交互状态的截图
│   ├── VERIFICATION.md            # 实测环境、结果与限制
│   ├── design/                    # Pixso 原稿导出，便于对照
│   └── screenshots/               # 实际模拟器界面截图
└── .fvmrc                         # Flutter 3.41.6
```

## 架构说明

采用按业务功能组织的轻量分层结构，共享业务状态和页面局部状态分开管理。未引入额外路由、依赖注入或第三方状态管理框架。

```text
页面组件（features）
    ↓ 用户操作
AppController（ChangeNotifier）
    ├── notifyListeners → AppScope → 订阅的组件刷新
    └── LocalRepository → SharedPreferences → 设备本地 JSON
```

- **界面层**：各 feature 负责页面组合；通用组件集中到 core。标题、头像、按钮、卡片及导航保持统一。
- **共享状态**：AppController 管理当前导航、Feed 模式、视图模式、关注、点赞、收藏、评论和消息。通过 AppScope 读取与订阅。
- **局部状态**：画廊页码、详情展开、播放器进度、评论排序、搜索输入等由页面自身管理，页面退出时释放输入控制器、滚动控制器与计时器。
- **数据层**：Creative 与 Artwork 为不可变内容模型；LocalRepository 集中封装存储读写。持久化键为 `infinite.state.v1`，评论按作品 ID 分组。
- **导航**：底部五栏切换顶层内容；作者、作品与聊天通过集中定义的命名路由与 Navigator 页面栈打开；筛选与评论使用底部弹层。支持系统返回与界面返回按钮。

关注、点赞、收藏、用户评论和发送的消息会在下次启动时恢复。筛选、搜索词和播放器状态属于会话内状态。输入去除首尾空格，空消息和空评论不提交。

## 设计还原与适配

原稿基准为 **375 × 812**。布局使用 SafeArea、Expanded、可滚动容器与响应式网格适配手机安全区，图片通过裁剪与 BoxFit 保持比例。

| 设计项 | 实现 |
| --- | --- |
| 页面背景 | `#435461 → #28343A` |
| 次要文字 | `#AEBECE` |
| 蓝色渐变 | `#92CAFB → #559CD9` |
| 绿色渐变 | `#8CFD97 → #4ECB5A` |
| 强调色 | 验证橙、收藏金 |
| 卡片 | 15 px 圆角，10 px 网格间距 |
| 页面边距 | 20 px |
| 字体 / 图标 | Flutter 平台默认字体 / Cupertino Icons |

原稿和节点映射见[设计来源](docs/DESIGN_SOURCE.md)。为满足可用性补充了返回/关闭按钮、Inbox、Search、收藏和提交后状态。所有内容图片本地加载；导出时附带的阴影留白已清理，并统一压缩为 WebP。

## 运行

本机验证版本：Flutter **3.41.6**、Dart **3.11.4**。推荐使用工程提供的 `.fvmrc`。

```sh
flutter pub get
flutter devices
flutter run -d <device-id>
```

使用 FVM 时可将上述 `flutter` 替换为 `fvm flutter`。iOS 首次构建需要 Xcode、可用模拟器和 CocoaPods；Android 需要对应 SDK、JDK 17 与有效 SDK 许可。

```sh
# 静态检查与组件 / 状态测试
flutter analyze
flutter test

# 在 iOS 模拟器上执行真实操作并重新生成截图
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d <ios-simulator-id>
```

截图测试会重置此应用自己的 `infinite.state.v1` 演示数据，然后运行关注、点赞、收藏、评论、聊天和搜索流程。`test_driver` 自动将 PNG 写入 `docs/screenshots/`。

## 代码精简

统一主题、通用组件与持久化入口，复用作品网格、作者信息、关注按钮、作品互动条和底部导航；删除默认计数器示例与测试。运行时依赖仅保留 Flutter、Cupertino Icons、SharedPreferences。未加入当前需求没有使用的网络层、数据库或大型架构依赖。46 个图片资源清理导出留白并转换为 WebP，总体积约由 13 MB 降至 2 MB。

## 当前交付范围

这是可运行、可操作的本地 UI 演示应用。关注、互动和消息保存在当前设备，尚未接入账户、服务端、实时消息、文件上传、推送或直播服务。设计内的 PDF 只有文件名，点击显示演示说明；分享复制作品摘要。作品菜单的举报、屏蔽与内容偏好属于交互演示。

Pixso 只提供视频静帧，所以播放器实现控制界面与本地计时预览，未播放真实视频，也未连接直播。正式产品接入时，需提供视频源并使用实际媒体播放器替换预览。

详细测试记录与平台验证范围见[验证说明](docs/VERIFICATION.md)。
