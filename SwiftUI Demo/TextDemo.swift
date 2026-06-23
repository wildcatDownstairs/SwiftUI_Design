//
//  TextDemo.swift
//  SwiftUI Demo
//
//  Text 组件说明
//  Text("...") —— 最基础的文字展示，支持 Markdown、富文本拼接、日期/时长自动格式化
//

import SwiftUI

struct TextDemo: View {
    private var attributedExample: AttributedString {
        var result = AttributedString("这一段是普通文字，")
        var highlighted = AttributedString("这一段是高亮文字")
        highlighted.foregroundColor = .orange
        highlighted.font = .body.bold()
        result.append(highlighted)
        return result
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Text(\"...\") —— 最基础的文字展示") {
                    Text("Hello, SwiftUI")
                }

                // MARK: Markdown
                DemoSection("Markdown 支持（自动解析）", note: "字符串字面量里的 **粗体**、_斜体_、`代码`、[链接](url) 会被自动识别渲染，不需要额外 API") {
                    Text("这是 **粗体**、_斜体_、`代码` 和 [链接](https://www.apple.com)")
                }

                // MARK: 富文本拼接
                DemoSection("富文本拼接（+ 运算符）", note: "多个 Text 用 + 拼接成一个整体，每段可以有自己的样式，常用于「价格前缀+大字号数字+单位」这类混排") {
                    Text("¥").font(.body)
                        + Text("99").font(.largeTitle).fontWeight(.bold)
                        + Text(" /月").font(.caption).foregroundStyle(.secondary)
                }

                // MARK: 样式修饰
                DemoSection("常见样式修饰", note: ".font / .fontWeight / .italic / .underline / .strikethrough 可以自由组合") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("斜体").italic()
                        Text("下划线").underline()
                        Text("删除线").strikethrough()
                        Text("渐变色文字")
                            .font(.title3.bold())
                            .foregroundStyle(
                                LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
                            )
                    }
                }

                // MARK: lineLimit
                DemoSection(".lineLimit() / .truncationMode()", note: "超出行数限制时，默认用省略号截断，truncationMode 可以改成头部/中间截断") {
                    Text("这是一段很长很长很长很长很长很长很长很长很长很长很长的文字，用来演示行数限制效果。")
                        .lineLimit(1)
                        .truncationMode(.tail)
                }

                // MARK: 日期格式化
                DemoSection("日期/时长自动格式化", note: "Text(date, style:) 可以自动显示相对时间或倒计时，且会随时间自动刷新，不需要自己写 Timer") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(Date(), style: .relative)
                        Text(Date().addingTimeInterval(60), style: .timer)
                        Text(Date(), style: .date)
                    }
                    .foregroundStyle(.secondary)
                }

                // MARK: 多行对齐
                DemoSection(".multilineTextAlignment()", note: "控制多行文字内部的对齐方式（leading/center/trailing），不是控制整个 Text 在父容器里的位置") {
                    Text("第一行较短\n第二行会长一些用来体现对齐效果")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }

                // MARK: verbatim
                DemoSection(
                    "Text(verbatim:)",
                    note: "verbatim 初始化会把字符串当成纯文本原样显示，不会被当成 Markdown 或本地化 key 解析，星号、下划线等符号不会触发任何格式化"
                ) {
                    Text(verbatim: "这段 **不会** 被解析成粗体，原样显示")
                }

                // MARK: format
                DemoSection(
                    "Text(_:format:)",
                    note: "传入 FormatStyle 可以直接把数字/日期格式化成本地化文案，不需要先手动拼字符串，常见的有 .currency / .percent"
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(99.9, format: .currency(code: "CNY"))
                        Text(0.856, format: .percent.precision(.fractionLength(1)))
                        Text(Date(), format: .dateTime.year().month().day())
                    }
                }

                // MARK: timerInterval
                DemoSection(
                    "Text(timerInterval:countsDown:)",
                    note: "声明一个时间区间，系统自动逐秒刷新显示剩余/经过时间，不需要自己写 Timer 驱动 @State 更新"
                ) {
                    Text(timerInterval: Date()...Date().addingTimeInterval(60), countsDown: true)
                        .font(.title2.monospacedDigit())
                }

                // MARK: AttributedString
                DemoSection(
                    "Text(AttributedString)",
                    note: "AttributedString 可以对字符串里某一段单独设置颜色/字重/链接等属性，比 Markdown 字面量更精细可控，常用于从富文本数据源渲染内容"
                ) {
                    Text(attributedExample)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Text")
    }
}

#Preview {
    NavigationStack {
        TextDemo()
    }
}
