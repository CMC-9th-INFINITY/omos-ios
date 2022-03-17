//
//  AllRecordCateDetailCell.swift
//  Omos
//
//  Created by sangheon on 2022/02/28.
//

import Foundation
import UIKit
import RxSwift

class AllRecordCateLongDetailCell:UITableViewCell {
    static let identifier = "AllRecordCateDetailCell"
    var disposeBag = DisposeBag()
    let myView = CellContainerView()
    
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
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(999)
        }
    }
    
 
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //myView.myView.backImageView.image = nil
//        myView.myView.likeButton.setImage(nil, for: .normal)
//        myView.myView.scrapButton.setImage(nil, for: .normal)
//        myView.myView.likeCountLabel.textColor = nil
//        myView.myView.scrapCountLabel.textColor = nil
        disposeBag = DisposeBag()
    }
    
    func configureModel(record:CategoryRespone) {
        myView.myView.musicTitleLabel.text = record.music.musicTitle
        myView.myView.subMusicInfoLabel.text = record.music.artists.map { $0.artistName }.reduce("") { $0 + " \($1)"} + "- \(record.music.albumTitle)"
        myView.myView.circleImageView.setImage(with: record.music.albumImageURL)
        //myView.myView.backImageView.setImage(with: ) 추후 추가되면 삽입
        myView.myView.titleLabel.text = record.recordTitle
        myView.myView.createdLabel.text = record.createdDate
        myView.myView.mainLabelView.text = record.recordContents
        myView.myView.nicknameLabel.text = record.nickname
        myView.myView.likeCountLabel.text = String(record.likeCnt)
        myView.myView.scrapCountLabel.text = String(record.scrapCnt)
        
        if record.isLiked {
            myView.myView.likeButton.setImage(UIImage(named: "fillLove"), for: .normal)
            myView.myView.likeCountLabel.textColor = .mainOrange
        }
        
        if record.isScraped {
            myView.myView.scrapButton.setImage( UIImage(named: "fillStar"), for: .normal)
            myView.myView.scrapCountLabel.textColor = .mainOrange
        } 
        
    }
    
    func configureOneMusic(record:OneMusicRecordRespone) {
        myView.myView.musicTitleLabel.text = record.music.musicTitle
        myView.myView.subMusicInfoLabel.text = record.music.artists.map { $0.artistName }.reduce("") { $0 + " \($1)"} + "- \(record.music.albumTitle)"
        myView.myView.circleImageView.setImage(with: record.music.albumImageURL)
        //myView.myView.backImageView.setImage(with: ) 추후 추가되면 삽입
        myView.myView.titleLabel.text = record.recordTitle
        myView.myView.createdLabel.text = record.createdDate
        myView.myView.mainLabelView.text = record.recordContents
        myView.myView.nicknameLabel.text = record.nickname
        myView.myView.likeCountLabel.text = String(record.likeCnt)
        myView.myView.scrapCountLabel.text = String(record.scrapCnt)
        myView.myView.cateLabel.text = record.category
        
        if record.isLiked {
            myView.myView.likeButton.setImage(UIImage(named: "fillLove"), for: .normal)
            myView.myView.likeCountLabel.textColor = .mainOrange
        }
        
        if record.isScraped {
            myView.myView.scrapButton.setImage( UIImage(named: "fillStar"), for: .normal)
            myView.myView.scrapCountLabel.textColor = .mainOrange
        }
    }
    
    func configureMyDjRecord(record:MyDjResponse) {
        myView.myView.musicTitleLabel.text = record.music.musicTitle
        myView.myView.subMusicInfoLabel.text = record.music.artists.map { $0.artistName }.reduce("") { $0 + " \($1)"} + "- \(record.music.albumTitle)"
        myView.myView.circleImageView.setImage(with: record.music.albumImageURL)
        //myView.myView.backImageView.setImage(with: ) 추후 추가되면 삽입
        myView.myView.titleLabel.text = record.recordTitle
        myView.myView.createdLabel.text = record.createdDate
        myView.myView.mainLabelView.text = record.recordContents
        myView.myView.nicknameLabel.text = record.nickname
        myView.myView.likeCountLabel.text = String(record.likeCnt)
        myView.myView.scrapCountLabel.text = String(record.scrapCnt)
        myView.myView.cateLabel.text = record.category
        
        if record.isLiked {
            myView.myView.likeButton.setImage(UIImage(named: "fillLove"), for: .normal)
            myView.myView.likeCountLabel.textColor = .mainOrange
        }
        
        if record.isScraped {
            myView.myView.scrapButton.setImage( UIImage(named: "fillStar"), for: .normal)
            myView.myView.scrapCountLabel.textColor = .mainOrange
        }
    }
    
}

class CellContainerView:BaseView {
    
    let myView = MyRecordDetailView()
    
    let dummyLabel:UILabel = {
        let label = UILabel()
        label.text = " 더보기"
        label.font = .systemFont(ofSize: 14,weight:.medium)
        label.backgroundColor = .mainBlack
        return label
    }()
    
    let readMoreButton:UIButton = {
        let button = UIButton()
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(UIColor.mainGrey6, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        super.configureUI()
        setupView()
    }
    
    func setupView() {
        self.addSubview(myView)
        myView.textCoverView.addSubview(dummyLabel)
        myView.textCoverView.addSubview(readMoreButton)
        myView.mainLabelView.textAlignment = .left
        myView.mainLabelView.font = .systemFont(ofSize: 16)
        myView.mainLabelView.numberOfLines = 3
        myView.mainLabelView.lineBreakMode = .byTruncatingTail
        myView.mainLabelView.text = "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        
        //remake
        
        myView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        myView.topLabelView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(Constant.mainHeight * 0.069)
        }
        
        myView.titleImageView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(myView.topLabelView.snp.bottom)
            make.height.equalTo(Constant.mainHeight * 0.201)
        }
        
        myView.mainLabelView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
//        dummyLabel.snp.makeConstraints { make in
//            make.bottom.trailing.equalToSuperview()
//            dummyLabel.sizeToFit()
//        }
        
        readMoreButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(26)
            make.width.equalTo(46)
        }
        
        myView.lastView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(Constant.mainHeight * 0.077)
        }
        
    }
}

class LoadingCell:UITableViewCell {
    static let identifier = "LoadingCell"
    
    let selfView = LoadingView()
    
    func start() {
        selfView.isHidden = false
    }
    
    func dismiss(){
        selfView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(selfView)
        selfView.backgroundColor = .mainBackGround
        selfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
