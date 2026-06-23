//
//  GroupBoxDemo.swift
//  SwiftUI Demo
//
//  GroupBox 组件说明
//  初始化方式：
//    GroupBox { 内容 }                 —— 不带标题
//    GroupBox("标题") { 内容 }          —— 字符串标题简写
//    GroupBox(label:content:)          —— label 可放任意 View（@ViewBuilder）
//  .groupBoxStyle() 可以通过实现 GroupBoxStyle 协议完全重写外观
//

import SwiftUI

/// 自定义 GroupBoxStyle：带强调色边框的高亮卡片
struct TintedGroupBoxStyle: GroupBoxStyle {
    var tint: Color = .blue

    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            configuration.label
                .font(.headline)
                .foregroundStyle(tint)
            configuration.content
        }
        .padding()
        .background(tint.opacity(0.08))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(tint.opacity(0.4), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct GroupBoxDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "GroupBox { 内容 } —— 不带标题，系统自动加圆角背景框") {
                    GroupBox {
                        Text("这是一段被框起来的内容")
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: 带标题
                DemoSection("带标题", note: "GroupBox(\"标题\") { 内容 } —— 字符串简写，标题显示在框的顶部") {
                    GroupBox("今日天气") {
                        Text("晴，26℃")
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "GroupBox(label:content:) 的 label 可以放图标 + 文字组合") {
                    GroupBox {
                        Text("已连接 Wi-Fi：HomeNetwork")
                            .foregroundStyle(.secondary)
                    } label: {
                        Label("网络", systemImage: "wifi")
                    }
                }

                // MARK: 嵌套
                DemoSection("嵌套 GroupBox", note: "GroupBox 内部可以再放一个 GroupBox，做出分层卡片效果") {
                    GroupBox("父级分组") {
                        GroupBox("子级分组") {
                            Text("嵌套内容")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // MARK: 自定义样式
                DemoSection("自定义 GroupBoxStyle", note: "实现 GroupBoxStyle 协议可以完全重写外观，这里做了一个带边框的高亮卡片") {
                    GroupBox("自定义样式") {
                        Text("用 TintedGroupBoxStyle 渲染")
                            .foregroundStyle(.secondary)
                    }
                    .groupBoxStyle(TintedGroupBoxStyle(tint: .orange))
                }

                // MARK: 放进 Form
                DemoSection("放进 Form", note: "GroupBox 也可以直接放进 Form，常用来在设置页里突出某一块说明文字") {
                    Form {
                        GroupBox("提示") {
                            Text("修改此设置需要重启 App 才能生效。")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 120)
                    .scrollDisabled(true)
                }

                // MARK: 实战
                DemoSection(
                    "实战：设备状态卡片",
                    note: "自定义 GroupBoxStyle + LabeledContent + Gauge 组合，是设置页里常见的「状态汇总」卡片写法"
                ) {
                    GroupBox {
                        VStack(spacing: 10) {
                            LabeledContent("Wi-Fi") {
                                Label("HomeNetwork", systemImage: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                            Divider()
                            LabeledContent("蓝牙") {
                                Label("已连接 AirPods", systemImage: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                            Divider()
                            LabeledContent("电量") {
                                Gauge(value: 0.62, in: 0...1) { Text("") }
                                    .gaugeStyle(.accessoryLinearCapacity)
                                    .frame(width: 80)
                            }
                        }
                    } label: {
                        Label("设备状态", systemImage: "antenna.radiowaves.left.and.right")
                            .font(.headline)
                    }
                    .groupBoxStyle(TintedGroupBoxStyle(tint: .blue))
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Group Box")
    }
}

#Preview {
    NavigationStack {
        GroupBoxDemo()
    }
}
