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
    
    var addToFavoiteTapped: ((ITunesMedia) -> Void)?
    
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
        
        // TODO: Replace url cheking in presenter
        guard let url = viewModel.artworkUrl,
            let imageData = viewModel.imageData else { return }
        if let imageURL = URL(string: url) {
            if !imageData.isEmpty {
                photoView.image = UIImage(data: imageData)
                return
            }
            photoView.af.setImage(withURL: imageURL,
                                  placeholderImage: placeholderImage,
                                  imageTransition: .flipFromTop(0.5),
                                  completion: { self.viewModel.imageData = $0.data })
        }
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        if favoriteButton.currentImage! == R.image.unlike()! {
            favoriteButton.setImage(R.image.like(), for: .normal)
        } else {
            favoriteButton.setImage(R.image.unlike(), for: .normal)
        }
        
        if isFavorite {
            addToFavoiteTapped?(viewModel)
        }
    }
    
    private func setupView() {
        photoView.layer.masksToBounds = true
        photoView.layer.cornerRadius = photoView.bounds.height / 10
        placeholderImage = R.image.gradient_bilinear()
        favoriteButton.setImage(R.image.unlike(), for: .normal)
    }
}
