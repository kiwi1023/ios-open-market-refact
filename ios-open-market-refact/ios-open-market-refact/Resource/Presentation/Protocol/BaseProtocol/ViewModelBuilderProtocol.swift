//
//  ViewModelBuilderProtoco;.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/12/09.
//

protocol ViewModelBuilderProtocol {
    associatedtype Input
    associatedtype Output
    
    var networkAPI : SessionProtocol { get }
    
    init(networkAPI : SessionProtocol)
    func transform(input: Input) -> Output
}
