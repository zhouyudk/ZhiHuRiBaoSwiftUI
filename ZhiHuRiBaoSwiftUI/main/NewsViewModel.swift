//
//  RiBaoViewModel.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/20.
//

import Foundation
import RxSwift

class NewsViewModel: ObservableObject {
    @Published var dailyNews = [DailyNewsModel]()
    @Published var todayNews = TodayNewsModel()
    @Published var refreshStatus = RefreshStatus()
    var noMoreDataSubject = BehaviorSubject(value: false)
    var beforeDays = 0
    let disposeBag = DisposeBag()
    func queryTodayNews() {
        NetworkManager
            .shared
            .queryTodayNews()
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .subscribe { [unowned self](todayNews) in
                let tn = DailyNewsModel()
                tn.date = ""
                tn.stories = todayNews.stories
                self.dailyNews.append(contentsOf: [tn])
                self.todayNews = todayNews
                self.queryDailyNews()
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
    }

    func queryDailyNews() {
        let queryDate = Date().timeIntervalSince1970 - Double(beforeDays*3600*24)
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        NetworkManager
            .shared
            .queryNewsBeforeDate(date: df.string(from: Date.init(timeIntervalSince1970: queryDate)))
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .subscribe { [unowned self] (news) in
                if let date = df.date(from: news.date) {
                    df.dateFormat = "MM月dd"
                    news.date = df.string(from: date)
                }
                self.dailyNews.append(news)
                self.beforeDays += 1
                self.refreshStatus = RefreshStatus(footerRefreshing: false, noMore: false)
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}

struct RefreshStatus {
    var footerRefreshing = false
    var noMore = false
    var headerRefreshing = false
}

struct ViewData {
    var topNews: [TopNewsModel]
    var dailyNews: [DailyNewsModel]
}
