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
        TabView {
            ForEach(todayNews.top_stories, id: \.id) { news in
                BannerItem(itemData: news)
            }
        }
        .frame(width: UIScreen.screenWidth, height: 400)
        .tabViewStyle(PageTabViewStyle())
    }
}

struct RiBaoBanner_Previews: PreviewProvider {
    static var previews: some View {
        RiBaoBanner(todayNews: TodayNewsModel())
    }
}

