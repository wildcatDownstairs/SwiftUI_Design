//
//  MenuButtonDemo.swift
//  SwiftUI Demo
//
//  组件面板里的 MenuButton 是 SwiftUI 1.0 时代的旧 API，仅在 macOS 上存在（iOS 从来没有这个 API），
//  且在 macOS 上也已被标记为 deprecated，官方说明是"Use Menu instead"；对应的 MenuButtonStyle
//  协议也一并被 MenuStyle 取代。所以这里不实现 MenuButton 本身，只演示跨平台通用的现代替代写法。
//

import SwiftUI

struct MenuButtonDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 废弃说明
                DemoSection(
                    "MenuButton 已废弃",
                    note: "MenuButton 是 macOS 专属的旧 API（iOS 从未提供），且在 macOS 上也已 deprecated，跨平台统一替代方案是 Menu"
                ) {
                    Text("MenuButton(\"标题\") { ... } → 仅 macOS，已废弃\nMenu(\"标题\") { ... } → 现代写法")
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                // MARK: 现代替代写法
                DemoSection("现代替代：Menu + .menuStyle(.button)", note: "外观最接近旧 MenuButton 的按钮式下拉菜单") {
                    Menu("选择选项") {
                        Button("选项 A", action: {})
                        Button("选项 B", action: {})
                        Button("选项 C", action: {})
                    }
                    .menuStyle(.button)
                    .buttonStyle(.bordered)
                }

                // MARK: 样式协议替代
                DemoSection("MenuButtonStyle → MenuStyle", note: "旧的 MenuButtonStyle 协议也一并废弃，自定义样式统一改用 MenuStyle 协议") {
                    Menu("自定义样式菜单") {
                        Button("选项 1", action: {})
                        Button("选项 2", action: {})
                    }
                    .menuStyle(.automatic)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Menu Button")
    }
}

#Preview {
    NavigationStack {
        MenuButtonDemo()
    }
}
