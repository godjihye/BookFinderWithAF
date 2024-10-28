//
//  BookTableViewController.swift
//  BookFinderWithAF
//
//  Created by jhshin on 10/28/24.
//

import UIKit
import Alamofire
import Kingfisher

class BookTableViewController: UITableViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var btnLeft: UIBarButtonItem!
	@IBOutlet weak var btnRight: UIBarButtonItem!
	
	let APIKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as! String
	var books: [Book]?
	var page = 0 {
		didSet {
			btnLeft.isEnabled = page > 1
			search(query: searchBar.text, page: page)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func search(query: String?, page: Int) {
		guard let query else {return}
		let endPoint = "https://dapi.kakao.com/v3/search/book"
		let params: Parameters = ["query": query, "page": page]
		let headers: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey)"]
		let alamo = AF.request(endPoint, parameters: params, headers: headers)
		alamo.responseDecodable(of: Root.self){ response in
			switch response.result {
			case .success(let root):
				self.books = root.books
				let isEnd = root.meta.isEnd
				self.btnRight.isEnabled = !isEnd
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			case .failure(let error):
				print(error.localizedDescription)
				
			}
		}
	}
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return books?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "bookcell", for: indexPath)
		guard let book = books?[indexPath.row] else {return cell}
		let imgCover = cell.viewWithTag(1) as? UIImageView
		let coverURL = URL(string: book.thumbnail)
		let ai = UIActivityIndicatorView(style: .large)
		
		imgCover?.kf
			.setImage(with: coverURL, placeholder: UIImage(systemName: ""))
		let lblTitle = cell.viewWithTag(2) as? UILabel
		lblTitle?.text = book.title
		let lblAuthors = cell.viewWithTag(3) as? UILabel
		lblAuthors?.text = book.authors.joined(separator: " ")
		
		return cell
	}
	
	/*
	 // MARK: - Navigation
	 
	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	 // Get the new view controller using segue.destination.
	 // Pass the selected object to the new view controller.
	 }
	 */
	
	@IBAction func actNext(_ sender: UIBarButtonItem) {
		page += 1
	}
	@IBAction func actPrev(_ sender: UIBarButtonItem) {
		page -= 1
	}
}
extension BookTableViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		page = 1
		searchBar.resignFirstResponder() // query를 키보드로 쓴 후 키보드를 내림
	}
}
