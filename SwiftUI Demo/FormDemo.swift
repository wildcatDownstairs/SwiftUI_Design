//
//  FormDemo.swift
//  SwiftUI Demo
//
//  Form 组件说明
//  Form 本身就是一个"分组滚动容器"（类似 List 的语义变体），专门为设置/表单页设计，
//  内部用 Section 分组，每个 Section 可以有 header/footer。
//  由于 Form 自身是滚动容器，下面每个示例都给了固定高度 + scrollDisabled，避免和外层 ScrollView 冲突。
//

import SwiftUI

struct FormDemo: View {
    @State private var username = ""
    @State private var notificationsOn = true
    @State private var volume = 50.0
    @State private var selectedTheme = "系统"
    @State private var birthday = Date()
    @State private var themeColor: Color = .blue
    @State private var agreeTerms = false
    @State private var sectionDisabled = false

    private let themes = ["系统", "浅色", "深色"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "Form { Section { ... } } —— 最简单的一组字段，自动套用系统分组样式") {
                    Form {
                        Section("账户") {
                            TextField("用户名", text: $username)
                        }
                    }
                    .frame(minHeight: 120)
                    .scrollDisabled(true)
                }

                // MARK: header / footer
                DemoSection("Section header / footer", note: "header 写在标题位置，footer 常用来放说明文案，二者都支持纯字符串或 @ViewBuilder 内容") {
                    Form {
                        Section {
                            Toggle("接收通知", isOn: $notificationsOn)
                            Stepper("音量：\(Int(volume))", value: $volume, in: 0...100, step: 5)
                        } header: {
                            Text("偏好设置")
                        } footer: {
                            Text("footer 会用小号灰字渲染在这组字段下方，常用来解释字段含义。")
                        }
                    }
                    .frame(height: 250)
                    .scrollDisabled(true)
                }

                // MARK: 多个 Section
                DemoSection("多个 Section（分组效果）", note: "每个 Section 自动产生一组独立的圆角卡片，组与组之间留白") {
                    Form {
                        Section("外观") {
                            Picker("主题", selection: $selectedTheme) {
                                ForEach(themes, id: \.self) { Text($0) }
                            }
                            ColorPicker("强调色", selection: $themeColor)
                        }
                        Section("日期") {
                            DatePicker("生日", selection: $birthday, displayedComponents: [.date])
                        }
                    }
                    .frame(height: 320)
                    .scrollDisabled(true)
                }

                // MARK: formStyle
                DemoSection(".formStyle(.grouped)", note: "iOS 上 Form 默认就是 grouped 样式；.columns 在 iOS 上也能编译运行，但在 iPhone 紧凑宽度下视觉接近 grouped，真正的双栏效果主要在 macOS / iPad 宽屏体现") {
                    Form {
                        Section("显式声明 grouped") {
                            Text("和不写 formStyle 时效果一致")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .formStyle(.grouped)
                    .frame(minHeight: 120)
                    .scrollDisabled(true)
                }

                // MARK: Section 整体禁用
                DemoSection("Section 整体禁用", note: ".disabled() 加在 Section 上，组内所有控件一起变灰失效，不需要逐个字段单独禁用") {
                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("禁用下方表单", isOn: $sectionDisabled)
                        Form {
                            Section("会被整体禁用的分组") {
                                Toggle("选项 A", isOn: .constant(true))
                                Toggle("选项 B", isOn: .constant(false))
                            }
                            .disabled(sectionDisabled)
                        }
                        .frame(height: 210)
                        .scrollDisabled(true)
                    }
                }

                // MARK: 综合实战
                DemoSection("综合实战：账户设置页", note: "把上面的控件拼成一个真实可用的设置页，体会 Form 在实际项目里的样子") {
                    Form {
                        Section("账户信息") {
                            TextField("用户名", text: $username)
                            DatePicker("生日", selection: $birthday, displayedComponents: [.date])
                        }
                        Section {
                            Toggle("我已同意用户协议", isOn: $agreeTerms)
                        } footer: {
                            Text("提交前必须勾选同意协议，否则提交按钮保持禁用。")
                        }
                        Section {
                            Button("提交") {}
                                .disabled(!agreeTerms)
                        }
                    }
                    .frame(height: 470)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Form")
    }
}

#Preview {
    NavigationStack {
        FormDemo()
    }
}
