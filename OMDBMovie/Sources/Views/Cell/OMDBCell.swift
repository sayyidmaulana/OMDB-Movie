//
//  OMDBCell.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import UIKit

protocol OMDBCellViewModel {
    var image: String { get }
}

class OMDBCell: UICollectionViewCell {

    static let cellID = "OMDBCell"

    private let imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(imgView)
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func loadImage(from: Data) {
        imgView.image = UIImage(data: from)
    }

    func set(viewModel: OMDBCellViewModel) {
        imgView.loadImage(from: viewModel.image)
    }
    
    
}
