//
//  ImageLoader.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 08/10/2025.
//

import Foundation
import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
        cache.countLimit = 200
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
    enum LoaderError: Error {
        case invalidData
    }
    
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let key = url as NSURL
        if let cached = cache.object(forKey: key) {
            completion(.success(cached))
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let self, let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(.failure(LoaderError.invalidData)) }
                return
            }
            self.cache.setObject(image, forKey: key, cost: data.count)
            DispatchQueue.main.async { completion(.success(image)) }
        }.resume()
    }
}
