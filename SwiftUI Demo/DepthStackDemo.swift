//
//  DepthStackDemo.swift
//  SwiftUI Demo
//
//  "Depth Stack" 对应 SwiftUI 里的 ZStack —— 三个方向的堆叠容器里唯一往"屏幕外"（Z 轴）叠的一个，
//  VStack/HStack 是在 X/Y 轴排布，ZStack 是让子视图直接重叠在同一块区域，所以设计工具里把它叫"深度堆叠"。
//

import SwiftUI

struct DepthStackDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "ZStack { ... } —— 子视图按声明顺序重叠堆放，后写的在上层") {
                    ZStack {
                        Circle().fill(.blue.opacity(0.3)).frame(width: 100, height: 100)
                        Circle().fill(.green.opacity(0.5)).frame(width: 60, height: 60)
                        Text("最上层")
                    }
                }

                // MARK: alignment
                DemoSection("alignment 参数", note: "默认 .center 居中堆叠；可以改成 .topLeading 等让子视图对齐到某个角") {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12).fill(.orange.opacity(0.3)).frame(width: 140, height: 90)
                        Text("左上角标签")
                            .font(.caption)
                            .padding(6)
                            .background(.orange)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(8)
                    }
                }

                // MARK: zIndex
                DemoSection(".zIndex()", note: "默认堆叠顺序就是代码书写顺序；想让某层临时浮到最上面，用 zIndex 显式指定，数值越大越靠上") {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(.red.opacity(0.4))
                            .frame(width: 100, height: 100)
                            .zIndex(0)
                        RoundedRectangle(cornerRadius: 12).fill(.blue.opacity(0.4))
                            .frame(width: 100, height: 100)
                            .offset(x: 30, y: 30)
                            .zIndex(-1)
                        Text("红色在上（因为蓝色 zIndex 更小）")
                            .font(.caption2)
                            .offset(y: 70)
                    }
                    .frame(height: 150)
                }

                // MARK: 实战
                DemoSection("实战：头像 + 在线状态角标", note: "ZStack(alignment:) 叠加一个小圆点，是社交类 App 头像「在线/离线」角标的典型写法") {
                    HStack(spacing: 20) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle().fill(.gray.opacity(0.3)).frame(width: 56, height: 56)
                                .overlay(Image(systemName: "person.fill").foregroundStyle(.secondary))
                            Circle()
                                .fill(.green)
                                .frame(width: 16, height: 16)
                                .overlay(Circle().strokeBorder(.white, lineWidth: 2))
                        }

                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 10).fill(.blue.opacity(0.15))
                                .frame(width: 56, height: 56)
                                .overlay(Image(systemName: "bell.fill").foregroundStyle(.blue))
                            Text("9")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .padding(5)
                                .background(.red)
                                .clipShape(Circle())
                                .offset(x: 6, y: -6)
                        }
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Depth Stack")
    }
}

#Preview {
    NavigationStack {
        DepthStackDemo()
    }
}
