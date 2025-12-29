import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_controller.dart';
import '../../core/config/app_constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _mealController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _mealController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _parseMeal() {
    final controller = context.read<ChatController>();
    controller.parseMeal(_mealController.text);
  }

  Future<void> _saveMeal() async {
    final controller = context.read<ChatController>();
    final description = _descriptionController.text.isEmpty
        ? _mealController.text
        : _descriptionController.text;

    final success = await controller.saveMeal(description);

    if (success && mounted) {
      _mealController.clear();
      _descriptionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal logged successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Chat'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<ChatController>(
            builder: (context, controller, child) {
              if (controller.hasMatches) {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => controller.clear(),
                  tooltip: 'Clear',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<ChatController>(
        builder: (context, controller, child) {
          if (!controller.hasMatches && !controller.isParsing) {
            return _buildInputView(controller);
          } else if (controller.isParsing) {
            return _buildLoadingView();
          } else {
            return _buildResultsView(controller);
          }
        },
      ),
    );
  }

  Widget _buildInputView(ChatController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Log your meal',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Describe what you ate in natural language',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Examples
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.amber[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Examples',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildExample('2 slices of pizza and a soda'),
                  _buildExample('turkey sandwich with chips'),
                  _buildExample('oatmeal and a banana for breakfast'),
                  _buildExample('grilled chicken salad with dressing'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Input field
          TextField(
            controller: _mealController,
            maxLines: 3,
            maxLength: AppConstants.maxMealTextLength,
            decoration: const InputDecoration(
              labelText: 'Meal description',
              hintText: 'e.g., 2 eggs, toast, and coffee',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.restaurant),
            ),
            onSubmitted: (_) => _parseMeal(),
          ),
          const SizedBox(height: 16),

          // Error message
          if (controller.errorMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.errorMessage,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                ],
              ),
            ),
          if (controller.errorMessage.isNotEmpty) const SizedBox(height: 16),

          // Parse button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _parseMeal,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Parse Meal'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Parsing meal with AI...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(ChatController controller) {
    final totalCalories = controller.matches
        .fold<int>(0, (sum, match) => sum + match.totalCalories);

    return Column(
      children: [
        // Summary header
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${controller.matches.length} items found',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Review and confirm',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$totalCalories',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const Text(
                    'total calories',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Items list
        Expanded(
          child: ListView.builder(
            itemCount: controller.matches.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final match = controller.matches[index];
              return _buildMatchCard(controller, match, index);
            },
          ),
        ),

        // Save button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Meal name (optional)',
                  hintText: _mealController.text,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isSaving ? null : _saveMeal,
                  icon: controller.isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(controller.isSaving ? 'Saving...' : 'Save Meal'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatchCard(ChatController controller, MealMatch match, int index) {
    final hasMatch = match.matchedFood != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with quantity controls
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.parsedItem.query,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: match.parsedItem.quantity > 1
                          ? () => controller.updateQuantity(
                              index, match.parsedItem.quantity - 1)
                          : null,
                      iconSize: 20,
                    ),
                    Text(
                      '${match.parsedItem.quantity}x',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => controller.updateQuantity(
                          index, match.parsedItem.quantity + 1),
                      iconSize: 20,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => controller.removeMatch(index),
                      iconSize: 20,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),

            if (hasMatch) ...[
              const Divider(),
              // Matched food
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.matchedFood!.description,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          match.matchedFood!.portion,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${match.totalCalories}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Text(
                        'cal',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              // Alternative matches
              if (match.alternativeMatches.isNotEmpty) ...[
                const SizedBox(height: 8),
                ExpansionTile(
                  title: const Text(
                    'See alternatives',
                    style: TextStyle(fontSize: 12),
                  ),
                  dense: true,
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  children: match.alternativeMatches.map((alt) {
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(alt.description),
                      subtitle: Text(alt.portion),
                      trailing: Text(
                        '${alt.calories} cal',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => controller.updateMatchedFood(index, alt),
                    );
                  }).toList(),
                ),
              ],
            ] else ...[
              const Divider(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'No match found in database',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
