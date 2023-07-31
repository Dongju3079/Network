//
//  CVCell.swift
//  Network_Practice
//
//  Created by Macbook on 2023/07/31.
//

import UIKit

class CVCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let urlString = self.imageUrl else { return }
        guard let url = URL(string: urlString)  else { return }

        DispatchQueue.global().async {
                        // 데이터를 통해서 이미지를 받아올 때 아래와 같은 코드를 사용함
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거 ⭐️⭐️⭐️
            guard self.imageUrl == url.absoluteString else { return }

            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행 ⭐️
        self.imageView.image = nil
    }
    
    
}
