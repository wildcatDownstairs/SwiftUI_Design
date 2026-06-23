//
//  PickerDemo.swift
//  SwiftUI Demo
//
//  Picker 组件说明
//  初始化：Picker("标题", selection: $value) { 选项们 } —— 选项用 .tag() 标记对应的值
//  .pickerStyle() 控制外观：automatic / segmented / wheel / menu / inline
//

import SwiftUI

private enum Flavor: String, CaseIterable, Identifiable {
    case vanilla = "香草", chocolate = "巧克力", strawberry = "草莓"
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .vanilla: "snowflake"
        case .chocolate: "circle.fill"
        case .strawberry: "heart.fill"
        }
    }
}

struct PickerDemo: View {
    @State private var flavor: Flavor = .vanilla
    @State private var styleDemo: Flavor = .vanilla
    @State private var inlineDemo: Flavor = .vanilla

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法（枚举 selection）", note: "Picker(\"标题\", selection: $value) { Text().tag(枚举值) } —— selection 通常绑定一个遵循 Hashable 的枚举") {
                    Picker("口味", selection: $flavor) {
                        ForEach(Flavor.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    Text("当前选择：\(flavor.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // MARK: pickerStyle 矩阵
                DemoSection(".pickerStyle() 样式矩阵", note: "segmented 适合 2-4 个选项；wheel 经典滚轮；menu 省空间下拉") {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("segmented").font(.caption).foregroundStyle(.secondary)
                        Picker("口味", selection: $styleDemo) {
                            ForEach(Flavor.allCases) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.segmented)

                        Text("menu").font(.caption).foregroundStyle(.secondary)
                        Picker("口味", selection: $styleDemo) {
                            ForEach(Flavor.allCases) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.menu)

                        Text("wheel").font(.caption).foregroundStyle(.secondary)
                        Picker("口味", selection: $styleDemo) {
                            ForEach(Flavor.allCases) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxHeight: 100)
                        .clipped()

                        Text("navigationLink").font(.caption).foregroundStyle(.secondary)
                        Picker("口味", selection: $styleDemo) {
                            ForEach(Flavor.allCases) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.navigationLink)

                        Text("palette（图标矩阵）").font(.caption).foregroundStyle(.secondary)
                        Picker("口味", selection: $styleDemo) {
                            ForEach(Flavor.allCases) { flavor in
                                Image(systemName: flavor.icon).tag(flavor)
                            }
                        }
                        .pickerStyle(.palette)
                    }
                }

                // MARK: inline 放进 List
                DemoSection(".pickerStyle(.inline) 放进 List", note: "inline 样式会把选项直接平铺展开成 List 行，而不是弹出/滚轮，常见于设置页") {
                    List {
                        Picker("口味", selection: $inlineDemo) {
                            ForEach(Flavor.allCases) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.inline)
                    }
                    .frame(height: 240)
                    .scrollDisabled(true)
                }

                // MARK: labelsHidden
                DemoSection(".labelsHidden()", note: "隐藏标签文字，segmented 风格下常这样用，靠上下文就能看懂含义") {
                    Picker("口味", selection: $flavor) {
                        ForEach(Flavor.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }

                // MARK: 禁用
                DemoSection(".disabled()", note: "禁用后整体变灰且不可交互") {
                    Picker("口味", selection: $flavor) {
                        ForEach(Flavor.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .disabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Picker")
    }
}

#Preview {
    NavigationStack {
        PickerDemo()
    }
}
