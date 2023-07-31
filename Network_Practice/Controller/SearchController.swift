//
//  SearchController.swift
//  Network_Practice
//
//  Created by Macbook on 2023/07/31.
//

import UIKit

class SearchController: UIViewController {
    
    
    @IBOutlet weak var colletionView: UICollectionView!
    
    let networkManager = Networking.shared
    
    var musicArray: [Music] = []
    
    let flowLayout = UICollectionViewFlowLayout()
    
    var searchTerm:String? {
        didSet {
            setupDatas()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLayout()
    }
    
    func autoLayout() {
        colletionView.dataSource = self
        
        colletionView.backgroundColor = .white
        
        let colletionCellWidth = (UIScreen.main.bounds.width - CVitem.spacingWitdh * (CVitem.cellColumns - 1)) / CVitem.cellColumns
        
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: colletionCellWidth, height: colletionCellWidth)
        flowLayout.minimumLineSpacing = CVitem.spacingWitdh
        flowLayout.minimumInteritemSpacing = CVitem.spacingWitdh
        
        colletionView.collectionViewLayout = flowLayout
        
    }
    
    func setupDatas() {
        
             guard let text = searchTerm else { return }
             let newText = text.replacingOccurrences(of: " ", with: "+")
             print(text)
                     // 다시 빈 배열로 만들기 ⭐️
             self.musicArray = []
         
             // 네트워킹 시작
             networkManager.fetchMusic(searchTerm: newText) { result in
                 switch result {
                 case .success(let musicDatas):
                       self.musicArray = musicDatas
                       DispatchQueue.main.async {
                           self.colletionView.reloadData()
                       }
                 case .failure(let error):
                       print(error.localizedDescription)
               }
             }
        self.view.endEditing(true)
       }
    
}

extension SearchController: UICollectionViewDataSource {
    
    // 갯수를 정함
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArray.count
    }
    
    // view를 어떻게 그릴건지 정함 (cell(view)에게 전달)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVitem.Idntifier, for: indexPath) as! CVCell
        cell.imageUrl = musicArray[indexPath.item].imageUrl
        
        return cell
    }
    
}
