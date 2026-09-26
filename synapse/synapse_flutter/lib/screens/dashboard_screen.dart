import 'package:flutter/material.dart';
import 'dart:async';
import '../client.dart';
import 'package:synapse_client/synapse_client.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  
  List<OrchestrationTask> _tasks = [];
  bool _isLoading = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    // Poll for updates every 3 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _fetchTasks();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _promptController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  Future<void> _fetchTasks() async {
    try {
      final tasks = await client.orchestration.listTasks(50, 0);
      if (mounted) {
        setState(() {
          _tasks = tasks;
        });
      }
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
    }
  }

  Future<void> _submitTask() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final codeContext = _contextController.text.trim();
      await client.orchestration.orchestrate(
        prompt,
        codeContext.isEmpty ? null : codeContext,
      );
      _promptController.clear();
      _contextController.clear();
      await _fetchTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 Synapse Orchestration', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left Panel: Input
            Expanded(
              flex: 1,
              child: _buildInputPanel(),
            ),
            const SizedBox(width: 16),
            // Right Panel: Task List
            Expanded(
              flex: 2,
              child: _buildTaskPanel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _promptController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'What should the AI do? (e.g. "Create a hello world python file")',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black26,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contextController,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Optional Code Context...',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black26,
            ),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Execute Task', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Task Monitor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _fetchTasks,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text('No tasks yet.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return _buildTaskCard(task);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(OrchestrationTask task) {
    Color statusColor;
    switch (task.status) {
      case 'complete':
        statusColor = Colors.green;
        break;
      case 'failed':
        statusColor = Colors.red;
        break;
      case 'calling_gemini':
      case 'parsing':
      case 'dispatching':
      case 'running':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      color: Colors.black26,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          task.prompt,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Skill: ${task.skillName ?? "pending"}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            task.status.toUpperCase(),
            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.errorMessage != null) ...[
                  const Text('Error:', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  Text(task.errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: 8),
                ],
                if (task.skillInput != null) ...[
                  const Text('Input:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.black45,
                    child: Text(
                      _prettyJson(task.skillInput!),
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (task.skillOutput != null) ...[
                  const Text('Output:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.black45,
                    child: SelectableText(
                      _prettyJson(task.skillOutput!),
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _prettyJson(String input) {
    try {
      final dynamic parsed = jsonDecode(input);
      return const JsonEncoder.withIndent('  ').convert(parsed);
    } catch (e) {
      return input;
    }
  }
}
