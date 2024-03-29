//
//  Extensions+Constraints.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import UIKit

extension UIView {

    func setAnchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,
                   bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,
                   paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat,
                   width: CGFloat = 0, height: CGFloat = 0) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            self.leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            self.trailingAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    var setTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }

    var setLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        }

        return leadingAnchor
    }

    var setBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }

        return bottomAnchor
    }

    var setRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        }

        return trailingAnchor
    }
}
