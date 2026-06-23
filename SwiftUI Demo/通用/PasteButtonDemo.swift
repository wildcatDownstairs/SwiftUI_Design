//
//  PasteButtonDemo.swift
//  SwiftUI Demo
//
//  PasteButton 组件说明（iOS 16+）
//  初始化：PasteButton(payloadType: 类型.self) { 数组 in ... } —— 系统统一外观的粘贴按钮，
//  点击后直接从系统剪贴板读取数据，不需要自己调用 UIPasteboard。
//  closure 收到的永远是数组（剪贴板可能同时有多项），即使只声明了单一类型。
//

import SwiftUI
import UniformTypeIdentifiers

struct PasteButtonDemo: View {
    @State private var pastedText = ""
    @State private var pastedCount = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "PasteButton(payloadType: String.self) { strings in ... } —— 点击后从剪贴板取文本") {
                    PasteButton(payloadType: String.self) { strings in
                        pastedText = strings.first ?? ""
                        pastedCount += 1
                    }
                }

                // MARK: 粘贴结果展示
                DemoSection("粘贴结果展示", note: "closure 参数是 [String]，先去系统里复制一段文字再回来点按钮试试") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("最近一次粘贴：\(pastedText.isEmpty ? "（暂无）" : pastedText)")
                        Text("粘贴次数：\(pastedCount)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: buttonBorderShape
                DemoSection(".buttonBorderShape() 矩阵", note: "capsule 胶囊形；roundedRectangle 圆角矩形，是 PasteButton 仅有的几个外观调整点之一") {
                    HStack(spacing: 12) {
                        PasteButton(payloadType: String.self) { strings in
                            pastedText = strings.first ?? ""
                        }
                        .buttonBorderShape(.capsule)

                        PasteButton(payloadType: String.self) { strings in
                            pastedText = strings.first ?? ""
                        }
                        .buttonBorderShape(.roundedRectangle)
                    }
                }

                // MARK: supportedContentTypes
                DemoSection(
                    "supportedContentTypes:payloadAction:",
                    note: "当需要同时接受多种内容类型（比如文本或图片任一种）时使用，payloadAction 收到的是 [NSItemProvider]，需要自己进一步解析具体类型，比 payloadType 版本更底层、更灵活"
                ) {
                    PasteButton(supportedContentTypes: [.plainText, .image]) { providers in
                        pastedCount += providers.count
                    }
                }

                // MARK: tint
                DemoSection(".tint()", note: "可以改变按钮的强调色，整体外观仍由系统统一控制，不能像 Button 那样完全自定义样式") {
                    PasteButton(payloadType: String.self) { strings in
                        pastedText = strings.first ?? ""
                    }
                    .tint(.orange)
                }

                // MARK: 实际场景
                DemoSection("实战：搜索框旁的粘贴按钮", note: "TextField + PasteButton 组合，常见于「粘贴链接/口令」一类输入场景") {
                    HStack(spacing: 8) {
                        TextField("粘贴链接到这里", text: $pastedText)
                            .textFieldStyle(.roundedBorder)
                        PasteButton(payloadType: String.self) { strings in
                            pastedText = strings.first ?? ""
                        }
                        .labelsHidden()
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Paste Button")
    }
}

#Preview {
    NavigationStack {
        PasteButtonDemo()
    }
}
