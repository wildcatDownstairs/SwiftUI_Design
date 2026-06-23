//
//  LinkDemo.swift
//  SwiftUI Demo
//
//  Link 组件说明
//  初始化方式：
//    Link("标题", destination: URL)   —— 字符串简写
//    Link(destination:label:)        —— label 可放任意 View（@ViewBuilder）
//  点击后由系统打开链接：Universal Link 会优先跳到关联 App，否则用用户的默认浏览器（不是应用内嵌 Safari）。
//  可用 environment(\.openURL) 注入 OpenURLAction 拦截改写（比如改成 in-app SFSafariViewController）
//

import SwiftUI

struct LinkDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Link(\"标题\", destination: URL) —— 点击后用系统默认方式打开链接") {
                    Link("访问 Apple 官网", destination: URL(string: "https://www.apple.com")!)
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "Link(destination:label:) 的 label 可以放图标 + 文字组合") {
                    Link(destination: URL(string: "https://developer.apple.com")!) {
                        Label("开发者文档", systemImage: "doc.text")
                    }
                }

                // MARK: 样式修饰
                DemoSection("样式同 Button", note: "Link 本质也是个可点击 View，可以叠加 .font/.foregroundStyle 等修饰符") {
                    Link("加粗大号链接", destination: URL(string: "https://www.apple.com")!)
                        .font(.title3.bold())
                        .foregroundStyle(.blue)
                }

                // MARK: 拦截链接跳转
                DemoSection(
                    "拦截链接跳转（environment）",
                    note: ".environment(\\.openURL, OpenURLAction { ... }) 可以拦截所有 Link 调用，自己决定怎么处理（记录日志、改成 in-app 打开等）"
                ) {
                    Link("被拦截的链接（看 Xcode 控制台）", destination: URL(string: "https://www.apple.com")!)
                        .environment(\.openURL, OpenURLAction { url in
                            print("拦截到链接：\(url)")
                            return .handled
                        })
                }

                // MARK: 放进 List
                DemoSection("放进 List", note: "Link 常见于设置页的「使用条款」「隐私政策」一类行，外观和普通 List 行一致") {
                    List {
                        Link("使用条款", destination: URL(string: "https://www.apple.com")!)
                        Link("隐私政策", destination: URL(string: "https://www.apple.com")!)
                    }
                    .frame(minHeight: 120)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Link")
    }
}

#Preview {
    NavigationStack {
        LinkDemo()
    }
}
