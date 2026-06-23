//
//  MenuDemo.swift
//  SwiftUI Demo
//
//  Menu 组件说明
//  初始化方式：
//    Menu("标题") { 按钮们 }                 —— 点击弹出下拉菜单
//    Menu(content:label:)                  —— label 可放任意 View（@ViewBuilder）
//    Menu(_:primaryAction:_:)               —— 点击触发主操作，长按才弹出菜单
//  .menuStyle() 控制外观：automatic / button
//

import SwiftUI

struct MenuDemo: View {
    @State private var sortOrder = "默认"
    @State private var primaryActionCount = 0
    @State private var nativeSort = "默认"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Menu(\"标题\") { 按钮们 } —— 点击弹出下拉菜单，菜单项通常是 Button") {
                    Menu("操作") {
                        Button("分享", action: {})
                        Button("收藏", action: {})
                        Button("删除", role: .destructive, action: {})
                    }
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "Menu(content:label:) 的 label 可以放任意 View，不限于文字") {
                    Menu {
                        Button("编辑", action: {})
                        Button("复制", action: {})
                    } label: {
                        Label("更多", systemImage: "ellipsis.circle")
                    }
                }

                // MARK: 嵌套子菜单
                DemoSection("嵌套子菜单", note: "Menu 内部可以再放一个 Menu，组成多级菜单") {
                    Menu("排序方式") {
                        Button("按名称", action: {})
                        Button("按时间", action: {})
                        Menu("更多选项") {
                            Button("按大小", action: {})
                            Button("按类型", action: {})
                        }
                    }
                }

                // MARK: primaryAction
                DemoSection(
                    "primaryAction（点击 vs 长按）",
                    note: "Menu(_:content:primaryAction:) —— 直接点击触发 primaryAction，长按才弹出菜单，常见于工具栏的「主操作 + 更多选项」组合"
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Menu("点击 +1（长按看更多）") {
                            Button("重置", action: { primaryActionCount = 0 })
                        } primaryAction: {
                            primaryActionCount += 1
                        }
                        Text("当前计数：\(primaryActionCount)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: 选中态菜单（原生 Picker）
                DemoSection("单选菜单：原生 Picker 自动勾选", note: "在 Menu 里直接放一个 Picker，系统会自动渲染勾选标记并管理单选状态，不用自己判断——这是最省事的官方写法") {
                    Menu("排序：\(nativeSort)") {
                        Picker("排序方式", selection: $nativeSort) {
                            ForEach(["默认", "名称", "时间"], id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                    }
                }

                // MARK: 选中态菜单（手动勾选）
                DemoSection("单选菜单：手动勾选", note: "如果需要更灵活的控制（比如每项带副标题/图标），也可以用 Button + systemImage: \"checkmark\" 自己判断状态来模拟勾选") {
                    Menu("排序：\(sortOrder)") {
                        ForEach(["默认", "名称", "时间"], id: \.self) { option in
                            Button {
                                sortOrder = option
                            } label: {
                                if sortOrder == option {
                                    Label(option, systemImage: "checkmark")
                                } else {
                                    Text(option)
                                }
                            }
                        }
                    }
                }

                // MARK: menuStyle
                DemoSection(".menuStyle(.button)", note: "默认外观跟随上下文（像普通文字）；.button 样式会渲染成实心按钮外观，可再叠加 .buttonStyle") {
                    Menu("按钮样式菜单") {
                        Button("选项 A", action: {})
                        Button("选项 B", action: {})
                    }
                    .menuStyle(.button)
                    .buttonStyle(.bordered)
                }

                // MARK: 实战
                DemoSection(
                    "实战：图片操作栏",
                    note: "Menu 自定义 label + 嵌套子菜单 + role: .destructive，模拟相册类 App 底部工具栏的「更多操作」按钮"
                ) {
                    HStack(spacing: 28) {
                        Button {
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        Button {
                        } label: {
                            Image(systemName: "heart")
                        }
                        Spacer()
                        Menu {
                            Button {
                            } label: {
                                Label("复制", systemImage: "doc.on.doc")
                            }
                            Button {
                            } label: {
                                Label("收藏", systemImage: "star")
                            }
                            Menu("移动到") {
                                Button("相册 A", action: {})
                                Button("相册 B", action: {})
                            }
                            Button(role: .destructive) {
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                        }
                    }
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .glassSurface(cornerRadius: 16)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Menu")
    }
}

#Preview {
    NavigationStack {
        MenuDemo()
    }
}
