//
//  RenameButtonDemo.swift
//  SwiftUI Demo
//
//  RenameButton 组件说明
//  RenameButton() 本身不做任何事——点击时只是调用环境里通过 .renameAction { } 注册的闭包，
//  通常用来让外部的 TextField 进入编辑焦点，常见于文件/文档列表的"重命名"操作。
//

import SwiftUI

struct RenameButtonDemo: View {
    @State private var name = "未命名文档"
    @FocusState private var isFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection(
                    "基础用法",
                    note: "RenameButton() 点击后调用 .renameAction { } 里的闭包，这里让 TextField 获得焦点进入编辑状态"
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("文档名称", text: $name)
                            .focused($isFocused)
                            .textFieldStyle(.roundedBorder)
                        RenameButton()
                    }
                    .renameAction {
                        isFocused = true
                    }
                }

                // MARK: List 行的 contextMenu
                DemoSection(
                    "放进 List 行的 contextMenu",
                    note: "真实场景常见于文件/文档列表，长按一行弹出菜单，菜单里的 RenameButton 触发该行的重命名"
                ) {
                    List {
                        HStack {
                            Image(systemName: "doc.text")
                            Text(name)
                        }
                        .contextMenu {
                            RenameButton()
                            Button(role: .destructive) {
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                        }
                        .renameAction {
                            isFocused = true
                        }
                    }
                    .frame(minHeight: 80)
                    .scrollDisabled(true)
                }

                // MARK: toolbar 用法说明
                DemoSection("放进 toolbar（写法说明）", note: "RenameButton 也常直接放在导航栏 toolbar 里，作为页面级的「重命名」入口") {
                    Text(".toolbar {\n    ToolbarItem { RenameButton() }\n}")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Rename Button")
    }
}

#Preview {
    NavigationStack {
        RenameButtonDemo()
    }
}
