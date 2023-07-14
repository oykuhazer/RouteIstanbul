//
//  FloatingActionButton.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 13.05.2023.
//

import UIKit

class FloatingActionButton: UIButton {
    // More button images
    let moreOffImage = UIImage(named: "more_off")
    let moreOnImage = UIImage(named: "more_on")

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Set default image
        setImage(moreOffImage, for: .normal)

        // Add target for button click event
        addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        // Set default image
        setImage(moreOffImage, for: .normal)

        // Add target for button click event
        addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }

    @objc func moreButtonTapped() {
        // Toggle button image
        if imageView?.image == moreOffImage {
            setImage(moreOnImage, for: .normal)
        } else {
            setImage(moreOffImage, for: .normal)
        }

        // Perform button click action here
        // ...
    }




}
