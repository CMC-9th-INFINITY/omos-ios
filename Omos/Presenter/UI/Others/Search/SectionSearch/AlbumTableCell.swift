//
//  AlbumTableCell.swift
//  Omos
//
//  Created by sangheon on 2022/02/27.
//

import UIKit


class AlbumTableCell:UITableViewCell {
    static let identifier = "AlbumTableCell"

    let songImageView:UIImageView = {
        let view = UIImageView(image:UIImage(named: "albumSquare"))
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "상수역"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let subTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "검정 치마"
        label.textColor = .mainGrey4
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    let createdLabel:UILabel = {
        let label = UILabel()
        label.text = "2000 00 00"
        label.textColor = .mainGrey4
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        confgirueUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        songImageView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
    }
    
    func confgirueUI() {
        self.addSubview(songImageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(createdLabel)
        
        songImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
            make.width.equalTo(songImageView.snp.height)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(songImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(songImageView.snp.top)
            
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            
        }
        
        createdLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(6)
            createdLabel.sizeToFit()
        }
        
    }
    
    func configureModel(album:AlbumRespone,keyword:String) {
        songImageView.setImage(with: album.albumImageURL)
        titleLabel.text = album.albumTitle
        subTitleLabel.text = album.artists.map { $0.artistName }.reduce("") { $0 + " \($1)" }
        if subTitleLabel.text?.first == " " {
            subTitleLabel.text?.removeFirst()
        }
        createdLabel.text = album.releaseDate
        titleLabel.asColor(targetString: keyword, color: .mainOrange)
        subTitleLabel.asColor(targetString: keyword, color: .mainOrange)
    }
    
}
