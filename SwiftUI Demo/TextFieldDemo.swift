//
//  TextFieldDemo.swift
//  SwiftUI Demo
//
//  TextField 组件说明
//  TextField("标题", text: $value) —— 单行（或 axis: .vertical 时多行）文本输入框
//  这里额外用 GlassFieldContainer（图标 + .glassSurface()）包装，演示真实项目里
//  登录页/表单页常见的"图标 + 玻璃质感输入框"写法，而不是只甩一个裸的 .roundedBorder。
//

import SwiftUI

struct TextFieldDemo: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var multilineText = ""
    @State private var quantity = 1
    @State private var price: Double = 9.9
    @State private var selectableText = "选中我试试"
    @State private var textSelection: TextSelection?
    @FocusState private var focusedField: Field?

    private enum Field {
        case name, email
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "TextField(\"标题\", text: $value) —— 标题在没有内容时充当占位符；这里外面套了图标 + .glassSurface() 模拟登录页常见的输入框质感") {
                    GlassFieldContainer(icon: "person.fill") {
                        TextField("姓名", text: $name)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Theme.ink)
                    }
                }

                // MARK: text:prompt
                DemoSection("text:prompt:", note: "用 Text 单独构造占位符，可以给占位符设置自己的样式（颜色/字体），这里把占位符调成了在奶油色玻璃背景下清晰可读的暖灰色") {
                    GlassFieldContainer(icon: "envelope.fill") {
                        TextField(text: $email, prompt: Text("example@mail.com").foregroundStyle(Theme.inkSecondary.opacity(0.7))) {
                            Text("邮箱")
                        }
                        .textFieldStyle(.plain)
                        .foregroundStyle(Theme.ink)
                    }
                }

                // MARK: keyboardType
                DemoSection(".keyboardType()", note: "根据输入内容类型切换键盘布局，比如数字、邮箱、电话") {
                    GlassFieldContainer(icon: "phone.fill") {
                        TextField("手机号", text: $phone)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Theme.ink)
                            .keyboardType(.phonePad)
                    }
                }

                // MARK: 多行输入
                DemoSection("axis: .vertical 多行输入（iOS 16+）", note: "加上 axis: .vertical 后 TextField 可以随内容增高，配合 lineLimit 限制最大行数，比 TextEditor 更轻量") {
                    GlassFieldContainer(icon: "note.text") {
                        TextField("备注（最多 3 行）", text: $multilineText, axis: .vertical)
                            .textFieldStyle(.plain)
                            .foregroundStyle(Theme.ink)
                            .lineLimit(3)
                    }
                }

                // MARK: 焦点切换
                DemoSection(
                    "FocusState + onSubmit 焦点切换",
                    note: "@FocusState 管理多个输入框的焦点，配合 .onSubmit 实现「按下一步跳到下一个输入框」"
                ) {
                    VStack(spacing: 10) {
                        GlassFieldContainer(icon: "person.fill") {
                            TextField("姓名", text: $name)
                                .textFieldStyle(.plain)
                                .foregroundStyle(Theme.ink)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .email }
                        }
                        GlassFieldContainer(icon: "envelope.fill") {
                            TextField("邮箱", text: $email)
                                .textFieldStyle(.plain)
                                .foregroundStyle(Theme.ink)
                                .focused($focusedField, equals: .email)
                                .submitLabel(.done)
                                .onSubmit { focusedField = nil }
                        }
                    }
                }

                // MARK: textFieldStyle
                DemoSection(
                    ".textFieldStyle() 矩阵（系统原生样式）",
                    note: "plain 无边框；roundedBorder 系统圆角边框——这两个是系统自带的原生样式，套了张白卡方便看清原本的样子，跟上面自定义的玻璃风格是两条不同的路"
                ) {
                    VStack(spacing: 10) {
                        TextField("plain", text: $name).textFieldStyle(.plain)
                        TextField("roundedBorder", text: $name).textFieldStyle(.roundedBorder)
                    }
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                // MARK: value:format:
                DemoSection(
                    "TextField(value:format:) 数值绑定",
                    note: "直接绑定数字类型（Int/Double 等），用 FormatStyle 控制输入输出格式，不需要自己在 String 和数字之间手动转换"
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        GlassFieldContainer(icon: "number") {
                            TextField("数量", value: $quantity, format: .number)
                                .textFieldStyle(.plain)
                                .foregroundStyle(Theme.ink)
                                .keyboardType(.numberPad)
                        }
                        GlassFieldContainer(icon: "yensign.circle.fill") {
                            TextField("价格", value: $price, format: .currency(code: "CNY"))
                                .textFieldStyle(.plain)
                                .foregroundStyle(Theme.ink)
                                .keyboardType(.decimalPad)
                        }
                    }
                }

                // MARK: selection 绑定
                DemoSection(
                    "selection 绑定（iOS 18+）",
                    note: "TextField(_:text:selection:) 把当前选中的文字范围暴露成 TextSelection? 绑定，可以读取/编程式设置选区，但 iOS 上同一时间只能可视化一段范围"
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        GlassFieldContainer(icon: "cursorarrow.and.square.on.square.dashed") {
                            TextField("可读取选区", text: $selectableText, selection: $textSelection)
                                .textFieldStyle(.plain)
                                .foregroundStyle(Theme.ink)
                        }
                        Text(textSelection == nil ? "尚未选中文字" : "当前有选区")
                            .font(.caption)
                            .foregroundStyle(Theme.inkSecondary)
                    }
                }

                // MARK: 实战
                DemoSection(
                    "实战：登录表单",
                    note: "把上面的输入框拼成一个真实可用的登录表单，配合 .buttonStyle(.glassProminent) 的提交按钮，体会 TextField 在 Liquid Glass 风格里的实际样子"
                ) {
                    VStack(spacing: 12) {
                        GlassFieldContainer(icon: "envelope.fill") {
                            TextField("邮箱", text: $email)
                                .textFieldStyle(.plain)
                                .foregroundStyle(Theme.ink)
                                .keyboardType(.emailAddress)
                        }
                        GlassFieldContainer(icon: "lock.fill") {
                            SecureField("密码", text: $name)
                                .textFieldStyle(.plain)
                                .foregroundStyle(Theme.ink)
                        }
                        Button("登录") {}
                            .buttonStyle(.glassProminent)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Text Field")
    }
}

#Preview {
    NavigationStack {
        TextFieldDemo()
    }
}
