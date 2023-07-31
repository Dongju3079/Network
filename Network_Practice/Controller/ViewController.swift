//
//  ViewController.swift
//  Network_Practice
//
//  Created by Macbook on 2023/07/31.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var musicTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil)
                                                .instantiateViewController(withIdentifier: "SearchController"))
    
    let networkManager = Networking.shared
    
    var musicArray: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatas()
        setupTableView()
        setupSearchBar()
    }
    
    func setupDatas() {
        
        networkManager.fetchMusic(searchTerm: "jazz") { result in
            switch result {
            case .success(let musicDatas):
                print("네트워크 연결 성공")
                self.musicArray = musicDatas
                
                // 받은 다음 테이블뷰 리로드
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupSearchBar() {
        // 제목 변경
        self.title = "Music Search"
        
        // 네비게이션 아이템 할당
        navigationItem.searchController = searchController
        
        // 🍏 1) (단순)서치바의 사용
        searchController.searchBar.delegate = self
        
        // 🍎 2) 서치(결과)컨트롤러의 사용 (복잡한 구현 가능)
        // 글자마다 검색 기능 + 새로운 화면을 보여주는 것도 가능
        searchController.searchResultsUpdater = self
        
        // 첫글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
        
    }
    
    func setupTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        
        musicTableView.register(UINib(nibName: Cell.Idntifier, bundle: nil), forCellReuseIdentifier: Cell.Idntifier)
    }
    
    
    
}

extension ViewController: UITableViewDataSource {
    
    //1) 테이블뷰에 몇개의 데이터를 표시할 것인지(셀이 몇개인지)를 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return musicArray.count
    }
    
    
    //2) 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        
        // (힙에 올라간)재사용 가능한 셀을 꺼내서 사용하는 메서드 (애플이 미리 잘 만들어 놓음)
        // (스토리보드로 만들면 사전에 셀을 등록하는 과정이 내부 메커니즘에 존재 / 코드로 작업시 register과정필요)
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.Idntifier, for: indexPath) as! MusicCell
        
        cell.imageUrl = musicArray[indexPath.row].imageUrl
        
        cell.musicName.text = musicArray[indexPath.row].musicName
        cell.singerName.text = musicArray[indexPath.row].artistName
        cell.colletionName.text = musicArray[indexPath.row].collectionName
        cell.releaseDate.text = musicArray[indexPath.row].releaseDate
        
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    // 테이블뷰 셀의 높이를 유동적으로 조절하고 싶다면 구현할 수 있는 메서드
    // (musicTableView.rowHeight = 120 대신에 사용가능)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ViewController: UISearchBarDelegate {
    
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
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
                      self.musicTableView.reloadData()
                  }
            case .failure(let error):
                  print(error.localizedDescription)
          }
        }
   self.view.endEditing(true)
  }
}

extension ViewController: UISearchResultsUpdating {
    // 유저가 글자를 입력하는 순간마다 호출되는 메서드 ===> 일반적으로 다른 화면을 보여줄때 구현
    func updateSearchResults(for searchController: UISearchController) {
//        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        // 글자를 치는 순간에 다른 화면을 보여주고 싶다면 (컬렉션뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchController
        // 컬렉션뷰에 찾으려는 단어 전달
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
