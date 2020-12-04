//
//  BannerItems.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/13.
//

import SwiftUI

struct BannerItemView: View, Identifiable {
    @ObservedObject var itemData: TopNewsModel
    @State private var remoteImage: UIImage? = nil
    @State private var showPopover: Bool = false
    var id: Int
    var body: some View {


        ZStack(alignment: .bottomLeading) {
            NavigationLink(destination:  NewsDetailView(news: NewsModel(images: [itemData.image], title: itemData.title))){
                Image(uiImage: remoteImage ?? UIImage(named: "haitun")!)
                    .resizable()
                    .frame(width: UIScreen.screenWidth, height: 400)
                    .onAppear(perform: {
                        fetchRemoteImage(url: itemData.image)
                    })
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

    func fetchRemoteImage(url: String){
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url){ (data, response, error) in
                if let d = data, let image = UIImage(data: d){
                    self.remoteImage = image
                }
                else{
                    print(error ?? "")
                }
            }.resume()
        }

}

struct BannerItem_Previews: PreviewProvider {
    static var previews: some View {
        BannerItemView(itemData: TopNewsModel(), id: 1)
    }
}
