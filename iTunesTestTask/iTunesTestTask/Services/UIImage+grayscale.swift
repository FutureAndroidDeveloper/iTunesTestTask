//
//  UIImage+grayscale.swift
//  iTunesTestTask
//
//  Created by Кирилл Клименков on 7/14/20.
//  Copyright © 2020 Kirill Klimenkov. All rights reserved.
//

import UIKit

extension UIImage {
    func grayscale() -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectNoir") {
            filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
}
