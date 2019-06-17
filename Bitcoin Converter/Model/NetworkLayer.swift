//
//  NetworkLayer.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/11/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import Foundation

protocol NetworkLayer {
    static var shared: Self { get }
    func request(to api: BitcoinConverterAPI, queryItems: [String: String?]?, handle: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkLayerImp: NetworkLayer {
    
    static var shared = NetworkLayerImp()
    
    // Not the best solution, I know
    private init() {}
    
    func request(to api: BitcoinConverterAPI, queryItems: [String: String?]? = nil, handle: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: api.urlString) else {
            return assertionFailure("Failure creating URL from given string: \(api.urlString)") }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems?.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        URLSession.shared.dataTask(with: components?.url ?? url) { data, response, error in
            if let error = error {
                handle(.failure(error))
            }
            
            if let data = data {
                handle(.success(data))
            }
        }.resume()
    }
}
