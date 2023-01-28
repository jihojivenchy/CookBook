//
//  LevelViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/26.
//

import UIKit
import SnapKit

final class LevelViewController: UIViewController {
//MARK: - Properties
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let stackView = UIStackView()
    private let progressBar = UIProgressView()
    private let levelLabel = UILabel()
    private let levelCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .clear
        cView.tag = 1
        cView.isScrollEnabled = false
        cView.showsVerticalScrollIndicator = false
        
        return cView
    }()
    private let levelArray : [String] = ["초급", "중급", "고급"]
    
    
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    
    final var sendedArray : [String] = ["", "", "", ""]
    final var userName = String()
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        
        addSubViews()
        setStackView()
        
        levelCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        levelCollectionView.dataSource = self
        levelCollectionView.delegate = self
    }
    
    //MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customGray
        
        view.addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(20)
        }
        
        view.addSubview(progressBar)
        progressBar.backgroundColor = .lightGray
        progressBar.progress = 0.25
        progressBar.progressTintColor = .customSignature
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp_bottomMargin).offset(5)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(7)
        }
        
        view.addSubview(levelLabel)
        levelLabel.text = "레시피의 난이도를 선택해주세요"
        levelLabel.textColor = .black
        levelLabel.textAlignment = .center
        levelLabel.font = UIFont(name: KeyWord.CustomFont, size: 25)
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        view.addSubview(levelCollectionView)
        levelCollectionView.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        view.addSubview(nextButton)
        nextButton.alpha = 0.6
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(levelCollectionView.snp_bottomMargin).offset(70)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
    }
    
    private func setStackView() {
        
        for i in sendedArray {
            
            let label = UILabel()
            label.text = i
            label.textAlignment = .center
            label.textColor = .black
            label.backgroundColor = .clear
            label.font = UIFont(name: KeyWord.CustomFont, size: 11)
            label.clipsToBounds = true
            label.layer.cornerRadius = 7
            
            self.stackView.addArrangedSubview(label)
        }
    }
    
//MARK: - ButtonMethod
    
    @objc private func nextButtonPressed(_ sender : UIButton){
        let state = nextButton.alpha
        
        if state == 1.0 {
            let vc = WriteTitleViewController()
            vc.sendedArray = self.sendedArray
            vc.userName = self.userName
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            CustomAlert.show(title: "난이도 선택", subMessage: "선택 후 진행이 가능합니다.")
        }
    }
    
    
    //MARK: - DataMethod
    
    
    
}
//MARK: - Extension
extension LevelViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.levelArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryLabel.text = self.levelArray[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3
        let height : CGFloat = 100
        
        return CGSize(width: width, height: height)
    }
}

extension LevelViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.nextButton.alpha = 1
        self.sendedArray[1] = levelArray[indexPath.row]
    }
}

