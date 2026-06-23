//
//  GlassStyle.swift
//  SwiftUI Demo
//
//  全局玻璃材质修饰符。参考 https://github.com/sanjaynela/liquid-glass-ios-system 的 GlassKit 实现，
//  用系统 Material（.ultraThinMaterial）而不是 iOS 26 专属的 .glassEffect()，
//  这样整个 App 的卡片/输入框风格在 iOS 17+ 也能正常工作，不强制要求最新 SDK。
//  （Liquid Glass 专栏那篇用的是真正的 .glassEffect() 原生 API，两者并不冲突，分别演示「系统材质模拟玻璃」
//  和「iOS 26 原生玻璃」两种实现路径。）
//

import SwiftUI

struct GlassStyle: Equatable {
    // 浅色奶油背景下：描边用暖黑低透明（白描边在浅色上看不见），高光保留一点白色顶光，阴影更柔
    var strokeOpacity: Double = 0.08
    var highlightOpacity: Double = 0.35
    var shadowOpacity: Double = 0.10
    var shadowRadius: CGFloat = 16
    var shadowY: CGFloat = 8
}

private struct GlassStyleKey: EnvironmentKey {
    static let defaultValue = GlassStyle()
}

extension EnvironmentValues {
    var glassStyle: GlassStyle {
        get { self[GlassStyleKey.self] }
        set { self[GlassStyleKey.self] = newValue }
    }
}

private struct GlassSurface: ViewModifier {
    let cornerRadius: CGFloat
    let material: Material
    let allowsShadow: Bool

    @Environment(\.glassStyle) private var style
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        reduceTransparency
                        ? AnyShapeStyle(Color(white: 0.97))
                        : AnyShapeStyle(material)
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Theme.ink.opacity(style.strokeOpacity), lineWidth: 1)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        RadialGradient(
                            colors: [Color.white.opacity(style.highlightOpacity), Color.clear],
                            center: .topLeading,
                            startRadius: 16,
                            endRadius: 240
                        )
                    )
                    .blendMode(.softLight)
                    .allowsHitTesting(false)
            }
            .compositingGroup()
            .shadow(
                color: Color.black.opacity(allowsShadow ? style.shadowOpacity : 0),
                radius: allowsShadow ? style.shadowRadius : 0,
                x: 0,
                y: allowsShadow ? style.shadowY : 0
            )
    }
}

extension View {
    func glassSurface(
        cornerRadius: CGFloat = 22,
        material: Material = .ultraThinMaterial,
        allowsShadow: Bool = true
    ) -> some View {
        modifier(GlassSurface(cornerRadius: cornerRadius, material: material, allowsShadow: allowsShadow))
    }
}

/// 图标 + 玻璃材质输入框容器，内部可以放 TextField/SecureField 等任意输入控件
struct GlassFieldContainer<Content: View>: View {
    let icon: String?
    let content: Content

    init(icon: String? = nil, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(Theme.inkSecondary)
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 20)
            }
            content
                .tint(Theme.accent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .glassSurface(cornerRadius: 18, allowsShadow: false)
    }
}
