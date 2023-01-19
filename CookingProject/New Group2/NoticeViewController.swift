//
//  NoticeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/15.
//

import UIKit
import SnapKit

class NoticeViewController: UIViewController {
 
    private lazy var noticeTextView : UITextView = {
        let tv = UITextView()
        tv.returnKeyType = .next
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.customPink?.cgColor
        tv.font = .systemFont(ofSize: 20, weight: .black)
        tv.textColor = .black
        tv.isEditable = false
        tv.text = "환영합니다. 우선 요리도감 서비스를 이용해주셔서 진심으로 감사합니다. \n\n요리를 좋아하는 사람들끼리 모여서 서로의 비법을 공유하고, 전수해주는 등의 활동을 목적으로 하는 커뮤니티 Application입니다. \n\n남을 비하하는 글, 정치적인 글 등 목적과 관계없는 글들은 삼가 부탁드립니다. \n\n규칙 위반, 고객신고 등에 의해서 회원 글 삭제 또는 회원탈퇴 조치될 수 있습니다."
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        viewChange()

    }
    
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "공지사항"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func viewChange() {
        view.backgroundColor = .white
        
        view.addSubview(noticeTextView)
        noticeTextView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.right.equalTo(view).inset(10)
            make.height.equalTo(350)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
