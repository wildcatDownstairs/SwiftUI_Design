//
//  LabeledContentDemo.swift
//  SwiftUI Demo
//
//  LabeledContent 组件说明
//  初始化方式：
//    LabeledContent("标题", value: "内容")     —— 左标题、右内容，最常见的只读信息行
//    LabeledContent("标题") { 内容 }           —— content 用 @ViewBuilder，可放任意 View
//    LabeledContent(content:label:)           —— label 也用 @ViewBuilder
//  .labeledContentStyle() 可以通过实现 LabeledContentStyle 协议重排布局
//

import SwiftUI

/// 自定义 LabeledContentStyle：把 label/content 从左右两端对齐改成上下堆叠
struct StackedLabeledContentStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            configuration.label
                .font(.caption)
                .foregroundStyle(.secondary)
            configuration.content
        }
    }
}

struct LabeledContentDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "LabeledContent(\"标题\", value: \"内容\") —— 左边标题、右边数值，最常见的只读信息行") {
                    LabeledContent("用户名", value: "Tom")
                }

                // MARK: content 自定义
                DemoSection("content 用 @ViewBuilder", note: "LabeledContent(\"标题\") { 内容 } —— 右侧内容可以放任意 View，不限于字符串") {
                    LabeledContent("头像") {
                        Circle()
                            .fill(.blue)
                            .frame(width: 28, height: 28)
                    }
                }

                // MARK: label 也自定义
                DemoSection("label 也用 @ViewBuilder", note: "LabeledContent(content:label:) —— 左右两侧都能自定义，label 可以放图标") {
                    LabeledContent {
                        Text("已连接")
                            .foregroundStyle(.green)
                    } label: {
                        Label("Wi-Fi", systemImage: "wifi")
                    }
                }

                // MARK: 放进 Form
                DemoSection("放进 Form / List", note: "LabeledContent 最常见的真实场景就是设置页里的只读信息行，和 Form 天生契合") {
                    Form {
                        LabeledContent("版本号", value: "1.4.2")
                        LabeledContent("设备型号", value: "iPhone 17 Pro")
                    }
                    .frame(minHeight: 120)
                    .scrollDisabled(true)
                }

                // MARK: labelsHidden
                DemoSection(".labelsHidden()", note: "隐藏左侧标题，只保留右侧内容，使用场景较少但确实支持") {
                    LabeledContent("隐藏的标签", value: "仍然可见的内容")
                        .labelsHidden()
                }

                // MARK: 自定义样式
                DemoSection("自定义 LabeledContentStyle", note: "实现 LabeledContentStyle 协议可以重排 label/content 的布局，这里改成了上下堆叠") {
                    LabeledContent("地址", value: "上海市浦东新区")
                        .labeledContentStyle(StackedLabeledContentStyle())
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Labeled Content")
    }
}

#Preview {
    NavigationStack {
        LabeledContentDemo()
    }
}
