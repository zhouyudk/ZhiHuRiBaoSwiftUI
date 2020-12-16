//
//  BannerItems.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/13.
//

import SwiftUI

struct BannerItemView: View, Identifiable {
    @ObservedObject var itemData: TopNewsModel
    @State private var showPopover: Bool = false
    var id: Int
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NavigationLink(destination:  NewsDetailView(news: NewsModel(images: [itemData.image], title: itemData.title))){
                WebImage(imageUrl: itemData.image)
                    .frame(width: UIScreen.screenWidth, height: 400)
            }
            VStack(alignment: .leading) {
                Text(itemData.title)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                Text(itemData.hint)
                    .font(.body)
                    .foregroundColor(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0))
                    .multilineTextAlignment(.leading)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        }
        .frame(width: UIScreen.screenWidth)
    }
}

struct BannerItem_Previews: PreviewProvider {
    static var previews: some View {
        BannerItemView(itemData: TopNewsModel(), id: 1)
    }
}
