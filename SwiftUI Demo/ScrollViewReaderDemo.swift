//
//  ScrollViewReaderDemo.swift
//  SwiftUI Demo
//
//  ScrollViewReader 组件说明
//  ScrollViewReader { proxy in ... } —— 包一层就能拿到 proxy，调用 proxy.scrollTo(id, anchor:)
//  编程式跳转到指定位置；目标视图需要先用 .id() 打标记。
//  ScrollViewDemo.swift 里也有一个基础示例，这里展开讲 anchor 矩阵和更完整的实战场景。
//

import SwiftUI

struct ScrollViewReaderDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "proxy.scrollTo(id) —— id 要和目标视图的 .id() 对应") {
                    ScrollViewReader { proxy in
                        VStack {
                            Button("跳到第 10 行") {
                                withAnimation { proxy.scrollTo(10) }
                            }
                            .buttonStyle(.bordered)

                            ScrollView {
                                VStack(spacing: 8) {
                                    ForEach(0..<20, id: \.self) { i in
                                        Text("第 \(i) 行")
                                            .id(i)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .frame(height: 150)
                        }
                    }
                }

                // MARK: anchor 矩阵
                DemoSection(
                    "anchor 参数矩阵",
                    note: "anchor 决定目标视图滚动到容器的哪个位置：.top 贴顶；.center 居中；.bottom 贴底，不传则系统自动选择最小滚动距离的位置"
                ) {
                    ScrollViewReader { proxy in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Button("anchor: .top") { withAnimation { proxy.scrollTo(15, anchor: .top) } }
                                Button("anchor: .center") { withAnimation { proxy.scrollTo(15, anchor: .center) } }
                                Button("anchor: .bottom") { withAnimation { proxy.scrollTo(15, anchor: .bottom) } }
                            }
                            .font(.caption2)
                            .buttonStyle(.bordered)

                            ScrollView {
                                VStack(spacing: 8) {
                                    ForEach(0..<30, id: \.self) { i in
                                        Text("第 \(i) 行" + (i == 15 ? "  ⬅️ 目标" : ""))
                                            .id(i)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .frame(height: 150)
                        }
                    }
                }

                // MARK: 配合 List
                DemoSection("配合 List 使用", note: "List 本身也是滚动容器，ScrollViewReader 同样适用，不需要额外包一层 ScrollView") {
                    ScrollViewReader { proxy in
                        VStack {
                            Button("跳到「葡萄」") {
                                withAnimation { proxy.scrollTo("葡萄", anchor: .center) }
                            }
                            .buttonStyle(.bordered)

                            List(["苹果", "香蕉", "橙子", "葡萄", "西瓜", "芒果", "草莓"], id: \.self) { fruit in
                                Text(fruit).id(fruit)
                            }
                            .frame(height: 180)
                        }
                    }
                }

                // MARK: 实战
                DemoSection(
                    "实战：聊天界面「跳到最新消息」",
                    note: "新消息追加后自动滚到底部，是聊天类 App 的标准交互——.onChange(of: messages.count) 配合 scrollTo 实现"
                ) {
                    ChatJumpToBottomExample()
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Scroll View Reader")
    }
}

private struct ChatJumpToBottomExample: View {
    @State private var messages = ["你好", "在吗", "项目进度怎么样了"]

    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 8) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(messages.enumerated()), id: \.offset) { index, message in
                            Text(message)
                                .padding(8)
                                .background(.blue.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .id(index)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 140)

                Button("发一条新消息") {
                    messages.append("新消息 \(messages.count)")
                    withAnimation {
                        proxy.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScrollViewReaderDemo()
    }
}
