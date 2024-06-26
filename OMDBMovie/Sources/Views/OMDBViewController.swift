//
//  OMDBViewController.swift
//  OMDBMovie
//
//  Created by sayyid.maulana.yakin on 29/03/24.
//

import UIKit

protocol OMDBViewProtocol: AnyObject {
    var presenter: OMDBPresenterInput? { get set }
    
    func setupView()
    func setupCollection()
    func setupSearch()
    func reloadOMDB()
    func displayError(message: String)
}

class OMDBViewController: UIViewController {
    
    var presenter: OMDBPresenterInput?
    
    var spinner = UIActivityIndicatorView(style: .large)

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let imageError: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "errorState")
        return img
    }()
    
    let labelError: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 32)
        label.text = "Something went wrong!"
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        title = "OMDB Movie Screen"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupCollection() {
        containerView.backgroundColor = .white
        collectionView.backgroundColor = .white

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OMDBCell.self, forCellWithReuseIdentifier: OMDBCell.cellID)

        view.addSubview(containerView)
        containerView.addSubview(imageError)
        containerView.addSubview(labelError)
        containerView.addSubview(collectionView)

        imageError.setAnchor(top: view.safeAreaLayoutGuide.topAnchor,
                             left: view.leadingAnchor,
                             bottom: nil,
                             right: view.trailingAnchor,
                             paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                             width: 200, height: 200)
        labelError.setAnchor(top: imageError.bottomAnchor, left: view.leadingAnchor, bottom: nil, right: view.trailingAnchor, paddingTop: 70, paddingLeft: 24, paddingBottom: 0, paddingRight: 24)
        containerView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor,
                                left: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                right: view.trailingAnchor,
                                paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        collectionView.setAnchor(top: containerView.topAnchor,
                                 left: containerView.leadingAnchor,
                                 bottom: containerView.bottomAnchor,
                                 right: containerView.trailingAnchor,
                                 paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.setAnchor(top: view.topAnchor,
                          left: view.leadingAnchor,
                          bottom: nil,
                          right: view.trailingAnchor,
                          paddingTop: 350, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 0)
    }
    
    func setupSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Cari di OMDB"
        navigationItem.searchController = search
    }
    
}

extension OMDBViewController: OMDBViewProtocol {
    func reloadOMDB() {
        collectionView.reloadData()
        self.spinner.isHidden = true
    }

    func displayError(message: String) {
        collectionView.isHidden = true
        self.spinner.isHidden = true
        labelError.text = message
        print(message)
    }
}

extension OMDBViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else { return .zero }
        return presenter.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let presenter = presenter else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OMDBCell.cellID, for: indexPath) as? OMDBCell else { return UICollectionViewCell() }
        let viewModel = presenter.viewModel(at: indexPath)
        self.presenter?.getDataImage(path: viewModel.image) { dataImage in
            DispatchQueue.main.async {
                cell.loadImage(from: dataImage)
            }
        }
        cell.set(viewModel: viewModel)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            presenter?.fetchOMDB(page: 2)
        }

        if scrollView.contentOffset.y >= 0 {
            presenter?.updatePage(page: self.presenter?.page ?? 1, keyword: self.presenter?.keyword ?? "")
        }
    }
}

extension OMDBViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        presenter?.searchOMDB(page: 1, keyword: text)
        presenter?.keyword = text
        print(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.isEnabled {
            presenter?.fetchOMDB(page: 1)
        }
    }
}

extension OMDBViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 3
        let cellHeight: CGFloat = 350
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
    }
}
