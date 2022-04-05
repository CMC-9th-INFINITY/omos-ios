//
//  DecoView.swift
//  Omos
//
//  Created by sangheon on 2022/02/10.
//

import UIKit

class DecoView:BaseView {
    private let view1:UIView = {
        let view = UIView()
        view.backgroundColor = .mainGrey7
        return view
    }()
    
    private let label:UILabel = {
        let label = UILabel()
        label.text = "or"
        label.textColor = .mainGrey7
        return label
    }()
    
    private let view2:UIView = {
        let view = UIView()
        view.backgroundColor = .mainGrey7
        return view
    }()
    
    override func configureUI() {
        self.addSubview(label)
        self.addSubview(view1)
        self.addSubview(view2)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view1.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.right.equalTo(label.snp.left).offset(-14)
        }
        
        view2.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalTo(label.snp.right).offset(14)
        }
        
    }
    
}

class EmailLabelView:BaseView {
    let emailLabel:UILabel = {
       let label = UILabel()
        label.text = "이메일"
        label.font = .systemFont(ofSize: 14)
        label.tintColor = .white
        return label
    }()
    
    
    let warningLabel:UILabel = {
       let label = UILabel()
        label.text = "이메일을 입력해주세요"
        label.font = .systemFont(ofSize:12)
        label.textColor = .mainOrange
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    override func configureUI() {
        self.addSubview(emailLabel)
        self.addSubview(warningLabel)
        
        emailLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            warningLabel.sizeToFit()
        }
    }
}


class PasswordLabelView:BaseView {
    let passwordLabel:UILabel = {
       let label = UILabel()
        label.text = "비밀번호"
        label.font = .systemFont(ofSize: 14)
        label.tintColor = .white
        return label
    }()
    
    
    let warningLabel:UILabel = {
       let label = UILabel()
        label.text = "비밀번호를 입력해주세요"
        label.font = .systemFont(ofSize:12)
        label.textColor = .mainOrange
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    override func configureUI() {
        self.addSubview(passwordLabel)
        self.addSubview(warningLabel)
        
        passwordLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            warningLabel.sizeToFit()
        }
    }
}


class labels:BaseView {
    let findButton:UIButton = {
       let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        return button
    }()
    
    
    let signUpButton:UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.mainGrey4, for: .normal)
        return button
    }()
    
    override func configureUI() {
        self.addSubview(findButton)
        self.addSubview(signUpButton)
        
        findButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(64)
        }


        
        signUpButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(64)
        }
        
    }
    
}

