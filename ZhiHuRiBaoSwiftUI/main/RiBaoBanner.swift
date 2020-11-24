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
    var body: some View {
        SwiftUIPagerView(index: $index, pages: todayNews.top_stories.map({
            BannerItem(itemData: $0, id: $0.id)
        }))
        .frame(width: UIScreen.screenWidth, height: 400)
    }
}

struct RiBaoBanner_Previews: PreviewProvider {
    static var previews: some View {
        RiBaoBanner(todayNews: TodayNewsModel())
    }
}

