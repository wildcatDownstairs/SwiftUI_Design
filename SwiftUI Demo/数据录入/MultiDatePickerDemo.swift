//
//  MultiDatePickerDemo.swift
//  SwiftUI Demo
//
//  MultiDatePicker 组件说明（iOS 16+）
//  初始化：MultiDatePicker("标题", selection: $dates, in: range)
//  selection 是 Set<DateComponents>，可以一次选多个不连续的日期；外观固定是日历网格，没有其他样式可切换
//

import SwiftUI

struct MultiDatePickerDemo: View {
    @State private var dates: Set<DateComponents> = []
    @State private var boundedDates: Set<DateComponents> = []

    private var bounds: PartialRangeFrom<Date> {
        Calendar.current.startOfDay(for: Date())...
    }

    private var selectedDateStrings: [String] {
        dates.compactMap { components in
            guard let date = Calendar.current.date(from: components) else { return nil }
            return date.formatted(date: .abbreviated, time: .omitted)
        }.sorted()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法", note: "MultiDatePicker(\"标题\", selection: $dates) —— selection 是 Set<DateComponents>，可以一次选多个不连续的日期") {
                    MultiDatePicker("选择多个日期", selection: $dates)
                }

                // MARK: 已选日期展示
                DemoSection("已选日期展示", note: "DateComponents 需要用 Calendar.date(from:) 转换成 Date 才能格式化显示") {
                    if selectedDateStrings.isEmpty {
                        Text("还没有选择日期")
                            .foregroundStyle(.secondary)
                    } else {
                        Text(selectedDateStrings.joined(separator: "、"))
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: in 限制范围
                DemoSection("in: 限制范围", note: "和 DatePicker 一样支持 in:，传 PartialRangeFrom 可以限制只能选今天及以后") {
                    MultiDatePicker("仅未来日期", selection: $boundedDates, in: bounds)
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "MultiDatePicker(selection:label:) 的 label 可以放图标 + 文字组合，不限于纯字符串标题") {
                    MultiDatePicker(selection: $dates) {
                        Label("可预约日期", systemImage: "calendar.badge.clock")
                    }
                }

                // MARK: labelsHidden
                DemoSection(".labelsHidden()", note: "隐藏标签文字，只保留日历本体") {
                    MultiDatePicker("隐藏的标签", selection: $dates)
                        .labelsHidden()
                }

                // MARK: 放进 Form
                DemoSection("放进 Form", note: "MultiDatePicker 体积较大，放进 Form 时通常单独占一个 Section") {
                    Form {
                        Section("可预约日期") {
                            MultiDatePicker("选择日期", selection: $dates)
                        }
                    }
                    .frame(minHeight: 360)
                    .scrollDisabled(true)
                }
            }
            .padding()
        }
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Multi Date Picker")
    }
}

#Preview {
    NavigationStack {
        MultiDatePickerDemo()
    }
}
