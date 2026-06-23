//
//  SignInWithAppleButtonDemo.swift
//  SwiftUI Demo
//
//  SignInWithAppleButton 组件说明（来自 AuthenticationServices 框架）
//  注意：要让点击真正跑通登录流程，项目需要在 Signing & Capabilities 里开启
//  "Sign in with Apple" 能力，否则点击会在 onCompletion 里收到错误。
//  这里只演示按钮本身的外观和参数，不依赖真实登录态。
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonDemo: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "SignInWithAppleButton(.signIn) { request in ... } onCompletion: { result in ... }") {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success: print("登录成功")
                        case .failure(let error): print("登录失败：\(error.localizedDescription)")
                        }
                    }
                    .frame(height: 44)
                }

                // MARK: type 矩阵
                DemoSection("type 矩阵", note: ".signIn / .signUp / .continue —— 按钮上的文案会随之变化（登录/注册/继续）") {
                    VStack(spacing: 10) {
                        SignInWithAppleButton(.signIn) { _ in } onCompletion: { _ in }
                            .frame(height: 44)
                        SignInWithAppleButton(.signUp) { _ in } onCompletion: { _ in }
                            .frame(height: 44)
                        SignInWithAppleButton(.continue) { _ in } onCompletion: { _ in }
                            .frame(height: 44)
                    }
                }

                // MARK: 样式矩阵
                DemoSection(".signInWithAppleButtonStyle() 样式矩阵", note: "black（默认）/ white / whiteOutline 三种系统预设外观，对应不同的页面背景色") {
                    VStack(spacing: 10) {
                        SignInWithAppleButton(.signIn) { _ in } onCompletion: { _ in }
                            .signInWithAppleButtonStyle(.black)
                            .frame(height: 44)
                        SignInWithAppleButton(.signIn) { _ in } onCompletion: { _ in }
                            .signInWithAppleButtonStyle(.white)
                            .frame(height: 44)
                        SignInWithAppleButton(.signIn) { _ in } onCompletion: { _ in }
                            .signInWithAppleButtonStyle(.whiteOutline)
                            .frame(height: 44)
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // MARK: 圆角
                DemoSection("圆角调整", note: "本质也是普通 View，可以叠加 .clipShape() 改变圆角，不需要特殊 API") {
                    SignInWithAppleButton(.signIn) { _ in } onCompletion: { _ in }
                        .frame(height: 44)
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Sign In With Apple")
    }
}

#Preview {
    NavigationStack {
        SignInWithAppleButtonDemo()
    }
}
