//
//  HomeView.swift
//  SwiftUI Demo
//
//  App 首页：分组列出所有 Demo，纯原生 List + insetGrouped 风格，不做自定义视觉
//  支持搜索：按英文/中文名过滤，过滤后仍按原分类分组展示
//

import SwiftUI

private struct DemoRow: View {
    let en: String
    let cn: String

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Theme.accent.opacity(0.16))
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.caption2)
                        .foregroundStyle(Theme.accent)
                )
            VStack(alignment: .leading, spacing: 1) {
                Text(en)
                    .foregroundStyle(Theme.ink)
                Text(cn)
                    .font(.caption)
                    .foregroundStyle(Theme.inkSecondary)
            }
        }
    }
}

private struct DemoItem: Identifiable {
    let id = UUID()
    let en: String
    let cn: String
    let category: String
    let destination: () -> AnyView
}

// 分类顺序固定，搜索过滤后也按这个顺序展示，不是按搜索命中顺序乱排
private let categoryOrder = ["通用", "布局", "导航", "数据录入", "数据展示", "反馈", "Liquid Glass", "练习 Demo"]

private let allDemos: [DemoItem] = [
    // 通用
    DemoItem(en: "Button", cn: "按钮", category: "通用") { AnyView(ButtonDemo()) },
    DemoItem(en: "Label", cn: "标签", category: "通用") { AnyView(LabelDemo()) },
    DemoItem(en: "Edit Button", cn: "编辑按钮", category: "通用") { AnyView(EditButtonDemo()) },
    DemoItem(en: "Link", cn: "链接", category: "通用") { AnyView(LinkDemo()) },
    DemoItem(en: "Paste Button", cn: "粘贴按钮", category: "通用") { AnyView(PasteButtonDemo()) },
    DemoItem(en: "Rename Button", cn: "重命名按钮", category: "通用") { AnyView(RenameButtonDemo()) },
    DemoItem(en: "Share Link", cn: "分享链接", category: "通用") { AnyView(ShareLinkDemo()) },
    DemoItem(en: "Sign In With Apple", cn: "苹果登录按钮", category: "通用") { AnyView(SignInWithAppleButtonDemo()) },
    DemoItem(en: "Text", cn: "文本", category: "通用") { AnyView(TextDemo()) },

    // 布局
    DemoItem(en: "Control Group", cn: "控件组", category: "布局") { AnyView(ControlGroupDemo()) },
    DemoItem(en: "Depth Stack", cn: "深度堆叠", category: "布局") { AnyView(DepthStackDemo()) },
    DemoItem(en: "Geometry Reader", cn: "几何读取器", category: "布局") { AnyView(GeometryReaderDemo()) },
    DemoItem(en: "Horizontal Stack", cn: "水平堆叠", category: "布局") { AnyView(HorizontalStackDemo()) },
    DemoItem(en: "Lazy Horizontal Grid", cn: "懒加载水平网格", category: "布局") { AnyView(LazyHGridDemo()) },
    DemoItem(en: "Lazy Horizontal Stack", cn: "懒加载水平堆叠", category: "布局") { AnyView(LazyHStackDemo()) },
    DemoItem(en: "Lazy Vertical Grid", cn: "懒加载垂直网格", category: "布局") { AnyView(LazyVGridDemo()) },
    DemoItem(en: "Lazy Vertical Stack", cn: "懒加载垂直堆叠", category: "布局") { AnyView(LazyVStackDemo()) },
    DemoItem(en: "Split View", cn: "分栏视图", category: "布局") { AnyView(NavigationSplitViewDemo()) },
    DemoItem(en: "Scroll View", cn: "滚动视图", category: "布局") { AnyView(ScrollViewDemo()) },
    DemoItem(en: "Scroll View Reader", cn: "滚动定位器", category: "布局") { AnyView(ScrollViewReaderDemo()) },
    DemoItem(en: "Section", cn: "分组", category: "布局") { AnyView(SectionDemo()) },
    DemoItem(en: "Spacer", cn: "弹性占位", category: "布局") { AnyView(SpacerDemo()) },
    DemoItem(en: "Vertical Stack", cn: "垂直堆叠", category: "布局") { AnyView(VerticalStackDemo()) },
    DemoItem(en: "View That Fits", cn: "自适应视图", category: "布局") { AnyView(ViewThatFitsDemo()) },

    // 导航
    DemoItem(en: "Menu", cn: "菜单", category: "导航") { AnyView(MenuDemo()) },
    DemoItem(en: "Menu Button", cn: "菜单按钮（已废弃）", category: "导航") { AnyView(MenuButtonDemo()) },
    DemoItem(en: "Navigation Link", cn: "导航链接", category: "导航") { AnyView(NavigationLinkDemo()) },
    DemoItem(en: "Navigation Stack", cn: "导航栈", category: "导航") { AnyView(NavigationStackDemo()) },
    DemoItem(en: "Navigation View", cn: "导航视图（已废弃）", category: "导航") { AnyView(NavigationViewDemo()) },
    DemoItem(en: "Tab View", cn: "标签视图", category: "导航") { AnyView(TabViewDemo()) },

    // 数据录入
    DemoItem(en: "Color Picker", cn: "取色器", category: "数据录入") { AnyView(ColorPickerDemo()) },
    DemoItem(en: "Date Picker", cn: "日期选择器", category: "数据录入") { AnyView(DatePickerDemo()) },
    DemoItem(en: "Multi Date Picker", cn: "多日期选择器", category: "数据录入") { AnyView(MultiDatePickerDemo()) },
    DemoItem(en: "Form", cn: "表单", category: "数据录入") { AnyView(FormDemo()) },
    DemoItem(en: "Picker", cn: "选择器", category: "数据录入") { AnyView(PickerDemo()) },
    DemoItem(en: "Secure Field", cn: "密码输入框", category: "数据录入") { AnyView(SecureFieldDemo()) },
    DemoItem(en: "Slider", cn: "滑动条", category: "数据录入") { AnyView(SliderDemo()) },
    DemoItem(en: "Stepper", cn: "步进器", category: "数据录入") { AnyView(StepperDemo()) },
    DemoItem(en: "Text Editor", cn: "文本编辑器", category: "数据录入") { AnyView(TextEditorDemo()) },
    DemoItem(en: "Text Field", cn: "文本输入框", category: "数据录入") { AnyView(TextFieldDemo()) },
    DemoItem(en: "Toggle", cn: "开关", category: "数据录入") { AnyView(ToggleDemo()) },

    // 数据展示
    DemoItem(en: "Disclosure Group", cn: "折叠面板", category: "数据展示") { AnyView(DisclosureGroupDemo()) },
    DemoItem(en: "Group Box", cn: "分组框", category: "数据展示") { AnyView(GroupBoxDemo()) },
    DemoItem(en: "Labeled Content", cn: "标签化内容", category: "数据展示") { AnyView(LabeledContentDemo()) },
    DemoItem(en: "List", cn: "列表", category: "数据展示") { AnyView(ListComponentDemo()) },
    DemoItem(en: "Outline Group", cn: "大纲分组", category: "数据展示") { AnyView(OutlineGroupDemo()) },
    DemoItem(en: "Table", cn: "表格", category: "数据展示") { AnyView(TableDemo()) },

    // 反馈
    DemoItem(en: "Gauge", cn: "仪表盘", category: "反馈") { AnyView(GaugeDemo()) },
    DemoItem(en: "Progress View", cn: "进度视图", category: "反馈") { AnyView(ProgressViewDemo()) },

    // Liquid Glass
    DemoItem(en: "Liquid Glass", cn: "液态玻璃", category: "Liquid Glass") { AnyView(LiquidGlassDemo()) },

    // 练习 Demo
    DemoItem(en: "Alignment", cn: "对齐布局练习", category: "练习 Demo") { AnyView(ContentView()) },
    DemoItem(en: "Card List", cn: "卡片列表练习", category: "练习 Demo") { AnyView(ListViewDemo()) },
]

struct HomeView: View {
    @State private var searchText = ""

    private var groupedDemos: [(category: String, items: [DemoItem])] {
        let filtered = searchText.isEmpty
            ? allDemos
            : allDemos.filter {
                $0.en.localizedCaseInsensitiveContains(searchText) || $0.cn.localizedCaseInsensitiveContains(searchText)
            }
        return categoryOrder.compactMap { category in
            let items = filtered.filter { $0.category == category }
            return items.isEmpty ? nil : (category, items)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedDemos, id: \.category) { group in
                    Section {
                        ForEach(group.items) { item in
                            NavigationLink { item.destination() } label: {
                                DemoRow(en: item.en, cn: item.cn)
                            }
                            .listRowBackground(Color.white.opacity(0.55))
                        }
                    } header: {
                        Text(group.category)
                            .foregroundStyle(Theme.accent)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(GlassBackground().ignoresSafeArea())
            .navigationTitle("SwiftUI Demo")
            .searchable(text: $searchText, prompt: "搜索组件")
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    HomeView()
}
