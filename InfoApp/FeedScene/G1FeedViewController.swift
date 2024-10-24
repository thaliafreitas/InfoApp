//
//  G1FeedViewController.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import UIKit

class G1FeedViewController: UIViewController {

    private let store = APIManager.sharedInstance
    private var refreshControl = UIRefreshControl()
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var isReloading: Bool = false
    private let errorView = ErrorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupRefreshControl()
        setupErrorView()
        loadData()
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func loadData() {
        guard !isReloading else { return }
        isReloading = true
        setErrorViewVisible(false)
        store.fetchG1Feed { [weak self] (result: [Item]) in
            self?.handleFetchSuccess(result)
        } failure: { [weak self] (error) in
            self?.handleFetchFailure(error)
        }
    }

    @objc private func reload() {
        guard !isReloading else { return }
        isReloading = true
        store.itemG1.removeAll()
        loadData()
    }

    private func handleFetchSuccess(_ result: [Item]) {
        store.itemG1 = result
        tableView.reloadData()
        endRefreshing()
    }

    private func handleFetchFailure(_ error: Error) {
        print("Erro ao carregar dados: \(error.localizedDescription)")
        setErrorViewVisible(true)
        endRefreshing()
    }
    
    private func setErrorViewVisible(_ isVisible: Bool) {
        errorView.isHidden = !isVisible
    }

    private func endRefreshing() {
        isReloading = false
        refreshControl.endRefreshing()
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

extension G1FeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.itemG1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CardCell else {
            return UITableViewCell()
        }
        let notice = store.itemG1[indexPath.row]
        cell.setupCell(url: notice.link, noticeTitle: notice.titulo, noticeDescription: notice.introducao, chapeuLabel: notice.editorias.rawValue, timeLabel: notice.dataPublicacao, image: notice.imagens)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewVC = WebViewViewController()
        webViewVC.url = store.itemG1[indexPath.row].link
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

extension G1FeedViewController: ViewCode {
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
