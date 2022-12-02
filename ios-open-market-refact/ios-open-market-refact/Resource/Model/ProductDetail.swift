//
//  ProductDetail.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation

// MARK: - ProductDetail

struct ProductDetail: Decodable {
    let id: Int
    let vendorID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let description: String
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    let images: [Image]
    let vendors: Vendors

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case description
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images
        case vendors
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int
    let url: String
    let thumbnailURL: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}

// MARK: - Vendors
struct Vendors: Codable {
    let name: String
    let id: Int
}
