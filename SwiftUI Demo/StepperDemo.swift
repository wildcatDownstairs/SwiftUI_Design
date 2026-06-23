//
//  StepperDemo.swift
//  SwiftUI Demo
//
//  Stepper 组件说明
//  初始化：Stepper("标题", value: $value, in: range, step: step) —— 加减按钮，常用于整数计数
//

import SwiftUI

struct StepperDemo: View {
    @State private var quantity = 1
    @State private var rating = 3
    @State private var customValue = 0
    @State private var editingValue = 5
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Stepper(\"标题\", value: $value, in: 1...10) —— 点击 +/- 改变数值，超出范围按钮自动变灰禁用") {
                    Stepper("数量：\(quantity)", value: $quantity, in: 1...10)
                }

                // MARK: step
                DemoSection("step 步进", note: "每次点击改变的幅度，不传默认是 1") {
                    Stepper("评分：\(rating)（step: 2）", value: $rating, in: 0...10, step: 2)
                }

                // MARK: 自定义 increment/decrement
                DemoSection(
                    "自定义 onIncrement / onDecrement",
                    note: "Stepper(onIncrement:onDecrement:label:) 不绑定具体数值范围，自己写加减逻辑，适合非线性的步进（比如翻倍）"
                ) {
                    Stepper {
                        Text("自定义步进：\(customValue)")
                    } onIncrement: {
                        customValue = customValue == 0 ? 1 : customValue * 2
                    } onDecrement: {
                        customValue = max(0, customValue / 2)
                    }
                }

                // MARK: label 自定义
                DemoSection("label 用 @ViewBuilder", note: "Stepper(value:in:label:) 的 label 可以放图标+文字组合") {
                    Stepper(value: $quantity, in: 1...10) {
                        Label("数量：\(quantity)", systemImage: "cart")
                    }
                }

                // MARK: onEditingChanged
                DemoSection(
                    "onEditingChanged",
                    note: "Stepper(value:in:step:onEditingChanged:) —— 按住 +/- 不松手期间持续回调 true，松手回调 false，可以用来区分「正在调」和「调完了」"
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Stepper("数值：\(editingValue)", value: $editingValue, in: 0...20) { editing in
                            isEditing = editing
                        }
                        Text(isEditing ? "正在调整…" : "已停止")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: 禁用
                DemoSection(".disabled()", note: "禁用后加减按钮一起变灰") {
                    Stepper("已禁用：\(quantity)", value: $quantity, in: 1...10)
                        .disabled(true)
                }

                // MARK: 放进 Form
                DemoSection("放进 Form", note: "Stepper 常见于购物车「商品数量」、设置页「字号大小」一类整数调节项") {
                    Form {
                        Stepper("商品数量：\(quantity)", value: $quantity, in: 1...99)
                    }
                    .frame(minHeight: 80)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Stepper")
    }
}

#Preview {
    NavigationStack {
        StepperDemo()
    }
}
