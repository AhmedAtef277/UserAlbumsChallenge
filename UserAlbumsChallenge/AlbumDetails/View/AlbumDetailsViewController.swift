//
//  AlbumDetailsViewController.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import UIKit
import Combine

class AlbumDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var photoesTitle: UILabel!
    @IBOutlet private weak var photosCollectionView: UICollectionView!
    
    // MARK: - Properties
    private let viewModel: AlbumDetailsViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: AlbumDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
}

// MARK: - Setup UI
private extension AlbumDetailsViewController {
    func setupUI() {
        setupCollectionView()
    }
    func setupCollectionView() {
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.register(UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
}

// MARK: - Bind ViewModel
private extension AlbumDetailsViewController {
    func bindViewModel() {
        bindAlbumPhotos()
        bindError()
    }
    
    func bindAlbumPhotos() {
        viewModel.albumPhotosPubliser
            .receive(on: DispatchQueue.main)
            .sink {[weak self] photos in
                guard let self else { return }
                photoesTitle.text = viewModel.selectedAlbumTitle
                photosCollectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    func bindError() {
        viewModel.errorMessagePubliser
            .receive(on: DispatchQueue.main)
            .sink {[weak self] error in
                guard let self, let error else { return }
                showAlert(errorMessage: error)
            }
            .store(in: &subscriptions)
    }
}

extension AlbumDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getFilteredPhotosCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(photoURL: viewModel.getAlbumPhotos(at: indexPath).toURL())
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width / 3), height: collectionView.frame.height / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 0 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 0 }
}

extension AlbumDetailsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateFilteredPhotos(accordingTo: searchText)
        photosCollectionView.reloadData()
    }
}
