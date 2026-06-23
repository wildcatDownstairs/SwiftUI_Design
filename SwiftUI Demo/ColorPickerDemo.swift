//
//  ColorPickerDemo.swift
//  SwiftUI Demo
//
//  ColorPicker 组件说明（与 ButtonDemo 同等密度）
//  初始化方式：
//    ColorPicker("标题", selection: $color, supportsOpacity: Bool)
//    ColorPicker(selection:supportsOpacity:label:)  —— label 可放任意 View（@ViewBuilder）
//  selection 可绑定 Color 或 CGColor；点击后弹出系统取色面板（拾色器/色轮/光谱 Tab）
//

import SwiftUI

struct ColorPickerDemo: View {
    @State private var basicColor: Color = .blue
    @State private var opaqueColor: Color = .red
    @State private var bgColor: Color = .orange
    @State private var labeledColor: Color = .purple
    @State private var cgColor: CGColor = CGColor(srgbRed: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
    @State private var formColor: Color = .teal
    @State private var disabledColor: Color = .gray

    private let presets: [Color] = [.red, .orange, .yellow, .green, .teal, .blue, .purple, .pink]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "ColorPicker(\"标题\", selection: $color) —— 默认支持透明度调节") {
                    ColorPicker("选择颜色", selection: $basicColor)
                }

                // MARK: supportsOpacity
                DemoSection("supportsOpacity", note: "true（默认）带透明度滑杆；false 关闭透明度，只能选纯色，适合背景色这类场景") {
                    VStack(alignment: .leading, spacing: 10) {
                        ColorPicker("supportsOpacity: true", selection: $basicColor, supportsOpacity: true)
                        ColorPicker("supportsOpacity: false", selection: $opaqueColor, supportsOpacity: false)
                    }
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "ColorPicker(selection:label:) 的 label 可以放图标 + 文字组合，不限于纯文本") {
                    ColorPicker(selection: $labeledColor) {
                        Label("画笔颜色", systemImage: "paintbrush.fill")
                    }
                }

                // MARK: CGColor 绑定
                DemoSection("绑定 CGColor", note: "selection 除了 Color，也支持直接绑定 CGColor，常见于需要和 Core Graphics/UIKit 互通的场景") {
                    ColorPicker("CGColor 绑定", selection: $cgColor)
                }

                // MARK: labelsHidden
                DemoSection(".labelsHidden()", note: "隐藏文字标签，只留色块按钮，常用于紧凑布局（如工具栏、List 行内）") {
                    HStack {
                        Text("主题色")
                        Spacer()
                        ColorPicker("隐藏的标签", selection: $basicColor)
                            .labelsHidden()
                    }
                }

                // MARK: 实时联动效果
                DemoSection("实时联动效果", note: "selection 是双向绑定，选完立刻反映到任何用到它的地方") {
                    VStack(alignment: .leading, spacing: 10) {
                        ColorPicker("背景色", selection: $bgColor)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(bgColor)
                            .frame(height: 60)
                    }
                }

                // MARK: 预设色板快捷选择
                DemoSection("预设色板（自定义交互）", note: "点击下方色块直接赋值给 selection，弹出系统面板之外的快捷取色方式，原生没有此 API，自己拼的。") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            ForEach(Array(presets.enumerated()), id: \.offset) { _, swatch in
                                Circle()
                                    .fill(swatch)
                                    .frame(width: 28, height: 28)
                                    .overlay(
                                        Circle().strokeBorder(.white, lineWidth: swatch == bgColor ? 2 : 0)
                                    )
                                    .onTapGesture { bgColor = swatch }
                            }
                        }
                        ColorPicker("或手动选择", selection: $bgColor)
                    }
                }

                // MARK: 在 Form 里使用
                DemoSection("在 Form / List 里使用", note: "ColorPicker 最常见的真实场景是放进 Form 的一行，和系统设置页风格一致") {
                    Form {
                        ColorPicker("强调色", selection: $formColor)
                        ColorPicker("次要色", selection: $bgColor)
                    }
                    .frame(minHeight: 120)
                    .scrollDisabled(true)
                }

                // MARK: 禁用状态
                DemoSection(".disabled()", note: "禁用后色块变灰且不可点击，由外部 Bool 控制") {
                    ColorPicker("禁用的取色器", selection: $disabledColor)
                        .disabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Color Picker")
    }
}

#Preview {
    NavigationStack {
        ColorPickerDemo()
    }
}
