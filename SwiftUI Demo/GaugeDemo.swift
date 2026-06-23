//
//  GaugeDemo.swift
//  SwiftUI Demo
//
//  Gauge 组件说明
//  初始化：Gauge(value:in:label:) ，可选 currentValueLabel / minimumValueLabel / maximumValueLabel
//  .gaugeStyle() 控制外观：automatic / linearCapacity / accessoryCircular /
//  accessoryCircularCapacity / accessoryLinear / accessoryLinearCapacity
//

import SwiftUI

struct GaugeDemo: View {
    @State private var progress = 0.6
    @State private var batteryLevel = 0.35
    @State private var temperature = 36.5

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Gauge(value:in:label:) —— value 在 in 区间内的占比决定填充进度，label 显示在下方") {
                    Gauge(value: progress, in: 0...1) {
                        Text("进度")
                    }
                }

                // MARK: 可拖动联调
                DemoSection("可拖动联调", note: "用 Slider 控制 value，观察 Gauge 实时跟随变化，体会它本质上只是个只读展示组件") {
                    VStack(alignment: .leading, spacing: 10) {
                        Gauge(value: progress, in: 0...1) {
                            Text("进度")
                        }
                        Slider(value: $progress, in: 0...1)
                    }
                }

                // MARK: 三个标签
                DemoSection("currentValueLabel / min / max 标签", note: "三个标签分别显示在指针位置、左端、右端，常用于展示具体数值而不是只看进度条") {
                    Gauge(value: temperature, in: 0...100) {
                        Text("温度")
                    } currentValueLabel: {
                        Text("\(Int(temperature))°")
                    } minimumValueLabel: {
                        Text("0°")
                    } maximumValueLabel: {
                        Text("100°")
                    }
                }

                // MARK: accessoryCircular
                DemoSection(".gaugeStyle(.accessoryCircular)", note: "圆形仪表盘，常见于 Apple Watch 复杂功能（complication）风格") {
                    Gauge(value: batteryLevel, in: 0...1) {
                        Text("电量")
                    } currentValueLabel: {
                        Text("\(Int(batteryLevel * 100))")
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(.green)
                }

                // MARK: accessoryCircularCapacity
                DemoSection(".gaugeStyle(.accessoryCircularCapacity)", note: "圆形容量样式，填充弧线随 value 增长，视觉上更像电池/水位") {
                    Gauge(value: batteryLevel, in: 0...1) {
                        Text("电量")
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(.orange)
                }

                // MARK: accessoryLinear
                DemoSection(".gaugeStyle(.accessoryLinear)", note: "横向刻度条，带一个指针标记当前位置，和 accessoryLinearCapacity 的「整段填充」视觉不同，更像温度计刻度") {
                    Gauge(value: temperature, in: 0...100) {
                        Text("温度")
                    } currentValueLabel: {
                        Text("\(Int(temperature))°")
                    }
                    .gaugeStyle(.accessoryLinear)
                    .tint(.red)
                }

                // MARK: linearCapacity
                DemoSection(".gaugeStyle(.linearCapacity)", note: "横向容量条，类似进度条但带刻度感") {
                    Gauge(value: progress, in: 0...1) {
                        Text("容量")
                    }
                    .gaugeStyle(.linearCapacity)
                }

                // MARK: accessoryLinearCapacity
                DemoSection(".gaugeStyle(.accessoryLinearCapacity)", note: "更紧凑的横向容量条，适合列表行内展示") {
                    Gauge(value: progress, in: 0...1) {
                        Text("容量")
                    }
                    .gaugeStyle(.accessoryLinearCapacity)
                }

                // MARK: 渐变色
                DemoSection(".tint() 渐变色", note: "tint 支持传入 Gradient，让指针颜色随数值变化呈现渐变过渡，常用于温度/转速类仪表") {
                    Gauge(value: temperature, in: 0...100) {
                        Text("温度")
                    }
                    .tint(Gradient(colors: [.blue, .green, .yellow, .red]))
                }

                // MARK: 实战
                DemoSection(
                    "实战：健康数据卡片",
                    note: "三个 accessoryCircularCapacity 样式的 Gauge 并排 + 数值文字，是健康/运动类 App 最常见的环形数据卡片写法"
                ) {
                    HStack(spacing: 24) {
                        VStack(spacing: 6) {
                            Gauge(value: 0.7, in: 0...1) { Text("步数") }
                                .gaugeStyle(.accessoryCircularCapacity)
                                .tint(.green)
                            Text("7,021")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        VStack(spacing: 6) {
                            Gauge(value: 0.45, in: 0...1) { Text("卡路里") }
                                .gaugeStyle(.accessoryCircularCapacity)
                                .tint(.orange)
                            Text("450 kcal")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        VStack(spacing: 6) {
                            Gauge(value: 0.9, in: 0...1) { Text("距离") }
                                .gaugeStyle(.accessoryCircularCapacity)
                                .tint(.blue)
                            Text("4.5 km")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .glassSurface(cornerRadius: 16)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Gauge")
    }
}

#Preview {
    NavigationStack {
        GaugeDemo()
    }
}
