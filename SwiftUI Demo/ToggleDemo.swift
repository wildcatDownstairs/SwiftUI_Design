//
//  ToggleDemo.swift
//  SwiftUI Demo
//
//  Toggle 组件说明
//  Toggle("标题", isOn: $bool) —— 开关控件，.toggleStyle() 控制外观：switch（默认）/ button / 自定义
//

import SwiftUI

/// 自定义 ToggleStyle：用图标 + 颜色变化模拟「收藏」效果，而不是标准开关
struct HeartToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label(
                configuration.isOn ? "已收藏" : "收藏",
                systemImage: configuration.isOn ? "heart.fill" : "heart"
            )
            .foregroundStyle(configuration.isOn ? .red : .secondary)
        }
    }
}

struct ToggleDemo: View {
    @State private var notificationsOn = true
    @State private var wifiOn = false
    @State private var isFavorited = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Toggle(\"标题\", isOn: $bool) —— 默认渲染成系统开关样式") {
                    Toggle("接收通知", isOn: $notificationsOn)
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "Toggle(isOn:label:) 的 label 可以放图标 + 文字组合") {
                    Toggle(isOn: $wifiOn) {
                        Label("Wi-Fi", systemImage: "wifi")
                    }
                }

                // MARK: toggleStyle 矩阵
                DemoSection(".toggleStyle() 矩阵", note: "switch（默认）是开关样式；button 渲染成可点击的按钮样式，常用于工具栏") {
                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("switch（默认）", isOn: $notificationsOn)
                            .toggleStyle(.switch)
                        Toggle("button", isOn: $notificationsOn)
                            .toggleStyle(.button)
                    }
                }

                // MARK: 自定义 ToggleStyle
                DemoSection("自定义 ToggleStyle", note: "实现 ToggleStyle 协议可以完全重写交互外观，这里做了一个「收藏」效果的开关") {
                    Toggle("收藏", isOn: $isFavorited)
                        .toggleStyle(HeartToggleStyle())
                        .labelsHidden()
                }

                // MARK: tint
                DemoSection(".tint()", note: "改变开关打开状态时的颜色") {
                    Toggle("橙色开关", isOn: $notificationsOn)
                        .tint(.orange)
                }

                // MARK: 放进 Form
                DemoSection("放进 Form", note: "Toggle 是设置页最常见的控件，每行一个开关") {
                    Form {
                        Toggle("接收通知", isOn: $notificationsOn)
                        Toggle("Wi-Fi", isOn: $wifiOn)
                    }
                    .frame(height: 170)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Toggle")
    }
}

#Preview {
    NavigationStack {
        ToggleDemo()
    }
}
