//
//  TaskViewModelTests.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import XCTest
import CoreData
@testable import ToDoListSwiftUI

final class TaskViewModelTests: XCTestCase {
    var viewModel: TaskViewModel!
    var mockContext: NSManagedObjectContext!

    @MainActor override func setUpWithError() throws {
        let container = NSPersistentContainer(name: "Model")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // Используем in-memory хранилище для тестов
        container.persistentStoreDescriptions = [description]

        let expectation = XCTestExpectation(description: "Load persistent stores")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error, "Ошибка инициализации CoreData")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0) // Ждём завершения загрузки
        mockContext = container.viewContext
        XCTAssertNotNil(mockContext, "Контекст не инициализирован")
        viewModel = TaskViewModel(context: mockContext)
        XCTAssertNotNil(viewModel, "ViewModel не инициализирован")
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockContext = nil
    }

    func testAddTask() async throws {
        let initialCount = try mockContext.count(for: TaskItem.fetchRequest())
        await viewModel.addTask(title: "Test Task", description: "Test Description")
        let newCount = try mockContext.count(for: TaskItem.fetchRequest())
        XCTAssertEqual(newCount, initialCount + 1, "Задача не добавлена")
    }

    func testEditTask() async throws {
        let task = TaskItem(context: mockContext)
        task.title = "Old Title"
        task.desc = "Old Description"
        task.created = Date()

        await viewModel.editTask(task, title: "New Title", description: "New Description")
        XCTAssertEqual(task.title, "New Title")
        XCTAssertEqual(task.desc, "New Description")
    }

    func testDeleteTask() async throws {
        let task = TaskItem(context: mockContext)
        task.title = "Test Task"
        task.desc = "Test Description"
        task.created = Date()

        await viewModel.deleteTask(task)
        XCTAssertFalse(mockContext.registeredObjects.contains(task), "Задача не удалена")
    }

    func testToggleCompletion() async throws {
        let task = TaskItem(context: mockContext)
        task.isCompleted = false

        await viewModel.toggleCompletion(task)
        XCTAssertTrue(task.isCompleted, "Статус выполнения задачи не изменён")
    }
}
