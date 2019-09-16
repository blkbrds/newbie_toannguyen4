//
//  RequestSerializer.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2016 AsianTech Co., Ltd. All rights reserved.
//

import Alamofire
import Foundation

extension API {
  func request(urlString: String, completion: @escaping (APIResult) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(.failure(.errorURL))
      return
    }

    let config = URLSessionConfiguration.ephemeral
    if #available(iOS 11.0, *) {
      config.waitsForConnectivity = true
    } else {
      // Fallback on earlier versions
    }
    let session = URLSession.shared
    let dataTask = session.dataTask(with: url) { (data, _, error) in
      DispatchQueue.main.async {
        if let error = error {
          completion(.failure(.error(error.localizedDescription)))
        } else {
          if let data = data {
            completion(.success(data))
          }
        }
      }
    }
    dataTask.resume()
  }

  func request(url: URL, completion: @escaping (APIResult) -> Void) {
    let config = URLSessionConfiguration.ephemeral
    if #available(iOS 11.0, *) {
      config.waitsForConnectivity = true
    } else {
      // Fallback on earlier versions
    }
    let session = URLSession.shared
    let dataTask = session.dataTask(with: url) { (data, _, error) in
      DispatchQueue.main.async {
        if let error = error {
          completion(.failure(.error(error.localizedDescription)))
        } else {
          if let data = data {
            completion(.success(data))
          }
        }
      }
    }
    dataTask.resume()
  }
}
