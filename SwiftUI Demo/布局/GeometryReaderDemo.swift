//
//  GeometryReaderDemo.swift
//  SwiftUI Demo
//
//  GeometryReader 组件说明
//  GeometryReader { geo in ... } —— 读取父容器分配给自己的尺寸/位置/安全区信息，
//  注意：它默认会贪婪占满父容器分配的所有可用空间，这是最常见的布局坑。
//

import SwiftUI

struct GeometryReaderDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法：读取尺寸", note: "GeometryReader { geo in ... }，geo.size.width / geo.size.height 是父容器分配给它的宽高") {
                    GeometryReader { geo in
                        Text("宽 \(Int(geo.size.width)) × 高 \(Int(geo.size.height))")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.blue.opacity(0.15))
                    }
                    .frame(height: 60)
                }

                // MARK: 贪婪占满的坑
                DemoSection(
                    "常见坑：默认贪婪占满空间",
                    note: "不给 GeometryReader 任何 frame 限制时，它会尽量撑满父容器分配的全部空间，哪怕内容很小——下面这个例子如果没有 .frame(height:)，会占满一整屏"
                ) {
                    GeometryReader { geo in
                        Text("我被限制在 80pt 高度内")
                    }
                    .frame(height: 80)
                    .background(.orange.opacity(0.15))
                }

                // MARK: 响应式布局
                DemoSection(
                    "响应式布局：根据宽度切换排列方向",
                    note: "用 geo.size.width 判断当前可用宽度，决定用 HStack 还是 VStack 排列子视图，是「自适应布局」最基础的实现思路"
                ) {
                    GeometryReader { geo in
                        Group {
                            if geo.size.width > 300 {
                                HStack {
                                    colorBlock(.red, "宽")
                                    colorBlock(.green, "屏")
                                    colorBlock(.blue, "横排")
                                }
                            } else {
                                VStack {
                                    colorBlock(.red, "窄")
                                    colorBlock(.green, "屏")
                                    colorBlock(.blue, "竖排")
                                }
                            }
                        }
                    }
                    .frame(height: 140)
                }

                // MARK: safeAreaInsets
                DemoSection(
                    "geo.safeAreaInsets",
                    note: "EdgeInsets 类型，告诉你当前区域被状态栏/导航栏/Home Indicator 占用了多少空间；只有视图忽略了安全区（.ignoresSafeArea()）时这些值才会非零"
                ) {
                    GeometryReader { geo in
                        Text("top: \(Int(geo.safeAreaInsets.top))  bottom: \(Int(geo.safeAreaInsets.bottom))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(height: 30)
                }

                // MARK: frame(in:) 命名坐标空间
                DemoSection(
                    "frame(in:) + 命名坐标空间",
                    note: "geo.frame(in: .named(\"...\")) 读取相对于某个具名祖先容器（用 .coordinateSpace(name:) 标记）的位置，而不是相对于整个屏幕——常用来判断子视图是否滚动到了特定区域"
                ) {
                    ScrollView {
                        VStack(spacing: 60) {
                            ForEach(0..<5, id: \.self) { i in
                                GeometryReader { geo in
                                    let minY = geo.frame(in: .named("scrollArea")).minY
                                    Text("第 \(i) 项  minY: \(Int(minY))")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(6)
                                        .background(minY > 0 && minY < 150 ? Color.green.opacity(0.25) : Color.clear)
                                }
                                .frame(height: 30)
                            }
                        }
                    }
                    .frame(height: 200)
                    .coordinateSpace(name: "scrollArea")
                }

                // MARK: 用 background 读取尺寸而不占用布局
                DemoSection(
                    "用 .background() 读取尺寸（不影响布局）",
                    note: "直接用 GeometryReader 包裹内容会让它决定内容尺寸；放进 .background() 里则只是「偷看」尺寸，不改变原有布局"
                ) {
                    Text("这段文字的真实尺寸不受 GeometryReader 影响")
                        .padding()
                        .background(
                            GeometryReader { geo in
                                Color.purple.opacity(0.15)
                                    .overlay(
                                        Text("\(Int(geo.size.width))×\(Int(geo.size.height))")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary),
                                        alignment: .bottomTrailing
                                    )
                            }
                        )
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Geometry Reader")
    }

    @ViewBuilder
    private func colorBlock(_ color: Color, _ text: String) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color.opacity(0.3))
            .overlay(Text(text).font(.caption))
    }
}

#Preview {
    NavigationStack {
        GeometryReaderDemo()
    }
}
