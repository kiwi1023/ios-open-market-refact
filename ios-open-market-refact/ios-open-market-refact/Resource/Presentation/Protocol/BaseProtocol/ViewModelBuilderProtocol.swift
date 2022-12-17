//
//  ViewModelBuilderProtocol.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/12/17.
//

protocol ViewModelBuilder {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
