//
//  ShareLinkDemo.swift
//  SwiftUI Demo
//
//  ShareLink 组件说明（iOS 16+）
//  初始化：ShareLink(item: 可分享的内容) —— 点击后弹出系统分享面板，比手写 UIActivityViewController 简单很多
//  item 需要遵循 Transferable（String/URL/Image 等系统类型已经默认支持）
//

import SwiftUI

struct ShareLinkDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法（分享链接）", note: "ShareLink(item: URL) —— 系统自动生成默认外观（图标 + \"共享\" 文字）") {
                    ShareLink(item: URL(string: "https://www.apple.com")!)
                }

                // MARK: 自定义标题/副标题
                DemoSection("自定义标题/副标题", note: "ShareLink(标题, item:, subject:, message:) —— subject/message 会传给支持它们的分享渠道（如邮件）") {
                    ShareLink(
                        "分享这篇文章",
                        item: URL(string: "https://www.apple.com")!,
                        subject: Text("值得一看的文章"),
                        message: Text("我觉得这篇文章写得不错，分享给你")
                    )
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "ShareLink(item:label:) 的 label 可以放任意 View") {
                    ShareLink(item: URL(string: "https://www.apple.com")!) {
                        Label("分享", systemImage: "square.and.arrow.up")
                    }
                }

                // MARK: 分享纯文本
                DemoSection("分享纯文本", note: "item 也可以直接是 String，不一定要 URL") {
                    ShareLink(item: "这是一段想要分享出去的文字内容")
                }

                // MARK: preview
                DemoSection("带预览的分享（item:preview:）", note: "preview 提供标题/缩略图，分享面板里会显示更丰富的预览卡片，常用于分享图片") {
                    ShareLink(
                        item: URL(string: "https://www.apple.com")!,
                        preview: SharePreview("Apple 官网", image: Image(systemName: "globe"))
                    )
                }

                // MARK: 实际场景
                DemoSection("实战：工具栏分享按钮", note: "纯图标 label + toolbar，是最常见的「分享当前页面」入口写法") {
                    HStack {
                        Spacer()
                        ShareLink(item: URL(string: "https://www.apple.com")!) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                        }
                        Spacer()
                    }
                    .padding()
                    .glassSurface(cornerRadius: 16)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Share Link")
    }
}

#Preview {
    NavigationStack {
        ShareLinkDemo()
    }
}
