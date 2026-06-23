//
//  SecureFieldDemo.swift
//  SwiftUI Demo
//
//  SecureField 组件说明
//  SecureField("标题", text: $password) —— 输入内容自动以圆点遮挡，外观和 TextField 一致，
//  没有内置的"显示/隐藏密码"按钮，需要自己用 TextField 切换来实现。
//  用 GlassFieldContainer（图标 + .glassSurface()）包装，呼应登录页常见的玻璃质感密码框。
//

import SwiftUI

struct SecureFieldDemo: View {
    @State private var password = ""
    @State private var promptPassword = ""
    @State private var visiblePassword = ""
    @State private var isPasswordVisible = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "SecureField(\"标题\", text: $password) —— 输入内容自动以圆点遮挡") {
                    GlassFieldContainer(icon: "lock.fill") {
                        SecureField("密码", text: $password)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Theme.ink)
                    }
                }

                // MARK: prompt 占位符
                DemoSection("text:prompt: 占位符", note: "SecureField(text:prompt:) 用 Text 构造占位文字，可以单独设置占位符样式") {
                    GlassFieldContainer(icon: "lock.fill") {
                        SecureField(text: $promptPassword, prompt: Text("至少 8 位字符").foregroundStyle(Theme.inkSecondary.opacity(0.7))) {
                            Text("新密码")
                        }
                        .textFieldStyle(.plain)
                        .foregroundStyle(Theme.ink)
                    }
                }

                // MARK: 常见修饰符
                DemoSection("常见配套修饰符", note: ".textContentType(.password) 帮助系统识别这是密码字段，配合钥匙串自动填充；.textInputAutocapitalization(.never) 防止密码被自动大写") {
                    GlassFieldContainer(icon: "lock.fill") {
                        SecureField("密码", text: $password)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Theme.ink)
                            .textContentType(.password)
                            .textInputAutocapitalization(.never)
                    }
                }

                // MARK: 显示/隐藏密码
                DemoSection(
                    "显示 / 隐藏密码（自行实现）",
                    note: "原生没有眼睛图标按钮，常见做法是用 isPasswordVisible 切换显示 SecureField 还是普通 TextField"
                ) {
                    GlassFieldContainer(icon: "lock.fill") {
                        HStack {
                            if isPasswordVisible {
                                TextField("密码", text: $visiblePassword)
                            } else {
                                SecureField("密码", text: $visiblePassword)
                            }
                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundStyle(Theme.inkSecondary)
                            }
                        }
                        .textFieldStyle(.plain)
                        .foregroundStyle(Theme.ink)
                    }
                }

                // MARK: onSubmit
                DemoSection(".onSubmit()", note: "键盘回车键触发的回调，常用来直接提交登录表单") {
                    GlassFieldContainer(icon: "lock.fill") {
                        SecureField("密码（按回车试试）", text: $password)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Theme.ink)
                            .onSubmit {
                                print("提交密码：\(password)")
                            }
                    }
                }

                // MARK: 放进 Form
                DemoSection("放进 Form", note: "和 TextField 一样常见于登录/注册表单（这里保留原生 Form 外观，对比玻璃风格输入框的差异）") {
                    Form {
                        Section("账户") {
                            TextField("用户名", text: .constant(""))
                            SecureField("密码", text: $password)
                        }
                    }
                    .frame(minHeight: 140)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Secure Field")
    }
}

#Preview {
    NavigationStack {
        SecureFieldDemo()
    }
}
