//
//  BestSearchTableCell.swift
//  Omos
//
//  Created by sangheon on 2022/02/24.
//

import Foundation
import UIKit

class BestSearchTableCell: UITableViewCell {
    static let identifier = "BestSearchTableCell"

    let rankLabel: UILabel = {
        let label = UILabel()
        label.text = "5"
        label.textColor = .mainOrange
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    let bestLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainGrey1
        label.text = "브리"
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }

    private func configureUI() {
        self.addSubview(rankLabel)
        self.addSubview(bestLabel)

        rankLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            rankLabel.sizeToFit()
        }

        bestLabel.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(22)
            make.centerY.equalToSuperview()
            bestLabel.sizeToFit()
        }
    }
}

class BestHeaderView: UITableViewHeaderFooterView {
    static let identtifier = "BestHeaderView"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인기검색어"
        label.textColor = .mainGrey1
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "전일기준"
        label.textColor = .mainGrey6
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }

    private func configureUI() {
        self.addSubview(titleLabel)
        self.addSubview(subLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            titleLabel.sizeToFit()
        }

        subLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            subLabel.sizeToFit()
        }
    }
}
