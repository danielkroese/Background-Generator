import XCTest
import Combine

final class GenerateImageViewModelTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions.removeAll()
        
        super.tearDown()
    }
    
    func test_tappedGenerateImage_withSuccess_setsImage() {
        let sut = createSut()
        
        let expectation = XCTestExpectation(description: "sets image")
        
        sut.$generatedImage
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.tappedGenerateImage()
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sut.errorText)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedGenerateImage_withError_setsErrorText() {
        let mockImageGenerator = MockImageGenerator()
        let sut = createSut(imageGenerator: mockImageGenerator)
        
        mockImageGenerator.generateImageError = ImageGeneratingError.incompleteQuery
        
        let expectation = XCTestExpectation(description: "sets error")
        
        sut.$errorText
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.tappedGenerateImage()
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sut.generatedImage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_tappedGenerateImage_togglesIsLoading() {
        let sut = createSut()
        
        let expectation = XCTestExpectation(description: "toggles isLoading")
        expectation.expectedFulfillmentCount = 2
        
        sut.$isLoading
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.tappedGenerateImage()
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertFalse(sut.isLoading)
    }
}

// MARK: - Test helpers
extension GenerateImageViewModelTests {
    private func createSut(
        imageGenerator: ImageGenerating = MockImageGenerator()
    ) -> GenerateImageViewModel {
        GenerateImageViewModel(imageGenerator: imageGenerator)
    }
}
