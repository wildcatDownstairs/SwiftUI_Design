//
//  TextEditorDemo.swift
//  SwiftUI Demo
//
//  TextEditor 组件说明
//  TextEditor(text: $text) —— 多行可编辑文本框，没有内置占位符，需要自己用 ZStack 叠一个 Text 模拟
//

import SwiftUI

struct TextEditorDemo: View {
    @State private var note = ""
    @State private var styledNote = "默认字体太小，改大一点"
    @State private var readonlyNote = "这段内容只能看，不能改"
    @State private var feedback = ""
    @State private var richText = AttributedString("选中文字，用键盘快捷键 ⌘B/⌘I 试试加粗/斜体")

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "TextEditor(text: $text) —— 多行可编辑文本框，自带滚动") {
                    TextEditor(text: $note)
                        .frame(height: 120)
                        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(.gray.opacity(0.3)))
                }

                // MARK: 样式修饰
                DemoSection(".font / .scrollContentBackground(.hidden)", note: "scrollContentBackground 设为 hidden 后可以自己叠加 .background() 自定义底色") {
                    TextEditor(text: $styledNote)
                        .font(.system(.body, design: .rounded))
                        .scrollContentBackground(.hidden)
                        .padding(8)
                        .background(Color.blue.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(height: 100)
                }

                // MARK: 占位符模拟
                DemoSection("占位符（自行实现）", note: "TextEditor 没有 prompt 参数，常见做法是文字为空时在 ZStack 底层叠一个灰色 Text") {
                    ZStack(alignment: .topLeading) {
                        if feedback.isEmpty {
                            Text("说说你的想法…")
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                        TextEditor(text: $feedback)
                            .frame(height: 100)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(.gray.opacity(0.3)))
                }

                // MARK: 禁用/只读
                DemoSection(".disabled()（只读展示）", note: "禁用后内容仍可见可滚动，但无法编辑，常用来展示长篇说明文字") {
                    TextEditor(text: $readonlyNote)
                        .disabled(true)
                        .foregroundStyle(.secondary)
                        .frame(height: 80)
                }

                // MARK: AttributedString 富文本编辑
                DemoSection(
                    "TextEditor(text: AttributedString)（iOS 26+）",
                    note: "绑定 AttributedString 而不是 String，就能获得开箱即用的富文本编辑能力（系统自带加粗/斜体等格式化快捷键和菜单），不需要自己实现富文本逻辑"
                ) {
                    TextEditor(text: $richText)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(.gray.opacity(0.3)))
                }

                // MARK: 字数统计实战
                DemoSection("实战：带字数统计的反馈输入框", note: "TextEditor + 实时字数统计，是「意见反馈」「评论」一类页面的典型组合") {
                    VStack(alignment: .leading, spacing: 4) {
                        TextEditor(text: $feedback)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(.gray.opacity(0.3)))
                        Text("\(feedback.count)/200")
                            .font(.caption2)
                            .foregroundStyle(feedback.count > 200 ? .red : .secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Text Editor")
    }
}

#Preview {
    NavigationStack {
        TextEditorDemo()
    }
}
