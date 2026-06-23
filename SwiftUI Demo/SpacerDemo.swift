//
//  SpacerDemo.swift
//  SwiftUI Demo
//
//  Spacer 组件说明
//  Spacer() —— 在 HStack/VStack 里尽量占满所有剩余空间，把相邻内容推开
//  注意：它依赖父容器"剩余空间"的概念，单独使用或放进 ZStack 没有意义
//

import SwiftUI

struct SpacerDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法：两端对齐", note: "Spacer() 把左右内容推到容器两端，是「两端对齐」最常用的写法") {
                    HStack {
                        Text("左侧")
                        Spacer()
                        Text("右侧")
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                }

                // MARK: 多个 Spacer
                DemoSection("多个 Spacer：居中效果", note: "两端各放一个 Spacer，中间内容会被挤到正中间") {
                    HStack {
                        Spacer()
                        Text("居中内容")
                        Spacer()
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                }

                // MARK: minLength
                DemoSection(".init(minLength:)", note: "minLength 保证 Spacer 至少有这么宽，即使空间紧张也不会被压缩到 0") {
                    HStack {
                        Text("A")
                        Spacer(minLength: 40)
                        Text("B")
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                }

                // MARK: VStack 里的 Spacer
                DemoSection("在 VStack 里垂直撑开", note: "原理和 HStack 一样，只是方向变成纵向，常用来把内容固定在顶部或底部") {
                    VStack {
                        Text("顶部内容")
                        Spacer()
                        Text("底部内容")
                    }
                    .frame(height: 120)
                    .padding()
                    .background(.gray.opacity(0.1))
                }

                // MARK: 常见误用
                DemoSection(
                    "常见误用：ZStack 里放 Spacer 不能分隔兄弟视图",
                    note: "ZStack 的子视图是重叠的、不是排队的，所以 Spacer 不能像在 HStack/VStack 里那样把兄弟视图推开（它仍会参与容器尺寸计算，但起不到分隔作用），这是新手容易踩的坑"
                ) {
                    ZStack {
                        Color.gray.opacity(0.1)
                        Text("A")
                        Spacer() // 直接作为 ZStack 子视图没有任何效果，A 和 B 仍然重叠在正中间
                        Text("B")
                    }
                    .frame(height: 50)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Spacer")
    }
}

#Preview {
    NavigationStack {
        SpacerDemo()
    }
}
