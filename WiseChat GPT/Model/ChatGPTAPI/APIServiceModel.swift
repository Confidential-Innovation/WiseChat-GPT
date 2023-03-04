//
//  APIServiceModel.swift
//  WeChat
//
//  Created by Md Murad Hossain on 19/2/23.
//

import UIKit

enum APIError: Error {
    case unableToCreateImageURL
    case unableToConvertDataIntoImage
    case unableToCreateURLForURLRequest
}

class APIService {
    
    let apiKey = "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"
    
    func fetchImageForPrompt(_ prompt: String) async throws -> UIImage {
        let fetchImageURL = "https://api.openai.com/v1/images/generations"
        let urlRequest = try createURLRequestFor(httpMethod: "POST", url: fetchImageURL, prompt: prompt, weChat: true)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
      
        let decoder = JSONDecoder()
        let results = try decoder.decode(WiseChatResponse.self, from: data)

        let imageURL = results.data[0].url
        guard let imageURL = URL(string: imageURL) else {
            throw APIError.unableToCreateImageURL
        }
        
        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
        
        guard let image = UIImage(data: imageData) else {
            throw APIError.unableToConvertDataIntoImage
        }
        
        return image
    }
    
    private func createURLRequestFor(httpMethod: String, url: String, prompt: String, weChat: Bool) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw APIError.unableToCreateURLForURLRequest
        }
        
        var urlRequest = URLRequest(url: url)
        
        // Method
        urlRequest.httpMethod = httpMethod
        
        // Headers
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
       
        
        // Body
        if weChat {
            let jsonBody: [String: Any] = [
                "prompt": "\(prompt)",
                "n": 1,
                "size": "1024x1024"
            ]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        } else {
            let jsonBody: [String: Any] = [
                "model": "text-davinci-003",
                "prompt": "\(prompt)",
                "max_tokens": 1000
            ]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        }
        
        return urlRequest
    }
    
    func sendPromtToGPT(promt: String) async throws -> String {
        let completionURL = "https://api.openai.com/v1/completions"
        
        let urlRequest = try createURLRequestFor(httpMethod: "POST", url: completionURL, prompt: promt, weChat: false)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let results = try decoder.decode(ChatGPTResponse.self, from: data)
        return results.choices[0].text
        
    }
}

