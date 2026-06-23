//
//  TabViewDemo.swift
//  SwiftUI Demo
//
//  TabView 组件说明
//  TabView 和 NavigationStack 一样是"全屏级容器"，硬塞进小卡片会渲染异常，
//  所以这里用 List + NavigationLink 跳到独立全屏示例页来演示。
//

import SwiftUI
import Combine

struct TabViewDemo: View {
    var body: some View {
        List {
            Section("基础用法（.tabItem）") {
                NavigationLink("查看示例") { ClassicTabExample() }
                Text(".tabItem { Label(...) } —— iOS 16 及之前的经典写法，每个子视图配一个 tabItem")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("现代写法（Tab，iOS 18+）") {
                NavigationLink("查看示例") { ModernTabExample() }
                Text("TabView { Tab(\"标题\", systemImage: \"...\") { ... } } —— 新语法更接近声明式列表") .font(.caption).foregroundStyle(.secondary)
            }

            Section("selection 绑定（.tabItem 旧写法）") {
                NavigationLink("查看示例") { SelectionTabExample() }
                Text("TabView(selection:) 配合外部按钮可以编程式切换到指定 Tab")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("selection 绑定（Tab(value:) 现代写法，iOS 18+）") {
                NavigationLink("查看示例") { ModernSelectionTabExample() }
                Text("每个 Tab 直接声明 value:，selection 绑定枚举而不是 Int，类型更安全，也是官方现在推荐的写法")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section("badge 徽标") {
                NavigationLink("查看示例") { BadgeTabExample() }
                Text(".badge(数字/字符串) 加在 tabItem 上，显示未读消息这类小红点数字")
                    .font(.caption).foregroundStyle(.secondary)
            }

            Section(".tabViewStyle(.page) 翻页样式") {
                NavigationLink("查看示例") { PageStyleTabExample() }
                Text("page 样式把 Tab 切换变成左右滑动翻页，常用于引导页/相册浏览") .font(.caption).foregroundStyle(.secondary)
            }

            Section("实战：仿抖音上下滑动 Feed") {
                NavigationLink("查看示例") { TikTokFeedExample() }
                Text("ScrollView + .scrollTargetBehavior(.paging) 实现纵向分页（比 TabView 旋转 90 度的老技巧更可靠），叠加点赞 / 文案展开 / 进度条拖动 / 顶部搜索栏，模拟完整的短视频体验")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Tab View")
    }
}

private struct ClassicTabExample: View {
    var body: some View {
        TabView {
            Text("首页内容")
                .tabItem { Label("首页", systemImage: "house") }
            Text("收藏内容")
                .tabItem { Label("收藏", systemImage: "star") }
            Text("我的内容")
                .tabItem { Label("我的", systemImage: "person") }
        }
    }
}

private struct ModernTabExample: View {
    var body: some View {
        TabView {
            Tab("首页", systemImage: "house") {
                Text("首页内容")
            }
            Tab("收藏", systemImage: "star") {
                Text("收藏内容")
            }
            Tab("我的", systemImage: "person") {
                Text("我的内容")
            }
        }
    }
}

private struct SelectionTabExample: View {
    @State private var selection = 0

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("跳到首页") { selection = 0 }
                Button("跳到我的") { selection = 2 }
            }
            .buttonStyle(.bordered)
            .padding()

            TabView(selection: $selection) {
                Text("首页内容").tabItem { Label("首页", systemImage: "house") }.tag(0)
                Text("收藏内容").tabItem { Label("收藏", systemImage: "star") }.tag(1)
                Text("我的内容").tabItem { Label("我的", systemImage: "person") }.tag(2)
            }
        }
    }
}

private struct ModernSelectionTabExample: View {
    private enum Page: Hashable {
        case home, favorites, profile
    }

    @State private var selection: Page = .home

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("跳到首页") { selection = .home }
                Button("跳到我的") { selection = .profile }
            }
            .buttonStyle(.bordered)
            .padding()

            TabView(selection: $selection) {
                Tab("首页", systemImage: "house", value: .home) {
                    Text("首页内容")
                }
                Tab("收藏", systemImage: "star", value: .favorites) {
                    Text("收藏内容")
                }
                Tab("我的", systemImage: "person", value: .profile) {
                    Text("我的内容")
                }
            }
        }
    }
}

private struct BadgeTabExample: View {
    var body: some View {
        TabView {
            Text("首页内容")
                .tabItem { Label("首页", systemImage: "house") }
            Text("消息内容")
                .tabItem { Label("消息", systemImage: "message") }
                .badge(5)
            Text("我的内容")
                .tabItem { Label("我的", systemImage: "person") }
                .badge("新")
        }
    }
}

private struct PageStyleTabExample: View {
    var body: some View {
        TabView {
            Color.red.opacity(0.3).overlay(Text("第一页"))
            Color.green.opacity(0.3).overlay(Text("第二页"))
            Color.blue.opacity(0.3).overlay(Text("第三页"))
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

// MARK: - 实战：仿抖音上下滑动 Feed

private struct VideoPost: Identifiable {
    let id = UUID()
    let username: String
    let caption: String
    let musicName: String
    let likeCount: Int
    let commentCount: Int
    let colors: [Color]
}

private let videoPosts: [VideoPost] = [
    VideoPost(
        username: "@coder_lily",
        caption: "用 SwiftUI 写了一个仿抖音的上下滑动效果，核心是 ScrollView 的 .scrollTargetBehavior(.paging) 分页 #SwiftUI #iOS开发 #编程日常",
        musicName: "原声 - coder_lily",
        likeCount: 12453,
        commentCount: 342,
        colors: [.purple, .indigo]
    ),
    VideoPost(
        username: "@travel_ken",
        caption: "today's sunset 🌅 随手记录今天傍晚的海边日落，超治愈",
        musicName: "夏日漫游 - 未知艺术家",
        likeCount: 8821,
        commentCount: 156,
        colors: [.orange, .pink]
    ),
    VideoPost(
        username: "@chef_amy",
        caption: "30 秒教你做一道家常菜，简单又好吃，赶紧学起来吧～",
        musicName: "厨房欢乐颂 - Amy 的小厨房",
        likeCount: 20934,
        commentCount: 901,
        colors: [.green, .teal]
    ),
]

// 注：经典的"把 TabView 整体转 90 度"实现纵向分页的技巧，实测尺寸换算很容易出错
// （转出屏幕外、内容空白），连 Apple 开发者论坛里都提到这个技巧不如系统应用可靠。
// 改用 iOS 17+ 官方支持的 ScrollView 分页方案：.scrollTargetBehavior(.paging) +
// .containerRelativeFrame，效果一样，但是官方 API，不需要旋转戏法。
private struct TikTokFeedExample: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(videoPosts) { post in
                    VideoPageView(post: post)
                        .containerRelativeFrame(.vertical)
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .background(Color.black)
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct VideoPageView: View {
    let post: VideoPost

    @State private var isLiked = false
    @State private var isCaptionExpanded = false
    @State private var progress: Double = 0
    @State private var isDraggingProgress = false

    var body: some View {
        ZStack(alignment: .bottom) {
                // 模拟视频画面：用渐变 + 半透明大图标代替真实视频
                LinearGradient(colors: post.colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(.white.opacity(0.2))
                    )
                    .ignoresSafeArea()

                // 顶部：关注/推荐 切换 + 搜索
                VStack {
                    HStack(spacing: 20) {
                        Text("关注")
                            .foregroundStyle(.white.opacity(0.7))
                        VStack(spacing: 4) {
                            Text("推荐")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            Capsule().fill(.white).frame(width: 18, height: 2)
                        }
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white)
                            .font(.body.weight(.semibold))
                    }
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.top, 54)

                    Spacer()
                }

                // 右侧：头像 + 点赞/评论/分享
                VStack(spacing: 22) {
                    Circle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 46, height: 46)
                        .overlay(Image(systemName: "person.fill").foregroundStyle(.white))

                    VStack(spacing: 4) {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                isLiked.toggle()
                            }
                        } label: {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundStyle(isLiked ? .red : .white)
                                .scaleEffect(isLiked ? 1.15 : 1)
                        }
                        Text("\(post.likeCount + (isLiked ? 1 : 0))")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 4) {
                        Image(systemName: "bubble.right.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                        Text("\(post.commentCount)")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.right.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                        Text("分享")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 14)
                .padding(.bottom, 96)

                // 底部：用户名/文案（点击展开） + 音乐 + 进度条
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(post.username)
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                        Text(post.caption)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .lineLimit(isCaptionExpanded ? nil : 1)
                            .onTapGesture {
                                withAnimation { isCaptionExpanded.toggle() }
                            }
                        HStack(spacing: 4) {
                            Image(systemName: "music.note")
                                .font(.caption2)
                            Text(post.musicName)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(.trailing, 56)

                    // 可拖动的播放进度条
                    GeometryReader { barGeo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.3)).frame(height: 3)
                            Capsule().fill(.white).frame(width: barGeo.size.width * progress, height: 3)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    isDraggingProgress = true
                                    let ratio = min(max(value.location.x / barGeo.size.width, 0), 1)
                                    progress = ratio
                                }
                                .onEnded { _ in
                                    isDraggingProgress = false
                                }
                        )
                    }
                    .frame(height: 20)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
        }
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) { _ in
            guard !isDraggingProgress else { return }
            progress += 0.05 / 8
            if progress >= 1 { progress = 0 }
        }
    }
}

#Preview {
    NavigationStack {
        TabViewDemo()
    }
}
