//
//  MediaTableViewCell.swift
//  iTunesTestTask
//
//  Created by Кирилл Клименков on 7/14/20.
//  Copyright © 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit
import AlamofireImage


class MediaTableViewCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var placeholderImage: UIImage!
    private var viewModel: ITunesMedia!
    
    private var isFavorite: Bool {
        guard let image = favoriteButton.imageView?.image else { return false }
        var result: Bool
        
        switch image {
        case R.image.like(): result = true
        case R.image.unlike(): result = false
        default: result = false
        }
        return result
    }
    
    var favoriteButtonTapped: ((ITunesMedia) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: ITunesMedia) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        dateLabel.text = viewModel.releaseDate
        selectionStyle = .none
        
        let likeImage =  viewModel.isFavorite ? R.image.like() : R.image.unlike()
        favoriteButton.setImage(likeImage, for: .normal)
        
        // TODO: Replace in presenter
        guard let url = viewModel.artworkUrl else { return }
        
        if let imageData = viewModel.imageData {
            photoView.image = UIImage(data: imageData)
            return
        }
        if let imageURL = URL(string: url) {
            photoView.af.setImage(withURL: imageURL,
                                  placeholderImage: placeholderImage,
                                  imageTransition: .flipFromTop(0.5),
                                  completion: { value in
                                    switch value.result {
                                    case .success(let image):
                                        self.viewModel.imageData = image.pngData()
                                    default: break
                                    }
            })
        }
    }
    
    func disableFavoriteButton() {
        favoriteButton.isEnabled = false
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        // check that the image is loaded and data saved
        guard let _ = viewModel.imageData else { return }
        
        // change button image
        if favoriteButton.currentImage! == R.image.unlike()! {
            favoriteButton.setImage(R.image.like(), for: .normal)
            viewModel.isFavorite = true
        } else {
            favoriteButton.setImage(R.image.unlike(), for: .normal)
            viewModel.isFavorite = false
        }
        
        favoriteButtonTapped?(viewModel)
    }
    
    private func setupView() {
        placeholderImage = R.image.gradient_bilinear()
        photoView.layer.masksToBounds = true
        photoView.layer.cornerRadius = photoView.bounds.height / 10
        photoView.image = placeholderImage
        favoriteButton.setImage(R.image.unlike(), for: .normal)
    }
}
