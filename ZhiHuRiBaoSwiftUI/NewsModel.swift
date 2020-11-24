//
//  RiBaoModel.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/20.
//

import Foundation
import HandyJSON

class NewsModel: HandyJSON, ObservableObject {
    var images: [String] = ["haitun"]
    var title: String = String.testStringShort
    var hint: String = String.testStringShort
    var url: String = "url"
    var id: Int = 1111
    var type: Int = 0
    required init() {

    }

    init(images: [String], title: String) {
        self.images = images
        self.title = title
    }
}

class TopNewsModel: HandyJSON, ObservableObject {
    var image: String = "haitun"
    var title: String = String.testStringShort
    var hint: String = String.testStringShort
    var url: String = "url"
    var id: Int = 1111
    var type: Int = 0
    required init() {

    }
}

class TodayNewsModel: HandyJSON, ObservableObject {
    var stories: [NewsModel] = [NewsModel()]
    var top_stories: [TopNewsModel] = [TopNewsModel(),TopNewsModel(),TopNewsModel(),TopNewsModel()]
    required init() {

    }
}

class DailyNewsModel: HandyJSON, ObservableObject {
    var date: String = ""
    var stories: [NewsModel] = [NewsModel()]
    required init() {

    }
}
