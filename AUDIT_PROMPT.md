# SwiftUI 组件说明库 —— 代码审计 Prompt

## 项目背景

这是一个 SwiftUI 组件文档/演示项目（类似 Ant Design 官网的组件文档，但用纯 SwiftUI 原生实现），目标用户是正在学习 SwiftUI 的开发者。每个原生组件对应一个 `XxxDemo.swift` 文件，把该组件的**全部常用 API** 罗列展示，外加必要时的真实场景示例。请你对整个项目做一次代码审计，找出不符合下述标准的地方。

## 已经确立的质量标准（审计基准）

### 1. 排版统一：所有示例必须用共享的 `DemoSection`

`ComponentDemoSection.swift` 里定义了 `DemoSection(title:note:content:)`，是整个项目唯一的卡片容器（强调色竖条标题 + 内容 + 带 info 图标的提示框，圆角+描边+阴影）。**审计点**：

- 是否有 `XxxDemo.swift` 文件里的示例没有包在 `DemoSection` 里，直接裸放 View？
- 是否有文件自己又写了一套不一致的卡片样式？

### 2. API 覆盖要"全"，且原生 API 与自定义模拟要分清楚

每个组件文件的目标是把官方文档里这个组件的初始化方式、关键修饰符（`.xxxStyle()`、常用 modifier）尽量列全，颗粒度参考 Ant Design 官网每个组件文档的演示密度（语法糖 / 颜色与变体矩阵 / 图标 / 尺寸 / 禁用态 等分块）。**审计点**：

- 有没有遗漏该组件的常见初始化重载或关键修饰符？
- SwiftUI 原生没有的视觉变体（比如 Ant Design 的 Outlined/Dashed/Filled/Text/Link 五种按钮变体），项目里是通过自定义 `ButtonStyle`/`LabelStyle`/`GroupBoxStyle`/`LabeledContentStyle` 等协议模拟出来的——**这类自定义实现必须在注释或 `note` 里明确标注"自定义模拟，非系统原生"**，避免学习者误以为这是系统自带能力。检查是否每处自定义样式都有这个标注。
- 检查 `note` 文案本身是否存在 API 幻觉（声称某个方法/参数存在但实际上 SwiftUI 没有这个 API），需要对照官方文档逐条核实。

### 3. 已废弃/平台不可用的 API：只做说明，不做实现

项目里遇到过几个例子：

- `HSplitView`/`VSplitView`：macOS 专属，iOS 不存在，写了直接编译失败 → 对应文件改成展示 `NavigationSplitView` 作为现代替代，并在文件头注释说明原因。
- `MenuButton`：SwiftUI 2.0（iOS 14）起已废弃，替代方案是 `Menu` → 对应文件只演示 `Menu + .menuStyle(.button)` 等现代写法，不实现 `MenuButton` 本身。
- `NavigationView`：iOS 16 起已废弃 → 对应文件演示 `NavigationStack`（单栏替代）和 `NavigationSplitView`（多栏替代），不实现 `NavigationView` 本身。

**审计点**：

- 是否有文件试图实现一个已废弃或当前平台不支持的 API（这会导致编译失败或产生大量 deprecation 警告）？
- 对应的"已废弃/不可用"说明文件，是否清楚写了废弃原因 + 现代替代方案？

### 4. 全屏级容器不能硬塞进小卡片

`NavigationStack`、`NavigationSplitView`、`TabView` 这类组件本身是"全屏级容器"，如果硬塞进外层 `ScrollView` 里一个带 `.frame(height:)` 的小卡片，会渲染异常（实测出现过整块内容空白/纯黑的情况）。项目里确立的解决方案是：这类组件的演示文件改用 `List + NavigationLink`，跳转到独立的全屏示例页面去演示，不再用 `DemoSection` 卡片包裹实际的容器实例。

**审计点**：

- 搜索项目里是否还有 `NavigationStack(...)`、`NavigationSplitView(...)`、`TabView(...)` 的实例被直接包在 `DemoSection { ... }` 内部、且外面又套了一层 `ScrollView` 的情况——这是高风险的渲染 bug 模式，需要标记出来。
- 反过来检查：被改造成"List + NavigationLink 跳转独立页"模式的文件（`NavigationStackDemo.swift`、`NavigationSplitViewDemo.swift`、`NavigationViewDemo.swift`、`TabViewDemo.swift`），跳转目标页面是否都正确定义、没有遗漏。

### 5. 容器尺寸用 `frame(minHeight:)`，不要用 `frame(height:)`

凡是在 `DemoSection` 里嵌入 `Form`/`List` 这类自带滚动能力的容器、又想限制它在卡片里的默认高度时，必须用 `.frame(minHeight:)` 而不是 `.frame(height:)`——因为内容如果是可展开的（`DisclosureGroup`、`Section(isExpanded:)`、可变行数的 `List`），固定 `height` 会导致展开后的内容被硬裁切看不到，且不能滚动补救。

**审计点**：

- 全项目搜索 `.frame(height:`，确认每一处都是"内容尺寸恒定、不会动态变化"的场景（比如纯装饰用的色块、固定 5 行且不可展开的 List）。如果发现 `.frame(height:)` 包裹的内容里有 `DisclosureGroup`、可展开 `Section`、或者其他运行时可能变高的元素，必须报告为 bug，并建议改成 `.frame(minHeight:)`。

### 6. 首页分类要对齐 Ant Design 的组件分组

`HomeView.swift` 把所有组件 Demo 按 Ant Design 官网的分类法分组：**通用 / 布局 / 导航 / 数据录入 / 数据展示 / 反馈**（外加一个和 Ant Design 无关的"练习 Demo"分组，放的是早期布局练习文件，不是组件文档）。

**审计点**：

- 检查每个组件被分到的类目是否合理（参照 Ant Design 官网对应组件的真实分类，例如 `DatePicker`→数据录入，`Collapse`类组件→数据展示，`Dropdown`/`Menu`→导航）。
- 检查 `HomeView.swift` 里的 `NavigationLink` 列表和实际项目里存在的 `XxxDemo.swift` 文件是否一一对应——有没有"建了文件但首页忘了加入口"或者"首页有入口但文件被删掉/改名导致编译错误"的情况。

## 请你具体输出

1. **逐文件清单**：每个 `XxxDemo.swift` 文件过一遍，标记是否符合上述 6 条标准，不符合的指出具体行号和问题。
2. **API 完整性差距**：对照官方文档，列出每个组件文件里明显缺失的常用 API/修饰符（不要求 100% 全覆盖，但常见的初始化重载和 `.xxxStyle()` 不应该漏）。
3. **高风险 bug 清单**：优先列出"全屏容器塞进小卡片"和"`frame(height:)` 裁切动态内容"这两类已知风险模式，在代码里有没有新增的、还没被发现的实例。
4. **分类问题清单**：`HomeView.swift` 里有没有分类错误或入口缺失/多余。
5. **风格不一致清单**：有没有文件没用 `DemoSection`、注释风格（中文/英文夹杂、术语不统一）明显跑偏的地方。

每条问题请给出**文件名 + 行号（如果能定位）+ 一句话描述问题 + 建议的修复方式**，不需要直接帮我改代码，先给审计报告。
