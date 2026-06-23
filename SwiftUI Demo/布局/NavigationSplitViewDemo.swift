//
//  NavigationSplitViewDemo.swift
//  SwiftUI Demo
//
//  组件面板里的"Horizontal Split View"对应的是 macOS 专属的 HSplitView/VSplitView，
//  这两个 API 在 iOS 上不存在，本项目编译目标是 iOS，写了会直接报错，因此不收录。
//
//  iOS 上真正对等、且能力更强的"分栏视图"是 NavigationSplitView：
//  它不只是左右分栏，在 iPhone 竖屏（窄屏）下还会自动折叠成单栏导航栈，
//  这是 HSplitView 完全没有的自适应能力——所以下面用它来演示。
//
//  注意：NavigationSplitView 和 NavigationStack 一样是"全屏级容器"，
//  硬塞进外层 ScrollView 的小卡片里会导致内容空白渲染失败，
//  所以这里不用 DemoSection 卡片包裹，而是用 NavigationLink 跳到独立的全屏示例页。
//

import SwiftUI

struct NavigationSplitViewDemo: View {
    var body: some View {
        List {
            Section("基础两栏（sidebar + detail）") {
                NavigationLink("查看示例") { BasicSplitExample() }
                Text("NavigationSplitView { sidebar } detail: { detail } —— iPad/横屏左右分栏；iPhone 竖屏自动折叠成单栏，点击列表项才推入详情")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("columnVisibility 绑定") {
                NavigationLink("查看示例") { VisibilitySplitExample() }
                Text("NavigationSplitViewVisibility 控制侧栏显示状态：.all / .doubleColumn / .detailOnly / .automatic")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section(".navigationSplitViewStyle()") {
                NavigationLink("查看示例（balanced）") { BalancedSplitExample() }
                NavigationLink("查看示例（prominentDetail）") { StyledSplitExample() }
                Text("默认是 automatic（系统按上下文自动选择）；balanced 两栏尽量等宽；prominentDetail 让 detail 区域尽量占满剩余空间")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("三栏（sidebar + content + detail）") {
                NavigationLink("查看示例") { ThreeColumnSplitExample() }
                Text("NavigationSplitView { sidebar } content: { content } detail: { detail } —— 三栏版本，preferredCompactColumn 决定窄屏下默认显示哪一栏，.navigationSplitViewColumnWidth() 固定某一栏的宽度")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Split View")
    }
}

private struct BasicSplitExample: View {
    private let fruits = ["苹果", "香蕉", "橙子", "葡萄", "西瓜"]
    @State private var selected: String?

    var body: some View {
        NavigationSplitView {
            List(fruits, id: \.self, selection: $selected) { fruit in
                Text(fruit)
            }
            .navigationTitle("水果")
        } detail: {
            if let selected {
                Text("已选择：\(selected)")
            } else {
                Text("请选择一项")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct VisibilitySplitExample: View {
    private let fruits = ["苹果", "香蕉", "橙子", "葡萄", "西瓜"]
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(fruits, id: \.self) { Text($0) }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(columnVisibility == .all ? "收起侧栏" : "展开侧栏") {
                            columnVisibility = columnVisibility == .all ? .detailOnly : .all
                        }
                    }
                }
        } detail: {
            Text("详情区域")
                .foregroundStyle(.secondary)
        }
    }
}

private struct StyledSplitExample: View {
    private let fruits = ["苹果", "香蕉", "橙子", "葡萄", "西瓜"]

    var body: some View {
        NavigationSplitView {
            List(fruits, id: \.self) { Text($0) }
        } detail: {
            Text("prominentDetail 样式")
                .foregroundStyle(.secondary)
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}

private struct BalancedSplitExample: View {
    private let fruits = ["苹果", "香蕉", "橙子", "葡萄", "西瓜"]

    var body: some View {
        NavigationSplitView {
            List(fruits, id: \.self) { Text($0) }
        } detail: {
            Text("balanced 样式：两栏尽量等宽")
                .foregroundStyle(.secondary)
        }
        .navigationSplitViewStyle(.balanced)
    }
}

private struct ThreeColumnSplitExample: View {
    private enum Category: String, CaseIterable, Identifiable, Hashable {
        case fruit = "水果", veggie = "蔬菜"
        var id: String { rawValue }
    }

    private let data: [Category: [String]] = [
        .fruit: ["苹果", "香蕉", "橙子"],
        .veggie: ["白菜", "番茄", "黄瓜"],
    ]

    @State private var selectedCategory: Category? = .fruit
    @State private var selectedItem: String?
    @State private var preferredColumn = NavigationSplitViewColumn.content

    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            List(Category.allCases, selection: $selectedCategory) { category in
                Text(category.rawValue).tag(category)
            }
            .navigationTitle("分类")
            .navigationSplitViewColumnWidth(150)
        } content: {
            List(data[selectedCategory ?? .fruit] ?? [], id: \.self, selection: $selectedItem) { item in
                Text(item)
            }
            .navigationTitle(selectedCategory?.rawValue ?? "")
        } detail: {
            if let selectedItem {
                Text("已选择：\(selectedItem)")
            } else {
                Text("请选择一项")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        NavigationSplitViewDemo()
    }
}
