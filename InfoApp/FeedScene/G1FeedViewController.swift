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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        store.fetchG1Feed { (result: [Item]) in
            self.store.itemG1 = result
            self.tableView.reloadData()
            self.isReloading = false
            self.refreshControl.endRefreshing() // Garantir que finalize o refresh no sucesso também
        } failure: { (error) in
            print("Erro ao carregar dados: \(error.localizedDescription)")
            self.isReloading = false
            self.refreshControl.endRefreshing()
        }

        refreshControl.addTarget(self, action: #selector(reload), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
    }
}

extension G1FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.itemG1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CardCell else {
            return UITableViewCell()
        }
        let notice = self.store.itemG1[indexPath.row]
        cell.setupCell(url: notice.link, noticeTitle: notice.titulo, noticeDescription: notice.introducao, chapeuLabel: "", timeLabel: notice.dataPublicacao, image: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexSelect = indexPath.row
        let webViewVC = WebViewViewController()
        webViewVC.url = self.store.itemG1[indexSelect].link
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.store.itemG1.count - 1 && !isReloading {
            print("Último item visível, tentando carregar mais...")

            if store.currentPage > 0 {
                print("Carregando a próxima página: \(store.currentPage)")
                isReloading = true
                store.nextPage { (newItems: [Item]) in
                    self.store.itemG1.append(contentsOf: newItems)
                    self.store.currentPage += 1 // Incrementar a página aqui
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.isReloading = false
                    }
                } failure: { (error) in
                    self.isReloading = false
                }
            }
        }
    }
}

extension G1FeedViewController: ViewCode {
    func buildViewHierarchy() {
        view.addSubview(tableView)
    }

    func setupAdditionalConfiguration() {
        setupTable()
    }

    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
    }

}

extension G1FeedViewController {
    @objc func reload() {
        if !isReloading {
            isReloading = true
            self.store.itemG1.removeAll()
            store.fetchG1Feed { (result: [Item]) in
                self.store.itemG1 = result
                self.isReloading = false
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } failure: { (error) in
                self.isReloading = false // Assegura que seja definido como false mesmo em caso de erro
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension G1FeedViewController {
    func setupTable() {
        tableView.setupTableViewCardCell()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .backgroundColor
    }
}
