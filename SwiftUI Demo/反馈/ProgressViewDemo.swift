//
//  ProgressViewDemo.swift
//  SwiftUI Demo
//
//  ProgressView 组件说明
//  ProgressView()                       —— 不确定进度的转圈动画
//  ProgressView(value:total:)           —— 确定进度的进度条/进度环
//  .progressViewStyle() 控制外观：automatic / linear / circular
//

import SwiftUI

/// 自定义 ProgressViewStyle：把横条换成圆点徽章 + 百分比文字
struct BadgeProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        let fraction = configuration.fractionCompleted ?? 0
        HStack(spacing: 8) {
            Circle()
                .stroke(.gray.opacity(0.2), lineWidth: 4)
                .overlay(
                    Circle()
                        .trim(from: 0, to: fraction)
                        .stroke(.green, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                )
                .frame(width: 28, height: 28)
            Text("\(Int(fraction * 100))%")
                .font(.caption.bold())
        }
    }
}

struct ProgressViewDemo: View {
    @State private var progress = 0.4
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 不确定进度
                DemoSection("不确定进度（转圈）", note: "ProgressView() —— 不知道具体进度时用，一直转圈直到任务完成") {
                    ProgressView()
                }

                // MARK: 确定进度
                DemoSection("确定进度（进度条）", note: "ProgressView(value:total:) —— value/total 决定填充比例，默认 total 是 1.0") {
                    ProgressView(value: progress)
                    Slider(value: $progress, in: 0...1)
                }

                // MARK: 带文字标签
                DemoSection("带文字标签", note: "ProgressView(\"标题\", value:total:) 或 label/currentValueLabel 闭包可以显示说明文字和具体数值") {
                    ProgressView(value: progress, total: 1) {
                        Text("下载进度")
                    } currentValueLabel: {
                        Text("\(Int(progress * 100))%")
                    }
                }

                // MARK: progressViewStyle 矩阵
                DemoSection(".progressViewStyle() 样式矩阵", note: "linear 横条；circular 圆环（不确定进度时常用），两者对 value 的支持程度不同") {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("linear").font(.caption).foregroundStyle(.secondary)
                        ProgressView(value: progress)
                            .progressViewStyle(.linear)

                        Text("circular").font(.caption).foregroundStyle(.secondary)
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }

                // MARK: tint
                DemoSection(".tint()", note: "改变进度条/转圈的颜色") {
                    ProgressView(value: progress)
                        .tint(.orange)
                }

                // MARK: 自定义 ProgressViewStyle
                DemoSection(
                    "自定义 ProgressViewStyle",
                    note: "实现 ProgressViewStyle 协议可以完全重写外观，configuration.fractionCompleted 是 0...1 的完成比例（不确定进度时为 nil）"
                ) {
                    ProgressView(value: progress)
                        .progressViewStyle(BadgeProgressViewStyle())
                }

                // MARK: 实战
                DemoSection("实战：模拟网络请求加载态", note: "Button 触发 Task，异步等待期间显示 ProgressView，结束后恢复正常按钮，是最常见的加载态写法") {
                    Button {
                        Task {
                            isLoading = true
                            try? await Task.sleep(for: .seconds(1.5))
                            isLoading = false
                        }
                    } label: {
                        HStack(spacing: 8) {
                            if isLoading {
                                ProgressView()
                                    .controlSize(.small)
                            }
                            Text(isLoading ? "加载中…" : "开始加载")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isLoading)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Progress View")
    }
}

#Preview {
    NavigationStack {
        ProgressViewDemo()
    }
}
