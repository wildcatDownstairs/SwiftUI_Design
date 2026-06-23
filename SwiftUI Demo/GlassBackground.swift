//
//  GlassBackground.swift
//  SwiftUI Demo
//
//  全局奶油色渐变背景 + 柔和暖色光晕（Claude 风格），给浅色玻璃材质提供足够的暖调反差。
//

import SwiftUI

struct GlassBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.creamTop, Theme.creamBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Theme.glowPeach.opacity(0.55))
                .frame(width: 360, height: 360)
                .blur(radius: 70)
                .offset(x: 150, y: -280)

            Circle()
                .fill(Theme.glowClay.opacity(0.35))
                .frame(width: 420, height: 420)
                .blur(radius: 80)
                .offset(x: -170, y: 220)

            Circle()
                .fill(Theme.glowSand.opacity(0.5))
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .offset(x: 130, y: 480)

            Circle()
                .fill(Theme.glowPeach.opacity(0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 75)
                .offset(x: -130, y: -440)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GlassBackground()
}
