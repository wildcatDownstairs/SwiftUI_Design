//
//  LiquidGlassDemo.swift
//  SwiftUI Demo
//
//  Liquid Glass 组件说明（iOS 26+）
//  .glassEffect(_:in:) —— 给任意 View 套上"液态玻璃"材质，自带模糊/折射/高光
//  GlassEffectContainer —— 把多个玻璃形状放进同一个容器，彼此靠近时会自动融合
//  Glass 类型支持 .regular / .clear，可链式调用 .tint() / .interactive()
//  .buttonStyle(.glass) / .glassProminent —— 系统新增的两种玻璃按钮样式
//

import SwiftUI

struct LiquidGlassDemo: View {
    @State private var isExpanded = false
    @Namespace private var glassNamespace

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection(
                    "基础用法",
                    note: ".glassEffect() —— 默认是 .regular 玻璃 + 胶囊形状，让内容呈现毛玻璃质感，带光线折射效果"
                ) {
                    Image(systemName: "star.fill")
                        .font(.title)
                        .padding(20)
                        .glassEffect()
                }

                // MARK: 形状矩阵
                DemoSection(
                    ".glassEffect(in:) 形状矩阵",
                    note: "可以指定玻璃的轮廓形状：.capsule（默认）/ .circle / 自定义 RoundedRectangle"
                ) {
                    HStack(spacing: 20) {
                        Text("胶囊")
                            .padding()
                            .glassEffect(.regular, in: .capsule)
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .padding(16)
                            .glassEffect(.regular, in: .circle)
                        Text("圆角矩形")
                            .padding()
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                    }
                }

                // MARK: tint
                DemoSection(
                    ".tint() 玻璃染色",
                    note: "Glass.tint(_:) 给玻璃材质叠加一层颜色，模糊/折射效果保留，常用来呼应品牌色或语义色"
                ) {
                    HStack(spacing: 16) {
                        Image(systemName: "bolt.fill")
                            .font(.title2)
                            .padding(16)
                            .glassEffect(.regular.tint(.orange), in: .circle)
                        Image(systemName: "drop.fill")
                            .font(.title2)
                            .padding(16)
                            .glassEffect(.regular.tint(.blue), in: .circle)
                    }
                }

                // MARK: interactive
                DemoSection(
                    ".interactive() 交互反馈",
                    note: "Glass.interactive() 让玻璃在点击时带缩放/弹性/高光的物理反馈，常配合 Button 使用"
                ) {
                    Button {
                    } label: {
                        Label("点我试试", systemImage: "hand.tap.fill")
                            .padding()
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive(), in: .capsule)
                }

                // MARK: regular vs clear
                DemoSection(
                    "regular vs clear",
                    note: "regular 是标准毛玻璃（带模糊和折射）；clear 几乎透明、几乎不模糊，适合叠加在已经很有视觉冲击力的背景上"
                ) {
                    HStack(spacing: 16) {
                        VStack(spacing: 6) {
                            Text("regular").font(.caption).foregroundStyle(.white)
                            Text("Aa").font(.title).padding().glassEffect(.regular, in: .circle)
                        }
                        VStack(spacing: 6) {
                            Text("clear").font(.caption).foregroundStyle(.white)
                            Text("Aa").font(.title).padding().glassEffect(.clear, in: .circle)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [.purple, .pink], startPoint: .top, endPoint: .bottom))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                // MARK: GlassEffectContainer
                DemoSection(
                    "GlassEffectContainer 合并效果",
                    note: "把多个 .glassEffect() 视图包进同一个 GlassEffectContainer，彼此靠近时会自动融合成一片，这是单独使用 .glassEffect() 做不到的"
                ) {
                    GlassEffectContainer(spacing: 20) {
                        HStack(spacing: 20) {
                            Image(systemName: "play.fill")
                                .font(.title2)
                                .padding(16)
                                .glassEffect()
                            Image(systemName: "pause.fill")
                                .font(.title2)
                                .padding(16)
                                .glassEffect()
                            Image(systemName: "stop.fill")
                                .font(.title2)
                                .padding(16)
                                .glassEffect()
                        }
                    }
                }

                // MARK: glassEffectID 形变
                DemoSection(
                    "glassEffectID + Namespace 形变过渡",
                    note: "配合 @Namespace 给玻璃形状打上 id，状态切换时玻璃会平滑地从一个形状「流动」变形到另一个形状，而不是简单淡入淡出"
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        GlassEffectContainer {
                            if isExpanded {
                                HStack(spacing: 16) {
                                    Image(systemName: "magnifyingglass")
                                        .padding()
                                        .glassEffect()
                                        .glassEffectID("icon", in: glassNamespace)
                                    Text("展开的搜索框")
                                        .padding()
                                        .glassEffect()
                                }
                            } else {
                                Image(systemName: "magnifyingglass")
                                    .padding()
                                    .glassEffect()
                                    .glassEffectID("icon", in: glassNamespace)
                            }
                        }
                        Button(isExpanded ? "收起" : "展开") {
                            withAnimation { isExpanded.toggle() }
                        }
                        .buttonStyle(.bordered)
                    }
                }

                // MARK: buttonStyle
                DemoSection(
                    ".buttonStyle(.glass) / .glassProminent",
                    note: "iOS 26 新增的两个按钮样式：.glass 是次要操作用的半透明玻璃按钮；.glassProminent 是主操作用的不透明玻璃按钮"
                ) {
                    HStack(spacing: 16) {
                        Button("次要操作") {}
                            .buttonStyle(.glass)
                        Button("主操作") {}
                            .buttonStyle(.glassProminent)
                    }
                }

                // MARK: 实战
                DemoSection(
                    "实战：浮动工具栏",
                    note: "GlassEffectContainer + 多个玻璃按钮，是 iOS 26 系统 App（地图、照片）里浮动工具栏的典型实现方式"
                ) {
                    GlassEffectContainer(spacing: 16) {
                        HStack(spacing: 16) {
                            Button { } label: { Image(systemName: "location.fill") }
                                .buttonStyle(.glass)
                            Button { } label: { Image(systemName: "layers.fill") }
                                .buttonStyle(.glass)
                            Button { } label: { Image(systemName: "ellipsis") }
                                .buttonStyle(.glassProminent)
                        }
                        .font(.title3)
                        .padding(8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [.green, .teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                // MARK: 实战：App Store 风格导航
                DemoSection(
                    "实战：App Store 风格的底部导航 + 顶部搜索",
                    note: "Tab(role: .search) 让搜索 Tab 自动跟其他 Tab 视觉分离，点击后展开成顶部搜索框；.tabBarMinimizeBehavior(.onScrollDown) 让底部 Tab 栏随内容下滑自动收起、上滑恢复——这是 iOS 26 系统 App（App Store / 音乐 / Safari）最典型的导航形态。TabView 是全屏级容器，跳到独立页面演示，不塞进卡片"
                ) {
                    NavigationLink("查看示例") { AppStoreStyleNavExample() }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Liquid Glass")
    }
}

private struct AppStoreStyleNavExample: View {
    @State private var searchText = ""

    private let allApps = ["微信", "支付宝", "抖音", "小红书", "豆瓣", "网易云音乐"]

    private var searchResults: [String] {
        searchText.isEmpty ? allApps : allApps.filter { $0.contains(searchText) }
    }

    var body: some View {
        TabView {
            Tab("今日", systemImage: "doc.text.image") {
                NavigationStack {
                    List(0..<20, id: \.self) { i in
                        Text("精选内容 \(i)")
                    }
                    .navigationTitle("今日")
                }
            }
            Tab("App", systemImage: "square.grid.2x2") {
                NavigationStack {
                    List(0..<20, id: \.self) { i in
                        Text("App \(i)")
                    }
                    .navigationTitle("App")
                }
            }
            Tab("游戏", systemImage: "gamecontroller") {
                NavigationStack {
                    List(0..<20, id: \.self) { i in
                        Text("游戏 \(i)")
                    }
                    .navigationTitle("游戏")
                }
            }
            Tab(role: .search) {
                NavigationStack {
                    List(searchResults, id: \.self) { item in
                        Text(item)
                    }
                    .navigationTitle("搜索")
                }
                .searchable(text: $searchText, prompt: "搜索 App")
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    NavigationStack {
        LiquidGlassDemo()
    }
}
