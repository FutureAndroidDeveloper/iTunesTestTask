//
//  FavoriteViewController.swift
//  iTunesTestTask
//
//  Created by Кирилл Клименков on 7/14/20.
//  Copyright (c) 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit
import AVFoundation

protocol FavoriteDisplayLogic: class {
    func displayData(viewModel: Favorite.Model.ViewModel.ViewModelData)
}

class FavoriteViewController: UIViewController, FavoriteDisplayLogic {
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var interactor: FavoriteBusinessLogic?
    var router: (NSObjectProtocol & FavoriteRoutingLogic)?
    
    private var media: [ITunesMedia] = []
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = FavoriteInteractor()
        let presenter             = FavoritePresenter()
        let router                = FavoriteRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.dataSource = self
        favoriteTableView.register(R.nib.mediaTableViewCell)
        favoriteTableView.rowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.makeRequest(request: .loadFavorite)
    }
    
    func displayData(viewModel: Favorite.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .mediaViewModel(let viewModel):
            media = viewModel
            favoriteTableView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    private func acceptDeletion(completion: @escaping (() -> Void)) {
        let alert = UIAlertController(title: R.string.localizable.alertTitle(),
                                      message: R.string.localizable.alertMessage(),
                                      preferredStyle: .alert)
        alert.addAction(.init(title: R.string.localizable.yes(), style: .default, handler: { _ in
            AudioServicesPlayAlertSound(1000)
            completion()
        }))
        alert.addAction(.init(title: R.string.localizable.no(), style: .cancel, handler: { _ in
            AudioServicesPlayAlertSound(1053)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        media.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let
            cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.mediaCell,
                                                 for: indexPath) else { fatalError() }
        let mediaViewModel = media[indexPath.row]
        cell.disableFavoriteButton()
        cell.configure(with: mediaViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            acceptDeletion { [weak self] in
                guard let self = self else { return }
                let removedMedia = self.media.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.interactor?.makeRequest(request: .remove(media: removedMedia))
            }
        }
    }
}
