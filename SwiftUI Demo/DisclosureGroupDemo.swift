//
//  DisclosureGroupDemo.swift
//  SwiftUI Demo
//
//  DisclosureGroup 组件说明
//  初始化方式：
//    DisclosureGroup("标题") { 内容 }                         —— 自管理展开状态
//    DisclosureGroup("标题", isExpanded: $bool) { 内容 }       —— 外部可控展开状态
//    DisclosureGroup(isExpanded:content:label:)               —— label 可放任意 View（@ViewBuilder）
//

import SwiftUI

struct DisclosureGroupDemo: View {
    @State private var isExpanded = false
    @State private var networkExpanded = true
    @State private var childExpanded = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法（自管理状态）", note: "不传 isExpanded 时，展开状态由组件自己管理，每次点击标题切换") {
                    DisclosureGroup("查看详情") {
                        Text("这里是展开后才显示的内容，默认收起。")
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: isExpanded 绑定
                DemoSection("isExpanded 绑定（外部可控）", note: "传入 Binding<Bool> 后，可以从外部按钮编程式展开/收起") {
                    VStack(alignment: .leading, spacing: 10) {
                        DisclosureGroup("受控的折叠面板", isExpanded: $isExpanded) {
                            Text("展开状态：\(isExpanded ? "已展开" : "已收起")")
                                .foregroundStyle(.secondary)
                        }
                        Button(isExpanded ? "收起" : "展开") {
                            withAnimation { isExpanded.toggle() }
                        }
                        .buttonStyle(.bordered)
                    }
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "DisclosureGroup(isExpanded:content:label:) 的 label 可以放图标 + 文字") {
                    DisclosureGroup(isExpanded: $networkExpanded) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Wi-Fi：已连接")
                            Text("蓝牙：已开启")
                        }
                        .foregroundStyle(.secondary)
                    } label: {
                        Label("网络状态", systemImage: "wifi")
                    }
                }

                // MARK: 嵌套
                DemoSection("嵌套折叠面板", note: "DisclosureGroup 内部可以再放一个 DisclosureGroup，组成树状层级结构") {
                    DisclosureGroup("一级菜单") {
                        DisclosureGroup("二级菜单", isExpanded: $childExpanded) {
                            Text("三级内容")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // MARK: 放进 Form
                DemoSection("放进 Form", note: "在 Form 里会自动套用系统分组样式，是设置页常见的折叠详情写法") {
                    Form {
                        DisclosureGroup("高级选项") {
                            Text("额外的配置项")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 160)
                }

                // MARK: 多个并存
                DemoSection("多个面板并存", note: "DisclosureGroup 之间互相独立，可以同时展开，没有手风琴（accordion）互斥效果") {
                    VStack(alignment: .leading, spacing: 10) {
                        DisclosureGroup("面板 A") { Text("A 的内容").foregroundStyle(.secondary) }
                        DisclosureGroup("面板 B") { Text("B 的内容").foregroundStyle(.secondary) }
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Disclosure Group")
    }
}

#Preview {
    NavigationStack {
        DisclosureGroupDemo()
    }
}
