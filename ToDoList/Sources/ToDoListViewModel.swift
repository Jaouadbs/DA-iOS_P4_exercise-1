import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    private var allItems : [ToDoItem ] = []  // Jaouad : Pour stocker tous les items

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.allItems = repository.loadToDoItems() // Jaouad :Pour charger toutes taches enregistrées dans le repository
        self.toDoItems = allItems
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    ///  Jaouad : Suppression du didSet car incompatible avec le filtre applyFilter
    @Published var toDoItems: [ToDoItem] = [] /*{
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }*/

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        allItems.append(item)
        repository.saveToDoItems(allItems)
        applyFilter(at: currentFilterIndex)
    }

    /// Toggles the completion status of a to-do item.
    /// Jaouad: on cherche la position de la tâche item dans la liste allItems et  avec isDone.toggle, on inverse son état
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            allItems[index].isDone.toggle()
            repository.saveToDoItems(allItems) // Jaouad :
            applyFilter(at: currentFilterIndex) // Jaouad :
        }
    }

    /// Removes a to-do item from the list.
    ///Jaouad: suppression de l'item grace à l'id, sauvgarde nouvelle liste et on applique le filtre
    func removeTodoItem(_ item: ToDoItem) {
        allItems.removeAll { $0.id == item.id }
        repository.saveToDoItems(allItems)
        applyFilter(at: currentFilterIndex)
    }
    // Jaouad: proprieté pour le suivi de filte, par défaut il est à All.
    private var currentFilterIndex = 0

    /// Apply the filter to update the list.
    /// Jaouad : on enregistre le filtre selectionné puis on affiche la liste en fonction de filtre.
    func applyFilter(at index: Int) {
        // TODO: - Implement the logic for filtering

       currentFilterIndex = index //

       switch index {
       case 0: // on affiche tous All
           toDoItems = allItems
       case 1: // on affiche uniquement les taches terminées Done
           toDoItems = allItems.filter { $0.isDone }
       case 2: // on affiche uniquement les taches non terminées Not Done
           toDoItems = allItems.filter { !$0.isDone }
       default: // on affiche tous All
           toDoItems = allItems
       }
    }
}
