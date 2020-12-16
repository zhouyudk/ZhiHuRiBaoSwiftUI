//
//  GalleryItemView.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/12/7.
//

import SwiftUI

struct GalleryItemView: View, Identifiable {
    var id: String
    var imageUrl: String
    var body: some View {
        ZStack {
            WebImage(imageUrl: imageUrl)
                .scaledToFit()
                .frame(idealWidth: UIScreen.screenWidth, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
        }

    }
}

struct GalleryItemView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryItemView(id: "dd",imageUrl: "https://pic1.zhimg.com/v2-d504102398ef53484f546b4c0008361b_720w.jpg?source=8673f162")
    }
}
