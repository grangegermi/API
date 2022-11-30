//
//  model.swift
//  Api2
//
//  Created by Даша Волошина on 29.11.22.
//

import Foundation

class Model {
    
    weak var viewController: ViewController?
    
    let urlPhoto = URL(string: "https://jsonplaceholder.typicode.com/photos")!
    let urlUser = URL(string: "https://jsonplaceholder.typicode.com/users")!
    
    
    var photos: [Photos] = [] {
        didSet {
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
            
        }
    }
    
    var users:[User] = [] {
        
        didSet {
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
        }
    }
    
    var finalPhotos:[FinalPhotos] = []{
        
        didSet{
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
            
        }
    }
    var tenFinalPhotos:ArraySlice<FinalPhotos> = []{
        
        didSet{
            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
            
        }
    }
    
    
    func createPhoto() {
        
        let group = DispatchGroup()
        
        var requestPhoto = URLRequest(url: self.urlPhoto)
        requestPhoto.httpMethod = "GET"
        
        group.enter()
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: requestPhoto) { [weak self]  data,  response, error in
                
                guard let data = data else {return}
                
                do {
                    
                    self?.photos = try JSONDecoder().decode([Photos].self, from: data)
                    Swift.print(self?.photos.count)
                    
                }catch{
                    Swift.print(error)
                }
                group.leave()
            }
            
            task.resume()
            
        }
        
        
        var requestUser = URLRequest(url: self.urlUser)
        requestUser.httpMethod = "GET"
        
        group.enter()
        DispatchQueue.main.async {
            let task1 = URLSession.shared.dataTask(with: requestUser) { [weak self] data,  response, error in
                guard let data = data else {return}
                
                do {
                    self?.users = try JSONDecoder().decode([User].self, from: data)
                    Swift.print(self?.users.first?.name)
                    
                } catch {
                    Swift.print(error)
                }
                group.leave()
            }
            
            task1.resume()
            
        }
        
        group.notify(queue: .main) {
            self.finalPhotos = self.users.enumerated().map {
                return FinalPhotos(id: $0.element,
                                   albumId: self.photos[$0.offset].albumId,
                                   title:self.photos[$0.offset].title,
                                   url: self.photos[$0.offset].url,
                                   thumbnailUrl: self.photos[$0.offset].thumbnailUrl)}
            
            self.tenFinalPhotos = self.finalPhotos.prefix(through: 9)
            print(self.tenFinalPhotos.count)
            
        }
        
    }
    
    
    
    func createPost() {
        
        let photo:[String:Any] = [
            "albumId": 1,
            "id":50001,
            "title":"title",
            "url":"https://via.placeholder.com/600/771796",
            "thumbnailUrl":"https://via.placeholder.com/600/771796"]
        
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
        
        
        let session = URLSession.shared
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: photo, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                    print(jsonResponse)
                    
                } else {
                    print("data maybe corrupted or in wrong format")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func delete (id:Int, completion: @escaping(Error?) -> ()){
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos/\(id-1)") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()
        
    }
    
}
