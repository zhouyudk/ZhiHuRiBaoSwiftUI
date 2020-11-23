//
//  RiBaoViewModel.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/20.
//

import Foundation
import RxSwift

class NewsViewModel: ObservableObject {
    @Published var topNews = [TopNewsModel]()
    @Published var dailyNews = [DailyNewsModel]()
    @Published var todayNews = TodayNewsModel()
    let disposeBag = DisposeBag()
    func queryTodayNews() {
        NetworkManager
            .shared
            .queryTodayNews()
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .subscribe { [unowned self](todayNews) in
                self.topNews.append(contentsOf: todayNews.top_stories)
                let tn = DailyNewsModel()
                tn.date = ""
                tn.stories = todayNews.stories
                self.dailyNews.append(contentsOf: [tn])
                self.todayNews = todayNews
                self.queryDailyNews(beforeDays: 1)
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
    }

    func queryDailyNews(beforeDays: Int) {
        let queryDate = Date().timeIntervalSince1970 - Double((beforeDays-1)*3600*24)
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        NetworkManager
            .shared
            .queryNewsBeforeDate(date: df.string(from: Date.init(timeIntervalSince1970: queryDate)))
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .subscribe { [unowned self] (news) in
                self.dailyNews.append(news)
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}

struct ViewData {
    var topNews: [TopNewsModel]
    var dailyNews: [DailyNewsModel]
}
