//
//  LazyVGridDemo.swift
//  SwiftUI Demo
//
//  LazyVGrid 组件说明
//  LazyVGrid(columns: [GridItem]) { ... } —— 纵向滚动、横向分列的网格，子视图懒加载
//  放进 ScrollView(.vertical)（默认方向）即可纵向滚动
//

import SwiftUI

struct LazyVGridDemo: View {
    private let fixedColumns = [GridItem(.fixed(70)), GridItem(.fixed(70)), GridItem(.fixed(70))]
    private let flexibleColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 60))]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法（固定列宽，三列）", note: "columns: [GridItem(.fixed(70)), ...] —— 三列固定宽度，内容纵向铺开，超出高度自动纵向滚动") {
                    LazyVGrid(columns: fixedColumns, spacing: 10) {
                        ForEach(0..<9, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.blue.opacity(0.25))
                                .frame(height: 60)
                                .overlay(Text("\(index)"))
                        }
                    }
                }

                // MARK: flexible
                DemoSection(".flexible() 弹性等分", note: "三个 .flexible() 会平均分配可用宽度，常用于「每行固定 N 列，自动适配屏幕宽度」") {
                    LazyVGrid(columns: flexibleColumns, spacing: 10) {
                        ForEach(0..<6, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.green.opacity(0.25))
                                .frame(height: 50)
                                .overlay(Text("\(index)"))
                        }
                    }
                }

                // MARK: adaptive
                DemoSection(".adaptive() 自适应列数", note: "只给一个 GridItem(.adaptive(minimum: 60))，系统会自动算出当前宽度能塞下几列，每列至少 60pt") {
                    LazyVGrid(columns: adaptiveColumns, spacing: 8) {
                        ForEach(0..<11, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.orange.opacity(0.25))
                                .frame(height: 44)
                                .overlay(Text("\(index)").font(.caption))
                        }
                    }
                }

                // MARK: GridItem 的 alignment
                DemoSection(
                    "GridItem(alignment:) 单元格内对齐",
                    note: "GridItem 自己也带一个 alignment（Alignment 类型），当列宽大于内容本身宽度时，决定内容在格子里贴左/居中/贴右"
                ) {
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach([("leading", Alignment.leading), ("center", .center), ("trailing", .trailing)], id: \.0) { label, alignment in
                            Text(label).font(.caption).foregroundStyle(.secondary)
                            LazyVGrid(columns: [GridItem(.flexible(), alignment: alignment)], spacing: 4) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.purple.opacity(0.3))
                                    .frame(width: 40, height: 30)
                            }
                            .background(.gray.opacity(0.08))
                        }
                    }
                }

                // MARK: pinnedViews
                DemoSection(
                    "pinnedViews 纵向吸顶分组",
                    note: "LazyVGrid 同样支持 pinnedViews: [.sectionHeaders]，配合 Section 让分组标题纵向滚动时吸附在顶部"
                ) {
                    ScrollView {
                        LazyVGrid(columns: flexibleColumns, pinnedViews: [.sectionHeaders]) {
                            Section {
                                ForEach(0..<6, id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.mint.opacity(0.3))
                                        .frame(height: 44)
                                        .overlay(Text("\(i)").font(.caption2))
                                }
                            } header: {
                                Text("分组标题")
                                    .font(.caption.bold())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 4)
                                    .background(Color(uiColor: .systemBackground))
                            }
                        }
                    }
                    .frame(height: 180)
                }

                // MARK: 实战
                DemoSection("实战：图片网格", note: "三列等宽网格 + 正方形裁切，是相册/商品列表类 App 最常见的网格布局") {
                    LazyVGrid(columns: flexibleColumns, spacing: 6) {
                        ForEach(0..<9, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.gray.opacity(0.25))
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
                        }
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Lazy Vertical Grid")
    }
}

#Preview {
    NavigationStack {
        LazyVGridDemo()
    }
}
