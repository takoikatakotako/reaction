import SwiftUI

class QuestionViewState: ObservableObject {
    @Published var questions: [Question] = [
        Question(
            id: 1,
            problemImageNames: [R.image.questionProblem1.name],
            solutionImageNames: [R.image.questionSolution1.name],
            references: [
                "https://pubs.acs.org/doi/10.1021/ol9025793"
            ]
        ),
        Question(
            id: 2,
            problemImageNames: [R.image.questionProblem2.name],
            solutionImageNames: [R.image.questionSolution2.name],
            references: [
                "https://www.degruyter.com/document/doi/10.1351/pac196817030519/html"
            ]
        ),
        Question(
            id: 3,
            problemImageNames: [R.image.questionProblem3.name],
            solutionImageNames: [R.image.questionSolution3.name],
            references: [
                "https://doi.org/10.1021/ja01183a084"
            ]
        ),
        Question(
            id: 4,
            problemImageNames: [R.image.questionProblem4.name],
            solutionImageNames: [R.image.questionSolution4.name],
            references: [
                "https://pubs.acs.org/doi/10.1021/ja9103233",
                "https://cdnsciencepub.com/doi/abs/10.1139/v78-048"
            ]
        ),
        Question(
            id: 5,
            problemImageNames: [R.image.questionProblem5.name],
            solutionImageNames: [R.image.questionSolution5.name],
            references: [
                "https://doi.org/10.1016/S0040-4039(00)61908-1"
            ]
        ),
        Question(
            id: 6,
            problemImageNames: [R.image.questionProblem6.name],
            solutionImageNames: [R.image.questionSolution6.name],
            references: [
                "https://doi.org/10.1021/ja00844a065"
            ]
        ),
        Question(
            id: 7,
            problemImageNames: [R.image.questionProblem7.name],
            solutionImageNames: [R.image.questionSolution7.name],
            references: [
                "https://doi.org/10.1002/anie.201102494"
            ]
        ),
        Question(
            id: 8,
            problemImageNames: [R.image.questionProblem8.name],
            solutionImageNames: [R.image.questionSolution8.name],
            references: [
                "https://doi.org/10.1021/ol9001653"
            ]
        ),
        Question(
            id: 9,
            problemImageNames: [R.image.questionProblem9.name],
            solutionImageNames: [R.image.questionSolution9.name],
            references: [
                "https://doi.org/10.1021/op010041v"
            ]
        ),
        Question(
            id: 10,
            problemImageNames: [R.image.questionProblem10.name],
            solutionImageNames: [R.image.questionSolution10.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 11,
            problemImageNames: [R.image.questionProblem10.name],
            solutionImageNames: [R.image.questionSolution10.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 11,
            problemImageNames: [R.image.questionProblem11.name],
            solutionImageNames: [R.image.questionSolution11.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 12,
            problemImageNames: [R.image.questionProblem12.name],
            solutionImageNames: [R.image.questionSolution12.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 13,
            problemImageNames: [R.image.questionProblem13.name],
            solutionImageNames: [R.image.questionSolution13.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 14,
            problemImageNames: [R.image.questionProblem14.name],
            solutionImageNames: [R.image.questionSolution14.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 15,
            problemImageNames: [R.image.questionProblem15.name],
            solutionImageNames: [R.image.questionSolution15.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 16,
            problemImageNames: [R.image.questionProblem16.name],
            solutionImageNames: [R.image.questionSolution16.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 17,
            problemImageNames: [R.image.questionProblem17.name],
            solutionImageNames: [R.image.questionSolution17.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 18,
            problemImageNames: [R.image.questionProblem18.name],
            solutionImageNames: [R.image.questionSolution18.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 19,
            problemImageNames: [R.image.questionProblem19.name],
            solutionImageNames: [R.image.questionSolution19.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 20,
            problemImageNames: [R.image.questionProblem20.name],
            solutionImageNames: [R.image.questionSolution20.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 21,
            problemImageNames: [R.image.questionProblem21.name],
            solutionImageNames: [R.image.questionSolution21.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 22,
            problemImageNames: [R.image.questionProblem22.name],
            solutionImageNames: [R.image.questionSolution22.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 23,
            problemImageNames: [R.image.questionProblem23.name],
            solutionImageNames: [R.image.questionSolution23.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 24,
            problemImageNames: [R.image.questionProblem24.name],
            solutionImageNames: [R.image.questionSolution24.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 25,
            problemImageNames: [R.image.questionProblem25.name],
            solutionImageNames: [R.image.questionSolution25.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 26,
            problemImageNames: [R.image.questionProblem26.name],
            solutionImageNames: [R.image.questionSolution26.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 27,
            problemImageNames: [R.image.questionProblem27.name],
            solutionImageNames: [R.image.questionSolution27.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 28,
            problemImageNames: [R.image.questionProblem28.name],
            solutionImageNames: [R.image.questionSolution28.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 29,
            problemImageNames: [R.image.questionProblem29.name],
            solutionImageNames: [R.image.questionSolution29.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 30,
            problemImageNames: [R.image.questionProblem30.name],
            solutionImageNames: [R.image.questionSolution30.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 31,
            problemImageNames: [R.image.questionProblem31.name],
            solutionImageNames: [R.image.questionSolution31.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 32,
            problemImageNames: [R.image.questionProblem32.name],
            solutionImageNames: [R.image.questionSolution32.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 33,
            problemImageNames: [R.image.questionProblem33.name],
            solutionImageNames: [R.image.questionSolution33.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 34,
            problemImageNames: [R.image.questionProblem34.name],
            solutionImageNames: [R.image.questionSolution34.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 35,
            problemImageNames: [R.image.questionProblem35.name],
            solutionImageNames: [R.image.questionSolution35.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 36,
            problemImageNames: [R.image.questionProblem36.name],
            solutionImageNames: [R.image.questionSolution36.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 37,
            problemImageNames: [R.image.questionProblem37.name],
            solutionImageNames: [R.image.questionSolution37.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 38,
            problemImageNames: [R.image.questionProblem38.name],
            solutionImageNames: [R.image.questionSolution38.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 39,
            problemImageNames: [R.image.questionProblem39.name],
            solutionImageNames: [R.image.questionSolution39.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 40,
            problemImageNames: [R.image.questionProblem40.name],
            solutionImageNames: [R.image.questionSolution40.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 41,
            problemImageNames: [R.image.questionProblem41.name],
            solutionImageNames: [R.image.questionSolution41.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 42,
            problemImageNames: [R.image.questionProblem42.name],
            solutionImageNames: [R.image.questionSolution42.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 43,
            problemImageNames: [R.image.questionProblem43.name],
            solutionImageNames: [R.image.questionSolution43.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 44,
            problemImageNames: [R.image.questionProblem44.name],
            solutionImageNames: [R.image.questionSolution44.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 45,
            problemImageNames: [R.image.questionProblem45.name],
            solutionImageNames: [R.image.questionSolution45.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 46,
            problemImageNames: [R.image.questionProblem46.name],
            solutionImageNames: [R.image.questionSolution46.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 47,
            problemImageNames: [R.image.questionProblem47.name],
            solutionImageNames: [R.image.questionSolution47.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 48,
            problemImageNames: [R.image.questionProblem48.name],
            solutionImageNames: [R.image.questionSolution48.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 49,
            problemImageNames: [R.image.questionProblem49.name],
            solutionImageNames: [R.image.questionSolution49.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 50,
            problemImageNames: [R.image.questionProblem50.name],
            solutionImageNames: [R.image.questionSolution50.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 51,
            problemImageNames: [R.image.questionProblem51.name],
            solutionImageNames: [R.image.questionSolution51.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 52,
            problemImageNames: [R.image.questionProblem52.name],
            solutionImageNames: [R.image.questionSolution52.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 53,
            problemImageNames: [R.image.questionProblem53.name],
            solutionImageNames: [R.image.questionSolution53.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 54,
            problemImageNames: [R.image.questionProblem54.name],
            solutionImageNames: [R.image.questionSolution54.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 55,
            problemImageNames: [R.image.questionProblem55.name],
            solutionImageNames: [R.image.questionSolution55.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 56,
            problemImageNames: [R.image.questionProblem56.name],
            solutionImageNames: [R.image.questionSolution56.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 57,
            problemImageNames: [R.image.questionProblem57.name],
            solutionImageNames: [R.image.questionSolution57.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 58,
            problemImageNames: [R.image.questionProblem58.name],
            solutionImageNames: [R.image.questionSolution58.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 59,
            problemImageNames: [R.image.questionProblem59.name],
            solutionImageNames: [R.image.questionSolution59.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 60,
            problemImageNames: [R.image.questionProblem60.name],
            solutionImageNames: [R.image.questionSolution60.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 61,
            problemImageNames: [R.image.questionProblem61.name],
            solutionImageNames: [R.image.questionSolution61.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 62,
            problemImageNames: [R.image.questionProblem62.name],
            solutionImageNames: [R.image.questionSolution62.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 63,
            problemImageNames: [R.image.questionProblem63.name],
            solutionImageNames: [R.image.questionSolution63.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 64,
            problemImageNames: [R.image.questionProblem64.name],
            solutionImageNames: [R.image.questionSolution64.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 65,
            problemImageNames: [R.image.questionProblem65.name],
            solutionImageNames: [R.image.questionSolution65.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 66,
            problemImageNames: [R.image.questionProblem66.name],
            solutionImageNames: [
                R.image.questionSolution66Image1.name,
                R.image.questionSolution66Image2.name,
            ],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 67,
            problemImageNames: [R.image.questionProblem67.name],
            solutionImageNames: [R.image.questionSolution67.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 68,
            problemImageNames: [R.image.questionProblem68.name],
            solutionImageNames: [R.image.questionSolution68.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 69,
            problemImageNames: [R.image.questionProblem69.name],
            solutionImageNames: [R.image.questionSolution69.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 70,
            problemImageNames: [R.image.questionProblem70.name],
            solutionImageNames: [R.image.questionSolution70.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 71,
            problemImageNames: [R.image.questionProblem71.name],
            solutionImageNames: [R.image.questionSolution71.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 72,
            problemImageNames: [R.image.questionProblem72.name],
            solutionImageNames: [R.image.questionSolution72.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 73,
            problemImageNames: [R.image.questionProblem73.name],
            solutionImageNames: [R.image.questionSolution73.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 74,
            problemImageNames: [R.image.questionProblem74.name],
            solutionImageNames: [R.image.questionSolution74.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 75,
            problemImageNames: [R.image.questionProblem75.name],
            solutionImageNames: [R.image.questionSolution75.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 76,
            problemImageNames: [R.image.questionProblem76.name],
            solutionImageNames: [R.image.questionSolution76.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 77,
            problemImageNames: [R.image.questionProblem77.name],
            solutionImageNames: [R.image.questionSolution77.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 78,
            problemImageNames: [R.image.questionProblem78.name],
            solutionImageNames: [R.image.questionSolution78.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 79,
            problemImageNames: [R.image.questionProblem79.name],
            solutionImageNames: [R.image.questionSolution79.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 80,
            problemImageNames: [R.image.questionProblem80.name],
            solutionImageNames: [
                R.image.questionSolution80Image1.name,
                R.image.questionSolution80Image2.name,
            ],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 81,
            problemImageNames: [R.image.questionProblem81.name],
            solutionImageNames: [R.image.questionSolution81.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 82,
            problemImageNames: [R.image.questionProblem82.name],
            solutionImageNames: [R.image.questionSolution82.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 83,
            problemImageNames: [R.image.questionProblem83.name],
            solutionImageNames: [R.image.questionSolution83.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 84,
            problemImageNames: [R.image.questionProblem84.name],
            solutionImageNames: [R.image.questionSolution84.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 85,
            problemImageNames: [R.image.questionProblem85.name],
            solutionImageNames: [R.image.questionSolution85.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 86,
            problemImageNames: [R.image.questionProblem86.name],
            solutionImageNames: [R.image.questionSolution86.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 87,
            problemImageNames: [R.image.questionProblem87.name],
            solutionImageNames: [R.image.questionSolution87.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 88,
            problemImageNames: [R.image.questionProblem88.name],
            solutionImageNames: [R.image.questionSolution88.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 89,
            problemImageNames: [R.image.questionProblem89.name],
            solutionImageNames: [
                R.image.questionSolution89Image1.name,
                R.image.questionSolution89Image2.name,
                R.image.questionSolution89Image3.name,
                R.image.questionSolution89Image4.name,
            ],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 90,
            problemImageNames: [R.image.questionProblem90.name],
            solutionImageNames: [R.image.questionSolution90.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 91,
            problemImageNames: [R.image.questionProblem91.name],
            solutionImageNames: [R.image.questionSolution91.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 92,
            problemImageNames: [R.image.questionProblem92.name],
            solutionImageNames: [R.image.questionSolution92.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 93,
            problemImageNames: [R.image.questionProblem93.name],
            solutionImageNames: [R.image.questionSolution93.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 94,
            problemImageNames: [R.image.questionProblem94.name],
            solutionImageNames: [R.image.questionSolution94.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 95,
            problemImageNames: [R.image.questionProblem95.name],
            solutionImageNames: [R.image.questionSolution95.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 96,
            problemImageNames: [R.image.questionProblem96.name],
            solutionImageNames: [R.image.questionSolution96.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 97,
            problemImageNames: [R.image.questionProblem97.name],
            solutionImageNames: [R.image.questionSolution97.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 98,
            problemImageNames: [R.image.questionProblem98.name],
            solutionImageNames: [R.image.questionSolution98.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 99,
            problemImageNames: [R.image.questionProblem99.name],
            solutionImageNames: [R.image.questionSolution99.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        ),
        Question(
            id: 100,
            problemImageNames: [R.image.questionProblem100.name],
            solutionImageNames: [R.image.questionSolution100.name],
            references: [
                "https://doi.org/10.1002/jlac.19576060109"
            ]
        )
    ]
}
