# Pixso 设计来源

读取时间：2026-10-23。Pixso 当前文件，Page 1（`0:1`）。原稿尺寸为 375 × 812；应用使用弹性布局与系统安全区。

| 原稿界面 | Node ID | 实现入口 | 设计预览 |
| --- | --- | --- | --- |
| Feed / New | `14:74` | Feed → New | [原稿](design/01-feed-new.png) |
| Feed / Recomended | `1:2` | Feed → Recommended | [原稿](design/02-feed-recommended.png) |
| Feed / Activity | `16:4` | Feed → Activity / Notifications | [原稿](design/03-feed-activity.png) |
| Feed / New / Filter | `18:158` | Feed 底部蓝色筛选按钮 | [原稿](design/04-feed-filter.png) |
| Feed / New / Filter 2 | `19:157` | 筛选面板内输入 James Ko | [原稿](design/05-filter-search.png) |
| Explore | `19:393` | 底部 Explore | [原稿](design/06-explore.png) |
| Profile | `36:261` | 右上角头像 | [原稿](design/07-profile.png) |
| Chat | `44:321` | Inbox → Mary / 主页 Message | [原稿](design/08-chat.png) |
| Opened Work | `26:283` | Recommended → Abduction! | [原稿](design/09-work.png) |
| Opened Work/Description | `29:295` | 画廊滑至 Spider-Man，展开底部信息 | [原稿](design/10-work-description.png) |
| Opened Work/Comments | `34:0` | 作品页评论按钮 | [原稿](design/11-comments.png) |
| Opened Video | `46:55` | Spider-Man → 播放按钮 | [原稿](design/12-video.png) |

通过 Pixso 读取截图、图层、颜色样式和图片，并导出 46 个作品与头像资源。自动 Flutter 代码生成连续两次超时，未使用生成代码；最终以手写的 Flutter 组件实现。

原始素材来自用户提供的 Pixso 设计。素材使用范围与授权以原设计为准。未从外部图片网站补充素材。

为让页面能够操作，新增 Inbox 列表、Search、列表模式、收藏结果与提交成功状态；增加返回、关闭和详情展开入口。系统图标使用 Cupertino Icons，未嵌入原稿 Font Awesome 字体。原稿仅提供视频静帧，播放器为本地交互预览。

图片节点与资源文件的完整映射见 [asset-manifest.json](asset-manifest.json)。
