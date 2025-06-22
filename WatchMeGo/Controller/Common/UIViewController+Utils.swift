//
//  UIViewController+Utils.swift
//  WatchMeGo
//
//  Created by Liza on 22/06/2025.
//

import UIKit

extension UIViewController {

    func showAlert(
        title: String,
        message: String,
        okTitle: String = "OK",
        cancelTitle: String? = nil,
        okHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            okHandler?()
        }
        alert.addAction(ok)
        
        if let cancelTitle = cancelTitle {
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
            alert.addAction(cancel)
        }

        present(alert, animated: true)
    }

    func clearTextField(_ textField: UITextField) {
        textField.text = ""
        textField.resignFirstResponder()
    }
}
