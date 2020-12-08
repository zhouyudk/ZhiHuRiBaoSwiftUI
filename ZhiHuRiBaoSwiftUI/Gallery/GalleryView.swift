//
//  GalleryView.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/12/7.
//

import SwiftUI

struct GalleryView: View {
    @State var index: Int
    var source: [String]
    var body: some View {
        ZStack {
            VStack {
                Color.black
            }
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .center)
            SwiftUIPagerView(index: $index, pages: source.map{ GalleryItemView(id:$0, imageUrl: $0) })
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .center)
        }
        .ignoresSafeArea()
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(index: 0, source: ["https://pic1.zhimg.com/v2-d504102398ef53484f546b4c0008361b_720w.jpg?source=8673f162","https://pic1.zhimg.com/v2-d504102398ef53484f546b4c0008361b_720w.jpg?source=8673f163","https://pic1.zhimg.com/v2-d504102398ef53484f546b4c0008361b_720w.jpg?source=8673f164"])
    }
}
