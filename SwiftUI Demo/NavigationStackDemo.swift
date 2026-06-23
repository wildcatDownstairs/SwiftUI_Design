//
//  NavigationStackDemo.swift
//  SwiftUI Demo
//
//  NavigationStack 组件说明
//  NavigationStack 和 NavigationSplitView 一样是"全屏级容器"，硬塞进小卡片会渲染空白，
//  所以这里用 List + NavigationLink 跳到独立全屏示例页来演示。
//

import SwiftUI

struct NavigationStackDemo: View {
    var body: some View {
        List {
            Section("基础用法（自管理）") {
                NavigationLink("查看示例") { BasicStackExample() }
                Text("NavigationStack { 根视图 } —— 不传 path 时，内部自己管理导航栈，最简单的写法")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("path: [Value] 数组绑定") {
                NavigationLink("查看示例") { ArrayPathExample() }
                Text("path 是普通数组，外部可以直接 append / removeLast / removeAll 编程式控制导航")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("NavigationPath（类型擦除）") {
                NavigationLink("查看示例") { NavigationPathExample() }
                Text("NavigationPath 可以在同一个 path 里混装多种不同 Hashable 类型，不像数组只能存一种类型")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("监听 path 变化") {
                NavigationLink("查看示例") { OnChangePathExample() }
                Text(".onChange(of: path) 可以在每次导航变化时执行额外逻辑，比如埋点统计页面访问")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Navigation Stack")
    }
}

private struct BasicStackExample: View {
    var body: some View {
        NavigationStack {
            NavigationLink("继续 push") {
                Text("第二层")
                    .navigationTitle("第二层")
            }
            .navigationTitle("根视图")
        }
    }
}

private struct ArrayPathExample: View {
    @State private var path: [Int] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 12) {
                Button("push 1") { path.append(1) }
                Button("push 1, 2, 3（一次推三层）") { path.append(contentsOf: [1, 2, 3]) }
                Button("回到根") { path.removeAll() }
            }
            .buttonStyle(.bordered)
            .navigationDestination(for: Int.self) { value in
                VStack(spacing: 12) {
                    Text("当前层：\(value)")
                    Button("继续 push") { path.append(value + 1) }
                    Button("后退一层") { path.removeLast() }
                }
                .buttonStyle(.bordered)
                .navigationTitle("第 \(value) 层")
            }
            .navigationTitle("数组 path")
        }
    }
}

private struct NavigationPathExample: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 12) {
                Button("push 一个 Int") { path.append(42) }
                Button("push 一个 String") { path.append("混装类型") }
                Button("回到根") { path.removeLast(path.count) }
            }
            .buttonStyle(.bordered)
            .navigationDestination(for: Int.self) { value in
                Text("Int 页面：\(value)").navigationTitle("Int")
            }
            .navigationDestination(for: String.self) { value in
                Text("String 页面：\(value)").navigationTitle("String")
            }
            .navigationTitle("NavigationPath 混装")
        }
    }
}

private struct OnChangePathExample: View {
    @State private var path: [Int] = []
    @State private var log: [String] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, spacing: 12) {
                Button("push") { path.append(path.count + 1) }
                    .buttonStyle(.bordered)
                Divider()
                Text("变化日志：").font(.caption).foregroundStyle(.secondary)
                ForEach(log, id: \.self) { Text($0).font(.caption2) }
            }
            .padding()
            .navigationDestination(for: Int.self) { value in
                Text("第 \(value) 层").navigationTitle("第 \(value) 层")
            }
            .navigationTitle("onChange 示例")
            .onChange(of: path) { _, newValue in
                log.append("path 变为 \(newValue.count) 层")
            }
        }
    }
}

#Preview {
    NavigationStack {
        NavigationStackDemo()
    }
}
