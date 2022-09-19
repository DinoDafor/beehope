import Foundation
import UIKit

class ApplicationModel {
    public var items = [Application]()
    
    private let basePath = "https://bee-hope.herokuapp.com/api"
    
    private func parseArrayWith(data: NSArray) {
        self.items = [Application]()
        guard data.count != 0 else {
            return
        }
        
        for item in data {
            if let application = Application(json: item as! [String: Any]) {
                items.append(application)
            }
        }
    }
    
    public func fillImages(with completion: @escaping () -> Void) {
        let group = DispatchGroup()
        for i in 0..<(items.count) {
            group.enter()
            if let photoLink = items[i].photoLink, photoLink.count > 0 {
                self.downloadImage(with: photoLink) {[weak self] image in
                    self?.items[i].photo = image
                    group.leave()
                }
            } else {
                items[i].photo = ApplicationCell.placeHolderPhoto()
                group.leave()
            }
        }
        let _ = group.wait(timeout: .now() + 4)
        completion()
        print("All images downloaded")
    }
    
    private func downloadImage(with link: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: link)!
            let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
                if let data = data {
                    completion(UIImage(data: data))
                }
            }
            dataTask.resume()
    }
    
    public func getApplicationList(completionHandler: @escaping ([Application]) -> Void) {
        let urlPath = "\(basePath)/requests"
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            print("Task completed")

            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data) as? NSArray {
                        DispatchQueue.main.async { 
                            self.parseArrayWith(data: jsonResult)
                            completionHandler(self.items)
                    }
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
        }

        task.resume()
    }
    
    public func sendToServer(application: Application) {
        let urlPath = "\(basePath)/requests"
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: String] = [
            "name": application.animal,
            "description": application.description ?? "",
            "coordinates": application.location ?? "",
            "image": application.photoLink ?? ""
        ]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: parameters, 
            options: []
        )
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard  
                let response = response as? HTTPURLResponse, 
                error == nil 
            else {
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
        }
        task.resume()
    }
    
    public func deleteAllApplications() {
        let urlPath = "\(basePath)/requests/delete"
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            print("Task completed")
        }

        task.resume()
    }
}
