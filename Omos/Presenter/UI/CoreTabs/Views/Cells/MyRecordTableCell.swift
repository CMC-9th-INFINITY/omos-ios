//
//  MyRecordCell.swift
//  Omos
//
//  Created by sangheon on 2022/02/15.
//

import Foundation
import UIKit

class MyRecordTableCell:UITableViewCell {
    static let identifier = "MyRecordTableCell"
    
    private let backCoverView:UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlack
        return view
    }()
    
    let albumImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "albumCover"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let backGroundView:UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 0.87).cgColor
        
        return view
    }()
    
    private let labelCoverView:UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous
        view.layer.backgroundColor = UIColor(red: 0.388, green: 0.388, blue: 0.4, alpha: 0.5).cgColor
        return view
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "노래제목이 들어갑니다.노래제목이 들어갑니다.노래제목이 들어갑니다."
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    let recordLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "노래제목이 들어갑니다.노래제목이 들어갑니다.노래제목이 들어갑니다."
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let descLabel:UILabel = {
        let label = UILabel()
        label.text = "record main title here..노래제목이 들어갑니다.노래제목이 들어갑니다.노래제목이 들어갑니다.노래제목이 들어갑니다"
        label.numberOfLines = 2
        
        return label
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "2022 00 00 카테코리가 들어갑니다"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let dummyView:UIView = {
        let view = UIView()
        view.backgroundColor = .mainOrange
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = .mainBackGround
        configureUI()
        
        albumImageView.layer.cornerRadius = albumImageView.width / 2
        albumImageView.layer.masksToBounds = true
        
        labelCoverView.layer.cornerRadius = labelCoverView.height / 2
        labelCoverView.layer.masksToBounds = true
    }
    
    private func configureUI() {
        self.addSubview(backCoverView)
        backCoverView.addSubview(albumImageView)
        backCoverView.addSubview(backGroundView)
        labelCoverView.addSubview(titleLabel)
        backGroundView.addSubview(recordLabel)
        backGroundView.addSubview(labelCoverView)
        backGroundView.addSubview(descLabel)
        backGroundView.addSubview(nameLabel)
        backGroundView.addSubview(dummyView)
        
        backCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        albumImageView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.64)
            make.width.equalTo(albumImageView.snp.height)
        }
        
        backGroundView.snp.makeConstraints { make in
            make.left.equalTo(albumImageView.snp.centerX)
            make.right.bottom.top.equalToSuperview()
        }
        
        labelCoverView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(14)
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.157)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
        
        recordLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        recordLabel.sizeToFit()
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(recordLabel.snp.bottom).offset(10)
            make.left.right.equalTo(recordLabel)
        }
        descLabel.sizeToFit()
        
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(descLabel)
            make.bottom.equalToSuperview()
        }
        nameLabel.sizeToFit()
        
        dummyView.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.width.equalTo(2)
        }
        
        layoutIfNeeded()
        
    }
    
}