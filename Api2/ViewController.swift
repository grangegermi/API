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
import SnapKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var model = Model()

    var tableView = UITableView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        createConstraints()
        
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(buttonTap))
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        
     
            self.model.viewController = self
            self.model.createPhoto()

    }
    
    func createConstraints (){
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
            return   model.tenFinalPhotos.count

            
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
//
      
                cell.label.text = self.model.tenFinalPhotos[indexPath.row].id.name
                cell.viewImage.sd_setImage(with: self.model.tenFinalPhotos[indexPath.row].url)
  
        
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
        }
        
        //        @objc func buttonTap(_ sender:UINavigationBa) {
        //
        //
        //
        //    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
                print("Error: cannot create URL")
                return
            }
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling DELETE")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
    }
    





