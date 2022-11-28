//
//  Alert.swift
//  ios-open-market-refact
//
//  Created by Kiwon Song on 2022/11/24.
//

import UIKit

struct Alert {
    var title: String?
    var message: String?
    var style: UIAlertController.Style = .alert
}

struct AlertAction {
    var title: String?
    var style: UIAlertAction.Style = .default
    var action: ((UIAlertAction) -> Void)?
}

protocol AlertBuilderable {
    var alert: Alert { get }
    var firstAction: AlertAction { get }
    var secondAction: AlertAction { get }
    var okAction: AlertAction { get }
    var cancelAction: AlertAction { get }
    var targetViewController: UIViewController { get }
    
    func setTitle(_ title: String) -> Self
    func setMessage(_ message: String) -> Self
    func setAlertStyle(_ style: UIAlertController.Style) -> Self
    func setFirstActionTitle(_ title: String) -> Self
    func setFirstActionStyle(_ style: UIAlertAction.Style) -> Self
    func setFirstAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self
    func setSecondActionTitle(_ title: String) -> Self
    func setSecondActionStyle(_ style: UIAlertAction.Style) -> Self
    func setSecondAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self
    func setCancelButton() -> Self
    
    func show()
}

final class AlertBuilder: AlertBuilderable {
    var alert = Alert()
    var firstAction = AlertAction()
    var secondAction = AlertAction()
    var okAction = AlertAction()
    var cancelAction = AlertAction()
    var targetViewController: UIViewController
    
    init(viewController: UIViewController) {
        targetViewController = viewController
    }
    
    func setTitle(_ title: String) -> Self {
        alert.title = title
        return self
    }
    
    func setMessage(_ message: String) -> Self {
        alert.message = message
        return self
    }
    
    func setAlertStyle(_ style: UIAlertController.Style) -> Self {
        alert.style = style
        return self
    }
    
    func setFirstActionTitle(_ title: String) -> Self {
        firstAction.title = title
        return self
    }
    
    func setFirstActionStyle(_ style: UIAlertAction.Style) -> Self {
        firstAction.style = style
        return self
    }
    
    func setFirstAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self {
        firstAction.action = action
        return self
    }
    
    func setSecondActionTitle(_ title: String) -> Self {
        secondAction.title = title
        return self
    }
    
    func setSecondActionStyle(_ style: UIAlertAction.Style) -> Self {
        secondAction.style = style
        return self
    }
    
    func setSecondAction(_ action: @escaping ((UIAlertAction) -> Void)) -> Self {
        secondAction.action = action
        return self
    }
    
    func setOkButton() -> Self {
        okAction.title = "확인"
        return self
    }
    
    func setCancelButton() -> Self {
        cancelAction.title = "취소"
        cancelAction.style = .cancel
        return self
    }
    
    func show() {
        guard validAlert() else { return }
        
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
        
        [firstAction, secondAction, okAction, cancelAction].forEach { actionButton in
            if actionButton.title != nil {
                let action = UIAlertAction(title: actionButton.title, style: actionButton.style, handler: actionButton.action)
                alert.addAction(action)
            }
        }
        
        DispatchQueue.main.async { [self] in
            targetViewController.present(alert, animated: true)
        }
    }
    
    private func validAlert() -> Bool {
        let numberOfActions = [firstAction, secondAction, okAction, cancelAction]
            .compactMap { $0.title }
            .count
        
        return (alert.style == .actionSheet && numberOfActions >= 1) ||
        (alert.style == .alert && numberOfActions >= 1 && (alert.title != nil || alert.message != nil))
    }
}

struct AlertDirector {
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func createErrorAlert(message: String) {
        AlertBuilder(viewController: viewController)
            .setTitle("에러 발생")
            .setMessage(message)
            .setOkButton()
            .show()
    }
    
    func createProductEditActionSheet(editAction: @escaping (UIAlertAction) -> Void, deleteAction: @escaping (UIAlertAction) -> Void) {
        AlertBuilder(viewController: viewController)
            .setAlertStyle(.actionSheet)
            .setFirstActionTitle("수정")
            .setFirstAction(editAction)
            .setSecondActionTitle("삭제")
            .setSecondAction(deleteAction)
            .setSecondActionStyle(.destructive)
            .setCancelButton()
            .show()
    }
    
    func createProductDeleteAlert(deleteAction: @escaping (UIAlertAction) -> Void) {
        AlertBuilder(viewController: viewController)
            .setFirstActionTitle("삭제")
            .setMessage("정말 삭제하시겠습니까?")
            .setFirstAction(deleteAction)
            .setFirstActionStyle(.destructive)
            .setCancelButton()
            .show()
    }
    
    func createProductDeleteSuccessAlert(message: String) {
        AlertBuilder(viewController: viewController)
            .setTitle("삭제완료")
            .setMessage(message)
            .setOkButton()
            .show()
    }
    
    func createProductPostSuccessAlert(message: String) {
        AlertBuilder(viewController: viewController)
            .setTitle("상품 등록 완료")
            .setMessage(message)
            .setOkButton()
            .show()
    }
}

enum ProductTextConditionAlert {
    case invalidName, invalidPrice, invalidStock, success
    
    var message: String {
        switch self {
        case .invalidName:
            return "이름을 올바르게 입력해 주세요"
        case .invalidPrice:
            return "가격을 올바르게 입력해 주세요"
        case .invalidStock:
            return "재고를 올바르게 입력해 주세요"
        case .success:
            return "상품 등록 완료"
        }
    }
}
