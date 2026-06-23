//
//  DatePickerDemo.swift
//  SwiftUI Demo
//
//  DatePicker 组件说明（与 ButtonDemo 同等密度）
//  初始化方式：
//    DatePicker("标题", selection: $date, in: range, displayedComponents:)
//    DatePicker(selection:displayedComponents:label:)  —— label 可放任意 View（@ViewBuilder）
//  displayedComponents 控制显示"日期"还是"时间"还是两者都要
//  .datePickerStyle() 控制外观：automatic / compact / graphical / wheel
//

import SwiftUI

// 顶部语言切换：演示 .environment(\.locale) 如何让同一个 DatePicker 渲染出不同语言的月份/星期文案
enum DemoLocale: String, CaseIterable, Identifiable {
    case zh = "中"
    case ja = "日"
    case en = "英"

    var id: String { rawValue }

    var locale: Locale {
        switch self {
        case .zh: Locale(identifier: "zh_Hans_CN")
        case .ja: Locale(identifier: "ja_JP")
        case .en: Locale(identifier: "en_US")
        }
    }
}

struct DatePickerDemo: View {
    @State private var selectedLocale: DemoLocale = .zh
    @State private var date1 = Date()
    @State private var date2 = Date()
    @State private var date3 = Date()
    @State private var date4 = Date()
    @State private var rangeDate = Date()
    @State private var pastOnlyDate = Date()
    @State private var labeledDate = Date()
    @State private var disabledDate = Date()
    @State private var lunarDate = Date()

    // in: 参数支持 ClosedRange<Date>，限制可选范围
    private var nextWeekRange: ClosedRange<Date> {
        let today = Calendar.current.startOfDay(for: Date())
        let oneWeekLater = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        return today...oneWeekLater
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("界面语言", selection: $selectedLocale) {
                ForEach(DemoLocale.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            .padding()

            scrollContent
        }
        .environment(\.locale, selectedLocale.locale)
        .background(GlassBackground().ignoresSafeArea())
        .navigationTitle("Date Picker")
    }

    private var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: 基础用法
                DemoSection("基础用法（默认样式）", note: "displayedComponents 不写时，默认同时显示日期和时间") {
                    DatePicker("选择时间", selection: $date1)
                }

                // MARK: displayedComponents
                DemoSection("displayedComponents", note: "[.date] 只显示年月日；[.hourAndMinute] 只显示时分；写两个则合并展示") {
                    VStack(alignment: .leading, spacing: 10) {
                        DatePicker("只选日期", selection: $date2, displayedComponents: [.date])
                        DatePicker("只选时间", selection: $date3, displayedComponents: [.hourAndMinute])
                        DatePicker("日期+时间", selection: $date4, displayedComponents: [.date, .hourAndMinute])
                    }
                }

                // MARK: datePickerStyle 矩阵
                DemoSection(".datePickerStyle() 样式矩阵", note: "compact 省空间点击展开；graphical 完整日历；wheel 经典滚轮，常见于表单底部弹出") {
                    VStack(alignment: .leading, spacing: 14) {
                        DatePicker("compact", selection: $date4, displayedComponents: [.date])
                            .datePickerStyle(.compact)

                        DatePicker("graphical", selection: $date4, displayedComponents: [.date])
                            .datePickerStyle(.graphical)

                        DatePicker("wheel", selection: $date4, displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .frame(maxHeight: 120)
                            .clipped()
                    }
                }

                // MARK: in: 限制范围
                DemoSection("in: 限制可选范围", note: "ClosedRange<Date> 限制未来 7 天；PartialRangeThrough（...Date()）可以反过来只允许选过去") {
                    VStack(alignment: .leading, spacing: 10) {
                        DatePicker("仅未来 7 天", selection: $rangeDate, in: nextWeekRange, displayedComponents: [.date])
                        DatePicker("仅可选过去日期", selection: $pastOnlyDate, in: ...Date(), displayedComponents: [.date])
                    }
                }

                // MARK: 自定义 label
                DemoSection("自定义 label（@ViewBuilder）", note: "DatePicker(selection:displayedComponents:label:) 的 label 可以放图标 + 文字") {
                    DatePicker(selection: $labeledDate, displayedComponents: [.date]) {
                        Label("出发日期", systemImage: "airplane.departure")
                    }
                }

                // MARK: labelsHidden
                DemoSection(".labelsHidden()", note: "隐藏标签文字，常用于和外部自定义文字搭配，避免重复显示标题") {
                    HStack {
                        Text("截止日期：")
                        DatePicker("", selection: $date1, displayedComponents: [.date])
                            .labelsHidden()
                    }
                }

                // MARK: 自定义日历/locale
                DemoSection("自定义日历 / 地区（environment）", note: ".environment(\\.calendar, ...) 和 .environment(\\.locale, ...) 可以切换农历等非公历日历，UI 文案随之变化") {
                    DatePicker("农历视图", selection: $lunarDate, displayedComponents: [.date])
                        .environment(\.calendar, Calendar(identifier: .chinese))
                        .environment(\.locale, Locale(identifier: "zh_Hans_CN"))
                }

                // MARK: 禁用状态
                DemoSection(".disabled()", note: "禁用后整体变灰且不可交互，由外部 Bool 控制") {
                    DatePicker("禁用的日期选择器", selection: $disabledDate, displayedComponents: [.date])
                        .disabled(true)
                }
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        DatePickerDemo()
    }
}
