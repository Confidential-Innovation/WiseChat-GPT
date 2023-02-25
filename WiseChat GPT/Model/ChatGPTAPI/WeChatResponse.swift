//
//  WeChatResponse.swift
//  WeChat
//
//  Created by Md Murad Hossain on 19/2/23.
//

import Foundation

struct WeChatResponse: Decodable {
    let data: [ImageURL]
}

struct ImageURL: Decodable {
    let url: String
}
