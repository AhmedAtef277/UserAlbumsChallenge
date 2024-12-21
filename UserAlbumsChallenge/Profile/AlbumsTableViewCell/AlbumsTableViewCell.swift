//
//  AlbumsTableViewCell.swift
//  UserAlbumsChallenge
//
//  Created by mac on 20/12/2024.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

    static let identifier = String(describing: AlbumsTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.numberOfLines = 0
    }
    
    func configure(text: String) {
        self.textLabel?.text = text
    }
}
