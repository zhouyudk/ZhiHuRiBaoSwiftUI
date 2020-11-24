//
//  RiBaoBanner.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/12.
//

import SwiftUI

struct RiBaoBanner: View {
    @ObservedObject var todayNews: TodayNewsModel
    @State var index = 0
    @State private var scrollTimer: Timer?
    @State private var isLeftToRight = true
    #warning("定制轮播器")
    var body: some View {
        ZStack(alignment: .center){
            SwiftUIPagerView(index: $index, pages: todayNews.top_stories.map({
                BannerItem(itemData: $0, id: $0.id)
            }))
            .frame(width: UIScreen.screenWidth, height: 400)
            .onAppear(perform: {
                index = todayNews.top_stories.count
//                enableAutoScroll()
            })
            .onDisappear(perform: {
                disableAutoScroll()
            })
            Text("\(index)")
        }

    }
    
    func enableAutoScroll() {
        guard todayNews.top_stories.count > 1 else {
//            pageControl.isHidden=true
//            collectionView.isScrollEnabled = false
            return
        }
//        pageControl.isHidden = false
//        collectionView.isScrollEnabled = true
        let t = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (_) in
            if isLeftToRight {
                if index+1 < todayNews.top_stories.count {
                    index += 1
                } else {
                    isLeftToRight = false
                    index -= 1
                }
            } else {
                if index-1 >= 0 {
                    index -= 1
                } else {
                    isLeftToRight = true
                    index += 1
                }
            }

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
}

struct RiBaoBanner_Previews: PreviewProvider {
    static var previews: some View {
        RiBaoBanner(todayNews: TodayNewsModel())
    }
}

