//
//  VerticalStackDemo.swift
//  SwiftUI Demo
//
//  VStack 组件说明
//  VStack(alignment:spacing:) { ... } —— 子视图沿垂直方向从上到下排列
//

import SwiftUI

struct VerticalStackDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "VStack { ... } —— 默认按内容自然高度紧凑排列，spacing 控制间距") {
                    VStack(spacing: 8) {
                        Text("第一行")
                        Text("第二行")
                        Text("第三行")
                    }
                }

                // MARK: alignment 矩阵
                DemoSection(".alignment 矩阵", note: "不同宽度的子视图在水平方向怎么对齐：leading / center（默认）/ trailing") {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("leading").font(.caption).foregroundStyle(.secondary)
                            Text("短").background(.blue.opacity(0.2))
                            Text("中等长度").background(.blue.opacity(0.2))
                            Text("最长的一行文字").background(.blue.opacity(0.2))
                        }
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("trailing").font(.caption).foregroundStyle(.secondary)
                            Text("短").background(.green.opacity(0.2))
                            Text("中等长度").background(.green.opacity(0.2))
                            Text("最长的一行文字").background(.green.opacity(0.2))
                        }
                    }
                }

                // MARK: Spacer
                DemoSection("Spacer() 撑开剩余空间", note: "把内容固定在顶部，剩余空间留白；常用于「标题在上，按钮永远贴底」的页面结构") {
                    VStack {
                        Text("顶部标题")
                        Spacer()
                        Button("底部按钮") {}
                            .buttonStyle(.borderedProminent)
                    }
                    .frame(height: 140)
                    .padding()
                    .background(.gray.opacity(0.08))
                }

                // MARK: 实战
                DemoSection("实战：个人信息卡片", note: "VStack 嵌套是最基础也最常用的卡片布局方式") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("张三")
                            .font(.title3.bold())
                        Text("iOS 开发工程师")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Divider()
                        Text("热爱 SwiftUI，正在学习 Swift 6 的并发模型。")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassSurface(cornerRadius: 16)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Vertical Stack")
    }
}

#Preview {
    NavigationStack {
        VerticalStackDemo()
    }
}
