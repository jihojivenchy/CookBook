//
//  FeedBackViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/23.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class FeedBackViewController: UIViewController {
//MARK: - Properties
    private let db = Firestore.firestore()
    final var nickName = String() //피드백보낼 때 유저 정보.
    
    private lazy var sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("보내기 ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .white
        button.semanticContentAttribute = .forceRightToLeft
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    private lazy var goToCenterButton : UIButton = {
        let button = UIButton()
        button.setTitle("고객센터 바로가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(goCenterButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    private let backGroudView = UIView()
    private lazy var feedBackTextView : UITextView = {
        let tv = UITextView()
        tv.returnKeyType = .next
        tv.font = .systemFont(ofSize: 20)
        tv.text = textViewHolder
        tv.textColor = .lightGray
        tv.tintColor = .black
        tv.backgroundColor = .clear
        tv.delegate = self
        
        return tv
    }()
    
    private let textViewHolder = "더 나은 서비스를 위한 글을 자유롭게 작성해주세요."

//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        naviBarAppearance()
        
    }
    
//MARK: - ViewMethod
    private func addSubViews() {
        view.backgroundColor = .customWhite
        
        view.addSubview(backGroudView)
        backGroudView.backgroundColor = .white
        backGroudView.clipsToBounds = true
        backGroudView.layer.cornerRadius = 7
        backGroudView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(300)
        }
        
        backGroudView.addSubview(feedBackTextView)
        feedBackTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(backGroudView.snp_bottomMargin).offset(50)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
        
        view.addSubview(goToCenterButton)
        goToCenterButton.snp.makeConstraints { make in
            make.top.equalTo(sendButton.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
        
    }
    
    private func naviBarAppearance() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "피드백"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.view.endEditing(true)
        
    }
    
//MARK: - ButtonMethod
    
    @objc private func sendButtonPressed(_ sender : UIButton){
        self.view.endEditing(true)
        
        guard let contents = feedBackTextView.text else{return}
        
        if Auth.auth().currentUser != nil {
            
            if contents == textViewHolder {
                CustomAlert.show(title: "오류", subMessage: "내용을 작성해주세요.")
                
            }else{
                db.collection("FeedBack").addDocument(data: ["name" : self.nickName,
                                                             "contents" : contents])
                
                DispatchQueue.main.async {
                    self.feedBackTextView.text = self.textViewHolder
                    ToastMessage.shared.showToast(message: "전송이 완료되었습니다.", durationTime: 3, delayTime: 0.5, width: 200, view: self.view)
                }
                
            }
          
        }else{
            CustomAlert.show(title: "로그인", subMessage: "로그인이 필요한 서비스입니다.")
        }
        
    }
    
    @objc private func goCenterButtonPressed(_ sender : UIButton){
        let centerURL = "https://open.kakao.com/o/skUiDAwe"
        let kakaoTalkURL = NSURL(string: centerURL)
        
        if UIApplication.shared.canOpenURL(kakaoTalkURL! as URL){
            UIApplication.shared.open(kakaoTalkURL! as URL)
        }else{
            CustomAlert.show(title: "접속 오류", subMessage: "현재 접속이 불가능합니다.")
        }
    }
    
//MARK: - DataMethod
    
}

//MARK: - Extension
extension FeedBackViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewHolder
            textView.textColor = .lightGray
        }
    }
}
