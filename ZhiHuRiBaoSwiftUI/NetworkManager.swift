//
//  NetworkManager.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/23.
//

import Foundation
import Alamofire
import RxSwift

//http://news-at.zhihu.com/api/3/stories/latest 获取今日日报
//
//http://news-at.zhihu.com/api/3/news/latest 获取今日日报
//
//http://news-at.zhihu.com/api/3/news/before/20140618 获取某个日期之前的日报
//
//http://news-at.zhihu.com/api/3/news/3977867 获取详情

enum API_PATH: String {
    case todayNews = "/news/latest"
    case newsBeforeDate = "/news/before/" //拼接20140618 查询该日前一天的news
    case newsDetail = "/news/" //拼接3977867 news id
}

class NetworkManager {
    static let shared = NetworkManager()
    private let host = "http://news-at.zhihu.com/api/3"

    func queryTodayNews() -> Single<TodayNewsModel>  {
        return Single.create { [unowned self](single) -> Disposable in
            let request = AF
                .request(self.host+API_PATH.todayNews.rawValue)
            request
                .responseJSON { response in
                    switch response.result {
                    case let .success(json):
                        if let todayNews = TodayNewsModel.deserialize(from: json as? [String: Any]) {
                            single(.success(todayNews))
                        } else {
                            single(.error(RBErrors.parseJSONError("JSON 解析错误")))
                        }
                    case let .failure(error):
                        single(.error(error))
                        print(error)
                    }
                    print(response.result)
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func queryNewsBeforeDate(date: String) -> Single<DailyNewsModel> {
        return Single.create { [unowned self](single) -> Disposable in
            let request = AF
                .request(self.host+API_PATH.newsBeforeDate.rawValue+date)
            request
                .responseJSON { response in
                    switch response.result {
                    case let .success(json):
                        if let news = DailyNewsModel.deserialize(from: json as? [String: Any]) {
                            single(.success(news))
                        } else {
                            single(.error(RBErrors.parseJSONError("JSON 解析错误")))
                        }
                    case let .failure(error):
                        single(.error(error))
                        print(error)
                    }
                    print(response.result)
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func queryNewsDetail(newsId: String) -> Single<NewsModel> {
        return Single.create { [unowned self](single) -> Disposable in
            let request = AF
                .request(self.host+API_PATH.newsDetail.rawValue+newsId)
            request
                .responseJSON { response in
                    print(response.result)
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
