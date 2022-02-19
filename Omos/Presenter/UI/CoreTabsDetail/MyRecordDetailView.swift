//
//  MyRecordDetailView.swift
//  Omos
//
//  Created by sangheon on 2022/02/19.
//

import Foundation
import UIKit

class MyRecordDetailView:BaseView {
    /// 1
    let topLabelView:UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackGround
        return view
    }()
    
    let circleImageView:UIImageView = {
        let view = UIImageView(image:UIImage(systemName: "person"))
        view.backgroundColor = .brown
        return view
    }()
    
    let musicTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "노래 제목이 들어있습니다"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let subMusicInfoLabel:UILabel = {
        let label = UILabel()
        label.text = "가수이름이 들어갑니다. 앨범제목이 들어갑니다."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainGrey4
        return label
    }()
    
    /// 2
    let titleImageView:UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .mainBackGround
        return view
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "백예린 노래"
        label.font = .systemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    
    let createdLabel:UILabel = {
        let label = UILabel()
        label.text = "2020 00 00 한줄감상"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainGrey1
        return label
    }()
    
    /// 3
    let textCoverView:UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlack
        return view
    }()
    
    let mainTextView:UITextView = {
        let view = UITextView()
        view.text = "백에린 노래 좋아"
        view.font = UIFont(name: "Cafe24Oneprettynight", size: 22)
        return view
    }()
    
    ///4
    let lastView:UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlack
        return view
    }()
    
    let nicknameLabel:UILabel = {
        let label = UILabel()
        label.text = "DJ닉네임이들어갑니다다다"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .mainGrey3
        return label
    }()
    
    
    
    let loveImageView:UIImageView = {
        let view = UIImageView(image:UIImage(named: "emptyLove"))
        return view
    }()
    
    let loveCountLabel:UILabel = {
       let label = UILabel()
        label.text = "122"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    let starImageView:UIImageView = {
        let view = UIImageView(image:UIImage(named: "emptyStar"))
        return view
    }()
    
    let starCountLabel:UILabel = {
       let label = UILabel()
        label.text = "144"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
        circleImageView.layer.cornerCurve = .circular
        circleImageView.layer.cornerRadius = circleImageView.height / 2
        circleImageView.layer.masksToBounds = true
    }
    
    
    override func configureUI() {
        addSubviews()
        ///1
        topLabelView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.11)
        }
        
        circleImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.64)
            make.width.equalTo(circleImageView.snp.height)
        }
        
        musicTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(circleImageView.snp.right).offset(14)
            make.top.equalTo(circleImageView.snp.top)
            make.bottom.equalTo(circleImageView.snp.centerY)
            musicTitleLabel.sizeToFit()
        }
        
        subMusicInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(musicTitleLabel)
            make.bottom.equalTo(circleImageView.snp.bottom)
            subMusicInfoLabel.sizeToFit()
        }
        
        ///2
        titleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLabelView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.32)
        }
        
        createdLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            createdLabel.sizeToFit()
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(createdLabel.snp.top)
            titleLabel.sizeToFit()
        }
        
        ///4
        lastView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.124)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            nicknameLabel.sizeToFit()
        }
        
        starImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalTo(starImageView.snp.height)
            make.right.equalToSuperview().offset(-16)
        }

        starCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(starImageView.snp.centerX)
            make.top.equalTo(starImageView.snp.bottom)
            starCountLabel.sizeToFit()
        }


        loveImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalTo(loveImageView.snp.height)
            make.right.equalTo(starImageView.snp.left).offset(-6)
        }

        loveCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(loveImageView.snp.centerX)
            make.top.equalTo(loveImageView.snp.bottom)
            starCountLabel.sizeToFit()
        }
        



        ///3
        textCoverView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleImageView.snp.bottom)
            make.bottom.equalTo(lastView.snp.top)
        }
        
        mainTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    
    func addSubviews() {
        self.addSubview(topLabelView)
        self.addSubview(titleImageView)
        self.addSubview(textCoverView)
        self.addSubview(lastView)
        
        topLabelView.addSubview(circleImageView)
        topLabelView.addSubview(musicTitleLabel)
        topLabelView.addSubview(subMusicInfoLabel)
        
        titleImageView.addSubview(titleLabel)
        titleImageView.addSubview(createdLabel)
        
        textCoverView.addSubview(mainTextView)
        
        lastView.addSubview(nicknameLabel)
        lastView.addSubview(loveImageView)
        lastView.addSubview(loveCountLabel)
        lastView.addSubview(starImageView)
        lastView.addSubview(starCountLabel)
    }
    
    
    
}
