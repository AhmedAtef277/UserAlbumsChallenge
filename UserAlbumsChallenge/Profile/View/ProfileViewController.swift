//
//  ProfileViewController.swift
//  UserAlbumsChallenge
//
//  Created by mac on 20/12/2024.
//

import UIKit
import Combine

final class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var userAddressLabel: UILabel!
    @IBOutlet weak private var albumsTableView: UITableView!
    
    // MARK: - Properties
    private let viewModel: ProfileViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: ProfileViewModelType) {
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
private extension ProfileViewController {
    func setupUI() {
        setupTableView()
    }
    
    func setupTableView() {
        albumsTableView.dataSource = self
        albumsTableView.delegate = self
        albumsTableView.register(UINib(nibName: AlbumsTableViewCell.identifier, bundle: nil),
                                 forCellReuseIdentifier: AlbumsTableViewCell.identifier)
    }
}

// MARK: - TableView Delegate and DataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getAlbumsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumsTableViewCell.identifier) as? AlbumsTableViewCell else { return UITableViewCell()}
        cell.configure(text: viewModel.getItem(at: indexPath)?.title ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRow = viewModel.getItem(at: indexPath) else { return }
        viewModel.didSelectAlbum(With: selectedRow.id, albumTitle: selectedRow.title, source: self)
    }
}

// MARK: - Bind ViewModel
private extension ProfileViewController {
    func bindViewModel() {
        bindUserProfile()
        bindUserAlbums()
        bindError()
    }
    
    func bindUserProfile() {
        viewModel.userProfilePubliser
            .receive(on: DispatchQueue.main)
            .sink {[weak self] userProfile in
                guard let self else { return }
                userNameLabel.text = userProfile?.name
                userAddressLabel.text = viewModel.getFullAddress()
            }
            .store(in: &subscriptions)
    }
    
    func bindUserAlbums() {
        viewModel.userAlbumsPubliser
            .receive(on: DispatchQueue.main)
            .sink {[weak self] albums in
                guard let self else { return }
                albumsTableView.reloadData()
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
