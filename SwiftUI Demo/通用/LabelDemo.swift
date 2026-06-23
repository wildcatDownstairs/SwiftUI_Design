//
//  LabelDemo.swift
//  SwiftUI Demo
//
//  Label 组件说明
//  初始化方式：
//    Label("标题", systemImage: "star")  —— 最常用的字符串 + 系统符号简写
//    Label(title:icon:)                  —— title / icon 都可放任意 View（@ViewBuilder）
//  .labelStyle() 控制图标/文字的取舍与排布：iconOnly / titleOnly / titleAndIcon（默认）/ 自定义
//

import SwiftUI

struct LabelDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Label(\"标题\", systemImage: \"star\") —— 图标 + 文字的标准组合，系统自动处理间距和基线对齐") {
                    Label("收藏", systemImage: "star.fill")
                }

                // MARK: title/icon 自定义
                DemoSection("Label(title:icon:)（@ViewBuilder）", note: "title 和 icon 都可以放任意 View，不限于纯文本/系统符号") {
                    Label {
                        Text("自定义内容")
                            .fontWeight(.semibold)
                    } icon: {
                        Circle()
                            .fill(.purple)
                            .frame(width: 20, height: 20)
                    }
                }

                // MARK: labelStyle 矩阵
                DemoSection(".labelStyle() 样式矩阵", note: "iconOnly 只显示图标；titleOnly 只显示文字；titleAndIcon（默认）两者都显示") {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("titleAndIcon（默认）", systemImage: "bell.fill")
                            .labelStyle(.titleAndIcon)
                        Label("iconOnly", systemImage: "bell.fill")
                            .labelStyle(.iconOnly)
                        Label("titleOnly", systemImage: "bell.fill")
                            .labelStyle(.titleOnly)
                    }
                }

                // MARK: 自定义 LabelStyle
                DemoSection("自定义 LabelStyle", note: "实现 LabelStyle 协议可以重排图标和文字的位置，这里复用了 ButtonDemo 里定义的 trailingIcon（图标放文字后面）") {
                    Label("图标在后面", systemImage: "chevron.right")
                        .labelStyle(.trailingIcon)
                }

                // MARK: 颜色与字号
                DemoSection("颜色与字号", note: "直接对 Label 整体应用 .foregroundStyle/.font 时图标和文字会同步变化；若要分别设置，用上面 Label(title:icon:) 的 builder 初始化方式，在各自闭包里单独加修饰符") {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("橙色大号", systemImage: "flame.fill")
                            .font(.title2)
                            .foregroundStyle(.orange)
                        Label("灰色小号", systemImage: "flame.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: 放进 List
                DemoSection("放进 List", note: "Label 是 List 行最常见的写法，图标会自动对齐到系统统一的缩进规则，比手动拼 HStack 更省心") {
                    List {
                        Label("通用", systemImage: "gearshape")
                        Label("通知", systemImage: "bell")
                        Label("隐私", systemImage: "hand.raised")
                    }
                    .frame(minHeight: 160)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Label")
    }
}

#Preview {
    NavigationStack {
        LabelDemo()
    }
}
