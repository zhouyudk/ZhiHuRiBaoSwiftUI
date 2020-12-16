//
//  ScrollViewOffset.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/12/15.
//

import SwiftUI

/// 用户读取scrollView的Offset
struct CustomScrollView<Content: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    let enableRefresh: Bool
    let offsetChanged: (CGPoint) -> Void
    let content: Content

    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        enableRefresh: Bool = false,
        offsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.enableRefresh = enableRefresh
        self.offsetChanged = offsetChanged
        self.content = content()
    }

    var body: some View {
            ScrollView(axes, showsIndicators: showsIndicators) {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named("scrollView")).origin
                    )
                }.frame(width: 0, height: 0)
                content
            }
//            .enableRefresh(enableRefresh)
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanged)
        }
}

/// Contains the gap between the smallest value for the y-coordinate of
/// the frame layer and the content layer.
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

//struct TestOffset: View {
//    var body: some View {
//        CustomScrollView { (offset) in
//
//        } content: { () -> _ in
//            
//        }
//
//    }
//}
