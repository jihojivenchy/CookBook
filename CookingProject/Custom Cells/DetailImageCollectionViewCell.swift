//
//  DetailImageCollectionViewCell.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/21.
//

import UIKit
import SnapKit

class DetailImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "DetailImageViewCell"
    
    let imageViewer = UIImageView()
    let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        self.backgroundColor = .white
        
        contentView.addSubview(scrollView)
        scrollView.backgroundColor = .black
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
        scrollView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(contentView)
        }
        
        scrollView.addSubview(imageViewer)
        imageViewer.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(scrollView)
            make.width.height.equalTo(scrollView)
        }
        
    }
    
}

extension DetailImageCollectionViewCell : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageViewer
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let collectionView = self.superview as? UICollectionView else{return} //superview인 컬렉션뷰를 가져온다.
        
        let enLaged : Bool = scrollView.zoomScale > 1 //이미지가 확대되어 있는 상태인지 확인.
        collectionView.isScrollEnabled = !enLaged //이미지가 확대되어 있지않다면 페이징이 가능하다.
    }
    
    
}
