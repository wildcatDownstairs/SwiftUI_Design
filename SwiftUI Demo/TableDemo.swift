//
//  TableDemo.swift
//  SwiftUI Demo
//
//  Table 组件说明
//  Table(数据) { TableColumn(...) } —— 在 iPad/Mac 横屏等"regular"宽度下会显示多列表格，
//  但在 iPhone 这种"compact"宽度下，官方文档说明只会显示第一列，其余列被收起——
//  这是文档写明的正常行为，不是 bug，所以下面顺便演示官方推荐的紧凑宽度替代写法。
//

import SwiftUI

private struct Employee: Identifiable {
    let id = UUID()
    let name: String
    let department: String
    let salary: Int
}

private let employees: [Employee] = [
    Employee(name: "张伟", department: "工程部", salary: 28000),
    Employee(name: "李娜", department: "设计部", salary: 22000),
    Employee(name: "王芳", department: "产品部", salary: 25000),
]

struct TableDemo: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedID: Employee.ID?
    @State private var multiSelection = Set<Employee.ID>()
    @State private var sortOrder = [KeyPathComparator(\Employee.salary)]

    private var sortedEmployees: [Employee] {
        employees.sorted(using: sortOrder)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection(
                    "基础用法",
                    note: "Table(数据) { TableColumn(...) } —— iPhone 紧凑宽度下只显示第一列，是文档说明的正常行为"
                ) {
                    Table(employees) {
                        TableColumn("姓名", value: \.name)
                        TableColumn("部门", value: \.department)
                        TableColumn("薪资") { employee in
                            Text("¥\(employee.salary)")
                        }
                    }
                    .frame(minHeight: 200)
                }

                // MARK: 单选/多选
                DemoSection(
                    "单选 / 多选 selection",
                    note: "Table(selection:) 绑定 Binding<ID?> 是单选；绑定 Binding<Set<ID>> 是多选，和 List 的 selection 用法一致"
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("单选：\(employees.first { $0.id == selectedID }?.name ?? "无")")
                            .font(.caption).foregroundStyle(.secondary)
                        Table(employees, selection: $selectedID) {
                            TableColumn("姓名", value: \.name)
                        }
                        .frame(minHeight: 160)
                    }
                }

                // MARK: sortOrder
                DemoSection(
                    "sortOrder 排序",
                    note: "TableColumn(_:value:comparator:) 标记为可排序后，点击列头会更新 sortOrder（[KeyPathComparator]），再用它对数据源排序——Table 本身不会自动重排数据"
                ) {
                    Table(sortedEmployees, sortOrder: $sortOrder) {
                        TableColumn("姓名", value: \.name)
                        TableColumn("薪资", value: \.salary) { employee in
                            Text("¥\(employee.salary)")
                        }
                    }
                    .frame(minHeight: 200)
                }

                // MARK: tableStyle
                DemoSection(
                    ".tableStyle() 矩阵",
                    note: "iOS 上只有 automatic 和 inset 两种（bordered 是 macOS 专属，iOS 不支持）"
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("automatic").font(.caption).foregroundStyle(.secondary)
                        Table(employees) {
                            TableColumn("姓名", value: \.name)
                        }
                        .tableStyle(.automatic)
                        .frame(minHeight: 120)

                        Text("inset").font(.caption).foregroundStyle(.secondary)
                        Table(employees) {
                            TableColumn("姓名", value: \.name)
                        }
                        .tableStyle(.inset)
                        .frame(minHeight: 120)
                    }
                }

                // MARK: 当前宽度类型
                DemoSection(
                    "检测当前宽度类型",
                    note: "用 @Environment(\\.horizontalSizeClass) 判断是否为紧凑宽度，决定要不要换一种展示方式"
                ) {
                    Text("horizontalSizeClass: \(horizontalSizeClass == .compact ? "compact（iPhone 竖屏）" : "regular（iPad / 横屏）")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // MARK: 紧凑宽度推荐写法
                DemoSection(
                    "紧凑宽度的推荐写法：换成 List",
                    note: "苹果官方建议：紧凑宽度下把其他列的信息聚合成副标题，用 List 而不是硬塞 Table"
                ) {
                    List(employees) { employee in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(employee.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("\(employee.department) · ¥\(employee.salary)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(minHeight: 160)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Table")
    }
}

#Preview {
    NavigationStack {
        TableDemo()
    }
}
