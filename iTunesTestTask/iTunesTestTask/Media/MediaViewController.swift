//
//  MediaViewController.swift
//  iTunesTest
//
//  Created by Кирилл Клименков on 7/13/20.
//  Copyright (c) 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit

protocol MediaDisplayLogic: class {
    func displayData(viewModel: Media.Model.ViewModel.ViewModelData)
}

class MediaViewController: UIViewController, MediaDisplayLogic {
    @IBOutlet weak var mediaControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var interactor: MediaBusinessLogic?
    var router: (NSObjectProtocol & MediaRoutingLogic)?
    
    private var mediaType: MediaType!
    private let defaultTerm = "Moon"
    private var media: [ITunesMedia] = []
    
    private var closeKeyboardTapGesture: UITapGestureRecognizer!
    
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
        let interactor            = MediaInteractor()
        let presenter             = MediaPresenter()
        let router                = MediaRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        interactor?.makeRequest(request: .restoreLastTerm)
        requestMedia()
        // receive notification to remove a like from post
        NotificationCenter.default.addObserver(self, selector: #selector(updateMedia),
                                               name: Notification.Name("deleteLike"),
                                               object: nil)
    }
    
    @objc func updateMedia() {
        interactor?.makeRequest(request: .updateMedia)
    }
    
    func displayData(viewModel: Media.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .mediaViewModel(let viewModel):
            self.media = viewModel
            self.tableView.reloadData()
            
        case .lastTerm(let text):
            searchBar.text = text
        }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.mediaTableViewCell)
        tableView.rowHeight = 140
        
        closeKeyboardTapGesture = UITapGestureRecognizer()
        closeKeyboardTapGesture.addTarget(self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(closeKeyboardTapGesture)
        
        setupMediaControl()
    }
    
    @objc private func closeKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func favoriteButtonTapped(media: ITunesMedia) {
        media.isFavorite ? addToFavorite(media: media) : removeFavorite(media: media)
    }
    
    private func addToFavorite(media: ITunesMedia) {
        changeFavoriteState(for: media)
        interactor?.makeRequest(request: .save(media: media))
    }
    
    private func removeFavorite(media: ITunesMedia) {
        changeFavoriteState(for: media)
        interactor?.makeRequest(request: .remove(media: media))
    }
    
    private func changeFavoriteState(for media: ITunesMedia) {
        let firstIndex = self.media.firstIndex { mediaObj -> Bool in
            return mediaObj.artistName == media.artistName &&
                mediaObj.trackName == media.trackName &&
                mediaObj.releaseDate == media.releaseDate
        }
        if let index = firstIndex { self.media[index].isFavorite = media.isFavorite }
    }
    
    private func requestMedia() {
        guard let text = searchBar.text else { return }
        let term = text.isEmpty ? defaultTerm : text
        interactor?.makeRequest(request: .loadMedia(term: term, media: mediaType))
    }
    
    private func setupMediaControl() {
        mediaControl.removeAllSegments()
        // set segments
        MediaType.allCases
            .map { $0.description.capitalized }
            .enumerated()
            .forEach {
                mediaControl.insertSegment(withTitle: $1, at: $0, animated: true)
            }
        
        // select first segment
        let firstIndex: Int? = mediaControl.numberOfSegments > 0 ? 0 : nil
        guard let index = firstIndex else { return }
        mediaControl.selectedSegmentIndex = index
        
        // set begin media type
        if let title = mediaControl.titleForSegment(at: index)?.lowercased() {
            mediaType = MediaType(rawValue: title)
        }
    }
    
    @IBAction func mediaTypeChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if let title = mediaControl.titleForSegment(at: selectedIndex)?.lowercased() {
            mediaType = MediaType(rawValue: title)
        }
        requestMedia()
    }
}

// MARK: - UITableViewDataSource
extension MediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return media.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let
            cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.mediaCell,
                                                 for: indexPath) else { fatalError() }
        let mediaViewModel = media[indexPath.row]
        cell.configure(with: mediaViewModel)
        cell.favoriteButtonTapped = favoriteButtonTapped(media:)
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension MediaViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestMedia()
        closeKeyboard()
    }
}
