//
//  OpenMarketRequest.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation

struct OpenMarketRequest: APIRequest {
    var method: HTTPMethod
    var baseURL: String
    var headers: [String : String]?
    var query: [String : String]?
    var body: HTTPBody?
    var path: String
}

final class OpenMarketRequestBuilder {
    private var method: HTTPMethod?
    private var baseURL: String
    private var headers: [String : String]?
    private var query: [String : String]?
    private var body: HTTPBody?
    private var path: String?
    
    init() {
        self.baseURL = URLHost.openMarket.url
    }
    
    func setBaseURL(_ url: String) -> OpenMarketRequestBuilder  {
        self.baseURL = url
        return self
    }
    
    func setMethod(_ method: HTTPMethod) -> OpenMarketRequestBuilder {
        self.method = method
        return self
    }
    
    func setPath(_ path: String) -> OpenMarketRequestBuilder {
        self.path = path
        return self
    }
    
    func setQuery(_ query: [String : String]) -> OpenMarketRequestBuilder {
        self.query = query
        return self
    }
    
    func setBody(_ body: HTTPBody) -> OpenMarketRequestBuilder {
        self.body = body
        return self
    }
    
    func setHeaders(_ headers: [String: String]) -> OpenMarketRequestBuilder {
        self.headers = headers
        return self
    }
    
    func buildRequest() -> OpenMarketRequest? {
        guard let method = method, let path = path else {
                    return nil
                }
        
        let marketRequest = OpenMarketRequest(method: method,
                                              baseURL: baseURL,
                                              headers: headers,
                                              query: query,
                                              body: body,
                                              path: path)
        
        return marketRequest
    }
}

struct OpenMarketRequestDirector {
    private let builder: OpenMarketRequestBuilder
    
    init(_ builder: OpenMarketRequestBuilder = OpenMarketRequestBuilder()) {
        self.builder = builder
    }
    
   func createGetRequest(pageNumber: Int, itemsPerPage: Int) -> OpenMarketRequest? {
        let getRequest = builder.setMethod(.get)
            .setPath(URLAdditionalPath.product.value)
            .setQuery(["page_no": "\(pageNumber)", "items_per_page": "\(itemsPerPage)"])
            .buildRequest()
        
        return getRequest
    }
    
    func createGetDetailRequest(_ productNumber: Int) -> OpenMarketRequest? {
        let getDetailRequest = builder.setMethod(.get)
            .setPath(URLAdditionalPath.product.value + "/\(productNumber)")
            .buildRequest()
        
        return getDetailRequest
    }
    
    func createPostRequest(product: RegistrationProduct, images: [ProductImage]) -> OpenMarketRequest? {
        guard let productData = try? JSONEncoder().encode(product) else { return nil }

        let boundary = "Boundary-\(UUID().uuidString)"
        let postRequest = builder.setMethod(.post)
            .setPath(URLAdditionalPath.product.value)
            .setBody(HTTPBody.multiPartForm(MultiPartForm(boundary: boundary,
                                                          jsonData: productData,
                                                          images: images)))
            .setHeaders(["Content-Type": "multipart/form-data; boundary=\(boundary)",
                         "identifier": UserInfo.identifier])
            .buildRequest()

        return postRequest
    }
    
    func createPatchRequest(product: RegistrationProduct, productNumber: Int) -> OpenMarketRequest? {
        guard let productData = try? JSONEncoder().encode(product) else { return nil }
        
        let patchRequest = builder.setMethod(.patch)
            .setPath(URLAdditionalPath.product.value + "/\(productNumber)/")
            .setHeaders(["identifier": UserInfo.identifier,
                        "Content-Type": "application/json"])
            .setBody(HTTPBody.json(productData))
            .buildRequest()
        
        return patchRequest
    }
    
    func createDeleteURIRequest(productNumber: Int) -> OpenMarketRequest? {
        let body = ProductDeleteKey(secret: UserInfo.secret)
        
        guard let data = try? JSONEncoder().encode(body) else { return nil }

        let deleteURIRequest = builder.setMethod(.post)
            .setPath(URLAdditionalPath.product.value + "/\(productNumber)/archived")
            .setHeaders(["Content-Type": "application/json",
                         "identifier": UserInfo.identifier])
            .setBody(HTTPBody.json(data))
            .buildRequest()
        
        return deleteURIRequest
    }
    
    func createDeleteRequest(with deleteURI: String) -> OpenMarketRequest? {
        let deleteRequest = builder.setMethod(.delete)
            .setPath(deleteURI)
            .setHeaders(["identifier": UserInfo.identifier])
            .buildRequest()
        
        return deleteRequest
    }
}
