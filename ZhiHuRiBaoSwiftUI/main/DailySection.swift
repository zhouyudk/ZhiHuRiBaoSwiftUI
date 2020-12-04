//
//  DailySection.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/20.
//

import SwiftUI

struct DailySection: View {
    @ObservedObject var sectionData: DailyNewsModel
    var body: some View {
        Section(header: DailySectionHeader(dateStr: sectionData.date)) {
            VStack {
                ForEach(sectionData.stories, id:\.id) { news in
                    NavigationLink(destination: NewsDetailView(news: news)) {
                        DailySectionItem(viewData: news)
                    }
                }
            }
        }
    }
}

struct DailySectionHeader: View {
    @State var dateStr: String = "11月20日"
    var body: some View {
        if dateStr == "" {
            ZStack{

            }
        } else {
            HStack(alignment: .center) {
                Text(dateStr)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                VStack {
                    Color.gray
                }
                .frame(minWidth: 0, maxWidth: .infinity,  idealHeight: 1,maxHeight: 1, alignment: .center)
            }
        }
    }
}

struct DailySectionItem: View {
    @ObservedObject var viewData: NewsModel
    @State private var remoteImage: UIImage? = nil
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text(viewData.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Text(viewData.hint)
                    .font(.primaryTextSize)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .topLeading)
            Spacer(minLength: 10)
            Image(uiImage: remoteImage ?? UIImage(named: "haitun")!)
                .resizable()
                .frame(width: 80, height: 80, alignment: .center)
                .onAppear(perform: {
                    fetchRemoteImage(url: viewData.images.first ?? "")
                })
        }
        .padding(EdgeInsets(top: 30, leading: 10, bottom: 40, trailing: 10))
        .frame(width: UIScreen.screenWidth, height: 100, alignment: .center)
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



struct DailySection_Previews: PreviewProvider {
    static var previews: some View {
//        DailySection(sectionData: DailyNewsModel())
        DailySectionHeader()
    }
}
