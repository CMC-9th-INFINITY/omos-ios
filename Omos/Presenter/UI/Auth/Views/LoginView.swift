//
//  LoginView.swift
//  Omos
//
//  Created by sangheon on 2022/02/10.
//

import UIKit

class LoginTopView: BaseView {
    let coverView = CoverView()
    
    let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "이메일(아이디)를 입력해주세요"
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.cornerRadius = Constant.loginCorner
        field.layer.masksToBounds = true
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.textColor = .white
        field.backgroundColor = .black
        field.layer.borderColor = .some(UIColor.mainOrange.cgColor)
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "비밀번호를 입력해주세요"
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textContentType = .password
        field.isSecureTextEntry = true
        field.layer.cornerRadius = Constant.loginCorner
        field.layer.masksToBounds = true
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.textColor = .white
        field.backgroundColor = .black
        field.rightViewMode = .always
        return field
    }()
    
    let passwordDecoView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "visible2" ), for: .normal)
        return button
    }()
    
    let emailLabel: EmailLabelView = {
        let labelView = EmailLabelView()
        return labelView
    }()
    
    let passwordLabel: PasswordLabelView = {
        let labelView = PasswordLabelView()
        return labelView
    }()
    
    let labelsView: Labels = {
        let view = Labels()
        return view
    }()
    
    lazy var views = [emailLabel, emailField, passwordLabel, passwordField, labelsView]
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        return stack
    }()
    
    override func configureUI() {
        self.backgroundColor = .mainBackGround
        passwordField.addSubview(passwordDecoView)
        self.addSubview(coverView)
        self.addSubview(stack)
        coverView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.42)
        }
        
        stack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(coverView.snp.bottom)
        }
        
        for view in views {
            view.snp.makeConstraints { make in
                make.height.equalTo(self.snp.height).multipliedBy(0.089)
            }
        }
        
        passwordDecoView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(24)
        }
    }
}
