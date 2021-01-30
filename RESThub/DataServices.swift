//
//  DataServices.swift
//  RESThub
//
//  Created by HeyCode Inc. on 1/30/21.
//  Copyright © 2021 Harrison. All rights reserved.
//

import Foundation

class DataServices{
    static let shared = DataServices()
    fileprivate let baseURLString = "https://api.github.com"
    
    func fetchGists(completion: @escaping (Result<[Gist],Error>) -> Void){
//        var baseURL = URL(string: baseURLString)
//        baseURL?.appendPathComponent("/somePath")
//
//        let compusedURL = URL(string: "/somePath", relativeTo: baseURL)
//        print(baseURL!)
//        print(compusedURL?.absoluteString ?? "Relative URL failed...")
        
        var componentURL = URLComponents()
        componentURL.scheme = "https"
        componentURL.host = "api.github.com"
        componentURL.path = "/gists/public"
        
        guard let validURL = componentURL.url else{
            print("URL creation failed...")
            return
        }
        
        URLSession.shared.dataTask(with: validURL) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
                print("API status: \(httpResponse.statusCode)")
            }
            
            guard let validData = data, error == nil else{
                completion(.failure(error!))
                return
            }
            
            do{
//                let json = try JSONSerialization.jsonObject(with: validData, options: [])
                let gists = try JSONDecoder().decode([Gist].self, from: validData)
                completion(.success(gists))
                
            }catch let serializationError{
                completion(.failure(serializationError))
            }
            
            
        }.resume()
    }
}
