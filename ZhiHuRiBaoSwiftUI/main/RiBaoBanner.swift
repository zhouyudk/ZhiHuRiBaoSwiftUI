//
//  RiBaoBanner.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/12.
//

import SwiftUI

struct RiBaoBanner: View {
    @ObservedObject var todayNews: TodayNewsModel
    var body: some View {
        CarouselView(pages: todayNews.top_stories.map{BannerItemView(itemData: $0, id: $0.id)})
            .frame(width: UIScreen.screenWidth, height: 400)
            .environmentObject(CarouselHelper(index: 0, itemsCount: todayNews.top_stories.count))
    }
}
