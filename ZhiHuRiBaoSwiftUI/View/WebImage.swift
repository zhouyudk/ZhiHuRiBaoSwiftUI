//
//  WebImage.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/12/16.
//

import SwiftUI


/// 定制显示网络图片的Image
struct WebImage: View {
    var imageUrl: String
    var placeHolder: UIImage = UIImage(named: "haitun")!
    @State private var remoteImage: UIImage? = nil
    
    var body: some View {
        Image(uiImage: remoteImage ?? placeHolder)
            .resizable()
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


struct WebImage_Previews: PreviewProvider {
    static var previews: some View {
        WebImage(imageUrl: "https://github.com/Jinxiansen/SwiftUI/raw/master/images/example/WebImage.png")
    }
}
