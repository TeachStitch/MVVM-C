//
//  UIViewController.swift
//

import UIKit

protocol CoordinatorHolder {}

extension UIViewController {
    private enum AssociatedObjectKey {
        static var coordinator = "UIViewControllerCoordinatorKey"
    }
    
    var coordinator: CoordinatorHolder? {
        get { return objc_getAssociatedObject(self, &AssociatedObjectKey.coordinator) as? CoordinatorHolder }
        set { objc_setAssociatedObject(self, &AssociatedObjectKey.coordinator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
