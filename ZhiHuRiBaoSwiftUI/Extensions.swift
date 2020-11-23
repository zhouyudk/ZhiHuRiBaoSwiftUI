//
//  extensions.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/12.
//

import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension UIApplication {
    static let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
}


extension String {
    static let testStringShort = "Test String Short"
}

