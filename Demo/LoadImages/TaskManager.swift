//
//  TaskManager.swift
//  Demo
//
//  Created by Yogendra on 7/11/18.
//  Copyright © 2018 Yogendra Singh. All rights reserved.
//

import Foundation

class TaskManager {
   
    static let shared = TaskManager()
    let session = URLSession(configuration: .default)
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    var tasks = [URL: [completionHandler]]()
    var allTasks = [URL : (Data?, URLResponse?, Error?)]()
    
    func dataTask(with url: URL, completion: @escaping completionHandler) {
        
        if tasks.keys.contains(url) {
            tasks[url]?.append(completion)
            
        } else {
            tasks[url] = [completion]
            let _ = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    
                    print("Finished network task")
                    self?.allTasks[url] = (data, response, error)
                    guard let completionHandlers = self?.tasks[url] else { return }
                    for handler in completionHandlers {
                        print("Executing completion block")
                        handler(data, response, error)
                    }
                }
            }).resume()
        }
    }
    
    func dataTaskss(with url: URL, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        
        if allTasks.keys.contains(url) {
            let task = allTasks[url]
            completion(task?.0, task?.1, task?.2)
        } else {
            let _ = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                    print("Finished network task")
                    self?.allTasks[url] = (data, response, error)
                    completion(data, response, error)
            }).resume()
        }
    }
 
}
