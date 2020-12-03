//
//  RiBaoBanner.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/12.
//

import SwiftUI

struct RiBaoBanner<Content: View & Identifiable>: View {
    var contents: [Content]
    var body: some View {
        ZStack(alignment: .center) {
            CarouselView(pages: contents)
                .frame(width: UIScreen.screenWidth, height: 400)
                .environmentObject(CarouselHelper(index: 0, itemsCount: contents.count))
            Text("\(contents.count)")
        }
    }
}
