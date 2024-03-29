//
//  Extensions+UIImageView.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import UIKit.UIImageView

extension UIImageView {
    func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }

                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }

            task.resume()
        }
    }
}
