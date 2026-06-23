//
//  ScrollViewDemo.swift
//  SwiftUI Demo
//
//  ScrollView 组件说明
//  ScrollView(.vertical/.horizontal) { 内容 } —— 内容超出可视区域时自动支持滚动
//  ScrollViewReader 配合 .id() 可以编程式跳转到指定位置；.refreshable() 提供下拉刷新
//

import SwiftUI

struct ScrollViewDemo: View {
    @State private var refreshCount = 0
    @State private var scrolledID: Int?
    @State private var keyboardText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法（垂直滚动）", note: "ScrollView { 内容 } —— 默认垂直滚动，内容超出屏幕自动支持滚动") {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(1...10, id: \.self) { i in
                                Text("第 \(i) 行")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .frame(height: 140)
                }

                // MARK: 横向滚动
                DemoSection(".horizontal 横向滚动", note: "ScrollView(.horizontal) 配合 HStack 做横向卡片滚动，showsIndicators: false 隐藏滚动条") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(["红", "橙", "黄", "绿", "蓝", "紫"], id: \.self) { name in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.blue.opacity(0.2))
                                    .frame(width: 80, height: 60)
                                    .overlay(Text(name))
                            }
                        }
                    }
                }

                // MARK: ScrollViewReader
                DemoSection("ScrollViewReader + scrollTo", note: "包一层 ScrollViewReader 拿到 proxy，调用 proxy.scrollTo(id, anchor:) 编程式跳转到指定位置") {
                    ScrollViewReader { proxy in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Button("跳到第 1 行") { withAnimation { proxy.scrollTo(1, anchor: .top) } }
                                Button("跳到第 20 行") { withAnimation { proxy.scrollTo(20, anchor: .top) } }
                            }
                            .buttonStyle(.bordered)
                            .font(.caption)

                            ScrollView {
                                VStack(spacing: 8) {
                                    ForEach(1...20, id: \.self) { i in
                                        Text("第 \(i) 行")
                                            .id(i)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .frame(height: 140)
                        }
                    }
                }

                // MARK: refreshable
                DemoSection(".refreshable()", note: "加在 ScrollView/List 上即可获得下拉刷新手势，闭包是 async，下拉后系统显示加载圈直到闭包执行完") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("下拉刷新次数：\(refreshCount)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ScrollView {
                            Text("下拉我试试")
                                .padding()
                        }
                        .frame(height: 100)
                        .refreshable {
                            try? await Task.sleep(for: .seconds(1))
                            refreshCount += 1
                        }
                    }
                }

                // MARK: scrollIndicators
                DemoSection(".scrollIndicators()", note: "现代写法，替代旧的 showsIndicators: 参数：.hidden 隐藏滚动条、.visible 强制显示、.automatic 跟随系统") {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(1...10, id: \.self) { i in
                                Text("第 \(i) 行").frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .frame(height: 100)
                    .scrollIndicators(.hidden)
                }

                // MARK: scrollPosition
                DemoSection(
                    ".scrollPosition(id:)（iOS 17+）",
                    note: "绑定一个 id，可以读取「当前滚动到了哪一项」，也可以反过来赋值编程式跳转——和 ScrollViewReader 的区别是它是声明式的状态绑定，不需要 proxy"
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("当前位置：第 \(scrolledID ?? 0) 行")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(1...20, id: \.self) { i in
                                    Text("第 \(i) 行")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .id(i)
                                }
                            }
                        }
                        .frame(height: 140)
                        .scrollPosition(id: $scrolledID)
                    }
                }

                // MARK: scrollDismissesKeyboard
                DemoSection(
                    ".scrollDismissesKeyboard()",
                    note: "控制滚动时键盘的收起行为：.interactively 跟手下拉收起；.immediately 一开始滚动就立刻收起；.automatic 跟随上下文"
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("点这里弹出键盘，再滚动下面试试", text: $keyboardText)
                            .textFieldStyle(.roundedBorder)
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(1...10, id: \.self) { i in
                                    Text("第 \(i) 行").frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .frame(height: 100)
                        .scrollDismissesKeyboard(.interactively)
                    }
                }

                // MARK: 双轴滚动
                DemoSection(
                    "双轴滚动 ScrollView([.horizontal, .vertical])",
                    note: "传入数组同时开启横向和纵向滚动，常用于看大尺寸表格/地图这类内容"
                ) {
                    ScrollView([.horizontal, .vertical]) {
                        Grid {
                            ForEach(0..<6, id: \.self) { row in
                                GridRow {
                                    ForEach(0..<6, id: \.self) { col in
                                        Text("\(row),\(col)")
                                            .frame(width: 60, height: 40)
                                            .background(.indigo.opacity(0.15))
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 150)
                }

                // MARK: LazyVStack
                DemoSection("LazyVStack 性能提示", note: "ScrollView 默认的 VStack 会一次性创建所有子视图；数据量大时改用 LazyVStack，子视图只在即将可见时才创建") {
                    Text("VStack { ... }      —— 立即创建全部子视图\nLazyVStack { ... }  —— 按需创建，列表很长时更省内存")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Scroll View")
    }
}

#Preview {
    NavigationStack {
        ScrollViewDemo()
    }
}
