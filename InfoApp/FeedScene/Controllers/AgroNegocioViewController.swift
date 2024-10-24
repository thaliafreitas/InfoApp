//
//  AgroNegocioViewController.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import UIKit

class AgroNegocioViewController: UIViewController {

    private let store = APIManager.sharedInstance
    private var refreshControl = UIRefreshControl()
    private var isReloading: Bool = false
    private var tableView = UITableView(frame: .zero, style: .plain)
    private let errorView = ErrorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupRefreshControl()
        setupErrorView()
        loadFeed()
    }

    private func loadFeed() {
        isReloading = true
        store.fetchG1Feed { [weak self] (result: [Item]) in
            guard let self = self else { return }
            self.store.itemG1 = result
            self.tableView.reloadData()
            self.isReloading = false
            self.refreshControl.endRefreshing()
        } failure: { [weak self] (error) in
            guard let self = self else { return }
            print("Erro ao carregar dados: \(error.localizedDescription)")
            self.isReloading = false
            self.refreshControl.endRefreshing()
        }
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func reload() {
        if !isReloading {
            loadFeed()
        }
    }
    
    private func setupErrorView() {
        errorView.isHidden = true
        errorView.configure(with: "Erro ao carregar dados. Tente novamente.") { [weak self] in
            self?.reload()
        }
        view.addSubview(errorView)

        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension AgroNegocioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.itemAgro.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CardCell else {
            return UITableViewCell()
        }
        let notice = store.itemAgro[indexPath.row]
        cell.setupCell(url: notice.link, noticeTitle: notice.titulo, noticeDescription: notice.introducao, chapeuLabel: notice.editorias.rawValue, timeLabel: notice.dataPublicacao, image: notice.imagens)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewVC = WebViewViewController()
        webViewVC.url = store.itemAgro[indexPath.row].link
        navigationController?.pushViewController(webViewVC, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.store.itemG1.count - 1 {
            loadMoreItems()
        }
    }


    private func loadMoreItems() {
        guard !isReloading, store.currentPage > 0 else { return }
        
        isReloading = true
        print("Carregando a próxima página: \(store.currentPage)")

        store.nextPage { [weak self] (newItems: [Item]) in
            guard let self = self else { return }
            self.store.itemG1.append(contentsOf: newItems)
            self.store.currentPage += 1
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.isReloading = false
            }
        } failure: { [weak self] (error) in
            print("Erro ao carregar mais itens: \(error.localizedDescription)")
            self?.isReloading = false
        }
    }
}

extension AgroNegocioViewController: ViewCode {
    func buildViewHierarchy() {
        view.addSubview(tableView)
    }

    func setupAdditionalConfiguration() {
        setupTableView()
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.setupTableViewCardCell()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .backgroundColor
    }
}
