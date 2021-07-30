//
//  ViewModel.swift
//  StargazerEx
//
//  Created by Massa Antonio on 30/07/21.
//

import Foundation

struct Stargazer: Hashable, Codable {
	let login: String
	let id: Int
	let avatar_url: String
}

class ViewModel: ObservableObject {
	@Published var stargazers: [Stargazer] = []

	func fetch() {
		guard let url = URL(string: "https://api.github.com/repos/octocat/hello-world/stargazers") else { return }
		let task = URLSession.shared.dataTask(with: url) { [weak self]  data, _, error in
			guard let data = data, error == nil else { return }
			//Convert JSON
			do {
				let stargazers = try JSONDecoder().decode([Stargazer].self, from: data)
				DispatchQueue.main.async {
					self?.stargazers = stargazers
				}
			} catch  {
				print(error)
			}
		}
		task.resume()
	}
}
