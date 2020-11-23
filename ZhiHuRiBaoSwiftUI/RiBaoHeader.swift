//
//  RiBaoHeader.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/12.
//

import SwiftUI

struct RiBaoHeader: View {
    @State var viewData = HeaderViewData()
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .center){
                    Text(viewData.day)
                        .font(.primaryTextSize)
                    Text(viewData.month)
                        .font(.textSize10)
                }
                HStack {
                    Color.gray
                }
                .frame(width: 1, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                Text("日报")
                    .font(.title2)
                    .bold()
                Spacer()
                    .frame(maxWidth: .infinity)
                Image(viewData.image)
                    .resizable()
                    .frame(width: 38, height: 38, alignment: .center)
                    .clipShape(Circle())
            }
            .frame(minWidth: 0, idealWidth: UIScreen.screenWidth, maxWidth: .infinity, minHeight: 40, idealHeight: 40, maxHeight: 40, alignment: .top)
            .padding(.horizontal, 10)
        }
        
    }
}

struct HeaderViewData {
    var image: String = "haitun"
    var month: String = "11月"
    var day: String = "11"
}
struct RiBaoHeader_Previews: PreviewProvider {
    static var previews: some View {
        RiBaoHeader()
    }
}
