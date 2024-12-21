//
//  AlbumDetailsViewController.swift
//  UserAlbumsChallenge
//
//  Created by mac on 21/12/2024.
//

import UIKit
import Combine

class AlbumDetailsViewController: UIViewController {
    
    @IBOutlet private weak var photoesTitle: UILabel!
    @IBOutlet private weak var photosCollectionView: UICollectionView!
    private let viewModel: AlbumDetailsViewModelType
    private var subscriptions = Set<AnyCancellable>()
    private var albumPhotosDataSource: [Photo] = []
    private var filteredPhotos: [Photo] = []
    
    init(viewModel: AlbumDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    func initializeFilteredPhotos() {
        filteredPhotos = albumPhotosDataSource
    }
}

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

private extension AlbumDetailsViewController {
    func bindViewModel() {
        bindAlbumPhotos()
    }
    func bindAlbumPhotos() {
        viewModel.albumPhotosPubliser
            .receive(on: DispatchQueue.main)
            .sink {[weak self] photos in
                guard let self else { return }
                albumPhotosDataSource = photos?.0 ?? []
                initializeFilteredPhotos()
                photoesTitle.text = photos?.albumTitle
                photosCollectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
}

extension AlbumDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(photoURL: filteredPhotos[indexPath.row].toURL())
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width / 3), height: collectionView.frame.height / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension AlbumDetailsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPhotos = searchText.isEmpty ? albumPhotosDataSource : albumPhotosDataSource.filter { $0.title.localizedCaseInsensitiveContains(searchText)}
        photosCollectionView.reloadData()
    }
}
