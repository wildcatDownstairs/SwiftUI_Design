//
//  ComponentDemoSection.swift
//  SwiftUI Demo
//
//  组件说明库的通用卡片容器：标题 + 示例 + 备注，统一各个 XxxDemo.swift 的排版
//  改用 .glassSurface() 玻璃材质，配合 GlassBackground 的深色渐变背景，呈现 Liquid Glass 质感
//

import SwiftUI

struct DemoSection<Content: View>: View {
    let title: String
    let note: String?
    let content: Content

    init(_ title: String, note: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.note = note
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Capsule()
                    .fill(Theme.accent)
                    .frame(width: 3, height: 14)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
            }

            content

            if let note {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "info.circle.fill")
                        .font(.caption)
                        .foregroundStyle(Theme.accent)
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(Theme.inkSecondary)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.accent.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassSurface(cornerRadius: 20)
    }
}

#Preview {
    ZStack {
        GlassBackground()
        DemoSection("Markdown 支持（自动解析）", note: "字符串字面量里的 **粗体**、_斜体_、`代码`、[链接](url) 会被自动识别渲染，不需要额外 API") {
            Text("这是 **粗体**、_斜体_、`代码` 和 [链接](https://www.apple.com)")
                .foregroundStyle(Theme.ink)
        }.padding(.horizontal, 32)
    }
}
