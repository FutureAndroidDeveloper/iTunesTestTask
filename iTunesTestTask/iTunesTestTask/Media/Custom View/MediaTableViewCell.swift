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
    
    private var placeholderImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with viewModel: ITunesMedia) {
        nameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        dateLabel.text = viewModel.releaseDate
        
        if let imageURL = viewModel.artworkUrl {
            photoView.af.setImage(withURL: imageURL,
                                  placeholderImage: placeholderImage,
                                  imageTransition: .flipFromTop(0.5))
        }
    }
    
    private func setupView() {
        photoView.layer.masksToBounds = true
        photoView.layer.cornerRadius = photoView.bounds.height / 10
        placeholderImage = R.image.gradient_bilinear()
    }
}
