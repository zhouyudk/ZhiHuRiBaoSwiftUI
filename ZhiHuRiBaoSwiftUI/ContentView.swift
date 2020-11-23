//
//  ContentView.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/12.
//

import SwiftUI
import RxSwift

struct ContentView: View {
    let disposeBag = DisposeBag()
    @ObservedObject var viewModel = NewsViewModel()
    var body: some View {
        VStack {
            RiBaoHeader(viewData: HeaderViewData())
                .padding(.all, 0)
            ScrollView {
                VStack {
                    RiBaoBanner(todayNews: viewModel.todayNews)
                    ForEach(viewModel.dailyNews, id: \.date) { daily in
                        DailySection(sectionData: daily)
                    }
                    Spacer()
                }
                .padding(.all, 0)
            }

        }
        .onAppear(perform: {
            viewModel.queryTodayNews()
        })
    }
}

struct RiBaoViewData {
    var headerViewData = HeaderViewData()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


