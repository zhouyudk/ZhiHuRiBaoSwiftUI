//
//  SwiftUIPagerViewswift.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/24.
//

import SwiftUI
//https://stackoverflow.com/questions/57028165/swiftui-scrollview-how-to-modify-content-offset-aka-paging
struct SwiftUIPagerView<Content: View & Identifiable>: View {

    @Binding var index: Int
    @State private var offset: CGFloat = 0
    @State private var isGestureActive: Bool = false

    // 1
    var pages: [Content]

    var indexChangeClosure: ((Int)->Void)?

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(self.pages) { page in
                        page
                            .frame(width: geometry.size.width, height: nil)
                    }
                }
            }
            // 2
            .content.offset(x: self.isGestureActive ? self.offset : -geometry.size.width * CGFloat(self.index))
            // 3
            .frame(width: geometry.size.width, height: nil, alignment: .leading)
            .gesture(DragGesture().onChanged({ value in
                // 4
                self.isGestureActive = true
                // 5
                self.offset = value.translation.width + -geometry.size.width * CGFloat(self.index)
            }).onEnded({ value in
                if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.pages.endIndex - 1 {
                    self.index += 1
                }
                if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                    self.index -= 1
                }
                // 6
                withAnimation { self.offset = -geometry.size.width * CGFloat(self.index) }
                // 7
                DispatchQueue.main.async { self.isGestureActive = false }
            }))
        }
    }
}

//struct SwiftUIPagerViewswift_Previews: PreviewProvider {
//    @State var index: Int = 0
//    static var previews: some View {
//        SwiftUIPagerView(index: index, pages: (0..<4).map { index in BannerItem(itemData: TopNewsModel(), id: index) })
//    }
//}
