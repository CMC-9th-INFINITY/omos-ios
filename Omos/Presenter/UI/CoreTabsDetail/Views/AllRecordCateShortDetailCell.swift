//
//  AllRecordCateShortDetailCell.swift
//  Omos
//
//  Created by sangheon on 2022/03/03.
//

import Foundation
import RxSwift
import UIKit

class AllRecordCateShortDetailCell: UITableViewCell {
    static let identifier = "AllRecordCateShortDetailCell"
    var disposeBag = DisposeBag()
    let myView = MyRecordDetailView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    func configureUI() {
        self.addSubview(myView)
        
        myView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        myView.lockButton.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configureModel(record: RecordResponse) {
        myView.musicTitleLabel.text = record.music.musicTitle
        myView.subMusicInfoLabel.text = record.music.artists.map { $0.artistName }.reduce("") { $0 + " \($1)" } + "- \(record.music.albumTitle)"
        myView.circleImageView.setImage(with: record.music.albumImageURL)
        myView.backImageView.setImage(with: record.recordImageURL ?? "")
        myView.titleLabel.text = record.recordTitle
        myView.mainLabelView.text = record.recordContents
        myView.createdLabel.text = record.createdDate.toDate()
        myView.nicknameLabel.text = record.nickname
        myView.likeCountLabel.text = String(record.likeCnt)
        myView.scrapCountLabel.text = String(record.scrapCnt)
        myView.cateLabel.text = " | \(record.category.getReverseCate())"
        
        if record.isLiked {
            myView.likeButton.setImage(UIImage(named: "fillLove"), for: .normal)
            myView.likeCountLabel.textColor = .mainOrange
        } else {
            myView.likeButton.setImage(UIImage(named: "emptyLove"), for: .normal)
            myView.likeCountLabel.textColor = .white
        }
        
        if record.isScraped {
            myView.scrapButton.setImage( UIImage(named: "fillStar"), for: .normal)
            myView.scrapCountLabel.textColor = .mainOrange
        } else {
            myView.scrapButton.setImage( UIImage(named: "emptyStar"), for: .normal)
            myView.scrapCountLabel.textColor = .white
        }
    }
    
    func configureOneMusic(record: RecordResponse) {
        myView.musicTitleLabel.text = record.music.musicTitle
        myView.subMusicInfoLabel.text = record.music.artists.map { $0.artistName }.reduce("") { $0 + " \($1)" } + "- \(record.music.albumTitle)"
        if myView.subMusicInfoLabel.text?.first == " " {
            myView.subMusicInfoLabel.text?.removeFirst()
        }
        myView.circleImageView.setImage(with: record.music.albumImageURL)
        myView.backImageView.setImage(with: record.recordImageURL ?? "" )
        myView.titleLabel.text = record.recordTitle
        myView.mainLabelView.text = record.recordContents
        myView.createdLabel.text = record.createdDate.toDate()
        myView.nicknameLabel.text = record.nickname
        myView.likeCountLabel.text = String(record.likeCnt)
        myView.scrapCountLabel.text = String(record.scrapCnt)
        myView.cateLabel.text = " | \(record.category.getReverseCate())"
        
        if record.isLiked {
            myView.likeButton.setImage(UIImage(named: "fillLove"), for: .normal)
            myView.likeCountLabel.textColor = .mainOrange
        } else {
            myView.likeButton.setImage(UIImage(named: "emptyLove"), for: .normal)
            myView.likeCountLabel.textColor = .white
        }
        
        if record.isScraped {
            myView.scrapButton.setImage( UIImage(named: "fillStar"), for: .normal)
            myView.scrapCountLabel.textColor = .mainOrange
        } else {
            myView.scrapButton.setImage( UIImage(named: "emptyStar"), for: .normal)
            myView.scrapCountLabel.textColor = .white
        }
    }
    
    func configureMyDjRecord(record: MyDjResponse) {
        myView.musicTitleLabel.text = record.music.musicTitle
        myView.subMusicInfoLabel.text = record.music.artists.map { $0.artistName }.reduce("") { $0 + " \($1)" } + "- \(record.music.albumTitle)"
        if myView.subMusicInfoLabel.text?.first == " " {
            myView.subMusicInfoLabel.text?.removeFirst()
        }
        myView.circleImageView.setImage(with: record.music.albumImageURL)
        myView.backImageView.setImage(with: record.recordImageURL ?? "")
        myView.titleLabel.text = record.recordTitle
        myView.mainLabelView.text = record.recordContents
        myView.createdLabel.text = record.createdDate.toDate()
        myView.nicknameLabel.text = record.nickname
        myView.likeCountLabel.text = String(record.likeCnt)
        myView.scrapCountLabel.text = String(record.scrapCnt)
        myView.cateLabel.text = " | \(record.category.getReverseCate())"
        
        if record.isLiked {
            myView.likeButton.setImage(UIImage(named: "fillLove"), for: .normal)
            myView.likeCountLabel.textColor = .mainOrange
        } else {
            myView.likeButton.setImage(UIImage(named: "emptyLove"), for: .normal)
            myView.likeCountLabel.textColor = .white
        }
        
        if record.isScraped {
            myView.scrapButton.setImage( UIImage(named: "fillStar"), for: .normal)
            myView.scrapCountLabel.textColor = .mainOrange
        } else {
            myView.scrapButton.setImage( UIImage(named: "emptyStar"), for: .normal)
            myView.scrapCountLabel.textColor = .white
        }
    }
}
