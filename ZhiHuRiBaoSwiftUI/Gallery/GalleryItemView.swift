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

    @State private var remoteImage: UIImage? = nil
    var body: some View {

        Image(uiImage: remoteImage ?? UIImage(named: "haitun")!)
            .resizable()
            .scaledToFit()
            .frame(idealWidth: UIScreen.screenWidth, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
            .onAppear(perform: {
                fetchRemoteImage(url: imageUrl)
            })
    }

    func fetchRemoteImage(url: String){
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url){ [self] (data, response, error) in
            if let d = data, let image = UIImage(data: d){
                self.remoteImage = image
            }
            else{
                print(error ?? "")
            }
        }.resume()
    }
}

struct GalleryItemView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryItemView(id: "dd",imageUrl: "https://pic1.zhimg.com/v2-d504102398ef53484f546b4c0008361b_720w.jpg?source=8673f162")
    }
}
