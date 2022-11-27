//
//  json.swift
//  Api2
//
//  Created by Даша Волошина on 26.11.22.
//

import Foundation


struct FinalPhotos:Codable {
    
    let id: User
    let albumId: Int
    let title: String
    let url : URL
    let thumbnailUrl: URL
    
}

//{
//   "albumId": 1,
//   "id": 1,
//   "title": "accusamus beatae ad facilis cum similique qui sunt",
//   "url": "https://via.placeholder.com/600/92c952",
//   "thumbnailUrl": "https://via.placeholder.com/150/92c952"
// }


struct Photos:Decodable {

    let albumId:Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL


}


//
//{
//   "id": 1,
//   "name": "Leanne Graham",
//   "username": "Bret",
//   "email": "Sincere@april.biz",
//   "address": {
//     "street": "Kulas Light",
//     "suite": "Apt. 556",
//     "city": "Gwenborough",
//     "zipcode": "92998-3874",
//     "geo": {
//       "lat": "-37.3159",
//       "lng": "81.1496"
//     }
//   },
//   "phone": "1-770-736-8031 x56442",
//   "website": "hildegard.org",
//   "company": {
//     "name": "Romaguera-Crona",
//     "catchPhrase": "Multi-layered client-server neural-net",
//     "bs": "harness real-time e-markets"
//   }
// },


struct User:Codable {

    let id:Int
    let name:String
    let username :String
    let email:String
    let address:Adress
    let phone:String
    let website:String
    let company:Company

}

struct Adress:Codable{

    let street:String
    let suite:String
    let city:String
    let zipcode:String
    let geo:Geo
}

struct Geo:Codable{
    let lat: String
    let lng:String
}

struct Company:Codable{
    let name:String
    let catchPhrase:String
    let bs:String

}
