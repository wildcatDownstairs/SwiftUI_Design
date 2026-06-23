//
//  OutlineGroupDemo.swift
//  SwiftUI Demo
//
//  OutlineGroup 组件说明
//  初始化：OutlineGroup(数据, children: \.可选子数组KeyPath) { item in ... }
//  自动渲染成可展开/收起的树状层级，常用来做文件目录/组织架构这类递归数据
//

import SwiftUI

private struct FileItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var children: [FileItem]?
}

private struct PlainFileItem {
    let name: String
    let icon: String
    var children: [PlainFileItem]?
}

private let plainTree: [PlainFileItem] = [
    PlainFileItem(name: "Assets", icon: "folder", children: [
        PlainFileItem(name: "icon.png", icon: "photo", children: nil),
        PlainFileItem(name: "logo.svg", icon: "photo", children: nil)
    ])
]

private let fileTree: [FileItem] = [
    FileItem(name: "项目文件夹", icon: "folder", children: [
        FileItem(name: "Sources", icon: "folder", children: [
            FileItem(name: "ContentView.swift", icon: "doc.text", children: nil),
            FileItem(name: "Models", icon: "folder", children: [
                FileItem(name: "User.swift", icon: "doc.text", children: nil)
            ])
        ]),
        FileItem(name: "README.md", icon: "doc.text", children: nil)
    ])
]

struct OutlineGroupDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection(
                    "基础用法",
                    note: "OutlineGroup(数据, children: \\.可选子数组KeyPath) { ... } —— 自动渲染成可展开/收起的树状层级，常用来做文件目录"
                ) {
                    OutlineGroup(fileTree, children: \.children) { item in
                        Label(item.name, systemImage: item.icon)
                    }
                }

                // MARK: List 版本
                DemoSection("放进 List：List(_:children:)", note: "List 有专门的 children 重载，效果和 OutlineGroup 一样，但自带 List 的滚动和分隔线样式") {
                    List(fileTree, children: \.children) { item in
                        Label(item.name, systemImage: item.icon)
                    }
                    .frame(minHeight: 240)
                    .scrollDisabled(true)
                }

                // MARK: id 重载
                DemoSection(
                    "OutlineGroup(_:id:children:content:)",
                    note: "数据不是 Identifiable 时，用 id: 传一个 KeyPath 当唯一标识（这里用 name 当 id），其余用法和基础版一致"
                ) {
                    OutlineGroup(plainTree, id: \.name, children: \.children) { item in
                        Label(item.name, systemImage: item.icon)
                    }
                }

                // MARK: 自定义行样式
                DemoSection("自定义每一行的样式", note: "OutlineGroup 的 content 闭包可以放任意 View，不限于纯文本") {
                    OutlineGroup(fileTree, children: \.children) { item in
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundStyle(item.children == nil ? Color.secondary : Color.blue)
                            Text(item.name)
                            if item.children != nil {
                                Spacer()
                                Text("\(item.children?.count ?? 0) 项")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Outline Group")
    }
}

#Preview {
    NavigationStack {
        OutlineGroupDemo()
    }
}
