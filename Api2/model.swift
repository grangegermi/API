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
    
    
    var photos: [Photos] = []
    {
        didSet {
            viewController?.tableView.reloadData()
        }
    }
    var users:[User] = []
    {

        didSet {
            viewController?.tableView.reloadData()
        }
    }
    
    var finalPhotos:[FinalPhotos] = []
    {

        didSet{
            viewController?.tableView.reloadData()
        }
    }
    var tenFinalPhotos:ArraySlice<FinalPhotos> = []
    {
        
        didSet{
            viewController?.tableView.reloadData()
        }
    }
//    
    
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
                Swift.print(self?.photos.first?.url)
                
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

    
}


