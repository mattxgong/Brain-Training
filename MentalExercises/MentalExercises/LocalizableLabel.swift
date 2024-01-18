//
//  LocalizableLabel.swift
//  MentalExercises
//
//  Created by Grace Chen on 2023-09-01.
//

import Foundation
import UIKit

class LocalizableLabel: UILabel {

    @IBInspectable var localizedKey: String? {
        didSet {
            guard let key = localizedKey else { return }
            text = NSLocalizedString(key, comment: "")
        }
    }

}
