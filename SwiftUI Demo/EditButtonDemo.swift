//
//  EditButtonDemo.swift
//  SwiftUI Demo
//
//  EditButton 组件说明
//  EditButton() 没有任何参数，它自动读写环境里的 \.editMode，
//  点击后在 .active / .inactive 之间切换，常放在 List 所在页面的 toolbar 里，
//  配合 List 的 .onDelete / .onMove 才能看到删除圆圈和拖拽手柄。
//

import SwiftUI

struct EditButtonDemo: View {
    @State private var fruits = ["苹果", "香蕉", "橙子", "葡萄", "西瓜"]
    @Environment(\.editMode) private var editMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础概念
                DemoSection("基础概念", note: "editMode 是一个环境值（EditMode?），EditButton 只是它的标准 UI 入口，自己也可以用 Button 手动切换") {
                    Text("当前 editMode：\(editMode?.wrappedValue == .active ? "编辑中" : "未编辑")")
                        .foregroundStyle(.secondary)
                }

                // MARK: 配合 List 删除/排序
                DemoSection("配合 List 的删除 / 排序", note: "进入编辑模式后，List 行首出现删除圆圈（onDelete 提供），行尾出现拖拽手柄（onMove 提供）") {
                    List {
                        ForEach(fruits, id: \.self) { fruit in
                            Text(fruit)
                        }
                        .onDelete { indexSet in
                            fruits.remove(atOffsets: indexSet)
                        }
                        .onMove { source, destination in
                            fruits.move(fromOffsets: source, toOffset: destination)
                        }
                    }
                    .frame(height: 260)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                    }
                }

                // MARK: 手动控制 editMode
                DemoSection("手动控制 editMode（不用 EditButton）", note: "editMode 是普通的 Binding<EditMode?>，自己写一个按钮赋值也能达到同样效果") {
                    Button(editMode?.wrappedValue == .active ? "完成" : "编辑") {
                        withAnimation {
                            editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Edit Button")
    }
}

#Preview {
    NavigationStack {
        EditButtonDemo()
    }
}
