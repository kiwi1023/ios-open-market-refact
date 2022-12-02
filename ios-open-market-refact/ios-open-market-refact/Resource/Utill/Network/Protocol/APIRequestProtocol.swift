//
//  APIRequestProtocol.swift
//  ios-open-market-refact
//
//  Created by 송기원, 유한석, 이은찬 on 2022/11/10.
//

import Foundation

protocol APIRequest {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var headers: HTTPHeader? { get }
    var query: HTTPQuery? { get }
    var body: HTTPBody? { get }
    var path: HTTPPath { get }
}

extension APIRequest {
    var url: URL? {        
        var urlComponents = URLComponents(string: baseURL + path.value)
        urlComponents?.queryItems = query?.quary.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpBody = createHTTPBody()
        urlRequest.httpMethod = method.type
        headers?.header.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
}

extension APIRequest {
    private func createHTTPBody() -> Data {
        guard let body = self.body else { return Data() }
        
        switch body {
        case .json(let json):
            return json
        case .multiPartForm(let form):
            return createMultiPartFormBody(form: form)
        }
    }
    
    private func createMultiPartFormBody(form: MultiPartForm) -> Data {
        let lineBreak = "\r\n"
        var requestBody = Data()
        
        requestBody.append(createMultipartFormJsonData(
            boundary: form.boundary,
            json: form.jsonData)
        )
        
        form.images.forEach
        {
            requestBody.append(createMultipartFormImageData(
                boundary: form.boundary,
                image: $0)
            )
        }
        
        requestBody.append("\(lineBreak)--\(form.boundary)--\(lineBreak)")
        
        return requestBody
    }
    
    private func createMultipartFormJsonData(boundary: String, json: Data) -> Data {
        let lineBreak = "\r\n"
        var paramsBody = Data()
        
        paramsBody.append("\(lineBreak)--\(boundary + lineBreak)")
        paramsBody.append("Content-Disposition: form-data; name=\"params\"\(lineBreak)")
        paramsBody.append("Content-Type: application/json \(lineBreak + lineBreak)")
        paramsBody.append(json)
        
        return paramsBody
    }
    
    private func createMultipartFormImageData(boundary: String, image: ProductImage) -> Data {
        let lineBreak = "\r\n"
        let fileName = image.name + "." + image.type
        let fileType = "image/\(image.type)"
        var imageBody = Data()
        
        imageBody.append("\(lineBreak)--\(boundary + lineBreak)")
        imageBody.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName)\"\(lineBreak)")
        imageBody.append("Content-Type: \(fileType) \(lineBreak + lineBreak)")
        imageBody.append(image.data)
        
        return imageBody
    }
}
