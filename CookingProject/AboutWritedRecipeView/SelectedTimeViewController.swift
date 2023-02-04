//
//  SelectedTimeViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/02.
//

import UIKit
import SnapKit

final class SelectedTimeViewController: UIViewController {
//MARK: - Properties
    private let backGroundView = UIView()
    
    final var delegate : SelectedTimeDelegate?
    
    private lazy var completeButton : UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(completeButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    private let timePicker = UIDatePicker()
    
    final var selectedTime = String()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
    }
    
    //MARK: - ViewMethod
    
    
    private func addSubViews() {
        view.backgroundColor = .clear
        
        view.addSubview(backGroundView)
        backGroundView.backgroundColor = .customWhite
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 15
        backGroundView.layer.masksToBounds = false
        backGroundView.layer.shadowOpacity = 1
        backGroundView.layer.shadowColor = UIColor.darkGray.cgColor
        backGroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backGroundView.layer.shadowRadius = 5
        backGroundView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(330)
        }
        
        backGroundView.addSubview(timePicker)
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .countDownTimer
        timePicker.locale = Locale(identifier: "ko-KR")
        timePicker.minuteInterval = 5
        timePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        timePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(216)
        }
        
        backGroundView.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ //화면 터치 시 키보드내려감
        self.dismiss(animated: true)
    }
    
//MARK: - ButtonMethod
    @objc private func completeButtonPressed(_ sender : UIButton) {
        if selectedTime == "" {
            CustomAlert.show(title: "오류", subMessage: "조리시간을 입력해주세요.")
        }else{
            self.delegate?.result(time: selectedTime)
            self.dismiss(animated: true)
        }
        
    }
    
    
//MARK: - DatePickerMethod
    
    @objc private func handleDatePicker(_ sender: UIDatePicker) {
        let dfMatter = DateFormatter()
        dfMatter.dateFormat = "HH"
        let hour = Int(dfMatter.string(from: sender.date)) ?? Int()
        
        dfMatter.dateFormat = "mm"
        let minute = Int(dfMatter.string(from: sender.date)) ?? Int()
        
        let resultMinute = (hour * 60) + minute
        
        self.selectedTime = "\(resultMinute)분"
    }
    
    
}
//MARK: - Extension
protocol SelectedTimeDelegate {
    func result(time : String)
}

