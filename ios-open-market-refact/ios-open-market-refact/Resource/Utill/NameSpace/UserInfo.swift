//
//  UserInfo.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/10.
//

import Foundation

enum UserInfo {
    case identifier
    case secret
    
    var text: String {
        switch self {
        case .identifier:
            return "25a1ab60-4aa3-11ed-a200-058d51faf231"
        case .secret:
            return "n333s9ajdpdjf11"
        }
    }
}
