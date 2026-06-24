//
//  ListViewDemo.swift
//  SwiftUI Demo
//
//  Created by 乐可 on 2026/06/21.
//

import SwiftUI

struct SwipeDeleteCard<Content: View>: View {
    @State private var offset: CGFloat = 0
    // 手势开始时的基准偏移，拖动过程中不变，避免和 offset 自身相加导致跳动
    @State private var baseOffset: CGFloat = 0
    private let actionWidth: CGFloat = 80
    let content: Content
    let onDelete: () -> Void

    init(onDelete: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.onDelete = onDelete
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            // 深色操作层铺满整张卡片底部；只给右侧（screen 边缘那一侧）留圆角，
            // 跟白色面板交接的左侧保持直角，交接处的弧线完全由白色面板自己的圆角画出来
            Button(action: onDelete) {
                Text("削除")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, (actionWidth - 28) / 2)
                    .frame(maxHeight: .infinity)
            }
            .background(Color(red: 0.06, green: 0.09, blue: 0.16))
            .clipShape(
                .rect(
                    topLeadingRadius: 16, bottomLeadingRadius: 16,
                    bottomTrailingRadius: 16, topTrailingRadius: 16
                )
            )

            content
                .background(Color.white)
                .clipShape(
                    .rect(
                        topLeadingRadius: 16, bottomLeadingRadius: 16,
                        bottomTrailingRadius: 8, topTrailingRadius: 8
                    )
                )
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = min(0, max(-actionWidth, baseOffset + value.translation.width))
                        }
                        .onEnded { value in
                            let isOpen = offset < -actionWidth / 2
                            // 把这个最终的跳变包成一个弹簧动画，而不是瞬间跳过去
                            withAnimation(.spring(response: 0.3)) {
                                offset = isOpen ? -actionWidth : 0
                            }
                            baseOffset = isOpen ? -actionWidth : 0
                        }
                )
            // 不裁剪整个 ZStack——否则白色面板往左滑出这一行原本的边界时，
            // 会被这层裁剪直接砍掉，盖不住左边的留白区域
        }
    }
}

// 白色面板
struct AddressCardView: View {
    let name: String
    let isMain: Bool
    let postalCode: String
    let prefecture: String
    let detail: String
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(name).font(.headline)
                if isMain {
                    Text("メイン")
                        .font(.caption)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .clipShape(Capsule())
                }
                Spacer()
                Button(action: onEdit) {
                    Image(systemName: "square.and.pencil")
                }
            }
            Text("\(postalCode)　\(prefecture)")
                .foregroundColor(.secondary)
            Text(detail)
        }
        .padding(16)
    }
}

// 渲染白色面板内容的数据结构
struct Address: Identifiable {
    let id = UUID()
    let name: String
    let isMain: Bool
    let postalCode: String
    let prefecture: String
    let detail: String
}

// mock 数据列表
struct AddressListView: View {
    @State private var addresses = [
        Address(name: "田中 太郎", isMain: true, postalCode: "105-0046", prefecture: "東京都", detail: "渋谷道玄坂2丁目2番地25山田山田山田ビール108号"),
        Address(name: "TANAKATAROU", isMain: false, postalCode: "354-0048", prefecture: "埼玉県", detail: "渋谷道玄坂2丁目2番地25山田山田山田ビール108号"),
        Address(name: "TANAKATAROU", isMain: false, postalCode: "354-0048", prefecture: "埼玉県", detail: "渋谷道玄坂2丁目2番地25山田山田山田ビール108号"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(addresses) { address in
                    SwipeDeleteCard(onDelete: { addresses.removeAll { $0.id == address.id } }) {
                        AddressCardView(
                            name: address.name, isMain: address.isMain,
                            postalCode: address.postalCode, prefecture: address.prefecture, detail: address.detail,
                            onEdit: { /* 跳转编辑 */ }
                        )
                    }
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
                }

                Button(action: { /* 新增逻辑 */ }) {
                    Label("住所を追加", systemImage: "plus")
                        .font(.subheadline.bold())
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("住所リスト")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            AddressListView()
        }
    }
}

#Preview {
    ContentView()
}
