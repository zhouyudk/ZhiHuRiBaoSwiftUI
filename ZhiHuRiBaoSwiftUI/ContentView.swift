//
//  ContentView.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/12.
//

import SwiftUI
import RxSwift

struct ContentView: View {
    @State var topNewsModel: [TopNewsModel] = []
    @State var dailyNewsDic: [String: [NewsModel]] = [:]
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
    }
    init() {
        registeObserver()
        viewModel.queryTodayNews()
    }
    func registeObserver() {
        viewModel.viewDataSubject.subscribe(onNext: { (vd) in
            self.topNewsModel = vd.topNews
//            self.dailyNewsDic = vd.dailyNews

        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)
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


