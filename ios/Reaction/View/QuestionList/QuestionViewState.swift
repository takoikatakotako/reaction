import SwiftUI

class QuestionViewState: ObservableObject {
    @Published var questions: [Question] = [
        Question(
            id: 1,
            problemImageName: R.image.questionProblem1.name,
            solutionImageName: R.image.questionSolution1.name,
            references: [
                "https://pubs.acs.org/doi/10.1021/ol9025793"
            ]
        ),
        Question(
            id: 2,
            problemImageName: R.image.questionProblem2.name,
            solutionImageName: R.image.questionSolution2.name,
            references: [
                "https://www.degruyter.com/document/doi/10.1351/pac196817030519/html"
            ]
        ),
        Question(
            id: 3,
            problemImageName: R.image.questionProblem3.name,
            solutionImageName: R.image.questionSolution3.name,
            references: [
                "https://doi.org/10.1021/ja01183a084"
            ]
        ),
        Question(
            id: 4,
            problemImageName: R.image.questionProblem4.name,
            solutionImageName: R.image.questionSolution4.name,
            references: [
                "https://pubs.acs.org/doi/10.1021/ja9103233",
                "https://cdnsciencepub.com/doi/abs/10.1139/v78-048"
            ]
        ),
        Question(
            id: 5,
            problemImageName: R.image.questionProblem5.name,
            solutionImageName: R.image.questionSolution5.name,
            references: [
                "https://doi.org/10.1016/S0040-4039(00)61908-1"
            ]
        ),
        Question(
            id: 6,
            problemImageName: R.image.questionProblem6.name,
            solutionImageName: R.image.questionSolution6.name,
            references: [
                "https://doi.org/10.1021/ja00844a065"
            ]
        ),
        Question(
            id: 7,
            problemImageName: R.image.questionProblem7.name,
            solutionImageName: R.image.questionSolution7.name,
            references: [
                "https://doi.org/10.1002/anie.201102494"
            ]
        ),
        Question(
            id: 8,
            problemImageName: R.image.questionProblem8.name,
            solutionImageName: R.image.questionSolution8.name,
            references: [
                "https://doi.org/10.1021/ol9001653"
            ]
        ),
        Question(
            id: 9,
            problemImageName: R.image.questionProblem9.name,
            solutionImageName: R.image.questionSolution9.name,
            references: [
                "https://doi.org/10.1021/op010041v"
            ]
        ),
        Question(
            id: 10,
            problemImageName: R.image.questionProblem10.name,
            solutionImageName: R.image.questionSolution10.name,
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        )
    ]
}
