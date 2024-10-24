//
//  FeedViewModel.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let count, page, totalPages, nextPage: Int
    let previousPage, showingFrom, showingTo: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: Int
    let tipo: Tipo
    let titulo, introducao, dataPublicacao: String
    let produtoID: Int
    let produtos: String
    let editorias: Editorias
    var imagens: String
    let produtosRelacionados: String
    let destaque: Bool
    var link: String

    enum CodingKeys: String, CodingKey {
        case id, tipo, titulo, introducao
        case dataPublicacao = "data_publicacao"
        case produtoID = "produto_id"
        case produtos, editorias, imagens
        case produtosRelacionados = "produtos_relacionados"
        case destaque, link
    }
}

// MARK: - ImageInfo
struct ImageInfo: Codable {
    let imageIntro: String
    let imageFulltext: String

    enum CodingKeys: String, CodingKey {
        case imageIntro = "image_intro"
        case imageFulltext = "image_fulltext"
    }
}


enum Editorias: String, Codable {
    case economicas = "economicas"
    case geociencias = "geociencias"
    case ibge = "ibge"
    case ibgeCenso2020 = "ibge;censo2020"
    case sociais = "sociais"
}

enum Tipo: String, Codable {
    case noticia = "Notícia"
    case release = "Release"
}
