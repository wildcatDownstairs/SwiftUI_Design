//
//  SectionDemo.swift
//  SwiftUI Demo
//
//  Section 组件说明
//  Section 本身不能独立显示，必须放进 List / Form 才有意义，负责把内容分组、
//  附加 header/footer，iOS 17 起还支持 isExpanded 绑定做成可折叠分组。
//

import SwiftUI

struct SectionDemo: View {
    @State private var isExpanded = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Section(\"标题\") { 行们 } —— 放进 List 里自动产生一组带标题的分组卡片") {
                    List {
                        Section("水果") {
                            Text("苹果")
                            Text("香蕉")
                        }
                    }
                    .frame(height: 210)
                    .scrollDisabled(true)
                }

                // MARK: header/footer
                DemoSection("header / footer（@ViewBuilder）", note: "两者都支持任意 View，不限于纯文本，常用来放图标说明") {
                    List {
                        Section {
                            Text("接收通知")
                        } header: {
                            Label("偏好设置", systemImage: "bell")
                        } footer: {
                            Text("关闭后仍可在系统设置里单独打开。")
                        }
                    }
                    .frame(height: 250)
                    .scrollDisabled(true)
                }

                // MARK: isExpanded 可折叠
                DemoSection(
                    "isExpanded 可折叠分组（iOS 17+）",
                    note: "Section(\"标题\", isExpanded: $bool) { 行们 } —— 标题行自带展开/收起箭头，效果类似内置的 DisclosureGroup"
                ) {
                    List {
                        Section("高级选项", isExpanded: $isExpanded) {
                            Text("选项 A")
                            Text("选项 B")
                        }
                    }
                    .frame(height: 250)
                }

                // MARK: List vs Form 外观差异
                DemoSection("List vs Form 外观差异", note: "同样的 Section，List 默认贴边铺满；Form 自动套用系统分组卡片间距，二者风格略有不同") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("List 里的 Section").font(.caption).foregroundStyle(.secondary)
                        List {
                            Section("分组") { Text("行内容") }
                        }
                        .frame(minHeight: 100)
                        .scrollDisabled(true)

                        Text("Form 里的 Section").font(.caption).foregroundStyle(.secondary)
                        Form {
                            Section("分组") { Text("行内容") }
                        }
                        .frame(minHeight: 100)
                        .scrollDisabled(true)
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Section")
    }
}

#Preview {
    NavigationStack {
        SectionDemo()
    }
}
