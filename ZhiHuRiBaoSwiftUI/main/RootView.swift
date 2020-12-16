//
//  ContentView.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/12.
//

import SwiftUI
import RxSwift
import Refresh

struct RootView: View {
    @ObservedObject var viewModel = NewsViewModel()
    @State private var offsetY: CGFloat = 0
    var body: some View {
        NavigationView() {
            VStack {
                RiBaoHeader()
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        RiBaoBanner(todayNews: viewModel.todayNews)
                        ForEach(viewModel.dailyNews, id: \.date) { daily in
                            DailySection(sectionData: daily)
                        }
                        RefreshFooter(refreshing: $viewModel.refreshStatus.footerRefreshing, action: {
                            viewModel.queryDailyNews()
                        }) {
                            if viewModel.refreshStatus.noMore {
                                Text("No more data !")
                            } else {
                                Text("loading more...")
                            }
                        }
                        .noMore(viewModel.refreshStatus.noMore)
                        .preload(offset: 50)
                    }
                    .padding(.all, 0)
                }
                .enableRefresh()
            }
            .navigationBarHidden(true)
        }
    }
    init() {
        viewModel.queryTodayNews()
    }
}

struct RiBaoViewData {
    var headerViewData = HeaderViewData()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}


