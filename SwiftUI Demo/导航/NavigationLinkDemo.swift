//
//  NavigationLinkDemo.swift
//  SwiftUI Demo
//
//  NavigationLink 组件说明
//  本页自己用 NavigationStack(path:) 包了一层，方便演示编程式 push，
//  这是合法的"嵌套导航栈"写法——外层是 HomeView 的栈，内层是本页自己的栈。
//
//  初始化方式：
//    NavigationLink("标题") { 目标View }        —— 最简单，不需要注册 navigationDestination
//    NavigationLink(destination:label:)         —— label 可放任意 View
//    NavigationLink(value:)                     —— 配合 .navigationDestination(for:) 的值导航
//

import SwiftUI

struct NavigationLinkDemo: View {
    @State private var path: [Int] = []

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // MARK: 基础用法
                    DemoSection("基础用法（直接给 destination）", note: "NavigationLink(\"标题\") { 目标View } —— 最简单的写法，不需要注册 navigationDestination") {
                        NavigationLink("跳转到详情页") {
                            Text("这是直接内联的目标页面")
                                .background(GlassBackground().ignoresSafeArea())
                                .navigationTitle("详情")
                        }
                    }

                    // MARK: 自定义 label
                    DemoSection("自定义 label（@ViewBuilder）", note: "NavigationLink(destination:label:) 的 label 可以放任意 View") {
                        NavigationLink {
                            Text("自定义入口跳转的目标页")
                        } label: {
                            Label("设置", systemImage: "gearshape")
                        }
                    }

                    // MARK: 值导航
                    DemoSection("值导航 NavigationLink(value:)", note: "点击后把 value 推入外层 NavigationStack 的 path，需要配合 .navigationDestination(for:) 才能解析出页面") {
                        NavigationLink("推入数字 1", value: 1)
                    }

                    // MARK: 编程式 push
                    DemoSection("编程式 push（path.append）", note: "value 导航的 path 是普通数组，外部按钮也能直接 append 触发跳转，效果和点击 NavigationLink 完全一样") {
                        Button("用按钮跳转到数字 99") {
                            path.append(99)
                        }
                        .buttonStyle(.bordered)
                    }

                    // MARK: 禁用/样式
                    DemoSection("禁用 / 样式修饰", note: "NavigationLink 也是普通 View，可以叠加 .disabled() / .font() / .foregroundStyle()") {
                        NavigationLink("禁用的链接") {
                            Text("不会跳转到这里")
                        }
                        .disabled(true)
                    }

                    // MARK: 已废弃写法说明
                    DemoSection(
                        "已废弃的旧写法（仅说明，不实现）",
                        note: "NavigationLink(destination:isActive:) 和 NavigationLink(tag:selection:) 从 iOS 16 起被标记为 deprecated，统一改用上面的 value + navigationDestination 写法"
                    ) {
                        Text("旧：NavigationLink(destination: V(), isActive: $bool)\n新：NavigationLink(value: x) + .navigationDestination(for:)")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .navigationDestination(for: Int.self) { number in
                Text("收到的值：\(number)")
                    .navigationTitle("数字 \(number)")
            }
            .navigationTitle("Navigation Link")
        }
    }
}

#Preview {
    NavigationLinkDemo()
}
