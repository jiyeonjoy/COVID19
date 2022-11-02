//
//  ViewController.swift
//  COVID19
//
//  Created by Jiyeon Choi on 2022. 10. 26..
//

import UIKit

import Charts
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }
    
    func fetchCovidOverview(
        /// 함수를 탈출해도 호출가능! 비동기 작업인 경우 해줘야됨. 언제 api 통신이 완료될지 모르기 때문!
      completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void
    ) {
      let url = "https://api.corona-19.kr/korea/country/new/"
      let param = [
        "serviceKey": "MHym6cezIlKtFRN3Wr2n4ExpYUw5fiJaD"
      ]
      AF.request(url, method: .get, parameters: param)
        .responseData(completionHandler: { response in
          switch response.result {
          case let .success(data):
            do {
              let decoder = JSONDecoder()
              let result = try decoder.decode(CityCovidOverview.self, from: data)
              completionHandler(.success(result))
            } catch {
              completionHandler(.failure(error))
            }
          case let .failure(error):
            completionHandler(.failure(error))
          }
        })
    }
}
