//
//  ViewController.swift
//  Api2
//
//  Created by Даша Волошина on 26.11.22.
//
//Самостоятельная работа: самостоятельно загрузить данные с выбранного
//АПИ
//https://jsonplaceholder.typicode.com/photos, https://jsonplaceholder.typicode.com/users, распарсить, взять первых 10 элементов, Подменить id внутри Photos на самого Юзера, отобразить на экране ячейку в TableView. Показать Картинку(спользуем SDWebImage или Kingfisher) и Имя пользователя. При нажатии на ячейку -> Удалить из локальных данных Photo(Отправить запрос на сервер DELETE). В navigationBar добавляем “+”. По нажатии на него отправляем запрос на создание ресурса (POST). Незабываем обновлять данные.
//PS. Для создания запросов Post и Delete есть гайд - https://jsonplaceholder.typicode.com/guide/ , тк этот сервис предоставляет тестовые данные, POST и DELETE на основные данные не повлияют. И как всегда если будут вопросы - я к ним готов. На это задание у вас будет время до 28 ноября. Почему такой срок, потому что это похоже на тестовое задание для джунов


import UIKit

class ViewController: UIViewController {
    
    let urlPhoto = URL(string: "https://jsonplaceholder.typicode.com/photos")!
    let urlUser = URL(string: "https://jsonplaceholder.typicode.com/users")!
    var finalPhotos:[FinalPhotos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlArray:[URL] = [urlPhoto, urlUser]
        var group = DispatchGroup()
        let queueConcurrent = DispatchQueue(label: "urls", attributes: .concurrent)
        
        for url in urlArray {
                
            group.enter()
            queueConcurrent.async {
                    
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) {  data, response, error in
                    
                    guard let data = data else{return}
                    var finalData:[Photos] = []
                    var finalData2:[User] = []
                    do {
                        finalData = try JSONDecoder().decode([Photos].self , from:  data)
//                        var newArrayPhotos = finalData.prefix(through: 9)
//                        print (newArrayPhotos.count)
                        
                    } catch {
                        print(error)
                    }
//                    print(finalData)
                    do {
                        let finalData2 = try JSONDecoder().decode([User].self , from:  data)
                        
//                        var newArrayUser = finalData2.prefix(through: 9)
//                        print (newArrayUser.count)
                        
                    } catch {
                        print(error)
                    }
                  
                    self.finalPhotos = finalData2.enumerated().map{
                        return FinalPhotos(albumId: finalData[$0.offset].albumId,
                                           id: $0.element,
                                           title: finalData[$0.offset].title,
                                           url: finalData[$0.offset].url,
                                           thumbnailUrl: finalData[$0.offset].thumbnailUrl)
      
                    print(self.finalPhotos.first?.title)
                }
                    task.resume()

                    group.leave()
             
                }
                group.wait()
            }
         
              group.notify(queue: .main){
                  print("All uploaded")
              }
    
    }
}
