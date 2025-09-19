//
//  PLBaseTableCell.swift
//  BPPulse
//
//  Created by admin on 2025/9/17.
//

import UIKit

class PLBaseTableCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setupUI() { }

    @objc func commonInit() { }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
