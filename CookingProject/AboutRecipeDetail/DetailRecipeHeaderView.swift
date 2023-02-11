//
//  DetailRecipeHeaderView.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/09.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailRecipeHeaderView: UIView {
    static let identifier = "DetailRecipeHeader"
    final var delegate : RecipeHeaderDelegate?
    final var recipeData : RecipeDataModel = RecipeDataModel(title: "", chefName: "", heartPeople: [], level: "", time: "", date: "", url: "", category: "", documentID: "") {
        didSet{
            addSubViews()
        }
    }
    final var name = String() //쉐프 닉네임
    final var commentsCount = Int() //댓글 갯수
    
    final let titleFoodImage = UIImageView()
    final let backGroundView = UIView()
    
    final let titleFoodName = UILabel()
    final let firstStackView = UIStackView()
    final let secondStackView = UIStackView()
    
    private lazy var heartButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        let image = UIImage(systemName: "suit.heart.fill", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = "\(recipeData.heartPeople.count)개"
        configuration.attributedTitle?.font = UIFont(name: KeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .customSignature
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.addTarget(self, action: #selector(heartButtonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.backgroundColor = .customSignature
        
        return button
    }()
    
    private lazy var categoryButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        let image = UIImage(systemName: "bookmark.fill", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = recipeData.category
        configuration.attributedTitle?.font = UIFont(name: KeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .customSignature
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.backgroundColor = .customSignature
        
        return button
    }()
    
    private lazy var levelButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        let image = UIImage(systemName: "chart.bar.fill", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = recipeData.level
        configuration.attributedTitle?.font = UIFont(name: KeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .customSignature
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.backgroundColor = .customSignature
        
        return button
    }()
    
    private lazy var timeButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        let image = UIImage(systemName: "alarm.fill", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = recipeData.time
        configuration.attributedTitle?.font = UIFont(name: KeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .customSignature
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.backgroundColor = .customSignature
        
        return button
    }()
    
    private lazy var userButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular, scale: .default)
        let image = UIImage(systemName: "person.circle", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .leading
        configuration.imagePadding = 7
        configuration.title = self.name
        configuration.attributedTitle?.font = UIFont(name: KeyWord.CustomFont, size: 16)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(userButtonPressed(_:)), for: .touchUpInside)
        button.tintColor = .customNavy
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    private lazy var CommentsButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular, scale: .default)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 5
        configuration.title = "댓글 \(self.commentsCount)개"
        configuration.attributedTitle?.font = UIFont(name: KeyWord.CustomFont, size: 16)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(commentsButtonPressed(_:)), for: .touchUpInside)
        button.tintColor = .customNavy
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        button.sizeToFit()
        
        return button
    }()
    
    private let ingredientsLabel = UILabel()
    final lazy var ingredientsTextView : UITextView = {
        let tv = UITextView()
        tv.returnKeyType = .next
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 5
        tv.font = .boldSystemFont(ofSize: 17)
        tv.textColor = .black
        tv.tintColor = .black
        tv.backgroundColor = .white
        tv.isEditable = false
        tv.showsVerticalScrollIndicator = false
        
        return tv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewBorderCustom()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        let width = self.frame.size.width
        
        addSubview(titleFoodImage)
        titleFoodImage.setImage(with: recipeData.url, width: width, height: 400)
        titleFoodImage.backgroundColor = .clear
        titleFoodImage.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(400)
        }
        
        addSubview(backGroundView)
        backGroundView.backgroundColor = .customWhite
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 30
        backGroundView.snp.makeConstraints { make in
            make.top.equalTo(titleFoodImage.snp_bottomMargin).offset(-10)
            make.left.right.equalToSuperview()
            make.height.equalTo(430)
        }
        
        backGroundView.addSubview(titleFoodName)
        titleFoodName.text = recipeData.title
        titleFoodName.textColor = .customNavy
        titleFoodName.font = UIFont(name: KeyWord.CustomFont, size: 25)
        titleFoodName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(25)
        }
        
        backGroundView.addSubview(firstStackView)
        firstStackView.backgroundColor = .clear
        firstStackView.axis = .horizontal
        firstStackView.distribution = .fillEqually
        firstStackView.alignment = .center
        firstStackView.spacing = 15
        firstStackView.snp.makeConstraints { make in
            make.top.equalTo(titleFoodName.snp_bottomMargin).offset(30)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(285)
            make.height.equalTo(60)
        }
        
        firstStackView.addArrangedSubview(heartButton)
        firstStackView.addArrangedSubview(categoryButton)
        firstStackView.addArrangedSubview(levelButton)
        firstStackView.addArrangedSubview(timeButton)
        
        backGroundView.addSubview(ingredientsLabel)
        ingredientsLabel.text = "재료"
        ingredientsLabel.textColor = .black
        ingredientsLabel.font = UIFont(name: KeyWord.CustomFont, size: 17)
        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(30)
        }
        
        backGroundView.addSubview(ingredientsTextView)
        ingredientsTextView.snp.makeConstraints { make in
            make.top.equalTo(ingredientsLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(150)
        }
        
        backGroundView.addSubview(secondStackView)
        secondStackView.backgroundColor = .clear
        secondStackView.axis = .horizontal
        secondStackView.distribution = .fillEqually
        secondStackView.alignment = .center
        secondStackView.spacing = 0
        secondStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        secondStackView.addArrangedSubview(userButton)
        secondStackView.addArrangedSubview(CommentsButton)
        
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
    
    
    @objc private func heartButtonPressed(_ seder : UIButton) {
        self.delegate?.heartButtonPressed()
    }
    
    @objc private func userButtonPressed(_ seder : UIButton) {
        self.delegate?.userButtonPressed()
    }
    
    @objc private func commentsButtonPressed(_ seder : UIButton) {
        self.delegate?.commentsButtonPressed()
    }
    
}

protocol RecipeHeaderDelegate {
    func heartButtonPressed()
    func userButtonPressed()
    func commentsButtonPressed()
}
