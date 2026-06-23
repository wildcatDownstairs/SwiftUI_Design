//
//  ControlGroupDemo.swift
//  SwiftUI Demo
//
//  ControlGroup 组件说明
//  ControlGroup { 按钮们 } —— 把一组相关操作视觉上"焊"成一个整体，常见于 toolbar、context menu
//  .controlGroupStyle() 控制外观：automatic / compactMenu / menu
//

import SwiftUI

struct ControlGroupDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "ControlGroup { Button... } —— 多个按钮自动拼成一整条分段控件") {
                    ControlGroup {
                        Button("剪切", action: {})
                        Button("复制", action: {})
                        Button("粘贴", action: {})
                    }
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "ControlGroup(content:label:) 的 label 可以放标题，常用于 menu 样式下显示分组名") {
                    ControlGroup {
                        Button("剪切", action: {})
                        Button("复制", action: {})
                    } label: {
                        Text("编辑操作")
                    }
                }

                // MARK: 图标按钮组
                DemoSection("图标按钮组", note: "按钮内容是纯图标时，ControlGroup 会自动渲染成紧凑的分段图标条") {
                    ControlGroup {
                        Button { } label: { Image(systemName: "bold") }
                        Button { } label: { Image(systemName: "italic") }
                        Button { } label: { Image(systemName: "underline") }
                    }
                }

                // MARK: controlGroupStyle 矩阵
                DemoSection(".controlGroupStyle() 矩阵", note: "compactMenu 会收进一个紧凑的菜单按钮；menu 类似但稍大，点击后展开成竖排菜单") {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("automatic（默认）").font(.caption).foregroundStyle(.secondary)
                        ControlGroup {
                            Button("剪切", action: {})
                            Button("复制", action: {})
                            Button("粘贴", action: {})
                        }
                        .controlGroupStyle(.automatic)

                        Text("compactMenu").font(.caption).foregroundStyle(.secondary)
                        ControlGroup {
                            Button("剪切", action: {})
                            Button("复制", action: {})
                            Button("粘贴", action: {})
                        }
                        .controlGroupStyle(.compactMenu)

                        Text("menu").font(.caption).foregroundStyle(.secondary)
                        ControlGroup {
                            Button("剪切", action: {})
                            Button("复制", action: {})
                            Button("粘贴", action: {})
                        }
                        .controlGroupStyle(.menu)

                        Text("navigation").font(.caption).foregroundStyle(.secondary)
                        ControlGroup {
                            Button { } label: { Image(systemName: "chevron.left") }
                            Button { } label: { Image(systemName: "chevron.right") }
                        }
                        .controlGroupStyle(.navigation)
                    }
                }

                // MARK: palette 说明（已知渲染问题）
                DemoSection(
                    ".controlGroupStyle(.palette)（已知问题，未收录可运行示例）",
                    note: "文档说明它存在且应该渲染成图标矩阵，但在当前 SDK/模拟器环境下实测内容完全不显示（空白），换 Button(_:systemImage:action:) 写法也一样，原因未定位，先标注问题不强行演示"
                ) {
                    Text(".controlGroupStyle(.palette)")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                // MARK: 实战
                DemoSection("实战：文本格式工具条", note: "ControlGroup + 纯图标按钮，是文档编辑类 App 工具栏「加粗/斜体/下划线」分组的典型写法") {
                    HStack {
                        Spacer()
                        ControlGroup {
                            Button { } label: { Image(systemName: "bold") }
                            Button { } label: { Image(systemName: "italic") }
                            Button { } label: { Image(systemName: "underline") }
                            Button { } label: { Image(systemName: "strikethrough") }
                        }
                        Spacer()
                    }
                    .padding()
                    .glassSurface(cornerRadius: 16)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Control Group")
    }
}

#Preview {
    NavigationStack {
        ControlGroupDemo()
    }
}
