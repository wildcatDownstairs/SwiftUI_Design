//
//  ButtonDemo.swift
//  SwiftUI Demo
//
//  Button 组件说明（仿 Ant Design 文档的演示密度）
//
//  原生 API 部分：
//    Button("标题", action:)            —— 文本按钮简写
//    Button(action:label:)              —— label 闭包可放任意 View
//    Button(role:action:label:)         —— 带语义角色（destructive / cancel）
//    .buttonStyle(.automatic/.plain/.bordered/.borderedProminent/.borderless) —— 系统内置样式
//
//  注意：SwiftUI 原生没有 Ant Design 那种 Outlined/Dashed/Filled/Text/Link 变体，
//  下方"颜色与变体矩阵"用自定义 VariantButtonStyle 模拟视觉效果，不是系统 API。
//

import SwiftUI

// MARK: - 自定义变体（模拟 Ant Design 的 variant + color 组合，非系统原生）

enum DemoButtonVariant: String, CaseIterable, Identifiable {
    case solid = "Solid"
    case outlined = "Outlined"
    case dashed = "Dashed"
    case filled = "Filled"
    case text = "Text"
    case link = "Link"

    var id: String { rawValue }
}

enum DemoButtonSize {
    case large, medium, small

    var horizontalPadding: CGFloat {
        switch self {
        case .large: 20
        case .medium: 14
        case .small: 10
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .large: 12
        case .medium: 8
        case .small: 5
        }
    }

    var font: Font {
        switch self {
        case .large: .body
        case .medium: .subheadline
        case .small: .caption
        }
    }
}

/// 自定义 ButtonStyle：用 variant + color 两个轴模拟 Ant Design 的按钮矩阵
struct VariantButtonStyle: ButtonStyle {
    var variant: DemoButtonVariant = .solid
    var color: Color = .blue
    var size: DemoButtonSize = .medium

    // ButtonStyle 的 Configuration 不带 isEnabled，需要单独从环境里读，
    // 才能让自定义样式在 .disabled(true) 时真正变灰（否则只是不可点、外观不变）
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font.weight(.medium))
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .foregroundStyle(foregroundColor)
            .background(backgroundShape)
            .opacity(configuration.isPressed ? 0.65 : 1)
            .opacity(isEnabled ? 1 : 0.4)
            .grayscale(isEnabled ? 0 : 1)
    }

    private var foregroundColor: Color {
        // Solid 填充用白字（当前色板都是中到深色，白字对比度足够）；其余变体文字用主题色本身
        variant == .solid ? .white : color
    }

    @ViewBuilder
    private var backgroundShape: some View {
        switch variant {
        case .solid:
            RoundedRectangle(cornerRadius: 8).fill(color)
        case .outlined:
            RoundedRectangle(cornerRadius: 8).strokeBorder(color, lineWidth: 1.2)
        case .dashed:
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(style: StrokeStyle(lineWidth: 1.2, dash: [5, 3]))
                .foregroundStyle(color)
        case .filled:
            RoundedRectangle(cornerRadius: 8).fill(color.opacity(0.12))
        case .text, .link:
            Color.clear
        }
    }
}

struct ButtonDemo: View {
    @State private var tapCount = 0
    @State private var isLiked = false
    @State private var isLoading = false
    @State private var iconAtEnd = true
    @State private var repeatCount = 0

    private let palette: [(name: String, color: Color)] = [
        ("Default", Theme.neutral),
        ("Primary", .blue),
        ("Danger", .red),
        ("Pink", .pink),
        ("Purple", .purple),
        ("Cyan", .teal),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 语法糖
                DemoSection(
                    "语法糖",
                    note: "通过 variant 预设按钮样式：主按钮、次按钮、虚线按钮、文本按钮和链接按钮。推荐主按钮在同一操作区域最多出现一次。"
                ) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Button("Primary Button") {}
                                .buttonStyle(VariantButtonStyle(variant: .solid, color: .blue))
                            Button("Default Button") {}
                                .buttonStyle(VariantButtonStyle(variant: .outlined, color: Theme.neutral))
                            Button("Dashed Button") {}
                                .buttonStyle(VariantButtonStyle(variant: .dashed, color: Theme.neutral))
                            Button("Text Button") {}
                                .buttonStyle(VariantButtonStyle(variant: .text, color: Theme.neutral))
                            Button("Link Button") {}
                                .buttonStyle(VariantButtonStyle(variant: .link, color: .blue))
                        }
                    }
                }

                // MARK: 颜色与变体矩阵
                DemoSection(
                    "颜色与变体",
                    note: "同时设置 color 和 variant，可以衍生出更多的变体按钮（自定义 VariantButtonStyle 模拟，非系统原生）。"
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(palette, id: \.name) { item in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(DemoButtonVariant.allCases) { variant in
                                        Button(variant.rawValue) {}
                                            .buttonStyle(VariantButtonStyle(variant: variant, color: item.color))
                                    }
                                }
                            }
                        }
                    }
                }

                // MARK: 按钮图标
                DemoSection("按钮图标", note: "可以通过在 label 里放 Image/Label 添加图标，支持纯图标（圆形）或图标+文字。") {
                    HStack(spacing: 10) {
                        Button { } label: { Image(systemName: "magnifyingglass") }
                            .buttonStyle(VariantButtonStyle(variant: .solid, color: .blue))
                            .clipShape(Circle())
                        Button { } label: { Text("A") }
                            .buttonStyle(VariantButtonStyle(variant: .solid, color: .gray))
                            .clipShape(Circle())
                        Button { } label: { Label("Search", systemImage: "magnifyingglass") }
                            .buttonStyle(VariantButtonStyle(variant: .solid, color: .blue))
                        Button { } label: { Image(systemName: "magnifyingglass") }
                            .buttonStyle(VariantButtonStyle(variant: .outlined, color: Theme.neutral))
                            .clipShape(Circle())
                    }
                }

                // MARK: 按钮图标位置 + Loading
                DemoSection(
                    "按钮图标位置 & Loading",
                    note: "图标可以放在文字前面（start）或后面（end）；Loading 状态用 ProgressView 替换图标并禁用点击来模拟。"
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        Picker("图标位置", selection: $iconAtEnd) {
                            Text("start").tag(false)
                            Text("end").tag(true)
                        }
                        .pickerStyle(.segmented)

                        HStack(spacing: 10) {
                            Button {
                            } label: {
                                if iconAtEnd {
                                    Label("Search", systemImage: "magnifyingglass")
                                        .labelStyle(.trailingIcon)
                                } else {
                                    Label("Search", systemImage: "magnifyingglass")
                                }
                            }
                            .buttonStyle(VariantButtonStyle(variant: .solid, color: .blue))

                            Button {
                                isLoading.toggle()
                            } label: {
                                HStack(spacing: 6) {
                                    if isLoading {
                                        ProgressView().tint(.white)
                                    }
                                    Text("Loading")
                                }
                            }
                            .buttonStyle(VariantButtonStyle(variant: .solid, color: .blue))
                            .disabled(isLoading)
                        }
                    }
                }

                // MARK: 按钮尺寸
                DemoSection("按钮尺寸", note: "按钮有大、中、小三种尺寸，自定义 size 控制 padding 和字号；原生 API 用 .controlSize(.large/.regular/.small/.mini)。") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            Button("Large") {}.buttonStyle(VariantButtonStyle(variant: .solid, color: .blue, size: .large))
                            Button("Medium") {}.buttonStyle(VariantButtonStyle(variant: .outlined, color: Theme.neutral, size: .medium))
                            Button("Small") {}.buttonStyle(VariantButtonStyle(variant: .dashed, color: Theme.neutral, size: .small))
                        }

                        Text("原生写法：")
                            .font(.caption).foregroundStyle(.secondary)
                        HStack(spacing: 10) {
                            Button("large") {}.buttonStyle(.bordered).controlSize(.large)
                            Button("regular") {}.buttonStyle(.bordered).controlSize(.regular)
                            Button("mini") {}.buttonStyle(.bordered).controlSize(.mini)
                        }
                    }
                }

                // MARK: 系统内置样式（原生 API）
                DemoSection(".buttonStyle() 系统内置样式（原生）", note: "automatic / plain / bordered / borderedProminent / borderless") {
                    VStack(alignment: .leading, spacing: 10) {
                        Button("automatic（默认）") {}.buttonStyle(.automatic)
                        Button("plain") {}.buttonStyle(.plain)
                        Button("bordered") {}.buttonStyle(.bordered)
                        Button("borderedProminent") {}.buttonStyle(.borderedProminent)
                        Button("borderless") {}.buttonStyle(.borderless)
                    }
                }

                // MARK: role 语义角色
                DemoSection("role: 语义角色（原生）", note: ".destructive 在 Menu/Alert 里会自动变红；.cancel 表示取消操作。") {
                    HStack(spacing: 12) {
                        Button("删除", role: .destructive) {}.buttonStyle(.bordered)
                        Button("取消", role: .cancel) {}.buttonStyle(.bordered)
                    }
                }

                // MARK: Button(_:systemImage:action:)
                DemoSection(
                    "Button(_:systemImage:action:)（原生）",
                    note: "标题 + 系统图标的便捷初始化方式，等价于手写 Label(title:systemImage:) 作为 label，省去一层闭包"
                ) {
                    Button("添加", systemImage: "plus.circle.fill") {}
                        .buttonStyle(.bordered)
                }

                // MARK: buttonBorderShape
                DemoSection(
                    ".buttonBorderShape() 矩阵（原生）",
                    note: "automatic 跟随上下文；capsule 胶囊形；circle 常用于纯图标按钮；roundedRectangle 圆角矩形可自定义圆角半径"
                ) {
                    HStack(spacing: 12) {
                        Button("capsule") {}
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                        Button {} label: { Image(systemName: "plus") }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                        Button("roundedRectangle") {}
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.roundedRectangle(radius: 4))
                    }
                }

                // MARK: buttonRepeatBehavior
                DemoSection(
                    ".buttonRepeatBehavior(.enabled)（原生）",
                    note: "长按不松手会持续重复触发 action，常用于「长按快速加减数值」这类场景，默认是 .automatic（系统按上下文判断）"
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Button("长按我连续 +1") {
                            repeatCount += 1
                        }
                        .buttonStyle(.bordered)
                        .buttonRepeatBehavior(.enabled)
                        Text("当前计数：\(repeatCount)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: 禁用状态
                DemoSection("禁用状态", note: "每种 variant 禁用后都应整体变灰且不可点击，由外部 Bool 控制。") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            Button("Primary") {}.buttonStyle(VariantButtonStyle(variant: .solid, color: .blue))
                            Button("Primary(disabled)") {}.buttonStyle(VariantButtonStyle(variant: .solid, color: .blue)).disabled(true)
                        }
                        HStack(spacing: 10) {
                            Button("Default") {}.buttonStyle(VariantButtonStyle(variant: .outlined, color: Theme.neutral))
                            Button("Default(disabled)") {}.buttonStyle(VariantButtonStyle(variant: .outlined, color: Theme.neutral)).disabled(true)
                        }
                        HStack(spacing: 10) {
                            Button("Dashed") {}.buttonStyle(VariantButtonStyle(variant: .dashed, color: Theme.neutral))
                            Button("Dashed(disabled)") {}.buttonStyle(VariantButtonStyle(variant: .dashed, color: Theme.neutral)).disabled(true)
                        }
                    }
                }

                // MARK: 基础交互（保留原始小 demo）
                DemoSection("基础交互", note: "Button(\"标题\") { action } —— 最简单的文本按钮，配合 @State 验证点击确实触发了。") {
                    HStack(spacing: 12) {
                        Button("点击我（\(tapCount) 次）") { tapCount += 1 }
                            .buttonStyle(.bordered)
                        Button {
                            isLiked.toggle()
                        } label: {
                            Label(isLiked ? "已喜欢" : "喜欢", systemImage: isLiked ? "heart.fill" : "heart")
                                .foregroundStyle(isLiked ? .red : .primary)
                        }
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Button")
    }
}

// 让 Label 支持"图标在文字后面"的排列，原生 LabelStyle 默认图标在前
struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: TrailingIconLabelStyle { TrailingIconLabelStyle() }
}

#Preview {
    NavigationStack {
        ButtonDemo()
    }
}
