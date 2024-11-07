import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            // Define the icons list directly as IconData items.
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the Dock used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200], // Fixed grey color for the container
      ),
      // Remove width constraint for dynamic resizing
      // padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.asMap().entries.map((entry) {
          int index = entry.key;
          T item = entry.value;
          return DraggableDockItem(
            icon: item as IconData,
            onDrop: (newIndex) {
              setState(() {
                // Move the item to the new position
                _items.removeAt(index);
                _items.insert(newIndex, item);
              });
            },
            currentIndex: index,
          );
        }).toList(),
      ),
    );
  }
}

/// Draggable dock item with drag target functionality.
class DraggableDockItem extends StatefulWidget {
  const DraggableDockItem({
    super.key,
    required this.icon,
    required this.onDrop,
    required this.currentIndex,
  });

  final IconData icon;
  final void Function(int newIndex)
      onDrop; // Callback to update the index when dropped
  final int currentIndex;

  @override
  _DraggableDockItemState createState() => _DraggableDockItemState();
}

class _DraggableDockItemState extends State<DraggableDockItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: widget.currentIndex, // Pass the index of the item being dragged
      child: DragTarget<int>(
        onAccept: (newIndex) {
          widget.onDrop(newIndex); // Move the icon to the new position
        },
        builder: (context, acceptedItems, rejectedItems) {
          return MouseRegion(
            onEnter: (_) {
              setState(() {
                isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                isHovered = false;
              });
            },
            child: Container(
              // Use a simple Container
              width: 60, // Fixed width for the container
              height: 60, // Fixed height for the container
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors
                    .primaries[widget.icon.hashCode % Colors.primaries.length],
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  size: 40, // Resize the icon size
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          // Use a simple Container
          width: 60,
          height: 60,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors
                .primaries[widget.icon.hashCode % Colors.primaries.length],
          ),
          child: Center(
            child: Icon(
              widget.icon,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
      childWhenDragging: Container(), // Hide the icon when dragging
    );
  }
}
