//
//  ListComponentDemo.swift
//  SwiftUI Demo
//
//  List 组件说明（与项目里已有的 ListDemo.swift / ListViewDemo.swift 练习文件无关，
//  那两个是布局练习，这个文件专门讲 List 组件本身的 API）
//  .listStyle() 控制外观：plain / grouped / insetGrouped / sidebar / automatic
//  .swipeActions() 滑动操作；.searchable() 搜索框；selection 单选/多选
//

import SwiftUI

private struct Order: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let status: String
    let icon: String
    let color: Color
}

private let sampleOrders: [Order] = [
    Order(title: "无线降噪耳机", subtitle: "订单号 #20260601", status: "已发货", icon: "headphones", color: .blue),
    Order(title: "机械键盘", subtitle: "订单号 #20260528", status: "待付款", icon: "keyboard", color: .orange),
    Order(title: "智能手表", subtitle: "订单号 #20260512", status: "已完成", icon: "applewatch", color: .green),
]

struct ListComponentDemo: View {
    @State private var items = ["苹果", "香蕉", "橙子", "葡萄", "西瓜"]
    @State private var searchText = ""
    @State private var selection: String?
    @State private var multiSelection = Set<String>()
    @State private var refreshCount = 0

    // 样式矩阵用的精简数据：5 条会让每个样式预览都很高、整页太长，3 条足够看清样式差异
    private let styleItems = ["苹果", "香蕉", "橙子"]

    private var filteredItems: [String] {
        searchText.isEmpty ? items : items.filter { $0.contains(searchText) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "List(数组, id:) { ... } —— 最简单的列表，自带滚动能力") {
                    List(items, id: \.self) { item in
                        Text(item)
                    }
                    .frame(height: 320)
                    .scrollDisabled(true)
                }

                // MARK: Section
                DemoSection("Section 分组 + footer", note: "和 Form 一样支持 Section，可以分组展示不同类别的数据") {
                    List {
                        Section {
                            ForEach(items, id: \.self) { Text($0) }
                        } header: {
                            Text("水果")
                        } footer: {
                            Text("共 \(items.count) 种水果")
                        }
                    }
                    .frame(height: 380)
                    .scrollDisabled(true)
                }

                // MARK: listStyle 矩阵
                DemoSection(
                    ".listStyle() 样式矩阵",
                    note: "automatic 跟随平台默认；plain 最朴素；grouped 经典分组（无圆角卡片）；insetGrouped 卡片化分组；sidebar 常用于 NavigationSplitView 的侧边栏"
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("automatic").font(.caption).foregroundStyle(.secondary)
                        List(styleItems, id: \.self) { Text($0) }
                            .listStyle(.automatic)
                            .frame(height: 220)
                            .scrollDisabled(true)

                        Text("plain").font(.caption).foregroundStyle(.secondary)
                        List(styleItems, id: \.self) { Text($0) }
                            .listStyle(.plain)
                            .frame(height: 160)
                            .scrollDisabled(true)

                        Text("grouped").font(.caption).foregroundStyle(.secondary)
                        List(styleItems, id: \.self) { Text($0) }
                            .listStyle(.grouped)
                            .frame(height: 220)
                            .scrollDisabled(true)

                        Text("insetGrouped").font(.caption).foregroundStyle(.secondary)
                        List(styleItems, id: \.self) { Text($0) }
                            .listStyle(.insetGrouped)
                            .frame(height: 220)
                            .scrollDisabled(true)

                        Text("sidebar").font(.caption).foregroundStyle(.secondary)
                        List(styleItems, id: \.self) { Text($0) }
                            .listStyle(.sidebar)
                            .frame(height: 220)
                            .scrollDisabled(true)
                    }
                }

                // MARK: swipeActions
                DemoSection(".swipeActions()", note: "左滑/右滑出现自定义操作按钮，role: .destructive 的按钮会自动渲染成红色") {
                    List {
                        ForEach(items, id: \.self) { item in
                            Text(item)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        items.removeAll { $0 == item }
                                    } label: {
                                        Label("删除", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                    } label: {
                                        Label("标记", systemImage: "flag")
                                    }
                                    .tint(.orange)
                                }
                        }
                    }
                    .frame(height: 320)
                    .scrollDisabled(true)
                }

                // MARK: selection
                DemoSection(
                    "单选 / 多选 selection",
                    note: "绑定 Binding<Item?> 是单选，点击行直接高亮；绑定 Binding<Set<Item>> 并打开 editMode 才会出现多选复选框"
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("单选结果：\(selection ?? "无")")
                            .font(.caption).foregroundStyle(.secondary)
                        List(items, id: \.self, selection: $selection) { item in
                            Text(item)
                        }
                        .frame(height: 320)
                        .scrollDisabled(true)

                        Text("多选结果：\(multiSelection.sorted().joined(separator: "、"))")
                            .font(.caption).foregroundStyle(.secondary)
                        List(items, id: \.self, selection: $multiSelection) { item in
                            Text(item)
                        }
                        .environment(\.editMode, .constant(.active))
                        .frame(height: 320)
                        .scrollDisabled(true)
                    }
                }

                // MARK: searchable
                DemoSection(".searchable()", note: "加在页面外层即可获得系统搜索框（出现在顶部导航栏下方），实时过滤下方列表") {
                    Text("当前过滤结果：\(filteredItems.joined(separator: "、"))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // MARK: onDelete/onMove
                DemoSection(
                    ".onDelete() / .onMove()",
                    note: "加在 ForEach 上即可获得删除/拖拽排序能力，需要配合编辑模式（EditButton 或手动设置 editMode）才会显示删除圆圈和拖拽手柄，完整交互示例见 Edit Button 那篇"
                ) {
                    Text("ForEach(items) { ... }\n  .onDelete { indexSet in items.remove(atOffsets: indexSet) }\n  .onMove { from, to in items.move(fromOffsets: from, toOffset: to) }")
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                // MARK: listRowSeparator / listRowBackground
                DemoSection(
                    ".listRowSeparator() / .listRowBackground()",
                    note: "逐行控制分隔线显示/隐藏，以及自定义该行的背景视图"
                ) {
                    List {
                        Text("默认分隔线")
                        Text("隐藏分隔线")
                            .listRowSeparator(.hidden)
                        Text("自定义背景")
                            .listRowBackground(Color.yellow.opacity(0.2))
                    }
                    .frame(height: 210)
                    .scrollDisabled(true)
                }

                // MARK: refreshable
                DemoSection(
                    ".refreshable()",
                    note: "加在 List 上即可获得下拉刷新手势，闭包是 async，下拉后系统显示加载圈直到闭包执行完，和 ScrollView 的用法一致"
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("刷新次数：\(refreshCount)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        List(items, id: \.self) { Text($0) }
                            .frame(height: 320)
                            .refreshable {
                                try? await Task.sleep(for: .seconds(1))
                                refreshCount += 1
                            }
                    }
                }

                // MARK: 实战
                DemoSection(
                    "实战：订单列表页",
                    note: "自定义行视图（圆形图标 + 标题/副标题 + 状态胶囊）配合 swipeActions，是电商类 App 订单列表的典型写法"
                ) {
                    List {
                        ForEach(sampleOrders) { order in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(order.color.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: order.icon)
                                            .foregroundStyle(order.color)
                                    )
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(order.title)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(order.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(order.status)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(order.color.opacity(0.15))
                                    .foregroundStyle(order.color)
                                    .clipShape(Capsule())
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                } label: {
                                    Label("删除", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .frame(height: 280)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .searchable(text: $searchText, prompt: "搜索水果")
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("List")
    }
}

#Preview {
    NavigationStack {
        ListComponentDemo()
    }
}
