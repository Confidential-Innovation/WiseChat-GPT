//
//  ChatGPTResponse.swift
//  WeChat
//
//  Created by Md Murad Hossain on 19/2/23.
//

struct ChatGPTResponse: Decodable {
    let choices: [ChatGPTCompletion]
}

struct ChatGPTCompletion: Decodable {
    let text: String
    let finishReason: String
}
