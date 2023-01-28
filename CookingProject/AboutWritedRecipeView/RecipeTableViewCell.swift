//
//  IngredientTableViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/26.
//

import UIKit
import SnapKit

final class RecipeTableViewCell: UITableViewCell {
    
    static let identifier = "RecipeCell"
    
    final var textDelegate : RecipeTextViewDelegate?
    
    final let backGroundView = UIView()
    final let stepLabel = UILabel()
    final let recipeTextView = UITextView()
    
    final var textIndex = Int()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.backgroundColor = .clear
        
        addSubview(stepLabel)
        stepLabel.textColor = .black
        stepLabel.font = UIFont(name: KeyWord.CustomFont, size: 18)
        stepLabel.sizeToFit()
        stepLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
        }
        
        addSubview(recipeTextView)
        recipeTextView.returnKeyType = .next
        recipeTextView.font = .systemFont(ofSize: 17)
        recipeTextView.textColor = .black
        recipeTextView.delegate = self
        recipeTextView.clipsToBounds = true
        recipeTextView.layer.cornerRadius = 7
        recipeTextView.backgroundColor = .white
        recipeTextView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
}

extension RecipeTableViewCell : UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.textDelegate?.startEditing(index: textIndex)
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = recipeTextView.text else{return}
        
        self.textDelegate?.sendText(index: textIndex, text: text)
    }
}

protocol RecipeTextViewDelegate {
    func sendText(index : Int, text : String)
    
    func startEditing(index : Int)
}
