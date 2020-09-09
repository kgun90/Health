//
//  ExtensionTextField.swift
//  Health
//
//  Created by Geon Kang on 2020/08/13.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit

extension UITextField {
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
