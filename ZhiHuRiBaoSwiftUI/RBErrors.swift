//
//  RBErrors.swift
//  ZhiHuRiBaoSwiftUI
//
//  Created by yu zhou on 2020/11/23.
//

enum RBErrors: Error {
    case network(String)
    case objectNotFound(String)
    case parseJSONError(String)
    case requestParameterError(String)
}
