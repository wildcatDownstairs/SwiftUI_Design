//
//  NavigationViewDemo.swift
//  SwiftUI Demo
//
//  NavigationView 从 iOS 16 起被标记为 deprecated，官方建议：
//  - 单栏导航场景 → 改用 NavigationStack
//  - 多栏/侧边栏场景（原来配合 .navigationViewStyle(.columns) 用的） → 改用 NavigationSplitView
//  所以这里不实现 NavigationView 本身，只演示两种现代替代写法。
//

import SwiftUI

struct NavigationViewDemo: View {
    var body: some View {
        List {
            Section("NavigationView 已废弃") {
                Text("NavigationView { 根视图 } → 已废弃\nNavigationStack { 根视图 } → 单栏场景的替代\nNavigationSplitView { sidebar } detail: { } → 多栏场景的替代")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            Section("替代方案一：NavigationStack") {
                NavigationLink("查看示例") { StackReplacementExample() }
                Text("适用于原来 NavigationView 不设置 .navigationViewStyle 的单栏场景")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("替代方案二：NavigationSplitView") {
                NavigationLink("查看示例") { SplitReplacementExample() }
                Text("适用于原来配合 .navigationViewStyle(.columns) 的双栏/侧边栏场景")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Navigation View")
    }
}

private struct StackReplacementExample: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("第一项") { Text("详情页") }
                NavigationLink("第二项") { Text("详情页") }
            }
            .navigationTitle("替代 NavigationView")
        }
    }
}

private struct SplitReplacementExample: View {
    var body: some View {
        NavigationSplitView {
            List {
                Text("侧边栏项目 A")
                Text("侧边栏项目 B")
            }
            .navigationTitle("侧边栏")
        } detail: {
            Text("详情区域")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        NavigationViewDemo()
    }
}
