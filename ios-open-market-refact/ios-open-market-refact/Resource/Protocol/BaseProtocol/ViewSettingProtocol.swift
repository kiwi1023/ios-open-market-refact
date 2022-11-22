//
//  ViewControllerSettingProtocol.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/17.
//

import UIKit

protocol ViewSettingProtocol {
    
    init()
    /*
     setupDefault()
     NavigationController 관련 작업
     delegate 설정 작업
     */
    func setupDefault()
    /*
     UI Component들을 view 에 추가 하는 작업
     */
    func addUIComponents()
    /*
     뷰의 AutoLayout 지정
     */
    func setupLayout()
}

class SuperViewControllerSetting: UIViewController , ViewSettingProtocol {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder :)")
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        setupDefault()
        addUIComponents()
        setupLayout()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    func setupDefault() {
        
    }
    
    func addUIComponents() {
       
    }
    
    func setupLayout() {
       
    }
}

class SuperViewSetting: UIView , ViewSettingProtocol {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder :)")
    }
    
    required init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        setupDefault()
        addUIComponents()
        setupLayout()
    }
    
    func setupDefault() {
        
    }
    
    func addUIComponents() {
       
    }
    
    func setupLayout() {
       
    }
}
