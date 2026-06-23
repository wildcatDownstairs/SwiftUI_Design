//
//  LazyHGridDemo.swift
//  SwiftUI Demo
//
//  LazyHGrid 组件说明
//  LazyHGrid(rows: [GridItem]) { ... } —— 横向滚动、纵向分行的网格，只在子视图即将可见时才创建（懒加载）
//  必须放进 ScrollView(.horizontal) 才能横向滚动
//

import SwiftUI

struct LazyHGridDemo: View {
    private let rows = [GridItem(.fixed(60)), GridItem(.fixed(60))]
    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .teal, .indigo, .mint]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法（固定行高，两行）", note: "rows: [GridItem(.fixed(60)), GridItem(.fixed(60))] —— 两行固定高度，内容横向铺开，超出宽度自动横向滚动") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: rows, spacing: 10) {
                            ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(color.opacity(0.4))
                                    .frame(width: 60)
                                    .overlay(Text("\(index)"))
                            }
                        }
                        .frame(height: 140)
                    }
                }

                // MARK: GridItem 类型
                DemoSection("GridItem 三种类型", note: ".fixed 固定尺寸；.flexible 弹性拉伸；.adaptive 根据可用空间自动决定行数") {
                    Text(".fixed(60)     —— 固定 60pt\n.flexible()     —— 平均分配剩余空间\n.adaptive(minimum: 40) —— 尽量塞下更多行，每行至少 40pt")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                // MARK: alignment
                DemoSection(
                    "alignment 参数",
                    note: "当 rows 总高度小于外部分配的高度时，alignment（VerticalAlignment）决定行组贴顶/居中/贴底，默认 .center"
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach([("top", VerticalAlignment.top), ("center", .center), ("bottom", .bottom)], id: \.0) { label, alignment in
                            Text(label).font(.caption).foregroundStyle(.secondary)
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem(.fixed(40))], alignment: alignment, spacing: 8) {
                                    ForEach(0..<6, id: \.self) { i in
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(.blue.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                            .overlay(Text("\(i)").font(.caption2))
                                    }
                                }
                                .frame(height: 90)
                            }
                            .background(.gray.opacity(0.08))
                        }
                    }
                }

                // MARK: pinnedViews
                DemoSection(
                    "pinnedViews 横向吸顶分组",
                    note: "LazyHGrid 同样支持 pinnedViews: [.sectionHeaders]，配合 Section 让分组标题横向滚动时吸附在最前面"
                ) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.fixed(50)), GridItem(.fixed(50))], pinnedViews: [.sectionHeaders]) {
                            Section {
                                ForEach(0..<8, id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.green.opacity(0.25))
                                        .frame(width: 50)
                                        .overlay(Text("\(i)").font(.caption2))
                                }
                            } header: {
                                Text("分组")
                                    .font(.caption.bold())
                                    .frame(width: 40, height: 108)
                                    .background(Color(uiColor: .systemBackground))
                            }
                        }
                        .frame(height: 110)
                    }
                }

                // MARK: 实战
                DemoSection("实战：相册横向缩略图网格", note: "两行 LazyHGrid 横向滚动，是相册类 App「按日期横滑浏览缩略图」的常见布局") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.fixed(70)), GridItem(.fixed(70))], spacing: 6) {
                            ForEach(0..<14, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.gray.opacity(0.25))
                                    .frame(width: 70)
                                    .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
                            }
                        }
                        .frame(height: 150)
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Lazy Horizontal Grid")
    }
}

#Preview {
    NavigationStack {
        LazyHGridDemo()
    }
}
