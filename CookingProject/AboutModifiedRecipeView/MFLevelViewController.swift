//
//  MFLevelViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/17.
//

import UIKit
import SnapKit

final class MFLevelViewController: UIViewController {
//MARK: - Properties
    final var modifyRecipeData : ModifyRecipeDataModel?
    
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
    
    private let timeView = UIView()
    
    private lazy var timeButton : UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default)
        let image = UIImage(systemName: "alarm.fill", withConfiguration: config)
        
        let button = UIButton()
        button.setTitle(modifyRecipeData?.foodTime, for: .normal)
        button.setTitleColor(.customNavy, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = .customNavy
        button.titleLabel?.font = UIFont(name: FontKeyWord.CustomFont, size: 16)
        button.addTarget(self, action: #selector(timeButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
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
        view.backgroundColor = .customWhite
        
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
        levelLabel.text = "레시피의 난이도와 조리시간을 선택해주세요."
        levelLabel.textColor = .black
        levelLabel.textAlignment = .center
        levelLabel.numberOfLines = 2
        levelLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 25)
        levelLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(levelCollectionView)
        levelCollectionView.snp.makeConstraints { make in
            make.top.equalTo(levelLabel.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        view.addSubview(timeButton)
        timeButton.snp.makeConstraints { make in
            make.top.equalTo(levelCollectionView.snp_bottomMargin).offset(50)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(timeButton.snp_bottomMargin).offset(80)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(55)
        }
    }
    
    private func setStackView() {
        guard let modifyRecipeData = self.modifyRecipeData else{return}
        
        let stackViewArray = [modifyRecipeData.foodCategory, "", "", ""]
        
        for i in stackViewArray{
            
            let label = UILabel()
            label.text = i
            label.textAlignment = .center
            label.textColor = .black
            label.backgroundColor = .clear
            label.font = UIFont(name: FontKeyWord.CustomFont, size: 11)
            label.clipsToBounds = true
            label.layer.cornerRadius = 7
            
            self.stackView.addArrangedSubview(label)
        }
    }
    
    //MARK: - ButtonMethod
    @objc private func timeButtonPressed(_ sender : UIButton){
        guard let modifyRecipeData = self.modifyRecipeData else{return}
        
        UIView.animate(withDuration: 0.1, animations: {
            self.timeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.timeButton.transform = CGAffineTransform.identity
            }
        })
        
        let vc = SelectedTimeViewController()
        vc.modalPresentationStyle = .custom
        vc.delegate = self
        vc.selectedTime = modifyRecipeData.foodTime
        self.present(vc, animated: true)
    }
    
    @objc private func nextButtonPressed(_ sender : UIButton){
        let vc = MFTitleAndIngredientViewController()
        vc.modifyRecipeData = self.modifyRecipeData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK: - Extension
extension MFLevelViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.levelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryLabel.text = self.levelArray[indexPath.row]
        
        if let modifyRecipeData = self.modifyRecipeData {
            if modifyRecipeData.foodLevel == self.levelArray[indexPath.row]{
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            }
        }
        
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

extension MFLevelViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.modifyRecipeData?.foodLevel = levelArray[indexPath.row]
    }
}

extension MFLevelViewController : SelectedTimeDelegate{
    func result(time: String) {
        self.modifyRecipeData?.foodTime = time
        self.timeButton.setTitle(" \(time)", for: .normal)
    }
}
