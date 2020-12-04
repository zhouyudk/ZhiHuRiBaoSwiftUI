//
//  NewsDetailViewModel.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/12/3.
//

import Foundation
import RxSwift

class NewsDetailViewModel: ObservableObject {
    @Published var newsDetail = NewsDetailModel()
    private let disposeBag = DisposeBag()
    func fetchNewsDetail(id: Int) {
        NetworkManager
            .shared
            .queryNewsDetail(newsId: id)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .subscribe(onSuccess: {[weak self] (model) in
                guard let self = self else { return }
                self.newsDetail = model
            }, onError: { (error) in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
