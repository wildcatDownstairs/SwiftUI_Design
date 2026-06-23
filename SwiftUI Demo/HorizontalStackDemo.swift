//
//  HorizontalStackDemo.swift
//  SwiftUI Demo
//
//  HStack 组件说明
//  HStack(alignment:spacing:) { ... } —— 子视图沿水平方向从左到右排列
//

import SwiftUI

struct HorizontalStackDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "HStack { ... } —— 默认按内容自然宽度紧凑排列，spacing 控制间距") {
                    HStack(spacing: 12) {
                        Circle().fill(.red).frame(width: 30, height: 30)
                        Circle().fill(.green).frame(width: 30, height: 30)
                        Circle().fill(.blue).frame(width: 30, height: 30)
                    }
                }

                // MARK: alignment
                DemoSection(".alignment 矩阵", note: "不同高度的子视图在垂直方向怎么对齐：top / center（默认）/ bottom / firstTextBaseline") {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("top").font(.caption).foregroundStyle(.secondary)
                        HStack(alignment: .top, spacing: 10) {
                            Rectangle().fill(.blue.opacity(0.3)).frame(width: 40, height: 60)
                            Rectangle().fill(.green.opacity(0.3)).frame(width: 40, height: 30)
                            Rectangle().fill(.orange.opacity(0.3)).frame(width: 40, height: 45)
                        }

                        Text("bottom").font(.caption).foregroundStyle(.secondary)
                        HStack(alignment: .bottom, spacing: 10) {
                            Rectangle().fill(.blue.opacity(0.3)).frame(width: 40, height: 60)
                            Rectangle().fill(.green.opacity(0.3)).frame(width: 40, height: 30)
                            Rectangle().fill(.orange.opacity(0.3)).frame(width: 40, height: 45)
                        }

                        Text("firstTextBaseline").font(.caption).foregroundStyle(.secondary)
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text("小字").font(.caption)
                            Text("大字").font(.largeTitle)
                            Text("中字").font(.title2)
                        }
                    }
                }

                // MARK: Spacer
                DemoSection("Spacer() 撑开剩余空间", note: "Spacer 会尽量占满所有剩余空间，把两侧内容推到容器边缘，是「两端对齐」最常用的写法") {
                    HStack {
                        Text("左侧")
                        Spacer()
                        Text("右侧")
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                }

                // MARK: 嵌套实现网格
                DemoSection("HStack + VStack 嵌套实现简单网格", note: "没有 Grid 的早期项目里，常用 HStack 套 VStack（或反过来）手搭网格布局") {
                    VStack(spacing: 8) {
                        ForEach(0..<2) { row in
                            HStack(spacing: 8) {
                                ForEach(0..<3) { col in
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.indigo.opacity(0.2))
                                        .frame(height: 40)
                                        .overlay(Text("\(row * 3 + col + 1)").font(.caption))
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Horizontal Stack")
    }
}

#Preview {
    NavigationStack {
        HorizontalStackDemo()
    }
}
