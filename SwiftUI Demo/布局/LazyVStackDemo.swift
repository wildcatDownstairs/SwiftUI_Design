//
//  LazyVStackDemo.swift
//  SwiftUI Demo
//
//  LazyVStack 组件说明
//  排列方式和 VStack 一样，区别是子视图只在即将进入可见区域时才创建——
//  长列表应该用 LazyVStack 而不是 VStack，这也是 List 内部的实现原理
//

import SwiftUI

struct LazyVStackDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "LazyVStack { ... } 放进 ScrollView(.vertical)（默认方向），排列效果和 VStack 完全一样") {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(0..<6, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.blue.opacity(0.2))
                                    .frame(height: 44)
                                    .overlay(Text("第 \(index) 行"))
                            }
                        }
                    }
                    .frame(height: 220)
                }

                // MARK: 和 VStack 的区别
                DemoSection(
                    "和 VStack 的核心区别：懒加载",
                    note: "VStack 会一次性创建全部子视图；LazyVStack 只创建当前可见 + 即将可见的部分，是 List 内部实现长列表性能的原理"
                ) {
                    Text("VStack { ... }      —— 1000 行数据，立即创建 1000 个 View\nLazyVStack { ... }  —— 1000 行数据，屏幕能容纳几行就先创建几行")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                // MARK: Section 吸顶
                DemoSection(
                    "配合 Section 做纵向吸顶分组",
                    note: "LazyVStack 可以包 Section，pinnedViews 是 LazyVStack 自己的初始化参数（不是 ScrollView 的），传 [.sectionHeaders] 让分组标题纵向滚动时吸附在顶部，效果类似 List 的 Section header"
                ) {
                    ScrollView {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            ForEach(["A", "B"], id: \.self) { letter in
                                Section {
                                    ForEach(0..<3, id: \.self) { i in
                                        Text("\(letter) 组 - 第 \(i) 项")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                    }
                                } header: {
                                    Text("分组 \(letter)")
                                        .font(.caption.bold())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                        .background(Color(uiColor: .systemBackground))
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Lazy Vertical Stack")
    }
}

#Preview {
    NavigationStack {
        LazyVStackDemo()
    }
}
