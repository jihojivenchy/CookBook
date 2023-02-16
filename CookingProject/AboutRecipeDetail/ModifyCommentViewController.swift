//
//  ModifyCommentViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/15.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class ModifyCommentViewController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    final var commentData = CommentsDataModel(comment: "", childComments: [], date: "", userUID: "", userName: "", commentDocumentID: "")
    
    final lazy var commentsTextView : UITextView = {
        let tv = UITextView()
        tv.returnKeyType = .next
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 10
        tv.font = .systemFont(ofSize: 18)
        tv.textColor = .black
        tv.tintColor = .black
        tv.backgroundColor = .white
        
        return tv
    }()
    
    final var recipeDocumentID = String() //현재 레시피 도큐먼트아이디
    final var childMode : Bool = false //지금 수정하는 데이터가 댓글인지 대댓글인지.
    final var childDocumentIndex = 0
    
    private lazy var updateButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(updateButtonPressed(_:)))
        
        return button
    }()
    
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        naviBarAppearance()
    
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        navigationItem.title = "수정"
        navigationItem.rightBarButtonItem = updateButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customWhite
        
        view.addSubview(commentsTextView)
        commentsTextView.becomeFirstResponder()
        commentsTextView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(300)
        }
    }
    
//MARK: - ButtonMethod
    @objc private func updateButtonPressed(_ seder : UIBarButtonItem) {
        guard let comment = commentsTextView.text else{return}
        
        if comment != "" {
            
            if childMode { //대댓글 수정
                let childRef = db.collection("전체보기").document(recipeDocumentID).collection("댓글").document(commentData.commentDocumentID).collection("답글").document(commentData.childComments[self.childDocumentIndex].childDocumentID)
                
                childRef.updateData([DataKeyWord.comment : comment]) { error in
                    if let e = error {
                        print("Error 대댓글 수정 실패 :\(e.localizedDescription)")
                        
                    }else{
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            }else{//댓글 수정
                db.collection("전체보기").document(recipeDocumentID).collection("댓글").document(commentData.commentDocumentID).updateData([DataKeyWord.comment : comment]) { error in
                    if let e = error {
                        print("Error 댓글 수정 실패 :\(e.localizedDescription)")
                        
                    }else{
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            
            
        }else{
            CustomAlert.show(title: "오류", subMessage: "댓글을 작성해주세요.")
        }
        
    }
    
}



