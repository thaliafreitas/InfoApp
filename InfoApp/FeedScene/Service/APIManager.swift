//
//  APIManager.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import Foundation
import Alamofire

class APIManager {
    
    var g1Url = G1Provider()

    static let sharedInstance = APIManager()

    var itemG1: [Item] = []
    var itemAgro: [Item] = []
    var currentPage = 1

    func fetchG1Feed(completion: @escaping ([Item]) -> Void, failure: @escaping (Error) -> Void) {
        AF.request(g1Url.g1ApiAdress).responseDecodable(of: Welcome.self) { response in
            switch response.result {
            case .success(let feed):
                // Adiciona os itens da nova página sem remover os anteriores
                for var item in feed.items {
                    // Verifica se o link começa com "http://" e substitui por "https://"
                    if item.link.hasPrefix("http://") {
                        item.link = item.link.replacingOccurrences(of: "http://", with: "https://")
                    }
                    
                    // Decodifica a string de imagens
                    if let data = item.imagens.data(using: .utf8) {
                        do {
                            // Tenta decodificar a string para um objeto ImageInfo
                            let images = try JSONDecoder().decode(ImageInfo.self, from: data)
                            let baseURL = "https://servicodados.ibge.gov.br/"
                            
                            let updatedImageIntro = baseURL + images.imageIntro
                            let updatedImageFulltext = baseURL + images.imageFulltext
                            item.imagens = updatedImageIntro

                            // Use updatedImageIntro e updatedImageFulltext conforme necessário
                            print("Updated Image Intro URL: \(updatedImageIntro)")
                            print("Updated Image Fulltext URL: \(updatedImageFulltext)")

                        } catch {
                            print("Erro ao decodificar imagens: \(error)")
                        }
                    }
                    
                    if item.tipo == .noticia {
                        self.itemG1.append(item)
                    } else {
                        self.itemAgro.append(item)
                    }
                }
                self.currentPage = feed.nextPage
                completion(self.itemG1)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    // MARK: - To discuss
    func nextPage(completion: @escaping ([Item]) -> Void, failure: @escaping (Error) -> Void) {
        // Verifica se há uma próxima página
        guard self.currentPage > 0 else {
            completion([]) // Se não houver próxima página, retorna uma lista vazia
            return
        }

        let url = "https://servicodados.ibge.gov.br/api/v3/noticias/?page=\(self.currentPage)"
        AF.request(url).responseDecodable(of: Welcome.self) { response in
            switch response.result {
            case .success(let feed):
                for item in feed.items {
                        self.itemG1.append(item)
                }
                self.currentPage = feed.nextPage
                completion(self.itemG1)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
