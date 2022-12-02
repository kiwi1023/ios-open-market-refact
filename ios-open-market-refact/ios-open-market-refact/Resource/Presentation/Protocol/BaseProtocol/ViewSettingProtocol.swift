//
//  ViewControllerSettingProtocol.swift
//  ios-open-market-refact
//
//  Created by 유한석 on 2022/11/17.
//

import UIKit

protocol ViewSettingProtocol {
    
    init()
    
    func setupDefault()
    func addUIComponents()
    func setupLayout()
}

class SuperViewControllerSetting: UIViewController , ViewSettingProtocol {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder :)")
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupDefault()
        addUIComponents()
        setupLayout()
    }
    
    func setupDefault() { }
    func addUIComponents() { }
    func setupLayout() { }
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
    
    func setupDefault() { }
    func addUIComponents() { }
    func setupLayout() { }
}
