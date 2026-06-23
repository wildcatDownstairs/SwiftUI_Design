//
//  SliderDemo.swift
//  SwiftUI Demo
//
//  Slider 组件说明
//  初始化：Slider(value: $value, in: range, step: step) —— 拖动滑杆改变数值
//

import SwiftUI

struct SliderDemo: View {
    @State private var volume = 50.0
    @State private var steppedValue = 5.0
    @State private var isEditing = false
    @State private var editCount = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Slider(value: $value, in: 0...100) —— 不传 step 时可以连续拖动到任意小数值") {
                    Slider(value: $volume, in: 0...100)
                    Text("当前值：\(Int(volume))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // MARK: step
                DemoSection("step 步进", note: "传入 step 后只能停在固定间隔的刻度上，和 Stepper 的 step 含义一致") {
                    Slider(value: $steppedValue, in: 0...10, step: 1)
                    Text("当前值：\(Int(steppedValue))（只能是整数）")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // MARK: min/max 标签
                DemoSection("minimumValueLabel / maximumValueLabel", note: "两端可以放图标说明含义，比纯数字更直观") {
                    Slider(value: $volume, in: 0...100) {
                        Text("音量")
                    } minimumValueLabel: {
                        Image(systemName: "speaker.fill")
                    } maximumValueLabel: {
                        Image(systemName: "speaker.wave.3.fill")
                    }
                }

                // MARK: onEditingChanged
                DemoSection(
                    "onEditingChanged",
                    note: "拖动开始时回调 true，松手时回调 false，常用来区分「正在拖」和「拖完了」两种状态（比如拖动时暂停自动刷新）"
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Slider(value: $volume, in: 0...100) { editing in
                            isEditing = editing
                            if !editing { editCount += 1 }
                        }
                        Text(isEditing ? "正在拖动…" : "已松手（共拖动 \(editCount) 次）")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: tint
                DemoSection(".tint()", note: "改变滑杆已填充部分的颜色") {
                    Slider(value: $volume, in: 0...100)
                        .tint(.orange)
                }

                // MARK: 放进 Form
                DemoSection("放进 Form", note: "Slider 常见于设置页的「音量」「亮度」这类连续数值调节项") {
                    Form {
                        Section("显示与亮度") {
                            HStack {
                                Image(systemName: "sun.min")
                                Slider(value: $volume, in: 0...100)
                                Image(systemName: "sun.max")
                            }
                        }
                    }
                    .frame(minHeight: 100)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Slider")
    }
}

#Preview {
    NavigationStack {
        SliderDemo()
    }
}
