//
//  ViewThatFitsDemo.swift
//  SwiftUI Demo
//
//  ViewThatFits 组件说明（iOS 16+）
//  ViewThatFits { 视图A; 视图B; 视图C } —— 按声明顺序依次测量，选第一个能在可用空间内完整显示的子视图，
//  如果都放不下，就用最后一个（通常放最紧凑的版本兜底）
//

import SwiftUI

struct ViewThatFitsDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection(
                    "基础用法：自动选择能放下的版本",
                    note: "三个候选视图从长到短排列，ViewThatFits 会自动挑第一个不溢出的——拖动下方滑杆改变可用宽度试试"
                ) {
                    WidthAdjustableExample()
                }

                // MARK: axis 参数
                DemoSection(".init(in:) 指定测量方向", note: "默认同时测量横纵两个方向；也可以指定只测量 .horizontal 或 .vertical，更精确地控制判断依据") {
                    Text("ViewThatFits(in: .horizontal) { ... } —— 只关心宽度够不够，不管高度")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                // MARK: 实战
                DemoSection(
                    "实战：按钮文案根据空间自动精简",
                    note: "工具栏空间不够时自动从「完整文字」退化到「纯图标」，不需要自己写宽度判断逻辑"
                ) {
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text("宽工具栏（160pt）")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Button {
                            } label: {
                                ViewThatFits {
                                    Label("添加到收藏夹", systemImage: "star.fill")
                                    Label("收藏", systemImage: "star.fill")
                                    Image(systemName: "star.fill")
                                }
                                .frame(width: 160)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                        }

                        VStack(spacing: 8) {
                            Text("窄工具栏（60pt）")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Button {
                            } label: {
                                ViewThatFits {
                                    Label("添加到收藏夹", systemImage: "star.fill")
                                    Label("收藏", systemImage: "star.fill")
                                    Image(systemName: "star.fill")
                                }
                                .frame(width: 60)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("View That Fits")
    }
}

private struct WidthAdjustableExample: View {
    @State private var width: Double = 300

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ViewThatFits {
                Text("这是一段完整的、很长的说明文字")
                Text("较短说明")
                Image(systemName: "ellipsis.circle.fill")
            }
            .frame(width: width, alignment: .leading)
            .padding(8)
            .background(.blue.opacity(0.1))

            Slider(value: $width, in: 40...320)
            Text("可用宽度：\(Int(width))pt")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ViewThatFitsDemo()
    }
}
