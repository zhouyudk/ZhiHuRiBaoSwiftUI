//
//  CarouselView.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/12/1.
//

import SwiftUI

struct CarouselView<Content: View & Identifiable>: View {
    @EnvironmentObject var carouselHelper: CarouselHelper
    @State private var offset: CGFloat = 0
    @State private var isGestureActive: Bool = false
    var pages: [Content]
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(self.pages) { page in
                        page
                            .frame(width: geometry.size.width, height: nil)
                    }
                }
            }
            // 调整offset
            .content.offset(x: self.isGestureActive ? self.offset : -geometry.size.width * CGFloat(carouselHelper.index))
//            .animation(.easeInOut)
            // 调整自身宽度与父层相同，借由GeometryReader的作用
            .frame(width: geometry.size.width, height: nil, alignment: .leading)
            .gesture(DragGesture().onChanged({ value in
                carouselHelper.disableAutoScroll()
                // offset跟随手势调整标识，不由index修改offset
                self.isGestureActive = true
                // 跟随手势调整offset
                self.offset = value.translation.width + -geometry.size.width * CGFloat(carouselHelper.index)
            }).onEnded({ value in
                var newIndex = carouselHelper.index
                if -value.predictedEndTranslation.width > geometry.size.width / 2, carouselHelper.index < self.pages.endIndex - 1 {
                    newIndex = carouselHelper.index+1
                }
                if value.predictedEndTranslation.width > geometry.size.width / 2, carouselHelper.index > 0 {
                    newIndex = carouselHelper.index-1
                }
                // 动画调整offset
                withAnimation { self.offset = -geometry.size.width * CGFloat(newIndex) }
                //必须先调整offset再更新 index
                carouselHelper.updateIndex(newIndex)
                // 修改是否拖拽状态
                DispatchQueue.main.async { self.isGestureActive = false }
                carouselHelper.enableAutoScroll()
            }))
        }
        .onAppear(perform: {
            carouselHelper.enableAutoScroll()
        })
        .onDisappear(perform: {
            carouselHelper.disableAutoScroll()
        })
    }
    init(pages: [Content]) {
        var newPages = pages
        if pages.count > 1 {
            let pageFirst = pages.first!
            let pageLast = pages.last!
            newPages.insert(pageLast, at: 0)
            newPages.append(pageFirst)
        }
        self.pages = newPages
    }
}

class CarouselHelper: ObservableObject {
    @Published var index: Int = 0
    var itemsCount: Int = 0
    private var scrollTimer: Timer?

    init(index: Int, itemsCount: Int) {
        guard itemsCount > 1 else { return }
        self.itemsCount = itemsCount+2
        self.index = index+1
        enableAutoScroll()
    }
    func enableAutoScroll() {
        let t = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { [self] (_) in
            guard itemsCount > 1 else {
                return
            }
            updateIndex(index+1)
        }
        scrollTimer = t
        RunLoop.main.add(scrollTimer!, forMode: RunLoop.Mode.common)
    }

    func disableAutoScroll() {
        if self.scrollTimer != nil {
            self.scrollTimer?.invalidate()
            self.scrollTimer = nil
        }
    }

    func updateIndex(_ index: Int) {
        print(index)
        // 先动画滚动到index，再判断index是否为边界
        withAnimation {
            self.index = index
        }
        if index == itemsCount-1 {
            self.index = 1
        } else if index == 0 {
            self.index = itemsCount-2
        }
    }
}
