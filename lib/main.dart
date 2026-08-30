import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const RobotVaultApp());
}

class RobotVaultApp extends StatelessWidget {
  const RobotVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Protocol Vault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        primaryColor: const Color(0xFF2563EB),
        cardColor: const Color(0xFF151C2E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF2563EB),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const RoutineScreen(),
    const GymTrackerScreen(),
    const EnglishCoachScreen(),
    const ProtocolScoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F19),
        elevation: 0,
        title: const Text(
          '⚡ ROBOT PROTOCOL',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2, fontSize: 18),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF111827),
        selectedItemColor: const Color(0xFF38BDF8),
        unselectedItemColor: const Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Routine'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'PPL Gym'),
          BottomNavigationBarItem(icon: Icon(Icons.record_voice_over), label: 'English'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Discipline'),
        ],
      ),
    );
  }
}

// 1. ROUTINE SCREEN
class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF151C2E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🎯 Non-Negotiable Schedule', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                '• 06:00 AM: Wake Up + 500ml Water + Sunlight\n'
                '• 06:30 AM - 08:30 AM: Deep Study Block\n'
                '• 03:30 PM - 05:30 PM: Problem Solving & PYQs\n'
                '• Evening: PPL Gym Session + 6 Whole Eggs\n'
                '• Night: Protocol Lock & Cold Sleep Routine',
                style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 2. GYM TRACKER SCREEN
class GymTrackerScreen extends StatefulWidget {
  const GymTrackerScreen({super.key});

  @override
  State<GymTrackerScreen> createState() => _GymTrackerScreenState();
}

class _GymTrackerScreenState extends State<GymTrackerScreen> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  String _selectedExercise = 'Incline DB Press';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _logs = prefs.getStringList('gym_logs') ?? [];
    });
  }

  void _saveLog() async {
    if (_weightController.text.isEmpty || _repsController.text.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final newEntry = '$_selectedExercise: ${_weightController.text} kg × ${_repsController.text} reps';
    _logs.insert(0, newEntry);
    await prefs.setStringList('gym_logs', _logs);
    _weightController.clear();
    _repsController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF151C2E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('⚡ Log Lift (Progressive Overload)', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedExercise,
                dropdownColor: const Color(0xFF151C2E),
                items: ['Incline DB Press', 'Flat Bench Press', 'Lateral Raises', 'Lat Pulldowns', 'Barbell Curls', 'Barbell Squats']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedExercise = val!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _repsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Reps', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _saveLog,
                  child: const Text('Save Set', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('📊 Workout History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ..._logs.map((l) => Card(
          color: const Color(0xFF111827),
          child: ListTile(title: Text(l, style: const TextStyle(fontSize: 14))),
        )),
      ],
    );
  }
}

// 3. ENGLISH COACH SCREEN
class EnglishCoachScreen extends StatelessWidget {
  const EnglishCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildScriptCard('🏋️ Gym Work-in', 'Hey, mind if I work in with you between your sets?'),
        const SizedBox(height: 12),
        _buildScriptCard('🤝 Workplace / Site Update', 'We had a minor site delay, but I’ve already adjusted coordinates to stay on schedule.'),
        const SizedBox(height: 12),
        _buildScriptCard('🛡️ Firm Boundary', 'I won’t be able to take that on right now as my schedule is fully locked.'),
      ],
    );
  }

  Widget _buildScriptCard(String contextTitle, String script) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contextTitle, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('"$script"', style: const TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}

// 4. PROTOCOL SCORE SCREEN
class ProtocolScoreScreen extends StatefulWidget {
  const ProtocolScoreScreen({super.key});

  @override
  State<ProtocolScoreScreen> createState() => _ProtocolScoreScreenState();
}

class _ProtocolScoreScreenState extends State<ProtocolScoreScreen> {
  bool _t1 = false, _t2 = false, _t3 = false, _t4 = false;

  @override
  Widget build(BuildContext context) {
    int score = (_t1 ? 1 : 0) + (_t2 ? 1 : 0) + (_t3 ? 1 : 0) + (_t4 ? 1 : 0);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF151C2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discipline Score:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('$score / 4', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF38BDF8))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Morning Deep Study Block Completed'),
            value: _t1,
            onChanged: (v) => setState(() => _t1 = v!),
          ),
          CheckboxListTile(
            title: const Text('PPL Workout / Sprint Done'),
            value: _t2,
            onChanged: (v) => setState(() => _t2 = v!),
          ),
          CheckboxListTile(
            title: const Text('Protein & Water Goals Met'),
            value: _t3,
            onChanged: (v) => setState(() => _t3 = v!),
          ),
          CheckboxListTile(
            title: const Text('Zero Social Media / Gemini Detox Maintained'),
            value: _t4,
            onChanged: (v) => setState(() => _t4 = v!),
          ),
        ],
      ),
    );
  }
}
