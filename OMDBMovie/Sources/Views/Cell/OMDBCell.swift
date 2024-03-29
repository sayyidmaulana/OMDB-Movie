//
//  OMDBCell.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import UIKit

protocol OMDBCellViewModel {
    var image: String { get }
    var title: String { get }
}

class OMDBCell: UICollectionViewCell {

    static let cellID = "OMDBCell"

    private let imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let labelView: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 16)
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(labelView)
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelView.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 16),
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func loadImage(from: Data) {
        imgView.image = UIImage(data: from)
    }

    func set(viewModel: OMDBCellViewModel) {
        imgView.loadImage(from: viewModel.image)
        labelView.text = viewModel.title
    }
    
    
}
