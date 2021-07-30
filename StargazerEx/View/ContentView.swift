//
//  ContentView.swift
//  StargazerEx
//
//  Created by Massa Antonio on 30/07/21.
//

import SwiftUI

struct ContentView: View {
	@StateObject var viewModel = ViewModel()

	var body: some View {
		NavigationView {
			List {
				ForEach(viewModel.stargazers, id: \.self) { stargazer in
					HStack {
						URLImage(stargazer: stargazer, urlString: stargazer.avatar_url)
						Text(stargazer.login)
							.bold()
					}
					.padding(3)
				}
			}
			.navigationTitle("Stargazer")
			.onAppear {
				viewModel.fetch()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

struct URLImage: View {
	var stargazer: Stargazer
	let urlString: String
	@State var data: Data?

	var body: some View {
		if let data = data, let image = UIImage(data: data) {
			Image(uiImage:image)
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: 80, height: 80)
				.cornerRadius(40)
				.shadow(color: .black, radius: 10, x: 0, y: 0)
		} else {
		Image(systemName: "photo")
			imageStyle()
			.onAppear {
				fetchData()
			}
		}
	}
	
	private func fetchData() {
		guard let url = URL(string: urlString) else {
			return
		}
		let task = URLSession.shared.dataTask(with: url) { data, _, _ in
			self.data = data
		}
		task.resume()
	}
}

extension URLImage {
	func imageStyle() -> some View {
		return Image(stargazer.avatar_url)
			.resizable()
			.frame(width: 80, height: 80)
			.cornerRadius(40)
			.shadow(color: .black, radius: 8)
	}

}
