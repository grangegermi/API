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
        view.backgroundColor = .yellow
        view.addSubview(tableView)
        
        createConstraints()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(buttonTap))
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        
        
        self.model.viewController = self
        self.model.createPhoto()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        return 100
    }
//    
    @objc func buttonTap(_ sender:UIButton) {
        
        model.createPost()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        model.delete(id: model.finalPhotos[indexPath.row].id.id){(error) in
            if let error = error {
                print(error)
                
                return
            }
            print("delete from server")

            self.model.tenFinalPhotos.remove(at: indexPath.row)
            tableView.reloadData()

         
        }
    }

}

