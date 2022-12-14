//
//  RegistrationProduct.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

struct RegistrationProduct: Encodable {
    let name: String
    let description: String
    let price: Double
    let currency: String
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case price
        case currency
        case stock
        case secret
        case discountedPrice = "discounted_price"
    }
}
