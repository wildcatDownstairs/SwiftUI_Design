//
//  LazyHStackDemo.swift
//  SwiftUI Demo
//
//  LazyHStack 组件说明
//  和 HStack 排列方式一样，区别是子视图只在即将进入可见区域时才创建——
//  数据量很大的横向滚动列表应该用 LazyHStack 而不是 HStack，避免一次性创建几百个视图
//

import SwiftUI

struct LazyHStackDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "LazyHStack { ... } 放进 ScrollView(.horizontal)，排列效果和 HStack 完全一样") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            ForEach(0..<30, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.blue.opacity(0.2))
                                    .frame(width: 70, height: 70)
                                    .overlay(Text("\(index)"))
                            }
                        }
                    }
                }

                // MARK: 和 HStack 的区别
                DemoSection(
                    "和 HStack 的核心区别：懒加载",
                    note: "HStack 会一次性创建全部子视图（哪怕大部分都在屏幕外看不见）；LazyHStack 只创建当前可见 + 即将可见的部分，数据量大时内存和启动速度差异明显"
                ) {
                    Text("30 个方块用 HStack：立即创建 30 个 View\n30 个方块用 LazyHStack：屏幕能容纳几个就先创建几个")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                // MARK: pinnedViews
                DemoSection(
                    "配合 Section 做横向吸顶分组",
                    note: "LazyHStack 可以包 Section，pinnedViews 是 LazyHStack 自己的初始化参数（不是 ScrollView 的），传 [.sectionHeaders] 让分组标题横向滚动时保持吸附"
                ) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .top, spacing: 0, pinnedViews: [.sectionHeaders]) {
                            Section {
                                ForEach(0..<5, id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.green.opacity(0.2))
                                        .frame(width: 60, height: 60)
                                        .overlay(Text("A\(i)"))
                                        .padding(.horizontal, 4)
                                }
                            } header: {
                                Text("A组")
                                    .font(.caption)
                                    .padding(6)
                                    .background(Color(uiColor: .systemBackground))
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Lazy Horizontal Stack")
    }
}

#Preview {
    NavigationStack {
        LazyHStackDemo()
    }
}
