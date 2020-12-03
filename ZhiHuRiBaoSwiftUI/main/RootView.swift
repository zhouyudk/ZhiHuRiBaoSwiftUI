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
    let disposeBag = DisposeBag()
    @ObservedObject var viewModel = NewsViewModel()
    var body: some View {
        NavigationView() {
            VStack {
                RiBaoHeader()
                ScrollView {
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
                                Text("refreshing...")
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


