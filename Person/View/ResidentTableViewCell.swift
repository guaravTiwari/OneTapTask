//
//  ResidentTableViewCell.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//

import UIKit

final class ResidentTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var nameLabel: UILabel?
  @IBOutlet private weak var checkInButton: UIButton?
  
  var resident: Person? {
    willSet {
      nameLabel?.text = newValue?.name
      checkInButton?.isHidden = newValue?.isPresent ?? false
      nameLabel?.textColor = newValue?.isPresent ?? false ? .gray : .black
    }
  }
  
  var tappedOnCheckIn: ((UUID) -> Void)?
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @IBAction private func checkInAction() {
    guard let id = resident?.id else { return }
    tappedOnCheckIn?(id)
  }
}
