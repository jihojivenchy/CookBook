//
//  ShowRecipeHeaderView.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/01.
//

import UIKit
import SnapKit

final class ShowRecipeHeaderView: UIView {
    
    static let identifier = "ShowRecipeHeader"
    
    final var delegate : CategoryCellClikedDelegate?
    
    final var selectedIndex : Int = Int() {
        didSet{
            addSubViews()
        }
    }
    
    final var check : Bool = true         //layoutSubViews가 스크롤 할 때마다 실행되기 때문에, 체크를 통해 실행을 막음.
    
    final let categoryLabel = UILabel()
    final let subTitleLabel = UILabel()
    
    private let categoryCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = .init(width: 100, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    private let categoryArray : [String] = ["전체", "한식", "중식", "양식", "일식", "간식", "채식", "퓨전", "분식", "안주"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewBorderCustom()
        
        categoryCollectionView.register(ShowRecipeCollectionViewCell.self, forCellWithReuseIdentifier: ShowRecipeCollectionViewCell.identifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if check {
            let indexPath = IndexPath(item: selectedIndex, section: 0)
            categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        check = false
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(categoryLabel)
        categoryLabel.textColor = .customNavy
        categoryLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 27)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.textColor = .darkGray
        subTitleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 17)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        addSubview(categoryCollectionView)
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(110)
        }
        
    }
    
    private func viewBorderCustom() {
        
        let border = UIView()
        border.backgroundColor = .lightGray
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5)
        border.clipsToBounds = true
        border.layer.cornerRadius = 30
        border.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        self.addSubview(border)
        //특정 border line
    }
    
}

extension ShowRecipeHeaderView : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowRecipeCollectionViewCell.identifier, for: indexPath) as! ShowRecipeCollectionViewCell
        
        cell.categoryImageView.image = UIImage(named: self.categoryArray[indexPath.row])
        cell.categoryLabel.text = self.categoryArray[indexPath.row]
        
        if indexPath.row == self.selectedIndex {
            cell.backGroundView.backgroundColor = .customSignature
            cell.categoryLabel.textColor = .white
        }else{
            cell.backGroundView.backgroundColor = .white
            cell.categoryLabel.textColor = .black
        }
        
        return cell
    }
    
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 100, height: 100)
        
        
        return size
    }
    
}

extension ShowRecipeHeaderView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.delegate?.cellClicked(index: self.selectedIndex)
    }
}

protocol CategoryCellClikedDelegate {
    func cellClicked(index : Int)
}
