//
//  NewsDetailView.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/23.
//

import SwiftUI

struct NewsDetailView: View {
    @State private var remoteImage: UIImage? = nil
    @ObservedObject var newsModel: NewsModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    Image(uiImage: remoteImage ?? UIImage(named: "haitun")!)
                        .resizable()
                        .frame(width: UIScreen.screenWidth, height: 400)
                        .onAppear(perform: {
                            fetchRemoteImage(url: newsModel.images.first!)
                        })

                    VStack(alignment: .leading) {
                        Text(newsModel.title)
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
                }
                Text("待添加")
                    .font(.body)
                    .foregroundColor(.black)
                Spacer()
            }

        }
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

struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(newsModel: NewsModel())
    }
}
