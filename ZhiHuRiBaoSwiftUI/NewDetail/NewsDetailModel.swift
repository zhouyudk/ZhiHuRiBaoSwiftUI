//
//  NewsDetailModel.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/12/3.
//

import Foundation
import HandyJSON

class NewsDetailModel: HandyJSON, ObservableObject {
    var body: String = ""
    var title: String = ""
    var image: String = ""
    var id: Int = 0
    var images: [String] = []
    required init() {

    }
}
