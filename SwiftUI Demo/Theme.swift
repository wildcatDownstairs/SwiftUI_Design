//
//  Theme.swift
//  SwiftUI Demo
//
//  全局配色：参考 Claude / Anthropic 的暖米色主题——奶油色背景 + 黏土橙（coral/clay）强调色 + 暖黑文字，
//  替换掉之前那套偏"AI 味"的蓝紫渐变。整个 App 走浅色（.light），文字默认 .primary 即暖黑，自动适配。
//

import SwiftUI

enum Theme {
    /// 奶油背景渐变（顶部稍亮、底部稍暖）
    static let creamTop = Color(red: 0.953, green: 0.941, blue: 0.910)   // #F3F0E8
    static let creamBottom = Color(red: 0.910, green: 0.890, blue: 0.843) // #E8E3D7

    /// Claude 招牌的黏土橙强调色
    static let accent = Color(red: 0.851, green: 0.467, blue: 0.341)      // #D97757

    /// 背景上柔和的暖色光晕（取代蓝紫光斑）
    static let glowPeach = Color(red: 0.906, green: 0.769, blue: 0.639)   // #E7C4A3
    static let glowClay = Color(red: 0.831, green: 0.596, blue: 0.467)    // #D49877
    static let glowSand = Color(red: 0.886, green: 0.835, blue: 0.706)    // #E2D5B4

    /// 暖黑文字 / 暖灰次要文字
    static let ink = Color(red: 0.165, green: 0.153, blue: 0.125)         // #2A2720
    static let inkSecondary = Color(red: 0.459, green: 0.443, blue: 0.416) // #75716A

    /// 按钮矩阵里的"中性默认色"——暖黑而不是纯黑
    static let neutral = Color(red: 0.231, green: 0.216, blue: 0.184)     // #3B372F
}
